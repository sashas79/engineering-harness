---
name: maintain
description: Report the maintenance state through the deterministic Engineering Harness core, open a change record, or continue the revision in progress. Use only when the operator invokes this command by name.
argument-hint: "[status | statement | register statement | rework instruction | abandon CHG-id]"
disable-model-invocation: true
---

# maintain

Report the maintenance state, open a change record, or continue the revision in progress, as an adapter to the deterministic Engineering Harness core. The words the operator wrote after the command name select the form: `status`, `register <statement>`, `rework <instruction>`, `abandon <CHG-id>`, a statement of what is to change, or nothing.

## Rules of every call

- Read the Engineering Harness block of `AGENTS.md` first. Its rules apply here.
- Call the core only as `./harness <operation> --project-root . --adapter <id>`, from the project root. The adapter identifiers are `claude-code`, `codex` and `copilot`. `<id>` is your own: pass it on every call.
- Perform only the next action the core returns, or an operation its current result lists in `permitted_operations` with actor `adapter`. An operation the current result does not offer is not yours to run.
- You must never run a reserved operation or an operator command, and never `ssh-keygen -Y sign`. Decisions are the operator's.
- Never write under a reserved path. The core writes the governed files when you hand it an operation.
- Stop at `HUMAN_INPUT`, `HUMAN_DECISION`, `REWORK`, `BLOCKED`, `INVALID` and `ERROR`, and present the issue codes and the next action exactly as the core returned them.
- When the launcher exits with status 64, stop and report its message.

This command never executes a Work Item. That is `execute`.

## `maintain status`

```sh
./harness check_maintenance --project-root . --adapter <id>
```

Present what the core returns: the regime, the change records with their status, the revision in progress, the Work Item summary, the open acceptance criteria, the changes made outside a run, the next action, `permitted_operations` and every issue with its code. This form writes nothing.

## `maintain <statement>`

The operator states what is to change and why. Record that statement; do not start the change.

1. Run `maintain status` and confirm that the result lists `open_change`.
2. Propose the kind: `defect`, `follow_up`, `new_requirement` or `documentation`. Propose a reach (`execution`, `work`, `architecture` or `specification`) only when the statement requires one wider than the default of the kind; otherwise leave it out and the core applies the default. When the statement does not decide the kind or the reach, ask the operator. Never decide either for them.
3. Open the change record with the operator's own words as the statement:

   ```sh
   ./harness open_change --project-root . --adapter <id> --kind <kind> --title <title> --statement <statement>
   ```

   Add `--reach <reach>` for a requested reach, `--rework <TASK-id>` once for each finished Work Item to re-execute under its approved definition, `--acceptance <statement>` once for each acceptance statement, and `--supersedes <CHG-id>` when the record corrects an earlier one.
4. Present the change record the core returns: its id, kind, reach and status, and the next action. Stop. The operator continues the revision with `maintain`.

## `maintain register <statement>`

The operator states a change that was made outside a run, for example a commit made without `execute`, and asks for it to be registered. Register it; do not re-execute or repeat any of it. A registered change has reach `none`: it starts no revision and no run.

1. Run `maintain status` and confirm that the result lists `open_change`.
2. Establish the changed paths. When the operator names Git commits, list the paths each one changes with `git show --name-only --format= <commit>`. When the operator names paths, take those. The core records the digest each path has now, so every path must exist as a regular file. Show the list to the operator.
3. Propose the finished Work Items whose deliverables the change touches: those that `execute status` reports as done and whose `repository_scope.allowed` in `work/tasks/<TASK-id>.yaml` covers a changed path. Ask the operator to confirm them. A change may touch none.
4. Propose the kind: `defect`, `follow_up`, `new_requirement` or `documentation`. When the statement does not decide it, ask the operator. Never decide it for them.
5. Register the change with the operator's own words as the statement:

   ```sh
   ./harness open_change --project-root . --adapter <id> --kind <kind> --title <title> --statement <statement> --registered --changed-path <path> --commit <sha> --touches <TASK-id>
   ```

   Give `--changed-path` once for each path, `--commit` once for each commit the operator named and `--touches` once for each Work Item the operator confirmed; leave out `--commit` and `--touches` when there are none. Never add `--reach`, `--rework`, `--acceptance` or `--supersedes`. When the core refuses a path with `TASK_SCOPE_VIOLATION`, the path is reserved or is not a regular file: present the issue and stop.
