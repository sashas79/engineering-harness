# Engineering Harness v0.4.0

This repository is the centrally governed source/distribution layout for Engineering Harness v0.4.0.

## Repository model

```text
engineering-harness/
├── harness/harness.yaml       release metadata
├── schemas/                   normative Draft 2020-12 contracts
├── controls/                  Harness control definitions
├── profiles/                  centrally governed profiles
├── technologies/              recognised technology catalogue
├── gates/                     human-gate definitions
├── workflows/                 authoritative workflow contracts (bootstrap, execution, maintenance)
├── standards/                 minimum standards used by the release
├── annexes/                   harness-v1 vectors, signature vectors and definitive contract tests
├── project-template/          clean engineered-project skeleton
├── project-pack-template/     human-input skeleton
├── adapters/                  adapter manifest, shared source text, overlays for Claude Code, Codex and Copilot,
│                              and the v0.3.0 adapter files that adoption recognises
├── docs/v0.4.0/               BRS 2.0 and its design documents
└── harness-core-<platform>    the compiled core (macOS arm64 and x64, Linux x64, Windows x64)
```

The deterministic core implementation is merged separately; see `CORE-INTEGRATION.md`.

## Initialisation

The initializer performs the distribution/setup work that precedes `bootstrap_repository`:

```bash
./harness-core init --target <target-project> --version v0.4.0 [--adapters <list>] [--source <local-checkout> | --repository <git-url>]
```

Example:

```bash
./harness-core init --target ecommerce-platform --version v0.4.0 --adapters claude-code,codex,copilot
```

`--version v0.4.0` is needed: the default of `init` is still v0.3.0 and refuses a v0.4.0 release with
`INIT_VERSION_MISMATCH`. `--adapters` takes any subset of `claude-code`, `codex` and `copilot`, or `none`;
without `--adapter` and `--adapters` the adapter `claude-code` is installed.

It installs the exact Harness release under:

```text
<harness-root>/releases/v0.4.0/
```

and creates the new project with:

```text
.engineering-harness-template
.engineering-harness-adapters
AGENTS.md
harness
harness.cmd
project-pack/
spec/
architecture/
engineering/
ai/
work/
baselines/
evidence/
src/
tests/
infra/
```

plus the files of the chosen adapters. After initialisation, the project team completes `project-pack/`. The
deterministic core then derives `PROJECT_INPUT_READY`, after which the agent command `bootstrap` eventually creates
the `engineering/` directory content.

## Normative authority

`docs/v0.4.0/BRS.md` (BRS 2.0), `schemas/**`, and `annexes/**` are supplied normative contracts. Development implements against them; development does not generate or redefine them.

# Harness Core

The deterministic core used to initialise, validate and operate project work under a governed lifecycle it enforces the approved release, checks project state, and exposes a direct CLI as well as adapter-driven workflows for Claude Code, OpenAI Codex CLI and GitHub Copilot CLI.

Use the Harness Core directly when you need precise lifecycle control and validation from the CLI. Use the adapter workflow (`bootstrap`, `execute`, `maintain`) when you want the core to operate behind a guided project experience in one of the three coding agents.

The core is the deterministic authority; the adapter is the user-facing interface.

## Packaged with bun into 4 platform targets

```bash
harness-core-macos-arm64
harness-core-macos-x64
harness-core-linux-x64
harness-core-win-x64.exe
```

## Runs as

### 1. Layout

The convention is one working directory holding the binary, the Harness root and the projects side by side.
The binary finds the Harness root by itself (BRS FR-034): `ENGINEERING_HARNESS_ROOT` when set, otherwise
the `_root` directory beside the binary. There is no `--harness-root` argument; passing one exits 64.

```text
work/
  harness-core          the compiled binary (copy or rename harness-core-<platform>)
  _root/                schema profile root, created by init;
                        releases are installed under _root/releases/<version>
  kpi-platform/         a project created by init
```

A checkout run (`node dist/src/cli.js ...`) has no binary location, so it needs
`export ENGINEERING_HARNESS_ROOT=/path/to/_root`.

The adapter files reach the core through the launcher `./harness` at the project root, which runs, in this order:
the command named by `ENGINEERING_HARNESS_CORE`, `harness-core` beside the project directory (the layout above),
`harness-core` on the search path. With none of them it exits 64.

### 2. Create a project

```bash
cd work
./harness-core init --target kpi-platform --version v0.4.0                                       # terminal questionnaire, adapter claude-code
./harness-core init --target kpi-platform --version v0.4.0 --adapters claude-code,codex,copilot  # all three agents
./harness-core init --target kpi-platform --version v0.4.0 --adapters none                       # no agent files
./harness-core init --target kpi-platform --version v0.4.0 --answers answers.json                # answers already known
./harness-core init --target kpi-platform --version v0.4.0 --no-questionnaire                    # agent flow: questionnaire returned as JSON
```

