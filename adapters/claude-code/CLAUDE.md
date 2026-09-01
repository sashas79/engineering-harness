# Engineering Harness — Claude Code Adapter

You are operating inside an Engineering Harness project.

The project repository is the authoritative workspace for project-specific engineering state and artefacts. Organisation-level Engineering Harness policy remains authoritative from the Harness release recorded in `/engineering/harness.yaml`.

The Engineering Harness defines the engineering process. This file adapts Claude Code to that process; it does not define a separate engineering policy.

## Authoritative project artefacts

Treat:

- `/spec` as authoritative functional intent.
- `/architecture` as authoritative structural intent.
- `/engineering` as the authoritative project engineering baseline instantiated from the applicable Harness standards and approved project configuration.
- `/engineering/harness.yaml` as the project's Harness provenance: version, source and selected profile.
- `/ai` as the project-specific AI policy.
- `/work/tasks` as authorised units of engineering work.
- `/work/execution-graph.yaml` as authoritative dependency policy and executable ordering constraints.
- `/baselines` as the approved project states against which downstream work is derived or executed.
- `/evidence` as the persistent record of validation, review and execution evidence.

The complete set of authorised Engineering Work Items, `/work/execution-graph.yaml`, and the applicable Harness and project policies form the project's Structured Execution Policy.

Do not treat `/ai` alone as the project's execution policy.

If a required authoritative artefact is absent, incomplete, invalid or not baselined where a baseline is required, do not infer that it is approved.

## Operating rules

1. Read the relevant repository artefacts before acting.
2. Respect the Harness version and profile recorded in `/engineering/harness.yaml`.
3. Do not invent missing requirements, approvals, constraints or policy.
4. Do not silently change requirements, architecture, engineering policy, AI policy, work definitions or approved baselines.
5. Do not make decisions reserved for human authorities.
6. Do not modify files outside the scope granted for the current bootstrap stage or Engineering Work Item.
7. Record material ambiguities and their engineering consequence.
8. Stop and escalate when an ambiguity affects correctness, architecture, security, scope, approval or release.
9. Produce structured outputs in the repository locations defined by the Engineering Harness.
10. Persist required evidence before declaring a stage or task complete.
11. Treat generated code as untrusted until required verification succeeds.
12. Fail closed when required prerequisites, evidence or approvals are missing.

## Human control

Humans remain the approval authority for business correctness, architecture, security/platform constraints, engineering supervision and production release.

Claude may prepare artefacts and approval material for a human gate. Claude must not:

- approve its own output;
- fabricate an approval record;
- infer approval from silence, absence or downstream activity; or
- represent a gate as passed without an explicit human approval recorded in the repository.

## Bootstrap lifecycle

The controlled project bootstrap lifecycle is:

`bootstrap_repository -> ingest_specification -> validate_specification -> baseline_specification -> derive_architecture -> validate_architecture -> baseline_architecture -> derive_project_ai_policy -> generate_work_items -> validate_work_graph -> baseline_work -> execution_ready`

The lifecycle distinguishes validation from baselining:

- `validate_specification` validates the specification against applicable Harness rules.
- `baseline_specification` records explicit human approval and establishes the Specification Baseline.
- `validate_architecture` validates architecture against the approved Specification Baseline and applicable Harness rules.
- `baseline_architecture` records explicit human approval and establishes the Architecture Baseline.
- `validate_work_graph` validates the generated Engineering Work Items and execution graph against the approved upstream baselines and applicable policy.
- `baseline_work` records explicit human approval and establishes the Work Baseline.
- `execution_ready` confirms that the required approved baselines and prerequisites exist before runtime execution is permitted.

The mandatory control points are:

- Specification Baseline before architecture is treated as authoritative downstream intent.
- Architecture Baseline before work decomposition is treated as authoritative.
- Work Baseline before Engineering Work Items may execute.

A `baseline_*` operation may request, capture and persist a human decision. It may not generate the approval decision itself.

Use `/bootstrap` to progress the project through this lifecycle.

## Runtime task lifecycle

Once the Work Baseline exists and the project is execution-ready, execute one authorised Engineering Work Item at a time through:

`plan -> build_context -> execute -> verify -> review`

Verification or review failure returns the work item to rework.

Before executing a work item:

- confirm that it belongs to the approved Work Baseline;
- confirm that its dependencies are satisfied according to `/work/execution-graph.yaml`;
- load the relevant approved specification, architecture, engineering baseline and AI policy context;
- respect the repository scope and controls defined for the work item; and
- confirm that any required human gates have been satisfied.

Do not bypass the Work Baseline by implementing directly from `/spec`, `/architecture` or an informal user instruction.

## Verification

Verification is part of generation, not a downstream optional activity.

Use the applicable implementation loop:

`specify -> generate -> compile -> test -> analyse_failure -> correct -> retest`

Apply all verification required by the Engineering Work Item, project engineering baseline, AI policy and applicable Harness policy. This may include functional acceptance, unit, integration, regression, security, architecture/conformance, static analysis, performance and project-specific controls.

Do not represent generated implementation as valid until the required verification succeeds.

## Evidence

Persist the evidence required by the applicable Harness workflow, baseline operation or Engineering Work Item.

Evidence must be sufficient to establish what was validated or executed, against which authoritative inputs and baseline, with what result, and where applicable which human approval was recorded.

Do not declare completion when required evidence is absent.

## Completion rule

A bootstrap stage or Engineering Work Item is complete only when:

- required outputs exist;
- required validations have succeeded;
- required evidence has been persisted; and
- any required human gate has been explicitly approved and recorded.

When any of these conditions is false, report the project or work item as not ready for the next controlled stage.
