# Engineering Harness v0.4.0 — BRS change set

**Status:** APPROVED on 2026-11-13 with decision D-06 option (c), signed decisions. Revision 4 adds Section 73 and the changes it causes, all marked **[D-06c]**. Those additions were written after the approval and are flagged in `DECISIONS.md` Section 4 where they touch D-07 and D-08.
**Base document:** BRS 1.2 (Engineering Harness v0.3.0), the copy the v0.3.0 core implements. See decision D-01: this repository still carries BRS 1.1 under `docs/v0.3.0/`.
**Result when approved:** BRS 2.0, Engineering Harness v0.4.0, published as `docs/v0.4.0/BRS.md`.
**Companions:** `CONTRACT-TESTS-CHANGES.md`, `DECISIONS.md`, `AGENT-SURFACES.md`.

## 0. Conventions

- Each change is marked **REPLACE**, **ADD** or **DELETE** against a BRS 1.2 section. Text in a change block is the proposed normative wording.
- Existing section numbers, FR, AC and CT identifiers never change. New sections are 62 to 73. New requirements are FR-050 to FR-060 (Section 2.9), new acceptance criteria AC-043 to AC-071, new contract tests CT-141 to CT-226. CT-139 and CT-140 are retired.
- A marker such as **[D-05]** means the wording follows the recommended option of that decision in `DECISIONS.md`. If you choose differently, only the marked text changes.
- "v0.3.0 record" means a record written by a v0.3.0 core. No rule below edits, moves or rewrites a v0.3.0 record.

## 1. What changes, in one table

| Area | BRS 1.2 | BRS 2.0 |
| --- | --- | --- |
| Revision after a Work Baseline | A side effect of state recomputation; the core accepts operations it did not offer | Starts from a change record; every step is the next action or a listed permitted operation (Sections 40, 62, 63) |
| What the approver sees | The whole candidate | The candidate plus what was added, changed and removed against the baseline it supersedes, bound into the candidate digest (Section 63.4) |
| Runtime state | Written by hand by the adapter; never read by the core (FR-036) | Written and read only by core operations under a release schema; every write names the caller (Section 64) |
| Finished tasks under a new Work Baseline | Undefined | Derived by rule from definition digests (Section 64.5) |
| Not executing a task | Not possible | Deferred or withdrawn by a human decision (Section 65) |
| Change made outside a task | Invisible | Can be registered and accepted by decision, and is reported as such (Section 66) |
| Moving to a newer release | Out of scope; a version change makes every baseline stale | Explicit adoption with an adoption record; baselines stay current when the effective controls are unchanged (Section 67) |
| Recording a human decision | Any caller of the CLI; identity declared | Reserved operations; the CLI refuses agent contexts and requires a terminal confirmation (Section 68); the record is valid only with an SSH signature by a key enrolled for the approver (Section 73) **[D-06c]** |
| Adapters | `claude-code`, `copilot`; one per project; core location substituted into files | `claude-code`, `codex`, `copilot`; any subset; one authored source; core location in an agent-neutral launcher (Sections 69, 70) |

## 2. Amendments to existing sections

### 2.1 Title block and Section 1 (Purpose)

**REPLACE** the title block version lines with: `Version: 2.0`, `Release: Engineering Harness v0.4.0`.

**ADD** to the list of questions in Section 1:

```text
- Which change records are open, and is a revision in progress?
- What changed between a candidate and the baseline it would supersede?
- Which Work Item is to be executed next, and what is the state of every Work Item?
- Which adapters are installed, and do their files match the release?
- Which operations will the core accept now, and from whom?
```

### 2.2 Section 3 (Terminology)

**ADD:**

> **Maintenance regime.** The condition of a project governed by v0.4.0 or later whose `baselines/work/` holds at least one baseline record, valid or not. Otherwise the project is in the bootstrap regime.
>
> **Governing Work Baseline.** The lineage head of the Work chain when it is historically valid, whether or not it is current.
>
> **Change record.** The immutable, content-addressed statement of why a project in the maintenance regime is to be changed. Section 62.
>
> **Revision.** The sequence of lifecycle operations that replaces one or more baselines under exactly one change record. Section 63.
>
> **Reach.** How far up the baseline chain a change record extends: `none`, `execution`, `work`, `architecture` or `specification`. Section 62.3.
>
> **Satisfied; settled.** A chain is *satisfied* for a change record when its lineage holds a baseline record, head or superseded, that reproduces its digest and whose candidate names that record or a planned record it supersedes. It is *settled* when it is satisfied and its head baseline is current.
>
> **Work revision.** The condition in which the active revision change has reach `work`. In a revision of wider reach the task set and every effective status are those of the governing Work Baseline until the new Work Baseline exists.
>
> **Item.** An identified element inside a candidate artefact. Section 63.4.
>
> **Run.** One execution of one Work Item, recorded by the core. Section 64.
>
> **Disposition.** A human decision that a Work Item is deferred or withdrawn. Section 65.
>
> **Adoption.** The explicit, recorded change of the release that governs a project. Section 67.
>
> **Reserved operation.** An operation that records a human decision. **Operator command.** A distribution command that changes the governing release or the installed adapters. Only a human operator may invoke either. Section 68.
>
> **Launcher.** The agent-neutral project file through which every adapter invokes the core. Section 69.4.
>
> **Signed record.** A decision record, subject decision, adoption record or signer record together with its signature file. **Signer.** An SSH public key enrolled for one identity of the Project Engineering Pack. **Signer chain.** The append-only sequence of signer records of a project. **Anchor.** The first record of the signer chain. Section 73. **[D-06c]**

### 2.3 Section 4 (Authority model)

**ADD** rows:

| Concern | Authority |
| --- | --- |
| Statement of a change | Human operator; recorded by the core |
| Reach of a change | Harness core, from the release's maintenance workflow and the operator's request (Section 62.3) |
| Runtime task state | Harness core |
| Task disposition | Required human authority (`engineering`) |
| Acceptance of a registered change | Required human authority (`engineering`) |
| Adoption of a release | Human operator, who signs the adoption record; verified and recorded by the core |
| Enrolment and revocation of a signing key | Human operator holding an enrolled key; verified and recorded by the core |
| Custody of a private signing key | The human it belongs to. The core never reads one |

### 2.4 Section 5 (Human control plane)

**ADD** after the table of mandatory bootstrap approvals:

> The maintenance regime adds two decisions, both owned by `engineering`:
>
> | Decision | Gate | Required authority |
> | --- | --- | --- |
> | Defer, withdraw or reinstate a Work Item | `gate://task-disposition` | `engineering` |
> | Accept or reject a registered change | `gate://registered-change` | `engineering` |
>
> A revision never removes or weakens a baseline gate. Each baseline a revision replaces is approved at its own gate by its own authority.

### 2.5 Section 6 (Scope)

**ADD** to 6.1: change records; revisions; candidate revision context and delta; the permitted-operation set; runtime task state operations; task selection; task dispositions; registered changes; release adoption; the reserved-operation guard; signed records and the signer chain; adapter installation, removal and verification.

**ADD** to 6.2: custody, generation and protection of private signing keys; a public-key infrastructure or certificates; recovery of a signer chain whose keys are all lost.

**REPLACE** in 6.2 the entry "automatic Harness-version migration" with "silent or automatic Harness-version migration (adoption is explicit, Section 67)".

**REPLACE** the paragraph that follows the 6.2 list with:

> Work Item execution is performed by an AI agent through the adapter command `execute`. The core selects the Work Item, validates and records its runtime state (Section 64) and performs no implementation work. The core remains outside the scope of an execution engine: it starts no agent, schedules nothing and runs no verification command.

### 2.6 Section 7 (Clean project contract)

**REPLACE** the first lines of the project tree with:

```text
project/
├── .engineering-harness-template
├── .engineering-harness-adapters          (present when at least one adapter is installed)
├── AGENTS.md, harness, harness.cmd        (present when at least one adapter is installed)
├── adapter files of each installed adapter
```

**ADD** to the tree under `evidence/`: `changes/`, `adoptions/`, `decisions/`, `signers/`. The four directories are created by the first operation that writes into them. They are not required directories under FR-020, so a project without them, such as an adopted v0.3.0 project, is structurally valid. **ADD** to the list of what a fresh project must not contain: change records, adoption records, runs.

### 2.7 Section 8 (Filesystem ownership)

**REPLACE** the `/work/state/**` row and **ADD** rows:

| Path | Owner | Harness write rule |
| --- | --- | --- |
| `/work/state/**` | Harness core | Runtime state operations only (Section 64); never part of a validation subject; a v0.3.0 state file is read and never rewritten |
| `/evidence/changes/**` | Harness | Append-only |
| `/evidence/adoptions/**` | Harness | Append-only |
| `/evidence/decisions/**` | Harness | Append-only |
| `/evidence/signers/**` | Harness | Append-only |
| `<record>.yaml.sig` beside a signed record | Harness | Written once with its record; never rewritten |
| Adapter overlay files, the managed block of `AGENTS.md`, `harness`, `harness.cmd`, `.engineering-harness-adapters` | Harness distribution | Adapter operations only (Section 69); never part of a fingerprint, validation subject or candidate |

**ADD:**

> Every path in this table except `/src`, `/tests` and `/infra`, together with `.engineering-harness-template`, is a **reserved path**. No run may report a reserved path as changed, whatever the Work Item's `repository_scope` says (Section 64.4), and no registered change may name one (Section 66.2). Existing Work Items need no edit to protect the files of an adapter installed later.

### 2.8 Section 9 (Executable contract set)

**ADD** families:

> **9.12 Maintenance:** change record; change closure; subject decision (task disposition, registered change).
> **9.13 Runtime state:** run; task result (the completion input document); legacy task state.
> **9.14 Adoption:** adoption record.
> **9.15 Adapters:** adapter manifest; installed-adapter provenance.
> **9.16 Workflows:** maintenance workflow; execution workflow.
> **9.17 Signatures:** signer record; signature assurance. **[D-06c]**

**REPLACE** "Every governed YAML document shall contain `schema_version: 1`" with:

> Every governed YAML document shall contain `schema_version: 1`. A release may add optional fields to a version-1 schema, add enumeration values and relax a minimum. It shall not remove a field, make an optional field required, or change the meaning or digest of a document that was valid under an earlier release from which it declares adoption (Section 67.7). **[D-12]**

### 2.9 Section 11 (Functional requirements)

**REPLACE** FR-030's file list with `.engineering-harness-template`, `.engineering-harness-adapters`, `engineering/harness.yaml`, and add: "In a project governed by v0.3.0 the core reads `.engineering-harness-adapter` under the v0.3.0 grammar."

**REPLACE** FR-031 with:

> The project shall remain governed by its recorded Harness release. A newer available release shall not silently replace it. The governing release changes only through `adopt_release` (Section 67).

**ADD** to FR-032:

> A release declares the core contract it requires. A core resolves a release only when it implements that contract; otherwise the resolution status is `UNSUPPORTED` and nothing is written (Section 71.3).

**ADD** to FR-033:

> `.engineering-harness-adapters` uses the same encoding rules and contains exactly:
>
> ```text
> version=<v-prefixed semantic version>
> adapters=<adapter identifier>[,<adapter identifier>...]
> ```
>
> The identifiers are unique, in ascending code-point order, and each names an adapter of the governing release. `version` equals the governing release. The file is absent when no adapter is installed. Any violation, and the presence of `.engineering-harness-adapter` in a project governed by v0.4.0, produces `PROV_INCONSISTENT`.

**REPLACE** FR-035 with "Adapter distribution is defined in Section 69." **REPLACE** FR-036 with "Adapter commands are defined in Section 70; runtime state in Section 64." The runtime-state grammar of FR-036 becomes the legacy state grammar of Section 64.6 and is no longer written.

**ADD:**

> **FR-050 — Change records.** Section 62.
> **FR-051 — Revisions.** Section 63.
> **FR-052 — Permitted operations.** Section 40.
> **FR-053 — Runtime state.** Section 64.
> **FR-054 — Task dispositions.** Section 65.
> **FR-055 — Registered changes.** Section 66.
> **FR-056 — Release adoption.** Section 67.
> **FR-057 — Reserved operations and operator commands.** Section 68.
> **FR-058 — Adapters and adapter commands.** Sections 69 and 70.
> **FR-059 — Core contract of a release.** Section 71.3.
> **FR-060 — Signed records.** Section 73. **[D-06c]**

### 2.10 Section 16 (Canonicalisation)

