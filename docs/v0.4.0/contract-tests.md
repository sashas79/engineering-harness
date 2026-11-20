# Engineering Harness v0.4.0 — Definitive Contract Tests

**Status:** Normative

# Appendix A — Definitive Contract Test Scenarios

## Purpose

These scenarios are the definitive normative contract tests for the v0.3.0 handover package. They are directly implementable against the schemas and `harness-v1` contract supplied with this package.

They test boundaries and semantics rather than implementation structure.

---

## A. Clean repository and Project Pack

### CT-001 — Fresh project is expected incomplete

**Given**
- clean v0.3.0 project structure;
- distribution provenance exists;
- `/project-pack` exists but required human inputs are incomplete;
- no generated baselines/work/AI policy exist.

**Expect**
- repository structure is valid;
- state is `PROJECT_INPUT_REQUIRED`;
- progress is not an internal error;
- next action is human input;
- inspection writes nothing.

### CT-002 — Fresh project containing fake approved baseline fails structure/semantic checks

**Given**
- freshly initialised project;
- `baselines/specification/...` contains an approved-looking baseline without the required candidate/approval/evidence chain.

**Expect**
- it is not treated as `SPECIFICATION_BASELINED`;
- issue is reported as invalid/inconsistent lifecycle evidence;
- no approval is inferred.

### CT-003 — Undeclared source file

**Given**
- source file under `/project-pack/source`;
- file is not declared in source manifest;
- contract requires engineering input to be declared.

**Expect**
- Project Pack validation reports deterministic source issue;
- file is not silently consumed.

### CT-004 — Source path traversal

**Given**
- manifest source path `../../secret.txt`.

**Expect**
- deterministic reference/path failure;
- core never reads outside project source boundary.

### CT-005 — Unknown technology

**Given**
- valid Project Pack syntax;
- technology ID absent from recorded Harness release catalogue.

**Expect**
- profile resolution fails closed;
- no guessed equivalent;
- `/engineering` is not materialised by inspection.

---

## B. Provenance and Harness release

### CT-010 — Distribution provenance only

**Given**
- clean project before `bootstrap_repository`;
- `.engineering-harness-template` and adapter provenance exist;
- `/engineering/harness.yaml` does not yet exist;
- required Project Pack inputs are incomplete.

**Expect**
- distribution provenance resolves;
- absence of resolved engineering provenance is expected;
- state is `PROJECT_INPUT_REQUIRED`.

### CT-011 — Resolved engineering provenance unavailable

**Given**
- `/engineering/harness.yaml` claims an engineering resolution against release `v0.3.0`;
- that governing release cannot be resolved.

**Expect**
- issue `PROV_NOT_FOUND`;
- outcome `ERROR`;
- no downstream state is trusted.

### CT-012 — Newer central release exists

**Given**
- project records v0.3.0;
- v0.3.1 is also available.

**Expect**
- project remains governed by v0.3.0;
- no silent migration.

---

## C. Profile resolution

### CT-020 — Default profile resolves deterministically

**Given**
- valid Project Pack;
- profile `default`;
- recognised technology identifiers;
- no overrides.

**Expect**
- effective control set contains invariant + profile + technology controls;
- each control has recorded origin/provenance;
- repeated resolution yields identical canonical result and digest under `harness-v1`.

### CT-021 — Project config at forbidden point

**Given**
- project policy attempts to configure a control that does not expose project configuration.

**Expect**
- semantic validation failure;
- no last-write-wins behaviour.

### CT-022 — Override non-overrideable control

**Given**
- override targets an existing control;
- control does not expose an override point.

**Expect**
- override invalid;
- effective control set unchanged;
- Project Pack validation and profile resolution fail; the effective control set is not materialised.

### CT-023 — Conflicting effective controls

**Given**
- otherwise valid inputs produce an unresolved conflict under the normative control-resolution rules.

**Expect**
- issue `CONTROL_CONFLICT`;
- outcome `BLOCKED`;
- no arbitrary precedence.

### CT-024 — Inspection does not rematerialise engineering

**Given**
- existing `/engineering`;
- current Project Pack differs from resolution source fingerprint.

**When**
- `inspect_project()` runs.

**Expect**
- existing engineering resolution reported not current;
- `/engineering` unchanged;
- status operation performs no repair.

---

## D. Specification validation and approval

### CT-030 — Validation PASS but no candidate persisted

**Given**
- specification exists;
- PASS validation evidence exists;
- no candidate manifest exists;
- this repository condition is treated as legacy, manual or otherwise non-conformant because a conforming v0.3.0 PASS publication writes PASS evidence and its candidate atomically.

**Expect**
- state is not `AWAITING_SPECIFICATION_APPROVAL`;
- issue `REPO_INCONSISTENT_STATE` is reported; the project does not enter an approval-waiting or approved state.

### CT-031 — Candidate prepared from changed subject

**Given**
- PASS evidence for subject digest A exists from legacy/manual/non-conformant state;
- specification changed to digest B before candidate preparation.

**Expect**
- candidate preparation is prohibited;
- validation must be rerun.

### CT-032 — Human approves exact candidate

**Given**
- valid persisted candidate;
- correct assigned Product/Domain authority;
- explicit approved decision for exact candidate digest;
- declared identity assurance satisfies v0.3.0 rule.

**Expect**
- decision evidence is valid approval input; baseline establishment succeeds only after the mandatory final re-verification passes.

### CT-033 — Approval for wrong candidate

**Given**
- approval evidence references candidate digest A;
- baseline establishment attempts candidate B.

**Expect**
- integrity/authority chain failure;
- no baseline.

### CT-034 — Silence is not approval

**Given**
- candidate exists;
- no explicit decision evidence.

**Expect**
- state remains awaiting approval;
- adapter/core cannot infer pass.

On a project governed by v0.4.0 the decision is signed with the fixture key of the approver; the expectations are unchanged. On the v0.3.0 fixture the test runs as written.

### CT-035 — Rejected candidate cannot later be approved

**Given**
- persisted rejection decision for candidate A;
- later approval evidence attempts candidate A.

**Expect**
- invalid decision chain;
- new candidate required.

On a project governed by v0.4.0 the decision is signed with the fixture key of the approver; the expectations are unchanged. On the v0.3.0 fixture the test runs as written.

---

## E. Baseline integrity and lineage

### CT-040 — Valid current Specification Baseline

**Given**
- validation subject/evidence reproduce;
- candidate digest reproduces;
- approval evidence reproduces;
- correct authority;
- baseline record references exact candidate/approval;
- no superseding baseline;
- current specification matches candidate;
- current governing inputs match.

**Expect**
- historical validity = valid;
- currentness = current;
- lineage = head.

On a project governed by v0.4.0 the decision is signed with the fixture key of the approver; the expectations are unchanged. On the v0.3.0 fixture the test runs as written.

### CT-041 — Specification changes after approval

**Given**
- historically valid Specification Baseline;
- `/spec/**` differs from approved candidate.

**Expect**
- historical validity remains valid;
- currentness = stale;
- architecture and downstream execution cannot rely on it.

On a project governed by v0.4.0 the decision is signed with the fixture key of the approver; the expectations are unchanged. On the v0.3.0 fixture the test runs as written.

### CT-042 — Multiple baseline heads

**Given**
- two valid same-type baselines;
- neither supersedes the other.

**Expect**
- conflict/fail closed;
- timestamps must not choose winner.

### CT-043 — Supersession cycle

**Given**
- A supersedes B;
- B supersedes A.

**Expect**
- lineage invalid;
- no current head.

### CT-044 — Cross-type supersession

**Given**
- Architecture Baseline supersedes Specification Baseline.

**Expect**
- schema/semantic invalid.

### CT-045 — Approval evidence modified after baseline

**Given**
- established baseline stores approval evidence digest;
- approval record contents are edited.

**Expect**
- digest mismatch;
- baseline integrity invalid.

### CT-046 — Git commit missing but content evidence valid

**Given**
- baseline content-addressed chain verifies;
- optional Git provenance cannot be resolved.

**Expect**
- normative approval binding remains based on candidate/evidence contract;
- missing optional Git provenance does not invalidate an otherwise valid content-addressed approval chain and does not become the approval boundary.

---

## F. Project Pack and engineering-resolution staleness

### CT-050 — Project Pack edited after execution-ready

**Given**
- previously execution-ready project;
- observed Project Pack fingerprint changes.

**Expect**
- current engineering resolution is no longer current;
- Specification, Architecture, AI Policy and Work become stale according to dependency rules;
- execution prohibited;
- historical approval evidence remains intact.
- in the maintenance regime the next action is `open_change` with `CHANGE_RECORD_REQUIRED`; an invalid Pack still gives `correct_project_pack`.

### CT-051 — Invalid partial Project Pack edit

**Given**
- previously valid pack fingerprint A;
- user edits pack into invalid state B.

**Expect**
- observed fingerprint differs;
- B does not become validated fingerprint;
- existing resolved state is no longer current;
- core does not pretend A is still current merely because B is invalid.

### CT-052 — Pack restored byte-for-byte

**Given**
- A was approved/resolved;
- changed to B causing staleness;
- files later return to bytes matching A.

**Expect**
- an unsuperseded baseline becomes current again when every complete approved binding matches current repository facts exactly;
- a superseded baseline never becomes current again.

---

## G. Architecture and AI policy

### CT-060 — Architecture cannot be current on stale Specification Baseline

**Given**
- historically valid Architecture Baseline;
- its immediate Specification Baseline is stale.

**Expect**
- Architecture currentness = stale;
- AI policy and Work downstream = stale.