`init` installs the release into `_root/releases/v0.4.0` (first use), creates the project shell, overlays the
adapters and writes the Project Pack brief from the answers. The adapter files call the core only as `./harness`;
nothing has to be configured by hand. Every adapter shares these files:

- `AGENTS.md` (the instructions of all three agents; the Harness owns one marked block in it)
- `harness` and `harness.cmd` (the launcher)

and adds:

- `claude-code` (default):
  - `CLAUDE.md` (one line, importing `AGENTS.md`)
  - `.claude/commands/bootstrap.md`, `.claude/commands/execute.md`, `.claude/commands/maintain.md`
  - `.claude/settings.json` (deny rules and a `PreToolUse` hook)

- `codex`:
  - `.agents/skills/{bootstrap,execute,maintain}/SKILL.md` and `agents/openai.yaml`
  - `.codex/rules/engineering-harness.rules`
  - `.codex/hooks.json`

- `copilot`:
  - `.github/skills/{bootstrap,execute,maintain}/SKILL.md`
  - `.github/hooks/engineering-harness.json`

`.engineering-harness-adapters` records which adapters are installed. Change the set later, from your own terminal:

```bash
./harness-core adapter_add codex --project-root ./kpi-platform
./harness-core adapter_remove copilot --project-root ./kpi-platform
./harness-core adapter_sync --project-root ./kpi-platform       # reinstall the files of the installed set
./harness-core check_adapters --project-root ./kpi-platform     # compare installed files with the release
```

A file that exists and differs from the release is never overwritten unless you add `--replace-adapter-files`; the
files replaced are listed.

The result's `next_steps` repeat the steps below for the installed adapters.

### 3. Set up your signing key

Every human decision of v0.4.0 is a signed record. The agent never signs; you do, in your own terminal. Before the
first decision:

- have an SSH key that needs you for every signature: a passphrase-protected private key file that is not loaded
  into an SSH agent, an agent key added with per-use confirmation, or a hardware key. The core refuses a private
  key file without a passphrase (`GUARD_KEY_UNPROTECTED`) unless the key is hardware-backed. Key types: ed25519,
  ECDSA P-256/P-384/P-521, RSA of at least 2048 bits, and the `sk-` hardware types;
- have OpenSSH `ssh-keygen` 8.1 or later on the search path, and the public half of the key at `<key>.pub`
  (`ssh-keygen -y -f <key> > <key>.pub`);
- know your identity: the identity that `project-pack/project.yaml` assigns to the authority of each gate;
- enrol the key. The first enrolment writes the anchor of the signer chain and is signed with the key itself:

```bash
./harness-core enrol_signer --project-root ./kpi-platform --identity <identity> --key <path-to-key>
./harness-core check_signers --project-root ./kpi-platform --pretty
```

Enrol a second key kept apart from the first (`enrol_signer` again, with `--public-key <file.pub>` for the new
key); `check_signers` and `inspect_project` warn while only one key is enrolled. The first time on a machine, a
guarded command shows the signer anchor and asks you to type the last eight characters of its fingerprint; if the
anchor ever changes, the command is refused (`GUARD_ANCHOR_CHANGED`) until you run `trust_signers`.

Guarded commands (the decision commands and `adopt_release`, `enrol_signer`, `revoke_signer`, `trust_signers`,
`adapter_add`, `adapter_remove`, `adapter_sync`) run only in a terminal of yours: not in an agent session, and with a
controlling terminal.

### 4. Bootstrap

- Claude Code: open `kpi-platform/` in Claude Code, run `/bootstrap status` to see the deterministic state,
  then `/bootstrap` to perform the next permitted step. The first run completes `project-pack/` from the brief
  and stops at `PROJECT_INPUT_READY`; the following runs perform `bootstrap_repository` and the AI-assisted
  operations, one core-reported next action at a time.
- Codex CLI: start `codex` at the project root (it must be the Git root), trust the project so that `.codex/` loads,
  review the hook with `/hooks`, then run `$bootstrap status` and `$bootstrap`. In Codex the commands start with
  `$`, not `/`.
- Copilot CLI: start `copilot` at the project root (the Git root), trust the folder, then run `/bootstrap status`
  and `/bootstrap`.

Claude Code without a terminal (`claude -p`): in a folder you have never opened in Claude Code interactively,
Claude Code ignores the project's `permissions.allow` entries and says so on stderr ("this workspace has not been
trusted"), so every `./harness` call is denied. Open the project once interactively and accept the trust dialog,
or pass the rule yourself, for example `claude -p "/maintain status" --allowedTools "Bash(./harness *)"`. The deny
rules of `.claude/settings.json` and the hook apply either way. `maintain` writes a revised artefact set to a
directory outside the project: give it one with `--add-dir <dir>`.