6. Present the change record the core returns: its id, the paths with their digests, the commits, the Work Items it touches and its status, `awaiting_decision`. Then present the command the operator runs in their own terminal to accept or reject it, and stop:

   ```text
   ./harness record_change_decision --project-root . --change <CHG-id> --decision accepted --approver <identity> --key <path>
   ./harness record_change_decision --project-root . --change <CHG-id> --decision rejected --approver <identity> --key <path> --comment <reason>
   ```

   `<identity>` is the identity `project-pack/project.yaml` assigns to the `engineering` authority. `<path>` is the operator's signing key. Never run these commands yourself.

## `maintain`

Continue the revision in progress.

1. Run `maintain status`. When there is no revision in progress, present the status and stop.
2. When the next action is a `HARNESS_OPERATION`, perform that one operation and no other. The deterministic operations take no input:

   ```sh
   ./harness bootstrap_repository --project-root . --adapter <id>
   ./harness validate_specification --project-root . --adapter <id>
   ./harness baseline_specification --project-root . --adapter <id>
   ./harness validate_architecture --project-root . --adapter <id>
   ./harness baseline_architecture --project-root . --adapter <id>
   ./harness derive_project_ai_policy --project-root . --adapter <id>
   ./harness validate_work_graph --project-root . --adapter <id>
   ./harness baseline_work --project-root . --adapter <id>
   ```

   For an authoring operation, author the revised artefact set as "Authoring a revision" below describes and hand it to the core:

   ```sh
   ./harness ingest_specification --project-root . --adapter <id> --file <revised specification>
   ./harness derive_architecture --project-root . --adapter <id> --dir <revised architecture directory>
   ./harness generate_work_items --project-root . --adapter <id> --dir <revised work directory>
   ```

3. When the next action is an authoring operation and the change record requires no change to that chain, do not author. Invoke the `validate_specification`, `validate_architecture` or `validate_work_graph` that the result lists in `permitted_operations` instead, and say that this chain is carried over unchanged.
4. After an operation succeeds, run `maintain status` again and continue with the next action, until the core returns a stop. An interrupted authoring step leaves nothing to hand over: the next session restarts that step from the next action.
5. At `HUMAN_DECISION`, stop. Present the gate, the change record (`pending_gate.revision.change`), the baseline the candidate supersedes, `pending_gate.candidate_digest`, and the delta in full: the artefacts and the items added, changed and removed, and the counts unchanged. Then present the command the operator runs in their own terminal:

   ```text
   ./harness approve_pending --project-root . --approver <identity> --key <path>
   ./harness reject_pending --project-root . --approver <identity> --key <path> --comment <reason>
   ```

   `<identity>` is `pending_gate.approver`, the identity the Project Pack assigns to the gate's authority (`pending_gate.authority`); when it is null the Pack names no one for that authority, so say so and stop. `<path>` is the operator's signing key. Never run these commands yourself.
6. At `REWORK`, stop and present the issues. The operator answers with `maintain rework <instruction>`.
7. When the next action is `open_change`, the revision needs a change record, or one of wider reach. Present the issue codes (`CHANGE_RECORD_REQUIRED`, `CHANGE_REACH_INSUFFICIENT`) and the reach the result names, and stop. The operator answers with `maintain <statement>`.
8. When the revision is complete and a change record lists Work Items to re-execute, reopen each one that the result lists `reopen_task` for:

   ```sh
   ./harness reopen_task --project-root . --adapter <id> --task <TASK-id> --change <CHG-id>
   ```

   Then say that `execute` executes them.

## `maintain rework <instruction>`

Run `maintain status`. Author a corrected artefact set from the artefacts in place, the issues the core returned and the operator's instruction, then call the authoring operation that the current result lists in `permitted_operations` (`ingest_specification`, `derive_architecture` or `generate_work_items`), in the form step 2 of `maintain` gives. When the result lists none, stop and say so.

## `maintain abandon <CHG-id>`

Run `maintain status`. When the result lists `abandon_change` for that change record:

```sh
./harness abandon_change --project-root . --adapter <id> --change <CHG-id>
```

Otherwise present why the core does not offer it, and stop. After a baseline has been established under a change record its revision can only go forward.

## Authoring a revision

- An authoring operation takes a complete artefact set, as in bootstrap. Start from the artefact set in place and change only what the change record requires. Hand back every unchanged artefact unchanged.
- Subject matter that changes keeps its id. New subject matter gets a new id. A retired id is never reused.
- A Work Item that the revision adds or changes lists the change record in `change_refs` and keeps every entry it had there. A Work Item with no requirement or acceptance reference needs a change record of kind `documentation` or `defect` that declares an acceptance statement.
- Write the revised set to a temporary location outside the project and pass it with `--file` or `--dir`. Never edit a governed file in place. The `bootstrap` command describes each document; the release schemas are authoritative for every field name.

Never claim a lifecycle transition that the core's result does not state.