**ADD** rows to 16.4:

| Object / field | Sort key |
| --- | --- |
| Candidate `items` | `kind`, then `id` ascending |
| Candidate `revision.delta` lists (`added`, `changed`, `removed`) | artefact lists by `path`; item lists by `kind`, then `id` |
| Adoption record `baselines` | `type` ascending |
| Adoption record baseline `items` | `kind`, then `id` ascending |
| Change record `rework` | task ID ascending |
| Adoption record `declared_decisions` | `id` ascending |
| Signer record `retained` | `path` ascending |

**ADD** to 16.6 and to the annex self-digest table: change record `change.binding.digest`; change closure `closure.binding.digest`; subject decision `decision.binding.digest`; adoption record `adoption.binding.digest`; signer record `signer.binding.digest`. Runs carry no self digest and are not canonicalised objects. A signature file is not a governed YAML document and is outside canonicalisation: it signs the self digest of its record (Section 73.2).

### 2.11 Sections 18 and 21 (Validation subjects and candidates)

**ADD** to Section 18:

> In the maintenance regime a validation subject constructed by `validate_*` also binds the revision: the change record, by ID and digest, and the baseline to be superseded, by ID and digest. A subject constructed in the bootstrap regime has no such member, so every v0.3.0 subject keeps its digest. Validation evidence is therefore specific to one change record: content validated under one change record is not validated under another.
>
> In the maintenance regime a chain has up to two subjects:
>
> - The **baseline subject** is rebuilt from current facts with the revision member that the head baseline's own candidate records, or with none when that candidate records none, and with the release that candidate binds (Section 29). It is the subject used for the currentness of the head baseline (Section 29), for "Work graph valid" (Section 43) and for the upstream and Project AI Policy bindings of downstream chains. A baseline established in a revision therefore stays current after its change record is completed, for as long as its artefacts and bindings match, and opening a change record makes no baseline stale.
> - The **revision subject** exists only for the chain X of the active revision change C (Section 37). It binds C, X's head baseline and the governing release. It is the subject of `validate_<x>`, of rows 9 to 11 and 13 of Section 37 and of the candidate offered for decision. No other chain has a revision subject.

**ADD** to the candidate binding list of Section 21:

> - the item index of the candidate artefacts (Section 63.4); and
> - in the maintenance regime, the revision context: the change record and the baseline to be superseded, as bound by the subject, and the delta (Section 63.4).

**ADD** to Section 21:

> In the maintenance regime a candidate is offered for decision and can establish a baseline only when its subject digest equals the revision subject of its chain. Its revision context then names the active revision change (Section 63.2) and the head baseline of its chain. A candidate without a revision context, or naming another change record, is never offered for decision and never establishes a baseline in the maintenance regime. The candidate of a head baseline keeps its role in the currentness of that baseline.
>
> While a candidate's artefacts match the working tree, the core recomputes its item index and its delta. A difference invalidates the candidate (`REVISION_DELTA_MISMATCH`).

### 2.12 Section 22 (Human decisions)

**REPLACE** the paragraph beginning "For v0.3.0:" through "It does not claim cryptographic authentication." with:

> Identity assurance in a project governed by v0.4.0 is: **[D-06c]**
>
> ```text
> identity_assurance.mechanism = ssh-signature
> identity_assurance.level = signed
> ```
>
> The recorded approver identity matches the identity assigned to the required authority in the Project Engineering Pack, and the decision record carries a signature made with a key enrolled for that identity (Section 73). A decision record without such a signature satisfies no gate.
>
> One exception keeps the BRS 1.2 assurance (`declared-project-identity`, `declared`): a decision recorded under a release without signed decisions, when an adoption record lists it (Section 67.4). Such a decision keeps its declared assurance and gains nothing: it claims no cryptographic authentication, and every result that reports a baseline resting on it says so.
>
> A decision is captured only through a reserved operation under the guard of Section 68. The decision record states how it was captured, including the confirmation the guard obtained.

**ADD:** "Decisions on a Work Item or on a registered change follow the same rules, with the subject of Section 65 or 66 in place of a candidate."

### 2.13 Section 25 (Baseline establishment)

**ADD** to the re-verification list:

> - in the maintenance regime, the candidate's change record exists, reproduces its digest and is the active revision change (Section 63.2);
> - the candidate's item index and delta reproduce;
> - the approval's identity assurance satisfies Section 22: its signature verifies under Section 73.3, or an adoption record carries it. **[D-06c]**

### 2.14 Section 29 (Validity and currentness)

**ADD** after "A baseline is current only when":

> **Release binding through adoption.** A candidate and its validation evidence bind the Harness release under which they were written. That binding is satisfied by the governing release when the two are equal. It is also satisfied when an unbroken chain of valid, control-equivalent adoption records (Section 67) leads from the bound release to the governing release and the first record of the chain lists the candidate as the candidate of a baseline.
>
> In the second case every rule of this BRS that compares that record's validation-subject digest with a subject rebuilt from current facts rebuilds it for the release the record binds (Section 18). This applies to candidate currentness (Section 21), to the latest authoritative validation of the subject (Sections 17.2 and 36) and to "Work graph valid" (Section 43), which is always evaluated on the baseline subject of the governing Work Baseline. Validation evidence for a revision subject counts only for rows 9 to 13 of Section 37. Every other binding is compared exactly as before.
>
> An adoption record that is missing, does not reproduce its digest or is not control-equivalent satisfies nothing: the binding fails and the baseline is stale.
>
> The Project AI Policy binds no release. It is current when Section 31 holds under the governing release.

**ADD** at the end:

> A baseline that a revision will supersede remains the lineage head until then, and remains historically valid after it is superseded. No operation edits it.

### 2.15 Section 30 (Staleness propagation)

**ADD:**

> A control-equivalent adoption changes no engineering-resolution digest and propagates no staleness. An adoption that is not control-equivalent is refused in v0.4.0 (Section 67.3). **[D-07]**

### 2.16 Section 32 (Work contract)

**ADD** to the list of Work Item content: "change references (`change_refs`), optional".

**ADD** to the list of deterministic validations. The second evaluates only facts the validation subject binds. The first and third also read the change records the Work Items list; a listed record that is missing or does not reproduce its digest is `CHANGE_RECORD_INVALID` and is reported before any control runs.

> - every change reference resolves to a change record held by the repository;
> - when the validation subject binds a revision, every Work Item whose `task` item is added or changed against the baseline to be superseded lists the change record of the revision, or a planned record that it supersedes, in `change_refs`, and keeps every `change_refs` entry it has in that baseline;
> - a Work Item whose `requirement_refs` or `acceptance_refs` is empty lists at least one change record whose kind is `documentation` or `defect` and which declares at least one acceptance statement. **[D-02]**

**REPLACE** "A requirement/acceptance criterion requiring implementation coverage must be covered by at least one Work Item." with the same sentence followed by: "A deferred or withdrawn Work Item still counts as coverage for validation. Whether its criteria are met is reported by Section 65.4, not by validation."

### 2.17 Sections 33 and 34 (Operations)

**ADD** to the read-only operations of Section 33:

```text
check_maintenance
check_adapters
check_signers
list_tasks
select_task
```

**ADD** to Section 34, after the lifecycle operations:

```text
Maintenance operations:   open_change, abandon_change
Runtime state operations: start_task, record_task_progress, block_task, complete_task, reopen_task
Reserved operations:      record_specification_decision, record_architecture_decision, record_work_decision,
                          record_task_decision, record_change_decision
```

| Operation | Execution ownership | Who may invoke it |
| --- | --- | --- |
| `open_change` | Adapter-assisted under Harness control: the operator states the change, the core records it | adapter or operator |
| `abandon_change` | Deterministic core | adapter or operator |
| `start_task`, `record_task_progress`, `block_task`, `complete_task`, `reopen_task` | The core records what the caller reports and validates what it can check deterministically | adapter or operator |
| `record_*_decision`, `record_task_decision`, `record_change_decision` | Core captures explicit human decision | operator only |

**ADD:**

> The distribution commands are `init`, `adopt_release`, `enrol_signer`, `revoke_signer`, `trust_signers`, `adapter_add`, `adapter_remove`, `adapter_sync`, `render_adapters`, `adapter_guard`, `pack_questionnaire`, `pack_brief`, `approve_pending` and `reject_pending`. They share the executable and are not lifecycle operations. `approve_pending` and `reject_pending` are short forms of the three `record_*_decision` operations on a baseline candidate and are reserved in the same way. `adopt_release`, `enrol_signer`, `revoke_signer`, `trust_signers`, `adapter_add`, `adapter_remove` and `adapter_sync` are operator commands (Section 68).
>
> Every lifecycle, maintenance, runtime state and reserved operation is accepted only when the core's current result offers it, as the next action or in `permitted_operations` (Section 40).

### 2.18 Sections 35 to 37 (Lifecycle)

The sixteen states are unchanged. No state is added.

**ADD** to Section 37, after the existing table:

> **Maintenance regime.** In the maintenance regime the state and the next action are taken from the first row below that applies. Where the State column says "as derived" or "as BRS 1.2" the state is the one Section 36 derives. In rows 9, 10, 11 and 13 it is the state the row names, also when X's head baseline is still current. C is the active revision change (Section 63.2), if there is one. X is the first chain in C's reach, from the top, that is not settled for C. `<X>` and `<x>` stand for that chain's names in the bootstrap table; for the Work chain these are `WORK_DECOMPOSITION_IN_PROGRESS`, `AWAITING_WORK_APPROVAL`, `WORK_APPROVED`, `validate_work_graph`, `correct_work_decomposition`, `record_work_decision` and `baseline_work`.
>
> | # | Condition | State | Progress | Next action kind | Next action |
> | --- | --- | --- | --- | --- | --- |
> | 1 | Pack incomplete or invalid; a lineage fault; a change record fault; a signer chain fault; a repository fault on the Project AI Policy; a failed readiness prerequisite on a current Work Baseline | as BRS 1.2 | as BRS 1.2 | as BRS 1.2 | as BRS 1.2 |
> | 2 | Engineering resolution not current; the observed Pack fingerprint equals the one the head Specification Baseline binds | `PROJECT_INPUT_READY` | ready | `HARNESS_OPERATION` | `bootstrap_repository` |
> | 3 | Engineering resolution not current; C has reach `specification` | `PROJECT_INPUT_READY` | ready | `HARNESS_OPERATION` | `bootstrap_repository` |
> | 4 | Engineering resolution not current, otherwise | `PROJECT_INPUT_READY` | blocked | `HUMAN_INPUT` | `open_change` |
> | 5 | The head of the Specification or Architecture chain is not current, and either there is no C or that chain is outside C's reach | as derived | blocked | `HUMAN_INPUT` | `open_change` |
> | 6 | Architecture Baseline current; Project AI Policy absent, invalid or not current | as derived | ready | `HARNESS_OPERATION` | `derive_project_ai_policy` |
> | 7 | No C; Work Baseline not current | as derived | blocked | `HUMAN_INPUT` | `open_change` |
> | 8 | No C; every baseline current | `EXECUTION_READY` | ready | `NO_ACTION` | `none_bootstrap_complete` |
> | 9 | C; X has a current undecided candidate | `AWAITING_<X>_APPROVAL` | ready | `HUMAN_DECISION` | `record_<x>_decision` |
> | 10 | C; X has a current approved candidate | `<X>_APPROVED` | ready | `HARNESS_OPERATION` | `baseline_<x>` |
> | 11 | C; X's artefacts cannot be read, or the latest authoritative validation of X's current subject is `FAIL` or `ERROR`, or the candidate for X's current subject was rejected | `<X>_IN_PROGRESS` | blocked | `REWORK` | `correct_<x>` |
> | 12 | C; X's artefacts equal those of X's head baseline | as derived | ready | `HARNESS_OPERATION` | the authoring operation of X |
> | 13 | C; otherwise | `<X>_IN_PROGRESS` | ready | `HARNESS_OPERATION` | `validate_<x>` |
>
> Rows 4, 5 and 7 carry the issue `CHANGE_RECORD_REQUIRED` when there is no C and `CHANGE_REACH_INSUFFICIENT` when C's reach does not include the chain that changed. When C exists, `open_change` in rows 4 and 5 has C as its subject and the result names the reach required: only a record that supersedes C with at least that reach, or abandoning C, changes the result, and a record that does not supersede C waits (Section 63.2). The candidates of rows 9 and 10 are those Section 21 allows to be offered, which name C. The authoring operations are `ingest_specification`, `derive_architecture` and `generate_work_items`.
>
> A change record fault in row 1 is a record, closure or supersession that is `CHANGE_RECORD_INVALID` (Section 62.2). For it the state is as derived, progress is blocked, the next action is `REWORK` `resolve_blocker`, no revision change is active and execution is prohibited, until the records reproduce again or the hand-written record is removed. A signer chain fault is `SIGNER_CHAIN_INVALID` (Section 73.4) and has the same effect, in either regime.
>
> Rows 2 and 6 need no change record: re-materialising `/engineering` for an unchanged Pack and re-deriving the Project AI Policy reproduce deterministic artefacts and replace no baseline.
>
> In row 12 the core also lists `validate_<x>` as permitted: it is the explicit statement that this chain needs no change under C, and its candidate carries a delta with nothing added, changed or removed.