### CT-061 — AI policy content changed manually

**Given**
- valid AI policy provenance/digest;
- policy content edited.

**Expect**
- AI policy not current;
- Work Baseline not current;
- execution prohibited.

### CT-062 — AI policy binds wrong Architecture Baseline

**Given**
- policy content valid structurally;
- provenance references non-current or wrong Architecture Baseline.

**Expect**
- semantic/currentness failure.

---

## H. Work graph

### CT-070 — Valid DAG

**Given**
- all Work Items schema-valid;
- graph references all tasks;
- dependencies resolve;
- graph acyclic;
- required requirement/acceptance references resolve.

**Expect**
- deterministic Work Graph validation PASS.

### CT-071 — Cycle

**Given**
- A depends on B;
- B depends on A.

**Expect**
- validation failure;
- no Work approval candidate.

### CT-072 — Missing dependency target

**Given**
- task references `TASK-999`;
- no task exists.

**Expect**
- reference failure.

### CT-073 — Acceptance criterion orphan

**Given**
- approved specification acceptance criterion has no required work coverage.

**Expect**
- validation fails with `WORK_COVERAGE_INCOMPLETE`.

### CT-074 — "Independently verifiable" has no executable rule

**Given**
- work item passes structural checks;
- no deterministic rule exists for the semantic claim "independently verifiable".

**Expect**
- core does not claim that property passed deterministically;
- the claim is classified as AI-assisted/human review; no deterministic PASS result is emitted for it.

### CT-075 — Repository scope escapes project

**Given**
- allowed path includes `../other-repo/**`.

**Expect**
- scope validation fails closed.

---

## I. Bootstrap state derivation

### CT-080 — Specification exists, no validation

**Expect**
- `SPECIFICATION_IN_PROGRESS`.

### CT-081 — PASS validation + persisted candidate, no decision

**Expect**
- `AWAITING_SPECIFICATION_APPROVAL`.

### CT-082 — Approved current Specification Baseline

**Given**
- current valid Specification Baseline exists;
- no Architecture artefact exists.

**Expect**
- state is `SPECIFICATION_BASELINED`.

### CT-083 — Architecture valid but human rejection captured

**Expect**
- lifecycle returns to `ARCHITECTURE_IN_PROGRESS`;
- rejection evidence remains immutable.

### CT-084 — Work Baseline current, readiness prerequisite fails

**Expect**
- `WORK_BASELINED` remains distinct from `EXECUTION_READY`;
- progress/blocker explains readiness failure;
- execution not permitted.

### CT-085 — Upstream change from execution-ready

**Given**
- project was `EXECUTION_READY`;
- the specification is changed by hand, not through `ingest_specification`.

**Expect**
- state recomputed to highest supported state;
- no forward-only `EXECUTION_READY` flag remains authoritative.
- the derived state is reported, the next action is `open_change` with `CHANGE_RECORD_REQUIRED`;
- restoring the bytes gives `EXECUTION_READY`.

---

## J. Next action

### CT-090 — Incomplete pack

**Expect**
- action kind `HUMAN_INPUT`;
- action identifies completion of Project Pack.

### CT-091 — Awaiting approval

**Expect**
- action kind `HUMAN_DECISION`;
- exact pending gate/candidate is identified;
- no Harness generation operation is offered as next.

### CT-092 — Validation failure

**Expect**
- action kind `REWORK`;
- adapter is not told to proceed to baseline.

### CT-093 — Execution ready

**Expect**
- bootstrap next action is none/complete;
- core does not automatically execute an Engineering Work Item as part of bootstrap.
- `permitted_operations` lists `open_change` and, for each ready task, `start_task`.

---

## K. Read-only and persistence guarantees

### CT-100 — Status is idempotent

**Given**
- unchanged repository.

**When**
- `inspect_project()` is run repeatedly.

**Expect**
- same engineering result;
- no project file modification;
- no new evidence merely from status inspection.

### CT-101 — Query validation does not create lifecycle evidence unless explicitly invoked in evidence-producing mode

**Expect**
- diagnostic query and authoritative validation-evidence production are distinguishable.

### CT-102 — Append-only baseline records

**Given**
- baseline already established.

**Expect**
- correction creates a new record;
- old record is not overwritten.

---

## L. Result and exit behaviour

### CT-110 — Machine-readable issue code

**Given**
- missing profile.

**Expect**
- result includes stable issue code/category;
- callers need not parse prose.

### CT-111 — Expected incomplete versus internal error

**Given**
- fresh project lacking source input.

**Expect**
- engineering outcome is incomplete/not ready;
- no internal-error classification.

### CT-112 — Unsupported canonicalisation

**Given**
- content-addressed record declares unsupported canonicalisation version.

**Expect**
- unsupported/fail-closed outcome;
- digest is not guessed using `harness-v1`.

### CT-113 — CLI exit semantics

Verify the normative CLI exit mapping:

```text
0   OK
2   INCOMPLETE
3   INVALID
4   BLOCKED / CONFLICT
5   Harness resolution or internal ERROR
64  command usage error
```

---

## Completion

These scenarios are executable against the normative schemas, semantic rules and canonicalisation vectors supplied with this handover package. The implementation must not weaken their expected behaviour for implementation convenience.

---

## M. Additional contract tests required by final BRS decisions

The following tests shall be added because they resolve ambiguities not covered by the original contract-test set.

## CT-120 — Approved intermediate Specification state

**Given**

- valid current Specification candidate;
- explicit valid approved decision;
- no Specification Baseline.

**Expect**

```text
state = SPECIFICATION_APPROVED
next_action = baseline_specification

```

---

## CT-121 — Approved intermediate Architecture state

**Given**

- valid current Architecture candidate;
- explicit valid approved decision;
- no Architecture Baseline.

**Expect**

```text
state = ARCHITECTURE_APPROVED
next_action = baseline_architecture

```

---

## CT-122 — Approved intermediate Work state

**Given**

- valid current Work candidate;
- explicit valid approved decision;
- no Work Baseline.

**Expect**

```text
state = WORK_APPROVED
next_action = baseline_work

```

---

## CT-123 — Fingerprint subject uncomputable

**Given**

- source manifest cannot be deterministically parsed.

**Expect**

```text
observed_fingerprint = null
fingerprint_status = UNCOMPUTABLE
validated_fingerprint = null

```

No fallback tree hash is invented.

---

## CT-124 — Raw source hashing

**Given**

Two source files differ only in raw byte representation.

**Expect**

Their source digests differ.

No source-file line-ending normalisation occurs.

---

## CT-125 — Governed symlink

**Given**

A governed source/evidence/baseline path is a symlink.

**Expect**

```text
REPO_FORBIDDEN_SYMLINK

```

and the target is not consumed as a governed artefact.

---

## CT-126 — Mutation lock

**Given**

One mutation already holds the project lock.

**When**

A second mutation starts.

**Expect**

```text
MUTATION_LOCKED

```

No second authoritative mutation is published.

---

## CT-127 — Exclusive record creation

**Given**

A target evidence/baseline record already exists.

**Expect**

```text
RECORD_ALREADY_EXISTS

```

Existing bytes remain unchanged.

---

## CT-128 — Mutation precondition changed

**Given**

A caller inspected candidate/upstream state.

**And**

Relevant repository state changes before the mutation obtains its lock.

**Expect**

```text
MUTATION_PRECONDITION_CHANGED

```

No mutation is published.

---

## CT-129 — Record ID allocation

**Given**

Existing records:

```text
CAND-SPEC-0001
CAND-SPEC-0002

```

**Expect**

Next candidate ID:

```text
CAND-SPEC-0003

```

allocated under the project mutation lock.

---

## CT-130 — Result precedence

**Given**

The same inspection identifies:

- invalid project artefact;
- blocking baseline conflict; and
- no internal runtime failure.

**Expect**

```text
outcome = BLOCKED
exit = 4

```

All issues remain in the result.

---

## CT-131 — Harness release resolution is local

**Given**

The recorded release is unavailable locally but could theoretically be retrieved from the internet.

**Expect**

```text
PROV_NOT_FOUND / Harness-resolution error

```

Inspection does not silently download it.

---

---

# Additional contract tests introduced by BRS v1.1

## CT-132 — Valid Pack is ready for bootstrap

**Given**
- clean project structure;
- Project Pack is complete, schema-valid and semantically valid against the recorded Harness release;
- validated Pack fingerprint can be produced;
- no current `/engineering` resolution exists for that fingerprint.

**Expect**
```text
state = PROJECT_INPUT_READY
next_action = bootstrap_repository
outcome = INCOMPLETE
```
Inspection writes nothing.

## CT-133 — Valid Pack change falls back to PROJECT_INPUT_READY

**Given**
- project previously progressed beyond `REPOSITORY_INITIALISED`;
- current Pack is changed to a new valid fingerprint;
- `/engineering` still binds the earlier resolution-source fingerprint.
- no Work Baseline has been established.

**Expect**
```text
state = PROJECT_INPUT_READY
next_action = bootstrap_repository
```
Existing baselines/evidence remain historical and downstream currentness is stale.

## CT-134 — Approval-requiring override is unsupported

**Given**
- override targets an otherwise known/overrideable control;
- governing control declares human approval required for override.

**Expect**
```text
CONTROL_OVERRIDE_APPROVAL_UNSUPPORTED
outcome = INVALID
```
No override approval candidate or decision record is created.

## CT-135 — No executable security-exception flow

**Given**
- a v0.3.0 project using only the normative vertical-slice catalogue.

