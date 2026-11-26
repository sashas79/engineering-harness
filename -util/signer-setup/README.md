# Signer setup

`setup-signers.sh` reads convention table rows, generates the scripts, and runs
key generation followed by enrolment. All selected private keys are generated
on the machine where you run it. Sasha is the sample anchor.

Requirements: Bash 3.2 or newer, Python 3.8 or newer, OpenSSH `ssh-keygen`, and
a project with an executable `./harness` that supports `check_signers` and
`enrol_signer`. Run from an interactive operator terminal. No packages need
installing beyond those tools.

## Run everything

Extract this package, edit `signers.example.csv` if needed, then run:

```bash
bash setup-signers.sh \
  --input signers.example.csv \
  --project-root /path/to/jev-router \
  --output ./signer-setup-generated
```

The output directory must be new. The master first generates the scripts,
then creates every selected key, enrols the anchor, enrols the other signers,
and checks the final chain. It preserves passphrase prompts and asks you to
type `YES` before each enrolment. Answer those prompts yourself.

To use the same four built-in sample rows, omit `--input`:

```bash
bash setup-signers.sh --project-root /path/to/jev-router
```

To use the included Markdown table, pass `--input signers.example.md`.
Markdown input must contain just the table, without headings or surrounding
prose. Paths can be wrapped in backticks.

## Convention rows

| Column | Meaning |
| --- | --- |
| `signer` | Optional display name. |
| `identity` | Exact identity from the Project Pack. Lowercase; letters, digits, dots, underscores and hyphens. |
| `private_key` | Private key path. `~/`, `$HOME/`, `${HOME}/` and absolute paths are supported. Relative paths start at the project root. |
| `public_key` | Exported public key path, ending in `.pub`. Relative paths start at `<output>/public-keys`, or `--public-dir` when supplied. |
| `mode` | `anchor` or `member`. Include exactly one anchor in the complete input. |
| `authorities` | Optional reference text. Use `;` between authorities. The harness reads authority assignments from the Project Pack; this script does not assign them. |

The sample rows preserve these mappings:

| Signer | Identity | Private key | Public export | Mode | Authorities |
| --- | --- | --- | --- | --- | --- |
| Sasha | sasha | `~/.ssh/jev-router-sasha` | `Sasha.pub` | anchor | product_domain |
| Chris | chris | `~/.ssh/jev-router-chris` | `chris.pub` | member | architecture |
| Wayne | wayne | `~/.ssh/jev-router-wayne` | `wayne.pub` | member | security_platform |
| Petre | petre | `~/.ssh/jev-router-petre` | `petre.pub` | member | engineering;release |

Use one row per identity. Petre's two authorities use the same key. You may
replace the sample identities and paths with your own Project Pack identities.
Enrolment uses these command shapes:

```bash
# Anchor: the key being enrolled signs its own anchor record.
./harness enrol_signer --project-root . --identity sasha --key /path/to/anchor-key

# Member: the anchor signs the enrolment of the member's public key.
./harness enrol_signer --project-root . --identity chris --key /path/to/anchor-key --public-key /path/to/chris.pub
```

## Generate scripts for review

```bash
bash setup-signers.sh \
  --input signers.example.csv \
  --project-root /path/to/jev-router \
  --output ./signer-setup-generated \
  --generate-only
```

This writes scripts without generating keys or calling the harness. Then run:

```bash
bash ./signer-setup-generated/run-all.sh
```

The generated directory contains:

```text
generate-signer-key.sh
enrol-signers.sh
01-sasha-generate.sh
01-sasha-enrol.sh
02-chris-generate.sh
02-chris-enrol.sh
03-wayne-generate.sh
03-wayne-enrol.sh
04-petre-generate.sh
04-petre-enrol.sh
run-all.sh
signers.resolved.csv
public-keys/                 created when keys are generated
```

The helpers are configurable versions of the earlier scripts, embedded in
the master. They do not require the previous downloads. The per-signer scripts
provide the identity, paths, mode and project root. Existing copies of the
earlier scripts are not changed. Generated scripts contain absolute paths;
regenerate them if you move the project or change machines.

## Selection and separate phases

```bash
# Generate and enrol only Sasha and Chris.
bash setup-signers.sh --project-root /path/to/project --only sasha,chris --output ./setup-selected

# Generate only Chris's key; enrolment can follow later.
bash setup-signers.sh --project-root /path/to/project --only chris --phase keys --output ./setup-chris

# Once all keys exist, run just enrolment from an existing generated plan.
bash ./signer-setup-generated/run-all.sh enrol

# Or create a new plan for enrolment using existing keys and public exports.
bash setup-signers.sh --input signers.example.csv --project-root /path/to/project --public-dir /path/to/public-keys --phase enrol --output ./setup-enrol
```

`--only` filters the input; it does not silently add the anchor. When enrolling
members without selecting the anchor, its key must already exist and the
anchor must already be enrolled. Keep the anchor row in the input so its
signing key is known. The input order does not affect anchor-first enrolment.

Use `--sample` to print the built-in CSV; use `--help` for all arguments.

## Existing files and failures

Before creating any keys, the runner checks every selected private key,
adjacent `.pub` and public export destination. If any exists, it stops without
overwriting it. Private keys stay outside the generated scripts directory;
new files and directories use owner-only permissions.

The runner stops at the first failed command or declined confirmation. Earlier
keys or enrolments remain in place. It does not delete keys, roll back signed
records, skip existing enrolments, or replace an existing anchor. To continue
after a partial enrolment, inspect `check_signers` and run only the remaining
individual `*-enrol.sh` scripts. Re-running `all` after key generation will stop
because the keys already exist. Every nonzero `check_signers` result stops
enrolment, including before creating the anchor; resolve that result before
continuing.

Passphrases are read by OpenSSH and are not stored by these scripts. This
package contains no private keys. Machine-local trust remains the harness's
own operator workflow; this script does not run `trust_signers`.

## Validation

The master and generated scripts pass Bash syntax checks. The full four-signer
flow was exercised in an isolated pseudo-terminal using real encrypted
Ed25519 keys and a simulated harness. Checks covered CSV and Markdown input,
anchor ordering, command arguments, selection, paths containing spaces and
shell punctuation, overwrite refusal, rejected input, operator cancellation,
and propagation of a harness failure.

The live harness implementation was not available in this workspace. Its
signer-chain persistence, authority enforcement, signing prompts and trust
handling still need verification when you run this against your project.