### 2.19 Section 39 (Upstream-change transitions)

**ADD:**

> In the maintenance regime a changed valid Pack still derives `PROJECT_INPUT_READY`. The next action is `bootstrap_repository` only under an active revision change of reach `specification`; otherwise it is `open_change` (Section 37, rows 3 and 4).

### 2.20 Section 40 (Next-action contract)

**ADD** the action ID `open_change`.

**REPLACE** "There shall be at most one authoritative next bootstrap action." with:

> There shall be at most one authoritative next action. It names the next step of the bootstrap lifecycle or of the revision in progress.
>
> Operations that an operator may start at will are not next actions. The core lists them in `permitted_operations`. Each entry names the operation, the actor (`adapter` or `operator`) and the subject where one applies. An adapter performs only the next action, or a permitted operation whose actor is `adapter` and that the operator asked for through an adapter command.
>
> An operation that is neither the next action nor listed is refused and writes nothing. In the maintenance regime the refusal is `CHANGE_RECORD_REQUIRED` when no change record permits it and `CHANGE_REACH_INSUFFICIENT` when the active revision change excludes it. In every other case it carries the code its section names and, where none is named, the BRS 1.2 code `MUTATION_PRECONDITION_CHANGED`.

**ADD** the permitted set as a normative table:

> **Bootstrap regime.** Beside the next action, as the v0.3.0 core accepts them:
>
> | Operation | Actor | Listed when |
> | --- | --- | --- |
> | `ingest_specification` | adapter | the engineering resolution is current |
> | `derive_architecture` | adapter | the state is `SPECIFICATION_BASELINED`, `ARCHITECTURE_IN_PROGRESS` or `ARCHITECTURE_BASELINED` |
> | `derive_project_ai_policy` | adapter | the Architecture Baseline is current |
> | `generate_work_items` | adapter | the state is `ARCHITECTURE_BASELINED` with a current Project AI Policy, or `WORK_DECOMPOSITION_IN_PROGRESS` |
>
> **Maintenance regime.** Beside the next action:
>
> | Operation | Actor | Listed when | Subject |
> | --- | --- | --- | --- |
> | `open_change` | adapter | the release resolves | none |
> | `abandon_change` | adapter | Section 62.6 holds | each such change record |
> | the authoring operation of X | adapter | rows 11, 12 and 13 of Section 37 | C |
> | `validate_<x>` | adapter | rows 11, 12 and 13 | C |
> | `start_task` | adapter | Section 43 permits execution | each ready Work Item |
> | `record_task_progress`, `block_task` | adapter | the Work Item's latest run is open on its current definition | each such Work Item |
> | `complete_task` | adapter | as above, and Section 43 permits execution of the item | each such Work Item |
> | `reopen_task` | adapter | Section 64.4 | each such Work Item and change record |
> | `record_task_decision` | operator | a governing Work Baseline exists | each Work Item of its task set |
> | `record_change_decision` | operator | a registered change awaits decision | each such change record |
>
> An entry with actor `adapter` may also be invoked by an operator. An entry with actor `operator` is a reserved operation.

### 2.21 Section 41 (`bootstrap_repository`)

**REPLACE** step 2 with: "reread and reconcile `.engineering-harness-template` and `.engineering-harness-adapters`".

### 2.22 Section 42 (`inspect_project`)

**ADD** to the result list: the regime; the change records with their derived status; the revision in progress; the Work Item summary and the next runnable Work Item; the installed adapters and whether their files match the release; the signers (Section 73.8); the permitted operations. A pending gate in the maintenance regime carries the revision context of Section 63.4.

### 2.23 Section 43 (Execution readiness)

**REPLACE** the sentence "Any stale, invalid, missing or indeterminate required prerequisite prohibits execution." with:

> Any stale, invalid, missing or indeterminate required prerequisite prohibits execution, with one exception. **[D-03]**
>
> **Execution under a work revision.** While the active revision change has reach `work`, execution is permitted when every condition above holds except "Work Baseline current" and "Work graph valid", provided that the governing Work Baseline matches current facts in its release binding (Section 29), its engineering-resolution digest, its upstream Architecture Baseline and its Project AI Policy digest, and that the Work artefacts in the working tree can be read.
>
> In that case a Work Item is executable only when both its `task` item and its `graph_entry` item in the working tree have the digests the governing Work Baseline's item index records. A Work Item the revision adds, changes or removes is not executable until the new Work Baseline exists.
>
> No exception applies to a Specification Baseline, an Architecture Baseline or a Project AI Policy that is not current. A revision of reach `architecture` or `specification` therefore stops execution from its first changed artefact until its last baseline is established.

**REPLACE** "Execution is performed by the adapter `/execute` workflow (FR-036), never by a core operation." with "Execution is performed by an agent through `execute` (Section 70) and recorded through the runtime state operations (Section 64)."

`execution_permitted` in a result is true exactly when this section permits execution of at least the unchanged Work Items. It can therefore be true in a state other than `EXECUTION_READY`. `check_execution_readiness` returns outcome `OK` exactly when `execution_permitted` is true, and under a work revision lists the Work Items that are not executable. A change record fault (Section 37, row 1) prohibits execution.

### 2.24 Sections 45 and 46 (Append-only, record IDs)

**ADD** to Section 45: `evidence/changes/**`, `evidence/adoptions/**`, `evidence/decisions/**`, `evidence/signers/**`, and every signature file. A run whose status is `done` is never modified (Section 64.2).

**ADD** to Section 46:

```text
CHG-0001      change record            evidence/changes/
CLO-0001      change closure           evidence/changes/
DEC-0001      subject decision         evidence/decisions/
ADOPT-0001    adoption record          evidence/adoptions/
SGN-0001      signer record            evidence/signers/
RUN-0001      run, numbered per task   work/state/<TASK-id>/
```

A signature file has the name of its record followed by `.sig`, for example `evidence/approvals/APR-WORK-0002.yaml.sig`. Record scans ignore it; Section 73 reads it.

### 2.25 Sections 47 and 48 (Issue codes)

**ADD** these codes. The category is new for each group.

| Issue code | Category | Default outcome | Exit | Raised when |
| --- | --- | ---: | ---: | --- |
| `CHANGE_RECORD_REQUIRED` | maintenance | `BLOCKED` | 4 | no change record permits the operation or the observed change (Section 37 rows 4, 5, 7; Section 40) |
| `CHANGE_REACH_INSUFFICIENT` | maintenance | `BLOCKED` | 4 | the active revision change excludes the operation or the changed chain |
| `CHANGE_REACH_INVALID` | maintenance | `INVALID` | 3 | `open_change` with a reach below the minimum of the kind or of the record it supersedes |
| `CHANGE_NOT_OPEN` | maintenance | `BLOCKED` | 4 | `abandon_change`, `reopen_task` or a superseding `open_change` names a record whose status or content does not allow it |
| `CHANGE_RECORD_INVALID` | maintenance | `INVALID` | 3 | a change record or closure does not reproduce its digest, or a record has two successors, or supersession is cyclic |
| `CHANGE_REFERENCE_INVALID` | maintenance | `INVALID` | 3 | a Work Item breaks a rule of Section 32 on `change_refs` |
| `REVISION_DELTA_MISMATCH` | maintenance | `INVALID` | 3 | a candidate's item index or delta does not reproduce |
| `EXECUTION_NOT_PERMITTED` | runtime | `BLOCKED` | 4 | a runtime state operation that needs Section 43 while it prohibits execution |
| `TASK_UNKNOWN` | runtime | `INVALID` | 3 | the named Work Item is not in the task set |
| `TASK_NOT_READY` | runtime | `BLOCKED` | 4 | a dependency is not done, or the item awaits a baseline |
| `TASK_ALREADY_DONE` | runtime | `BLOCKED` | 4 | `start_task` on a done item |
| `TASK_NOT_EXECUTABLE` | runtime | `BLOCKED` | 4 | the item is deferred, withdrawn or gated |
| `TASK_RUN_NOT_OPEN` | runtime | `BLOCKED` | 4 | `record_task_progress`, `block_task` or `complete_task` without an open run on the current definition |
| `TASK_VERIFICATION_INCOMPLETE` | runtime | `INVALID` | 3 | `complete_task` without a result for a verification control |
| `TASK_VERIFICATION_FAILED` | runtime | `BLOCKED` | 4 | `complete_task` with a `FAIL` result |
| `TASK_SCOPE_VIOLATION` | runtime | `INVALID` | 3 | a reported or registered path is out of scope or reserved |
| `TASK_STATE_INVALID` | runtime | `INVALID` | 3 | a run or legacy state file cannot be read under its schema |
| `DECISION_SUBJECT_INVALID` | approval | `INVALID` | 3 | a subject decision names a Work Item or change record that cannot be decided |
| `DECISION_RECORD_INVALID` | approval | `INVALID` | 3 | a subject decision does not reproduce its digest, or a decision has two successors |
| `ADAPTER_UNKNOWN` | adapter | `INVALID` | 3 | `--adapter` names an adapter that is not installed |
| `ADAPTER_MISMATCH` | adapter | `INVALID` | 3 | the declared caller contradicts an agent session marker in the environment |
| `ADAPTER_FILE_MISSING` | adapter | `INVALID` | 3 | `check_adapters`: an overlay file or the managed block is absent |
| `ADAPTER_FILE_MODIFIED` | adapter | `INVALID` | 3 | `check_adapters`: an overlay file or the managed block differs from the release |
| `ADAPTER_FILE_CONFLICT` | adapter | `BLOCKED` | 4 | an adapter operation would overwrite a file it does not own |
| `ADOPTION_NOT_PERMITTED` | adoption | `BLOCKED` | 4 | a precondition of Section 67.2 on the project fails |
| `ADOPTION_UNSUPPORTED` | adoption | `ERROR` | 5 | the target release is unavailable or does not list the recorded release |
| `ADOPTION_NOT_EQUIVALENT` | adoption | `BLOCKED` | 4 | Section 67.3 |
| `ADOPTION_RECORD_INVALID` | adoption | `INVALID` | 3 | an adoption record does not reproduce its digest, its chain is broken, or its signature does not verify |
| `APPROVAL_SIGNATURE_MISSING` | approval | `INVALID` | 3 | a record that declares signed assurance has no signature file |
| `APPROVAL_SIGNATURE_INVALID` | approval | `INVALID` | 3 | a signature file cannot be parsed, names another namespace or key than its record, or does not verify over the record's digest |
| `APPROVAL_SIGNER_NOT_ENROLLED` | approval | `INVALID` | 3 | the signing key is not enrolled for the record's identity at the signer record it names, or was revoked and the record is not retained |
| `SIGNER_CHAIN_INVALID` | approval | `INVALID` | 3 | a signer record does not reproduce its digest, the chain has a gap or a fork, the anchor is not signed by its own key, or a later record is not signed by an enrolled key |
| `SIGNER_IDENTITY_UNKNOWN` | approval | `INVALID` | 3 | `enrol_signer` names an identity that holds no authority in the Project Engineering Pack |
| `SIGNER_KEY_INVALID` | approval | `INVALID` | 3 | a public key is of a type Section 73.2 does not accept, is malformed, or was enrolled before |
| `SIGNER_NOT_ENROLLED` | approval | `BLOCKED` | 4 | a reserved operation or operator command is signed with a key that is not enrolled for the required identity; `revoke_signer` names a key that is not enrolled |
| `SIGNER_LAST_KEY` | approval | `BLOCKED` | 4 | `revoke_signer` would leave no enrolled key |