**Expect**
- no bootstrap state or next action requests security-exception approval;
- no security-exception candidate/evidence is required for `EXECUTION_READY`;
- the core does not invent such a gate.

## CT-136 — PASS evidence and candidate publish atomically

**Given**
- authoritative validation controls return PASS;
- PASS evidence and candidate are staged;
- the validation subject changes before final recheck.

**Expect**
```text
VALIDATION_SUBJECT_CHANGED
outcome = BLOCKED
```
Neither PASS evidence nor candidate is published.

## CT-137 — Harness root convention

**Given**
- project root is supplied;
- no `harness_root` is supplied to the core.

**Expect**
- core invocation is rejected as caller/usage configuration error;
- no repository inspection/mutation occurs.

**CLI variant (a)**
- `ENGINEERING_HARNESS_ROOT` absent;
- no core executable location is known (a checkout run through a script interpreter), so no `_root` can be derived.

**Expect**
```text
exit = 64
```
No repository inspection/mutation occurs. (A compiled executable always derives `_root` beside itself; a release missing there is `PROV_NOT_FOUND`, exit 5.)

**CLI variant (b)**
- a `--harness-root` argument is supplied.

**Expect**
```text
exit = 64
```
No repository inspection/mutation occurs.

**CLI variant (c)**
- `ENGINEERING_HARNESS_ROOT` set;
- a `_root` directory exists beside the core executable.

**Expect**
- the environment variable is used; `_root` is not consulted.

## CT-138 — NFC-normalised mapping-key collision

**Given**
- governed YAML/JSON contains two distinct parsed mapping keys that normalise to the same NFC string.

**Expect**
```text
CANONICALISATION_KEY_COLLISION
outcome = INVALID
```
No digest is produced.

# Additional contract tests introduced by BRS v1.2

## CT-139 — Adapter overlay

Retired. Replaced by CT-179, CT-181 and CT-183.

## CT-140 — `/execute` command contract

Retired. Replaced by CT-185.

# Additional contract tests introduced by BRS v2.0

All scenarios are deterministic and need no LLM (BRS Section 56). Every refusal names its issue code; a refused operation writes nothing unless the test says otherwise.

- **Reference project:** the catalogue API fixture taken to `EXECUTION_READY` under v0.4.0.
- **v0.3.0 fixture:** the same project as a v0.3.0 core and `init --adapter claude-code` left it: both v0.3.0 marker files, v0.3.0 candidates, the four v0.3.0 Claude Code adapter files, and one legacy state file per finished task. A second variant carries the v0.3.0 Copilot adapter files.
- **CHG, DEC, RUN:** the first change record, decision and run of a test unless numbered otherwise.
- **Fixture signers:** every fixture project governed by v0.4.0 has a signer chain whose anchor enrols a fixture key for the `engineering` identity, with further fixture keys for the other identities. Wherever a test says a decision is recorded, or a release adopted, the record is signed with the fixture key of the identity that makes it and its signature file is written, unless the test says otherwise. The fixture keys are test data: their private halves are in the test tree and protect nothing. Tests through the library pass a signing function; tests through the CLI run the real `ssh-keygen` with a passphrase-protected fixture key and are skipped, with the reason reported, where `ssh-keygen` is not installed.

## N. Change records and revisions

### CT-141 — A revision needs a change record

**Given**

- reference project at `EXECUTION_READY`, no change record.

**When**

- `generate_work_items`, `derive_architecture` or `ingest_specification` is invoked.

**Expect**

- `CHANGE_RECORD_REQUIRED`, outcome `BLOCKED`;
- the preceding `inspect_project` result did not list the operation in `permitted_operations` and listed `open_change` with actor `adapter`.

### CT-142 — Governed content changed without a change record

**Given**

- reference project at `EXECUTION_READY`, no change record;
- a file under `work/tasks/` is edited by hand.

**Expect**

```text
progress = blocked
next_action = HUMAN_INPUT open_change
issue = CHANGE_RECORD_REQUIRED
execution_permitted = false
```

Restoring the bytes returns the project to `EXECUTION_READY` with no issue. The same holds, with the state derived for that chain, when `spec/specification.yaml` or a file under `architecture/` is edited by hand.

### CT-143 — `open_change` records an immutable change record

**When**

- `open_change` with kind `defect`, a title and a statement, declared adapter `codex`.

**Expect**

- `evidence/changes/CHG-0001.yaml` is created with exclusive-create semantics and reproduces its digest;
- it records the kind, the statement, reach `work`, the three baselines in force by ID and digest, and the caller `codex`;
- no other file changes; its status is `open`;
- a second `open_change` creates `CHG-0002` and leaves `CHG-0001` byte-identical.

### CT-144 — Reach follows the kind and cannot go below its minimum

**Expect**

- kind `new_requirement` with no requested reach records reach `specification`;
- kind `new_requirement` with requested reach `work`: `CHANGE_REACH_INVALID`;
- kind `defect` with only Work Items to re-execute records reach `execution`; with nothing named, `work`;
- kinds `documentation` and `follow_up` record reach `work`; with requested reach `execution`: `CHANGE_REACH_INVALID`.

### CT-145 — A work revision is offered step by step

**Given**

- reference project at `EXECUTION_READY`; `CHG-0001` opened with reach `work`.

**Expect** the next actions, in order, each performed as offered:

```text
generate_work_items      (state EXECUTION_READY, artefacts equal the baseline)
validate_work_graph      (state WORK_DECOMPOSITION_IN_PROGRESS)
record_work_decision     (state AWAITING_WORK_APPROVAL, HUMAN_DECISION)
baseline_work            (state WORK_APPROVED)
none_bootstrap_complete  (state EXECUTION_READY)
```

- directly after `open_change` the next action is `generate_work_items`, although the candidate of `WORK-0001` is current and approved; `baseline_work` then is refused with `MUTATION_PRECONDITION_CHANGED`;
- the status of `CHG-0001` is `open`, then `in_revision` once its candidate exists, then no longer either once `WORK-0002` exists;
- opening `CHG-0001` makes no baseline stale: directly afterwards `WORK-0001` is current and `execution_permitted` is true;
- `validate_work_graph` run on unchanged artefacts instead gives `AWAITING_WORK_APPROVAL` with `execution_permitted` true and a delta with nothing added, changed or removed;
- the Specification and Architecture Baselines stay current throughout and the Pack fingerprint does not change.

### CT-146 — Unchanged content keeps its identity; the candidate states the delta

**Given**

- the revision of CT-145 submits every existing task file unchanged, one new task that lists `CHG-0001` in `change_refs`, and the graph with one new entry.

**Expect** in the new Work candidate:

- every unchanged task file has the digest it has in the superseded baseline's candidate, and its bytes on disk are unchanged;
- `revision.change` names `CHG-0001` with its digest; `revision.supersedes` names `WORK-0001` with its digest; the validation subject binds the same two;
- the artefact delta lists one added task file, one changed file (the graph) and N unchanged;
- the item delta lists, for kind `task`, one added and N unchanged; for kind `graph_entry`, one added and N unchanged; for kind `document`, one changed (the graph);
- the pending gate in the operation result carries the same revision context.

### CT-147 — An index or delta that does not reproduce invalidates the candidate

**Given**

- the pending candidate of CT-146 with one delta entry or one item digest edited, and the candidate digest recomputed to match.

**Expect**

- `REVISION_DELTA_MISMATCH`; the candidate is invalid;
- the state is not `AWAITING_WORK_APPROVAL`; `record_work_decision` is refused.

### CT-148 — The new baseline supersedes; the old one stays valid and untouched

**Given**

- the revision of CT-145 approved and baselined.

**Expect**

- `WORK-0002` records `supersedes` = `WORK-0001` with its path and digest;
- `WORK-0001`: integrity valid, historical validity valid, lineage position superseded, bytes unchanged;
- `WORK-0002`: current, head;
- `CHG-0001` has status `in_execution` while the added task is not done and `completed` once it is;
- after `CHG-0001` is completed and with no change record active, and again directly after `CHG-0002` is opened, `WORK-0002` is current and the Work graph valid: its baseline subject carries the revision member its own candidate records.

### CT-149 — An architecture revision replaces two baselines

**Given**

- `CHG-0001` opened with reach `architecture`; the revision changes one ADR that a task references and leaves that task unchanged.

**Expect**

- the next actions run through `derive_architecture`, `validate_architecture`, `record_architecture_decision`, `baseline_architecture`, `derive_project_ai_policy`, then the Work steps of CT-145;
- both new candidates name `CHG-0001`;
- each gate is decided by its own authority; the `engineering` authority deciding the architecture gate is `APPROVAL_WRONG_AUTHORITY`;
- `execution_permitted` is true until the first architecture artefact changes and false from then until `WORK-0002` is established;
- validating the Work candidate reports, as a warning, the unchanged task that references the changed ADR; validation still returns `PASS`.

### CT-150 — A chain that needs no change is confirmed, not skipped

**Given**

- `CHG-0001` opened with reach `specification`; the Specification step is baselined as `SPEC-0002`; the architecture needs no change.

**Expect**

- the state is `ARCHITECTURE_IN_PROGRESS`, the next action is `derive_architecture` and `permitted_operations` lists `validate_architecture` with actor `adapter`;
- `validate_architecture` publishes a candidate whose delta has nothing added, changed or removed and whose upstream is `SPEC-0002`;
- the architecture gate is still required before `ARCH-0002` exists.

### CT-151 — The reach is enforced

**Given**

- `CHG-0001` opened with reach `work`.

**Expect**

