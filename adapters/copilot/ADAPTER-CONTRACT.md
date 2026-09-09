# GitHub Copilot Adapter Contract — v0.3.0

The GitHub Copilot adapter is a presentation/execution adapter to the Engineering Harness for Copilot Chat in VS Code. It does not define lifecycle state, validation, approval, baseline, profile-resolution, currentness, or next-action semantics.

## Required behaviour

- Use the deterministic Harness core for repository inspection and deterministic lifecycle decisions.
- Treat `/project-pack/**` as human/project-owned and never silently modify it. The only permitted write is completing the Pack from `project-pack/PROJECT-PACK-BRIEF.md`, the operator's explicit written instruction, while the core reports `PROJECT_INPUT_REQUIRED`; the adapter stops at `PROJECT_INPUT_READY`.
- Perform AI-assisted lifecycle operations (`ingest_specification`, `derive_architecture`, `derive_project_ai_policy`, `generate_work_items`) only when the core reports them as the next permitted operation. For `ingest_specification`, `derive_architecture` and `generate_work_items` the adapter authors the input document from the Pack's sources and the baselined predecessor, passes it to the core, and never writes governed documents directly. `derive_project_ai_policy` takes no input document; the adapter invokes it and the core derives `ai/policy.yaml`.
- Stop for explicit human decisions when the core reports a `HUMAN_DECISION` next action: present the pending gate, the candidate digest and the `approve_pending` short form for the operator to run. The adapter never runs `approve_pending`, `reject_pending` or `record_*_decision` itself; the shipped `.vscode/settings.json` denies their auto-approval to the agent.
- Never infer approval, currentness, or readiness.
- Execute Work Items only through `/execute` and only while the core reports `EXECUTION_READY` with `execution_permitted` true (BRS FR-036): one task at a time in `execution-graph.yaml` order once its `depends_on` are `done`, writing only inside the task's `repository_scope` plus `work/state/<TASK-id>.yaml`, recording verification results per control (`PASS`, `FAIL`, or `NOT_RUN` when no executable rule exists; never a claimed `PASS`), stopping for tasks with `human_gates`, and re-inspecting after each task.
- Let the core resolve the Harness root (`ENGINEERING_HARNESS_ROOT`, otherwise `_root` beside the binary); never pass a root, and never download or select another Harness release during project inspection.

## Environment

Copilot has no per-project environment block, so `init` writes the core command literally into the adapter files:

| Value | Meaning | Example |
| --- | --- | --- |
| `{{harness_core}}` | The core command, run from the project root; substituted by `init` in every adapter file that carries the placeholder. | `../harness-core` |

There is no Harness-root value to configure: the core resolves the root itself (BRS FR-034).

## Adapter files

The adapter ships the following files. `init` overlays every file except this contract onto a new project; `ADAPTER-CONTRACT.md` stays central.

- `.github/copilot-instructions.md` — repository custom instructions for Copilot (read by Copilot Chat in VS Code and by the other Copilot surfaces).
- `.github/prompts/bootstrap.prompt.md` — the `/bootstrap` prompt (`/bootstrap status` reports; `/bootstrap` performs the next permitted operation).
- `.github/prompts/execute.prompt.md` — the `/execute` prompt (`/execute status` reports runtime state; `/execute [TASK-id]` runs one Work Item at `EXECUTION_READY`).
- `.vscode/settings.json` — a template (strict JSON). It enables prompt and instruction files and configures `chat.tools.terminal.autoApprove`: the core command `{{harness_core}}` is auto-approved, while any command line naming `approve_pending`, `reject_pending` or `record_*_decision` is denied, so the agent cannot record a human decision. VS Code applies workspace settings only once the operator has trusted the workspace.

## Limits

- Prompt files are loaded by Copilot Chat in VS Code (and the Visual Studio / JetBrains previews); the Copilot CLI and the Copilot coding agent on github.com read `.github/copilot-instructions.md` but not the prompts, and have no workspace permission model. Those surfaces are not supported by this adapter.
- The terminal auto-approve rule is a tool-level guard, not a security boundary; the human decision remains the operator's under the Harness contract.

The authoritative v0.3.0 contracts are the recorded Harness release and the project repository facts.