`APPROVAL_IDENTITY_ASSURANCE_INVALID` keeps its BRS 1.2 meaning and is also raised for a decision record with declared assurance that no adoption record carries. **[D-06c]**

`ADAPTER_FILE_MISSING` and `ADAPTER_FILE_MODIFIED` have the outcome above in `check_adapters`. In every other operation they are warnings and never change a lifecycle conclusion.

The guard of Section 68 is raised by the CLI before any operation runs. Its codes, `GUARD_AGENT_CONTEXT`, `GUARD_NOT_INTERACTIVE`, `GUARD_CONFIRMATION_FAILED`, `GUARD_ANCHOR_UNTRUSTED`, `GUARD_ANCHOR_CHANGED`, `GUARD_KEY_UNPROTECTED` and `GUARD_SIGNING_FAILED`, have category `guard`, outcome `BLOCKED` and exit 4, and appear in the result document of the refused command. They join the three distribution-layer codes v0.3.0 already has for `approve_pending` and `reject_pending` (`DECISION_PROVENANCE_UNRESOLVED`, `DECISION_NOTHING_PENDING`, `DECISION_GATE_UNKNOWN`), which Section 47 now lists.

**ADD** to the distribution-layer codes of Section 47 the codes of `init`: `INIT_GIT_FAILED`, `INIT_SOURCE_MISSING_PATH`, `INIT_SOURCE_SYMLINK`, `INIT_VERSION_MISMATCH`, `INIT_INSTALL_LOCKED`, `INIT_RELEASE_MISMATCH`, `INIT_RELEASE_UNUSABLE`, `INIT_TARGET_APPEARED`, `INIT_STAGE_EXISTS`, `INIT_IO_ERROR`, `INIT_ANSWER_INVALID`, `INIT_PROVENANCE_UNRESOLVED`, `INIT_ADAPTER_UNKNOWN`, `INIT_ADAPTER_MANIFEST_INVALID` and `INIT_ADAPTER_CONFLICT`. Owner ruling RUL-66, 2026-11-23.

Section 47 also lists the codes of `init`, all prefixed `INIT_`. Twelve exist in v0.3.0; `INIT_ADAPTER_UNKNOWN`, `INIT_ADAPTER_MANIFEST_INVALID` and `INIT_ADAPTER_CONFLICT` are added for a release of core contract 2 (Section 69.5). `adopt_release` reports an `INIT_*` code when installing the target release fails as `init` does (Section 67.1). Section 47 fixes only their names. This BRS defines no category, outcome or condition for them.

No existing code changes meaning.

### 2.26 Section 49 (CLI contract)

**ADD:**

> Every operation accepts `--adapter <identifier>`. An adapter passes its own identifier on every call. The value shall name an adapter installed in the project; otherwise the operation fails with `ADAPTER_UNKNOWN` and writes nothing. The result reports the declared adapter in `provenance.adapter` and the installed adapters in `provenance.installed_adapters`.
>
> A maintenance or runtime state operation that writes requires exactly one of `--adapter <identifier>` and `--operator`; with neither or both the CLI exits 64. The record names the caller as declared. The declaration is not verified, with one check: when an agent session marker of the adapter manifest is present in the environment and the caller declares `--operator` or an adapter other than the marker's, the operation fails with `ADAPTER_MISMATCH`.
>
> A reserved operation and an operator command reject `--adapter` (Section 68).
>
> On a project governed by v0.3.0 the result conforms to the v0.3.0 result schema, `provenance.adapter` is taken from the v0.3.0 marker and `--adapter` has no effect other than on the guard.

### 2.27 Section 52 (Acceptance criteria)

**REPLACE** AC-026 "at most one authoritative bootstrap next action" with "at most one authoritative next action, and the complete set of permitted operations (Section 40)".

**ADD** to AC-028: "except as Section 43 permits under a work revision."

**REPLACE** AC-041 with "Adapter distribution conforms to Section 69 (AC-059 to AC-062)." **REPLACE** AC-042 with "Adapter commands conform to Section 70 and hold no selection rule, transition rule or state grammar; runtime state conforms to Section 64."

**ADD** AC-043 to AC-071:

> **AC-043 — Change record.** A revision in the maintenance regime starts only from a change record. The record is immutable and content-addressed. Every candidate of the revision names it, every baseline reaches it through its candidate, and every Work Item the revision adds or changes lists it.
>
> **AC-044 — Offered steps.** For every step of a revision the core returns the step as the next action or lists it as a permitted operation, with its actor and subject.
>
> **AC-045 — Nothing unoffered.** A lifecycle, maintenance, runtime state or reserved operation that the core's current result does not offer is refused and writes nothing.
>
> **AC-046 — Identity of unchanged content.** An artefact that a revision leaves byte-identical has the same digest in the superseding candidate. The candidate records what was added, changed and removed against the baseline it supersedes, and an item index or delta that does not reproduce invalidates the candidate.
>
> **AC-047 — Supersession.** A baseline established by a revision supersedes the previous head. The superseded baseline remains historically valid and its bytes are unchanged. A change record whose revision is complete is never made active again by a later revision.
>
> **AC-048 — Gates in a revision.** A revision is approved at the gate of each baseline it replaces, by that gate's authority, and at no other.
>
> **AC-049 — Runtime state ownership.** Runtime state is written only by core operations, validates against the release schema, and records on every write the caller as declared.
>
> **AC-050 — Task selection.** With a named Work Item the core returns that item when it is ready and no item otherwise. Without a name it returns the first ready item in execution-graph order whose run is in progress, and if there is none the first ready item that is pending or requires rework. An item it returns can be started.
>
> **AC-051 — Carry-over.** Under a superseding Work Baseline a Work Item whose definition digest is unchanged keeps its status, a Work Item whose definition changed requires rework, and the state of a removed Work Item remains as history.
>
> **AC-052 — Finished work is not overwritten.** Starting a finished Work Item is refused. Reopening it under a change record creates a new run and leaves the earlier run byte-identical.
>
> **AC-053 — Disposition.** A Work Item is deferred or withdrawn only by a decision of the `engineering` authority. Such an item is never selected or started.
>
> **AC-054 — Open criteria.** Every acceptance criterion and every change-record acceptance statement referenced by a Work Item that is not done is reported as open, with the items and statuses that keep it open.
>
> **AC-055 — Maintenance status.** `check_maintenance` reports the change records with their status, the revision in progress and the Work Item summary, and writes nothing.
>
> **AC-056 — Adoption.** A v0.3.0 project that adopts a control-equivalent v0.4.0 release keeps every baseline current and its lifecycle state. No v0.3.0 record is modified and no validation, candidate or decision record is created. The adoption record is signed, and it writes the signer anchor when the project has none.
>
> **AC-057 — Adoption is never silent.** The governing release of a project changes only through `adopt_release`. An adoption that is not control-equivalent is refused and writes nothing.
>
> **AC-058 — Legacy state.** A v0.3.0 state file is read under the legacy grammar, is never rewritten, and gives the same status as a run with the same content.
>
> **AC-059 — Adapter subset.** Project initialisation installs any subset of the release's adapters. Adding or removing an adapter changes no governed state, no digest and no lifecycle conclusion.
>
> **AC-060 — One source.** Every rendered adapter file of the release equals the rendering of the single authored source. The build fails when one differs.
>
> **AC-061 — Installed adapters.** `check_adapters` reports every installed adapter file that is missing or differs from the release.
>
> **AC-062 — Core location.** No adapter file names the location of the core. Every adapter invokes the launcher.
>
> **AC-063 — Reserved operations.** The CLI records a human decision only on a controlling terminal, outside every detected agent context, after the operator has confirmed the exact subject, and only with a signature that verifies for a key enrolled for the identity of the required authority.
>
> **AC-064 — Hand-over.** A run started through one adapter and continued through others is hand-over equivalent (Section 64.7) to a run of the same Work Item made through one adapter.
>
> **AC-065 — Registered change.** A change made outside a run can be recorded only as a registered change, is accepted or rejected by the `engineering` authority, and is never represented as a run.
>
> **AC-066 — Core contract.** A core that does not implement the core contract a release declares resolves nothing under that release and writes nothing. A v0.3.0 core fails in this way on a project governed by v0.4.0.
>
> **AC-067 — Signed records.** In a project governed by v0.4.0 a decision record, a subject decision, an adoption record or a signer record without a valid signature by an enrolled key has no effect: it satisfies no gate, establishes no baseline, changes no disposition, accepts no registered change, adopts no release and enrols or revokes no key. A record written as a file without the key is therefore rejected, and its presence is reported. **[D-06c]**
>
> **AC-068 — Carried decisions.** A decision recorded under a release without signed decisions keeps its declared assurance exactly when a valid adoption record lists it by ID and digest. Every other decision record with declared assurance is invalid.
>
> **AC-069 — Signer chain.** Keys are enrolled and revoked only by signed, append-only signer records that form one chain from the anchor. A gap, a fork or an invalid signature in the chain is reported, and no record verifies under a broken chain.
>
> **AC-070 — Keys stay with their owner.** The core never reads a private key. A signature is made by the operator's OpenSSH and verified by the core in process, and the same signature verifies with stock OpenSSH against the allowed-signers file the core prints.
>
> **AC-071 — Anchor trust.** The CLI performs a reserved operation or an operator command only on a project whose signer anchor the operator has accepted on that machine, and refuses when the anchor differs from the accepted one.

### 2.28 Sections 53 to 58

**DELETE** CT-139 and CT-140 from Appendix A and their rows from Section 53. The identifiers are retired and not reused. **ADD** the rows of CT-141 to CT-226 as given in `CONTRACT-TESTS-CHANGES.md`. **ADD** to Section 56 integration tests: two consecutive revisions; a specification-reach revision; adoption of a v0.3.0 fixture project that carries v0.3.0 adapter files; a three-adapter hand-over; the v0.3.0 executable against an adopted project. **REPLACE** Definition of Done item 24 with the same sentence followed by "except as Section 43 permits under a work revision". **ADD** items for AC-043 to AC-071, and "the acceptance scenario of Section 72.3 passes on a clone of a real v0.3.0 project".

### 2.29 Section 60 (Change control)

**ADD** to the list of what requires a contract change: change-record semantics; reach rules; the permitted-operation set; delta construction; runtime state transitions; disposition semantics; adoption equivalence; the reserved-operation guard; the signature format, the accepted key types and the signer chain; the adapter manifest; the core contract of a release.

**ADD:**

> A change set that alters a normative file updates the handover manifest in the same commit. BRS 2.0 is recorded against release v0.4.0.

## 3. New sections

### Section 62 — Change records

**62.1 Purpose.** In the maintenance regime nothing replaces a baseline, re-executes a finished Work Item or records work done outside a run without a change record.

**62.2 Content.** A change record is stored under `evidence/changes/` and contains:

- its ID;
- the kind: `defect`, `follow_up`, `new_requirement` or `documentation`;
- the origin: `planned` or `registered`;
- a title and the operator's statement of what is to change and why;
- the reach (62.3);
- the finished Work Items to re-execute under their approved definition (`rework`), if any;
- acceptance statements with stable IDs (`CHG-0001-AC-01`), if any;
- the baselines in force when it was opened, by ID and digest;
- the change record it supersedes, if any;
- for a registered change, the content of Section 66;
- how it was opened (interface and caller) and the Harness-generated timestamp;
- algorithm, canonicalisation version and self digest.

A change record is never edited. A correction, including a wider reach, is a new change record that supersedes it:

- a planned record can be superseded only while its status is `open` or `in_revision`, or while its reach is `execution` and no run is bound to it; a registered record only while its status is `rejected`; the successor is a planned record; a record is superseded only once, and a second successor is refused with `CHANGE_NOT_OPEN`;
- the successor's reach is at least as wide as its predecessor's;
- the successor of a planned record takes its predecessor's place in the order of 63.2 and inherits the baselines and Work Items bound to it; the successor of a registered record takes its own sequence number and inherits nothing;
- supersession is explicit and acyclic. A record with two successors, a cycle, a change record or closure that does not reproduce its digest, and a record that another record or a candidate names but that is missing, are each `CHANGE_RECORD_INVALID`: then no revision change is active and the next action is `resolve_blocker` (Section 37, row 1). A baseline whose candidate names such a record keeps its integrity; the fault is reported, not propagated.

**62.3 Reach.** The core determines the reach when the record is opened and stores it. **[D-17]**

```text
reach = the reach the operator requests, when given and not below the minimum of the kind
        otherwise the default reach of the kind
```

