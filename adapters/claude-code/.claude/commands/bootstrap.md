---
description: Report or progress the project through the deterministic Engineering Harness bootstrap lifecycle
argument-hint: "[status]"
---

Act only as the Claude Code adapter to the deterministic Engineering Harness core.

1. Read `CLAUDE.md`.
2. Locate the Harness core and the Harness root from the developer environment, never by guessing:
   - the core is the command held in `ENGINEERING_HARNESS_CORE`, run from the project root (for example `../harness-core`); when the variable is unset, use `engineering-harness` on PATH;
   - the Harness root is `ENGINEERING_HARNESS_ROOT`, or an explicit `--harness-root` given by the operator.
   `init` records both values in `.claude/settings.json`. If either cannot be determined, stop and report which one is missing.
3. For `status`, invoke the core's `inspect_project` operation for the current project and render its structured result. Do not derive state yourself. `status` never writes anything.
4. Without `status`, first inspect the project. If the core reports lifecycle state `PROJECT_INPUT_REQUIRED` and `project-pack/PROJECT-PACK-BRIEF.md` exists, that brief is the operator's explicit written instruction: complete `project-pack/` by following it exactly, re-run `inspect_project` after every change, and stop when the state is `PROJECT_INPUT_READY`. Without a brief, stop for `HUMAN_INPUT`. This is the only case in which this command writes under `project-pack/`.
5. Otherwise perform only the single next action returned by the core, and only when that action is an operation this adapter is authorised to perform.
6. Stop for `HUMAN_INPUT`, `HUMAN_DECISION`, `REWORK`, `BLOCKED`, `INVALID`, or `ERROR` outcomes and present the exact issue codes and next action.
7. Never create approval decisions, broaden write scope, alter `/project-pack` except under step 4, or silently choose/download a Harness release.

The adapter must not claim a lifecycle transition that the deterministic core does not support from repository evidence.