- `ingest_specification` and `derive_architecture` are not listed and are refused with `CHANGE_REACH_INSUFFICIENT`;
- a valid Pack change derives `PROJECT_INPUT_READY`, blocked, next action `open_change`, issue `CHANGE_REACH_INSUFFICIENT`; `bootstrap_repository` is refused with the same code;
- `spec/specification.yaml` edited by hand: blocked, next action `open_change`, issue `CHANGE_REACH_INSUFFICIENT`; `generate_work_items` and `validate_work_graph` are not listed;
- in both cases the result names `CHG-0001` as the subject of `open_change` and the reach required; opening an unrelated change record leaves the result unchanged, and a record that supersedes `CHG-0001` with that reach clears it.

### CT-152 — A wider reach is a superseding change record

**Given**

- `CHG-0001` (reach `work`) in revision with an undecided candidate; `CHG-0002` (reach `work`) open and waiting.

**When**

- `open_change` with reach `architecture` superseding `CHG-0001`.

**Expect**

- `CHG-0003` records `supersedes` = `CHG-0001`; `CHG-0001` is `superseded` and byte-identical;
- the active revision change is `CHG-0003`, not `CHG-0002`;
- the candidate that names `CHG-0001` is no longer offered for decision; the next action follows `CHG-0003`; the tasks authored under `CHG-0001`, which list it in `change_refs`, validate under `CHG-0003` without being re-authored;
- superseding with a narrower reach: `CHANGE_REACH_INVALID`;
- a second record superseding `CHG-0001`: `CHANGE_NOT_OPEN`;
- superseding a record whose status is `completed`, `abandoned` or `superseded`: `CHANGE_NOT_OPEN`;
- in a specification-reach revision, superseding after `SPEC-0002` exists: the successor inherits `SPEC-0002`, and the next action is the architecture step.

### CT-153 — Abandoning a change

**Expect**

- with the working artefacts equal to the baseline and no current undecided or approved candidate: `abandon_change` writes a closure record; the change is `abandoned`; the project is `EXECUTION_READY` with next action `none_bootstrap_complete`;
- with changed artefacts, or with a current undecided candidate naming the change: `CHANGE_NOT_OPEN`;
- with artefacts authored, validated and then restored to the baseline bytes: `abandon_change` succeeds (the candidate is no longer current);
- after a baseline was established under the change, or with a run bound to it: `CHANGE_NOT_OPEN`.

### CT-154 — One revision at a time

**Given**

- `CHG-0001` (reach `work`) in revision; `CHG-0002` (reach `work`) opened afterwards.

**Expect**

- the next action follows `CHG-0001`; candidates name `CHG-0001` only;
- `CHG-0002` is `open` and becomes the active revision change once `WORK-0002` is established.

### CT-155 — A maintenance task that traces to its change record

**Expect**

- a new task with empty `requirement_refs` and `acceptance_refs` that lists `CHG-0001`, where `CHG-0001` has kind `documentation` and declares an acceptance statement: validation `PASS`;
- the same where `CHG-0001` declares no acceptance statement, or has kind `follow_up`: validation `FAIL`, `CHANGE_REFERENCE_INVALID`, no candidate;
- such a task changed in a later revision under `CHG-0002` of kind `follow_up`: listing both records is `PASS`; dropping `CHG-0001` from `change_refs` is `CHANGE_REFERENCE_INVALID`;
- a task with empty references and no `change_refs`: validation `FAIL`, `CHANGE_REFERENCE_INVALID`;
- a `change_refs` entry naming a change record the repository does not hold: `CHANGE_REFERENCE_INVALID`;
- an acceptance criterion of the specification covered by no task: still `WORK_COVERAGE_INCOMPLETE` (CT-073 unchanged).

### CT-156 — Added and changed tasks name the revision

**Expect**

- a task added or changed in a revision under `CHG-0001` without `CHG-0001` in `change_refs`: validation `FAIL`, `CHANGE_REFERENCE_INVALID`;
- an unchanged task needs no `change_refs`.

### CT-157 — `check_maintenance` reports and writes nothing

**Given**

- one change in revision, one open and waiting, one registered change awaiting decision, one deferred task.

**Expect**

- the result lists each change record with kind, reach and derived status, the revision in progress with its chains and the step of each, the Work Item summary, the open acceptance criteria and the adapter findings;
- repeated calls give the same result; no file in the project changes.

## O. Runtime state

### CT-158 — Selection

**Given**

- reference project at `EXECUTION_READY`, three tasks in graph order A, B, C with C depending on A; no state.

**Expect**

- `select_task` without a name returns A;
- `select_task` naming C returns no task and `TASK_NOT_READY`; naming a task that is not in the task set: `TASK_UNKNOWN`;
- with B `in_progress` and A pending and ready, `select_task` without a name returns B and its open run with events and notes;
- every task `select_task` returns without a name is accepted by `start_task`;
- with B `blocked` and A pending and ready, `select_task` without a name returns A; naming B returns B;
- with C `in_progress` and its dependency A reopened, `select_task` without a name does not return C;
- while execution is prohibited, `select_task` returns no task and `EXECUTION_NOT_PERMITTED`;
- `list_tasks` returns every task in graph order with effective status and readiness;
- neither operation writes a file.

### CT-159 — `start_task` creates a run

**When**

- `start_task` on the selected task, declared adapter `claude-code`.

**Expect**

- `work/state/<TASK-id>/RUN-0001.yaml` validates against `schema://runtime/task-run/v1`;
- it binds the task definition by path and digest and the governing Work Baseline by ID, path and digest;
- status `in_progress`; one event of type `started` whose caller is `claude-code`;
- no candidate, subject or baseline digest changes; `inspect_project` is still `EXECUTION_READY`;
- through the CLI with neither `--adapter` nor `--operator`, or with both: exit 64, nothing written.

### CT-160 — `complete_task` checks what the core can check

**Expect**

- a result without an entry for one of the task's `verification_controls`: `TASK_VERIFICATION_INCOMPLETE`; the run stays open;
- a result with a `FAIL`: `TASK_VERIFICATION_FAILED`; the run stays open;
- a result whose changed path is outside `repository_scope.allowed`, inside `forbidden`, or a reserved path such as `AGENTS.md` or `evidence/`: `TASK_SCOPE_VIOLATION`;
- `complete_task` with no open run: `TASK_RUN_NOT_OPEN`;
- a result with `PASS` and `NOT_RUN` entries and paths in scope: the run is `done`; the results are recorded as given (`NOT_RUN` stays `NOT_RUN`); the run lists the union of the paths reported earlier in the run and in the result, each with its raw-byte digest; a `completed` event names the caller.

### CT-161 — Blocking, progress and resuming

**Expect**

- `record_task_progress` appends a `progress` event with its note and adds its changed paths to the run; a path out of scope: `TASK_SCOPE_VIOLATION`, nothing appended;
- `block_task` with a reason sets the run to `blocked`;
- `start_task` appends `resumed` to the same run and sets it to `in_progress`; no second run is created;
- `record_task_progress` and `block_task` on an open run succeed while execution is not permitted; `complete_task` then is `EXECUTION_NOT_PERMITTED`.

### CT-162 — A finished task is not overwritten

**Given**

- a task whose `RUN-0001` is `done`.

**Expect**

- `start_task`: `TASK_ALREADY_DONE`;
- `reopen_task` naming a change record that does not list the task in `rework`: `CHANGE_NOT_OPEN`;
- under a change record of kind `defect` and reach `execution` that lists the task: the record's status is `in_execution` from the moment it is opened; `reopen_task` creates `RUN-0002` bound to it; `RUN-0001` is byte-identical; the effective status is `in_progress`;
- a second `reopen_task` for the same task and record: `CHANGE_NOT_OPEN`;
- a task named in `rework` that a later revision changed before it was reopened is `rework_required`; `reopen_task` under the record is accepted and the run it creates is bound to the record; `reopen_task` on a task that is `in_progress`: `TASK_NOT_READY`.

### CT-163 — Carry-over under a new Work Baseline

**Given**

- tasks A, B and C `done` under `WORK-0001`;
- a revision that leaves A byte-identical, changes B and removes C; `WORK-0002` established.

**Expect**

- A is `done`; B is `rework_required`; C is not in the task list and its state is reported as history;
- no file under `work/state/` was written by `baseline_work`;
- `start_task` on B creates the next run bound to `WORK-0002`; B's earlier run is byte-identical;
- a disposition recorded on C before the revision is reported as ended.

### CT-164 — Legacy state files are read, never rewritten

**Given**

- v0.3.0 fixture, adopted (CT-174), with legacy files `work/state/<TASK-id>.yaml` naming `baselines/work/WORK-0001.yaml`, carrying the extra keys real projects contain (`acceptance`, `notes`, `changed_paths`, comments, folded scalars, a leading document marker, a value that looks like a float).

**Expect**

- a legacy file with status `done` gives `done`; after a revision that leaves the task byte-identical it is still `done`; after one that changes it, `rework_required`;
- a legacy file with status `in_progress`: `start_task` creates `RUN-0001` whose first event has type `resumed` and which names the legacy file;
- a legacy file with an unreadable `status`: `TASK_STATE_INVALID` and `rework_required`;
- no legacy file's bytes ever change.

### CT-165 — Hand-over between adapters

**Given**

- two copies of the reference project; a fixed clock.

**When**

- copy 1: `start_task` as `claude-code`; `record_task_progress` as `claude-code` with one changed path; `start_task` as `codex`; `record_task_progress` as `codex`; `start_task` as `copilot`; `complete_task` as `copilot` with a result that does not repeat the first path;
- copy 2: the same operations with the same inputs, all as `claude-code`.

**Expect**

