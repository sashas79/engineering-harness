# Engineering Harness v0.4.0 — Version-1 Schemas

These JSON Schema Draft 2020-12 files are normative annexes to the BRS. `schema-catalog.json` maps stable `schema://...` identifiers to release-local files.

Cross-file and repository-state rules that cannot truthfully be represented as single-object JSON Schema remain normative deterministic-semantic requirements in the BRS and contract tests.

## Relation to v0.3.0

Every schema is still version 1. Against the v0.3.0 schemas this release only adds optional members, adds enumeration values and relaxes a minimum (BRS Section 9, decision D-12). Every document that was valid under v0.3.0 is valid here and keeps its digest, because an absent member stays absent in the canonical form.

Changed schemas:

| Schema | Change |
| --- | --- |
| `validation-subject` | optional `revision` (change record; baseline to be superseded) |
| `approval-candidate` | optional `items` (item index); optional `revision` (as the subject, with the change record's path and the delta) |
| `human-decision` | optional `captured_via.confirmation`; `identity_assurance` also accepts the signed form of `signature-assurance` |
| `work-item` | optional `change_refs`; `minItems` of `requirement_refs` and `acceptance_refs` lowered to 0 |
| `harness-release` | `core_contract`, `workflows`, `adapters`, `adoptable_from`; `bootstrap_workflow` is required only when `core_contract` is absent |
| `next-action` | action `open_change` |
| `operation-result` | optional `regime`, `maintenance`, `work`, `permitted_operations`, `adapters`, `signers`; `provenance.installed_adapters`; `pending_gate.revision`; `approval_assurance` in each baseline summary; the new operation names |
| `issue`, `blocking-condition` | the issue codes of the maintenance, runtime, adapter, adoption and guard categories and the new approval codes; `issue` also gains the five categories and the new operation names |

New schemas:

| Schema ID | File | Document |
| --- | --- | --- |
| `schema://maintenance/change/v1` | `change.schema.json` | `evidence/changes/CHG-*.yaml` |
| `schema://maintenance/change-closure/v1` | `change-closure.schema.json` | `evidence/changes/CLO-*.yaml` |
| `schema://approval/subject-decision/v1` | `subject-decision.schema.json` | `evidence/decisions/DEC-*.yaml` |
| `schema://provenance/adoption/v1` | `adoption.schema.json` | `evidence/adoptions/ADOPT-*.yaml` |
| `schema://runtime/task-run/v1` | `task-run.schema.json` | `work/state/<TASK-id>/RUN-*.yaml` |
| `schema://runtime/task-result/v1` | `task-result.schema.json` | the `complete_task` input |
| `schema://runtime/legacy-task-state/v1` | `legacy-task-state.schema.json` | the three fields read from a v0.3.0 state file |
| `schema://lifecycle/maintenance-workflow/v1` | `maintenance-workflow.schema.json` | `workflows/maintenance.yaml` |
| `schema://lifecycle/execution-workflow/v1` | `execution-workflow.schema.json` | `workflows/execution.yaml` |
| `schema://harness/adapter-manifest/v1` | `adapter-manifest.schema.json` | `adapters/adapters.yaml` |
| `schema://provenance/adapters/v1` | `adapters-provenance.schema.json` | parsed `.engineering-harness-adapters` |
| `schema://approval/signer/v1` | `signer.schema.json` | `evidence/signers/SGN-*.yaml` |
| `schema://approval/signature-assurance/v1` | `signature-assurance.schema.json` | the signer reference shared by every signed record |

Content-addressed records carry a `binding` member (`algorithm`, `canonicalisation`, `digest`); the digest is the self digest named in the canonicalisation annex. A run (`task-run`) carries no self digest and is not a canonicalised object.