| Kind | Minimum reach | Default reach |
| --- | --- | --- |
| `defect` | `execution` | `work`; `execution` when the operator names only Work Items to re-execute |
| `follow_up` | `work` | `work` |
| `documentation` | `work` | `work` |
| `new_requirement` | `specification` | `specification` |

A requested reach below the minimum is refused with `CHANGE_REACH_INVALID`. A registered change has reach `none`.

| Reach | Baselines the revision replaces |
| --- | --- |
| `none` | none; no revision and no execution |
| `execution` | none; named finished Work Items are re-executed |
| `work` | Work |
| `architecture` | Architecture, then Work |
| `specification` | Specification, then Architecture, then Work |

The core enforces the reach from facts. A chain outside the reach that is not current blocks the revision (Section 37 row 5). A changed Pack needs reach `specification` (rows 3 and 4). A Work Item that names no requirement is allowed only under the kinds of Section 32. A revision that turns out to need more is continued under a superseding record of wider reach.

**62.4 `open_change`.** Inputs: the kind, the title, the statement, and optionally the requested reach, the Work Items to re-execute, acceptance statements and the record to supersede. Permitted in the maintenance regime whenever the release resolves. Every Work Item named for re-execution shall be in the task set of the governing Work Baseline with effective status `done`; otherwise `open_change` is refused with `TASK_UNKNOWN` or `TASK_NOT_READY`. It writes one record with exclusive-create semantics under the mutation lock.

**62.5 Derived status.** The status of a change record is derived, never stored. The first row that applies gives it:

| Order | Status | Condition |
| --- | --- | --- |
| 1 | `superseded` | another change record supersedes it |
| 2 | `abandoned` | a closure record names it |
| 3 | `rejected`, `accepted`, `awaiting_decision` | a registered change, by its decision (Section 66) |
| 4 | `in_revision` | a chain in its reach is not satisfied for it, and a candidate names it |
| 5 | `open` | a chain in its reach is not satisfied for it |
| 6 | `completed` | every Work Item attributed to it is done for it |
| 7 | `completed_with_open_items` | every attributed Work Item is done for it, under a disposition, or no longer in the task set, and at least one is not done for it |
| 8 | `in_execution` | otherwise |

Attribution and completion are fixed and are not re-derived from later state. The Work Items attributed to a change record are those whose `task` item lists it, or a planned record it supersedes, in `change_refs` in the first Work Baseline established under it, and those in its `rework` list. An attributed item is done for the record once a done run exists on the definition digest that baseline holds for it; a `rework` item, once a run bound to the record is done. A later run, revision or disposition does not undo that. A record of reach `execution` therefore starts as `in_execution`.

Status does not depend on whether a baseline is still current. A record whose chains are all satisfied never returns to `open` or `in_revision`.

**62.6 `abandon_change`.** Permitted for a planned record whose status is `open` or `in_revision`, or whose reach is `execution`, while no chain is satisfied for it, no run is bound to it, no current undecided or approved candidate names it, and every chain in its reach has artefacts equal to those of its head baseline. It writes a closure record. After a baseline has been established under a change record the revision can only go forward.

### Section 63 — Revisions

**63.1 One revision at a time.** A revision replaces baselines under exactly one change record. **[D-10]**

**63.2 Active revision change.** The candidates are the planned change records of reach `work` or wider that are not superseded, not abandoned and have a chain in their reach that is not satisfied for them. A record's position is the sequence number of the oldest planned record in its supersession chain. The candidate with the lowest position is the active revision change. Later ones wait with status `open`.

**63.3 Steps.** The steps of a revision are the next actions of Section 37. A revision is complete when every chain in the reach of its change record is satisfied for it.

**63.4 Item index and delta.** Every candidate written by a v0.4.0 core carries an item index. For each item it gives the kind, the ID, the artefact path and the `harness-v1` digest of the item.

| Candidate type | Item kinds | Item |
| --- | --- | --- |
| specification | `requirement`, `acceptance_criterion` | each element of the two lists |
| architecture | `component`, `adr`, `contract` | each component; each ADR file; each contract file |
| work | `task`, `graph_entry` | each task file; each entry of the execution graph |
| all | `document` | each artefact that holds a list of items, with every such list replaced by the ordered list of its item IDs |

The digest of an item is the digest of its parsed object. Every part of every artefact is therefore covered by exactly one item, and a reordering shows as a changed `document` item. For a `task` item the index also records its `requirement_refs`, `acceptance_refs`, `change_refs` and `dependencies`, so that Sections 32, 62.5, 64.3 and 65.4 can be evaluated when the working tree differs from the governing Work Baseline.

In the maintenance regime every candidate also carries a revision context:

- the change record, by ID, path and digest;
- the baseline it will supersede, by ID and digest;
- the delta against that baseline's candidate, at two levels:
  - artefacts added, changed (old and new digest) and removed, and the count unchanged;
  - items added, changed (old and new digest) and removed, and the count unchanged for each item kind.

The index of the superseded baseline comes from its candidate. For a baseline established under v0.3.0 it comes from the adoption record (Section 67.4).

The item index and the revision context are inside the candidate digest. The approver therefore approves the statement of what changed together with the content. A pending gate reports the revision context, and an adapter and the CLI present it to the approver.

Under core contract 2 a pending gate also names the `authority` of its gate and, as `approver`, the identity the Project Pack assigns to that authority, which is the identity that signs; `approver` is null when the Pack names none. An adapter fills the decision command it presents from them. A v0.3.0 result carries neither member.

**63.5 Authoring in a revision.** The authoring operations take a complete artefact set, as in the bootstrap regime. The core writes an unchanged artefact with identical bytes. The adapter authors a revision from the existing artefact and changes only what the change record requires: subject matter that changes keeps its ID, new subject matter gets a new ID, and a retired ID is never reused.

**63.6 Upstream change notice.** When a Work candidate is validated in a revision of reach `architecture` or `specification`, the core reports, as a warning that does not fail validation, every Work Item whose `task` item is unchanged and which references an item that the revision's Specification or Architecture baseline changed or removed.

### Section 64 — Runtime state and task execution

**64.1 Ownership.** Runtime state is read and written only by the core. An adapter never writes under `work/state/`.

**64.2 Run record.** A run is stored as `work/state/<TASK-id>/RUN-<nnnn>.yaml` under the release schema and contains:

- the run ID and the Work Item ID;
- the Work Item definition it executes, by path and digest;
- the Work Baseline in force when it started, by ID, path and digest;
- the change record under which it was reopened, if any; the legacy file it continues, if any;
- the status: `in_progress`, `blocked` or `done`;
- the ordered events, each with a sequence number, a type (`started`, `resumed`, `progress`, `blocked`, `completed`), the Harness-generated timestamp, the caller as declared (an adapter identifier, or `operator`), and an optional note;
- the changed paths reported so far, in ascending path order;
- at completion: the verification result of every control, optional notes per acceptance criterion, and the raw-byte digest of each changed path. **[D-05]**

Events are only appended. A run whose status is `done` is never modified. A run file that does not validate against the schema, or whose Work Item, number or path disagree, is `TASK_STATE_INVALID`: it is never modified, and its Work Item requires rework.

**64.3 Effective status.** The task set is the task set of the governing Work Baseline; under a work revision it also includes the Work Items the working tree adds. Execution-graph order and dependencies are those of the working tree's graph. A Work Item of the governing Work Baseline that the working tree no longer holds is listed after all others, in ascending ID order. When the working tree's graph cannot be read, the items of the governing baseline's item index are listed in ascending ID order and none is ready. The status of a Work Item is the first row that applies:

| Order | Effective status | Condition |
| --- | --- | --- |
| 1 | `deferred`, `withdrawn` | a disposition is in force (Section 65) |
| 2 | `awaiting_baseline` | under a work revision: its `task` or `graph_entry` item in the working tree differs from the governing Work Baseline, or it is added or removed |
| 3 | `gated` | the item's `human_gates` is not empty and no run on its current definition is done |
| 4 | `done`, `in_progress`, `blocked` | the latest run has that status and its definition digest is the current one |
| 5 | `rework_required` | a run exists and none of the above applies, or its state file is invalid |
| 6 | `pending` | otherwise |

The current definition digest of a Work Item is its artefact digest in the candidate of the governing Work Baseline. State under `work/state/` for a Work Item that is not in the task set is history: it is reported and never selected.

A Work Item is **ready** when its effective status is `pending`, `rework_required`, `in_progress` or `blocked` and every Work Item it depends on is `done`.

v0.4.0 defines no operation that satisfies a Work Item gate. As in v0.3.0, a gated item is reported and never started by an adapter; it leaves that status through a revision that removes the gate or through a disposition.

**64.4 Operations.**

`list_tasks` returns every Work Item of the task set in execution-graph order with its effective status, dependencies, readiness and the reason when it is not ready; the historical state; and the open acceptance criteria (Section 65.4). It writes nothing.

`select_task` returns the Work Item to execute. With a named item: that item when it is ready, and otherwise no item and the reason (`TASK_NOT_READY`, `TASK_ALREADY_DONE` or `TASK_NOT_EXECUTABLE`). Without a name: the first item in execution-graph order whose effective status is `in_progress` and which `start_task` would accept; if there is none, the first item whose effective status is `pending` or `rework_required` and which `start_task` would accept. When Section 43 prohibits execution it returns no item and `EXECUTION_NOT_PERMITTED`. A blocked item is returned only by name. `select_task` returns the definition, the open run with its events and notes if there is one, and the operations permitted on the item. It writes nothing.

`start_task` requires that Section 43 permits execution of the item and that the item is ready. If the latest run is open and its definition digest is current, it appends a `resumed` event. Otherwise it creates the next run. It is refused with `TASK_ALREADY_DONE` for a `done` item, `TASK_NOT_EXECUTABLE` for a deferred, withdrawn or gated item, `EXECUTION_NOT_PERMITTED` when Section 43 prohibits execution, and `TASK_NOT_READY` otherwise.

`record_task_progress` appends a `progress` event with a note to the open run, and accepts changed paths. Its purpose is hand-over: the note states what is done and what remains, so that the next session needs nothing but the repository. `block_task` sets the open run to `blocked` with a reason and accepts changed paths in the same way; `start_task` resumes it. Both require an open run on the current definition (`TASK_RUN_NOT_OPEN` otherwise) and not that execution is permitted, so that work can be parked.

The core checks every reported path at once: a path outside the item's `repository_scope.allowed`, inside its `forbidden`, or a reserved path is `TASK_SCOPE_VIOLATION` and nothing is written.

`complete_task` takes a task result document: a verification result (`PASS`, `FAIL` or `NOT_RUN`, with the command and a note) for every identifier in the item's `verification_controls`, optional notes per acceptance criterion, and changed paths. It requires an open run on the current definition and that Section 43 permits execution of the item, and it is refused with `TASK_NOT_EXECUTABLE` for an item under a disposition. The core refuses completion when a control has no result (`TASK_VERIFICATION_INCOMPLETE`) or a result is `FAIL` (`TASK_VERIFICATION_FAILED`). `NOT_RUN` is accepted and recorded; the core never turns it into `PASS` (Section 50). On success the run records the union of the paths reported during the run and in the result document, with the digest of each, and is `done`. **[D-13]** An acceptance note names a criterion of the specification (`AC-…`) or an acceptance statement of a change record (`CHG-nnnn-AC-nn`); a note that names a criterion neither defines is `VALIDATION_FAILED`, and nothing is written.

`reopen_task` requires a Work Item whose effective status is `done` or `rework_required` (`TASK_NOT_READY` otherwise), that Section 43 permits execution of it, and a change record with status `in_execution` that lists the item in `rework` and has no run bound to it for that item (`CHANGE_NOT_OPEN` otherwise). It creates the next run, bound to that change record. The earlier run is untouched.

The core does not run verification commands and does not observe the working tree. What a caller reports in `complete_task` is the caller's claim, recorded with the caller's name.

**64.5 Carry-over under a new Work Baseline.** Establishing a Work Baseline writes nothing under `work/state/`. Carry-over is the derivation of 64.3: a Work Item whose definition digest is unchanged keeps its status; a changed one is `rework_required` and its next `start_task` creates a new run; a removed one keeps its state as history.

**64.6 Legacy state.** A file `work/state/<TASK-id>.yaml` written under the FR-036 grammar of BRS 1.2 is a legacy run. The core reads it as YAML and types only `task`, `status` and `work_baseline`; every other value is opaque and is ignored. It takes the definition digest from the candidate of the Work Baseline the file names, and treats the file as the run that precedes `RUN-0001`. It never rewrites, moves or deletes the file. A legacy file that cannot be read this way is `TASK_STATE_INVALID` and its Work Item requires rework.

