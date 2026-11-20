---
name: bootstrap
description: Report the project through the deterministic Engineering Harness core, or perform the next action of its bootstrap lifecycle. Use only when the operator invokes this command by name.
argument-hint: "[status | rework instruction]"
disable-model-invocation: true
---

# bootstrap

Report the project, or perform the next action of the bootstrap lifecycle, as an adapter to the deterministic Engineering Harness core. The words the operator wrote after the command name select the form: `status`, `rework <instruction>`, or nothing.

## Rules of every call

- Read the Engineering Harness block of `AGENTS.md` first. Its rules apply here.
- Call the core only as `./harness <operation> --project-root . --adapter <id>`, from the project root. The adapter identifiers are `claude-code`, `codex` and `copilot`. `<id>` is your own: pass it on every call.
- Perform only the next action the core returns, or an operation its current result lists in `permitted_operations` with actor `adapter`. An operation the current result does not offer is not yours to run.
- You must never run a reserved operation or an operator command, and never `ssh-keygen -Y sign`. Decisions are the operator's.
- Never write under a reserved path. The core writes the governed files when you hand it an operation.
- Stop at `HUMAN_INPUT`, `HUMAN_DECISION`, `REWORK`, `BLOCKED`, `INVALID` and `ERROR`, and present the issue codes and the next action exactly as the core returned them.
- When the launcher exits with status 64, stop and report its message.

## `bootstrap status`

```sh
./harness inspect_project --project-root . --adapter <id>
```

Present the result: `regime`, `lifecycle.state`, `outcome`, `next_action`, `pending_gate`, `permitted_operations`, the change records and the revision in progress, the Work Item summary, the installed adapters, the signers, and every issue with its code. Derive nothing yourself. This form writes nothing.

## `bootstrap`

1. Inspect the project with the call above.
2. When `regime` is `maintenance`, present the status and say that `maintain` continues a revision and `execute` executes Work Items. Stop.
3. When `lifecycle.state` is `PROJECT_INPUT_REQUIRED` and `project-pack/PROJECT-PACK-BRIEF.md` exists, that brief is the operator's written instruction. Complete `project-pack/` by following it exactly, inspect again after every change, and stop when the state is `PROJECT_INPUT_READY`. Without a brief, stop for `HUMAN_INPUT`. This is the only case in which this command writes under `project-pack/`.
4. When the next action is a `HARNESS_OPERATION`, perform that one operation and no other. The deterministic operations take no input:

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

   For the authoring operations you are the author of the input, as "Authoring" below describes, and the core validates it and writes it into the governed location:

   ```sh
   ./harness ingest_specification --project-root . --adapter <id> --file <draft specification>
   ./harness derive_architecture --project-root . --adapter <id> --dir <draft architecture directory>
   ./harness generate_work_items --project-root . --adapter <id> --dir <draft work directory>
   ```

5. After an operation succeeds, inspect again and continue with the next action the core returns, until it returns a stop. An interrupted authoring step leaves nothing to hand over: the next session restarts that step from the next action.
6. At `HUMAN_DECISION`, stop. Present `pending_gate.gate`, `pending_gate.candidate_path`, `pending_gate.candidate_digest` and the commands the operator runs in their own terminal:

   ```text
   ./harness approve_pending --project-root . --approver <identity> --key <path>
   ./harness reject_pending --project-root . --approver <identity> --key <path> --comment <reason>
   ```

   `<identity>` is `pending_gate.approver`, the identity the Project Pack assigns to the gate's authority (`pending_gate.authority`); when it is null the Pack names no one for that authority, so say so and stop. `<path>` is the operator's signing key. Never run these commands yourself.
7. At `REWORK`, stop and present the issues. The operator answers with `bootstrap rework <instruction>`.
8. When the core returns `EXECUTION_READY` with next action `none_bootstrap_complete`, bootstrap is complete. Report it and stop. Work Items are executed with `execute`, never from this command.

## `bootstrap rework <instruction>`

Inspect the project. Author a corrected artefact set from the artefacts in place, the issues the core returned and the operator's instruction, then call the authoring operation that the current result lists in `permitted_operations`, in the form step 4 gives. When the result lists none, stop and say so.

## Authoring

- Draft from the sources the Pack declares under `project-pack/source/` and from the baselined predecessor: the baselined specification for the architecture, the baselined architecture and specification for the Work Items. Do not filter, reprioritise or invent content: one requirement per requirement stated in the sources; unresolved points go into `ambiguities`; stated assumptions go into `assumptions`.
- Write the draft to a temporary location outside the project and pass it with `--file` (one document) or `--dir` (a document set). Never place a document in a governed directory by hand.
- The release schemas are authoritative for every field name. They are in `<harness_root>/releases/<harness_version>/schemas/`, with both values taken from `provenance` in the core's result.
- `ingest_specification` takes `schema://intent/specification/v1`: `schema_version: 1` and a `specification` object with `id`, `title`, `requirements[]` (each `id`, `statement`, and `source_refs` listing source ids declared in `project-pack/source/manifest.yaml`), `acceptance_criteria[]` (each `id`, `requirement_id`, `statement`), and optional `assumptions[]` and `ambiguities[]` of strings. The core rejects duplicate ids, a criterion that references an unknown requirement, a requirement with no criterion, and a `source_refs` entry that is not a declared source.
- `derive_architecture` takes a directory laid out like the project's `architecture/`: `architecture.yaml` (`schema://intent/architecture/v1`: `architecture` with `id`, `title`, `components[]` each with an `id` starting `COMP-`, `name`, `responsibility`, `requirement_refs`; plus top-level `requirement_refs`, `adr_refs`, `contract_refs`), `adrs/<ADR-id>.yaml` (`schema://intent/adr/v1`: `adr` with an `id` starting `ADR-`, `title`, `status` of `proposed`, `accepted` or `superseded`, `decision`, `rationale`, `requirement_refs`) and `contracts/<CONTRACT-id>.yaml` (`schema://intent/contract-reference/v1`: `contract` with an `id` starting `CONTRACT-`, `name`, `type` of `api`, `event`, `data`, `integration` or `other`, `requirement_refs`). Every requirement is allocated to at least one component, every reference names a requirement of the baselined specification, and every ADR and contract file is named `<id>.yaml` and listed in `adr_refs` or `contract_refs`.
- `derive_project_ai_policy` has no input. The core derives `ai/policy.yaml` from the effective policy controls and the current Architecture Baseline.
- `generate_work_items` takes a directory laid out like the project's `work/`: `tasks/<TASK-id>.yaml` (`schema://work/item/v1`: `work_item` with an `id` starting `TASK-`, `title`, `requirement_refs`, `acceptance_refs`, `architecture_refs`, `contract_refs`, `dependencies`, `repository_scope` with `allowed` and `forbidden` path patterns, `verification_controls` taken from `engineering/controls.yaml`, and `human_gates`, which is empty or names gates of the release) and `execution-graph.yaml` (`schema://work/execution-graph/v1`: one entry per task file, holding the task's id and the same predecessors as that task's `dependencies`). The graph lists exactly the task files and is acyclic; every reference resolves; every requirement and every acceptance criterion of the specification is covered by at least one task; every `repository_scope` path stays inside the repository, and `allowed` never enters a reserved path: implementation scope lives under `src/`, `tests/` and `infra/`. Never write one task per requirement: write one task per component, or per group of closely related components, whose `requirement_refs` are that component's requirements and whose `acceptance_refs` are every acceptance criterion of those requirements.

Never claim a lifecycle transition that the core's result does not state.
