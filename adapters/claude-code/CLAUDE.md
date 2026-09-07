# Engineering Harness — Claude Code Adapter v0.3.0

You are operating inside an Engineering Harness project.

The deterministic Engineering Harness core is authoritative for deterministic repository facts, lifecycle state, validation results, baseline validity/currentness, blockers, and next permitted action. Do not independently reconstruct those conclusions from conversational context or repository forensics.

## Authority boundaries

- `/project-pack/**` is human/project-owned input. Never silently modify it.
- `/engineering/**` is materialised only by authorised Harness profile-resolution/bootstrap operations.
- `/spec/**`, `/architecture/**`, `/ai/**`, and `/work/tasks/**` are generated only by their authorised lifecycle operations.
- `/baselines/**` and governed `/evidence/**` records are append-only under Harness semantics.
- Human approval decisions must be explicit and captured through the Harness decision mechanism.

## Configuration

`init` records how to reach the Harness in `.claude/settings.json`:

- `ENGINEERING_HARNESS_CORE` — the core command, run from the project root (for example `../harness-core`).
- `ENGINEERING_HARNESS_ROOT` — the Harness root holding the installed releases (for example `../_root`).

Use those values. Never guess a core command or a Harness root, and never download or select a release yourself.

## Bootstrap

Use `/bootstrap status` to obtain deterministic status through the configured Harness core.
Use `/bootstrap` only to perform the next operation that the core reports as permitted.

On a freshly initialised project the first permitted step is completing `project-pack/` from `project-pack/PROJECT-PACK-BRIEF.md`, which is the operator's explicit written instruction. `/bootstrap` does that, stops at `PROJECT_INPUT_READY`, and leaves the decision to run `bootstrap_repository` to the operator.

For the AI-assisted operations (`ingest_specification`, `derive_architecture`, `derive_project_ai_policy`, `generate_work_items`) `/bootstrap` authors the input document from the Pack's sources and any baselined predecessor and hands it to the core; the core alone validates it and writes it into the repository. Human decisions (`record_*_decision`) are never made by the adapter.

Do not implement a second state machine in this file or in Claude reasoning.
Do not begin Engineering Work Item execution merely because bootstrap is complete; runtime execution is a separate controlled workflow.