An open legacy run is never appended to. `start_task` on its Work Item creates `RUN-0001`, whose first event has type `resumed` and which names the legacy file it continues.

**64.7 Hand-over equivalence.** Two runs of one Work Item are hand-over equivalent when they agree on the Work Item, the definition digest, the Work Baseline, the change record, the final status, the identifiers of the verification controls with a result, and the sequence of event types after `progress` and `resumed` events are removed; and when `list_tasks`, `inspect_project` and `check_maintenance` give the same conclusions for both projects. Callers, timestamps, notes, changed paths and digests are not compared.

### Section 65 — Task dispositions

**65.1 Decision.** `record_task_decision` records that a Work Item of the governing Work Baseline's task set is `deferred`, `withdrawn` or `reinstated`. It is a reserved operation at `gate://task-disposition`, permitted whenever a governing Work Baseline exists, including during a revision. The decision record is stored under `evidence/decisions/` and binds the Work Item ID, its definition digest, the Work Baseline, the decision, the reason, the approver and authority, the identity assurance, the change record if one is given, and the previous decision on the same Work Item, which it supersedes. A Work Item with two unsuperseded decisions, or a decision with two successors, is `DECISION_RECORD_INVALID`; the item is then treated as deferred until the fault is removed.

A subject decision is a signed record (Section 73). One whose signature is missing or does not verify has no effect on any disposition or registered change: the chain is read as if the record were absent, and the record is reported as an error, which prohibits execution (Section 43) until it is removed. A forged reinstatement therefore starts nothing, and a forged deferral stops the project visibly instead of silently. **[D-06c]**

**65.2 Meaning.** `deferred`: the item will not be executed in this project for now, for the reason given, for example because another team delivers it with its own tooling. `withdrawn`: the item will not be executed. `reinstated`: the previous disposition ends.

**65.3 Effect.** The disposition in force for a Work Item is the head of its decision chain. A deferred or withdrawn item is never selected and `start_task` refuses it. A Work Item that depends on it is not ready, and `list_tasks` says why. A disposition stays in force when a revision changes the item's definition; the core then reports that the definition changed after the decision. **[D-11]** It ends when the item is reinstated or leaves the task set.

**65.4 Open acceptance criteria.** A criterion of the specification is closed when every Work Item that references it is `done`. Otherwise it is open. The acceptance statements of a change record are reported with the record: closed when every Work Item attributed to the record is done for it (Section 62.5), and otherwise open, also when an attributed Work Item is no longer in the task set. For each open criterion `list_tasks` and `check_maintenance` report the Work Items that are done and those that are not, with their effective status. A criterion with no done Work Item is reported as not delivered. A criterion kept open only by deferred or withdrawn items is reported as open by disposition. Nothing removes a criterion from the report.

### Section 66 — Registered changes

**66.1 Purpose.** A change made outside a run to a path that is not a reserved path cannot be turned into a run. It can be registered. **[D-04]**

**66.2 Registration.** `open_change` with origin `registered` records the changed paths with the raw-byte digest of each at registration, optionally the Git commits that contain the change, and the finished Work Items whose deliverables the operator says it touches. The reach is `none`. A reserved path in the list is refused with `TASK_SCOPE_VIOLATION`. Git data is provenance, not authority.

**66.3 Decision.** `record_change_decision` records `accepted` or `rejected` at `gate://registered-change`. It is a reserved operation. Until then the change is `awaiting_decision`.

**66.4 How it is told apart from work under a task.** A registered change has origin `registered`, has no run, and carries no verification result. The runs of the Work Items it names are not modified. `list_tasks` and `check_maintenance` report those items as done, with the note that their deliverables were changed by a registered change and whether that change was accepted. A rejected registered change stays in every report until a planned change record names it as superseded.

**66.5 Changes outside a run.** `check_maintenance` reports every path whose current raw-byte digest equals none of the digests recorded for it by a done run or by a registered change that is not rejected. This is a report. It blocks nothing, and it covers only paths recorded by a v0.4.0 run or a registered change. A path that a run still open (`in_progress` or `blocked`) has reported is that run's work and is not listed while the run is open. **[D-05]**

### Section 67 — Release adoption

**67.1 Operation.** `adopt_release` changes the governing release of a project. It is an operator command (Section 68) and records no human decision. **[D-08]** Its record is signed by the operator (67.4), because it is the record that lets decisions without a signature stand. **[D-06c]** It takes the target version, the adapters to install (by default the adapter the project records), whether to replace adapter files that were edited (`--replace-adapter-files`), the operator's identity and signing key, and the same release source inputs as `init`. It first installs the target release under the Harness root by the rules of FR-032, reusing an installed release only when it is byte-identical. The result names the release directory.

**67.2 Preconditions.**

- the project root exists and is a directory; otherwise `REPO_REQUIRED_PATH_MISSING`, checked first and before the target release is installed;
- the target release is available and its release definition lists the project's recorded release in `adoptable_from`; otherwise `ADOPTION_UNSUPPORTED`;
- the project resolves under its recorded release, its Pack is valid and its engineering resolution is current;
- no candidate is awaiting a decision and no approved candidate awaits its baseline;
- every baseline head is current or absent.

A failure of the last three is `ADOPTION_NOT_PERMITTED`. In every case nothing is written to the project.

**67.3 Control equivalence.** The core resolves the effective control set of the project under the target release. The adoption is **control-equivalent** when the engineering-resolution digest is the same under both releases and the target release's deterministic validation controls, run in diagnostic mode on the artefacts of each current baseline as a subject without a revision member, all return `PASS`. The rule of Section 32 on added and changed Work Items does not apply to such a subject. An adoption that is not control-equivalent fails with `ADOPTION_NOT_EQUIVALENT`, lists the differences and writes nothing. **[D-07]**

**67.4 Adoption record.** A successful adoption writes one record under `evidence/adoptions/` containing: the releases adopted from and to; the Project Pack fingerprint; the engineering-resolution digest before and after; the statement of control equivalence; for each current baseline its ID, digest, candidate digest, the controls run and their result, and the item index of its artefacts; the Project AI Policy digest; the previous adoption record, which it supersedes; the timestamp and how it was captured; and its self digest.

When the release adopted from has no signed decisions, the record also lists every decision record the repository holds at that moment, by ID, path and digest (`declared_decisions`). These, and no others, keep their declared assurance (Section 22). **[D-06c]**

The adoption record is a signed record (Section 73). It names the operator's identity, which shall hold at least one authority in the Project Engineering Pack, the key and the signer record that is the head of the chain. When the project has no signer chain, the same mutation writes the anchor for that identity and key, and the adoption record names the anchor. An adoption record without a valid signature satisfies nothing (Section 29): the release binding fails, every baseline it would carry is stale, and no decision it lists keeps its assurance.

**67.5 What adoption writes.** As one logical mutation under the lock:

- the adoption record with its signature file, and the signer anchor with its signature file when the project has no signer chain;
- `.engineering-harness-template` with the new version, and `engineering/` re-materialised for the target release;
- `.engineering-harness-adapters`; `.engineering-harness-adapter` is deleted;
- the adapter files, as follows. The target release carries, for each release in `adoptable_from`, the overlay files of that release's adapters. A v0.3.0 project does not record the core command it was initialised with, so the core recovers it from the files. A file whose release file holds no placeholder is **pristine** when it is byte-identical to the release file. A file whose release file holds the placeholder is pristine when one string exists that, substituted for every occurrence of the placeholder (escaped as a JSON string in a `.json` file, as v0.3.0 `init` wrote it), reproduces the project file byte for byte; the string must be the same in every such file of the recorded adapter, otherwise none of them is pristine. A pristine file is replaced by the new overlay file at that path, or removed when the new overlays have none. A file that is not pristine and lies at a path the new overlays write is `ADAPTER_FILE_CONFLICT`: the adoption writes nothing, unless the operator asks for replacement. A file that is not pristine and that the new overlays do not write is left in place. The result lists every file written, replaced, removed and left.

It writes nothing else. It modifies no record under `baselines/` or `evidence/` and no file under `spec/`, `architecture/`, `ai/` or `work/`.

**67.6 Effect.** After a control-equivalent adoption every baseline that was current is current (Section 29), the Project AI Policy is current without being re-derived, the Work graph is valid, and the lifecycle state is what it was. No validation, candidate or decision record is created.

**67.7 Compatibility duty of a release.** A release that lists an earlier release in `adoptable_from` shall accept, under its schemas and controls, every document that was valid under the earlier release.

### Section 68 — Reserved operations, operator commands and the guard

**68.1 What is guarded.** The reserved operations are `record_specification_decision`, `record_architecture_decision`, `record_work_decision`, `record_task_decision`, `record_change_decision` and the short forms `approve_pending` and `reject_pending`. The operator commands are `adopt_release`, `enrol_signer`, `revoke_signer`, `trust_signers`, `adapter_add`, `adapter_remove` and `adapter_sync`. `init` is not guarded: it creates a project and touches no governed state.

**68.2 Guard in the CLI.** The CLI performs a reserved operation only when all six conditions hold. Otherwise it writes nothing. **[D-06c]**

1. `--adapter` is absent. Otherwise `GUARD_AGENT_CONTEXT`.
2. The environment carries none of the agent session markers that the release's adapter manifest lists. Otherwise `GUARD_AGENT_CONTEXT`.
3. A controlling terminal is available. The CLI reads every confirmation from the controlling terminal device only, never from standard input. Otherwise `GUARD_NOT_INTERACTIVE`.
4. The signer anchor of the project is the one the operator accepted on this machine (Section 73.7). Otherwise `GUARD_ANCHOR_UNTRUSTED` or `GUARD_ANCHOR_CHANGED`.
5. The CLI has shown the operator, on that terminal, the gate, the subject, its digest, the signer it will sign as and, for a candidate in a revision, the delta summary; and the operator has typed the last eight characters of the subject's digest. Otherwise `GUARD_CONFIRMATION_FAILED`.
6. The operator's OpenSSH has signed the record and the signature verifies for a key enrolled for the approver (Section 73.6). Otherwise `GUARD_KEY_UNPROTECTED`, `GUARD_SIGNING_FAILED` or `SIGNER_NOT_ENROLLED`.

An operator command needs conditions 1 to 3. `adopt_release`, `enrol_signer` and `revoke_signer` write signed records and also need conditions 4 and 6; condition 4 does not apply to the command that writes the anchor.

The subject digest is the candidate digest, the Work Item definition digest or the change record digest. The decision record states `captured_via.interface = cli` and that the terminal confirmation was obtained.

Conditions 1 to 5 are part of the CLI and apply whatever release governs the project. On a project governed by v0.3.0, condition 4 does not apply and condition 6 is replaced by the declared identity of BRS 1.2. The library interface has no guard, because the guard concerns how the CLI captures a human act; but the signature of Section 73 is checked by the core itself whenever it reads a record, so a caller of the library cannot record a decision without one either. An embedding that exposes reserved operations to an agent violates this BRS.

**68.3 `adapter_guard`.** A distribution command that an agent's tool hook invokes before a tool call. It reads the call from standard input in the hook format of any shipped adapter, including the format one agent uses when it runs another agent's hook.

- For a shell command: when the command line contains, as a shell word, the name of a reserved operation or of an operator command, or invokes `ssh-keygen` with `-Y sign`, it exits with status 2 and writes the reason to standard error.
- For a file-writing tool: when the target is a reserved path other than under `project-pack/`, it exits with status 2 in the same way.
- For every other call, and for both kinds otherwise, it exits with status 0 and no output.

Every shipped agent treats exit status 2 as a denial. The command resolves a target path against the project root that the launcher passes to it. From the project it reads only `.engineering-harness-template`, to find the adapter manifest of the governing release; when that fails it uses the overlay paths of its own release. `AGENTS.md` is denied as a whole file. A call whose target it cannot determine is allowed. The command writes nothing and gives the same answer however often it is run for one call.

**68.4 What this is and is not.** The hooks, the agents' own deny rules and conditions 1 to 3 and 5 prevent an agent from recording a decision by following or misreading instructions. They are not authentication. Authentication is the signature of Section 73: a record written as a file, or a confirmation typed by an agent, yields nothing without a signature by an enrolled key. **[D-06c]**

