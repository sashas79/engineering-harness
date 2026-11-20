---
name: execute
description: Report the Work Items of the project through the deterministic Engineering Harness core, or execute one Work Item. Use only when the operator invokes this command by name.
argument-hint: "[status | TASK-id]"
disable-model-invocation: true
---

# execute

Report the Work Items, or execute one Work Item of the governing Work Baseline, as an adapter to the deterministic Engineering Harness core. The words the operator wrote after the command name select the form: `status`, a `TASK-id`, or nothing.

## Rules of every call

- Read the Engineering Harness block of `AGENTS.md` first. Its rules apply here.
- Call the core only as `./harness <operation> --project-root . --adapter <id>`, from the project root. The adapter identifiers are `claude-code`, `codex` and `copilot`. `<id>` is your own: pass it on every call.
- Perform only the next action the core returns, or an operation its current result lists in `permitted_operations` with actor `adapter`. An operation the current result does not offer is not yours to run.
- You must never run a reserved operation or an operator command, and never `ssh-keygen -Y sign`. Decisions are the operator's.
- Never write under a reserved path. The core writes the governed files when you hand it an operation.
- Stop at `HUMAN_INPUT`, `HUMAN_DECISION`, `REWORK`, `BLOCKED`, `INVALID` and `ERROR`, and present the issue codes and the next action exactly as the core returned them.
- When the launcher exits with status 64, stop and report its message.

This command holds no rule of selection, no rule of transition and no format of runtime state. The core selects the Work Item, decides whether it may start, and reads and writes its run. Never read or write a run file yourself, and never perform a lifecycle operation from this command.

## `execute status`

```sh
./harness list_tasks --project-root . --adapter <id>
```

Present what the core returns, in the order it returns it: every Work Item with its effective status, its dependencies, whether it is ready and the reason when it is not; the historical state; and the open acceptance criteria. This form writes nothing.

## `execute` and `execute <TASK-id>`

1. Ask the core which Work Item to execute. Use the second form when the operator named one:

   ```sh
   ./harness select_task --project-root . --adapter <id>
   ./harness select_task --project-root . --adapter <id> --task <TASK-id>
   ```

   The result holds the Work Item, its definition, its open run with the events and notes of earlier sessions, and the operations permitted on it. When it holds no Work Item, present the reason and its code (`EXECUTION_NOT_PERMITTED`, `TASK_NOT_READY`, `TASK_ALREADY_DONE`, `TASK_NOT_EXECUTABLE`) and stop. Never choose a Work Item yourself.
2. Start or resume it, when the result lists `start_task` for the item:

   ```sh
   ./harness start_task --project-root . --adapter <id> --task <TASK-id>
   ```

   When the run was open already, an earlier session worked on it, perhaps through another agent. Read the latest hand-over note in the run and continue from there.
3. Implement the Work Item from the definition the core returned. Read the requirements and acceptance criteria it references in `spec/specification.yaml`, the components, decisions and contracts it references under `architecture/`, and the effective controls in `engineering/controls.yaml`. Write only to paths that match its `repository_scope.allowed` and none that match its `repository_scope.forbidden`. Keep a list of every path you create, change or delete.
4. Verify. For each identifier in the item's `verification_controls`, run the repository's check for that control when one exists, and note the command and whether it passed. A control with no executable check is `NOT_RUN` with a note. Never report `PASS` for a check that did not run or did not pass.
5. Complete. Write the task result document to a temporary location outside the project and hand it to the core:

   ```sh
   ./harness complete_task --project-root . --adapter <id> --task <TASK-id> --file <task result document>
   ```

   The document is `schema://runtime/task-result/v1`: `schema_version: 1` and a `task_result` object with `verification[]` (for every identifier in `verification_controls` one entry with `control`, `result` of `PASS`, `FAIL` or `NOT_RUN`, and optionally `command` and `note`), optional `acceptance_notes[]` (each `criterion` and `note`) and `changed_paths[]`. The core refuses completion when a control has no result or a result is `FAIL`; fix the cause inside the scope and verify again. What you report is recorded as your claim, under your identifier.
6. When you cannot finish, park the work, with the paths changed so far:

   ```sh
   ./harness block_task --project-root . --adapter <id> --task <TASK-id> --reason <text> --changed-path <path>
   ```

   Use it when the item cannot be completed inside its scope, when a check fails and cannot be fixed, or when something outside the item is missing.
7. Whenever you stop before completion for any other reason, leave a hand-over note first. It states what is done and what remains, so that the next session, through any agent, needs nothing but the repository:

   ```sh
   ./harness record_task_progress --project-root . --adapter <id> --task <TASK-id> --note <text> --changed-path <path>
   ```

   Give `--changed-path` once for each path changed so far.
8. Present the result of the last call: the Work Item, its status, the changed paths and every issue with its code. Do not commit unless the operator asks. Execute one Work Item for each invocation of this command.

Never claim a verification result, a completion or a readiness that the core's result or an executed check does not support.