Codex in VS Code (the IDE extension): the v0.4.0 acceptance run used it for one leg of a hand-over. It read the
skills (`$execute`) and called `./harness` with `--adapter codex`. Whether it loads the project's rules and hook,
and whether it sets the session marker, is not established. Before relying on it, ask it to run
`./harness approve_pending --project-root .` and check that it is refused before the core answers.

Copilot in VS Code: the same run used it for the last leg; it read the skills (`/execute`) and called `./harness`
with `--adapter copilot`. Whether it runs the repository hook is not established; make the same check.

At every `HUMAN_DECISION` stop the adapter shows the pending gate and the candidate digest. Record the decision
yourself, in your own terminal, then continue with the command:

```bash
./harness-core approve_pending --project-root ./kpi-platform --approver <identity> --key <path-to-key> --pretty
./harness-core reject_pending  --project-root ./kpi-platform --approver <identity> --key <path-to-key> --comment "<reason>"
```

`<identity>` is the identity assigned in `project-pack/project.yaml` to the gate's authority; the authority and
the candidate digest come from the core's own result. The core shows the gate and the subject digest, asks you to
type the last eight characters of the digest, and then starts OpenSSH, which asks for the key's passphrase. The
agents cannot run these commands: each adapter ships a hook that blocks them, Claude Code also denies them in
`.claude/settings.json`, and Codex also forbids them in its rules file. These controls are guardrails, not
authentication: the signature is.

### 5. Execute Work Items

When `/bootstrap status` reports `EXECUTION_READY`, bootstrap is complete and `execute` takes over:

- `execute status` lists every Work Item with its effective status, dependencies and readiness;
- `execute` runs the next runnable Work Item; `execute TASK-003` runs that one;
- the core, called by the adapter, keeps the run of the Work Item under `work/state/` (`start_task`,
  `record_task_progress`, `block_task`, `complete_task`); the adapter implements inside the Work Item's
  `repository_scope`, runs the verification controls where the repository has an executable check, and records
  the result;
- a Work Item with `human_gates` is reported and left to you; `execute` never records decisions and never
  commits unless asked.

Runtime state under `work/state/` is never part of a validation subject, so it cannot change the approved Work
definition or the lifecycle state.

Hand-over between agents: a run can be started in one agent, continued in another and finished in a third. When
a session stops before the Work Item is complete, the adapter records a note of what is done and what remains
(`record_task_progress`) and the paths changed so far; the next session, in any agent, resumes from the
repository alone. Every event of a run names the adapter that made it.

### 6. Maintain the project

After the Work Baseline exists, the project is in the maintenance regime: a change to the approved content needs a
change record. Use `maintain`:

- `maintain status` reports the change records, the revision in progress and the next action;
- `maintain <statement>` opens a change record from what you want changed and why; the adapter proposes the kind
  (`defect`, `follow_up`, `new_requirement`, `documentation`) and asks you when the statement does not decide it;
- `maintain` continues the revision in progress and stops at its gate;
- `maintain rework <instruction>` corrects a revision at `REWORK`; `maintain abandon CHG-id` abandons a change;
- `maintain register <statement>` registers a change that was made outside a run, for example a commit made
  without `execute`: the adapter lists the changed paths from the commits or paths you name, proposes the kind and
  the finished Work Items it touches for you to confirm, and records it with `open_change --registered`. Nothing
  is re-approved or re-executed. You then accept or reject it with `record_change_decision`.

Task dispositions (deferring, withdrawing or reinstating a Work Item) and the acceptance of a change made outside a
run are signed decisions of yours:

```bash
./harness-core record_task_decision --project-root ./kpi-platform --task TASK-003 --decision deferred --reason "<why>" --approver <identity> --key <path-to-key>
./harness-core record_change_decision --project-root ./kpi-platform --change CHG-0001 --decision accepted --approver <identity> --key <path-to-key>
```

### 7. Adopt a v0.3.0 project

A project governed by v0.3.0 keeps working under the v0.4.0 core for reading (`inspect_project`), but the v0.4.0
operations need the adoption of the v0.4.0 release. Adoption approves nothing again: the three baselines stay
current and keep the approval they have, marked as declared and not signed.

1. Under the v0.3.0 core, `inspect_project` must report no pending gate and no candidate awaiting a decision or a
   baseline. Finish any open gate first. Commit the project.
2. Swap the binary, keeping the path `work/harness-core` (the v0.3.0 adapter files call `../harness-core`):

   ```bash
   mv harness-core harness-core-v0.3.0
   cp <distribution>/harness-core-<platform> harness-core
   chmod +x harness-core
   ./harness-core inspect_project --project-root ./kpi-platform --pretty   # same conclusions, still v0.3.0
   ```