What remains is no longer a gap in the Harness but a condition on its use, and `DECISIONS.md` Section 4 puts each to the owner:

1. **A key an agent can use.** A private key file without a passphrase, or a key held by an SSH agent that signs without asking, can be used by any process of the same user, including a coding agent. The CLI refuses a private key file that has no passphrase unless the key is hardware-backed. It cannot see how an SSH agent is configured. The operator shall use a key that needs them for every signature: a passphrase-protected key that is not loaded into an agent, an agent key added with per-use confirmation, a hardware key that requires touch, or a key manager that asks each time.
2. **The anchor.** The signer chain is stored in the repository, which an agent can write. Records signed under the chain bind it, so a replaced chain breaks them. But a chain replaced before any such record exists, or replaced together with everything signed under it, is consistent in itself. The CLI detects this on every machine where the operator accepted the anchor (Section 73.7); elsewhere it is found only by comparing the anchor's fingerprint.
3. **A signature given without reading.** The CLI shows the subject and the delta and asks for the digest; it cannot make the operator read them.

### Section 69 — Adapters

**69.1 Shipped adapters.** v0.4.0 ships `claude-code`, `codex` and `copilot`. The supported surfaces of each are listed in its contract. **[D-09]**

**69.2 One source.** The release holds, under `adapters/`:

- `source/instructions.md` and `source/commands/{bootstrap,execute,maintain}.md`: the single authored text of the project instructions and of each command;
- `adapters.yaml`: the adapter manifest. For each adapter it gives the identifier, the overlay files with the source each is rendered from and its native front matter, the files it shares with other adapters, its enforcement files and its agent session markers. It also gives, for each release in `adoptable_from`, the overlay files of that release's adapters (Section 67.5);
- `<adapter>/overlay/**`: the rendered files;
- `<adapter>/ADAPTER-CONTRACT.md`: the contract, never copied into a project;
- `common/overlay/**`: the files installed with any adapter.

The text of the instructions and of each command is identical in every rendering. A rendering adds only its path, its front matter and the files that the agent requires beside it. The text never states which adapter it was rendered for: it lists the identifiers of all adapters of the manifest and tells the agent to pass its own. This matters because agents read each other's files (`AGENT-SURFACES.md`).

`render_adapters` renders the overlays from the source and the manifest. With `--check` it writes nothing and fails when a rendered file differs. The build runs it. `adapters/` is a release component installed under `<harness_root>/releases/<version>/`.

**69.3 Overlays of v0.4.0.** The manifest is authoritative; this table reproduces it. **[D-09]**

| Layer | Files |
| --- | --- |
| common | the managed block of `AGENTS.md` (project instructions); `harness`, `harness.cmd` (launcher) |
| `claude-code` | `CLAUDE.md` (one line that imports `AGENTS.md`), `.claude/commands/{bootstrap,execute,maintain}.md`, `.claude/settings.json` (allow, deny, hook) |
| `codex` | `.agents/skills/{bootstrap,execute,maintain}/SKILL.md` with `agents/openai.yaml`, `.codex/rules/engineering-harness.rules`, `.codex/hooks.json` |
| `copilot` | `.github/skills/{bootstrap,execute,maintain}/SKILL.md`, `.github/hooks/engineering-harness.json` |

An installed overlay file is byte-identical to the release file. No overlay file contains a value specific to a project or a machine. Each rendered `SKILL.md` has a `name` equal to its directory name and a description within the limit of the Agent Skills format.

The project instructions are installed as a **managed block** in `AGENTS.md`, between the lines `<!-- engineering-harness:begin -->` and `<!-- engineering-harness:end -->`. An adapter operation creates the file with the block when it is absent, appends the block when the file has none, and otherwise replaces the content of the block. Everything outside the block belongs to the project and is never read or changed. A file with two blocks or an unterminated block is `ADAPTER_FILE_CONFLICT`.

**69.4 Launcher.** `harness` (POSIX shell) and `harness.cmd` (Windows) at the project root pass their arguments unchanged to the core, which they locate in this order: the `ENGINEERING_HARNESS_CORE` environment variable; `harness-core` in the parent directory of the launcher's own location; `harness-core` on the search path. When none exists they exit with status 64, except for `adapter_guard`, where they exit with status 0. Before starting the core they set `ENGINEERING_HARNESS_PROJECT_ROOT` to their own directory. They contain no other logic. **[D-14]**

Every command text invokes the core as `./harness` from the project root. A hook registration invokes the launcher by a path resolved from the project root and not from the session's working directory, by the means its agent documents. The `claude-code` registration must also work when another agent runs it (`AGENT-SURFACES.md`, finding 1): it resolves the launcher from `CLAUDE_PROJECT_DIR` when that is set and otherwise from the Git root, and it exits with status 0 when it finds no launcher. No adapter file, and no agent settings file, names the location of the core.

**69.5 Installation.** `init --adapters <list>` installs any subset, including none. `adapter_add` and `adapter_remove` change the set on an existing project, and `adapter_sync` reinstalls the files of the installed set from the governing release. These commands:

- write only overlay files, the managed block and `.engineering-harness-adapters`;
- install a file that several adapters share once and remove it with the last adapter that declares it;
- refuse to overwrite a file that exists and is not byte-identical to the overlay file (`ADAPTER_FILE_CONFLICT`) unless the operator asks for replacement, and then list every file replaced;
- never write a file under a governed directory.

Because adapter files are outside every fingerprint, subject and candidate, these commands change no digest and no lifecycle conclusion.

**69.6 Verification.** `check_adapters` compares every overlay file of every installed adapter, and the managed block, with the release and reports `ADAPTER_FILE_MISSING` and `ADAPTER_FILE_MODIFIED`. `inspect_project` and `check_maintenance` carry the same findings as warnings.

**69.7 Enforcement per adapter.** Each adapter ships the strongest repository-committed controls its agent documents, for shell commands and for its file-writing tools, and its contract states what they do and do not do:

| Adapter | Shipped controls | What they do |
| --- | --- | --- |
| `claude-code` | `permissions.deny` for the guarded command names and for file tools on reserved paths; a `PreToolUse` hook that runs `adapter_guard` | Block. Deny rules hold in every permission mode and cannot be overridden by local settings |
| `codex` | `forbidden` prefix rules for the guarded command names; a `PreToolUse` hook that runs `adapter_guard` | Block, once the operator has trusted the project's `.codex/` layer and reviewed the hook. A hook that fails to run lets the call through |
| `copilot` | a `preToolUse` hook that runs `adapter_guard` | Blocks in Copilot CLI once the folder is trusted, and not in prompt mode unless the operator opts in. In VS Code hooks are a preview feature |

Every one of these matches command text or tool arguments. None is a security boundary, and none sees a file written by a shell command. The guard of Section 68.2 applies whatever the agent does.

### Section 70 — Adapter commands

**70.1 Common rules.** Every adapter exposes `bootstrap`, `execute` and `maintain`, each with a `status` form that writes nothing. A command:

- invokes the core only through the launcher, from the project root, and passes `--adapter` with the agent's own identifier;
- performs only the next action, or a permitted operation whose actor is `adapter`;
- never invokes a reserved operation or an operator command;
- never writes under a reserved path;
- stops at `HUMAN_INPUT`, `HUMAN_DECISION`, `REWORK`, `BLOCKED`, `INVALID` and `ERROR`, and presents the issue codes and the next action exactly.

An interrupted authoring step leaves nothing to hand over: the next session restarts that step from the next action.

**70.2 `bootstrap`.** `bootstrap status` renders `inspect_project`. In the bootstrap regime `bootstrap` performs the next action: it completes the Pack from the operator's brief while the state is `PROJECT_INPUT_REQUIRED`; it authors the input of `ingest_specification`, `derive_architecture` and `generate_work_items` from the Pack's sources and the baselined predecessor and hands it to the core; it invokes the deterministic operations; and it stops at each gate, where it presents the gate, the candidate digest and the decision command for the operator. At `REWORK` it stops and presents the issues; `bootstrap rework <instruction>` then authors a corrected artefact set and calls the authoring operation the core lists as permitted. In the maintenance regime it reports status and refers the operator to `maintain` and `execute`.

**70.3 `execute`.** `execute status` renders `list_tasks`. `execute [TASK-id]` calls `select_task`, then `start_task`, implements the Work Item inside its repository scope, runs the repository's check for each verification control where one exists, and calls `complete_task`, or `block_task` when it cannot finish. When it stops before completion it calls `record_task_progress` with a hand-over note and the paths changed so far. It holds no selection rule, no transition rule and no state format of its own.

**70.4 `maintain`.** `maintain status` renders `check_maintenance`. `maintain <statement>` records the operator's statement with `open_change`: the adapter proposes the kind, and the reach only when the statement requires one wider than the default, and asks the operator when the statement does not decide them. `maintain` without a statement continues the revision in progress: it performs the next action, authoring a revised artefact set from the existing one (Section 63.5), and stops at the gate, where it presents the change record, the candidate digest and the delta. For a change record that lists Work Items to re-execute it calls `reopen_task` for each. It never executes a Work Item; that is `execute`.

Four further forms use permitted operations. When the next action is an authoring operation and the change record requires no change to that chain, `maintain` invokes the `validate_<x>` the core lists as permitted instead, and says so. At `REWORK` `maintain` stops and presents the issues; `maintain rework <instruction>` then authors a corrected artefact set and calls the authoring operation the core lists as permitted. `maintain abandon <CHG-id>` calls `abandon_change`. `maintain register <statement>` registers a change made outside a run (Section 66.2): it establishes the changed paths from the commits or paths the operator names, proposes the kind and the finished Work Items the change touches for the operator to confirm, calls `open_change` with origin `registered`, and presents the `record_change_decision` command for the operator. Each is an operation the operator asked for through the command (Section 40), and the adapter performs it only when the core's current result lists it.

### Section 71 — Release definition and workflows

**71.1 Workflows.** `workflows/maintenance.yaml` (`workflow://maintenance`) defines the change kinds with their minimum and default reach, the chains of each reach, and the gates `gate://task-disposition` and `gate://registered-change`. `workflows/execution.yaml` (`workflow://execution`) defines the run statuses, the event types and the permitted transitions between them. The content of the bootstrap workflow is unchanged. The two gates are added under `gates/`.

**71.2 Controls.** No control is added to or removed from the release or from any profile, and the files under `controls/`, `profiles/` and `technologies/` are byte-identical to v0.3.0. The engineering-resolution digest of every v0.3.0 project is therefore unchanged. The behaviour of `control://validation/work-graph` is extended as Section 32 states, and only for content v0.3.0 could not express. This is why adoption re-runs the controls on every baselined subject (Section 67.3).

**71.3 Core contract.** The release definition declares `core_contract: 2` and names its workflows, its adapter manifest and `adoptable_from`. A core implements one or more core contracts and resolves a release only when it implements the one the release declares. The v0.3.0 core predates this rule, so the v0.4.0 release definition is written so that the v0.3.0 core's own resolution fails: it does not carry the `bootstrap_workflow` key that the v0.3.0 core requires. A v0.3.0 core that is pointed at a project governed by v0.4.0 therefore reports `PROV_UNSUPPORTED` and writes nothing.

### Section 72 — v0.3.0 projects

**72.1 Reading.** A v0.4.0 core implements core contracts 1 and 2. It operates a project governed by v0.3.0 with v0.3.0 semantics: the bootstrap rows of Section 37 in every state, the single adapter marker, the legacy state grammar and the v0.3.0 result schema. It offers none of the operations of Sections 62 to 66 there. The guard of Section 68.2 applies.

**72.2 Adopting.** Section 67. For a project at `EXECUTION_READY` the result is `EXECUTION_READY` under v0.4.0 with the same three baselines current, the same Project AI Policy, the legacy state files untouched, one adoption record added and the adapter files of v0.4.0 in place of those of v0.3.0. After adoption the project must be operated with a v0.4.0 core; a v0.3.0 core refuses it (Section 71.3).

**72.3 Acceptance scenario.** On a clone of a v0.3.0 project that is `EXECUTION_READY` with fifteen of sixteen Work Items done:

