# Engineering Harness — Claude Code Adapter

You are operating inside an Engineering Harness project.

The repository is the authoritative project workspace. The Engineering Harness defines the engineering process; this file only adapts Claude Code to that process.

## Authoritative project artefacts

Treat:

- `/spec` as authoritative functional intent.
- `/architecture` as authoritative structural intent.
- `/engineering` as mandatory engineering standards.
- `/ai` as the project-specific AI policy.
- `/work/tasks` as authorised units of engineering work.
- `/work/execution-graph.yaml` as authoritative dependency policy.
- `/baselines` as the approved versions against which downstream work is derived or executed.
- `/evidence` as the persistent record of validation, review and execution evidence.

If a required authoritative artefact is absent, incomplete or not baselined, do not infer that it is approved.

## Operating rules

1. Read the relevant repository artefacts before acting.
2. Do not invent missing requirements.
3. Do not silently change requirements, architecture, policy or approved baselines.
4. Do not make decisions reserved for human authorities.
5. Do not modify files outside the scope granted for the current bootstrap stage or Engineering Work Item.
6. Record material ambiguities and their engineering consequence.
7. Stop and escalate when an ambiguity affects correctness, architecture, security, scope, approval or release.
8. Produce structured outputs in the repository locations defined by the Engineering Harness.
9. Persist required evidence before declaring a stage or task complete.
10. Treat generated code as untrusted until required verification succeeds.

## Human control

Humans remain the approval authority for business correctness, architecture, security/platform constraints, engineering supervision and production release.

Claude may prepare artefacts for a human gate, but must not approve its own output or represent a gate as passed without explicit approval recorded in the repository.

## Bootstrap lifecycle

The project bootstrap lifecycle is:

`bootstrap_repository -> ingest_specification -> validate_specification -> derive_architecture -> validate_architecture -> derive_project_ai_policy -> generate_work_items -> validate_work_graph -> baseline_work`

The mandatory control points are:

- Specification baseline before architecture is treated as approved.
- Architecture baseline before work generation is treated as approved.
- Work baseline before Engineering Work Items may execute.

Use `/bootstrap` to progress the project through this lifecycle.

## Runtime task lifecycle

Once the work baseline exists, execute one authorised Engineering Work Item at a time through:

`plan -> build_context -> execute -> verify -> review`

Verification or review failure returns the work item to rework.

Do not bypass the work baseline by implementing directly from `/spec` or `/architecture`.

## Completion rule

A bootstrap stage or Engineering Work Item is complete only when:

- required outputs exist;
- required validations have succeeded;
- required evidence has been persisted; and
- any required human gate has been explicitly approved.

When any of these conditions is false, report the project as not ready for the next controlled stage.