- the two run files are identical after the caller of each event is removed;
- copy 1's events name `claude-code`, `claude-code`, `codex`, `codex`, `copilot`, `copilot` in that order;
- the path reported only by the first caller is in the completed run with its digest;
- `inspect_project` and `list_tasks` give the same conclusions for both copies.

### CT-166 — Runtime state never enters a subject

**Expect**

- after any sequence of runtime state operations the Work validation subject digest, every candidate digest and every baseline's currentness are unchanged (BRS Section 20.4).

### CT-167 — Execution under a work revision

**Given**

- tasks A and B not done, both ready; `CHG-0001` of reach `work` whose revision changes B and adds D.

**Expect**

- after `generate_work_items`, before validation: `execution_permitted` is true; `start_task` on A succeeds and its run binds `WORK-0001`; B and D are `awaiting_baseline` and `start_task` on either is `TASK_NOT_READY`;
- the same after a failed validation and while the candidate awaits approval;
- a revision that only reorders the graph leaves every task executable and shows one changed `document` item; `select_task` without a name then follows the working tree's order; a task the revision removes is `awaiting_baseline` and is listed last;
- `check_execution_readiness` returns `OK` and lists B and D as not executable;
- with the working Work artefacts unreadable: `execution_permitted` is false;
- with the same edits made by hand and no change record: `execution_permitted` is false (CT-142);
- a deferral recorded while the candidate awaits approval is accepted and takes effect at once.

## P. Dispositions and registered changes

### CT-168 — Deferring a task

**Given**

- before the decision, `permitted_operations` lists `record_task_decision` with actor `operator` and the task as subject.

**When**

- `record_task_decision` with decision `deferred`, a reason, and the identity the Pack assigns to `engineering`.

**Expect**

- `evidence/decisions/DEC-0001.yaml` binds the task ID, its definition digest, the Work Baseline, the decision, the reason, the approver, the signing key and signer record, and `gate://task-disposition`, and reproduces its digest; `DEC-0001.yaml.sig` verifies over that digest;
- the task is `deferred`; `select_task` never returns it; `start_task` on it is `TASK_NOT_EXECUTABLE`;
- a task that depends on it is not ready and `list_tasks` names the deferred task as the reason;
- the project stays `EXECUTION_READY`.

### CT-169 — Only the engineering authority, only a human

**Expect**

- another identity: `APPROVAL_IDENTITY_ASSURANCE_INVALID`; another authority: `APPROVAL_WRONG_AUTHORITY`;
- a task that is not in the task set: `DECISION_SUBJECT_INVALID`;
- through the CLI with `--adapter`: `GUARD_AGENT_CONTEXT`.

### CT-170 — Reinstating; one decision chain per task

**Expect**

- `reinstated` creates `DEC-0002` that supersedes `DEC-0001`; the task returns to the status its runs give it;
- two decisions on one task that both name the same predecessor: `DECISION_RECORD_INVALID`; the task is treated as deferred; timestamps do not choose.

### CT-171 — Open acceptance criteria

**Given**

- criterion K1 referenced by a done task and by a deferred task; K2 referenced only by the deferred task; K3 referenced only by done tasks; a task that lists `CHG-0001`, which declares `CHG-0001-AC-01`, and is not done.

**Expect**

- K1 and K2 are open, each with the tasks that are done and the task that is deferred; K2 is reported as not delivered and as open by disposition;
- K3 is closed;
- `CHG-0001-AC-01` is reported with `CHG-0001` and is open; when its task is withdrawn it stays open and `CHG-0001` has status `completed_with_open_items`, naming the task; when a later revision removes the task before it was done, the same;
- once the task is done, `CHG-0001` is `completed` and stays so when the task is later reopened under another record, changed by a later revision or deferred;
- after a revision that leaves the deferred task unchanged the disposition is in force and the same criteria are open; after one that changes the task's definition the disposition is in force and is reported as decided on an earlier definition.

### CT-172 — Registered change

**When**

- `open_change` with origin `registered`, kind `defect`, three changed paths (two under `src/`, one under `docs/`) and one finished task named.

**Expect**

- the record has reach `none`, the raw-byte digest of each path and status `awaiting_decision`;
- a reserved path in the list: `TASK_SCOPE_VIOLATION`;
- no run is created or modified;
- `record_change_decision` `accepted` by the `engineering` authority writes a decision record at `gate://registered-change`; the status is `accepted`;
- `list_tasks` reports the named task as `done` with the note that a registered change touched its deliverable and was accepted;
- a registered change that is `rejected` stays in `check_maintenance` until a planned change record supersedes it; superseding it while another change record is in revision leaves the active revision change and its pending candidate as they were;
- no operation offers to execute or complete anything under a registered change.

### CT-173 — Changes outside a run are reported

**Given**

- a task completed through a v0.4.0 run that recorded two changed paths; afterwards one of those files is edited.

**Expect**

- `check_maintenance` reports that path as changed outside a run;
- after a registered change that names the path with its new digest is recorded, the path is no longer reported; after that change is rejected it is reported again;
- nothing is blocked; a path recorded only by a legacy state file is not reported.

## Q. Adoption

### CT-174 — A v0.3.0 project adopts v0.4.0 without re-approval

**Given**

- v0.3.0 fixture at `EXECUTION_READY` under a v0.3.0 release; a v0.4.0 release whose controls, profiles and technologies are byte-identical.

**When**

- `adopt_release` to v0.4.0 with adapters `claude-code,codex,copilot`, by the `engineering` identity with its fixture key.

**Expect**

- `evidence/adoptions/ADOPT-0001.yaml` records both releases, the same engineering-resolution digest before and after, control equivalence, each of the three baselines with a `PASS` result and its item index, and reproduces its digest;
- it lists every decision record of the fixture in `declared_decisions`, names the operator, the key and `SGN-0001`, and `ADOPT-0001.yaml.sig` verifies; `evidence/signers/SGN-0001.yaml` is the anchor for that identity and key, signed with that key;
- each baseline is reported with `approval_assurance: declared`;
- `engineering/harness.yaml` and `.engineering-harness-template` record v0.4.0; `engineering/controls.yaml` and `engineering/profile.yaml` are byte-identical;
- `.engineering-harness-adapter` is gone; `.engineering-harness-adapters` lists the three adapters; each v0.3.0 Claude Code file is replaced by the v0.4.0 overlay file; every overlay file is byte-identical to the release; the result lists the files written, replaced and removed;
- every file under `baselines/`, `evidence/validation/`, `evidence/candidates/`, `evidence/approvals/`, `spec/`, `architecture/`, `ai/` and `work/` is byte-identical;
- `inspect_project`: `EXECUTION_READY`, the three baselines current, the Project AI Policy current, the Work graph valid, `execution_permitted` true, no `REPO_INCONSISTENT_STATE` and no `REPO_REQUIRED_PATH_MISSING` (`evidence/changes/` and `evidence/decisions/` do not exist yet);
- no validation, candidate or decision record was created.

### CT-175 — Currentness rests on the adoption record

**Given**

- the adopted project of CT-174.

**Expect**

- with the adoption record removed: the declared decisions are not carried, each is `APPROVAL_IDENTITY_ASSURANCE_INVALID`, and the three baselines are invalid and stale; execution is prohibited;
- with it edited so that its digest does not reproduce: the same, with `ADOPTION_RECORD_INVALID`;
- with it edited and its digest recomputed, so that only the signature no longer matches, or with its signature file removed: the same, with `ADOPTION_RECORD_INVALID`;
- with the record restored byte for byte: `EXECUTION_READY` again;
- a candidate that the adoption record does not list as the candidate of a baseline is not made current by it.

### CT-176 — An adoption that is not control-equivalent is refused

**Given**

- v0.3.0 fixture; a target release that adds one invariant control, or whose work-graph control fails the baselined work.

**Expect**

- `ADOPTION_NOT_EQUIVALENT` naming the difference; nothing is written; the project is still governed by v0.3.0 and still `EXECUTION_READY`.

### CT-177 — Adoption is explicit and has preconditions

**Expect**

- a v0.3.0 project beside an installed v0.4.0 release stays governed by v0.3.0 (extends CT-012): no operation other than `adopt_release` changes the recorded release, and no v0.4.0 operation is offered;
- `adopt_release` with a candidate awaiting decision, with an approved candidate awaiting its baseline, with a stale baseline head, or with an invalid Pack: `ADOPTION_NOT_PERMITTED`;
- `adopt_release` to a release that does not list the recorded release in `adoptable_from`: `ADOPTION_UNSUPPORTED`;
- nothing is written to the project in any of these cases.

### CT-178 — The first revision after adoption has a delta

**Given**

- the adopted project of CT-174; a work revision as in CT-146.

**Expect**

- the delta is computed against the item index in the adoption record and gives the same result as CT-146;
- `WORK-0002` supersedes the v0.3.0 `WORK-0001`, which stays historically valid and byte-identical.

## R. Adapters

### CT-179 — Any subset at initialisation

**When**

- `init` with `--adapters` set to each of: none, `codex`, `claude-code,copilot`, `claude-code,codex,copilot`.

**Expect**

- the project holds exactly the overlay files of the chosen adapters and, when at least one is chosen, the common files; each is byte-identical to the release file, and `AGENTS.md` consists of the managed block;
- `.engineering-harness-adapters` lists the chosen identifiers in ascending order with the release version, and is absent when none is chosen;
- no `ADAPTER-CONTRACT.md` is in the project;
- `inspect_project` gives the same lifecycle state for all four projects (AC-035).

### CT-180 — Adding, removing and synchronising on an existing project

**Given**

