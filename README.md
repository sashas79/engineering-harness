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

# Harness Core

The deterministic core used to initialise, validate and operate project work under a governed lifecycle it enforces the approved release, checks project state, and exposes a direct CLI as well as adapter-driven workflows for Claude Code and GitHub Copilot.

Use the Harness Core directly when you need precise lifecycle control and validation from the CLI. Use the adapter workflow (`/bootstrap`, `/execute`) when you want the core to operate behind a guided project experience in Claude Code or Copilot Chat.

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
  harness-core          the compiled binary (copy or rename out/harness-core-<platform>)
  _root/                schema profile root, created by init; 
                        releases are installed under _root/releases/<version>
  kpi-platform/         a project created by init
```

A checkout run (`node dist/src/cli.js ...`) has no binary location, so it needs
`export ENGINEERING_HARNESS_ROOT=/path/to/_root`.

### 2. Create a project

```bash
cd work
./harness-core init --target kpi-platform                       # terminal questionnaire, adapter claude-code
./harness-core init --target kpi-platform --adapter copilot     # same, for VS Code Copilot Chat
./harness-core init --target kpi-platform --answers answers.json    # answers already known
./harness-core init --target kpi-platform --no-questionnaire        # agent flow: questionnaire returned as JSON
```

`init` installs the release into `_root/releases/v0.3.0` (first use), creates the project shell, overlays the
adapter and writes the Project Pack brief from the answers. The adapter files carry the core command
(`../harness-core`) already filled in; nothing has to be configured by hand:

- `claude-code` (default):
  - `CLAUDE.md`
  - `.claude/commands/bootstrap.md`
  - `.claude/commands/execute.md`
  - `.claude/settings.json`

- `copilot`:
  - `.github/copilot-instructions.md`
  - `.github/prompts/bootstrap.prompt.md`
  - `.github/prompts/execute.prompt.md`
  - `.vscode/settings.json`

The result's `next_steps` repeat the steps below for the chosen adapter.

### 3. Bootstrap

- Claude Code: open `kpi-platform/` in Claude Code, run `/bootstrap status` to see the deterministic state,
  then `/bootstrap` to perform the next permitted step. The first run completes `project-pack/` from the brief
  and stops at `PROJECT_INPUT_READY`; the following runs perform `bootstrap_repository` and the AI-assisted
  operations, one core-reported next action at a time.
- Copilot: open `kpi-platform/` in VS Code, trust the workspace (the shipped `.vscode/settings.json` is
  applied only then), open Copilot Chat in agent mode and run `/bootstrap status`, then `/bootstrap`.

At every `HUMAN_DECISION` stop the adapter shows the pending gate and the candidate digest. Record the decision
yourself, then continue with `/bootstrap`:

```bash
./harness-core approve_pending --project-root ./kpi-platform --approver <identity> --pretty
./harness-core reject_pending  --project-root ./kpi-platform --approver <identity> --comment "<reason>"
```

`<identity>` is the identity assigned in `project-pack/project.yaml` to the gate's authority; the authority and
the candidate digest come from the core's own result. The adapters can never run these commands: Claude Code
denies them through `.claude/settings.json`, Copilot through the terminal auto-approve rules.

### 4. Execute Work Items

When `/bootstrap status` reports `EXECUTION_READY`, bootstrap is complete and `/execute` takes over:

- `/execute status` lists every task of `work/execution-graph.yaml` with its runtime state;
- `/execute` runs the next runnable task (all dependencies `done`); `/execute TASK-003` runs that task;
- the adapter writes `work/state/<TASK-id>.yaml` (`in_progress` → `done`, or `blocked`), implements inside the
  task's `repository_scope`, runs the task's verification controls where the repository has an executable check
  and records `PASS`/`FAIL` (or `NOT_RUN` when no executable rule exists), then re-inspects;
- a task with `human_gates` is set `blocked` and left to you; `/execute` never records decisions and never
  commits unless asked.

Runtime state under `work/state/` is never part of a validation subject, so it cannot change the approved Work
definition or the lifecycle state.

### 5. Direct CLI

Every command takes `--project-root` only:

```bash
./harness-core inspect_project --project-root ./kpi-platform --pretty
./harness-core bootstrap_repository --project-root ./kpi-platform --pretty
./harness-core check_execution_readiness --project-root ./kpi-platform --pretty
./harness-core --help
```

Exit status: 0 OK, 2 INCOMPLETE, 3 INVALID, 4 BLOCKED, 5 ERROR, 64 usage.

### 6. Troubleshooting

- `exit 64`, "harness_root is not configured"
  - Cause: a checkout run (`node dist/src/cli.js`) with `ENGINEERING_HARNESS_ROOT` unset; the compiled binary never hits this
  - Fix: `export ENGINEERING_HARNESS_ROOT=...`, or use the compiled binary

- `exit 64`, "Unknown option '--harness-root'"
  - Cause: the argument was removed in BRS 1.2
  - Fix: drop it; set the variable if the root is not beside the binary

- `exit 5`, `PROV_NOT_FOUND` (release `NOT_FOUND`)
  - Cause: no `_root/releases/v0.3.0` beside the binary: `init` has not run here yet, or the binary was moved away from its `_root`
  - Fix: run `init` (it creates `_root`), move `_root` with the binary, or set `ENGINEERING_HARNESS_ROOT`

- Copilot asks for approval on every core call, or `/bootstrap` is missing
  - Cause: untrusted workspace, or prompt files disabled
  - Fix: trust the workspace; check `chat.promptFiles` in `.vscode/settings.json`
  