3. Adopt, from your own terminal, with your signing key and an identity that holds an authority in the Pack
   (it becomes the anchor of the signer chain):

   ```bash
   ./harness-core adopt_release --project-root ./kpi-platform --version v0.4.0 \
     --source <distribution-checkout> --key <path-to-key> --identity <identity> \
     --adapters claude-code,codex,copilot
   ```

   `--repository <git-url>` replaces `--source`; with neither, the release must already be under
   `_root/releases/v0.4.0`. The terminal shows what is carried and written before OpenSSH starts, which asks for
   the passphrase twice (the anchor, then the adoption record). An edited v0.3.0 adapter file stops the adoption
   with `ADAPTER_FILE_CONFLICT`; review it, then add `--replace-adapter-files`.
4. `./harness-core inspect_project --project-root ./kpi-platform --adapter claude-code --pretty` now reports
   v0.4.0, the maintenance regime and the baselines as `declared`. Enrol a second key.

Adoption is one way: the v0.3.0 core reads the project afterwards as unsupported (`PROV_UNSUPPORTED`, exit 5).

### 8. Direct CLI

Every command takes `--project-root` (`init` takes `--target`):

```bash
./harness-core inspect_project --project-root ./kpi-platform --pretty
./harness-core bootstrap_repository --project-root ./kpi-platform --pretty
./harness-core check_execution_readiness --project-root ./kpi-platform --pretty
./harness-core check_maintenance --project-root ./kpi-platform --pretty
./harness-core list_tasks --project-root ./kpi-platform --pretty
./harness-core --help
```

Run by hand, the operations that an adapter performs take `--operator` in place of `--adapter <identifier>`
(for example `start_task --task TASK-001 --operator`).

Exit status: 0 OK, 2 INCOMPLETE, 3 INVALID, 4 BLOCKED, 5 ERROR, 64 usage.

### 9. Troubleshooting

- `exit 64`, "harness_root is not configured"
  - Cause: a checkout run (`node dist/src/cli.js`) with `ENGINEERING_HARNESS_ROOT` unset; the compiled binary never hits this
  - Fix: `export ENGINEERING_HARNESS_ROOT=...`, or use the compiled binary

- `exit 64`, "Unknown option '--harness-root'"
  - Cause: the argument was removed in BRS 1.2
  - Fix: drop it; set the variable if the root is not beside the binary

- `exit 5`, `INIT_VERSION_MISMATCH` ("release VERSION is v0.4.0; requested v0.3.0")
  - Cause: `init` without `--version`; its default is still v0.3.0
  - Fix: add `--version v0.4.0`

- `exit 5`, `PROV_NOT_FOUND` (release `NOT_FOUND`)
  - Cause: no `_root/releases/v0.4.0` beside the binary: `init` has not run here yet, or the binary was moved away from its `_root`
  - Fix: run `init` (it creates `_root`), move `_root` with the binary, or set `ENGINEERING_HARNESS_ROOT`

- `exit 5`, `PROV_UNSUPPORTED`
  - Cause: a v0.4.0 operation on a project governed by v0.3.0, or the v0.3.0 core on an adopted project
  - Fix: adopt the project (section 7), or use the core of the release that governs it

- `exit 4`, `GUARD_AGENT_CONTEXT`, `GUARD_NOT_INTERACTIVE`
  - Cause: a decision or operator command run from an agent session (or with `--adapter`), or without a controlling terminal
  - Fix: run it yourself in a terminal that is not an agent session (a terminal opened by Claude Code or its IDE extension carries `CLAUDECODE` and counts as one)

- `GUARD_KEY_UNPROTECTED`, `SIGNER_NOT_ENROLLED`, `GUARD_ANCHOR_UNTRUSTED`, `GUARD_ANCHOR_CHANGED`
  - Cause: the key has no passphrase; the key is not enrolled for the approver; the signer anchor is not yet accepted on this machine; or it changed
  - Fix: use a protected key; `enrol_signer`; confirm the anchor fingerprint when asked; after a confirmed change, `trust_signers`

- Claude Code with `-p` reports "This command requires approval" for every `./harness` call
  - Cause: the folder has never been trusted in Claude Code, so the project's `permissions.allow` entry is ignored
  - Fix: open the project once in Claude Code and accept the trust dialog, or pass `--allowedTools "Bash(./harness *)"`

- A hook does not run, or the agent is not stopped at a decision command
  - Cause: Codex: the project's `.codex/` layer is not trusted or the hook is not reviewed; Copilot CLI: the folder is not trusted, or the session was not started at the Git root
  - Fix: trust the project or folder; in Codex review the hook with `/hooks`; start the agent at the project root

## Binary Download Workarounds (v0.4 and under)

### MacOS

      cp engineering-harness/harness-core-macos-arm64 harness-core
      chmod +x harness-core