- a v0.3.0 fixture adopted with `claude-code` only, at `EXECUTION_READY`.

**When**

- `adapter_add codex`, `adapter_add copilot`, `adapter_remove claude-code`, then one overlay file is deleted and `adapter_sync` is run.

**Expect** after each command:

- only overlay files, the managed block and `.engineering-harness-adapters` changed;
- the Pack fingerprint, the engineering-resolution digest, every candidate digest and every baseline's currentness are unchanged; the state is `EXECUTION_READY`;
- the launcher and the managed block remain until the last adapter is removed;
- `adapter_sync` restores the deleted file byte for byte;
- `adapter_add` onto an existing file that differs from the overlay: `ADAPTER_FILE_CONFLICT`; with replacement requested it succeeds and the result lists the file replaced.

### CT-181 — Rendered files equal the source

**Expect**

- `render_adapters --check` on the release source succeeds;
- after one character of a rendered file or of the source text is changed, it fails and names the file;
- the body of each command and of the instructions is byte-identical in every rendering;
- every rendering contains the same sentence listing all adapter identifiers of the manifest, and no rendering contains `--adapter` followed by a literal identifier;
- every rendered `SKILL.md` has a `name` equal to its directory name and a description of at most 1,024 characters;
- the rendered `CLAUDE.md` is exactly the line that imports `AGENTS.md`.

### CT-182 — Installed files are checked against the release

**Expect**

- `check_adapters` on a fresh installation: `OK`;
- with one installed file edited: `ADAPTER_FILE_MODIFIED` naming the file; with one deleted: `ADAPTER_FILE_MISSING`; with the content of the managed block edited: `ADAPTER_FILE_MODIFIED`; with text added outside the block: `OK`;
- `inspect_project` reports the same findings as warnings and its lifecycle conclusions do not change.

### CT-183 — The core is found through the launcher

**Expect**

- no overlay file contains a path to the core, the placeholder `{{harness_core}}`, or a setting that names the core's location;
- every core invocation in the rendered command text is `./harness`;
- the launcher, started from the project root and from a subdirectory, runs the executable named by `ENGINEERING_HARNESS_CORE` when set, otherwise `harness-core` in the parent of the launcher's own directory, otherwise `harness-core` on the search path, and passes every argument and the exit status through;
- when none exists it exits 64, and for `adapter_guard` it exits 0;
- for `adapter_guard` an exit status of the core other than 0 and 2 becomes 0, and 2 passes through.

### CT-184 — The caller is declared

**Expect**

- an operation with `--adapter codex` in a project where `codex` is installed reports `provenance.adapter = codex`;
- with an identifier that is not installed: `ADAPTER_UNKNOWN`;
- `provenance.installed_adapters` lists the installed set in every result;
- with `CLAUDE_CODE_CHILD_SESSION=1` in the environment and `--adapter codex`, or `--operator`: `ADAPTER_MISMATCH`; with `--adapter claude-code`: accepted.

### CT-185 — Command files hold no lifecycle logic (replaces CT-140)

**Given**

- the rendered `bootstrap`, `execute` and `maintain` of each adapter and the rendered instructions.

**Expect**

- `execute` contains `list_tasks`, `select_task`, `start_task`, `record_task_progress`, `block_task`, `complete_task`, `repository_scope`, `verification_controls` and `NOT_RUN`;
- `maintain` contains `check_maintenance`, `open_change`, `abandon_change`, `reopen_task`, `ingest_specification`, `derive_architecture`, `generate_work_items`, `HUMAN_DECISION` and `REWORK`, and names its forms `status`, `rework` and `abandon`;
- every command contains `--adapter`, `./harness`, `permitted_operations`, and the sentences "never run a reserved operation or an operator command" and, for its `status` form, "writes nothing";
- no rendered file contains `depends_on`, `work/state/`, `task_state:` or `status: in_progress`.

### CT-186 — Each adapter ships its enforcement files

**Expect**

- `claude-code`: `.claude/settings.json` allows `./harness`; denies each reserved operation and each operator command as a shell command; denies its file tools on `evidence/`, `baselines/` and `work/state/`; and registers `adapter_guard` before shell and file-writing tools;
- `codex`: a rules file that forbids each reserved operation and operator command after `./harness`, and a hooks file that registers `adapter_guard`;
- `copilot`: a hooks file that registers `adapter_guard` for both shells;
- each contract contains the headings "Supported surfaces", "What the shipped controls block", "What they do not block" and "Residual risk".

### CT-187 — `adapter_guard`

**Given**

- tool-call payloads in the hook format of each shipped adapter, and the Claude-format payload as Copilot delivers it.

**Expect**

- a shell command containing `approve_pending`, `reject_pending`, any `record_*_decision`, `record_task_decision`, `record_change_decision`, `adopt_release`, `adapter_add`, `adapter_remove` or `adapter_sync` as a shell word, in any position and behind any executable name: exit status 2, the reason on standard error;
- a file-writing call whose target is under `evidence/`, `baselines/`, `work/state/`, `engineering/`, `spec/`, `architecture/`, `ai/` or `work/tasks/`, or is an adapter file, the launcher or `AGENTS.md`: exit status 2, for an absolute and for a relative target, also when the session directory in the payload is below the project root; a target under `project-pack/`, `src/` or `tests/`: exit status 0; a call whose target cannot be determined: exit status 0;
- `./harness inspect_project --project-root .`, a command in which a guarded name appears only inside another word, and a call of any other tool: exit status 0, no output;
- unreadable input: exit status 2;
- the same input gives the same answer on every run; nothing is written, and only `.engineering-harness-template` is read from the project;
- whatever fails (standard input, the project, the manifest, an internal error, arguments it does not know), the exit status is 0 or 2.

## S. Reserved operations

### CT-188 — No terminal, no decision

**Given**

- a pending candidate; the CLI started with no controlling terminal.

**Expect**

```text
GUARD_NOT_INTERACTIVE
outcome = BLOCKED
```

No decision record is written. The same holds for `record_task_decision` and `record_change_decision`. With a controlling terminal and standard input redirected from a file that holds the correct confirmation, the confirmation is still read from the terminal.

### CT-189 — No decision in an agent context

**Expect**

- a reserved operation with `--adapter`: `GUARD_AGENT_CONTEXT`;
- with `CLAUDE_CODE_CHILD_SESSION=1`, separately with `CLAUDECODE=1`, and separately with `CODEX_THREAD_ID` set to any value: `GUARD_AGENT_CONTEXT`; the release manifest lists at least these three markers; a marker set to the empty string does not trigger;
- in every case nothing is written, with or without a terminal.

### CT-190 — Confirmation of the exact subject

**Given**

- a pending candidate in a revision; a terminal.

**Expect**

- the CLI shows the gate, the candidate path and digest, the change record and the delta summary before asking;
- the CLI also shows the identity and key fingerprint it will sign as and the project's anchor;
- the last eight characters of the candidate digest typed correctly: the CLI then obtains the signature (CT-222) and the decision is recorded with `captured_via.interface = cli` and the terminal confirmation noted;
- anything else typed, or end of input: `GUARD_CONFIRMATION_FAILED`, and no signature is requested;
- for `record_task_decision` the token is taken from the Work Item definition digest, and for `record_change_decision` from the change record digest;
- the library interface records the decision without a prompt, with the signature its caller's signing function returns, and states `captured_via.interface = library`; without a signing function, or with a signature that does not verify for the approver, it records nothing.

## T. Tests added after review

### CT-191 — Two consecutive revisions

**Given**

- the project of CT-148 (`WORK-0002` under `CHG-0001`); `CHG-0002` of reach `work` opened and taken through to `WORK-0003`.

**Expect**

- throughout the second revision the active revision change is `CHG-0002`; `CHG-0001` never has status `open` or `in_revision`;
- after `WORK-0003`, `WORK-0002` is superseded and historically valid, and no revision change is active;
- a Pack edit after the second revision gives next action `open_change` with `CHANGE_RECORD_REQUIRED`.

### CT-192 — Rejection and failed validation in a revision

**Expect**

- a revision candidate rejected at its gate: state `<X>_IN_PROGRESS`, blocked, next action `correct_<x>`; `permitted_operations` lists the authoring operation and `validate_<x>`; re-authoring and validating yields a second candidate naming the same change record, which can be approved;
- a `FAIL` validation in a revision: the same state; `permitted_operations` lists the authoring operation; after re-authoring, `validate_<x>` is the next action.

### CT-193 — The maintenance regime keeps the unconditional rows

**Given**

- reference project at `EXECUTION_READY`, with and without an open change record.

**Expect**

- an invalid Pack: `PROJECT_INPUT_REQUIRED`, next action `correct_project_pack` (CT-051, CT-090);
- `infra/` removed: `WORK_BASELINED`, blocked, `resolve_blocker` (CT-084);
- the approval evidence of the Work Baseline edited: the project is still in the maintenance regime, and `generate_work_items` without a change record is `CHANGE_RECORD_REQUIRED`.

### CT-194 — Repairs need no change record

**Expect**

- `ai/policy.yaml` edited by hand or deleted, no change record: next action `derive_project_ai_policy`; performing it returns the project to `EXECUTION_READY` (CT-061, CT-062 unchanged);
- `engineering/controls.yaml` deleted, Pack unchanged, no change record: next action `bootstrap_repository`; performing it returns the project to `EXECUTION_READY`.

### CT-195 — A specification revision with a changed Pack

**Given**

- `CHG-0001` of kind `new_requirement`; a new authoritative source added to the Pack.

**Expect**

