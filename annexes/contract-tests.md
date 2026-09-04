# Engineering Harness v0.3.0 — Definitive Contract Tests

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

### CT-035 — Rejected candidate cannot later be approved

**Given**
- persisted rejection decision for candidate A;
- later approval evidence attempts candidate A.

**Expect**
- invalid decision chain;
- new candidate required.

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

### CT-041 — Specification changes after approval

**Given**
- historically valid Specification Baseline;
- `/spec/**` differs from approved candidate.

**Expect**
- historical validity remains valid;
- currentness = stale;
- architecture and downstream execution cannot rely on it.

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
- Specification currentness fails.

**Expect**
- state recomputed to highest supported state;
- no forward-only `EXECUTION_READY` flag remains authoritative.

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

## CT-137 — Explicit Harness root required

**Given**
- project root is supplied;
- no `harness_root` is supplied to the core.

**Expect**
- core invocation is rejected as caller/usage configuration error;
- no repository inspection/mutation occurs.

**CLI variant**
- `--harness-root` absent;
- `ENGINEERING_HARNESS_ROOT` absent.

**Expect**
```text
exit = 64
```

## CT-138 — NFC-normalised mapping-key collision

**Given**
- governed YAML/JSON contains two distinct parsed mapping keys that normalise to the same NFC string.

**Expect**
```text
CANONICALISATION_KEY_COLLISION
outcome = INVALID
```
No digest is produced.

