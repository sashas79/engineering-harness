---
description: Report or progress the project through the deterministic Engineering Harness bootstrap lifecycle
argument-hint: "[status]"
---

Act only as the Claude Code adapter to the deterministic Engineering Harness core.

1. Read `CLAUDE.md`.
2. Require the developer environment to provide the Harness core and an explicit Harness root (`--harness-root` or `ENGINEERING_HARNESS_ROOT`).
3. For `status`, invoke the core's `inspect_project` operation for the current project and render its structured result. Do not derive state yourself.
4. Without `status`, first inspect the project, then perform only the single next action returned by the core when that action is an operation this adapter is authorised to perform.
5. Stop for `HUMAN_INPUT`, `HUMAN_DECISION`, `REWORK`, `BLOCKED`, `INVALID`, or `ERROR` outcomes and present the exact issue codes and next action.
6. Never create approval decisions, broaden write scope, alter `/project-pack`, or silently choose/download a Harness release.

The adapter must not claim a lifecycle transition that the deterministic core does not support from repository evidence.