- next action `bootstrap_repository`; then `ingest_specification`, although the specification file is unchanged; `validate_specification` is listed as permitted;
- the revision then runs through the three gates in order, each candidate naming `CHG-0001`, and ends at `EXECUTION_READY`.

### CT-196 — Change record integrity

**Expect**

- a change record edited after its candidate exists: `CHANGE_RECORD_INVALID`; the candidate is not current; `baseline_<x>` is refused;
- a change record removed: the same;
- a change record edited or removed after its baseline exists: `CHANGE_RECORD_INVALID`, progress blocked, next action `resolve_blocker`, `execution_permitted` false; the baseline's integrity stays valid; restoring the record byte for byte clears the fault;
- two change records superseding the same record, or a supersession cycle, written by hand: `CHANGE_RECORD_INVALID`; no revision change is active; next action `resolve_blocker`.

### CT-197 — The permitted set is exact

**Given**

- the reference project in each of: `EXECUTION_READY` with no change record; directly after `open_change`; awaiting approval in a work revision; with one task in progress.

**Expect**

- `permitted_operations` holds exactly the entries of the BRS Section 40 table for that state, each with its actor and subject;
- every listed operation with actor `adapter` is accepted; every lifecycle, maintenance and runtime state operation that is not listed and is not the next action is refused.

### CT-198 — The item index covers the whole content

**Expect**

- changing a specification's title, or the order of two requirements, changes exactly one item, of kind `document`;
- changing one requirement changes exactly one item, of kind `requirement`;
- for every candidate type, replacing each item in the artefacts by its indexed digest leaves no content uncovered: any byte change to an artefact changes at least one item digest;
- a candidate whose index was computed from other artefacts than those it lists: `REVISION_DELTA_MISMATCH`.

### CT-199 — An invalid run file

**Expect**

- a run file that fails its schema, or whose task ID or run number disagree with its path: `TASK_STATE_INVALID`; the task is `rework_required`; the file's bytes do not change;
- `start_task` creates the next run number.

### CT-200 — A v0.3.0 core refuses an adopted project

**Given**

- the adopted project of CT-174; the v0.3.0 executable for the platform.

**Expect**

- `inspect_project` and every mutating operation return outcome `ERROR` with `PROV_UNSUPPORTED`;
- no file in the project changes.

### CT-201 — Adoption and v0.3.0 adapter files that were edited

**Given**

- v0.3.0 fixture whose `CLAUDE.md` was edited by hand; the Copilot variant whose `.vscode/settings.json` was edited by hand.

**Expect**

- `adopt_release` with `claude-code`: `ADAPTER_FILE_CONFLICT` naming `CLAUDE.md`; nothing written, including no adoption record;
- with replacement requested: the adoption succeeds and the result lists `CLAUDE.md` as replaced;
- the Copilot variant adopted with `copilot`: the pristine v0.3.0 prompt and instruction files are removed, the edited `.vscode/settings.json` is left in place and listed as left;
- a fixture initialised with an absolute core path that contains a space adopts without conflict: the command is recovered from the files;
- a `.claude/settings.json` in which one of the occurrences of the core command names another command: `ADAPTER_FILE_CONFLICT`.

### CT-202 — Adoption installs the target release

**Expect**

- with the target release absent from the Harness root and a release source given: the release is installed and the result names its directory;
- with a release of that version already installed and not byte-identical to the source: the command fails as `init` does (`INIT_RELEASE_MISMATCH`) and the project is unchanged;
- with the target release absent and no source reachable: `ADOPTION_UNSUPPORTED`.

### CT-203 — Grammar of `.engineering-harness-adapters`

**Expect**

- identifiers out of order, repeated, or unknown to the release; a `version` that differs from the governing release; an extra line; and `.engineering-harness-adapter` present in a v0.4.0 project: each `PROV_INCONSISTENT`;
- the file absent: valid, with no adapter installed.

### CT-204 — The managed block of `AGENTS.md`

**Expect**

- `adapter_add` on a project that has its own `AGENTS.md`: the block is appended; the project's text is byte-identical;
- `adapter_sync` after a release change replaces the content of the block only;
- removing the last adapter removes the block and leaves the project's text; a file that then is empty is deleted;
- two blocks, or a begin line with no end line: `ADAPTER_FILE_CONFLICT`.

### CT-205 — Operator commands are guarded

**Expect**

- `adopt_release`, `adapter_add`, `adapter_remove` and `adapter_sync` with `--adapter`, or with an agent session marker set: `GUARD_AGENT_CONTEXT`;
- without a controlling terminal: `GUARD_NOT_INTERACTIVE`;
- `init` runs without a terminal and with a marker set.

### CT-206 — Hooks find the launcher from anywhere in the project

**Expect**

- each adapter's hook registration, executed with a subdirectory of the project as working directory, runs `adapter_guard` of the project's launcher;
- the registration of each adapter uses the mechanism its agent documents for the project root, and no registration contains a machine-specific path;
- the `claude-code` registration, executed with `CLAUDE_PROJECT_DIR` unset, from the project root and from a subdirectory, exits with status 0 or 2 and never another.

### CT-207 — Gated and withdrawn items

**Expect**

- a task with a non-empty `human_gates` and no run is `gated`; `start_task` on it is `TASK_NOT_EXECUTABLE`; a task that depends on it is not ready;
- a gated task with a legacy state file of status `blocked`, as v0.3.0 wrote for it, is `gated`, not `blocked`;
- a task that is both gated and deferred is `deferred`;
- a `withdrawn` task behaves as a deferred one in selection, and its criteria are reported open by disposition.

### CT-208 — Hand-over equivalence does not depend on what the callers wrote

**Given**

- two copies; copy 1 as in CT-165; copy 2 completes the same task in one session as `claude-code`, with different notes, different changed paths and no `progress` event.

**Expect**

- the two runs are hand-over equivalent by BRS Section 64.7;
- they stop being equivalent when the final status, the definition digest or the set of verification controls with a result differs.

### CT-209 — A v0.3.0 project under a v0.4.0 core

**Given**

- the v0.3.0 fixture, not adopted; the v0.4.0 core.

**Expect**

- every conclusion equals what the v0.3.0 core gives for the same repository; the result validates against the v0.3.0 result schema;
- `open_change`, `list_tasks` and the other operations of v0.4.0 are refused and write nothing;
- `approve_pending` without a terminal: `GUARD_NOT_INTERACTIVE`.

### CT-210 — `bootstrap` in the maintenance regime

**Expect**

- the rendered `bootstrap` contains the three authoring operation names, `derive_project_ai_policy`, `PROJECT-PACK-BRIEF.md` and `approve_pending`, and the sentence that in the maintenance regime it reports status and refers to `maintain` and `execute`.

### CT-211 — Re-executing two finished tasks under one change record

**Given**

- tasks A and B `done`; a change record of kind `defect` listing both in `rework`.

**Expect**

- `open_change` naming a task that is not in the task set: `TASK_UNKNOWN`; naming one that is not done: `TASK_NOT_READY`;
- the record is `in_execution`; `permitted_operations` lists `reopen_task` for A and for B;
- before the first `reopen_task`, `abandon_change` writes a closure record and `reopen_task` is no longer listed; so does, on a second copy, a superseding `open_change` of reach `work`;
- after A's new run is done the record is still `in_execution`; after B's it is `completed`;
- `abandon_change` on it after the first `reopen_task`: `CHANGE_NOT_OPEN`.

### CT-212 — A work-reach change record that also re-executes a task

**Given**

- a change record of reach `work` that adds a task and lists a finished task in `rework`.

**Expect**

- `reopen_task` is `CHANGE_NOT_OPEN` until the record's Work Baseline exists, and is listed as permitted afterwards;
- the record is `completed` only when the added task and the re-executed task are both done.

## U. Signed records

All tests in this group use a project governed by v0.4.0 with the fixture signer chain, unless they say otherwise. BRS Section 73.

### CT-213 — A signed decision satisfies the gate

**Given**

- a pending specification candidate; the `product_domain` identity has an enrolled fixture key.

**When**

- `record_specification_decision` `approved` by that identity, signed with that key.

**Expect**

- `APR-SPEC-0001.yaml` has `identity_assurance.mechanism = ssh-signature`, `level = signed`, the key type and fingerprint and the head signer record, and reproduces its digest;
- `APR-SPEC-0001.yaml.sig` is an armoured OpenSSH signature with namespace `engineering-harness` over the 71 bytes of the record's digest;
- the state is `SPECIFICATION_APPROVED`; after `baseline_specification` the baseline is reported with `approval_assurance: signed`;
- where `ssh-keygen` is installed, `ssh-keygen -Y verify` with the allowed-signers file from `check_signers --allowed-signers` accepts the same signature.

### CT-214 — A decision written as a file is rejected

**Given**

- a pending candidate; a decision record for it written by hand, complete and with a correct self digest, in each of these forms: with declared assurance as v0.3.0 wrote it; with signed assurance and no signature file; with signed assurance and a signature made with a key that is not enrolled.

**Expect**

- `APPROVAL_IDENTITY_ASSURANCE_INVALID`, `APPROVAL_SIGNATURE_MISSING` and `APPROVAL_SIGNER_NOT_ENROLLED` respectively;
- in each case the candidate's decision is invalid: the state is `AWAITING_<X>_APPROVAL`, blocked, next action `resolve_blocker`; `baseline_<x>` is refused and writes nothing;
- after the file is removed the candidate is pending again and a signed decision is accepted.

### CT-215 — The key must be enrolled for the approver

**Expect**

