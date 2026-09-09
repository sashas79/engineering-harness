# Claude Code Adapter Contract — v0.3.0

The Claude Code adapter is a presentation/execution adapter to the Engineering Harness. It does not define lifecycle state, validation, approval, baseline, profile-resolution, currentness, or next-action semantics.

## Required behaviour

- Use the deterministic Harness core for repository inspection and deterministic lifecycle decisions.
- Treat `/project-pack/**` as human/project-owned and never silently modify it. The only permitted write is completing the Pack from `project-pack/PROJECT-PACK-BRIEF.md`, the operator's explicit written instruction, while the core reports `PROJECT_INPUT_REQUIRED`; the adapter stops at `PROJECT_INPUT_READY`.
- Perform AI-assisted lifecycle operations (`ingest_specification`, `derive_architecture`, `derive_project_ai_policy`, `generate_work_items`) only when the core reports them as the next permitted operation. For `ingest_specification`, `derive_architecture` and `generate_work_items` the adapter authors the input document from the Pack's sources and the baselined predecessor, passes it to the core, and never writes governed documents directly. `derive_project_ai_policy` takes no input document; the adapter invokes it and the core derives `ai/policy.yaml`.
- Stop for explicit human decisions when the core reports a `HUMAN_DECISION` next action: present the pending gate, the candidate digest and the `approve_pending` short form for the operator to run. The adapter never runs `approve_pending`, `reject_pending` or `record_*_decision` itself; the shipped `.claude/settings.json` denies them to the agent.
- Never infer approval, currentness, or readiness.
- Execute Work Items only through `/execute` and only while the core reports `EXECUTION_READY` with `execution_permitted` true (BRS FR-036): one task at a time in `execution-graph.yaml` order once its `depends_on` are `done`, writing only inside the task's `repository_scope` plus `work/state/<TASK-id>.yaml`, recording verification results per control (`PASS`, `FAIL`, or `NOT_RUN` when no executable rule exists; never a claimed `PASS`), stopping for tasks with `human_gates`, and re-inspecting after each task.
- Let the core resolve the Harness root (`ENGINEERING_HARNESS_ROOT`, otherwise `_root` beside the binary); never pass a root, and never download or select another Harness release during project inspection.

## Environment

The developer environment provides one value, and the adapter reads it rather than guessing:

| Variable | Meaning | Example |
| --- | --- | --- |
| `ENGINEERING_HARNESS_CORE` | The core command, run from the project root. Falls back to `engineering-harness` on PATH when unset. | `../harness-core` |

There is no Harness-root variable to configure: the core resolves the root itself (BRS FR-034).

## Adapter files

The adapter ships the following files. `init` overlays every file except this contract onto a new project; `ADAPTER-CONTRACT.md` stays central.

- `CLAUDE.md` — project instructions for Claude Code.
- `.claude/commands/bootstrap.md` — the `/bootstrap` command (`/bootstrap status` reports; `/bootstrap` performs the next permitted operation).
- `.claude/commands/execute.md` — the `/execute` command (`/execute status` reports runtime state; `/execute [TASK-id]` runs one Work Item at `EXECUTION_READY`).
- `.claude/settings.json` — a template. It carries the placeholder `{{harness_core}}`, which `init` replaces with the core command for the project being created: a path relative to the project directory when the core sits beside it, absolute otherwise. The template grants Claude Code permission to run the core command and denies the decision commands (`approve_pending`, `reject_pending`, `record_*_decision`), so the agent cannot record a human decision.

The authoritative v0.3.0 contracts are the recorded Harness release and the project repository facts.
