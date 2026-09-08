# Claude Code Adapter Contract — v0.3.0

The Claude Code adapter is a presentation/execution adapter to the Engineering Harness. It does not define lifecycle state, validation, approval, baseline, profile-resolution, currentness, or next-action semantics.

## Required behaviour

- Use the deterministic Harness core for repository inspection and deterministic lifecycle decisions.
- Treat `/project-pack/**` as human/project-owned and never silently modify it. The only permitted write is completing the Pack from `project-pack/PROJECT-PACK-BRIEF.md`, the operator's explicit written instruction, while the core reports `PROJECT_INPUT_REQUIRED`; the adapter stops at `PROJECT_INPUT_READY`.
- Perform AI-assisted lifecycle operations (`ingest_specification`, `derive_architecture`, `derive_project_ai_policy`, `generate_work_items`) only when the core reports them as the next permitted operation. For `ingest_specification`, `derive_architecture` and `generate_work_items` the adapter authors the input document from the Pack's sources and the baselined predecessor, passes it to the core, and never writes governed documents directly. `derive_project_ai_policy` takes no input document; the adapter invokes it and the core derives `ai/policy.yaml`.
- Stop for explicit human decisions when the core reports a `HUMAN_DECISION` next action.
- Never infer approval, currentness, or readiness.
- Use the explicit Harness root supplied by the developer environment; do not download or select another Harness release during project inspection.

## Environment

The developer environment provides two values, and the adapter reads them rather than guessing:

| Variable | Meaning | Example |
| --- | --- | --- |
| `ENGINEERING_HARNESS_CORE` | The core command, run from the project root. Falls back to `engineering-harness` on PATH when unset. | `../harness-core` |
| `ENGINEERING_HARNESS_ROOT` | The Harness root holding installed releases. `--harness-root` on a single invocation takes precedence. | `../_root` |

## Adapter files

The adapter ships the following files. `init` overlays `.claude/` and `CLAUDE.md` onto every new project; `ADAPTER-CONTRACT.md` stays central.

- `CLAUDE.md` — project instructions for Claude Code.
- `.claude/commands/bootstrap.md` — the `/bootstrap` command (`/bootstrap status` reports; `/bootstrap` performs the next permitted operation).
- `.claude/settings.json` — a template. It carries the placeholders `{{harness_root}}` and `{{harness_core}}`, which `init` replaces with the values for the project being created: paths relative to the project directory when the Harness root and core sit beside it, absolute paths otherwise. The template also grants Claude Code permission to run the core command.

The authoritative v0.3.0 contracts are the recorded Harness release and the project repository facts.