- a decision by the `engineering` identity signed with the key enrolled for the `product_domain` identity: through the library nothing is written and the issue is `SIGNER_NOT_ENROLLED`; the same record placed as a file is `APPROVAL_SIGNER_NOT_ENROLLED`;
- a decision signed correctly by an identity that does not hold the gate's authority: `APPROVAL_IDENTITY_ASSURANCE_INVALID`, as BRS 1.2.

### CT-216 — The signature covers the record

**Given**

- a recorded, signed decision.

**Expect**

- the record's comment edited and its self digest recomputed: `APPROVAL_SIGNATURE_INVALID`;
- one byte of the signature changed: `APPROVAL_SIGNATURE_INVALID`;
- the signature file replaced by a valid signature of the same digest under another namespace: `APPROVAL_SIGNATURE_INVALID`;
- the signature file of another record copied in: `APPROVAL_SIGNATURE_INVALID`;
- in each case the baseline established on that decision loses its integrity and is not current; restoring the bytes restores it.

### CT-217 — The signer chain

**Expect**

- on a project without a chain, `enrol_signer` writes `SGN-0001` with no previous record, signed with the key it enrols; signed with any other key it writes nothing (`SIGNER_NOT_ENROLLED`);
- a second `enrol_signer` writes `SGN-0002`, which names `SGN-0001` by ID, path and digest and is signed with an enrolled key; signed with a key that is not enrolled it writes nothing;
- an identity that holds no authority in the Pack: `SIGNER_IDENTITY_UNKNOWN`; a key already in the chain, an RSA key of 1024 bits, a certificate: `SIGNER_KEY_INVALID`;
- each of these, made by hand, is `SIGNER_CHAIN_INVALID`: an anchor signed with another key; a second record without a signature file; two records that name `SGN-0001` as previous; `SGN-0003` present and `SGN-0002` missing; a signer record whose digest does not reproduce;
- while the chain is invalid no signed record verifies, the next action is `resolve_blocker`, `execution_permitted` is false, and nothing but restoring the chain changes that.

### CT-218 — Revocation

**Given**

- keys K1 and K2 enrolled for the `engineering` identity; decisions D1 and D2 signed with K1.

**When**

- `revoke_signer` for K1, signed with K2.

**Expect**

- the revoke record lists D1 and D2, and every other signed record made with K1, as retained; they stay valid;
- a new decision signed with K1 that names the signer record before the revocation as its head, placed as a file: `APPROVAL_SIGNER_NOT_ENROLLED`;
- a reserved operation signed with K1: nothing is written, `SIGNER_NOT_ENROLLED`;
- revoking K2, the last enrolled key: `SIGNER_LAST_KEY`;
- `check_signers --allowed-signers` no longer lists K1.

### CT-219 — Key types and signature vectors

**Expect**

- every vector of `annexes/signature-vectors.json` gives its expected result: OpenSSH signatures by Ed25519, ECDSA P-256, P-384 and P-521, RSA with SHA-256 and with SHA-512, and the two hardware-backed types verify; the altered and mismatched vectors do not;
- a signature the test signer makes is accepted by `ssh-keygen -Y verify`, and one `ssh-keygen -Y sign` makes is accepted by the core, for every key type OpenSSH on the test machine can generate;
- verification starts no process and gives the same result on every run.

### CT-220 — Adoption carries declared decisions, and only those

**Given**

- the adopted project of CT-174.

**Expect**

- every decision record the v0.3.0 fixture held, approved or rejected, is in `declared_decisions` and raises no issue;
- a further decision record with declared assurance, written by hand after adoption for a new candidate: `APPROVAL_IDENTITY_ASSURANCE_INVALID`; it satisfies no gate;
- a v0.3.0-style candidate, declared decision and baseline written by hand, together with an adoption record edited to list them and a recomputed digest: the adoption record's signature no longer verifies, so `ADOPTION_RECORD_INVALID`, nothing it lists is carried and the forged baseline is not valid;
- the first decision recorded after adoption is signed, and the Work Baseline established on it is reported as `signed` on an upstream that rests on declared approvals.

### CT-221 — Adoption needs the operator's signature

**Expect**

- `adopt_release` without a signing function or key writes nothing;
- on a project without a signer chain it writes the anchor and the adoption record in one mutation; when the mutation fails after the anchor was staged, neither exists;
- an identity that holds no authority in the Pack: `SIGNER_IDENTITY_UNKNOWN`, nothing written;
- on a project that already has a chain it writes no signer record and must be signed with an enrolled key.

### CT-222 — The CLI signs through OpenSSH and never reads the key

**Given**

- a pending candidate; a terminal; a passphrase-protected fixture key whose passphrase the test supplies through the askpass program OpenSSH documents.

**Expect**

- the decision is recorded and its signature verifies; the core process opened no private key file (the test traces file opens where the platform allows, and otherwise asserts that the key path was passed only to `ssh-keygen`);
- a private key file without a passphrase: `GUARD_KEY_UNPROTECTED`, nothing written;
- a wrong passphrase, a missing key file, `ssh-keygen` not on the search path: `GUARD_SIGNING_FAILED`, nothing written;
- a key that signs correctly but is not enrolled for the approver: `SIGNER_NOT_ENROLLED`, nothing written;
- neither `--key` nor `ENGINEERING_HARNESS_SIGNING_KEY`: the CLI exits 64.

### CT-223 — The anchor is accepted once per machine

**Given**

- a trust file named by `ENGINEERING_HARNESS_TRUST_FILE`.

**Expect**

- the command that writes the anchor records it in the trust file;
- with an empty trust file, a reserved operation first shows the anchor and asks for the last eight characters of its fingerprint; typed correctly, the anchor is recorded and the operation continues; anything else: `GUARD_ANCHOR_UNTRUSTED`, nothing written;
- with the project's signer chain replaced by another self-consistent chain: `GUARD_ANCHOR_CHANGED`, naming both anchors; nothing is written until `trust_signers` is run and confirmed;
- read-only operations and adapter operations never read or write the trust file, and no derived state depends on it.

### CT-224 — Subject decisions are signed

**Expect**

- `record_task_decision` and `record_change_decision` write a signature file and refuse a signature that does not verify for the `engineering` identity;
- a `reinstated` decision for a deferred task, written by hand without a valid signature: the task stays `deferred`; the record is reported as an error and `execution_permitted` is false until it is removed;
- a `deferred` decision written by hand without a valid signature: the task keeps the status its runs give it; the record is reported in the same way.

### CT-225 — `check_signers`

**Expect**

- it reports the anchor, each key with identity, type, fingerprint and status, and the faults of the chain, and writes nothing;
- it warns while only one key is enrolled and while an identity that holds an authority has no key;
- `--allowed-signers` prints one line per enrolled key that is not revoked, in the OpenSSH allowed-signers format, restricted to the namespace `engineering-harness`.

### CT-226 — An agent cannot ask OpenSSH to sign through a guarded tool call

**Expect**

- `adapter_guard` denies, in each hook format, a shell command that runs `ssh-keygen` with `-Y sign`, alone or inside a pipeline;
- it allows `ssh-keygen -Y verify`, `ssh-keygen -l` and a command that only mentions the words in a quoted string of another program;
- `enrol_signer`, `revoke_signer` and `trust_signers` are denied as operator commands (CT-205).

# The acceptance scenario on a clone of mentor

BRS Section 72.3. Steps 1 to 3 run on a clone with the v0.4.0 core. The human acts are yours: the adoption command, the approval at the work gate, and the deferral of TASK-16. Each of the three needs your signature, made by your own OpenSSH with a key you choose. Step 4 runs in the order you set (D-09): Claude Code CLI, which I operate, then Codex CLI and Copilot CLI, which you operate.

| Step | Automated check | On the clone | Needs you |
| --- | --- | --- | --- |
| 1 Adoption | CT-174, CT-200, CT-201, CT-220, CT-221 on the v0.3.0 fixture | state `EXECUTION_READY`; the digest of every file under `baselines/`, `spec/`, `architecture/`, `ai/` and `work/`, and of every v0.3.0 file under `evidence/`, equal before and after; the four v0.3.0 Claude Code files replaced; no decision record created; the anchor and the signed adoption record present; three baselines reported as resting on declared approvals | run `adopt_release` with your identity and key |
| 2 Change and added task | CT-145, CT-146, CT-178 | the candidate's item delta reads 16 `task` unchanged and 1 added | approve at `gate://work-baseline`, signed |
| 3 New baseline, carry-over, deferral | CT-148, CT-164, CT-168, CT-171, CT-213 | `WORK-0002` supersedes `WORK-0001` and is reported as `signed`; 15 tasks `done` with their legacy files byte-identical; TASK-16 `deferred`; its seven criteria open, `AC-NFR-008-01` not delivered | record the deferral, signed |
| 4a Each agent alone | CT-179 to CT-187, CT-206 | on its own clone, each agent runs `bootstrap status`, `maintain status`, `execute status` and one complete `execute` of the added task, and `check_adapters` reports no difference; the three runs are hand-over equivalent to each other | run the Codex and the Copilot clone |
| 4b Hand-over | CT-165, CT-208 | on a fourth clone the run of the added task names `claude-code`, `codex`, `copilot` in that order and is hand-over equivalent to the runs of 4a; `git status` shows nothing changed outside the task's scope and `work/state/` | run the Codex and Copilot sessions |

Step 4 compares structure, not text: two agent sessions never write the same notes or the same code, so byte equality is asserted only by the scripted CT-165. Step 4a is how "each must pass independently against the same Harness contract" is checked: the contract is the same core, the same permitted operations and the same run schema for all three, and each agent's run must satisfy them without the other two.
