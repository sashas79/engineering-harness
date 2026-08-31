---
description: Progress this repository through the Engineering Harness bootstrap lifecycle
argument-hint: "[status|continue|<stage>]"
---

Operate as the Claude Code adapter for the Engineering Harness bootstrap workflow.

This command does not define the bootstrap process. It executes the process already defined by the repository's Engineering Harness conventions.

## Objective

Progress the current project safely toward `EXECUTION READY` by performing only the next permitted bootstrap stage, validating its outputs, persisting evidence, and stopping at required human gates.

Never skip a prerequisite, infer an approval, or execute an Engineering Work Item from this command.

## First: inspect current state

Before changing anything:

1. Read `CLAUDE.md`.
2. Read `.engineering-harness-template` if present and report the harness repository and version.
3. Inspect:
   - `/spec`
   - `/architecture`
   - `/engineering`
   - `/ai`
   - `/work`
   - `/baselines`
   - `/evidence`
4. Determine which bootstrap outputs and baselines already exist.
5. Do not overwrite an approved baseline unless the user explicitly requests a controlled re-baseline.

Classify the project at exactly one bootstrap state:

- `REPOSITORY INITIALISED`
- `SPECIFICATION IN PROGRESS`
- `AWAITING SPECIFICATION APPROVAL`
- `SPECIFICATION BASELINED`
- `ARCHITECTURE IN PROGRESS`
- `AWAITING ARCHITECTURE APPROVAL`
- `ARCHITECTURE BASELINED`
- `AI POLICY IN PROGRESS`
- `WORK DECOMPOSITION IN PROGRESS`
- `AWAITING WORK APPROVAL`
- `EXECUTION READY`
- `BLOCKED`

Report the detected state and the evidence used to determine it.

If `$ARGUMENTS` is `status`, stop after reporting state, missing prerequisites, unresolved ambiguities and the next permitted stage.

## Bootstrap stages

Execute only the requested stage when it is permitted. If no stage is requested, execute the next permitted non-gated stage and stop when a human gate is reached.

### 1. bootstrap_repository

Expected repository foundation:

- `/spec`
- `/architecture`
- `/engineering`
- `/ai`
- `/work`
- `/baselines`
- `/evidence`

Validate that the repository foundation exists and that the engineering baseline/configuration required by the project is present.

Do not reconstruct missing organisation-level harness material from memory. If required project engineering material is absent, report `BLOCKED`.

### 2. ingest_specification

Inputs are the source materials available to this project and the applicable specification structure/schema.

Produce or update `/spec` so that source material is normalised into explicit engineering intent.

Requirements:

- preserve source traceability;
- distinguish stated facts from assumptions;
- record ambiguities rather than resolving them silently;
- link acceptance criteria to the requirements they verify;
- do not introduce architecture merely to fill specification gaps.

Persist bootstrap evidence under `/evidence/bootstrap/spec-ingestion/`.

### 3. validate_specification

Validate at least:

- required specification structure is complete;
- source traceability is complete;
- ambiguities are recorded;
- acceptance criteria are linked;
- references resolve.

If validation fails, report the failures and remain `SPECIFICATION IN PROGRESS`.

If validation succeeds, report:

`AWAITING SPECIFICATION APPROVAL`

Stop. Do not create or record the human approval yourself.

After explicit human approval has been recorded according to the repository convention, create/update `/baselines/specification.yaml` only as permitted by that convention.

### 4. derive_architecture

Prerequisite: approved specification baseline.

Inputs:

- `/spec/**`
- `/baselines/specification.yaml`
- `/engineering/**`
- project configuration available in the repository
- applicable decision policy

Derive `/architecture` from the approved specification and engineering constraints.

Architecture must make structural boundaries explicit, including applicable:

- bounded contexts or domain boundaries;
- application/service boundaries;
- data ownership and persistence boundaries;
- contracts and integrations;
- runtime/platform concerns;
- security boundaries;
- cross-cutting concerns;
- architectural decisions and unresolved decisions.

Do not silently resolve decisions reserved for human authority.

Persist evidence under `/evidence/bootstrap/architecture/`.

### 5. validate_architecture

Validate at least:

- architecture traces to the approved specification;
- contracts are resolved or explicitly escalated;
- required decisions comply with decision policy;
- engineering standards are satisfied;
- applicable conformance checks pass.

If validation fails, report failures and remain `ARCHITECTURE IN PROGRESS`.

If validation succeeds, report:

`AWAITING ARCHITECTURE APPROVAL`

Stop. Do not create or record the human approval yourself.

After explicit approval has been recorded according to repository convention, create/update `/baselines/architecture.yaml` only as permitted by that convention.

### 6. derive_project_ai_policy

Prerequisite: approved specification and architecture baselines.

Derive `/ai` from project intent, architecture and applicable organisation policies.

The result must state the project-specific rules governing AI use, including where relevant:

- permitted AI activities;
- prohibited or human-only decisions;
- required context;
- model/tool constraints;
- data handling constraints;
- verification requirements;
- evidence requirements;
- escalation conditions.

Do not weaken organisation policy.

### 7. generate_work_items

Prerequisite: approved architecture baseline.

Generate atomic Engineering Work Items under `/work/tasks`.

Each work item must be independently executable and verifiable and must contain enough structured control information to execute without rediscovering project intent.

Each work item must trace to applicable:

- requirements;
- acceptance criteria;
- architecture constraints;
- contracts;
- engineering standards;
- AI policy;
- dependencies;
- repository scope;
- human gates.

Generate `/work/execution-graph.yaml`.

Do not implement the work items.

### 8. validate_work_graph

Validate at least:

- 100% acceptance-criterion coverage;
- no orphan requirements;
- all references exist;
- dependency graph is acyclic;
- repository scopes are valid;
- no unapproved cross-context tasks;
- every task is independently verifiable;
- human gates are resolvable.

Persist evidence under `/evidence/bootstrap/work-validation/`.

If validation fails, report the failures and remain `WORK DECOMPOSITION IN PROGRESS`.

If validation succeeds, report:

`AWAITING WORK APPROVAL`

Stop. Do not approve the work baseline yourself.

### 9. baseline_work

Prerequisite: explicit human approval of the work decomposition.

Create/update `/baselines/work.yaml` according to repository convention.

Then report:

`EXECUTION READY`

Do not begin implementation. The runtime execution workflow is a separate operation.

## Fail-closed behaviour

Stop and report `BLOCKED` when:

- a required prerequisite is absent;
- an approval cannot be established;
- required source material is unavailable;
- a material ambiguity affects correctness, architecture, security or scope;
- a required schema or policy cannot be located;
- validation cannot be performed reliably.

When blocked, report:

1. current bootstrap state;
2. blocking condition;
3. affected artefacts;
4. consequence;
5. exact human decision or missing input required;
6. next permitted action after resolution.

## Final response format

At the end of every invocation, provide:

- **State:** current bootstrap state
- **Stage performed:** stage executed, or `none`
- **Files changed:** repository-relative paths
- **Validation:** pass/fail/not run, with concise details
- **Evidence:** evidence paths written
- **Gate:** none / awaiting specification approval / awaiting architecture approval / awaiting work approval
- **Blocked by:** `none` or exact blocker
- **Next permitted action:** one concrete next action

Do not claim `EXECUTION READY` unless the approved work baseline exists.
