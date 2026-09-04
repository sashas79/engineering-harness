# Engineering Harness v0.3.0

This repository is the centrally governed source/distribution layout for Engineering Harness v0.3.0.

## Repository model

```text
engineering-harness/
├── harness/harness.yaml       release metadata
├── schemas/                   normative Draft 2020-12 contracts
├── controls/                  Harness control definitions
├── profiles/                  centrally governed profiles
├── technologies/              recognised technology catalogue
├── gates/                     human-gate definitions
├── workflows/                 authoritative workflow contracts
├── standards/                 minimum standards used by the release
├── annexes/                   harness-v1 vectors and definitive contract tests
├── project-template/          clean engineered-project skeleton
├── project-pack-template/     human-input skeleton
├── adapters/                  execution adapters
└── harness-init.sh            release installer + project initializer
```

The deterministic core implementation is merged separately; see `CORE-INTEGRATION.md`.

## Initialisation

The initializer performs the distribution/setup work that precedes `bootstrap_repository`:

```bash
bash ./harness-init.sh <target-project> [version] [adapter] <harness-root>
```

Example:

```bash
bash ./harness-init.sh ecommerce-platform v0.3.0 claude-code "$HOME/.engineering-harness"
```

It installs the exact Harness release under:

```text
<harness-root>/releases/v0.3.0/
```

and creates the new project with:

```text
.engineering-harness-template
.engineering-harness-adapter
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

It does **not** complete project-specific inputs and does **not** run `bootstrap_repository`.

After initialisation, the project team completes `/project-pack`. The deterministic core then derives `PROJECT_INPUT_READY`, after which `bootstrap_repository --project-root ... --harness-root ...` may materialise `/engineering`.

## Normative authority

`docs/v0.3.0/BRS.md`, `schemas/**`, and `annexes/**` are supplied normative contracts. Development implements against them; development does not generate or redefine them.