1. `adopt_release` with all three adapters succeeds; the project is `EXECUTION_READY`; no decision was recorded. The adoption record is signed by the operator and the signer anchor is written; the three baselines are reported as resting on declared approvals.
2. Through `maintain` a change record of kind `defect` is opened and one Work Item is added. At `gate://work-baseline` the candidate reports sixteen `task` items unchanged and one added. The `engineering` authority approves with a signature.
3. `baseline_work` establishes the Work Baseline that supersedes the first one. The fifteen Work Items are `done`. The sixteenth is `deferred` by a decision of the `engineering` authority, and its acceptance criteria are reported as open.
4. The added Work Item is started through one adapter, continued through a second and completed through a third. Its run is hand-over equivalent (Section 64.7) to the run of the same Work Item made through one adapter on a second clone, every event names the adapter that made it, and no file outside the Work Item's scope and `work/state/` was needed or changed by the hand-over.

### Section 73 — Signed records **[D-06c]**

**73.1 Rule.** In a project governed by v0.4.0 the following records are valid only with a signature by an enrolled key. They are the **signed records**:

| Record | Directory | Signed by |
| --- | --- | --- |
| Decision on a baseline candidate | `evidence/approvals/` | the approver |
| Subject decision (task disposition, registered change) | `evidence/decisions/` | the approver |
| Adoption record | `evidence/adoptions/` | the operator who adopts |
| Signer record | `evidence/signers/` | 73.4 |

The single exception is a decision that an adoption record carries with declared assurance (Sections 22 and 67.4). Change records, closures, validation evidence, candidates, baselines and runs are not signed: none of them states a human decision, and each takes effect only through a signed one.

**73.2 Signature.** A signature is an OpenSSH signature (the `SSHSIG` format that `ssh-keygen -Y sign` writes), armoured, stored beside its record as `<record file name>.sig`.

- The namespace is `engineering-harness`.
- The signed message is the record's self digest as ASCII text: `sha256:` followed by 64 lowercase hexadecimal digits, 71 bytes, no line terminator. The digest covers the record, so the signature covers the record.
- The hash algorithm is `sha512` or `sha256`.
- Accepted key types: `ssh-ed25519`, `ecdsa-sha2-nistp256`, `ecdsa-sha2-nistp384`, `ecdsa-sha2-nistp521`, `ssh-rsa` keys of at least 2048 bits signing with `rsa-sha2-256` or `rsa-sha2-512`, and the hardware-backed `sk-ssh-ed25519@openssh.com` and `sk-ecdsa-sha2-nistp256@openssh.com`. Certificates are not accepted.

Inside its digest the record names who signed it: the identity; the key, by type and SHA-256 fingerprint; and the signer record that was the head of the signer chain when the record was written, by ID and digest. A decision record carries these in `identity_assurance` with `mechanism: ssh-signature` and `level: signed`.

**73.3 Verification.** The core verifies signatures in process, on every derivation, without starting another program. A signed record verifies when all of these hold:

1. the signature file exists and parses, and its namespace is `engineering-harness` (`APPROVAL_SIGNATURE_MISSING`, `APPROVAL_SIGNATURE_INVALID`);
2. the public key in the signature has the type and fingerprint the record names, and the signature verifies over the record's self digest (`APPROVAL_SIGNATURE_INVALID`);
3. the signer chain is valid (73.4) and holds the signer record the record names;
4. at that signer record the key is enrolled for the identity the record names and is not revoked; and if a later signer record revokes the key, that record lists this one as retained (`APPROVAL_SIGNER_NOT_ENROLLED`);
5. for a decision, the identity is the one the Project Engineering Pack assigns to the authority of the gate (BRS 1.2, unchanged).

A decision record that fails is an invalid decision record, with the consequences BRS 1.2 gives one: it satisfies no gate, and its candidate is blocked until the record is removed. A subject decision that fails has no effect (Section 65.1). An adoption record that fails satisfies nothing (Section 67.4).

Anyone can repeat the check with stock OpenSSH. `check_signers --allowed-signers` prints the chain as an OpenSSH allowed-signers file, and

```text
ssh-keygen -Y verify -f <allowed signers> -I <identity> -n engineering-harness -s <record>.yaml.sig
```

with the record's digest on standard input gives the same answer for a key that is not revoked.

**73.4 Signer chain.** A signer record is stored as `evidence/signers/SGN-<nnnn>.yaml` and contains: its ID; the action, `enrol` or `revoke`; the identity; the key, by type, public key and fingerprint; the previous signer record, by ID, path and digest; who signed it, by identity and key; the timestamp and how it was captured; and its self digest. A `revoke` record also gives the reason and the retained records: every signed record made with that key that verifies at the moment of revocation, by ID, path and digest.

- The first record is the **anchor**. It has no previous record, its action is `enrol`, and it is signed with the key it enrols, which proves that whoever enrolled the key holds it.
- Every later record names the record before it and is signed with a key that is enrolled and not revoked at that point. Records therefore form one chain, and its order is the order of enrolment and revocation.
- The identity of an `enrol` record shall hold at least one authority in the Project Engineering Pack when it is written (`SIGNER_IDENTITY_UNKNOWN`). The Pack still decides which identity holds which authority; the chain only says which keys speak for an identity.
- A key is enrolled at most once in the life of the chain, for one identity (`SIGNER_KEY_INVALID`).
- A revocation may be signed with any enrolled key, including the one it revokes. The last enrolled key cannot be revoked (`SIGNER_LAST_KEY`).

A record that does not reproduce its digest, a missing previous record, two records that name the same previous record, an anchor not signed by its own key, or a later record not signed by an enrolled key is `SIGNER_CHAIN_INVALID`. The chain is then invalid as a whole: no signed record verifies, the project is blocked with `resolve_blocker` (Section 37, row 1) and execution is prohibited, until the chain reproduces again.

v0.4.0 defines no way to continue a chain once every enrolled key is lost. Each project should enrol a second key that is kept apart from the first; `check_signers` and `inspect_project` warn while only one key is enrolled, and while an identity that holds an authority has none.

**73.5 Operations.**

- `enrol_signer` takes the identity and the public key file. On a project without a chain it writes the anchor and must be signed with the key it enrols. Otherwise it is signed with a key already enrolled.
- `revoke_signer` takes the fingerprint and the reason. The core computes the retained records and shows them to the operator before the signature is made.
- `check_signers` is read-only. It reports the anchor, every key with its identity and status, the faults of the chain and the warnings above, and prints the allowed-signers file on request.
- `trust_signers` records, on this machine, that the operator accepts the project's anchor (73.7).

`enrol_signer`, `revoke_signer` and `trust_signers` are operator commands (Section 68.2). They are permitted in either regime, whenever the release resolves and the Project Engineering Pack is valid.

**73.6 Signing.** The core never reads, stores or passes on a private key or a passphrase.

The CLI obtains a signature by starting `ssh-keygen -Y sign -n engineering-harness -f <key>` with the record's digest on its standard input. `<key>` is the path the operator gives with `--key` or in `ENGINEERING_HARNESS_SIGNING_KEY`: a private key file, or a public key file whose private part is held by an SSH agent or a hardware token. Passphrase entry, agent confirmation and touch happen between the operator and OpenSSH, on the operator's terminal. The CLI then verifies the signature as 73.3 and writes the record and its signature file together, the signature file first; a signature by a key that is not enrolled for the required identity writes nothing (`SIGNER_NOT_ENROLLED`). When OpenSSH is not installed or returns no signature the command fails with `GUARD_SIGNING_FAILED`.

Before it signs, the CLI asks OpenSSH whether a private key file opens with an empty passphrase. If it does and the key is not hardware-backed, the command fails with `GUARD_KEY_UNPROTECTED`: any process of the operator's user could have made that signature.

The library interface obtains the signature from a function its caller supplies and verifies it in the same way.

**73.7 Accepting the anchor on a machine.** The CLI keeps, per user and outside every project, the anchor it has been told to accept for each project root: a file under the user's configuration directory, or the file named by `ENGINEERING_HARNESS_TRUST_FILE`. It holds the project root path, the anchor's ID and digest and the anchor key's fingerprint.

- The command that writes an anchor records it as accepted.
- On a project whose anchor is not yet accepted on this machine, a reserved operation or operator command first shows the anchor (identity, key type, fingerprint, date) and asks the operator to type the last eight characters of the fingerprint. A wrong answer is `GUARD_ANCHOR_UNTRUSTED`.
- When the project's anchor differs from the accepted one the command is refused with `GUARD_ANCHOR_CHANGED` and names both. Only `trust_signers`, after the same confirmation, replaces the accepted anchor.

This is a check of the CLI on the operator's machine, like the terminal confirmation. No derived state depends on it, and a project is valid or invalid without it.

**73.8 Reporting.** `inspect_project`, `check_maintenance` and `check_signers` report, for each baseline, whether the approval it rests on is `signed` or `declared`, and for the project the anchor, the number of enrolled keys and the warnings of 73.4. A baseline that rests on a declared approval is as valid as BRS 1.2 made it and no more; a signed baseline whose upstream baseline rests on a declared approval is reported as such.

## 4. Schema changes

New schemas, all version 1, all with a closed top level:

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
| `schema://approval/signer/v1` | `signer.schema.json` | `evidence/signers/SGN-*.yaml` **[D-06c]** |
| `schema://approval/signature-assurance/v1` | `signature-assurance.schema.json` | the signer reference shared by every signed record: identity where the record has no approver, key type and fingerprint, signer record |

Changed schemas. Every change adds optional content, an enumeration value or a relaxed minimum, so every v0.3.0 document stays valid and keeps its digest (absent members stay absent, Section 16.3):

| Schema | Change |
| --- | --- |
| `validation-subject` | optional `revision` (change record, baseline to be superseded) |
| `approval-candidate` | optional `items`; optional `revision` (as the subject, plus the delta) |
| `human-decision` | optional `captured_via.confirmation`; `identity_assurance` also accepts `mechanism: ssh-signature`, `level: signed` with the key and the signer record **[D-06c]** |
| `work-item` | optional `change_refs`; `minItems` of `requirement_refs` and `acceptance_refs` lowered to 0, with the rule of Section 32 enforced by `control://validation/work-graph` **[D-02]** |
| `harness-release` | `core_contract`, `workflows`, `adapters`, `adoptable_from`; `bootstrap_workflow` no longer required (Section 71.3) |
| `next-action` | action `open_change` |
| `operation-result` | optional `regime`, `maintenance`, `work`, `permitted_operations`, `adapters`, `signers`; `provenance.installed_adapters`; `pending_gate.revision`, `pending_gate.authority` and `pending_gate.approver`; an optional `approval_assurance` in each baseline summary; the new operation names |
| `issue` | the codes and categories of 2.25 |

`baseline.schema.json` is unchanged: a baseline reaches its change record through its candidate. `human-gate.schema.json` is unchanged; two gate documents are added. The three baseline gate documents are byte-identical to v0.3.0: that a decision must be signed is a rule of this BRS for a project governed by v0.4.0, not a property of a gate and not a control, so it changes no engineering-resolution digest (Section 71.2).

The subject decision and the adoption record carry the signer reference as a required member. The adoption record also carries `declared_decisions`.

## 5. Canonicalisation annex

`harness-v1` is unchanged: same algorithm, same vectors. The annex gains the pre-sort rows and the self-digest rows of 2.10, the definition of an item's digest (Section 63.4), and one vector for each new content-addressed object (change record, change closure, subject decision, adoption record, signer record), for a validation subject with a revision and for a candidate with an item index and a revision context. Every existing vector must still reproduce.

A second annex, `annexes/signature-vectors.json`, holds signature vectors for Section 73.2: for each accepted key type a public key, a message, a signature made by OpenSSH and the expected result, and vectors that must fail (wrong namespace, altered message, altered signature, key of another type).

## 6. Release data of v0.4.0

- `VERSION`, `harness/harness.yaml`: `v0.4.0`, `core_contract: 2`, `workflows`, `adapters`, `adoptable_from: [v0.3.0]`.
- `schemas/`: Section 4.
- `workflows/maintenance.yaml`, `workflows/execution.yaml`.
- `gates/task-disposition.yaml`, `gates/registered-change.yaml`.
- `adapters/`: Section 69.2, including the v0.3.0 overlay files needed by Section 67.5. `adapters/copilot/.github/copilot-instructions.md`, `adapters/copilot/.github/prompts/` and `adapters/copilot/.vscode/settings.json` are no longer installed (`AGENT-SURFACES.md` gives the reasons).
- `controls/`, `profiles/`, `technologies/`: byte-identical to v0.3.0.
- `docs/v0.4.0/BRS.md`, `annexes/contract-tests.md`, `annexes/canonicalisation-*`: updated as above. `annexes/signature-vectors.json`: new.
