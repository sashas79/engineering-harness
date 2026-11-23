# Deterministic Harness Core

## Engineering Harness v0.4.0

### Business Requirements Specification

**Version:** 2.0
**Status:** Approved 2026-11-13; consolidated from BRS 1.2, the v0.4.0 change set revision 4 and the build rulings
**Release:** Engineering Harness v0.4.0

---

## 1. Purpose

This Business Requirements Specification defines the complete v0.3.0 deterministic Engineering Harness core required to turn versioned Harness contracts and project repository facts into reliable engineering state.

The implementation must provide deterministic answers to:

- Which Harness release governs this project?
- Is the repository structurally valid?
- Is the Project Engineering Pack complete and valid?
- What exact Project Engineering Pack revision is present?
- What engineering controls apply to the project?
- Is the resolved Project Engineering Baseline current?
- Are validation, approval and baseline records valid?
- What bootstrap state is supported by current evidence?
- What prevents progress?
- What is the next legally permitted action?
- Is implementation execution permitted?
- Which change records are open, and is a revision in progress?
- What changed between a candidate and the baseline it would supersede?
- Which Work Item is to be executed next, and what is the state of every Work Item?
- Which adapters are installed, and do their files match the release?
- Which operations will the core accept now, and from whom?

The implementation must not depend on AI reasoning, conversational history or adapter-specific interpretation for these answers.

---

## 2. Governing principle

The relationship is:

```text
Versioned Engineering Harness contracts
            +
Project repository facts
            ↓
Deterministic Harness Core
            ↓
Structured Harness result
            ↓
CLI | CI | AI adapter | later MCP

```

The Harness contracts define engineering semantics.

The deterministic core implements those semantics.

Adapters consume the result.

No adapter, AI agent or implementation component may independently redefine Harness semantics.

### 2.1 Normative handover package and precedence

This BRS, the version-1 schemas under `schemas/`, the `harness-v1` canonicalisation specification and vectors under `annexes/`, and the contract-test appendix form one normative development-handover package.

For v0.3.0 implementation purposes this package supersedes Chats 1–8 and earlier v0.3.0 design notes. Earlier material may explain origin or rationale but shall not change the behaviour defined here.

If two artefacts in this package appear inconsistent, precedence is:

```text
1. normative JSON Schema for field/type/required/null/enum structure
2. harness-v1 canonicalisation specification and authoritative vectors for byte/digest behaviour
3. this BRS for lifecycle, authority, semantic validation and operational behaviour
4. contract tests as executable examples of those contracts
```

A discovered contradiction between these layers is a contract defect and shall be raised rather than resolved by implementation inference.

---

## 3. Terminology

### Engineering Harness

The centrally governed, versioned engineering system containing:

- workflows;
- schemas;
- controls;
- standards;
- profiles;
- technologies;
- human gates;
- canonicalisation rules;
- evidence requirements; and
- other executable engineering policy.

### Project Engineering Pack

The human/project-owned project input set under:

```text
/project-pack

```

### Project Engineering Baseline

The resolved project-specific engineering controls under:

```text
/engineering

```

It is derived from the governing Harness release and Project Engineering Pack.

It is not a human-approved lifecycle baseline.

### Human-approved baseline

One of:

```text
Specification Baseline
Architecture Baseline
Work Baseline

```

### Validation subject

The exact content-addressed engineering state validated by deterministic controls.

### Approval candidate

The exact content-addressed object presented to a human authority for decision.

### Approval evidence

The immutable record of an explicit human approval or rejection of one exact candidate.

### Current

A valid state that still matches current repository facts and all required governing/upstream bindings.

### Stale

A historically valid state that no longer governs current downstream work because a required artefact or upstream binding changed.

**Maintenance regime.** The condition of a project governed by v0.4.0 or later whose `baselines/work/` holds at least one baseline record, valid or not. Otherwise the project is in the bootstrap regime.

**Governing Work Baseline.** The lineage head of the Work chain when it is historically valid, whether or not it is current.

**Change record.** The immutable, content-addressed statement of why a project in the maintenance regime is to be changed. Section 62.

**Revision.** The sequence of lifecycle operations that replaces one or more baselines under exactly one change record. Section 63.

**Reach.** How far up the baseline chain a change record extends: `none`, `execution`, `work`, `architecture` or `specification`. Section 62.3.

**Satisfied; settled.** A chain is *satisfied* for a change record when its lineage holds a baseline record, head or superseded, that reproduces its digest and whose candidate names that record or a planned record it supersedes. It is *settled* when it is satisfied and its head baseline is current.

**Work revision.** The condition in which the active revision change has reach `work`. In a revision of wider reach the task set and every effective status are those of the governing Work Baseline until the new Work Baseline exists.

**Item.** An identified element inside a candidate artefact. Section 63.4.

**Run.** One execution of one Work Item, recorded by the core. Section 64.

**Disposition.** A human decision that a Work Item is deferred or withdrawn. Section 65.

**Adoption.** The explicit, recorded change of the release that governs a project. Section 67.

**Reserved operation.** An operation that records a human decision. **Operator command.** A distribution command that changes the governing release or the installed adapters. Only a human operator may invoke either. Section 68.

**Launcher.** The agent-neutral project file through which every adapter invokes the core. Section 69.4.

**Signed record.** A decision record, subject decision, adoption record or signer record together with its signature file. **Signer.** An SSH public key enrolled for one identity of the Project Engineering Pack. **Signer chain.** The append-only sequence of signer records of a project. **Anchor.** The first record of the signer chain. Section 73.

---

# 4. Authority model

Authority shall be divided as follows.

| ConcernAuthority                   |                                                   |
| ---------------------------------- | ------------------------------------------------- |
| Lifecycle/state machine            | Versioned Harness                                 |
| Harness policy                     | Versioned Harness                                 |
| Schemas                            | Versioned Harness                                 |
| Human gates                        | Versioned Harness                                 |
| Profiles                           | Versioned Harness                                 |
| Technology catalogue               | Versioned Harness                                 |
| Engineering standards              | Versioned Harness                                 |
| Canonicalisation                   | Versioned Harness                                 |
| Project facts/configuration        | Project Engineering Pack                          |
| Project authority assignments      | Project Engineering Pack                          |
| Project-specific engineering state | Project repository                                |
| Human approval decision            | Required human authority                          |
| Deterministic state calculation    | Harness core implementing the contracts           |
| AI-assisted generation             | Execution adapter operating under Harness control |
| Runtime presentation               | CLI/CI/adapter                                    |
| Git                                | Optional provenance; not approval authority       |
| Statement of a change | Human operator; recorded by the core |
| Reach of a change | Harness core, from the release's maintenance workflow and the operator's request (Section 62.3) |
| Runtime task state | Harness core |
| Task disposition | Required human authority (`engineering`) |
| Acceptance of a registered change | Required human authority (`engineering`) |
| Adoption of a release | Human operator, who signs the adoption record; verified and recorded by the core |
| Enrolment and revocation of a signing key | Human operator holding an enrolled key; verified and recorded by the core |
| Custody of a private signing key | The human it belongs to. The core never reads one |

The project repository is authoritative for project-specific engineering state.

The recorded Harness release is authoritative for organisation-level engineering semantics.

---

# 5. Human control plane

The following authority roles exist:

| RoleResponsibility  |                                              |
| ------------------- | -------------------------------------------- |
| `product_domain`    | Business and functional correctness          |
| `architecture`      | Structural and architectural correctness     |
| `security_platform` | Security/platform constraints and exceptions |
| `engineering`       | Engineering quality and Work approval        |
| `release`           | Production release                           |

Mandatory bootstrap approvals are:

| BaselineRequired authority |                  |
| -------------------------- | ---------------- |
| Specification              | `product_domain` |
| Architecture               | `architecture`   |
| Work                       | `engineering`    |

The maintenance regime adds two decisions, both owned by `engineering`:

| Decision | Gate | Required authority |
| --- | --- | --- |
| Defer, withdraw or reinstate a Work Item | `gate://task-disposition` | `engineering` |
| Accept or reject a registered change | `gate://registered-change` | `engineering` |

A revision never removes or weakens a baseline gate. Each baseline a revision replaces is approved at its own gate by its own authority.

`security_platform` remains a recognised authority role for future security/platform controls. No executable security-exception trigger, candidate, decision or gate flow is included in the v0.3.0 vertical slice.

Production release remains a separate later lifecycle gate and is not implemented by the v0.3.0 bootstrap core.

AI may prepare material for approval.

AI may not originate, infer or fabricate a human approval.

---

# 6. Scope

## 6.1 Required

v0.3.0 shall implement:

- repository inspection;
- repository-structure validation;
- Harness provenance resolution;
- local governing Harness-release resolution;
- schema loading and validation;
- Project Engineering Pack validation;
- Project Pack fingerprinting;
- profile/control resolution;
- `/engineering` materialisation;
- `harness-v1` canonicalisation;
- SHA-256 content addressing;
- diagnostic validation;
- authoritative validation;
- validation-subject construction;
- validation evidence;
- approval-candidate construction;
- human-decision capture;
- Specification Baseline establishment;
- Architecture Baseline establishment;
- Work Baseline establishment;
- baseline integrity validation;
- baseline lineage validation;
- baseline historical validity;
- baseline currentness and staleness;
- staleness propagation;
- Project AI Policy integrity/currentness;
- Work Item validation;
- execution-graph validation;
- lifecycle-state derivation;
- next-action derivation;
- execution-readiness determination;
- structured result contracts;
- machine-readable issue reporting;
- CLI support;
- mutation locking and safe persistence;
- change records;
- revisions;
- candidate revision context and delta;
- the permitted-operation set;
- runtime task state operations;
- task selection;
- task dispositions;
- registered changes;
- release adoption;
- the reserved-operation guard;
- signed records and the signer chain;
- adapter installation, removal and verification;
- unit tests;
- canonicalisation conformance tests;
- contract tests; and
- end-to-end integration fixtures.

## 6.2 Explicitly out of scope

v0.3.0 does not require:

- Claude-specific lifecycle logic;
- MCP server;
- central Harness execution service;
- HTTP/web API server;
- database-backed Harness state;
- distributed orchestration;
- multi-agent runtime infrastructure;
- silent or automatic Harness-version migration (adoption is explicit, Section 67);
- profile inheritance;
- multiple-profile composition;
- broad enterprise standards catalogue;
- semantic interpretation of business requirements;
- deterministic assessment of architectural appropriateness;
- automatic human approval;
- approval-requiring project overrides;
- executable security-exception control/gate flow;
- custody, generation and protection of private signing keys;
- a public-key infrastructure or certificates;
- recovery of a signer chain whose keys are all lost;
- production deployment;
- production release implementation; or
- the complete Engineering Work Item execution engine.

Work Item execution is performed by an AI agent through the adapter command `execute`. The core selects the Work Item, validates and records its runtime state (Section 64) and performs no implementation work. The core remains outside the scope of an execution engine: it starts no agent, schedules nothing and runs no verification command.

---

# 7. Clean project contract

A freshly initialised project must contain structure and provenance but no fabricated lifecycle state.

The expected project shape is:

```text
project/
├── .engineering-harness-template
├── .engineering-harness-adapters          (present when at least one adapter is installed)
├── AGENTS.md, harness, harness.cmd        (present when at least one adapter is installed)
├── adapter files of each installed adapter
│
├── project-pack/
│   ├── project.yaml
│   ├── harness-profile.yaml
│   ├── project-policy.yaml
│   ├── source/
│   │   ├── manifest.yaml
│   │   └── ...
│   └── overrides/
│       └── ...
│
├── spec/
├── architecture/
├── engineering/
├── ai/
├── work/
│   ├── tasks/
│   └── state/
├── baselines/
├── evidence/
│   ├── changes/
│   ├── adoptions/
│   ├── decisions/
│   └── signers/
├── src/
├── tests/
└── infra/

```

The four directories are created by the first operation that writes into them. They are not required directories under FR-020, so a project without them, such as an adopted v0.3.0 project, is structurally valid.

A fresh project must not contain:

- approved Specification Baseline;
- approved Architecture Baseline;
- approved Work Baseline;
- generated Project AI Policy;
- generated Work Items;
- execution graph;
- task runtime state;
- change records;
- adoption records;
- runs;
- example-domain engineering state; or
- any artefact claiming an approval or lifecycle transition that has not occurred.

The initial lifecycle state is normally:

```text
PROJECT_INPUT_REQUIRED

```

---

# 8. Filesystem ownership

| PathOwnerHarness write rule  |                           |                                                             |
| ---------------------------- | ------------------------- | ----------------------------------------------------------- |
| `/project-pack/**`           | Human/project             | Never                                                       |
| `/spec/**`                   | Lifecycle generation      | Authorised lifecycle operation only                         |
| `/architecture/**`           | Lifecycle generation      | Authorised lifecycle operation only                         |
| `/engineering/**`            | Harness core              | Profile resolution only                                     |
| `/ai/**`                     | Lifecycle generation      | AI-policy derivation only                                   |
| `/work/tasks/**`             | Lifecycle generation      | Work generation only                                        |
| `/work/execution-graph.yaml` | Lifecycle generation      | Work generation only                                        |
| `/work/state/**` | Harness core | Runtime state operations only (Section 64); never part of a validation subject; a v0.3.0 state file is read and never rewritten |
| `/baselines/**`              | Harness                   | Append-only                                                 |
| `/evidence/validation/**`    | Harness                   | Append-only                                                 |
| `/evidence/candidates/**`    | Harness                   | Append-only                                                 |
| `/evidence/approvals/**`     | Harness                   | Append-only                                                 |
| `/evidence/changes/**` | Harness | Append-only |
| `/evidence/adoptions/**` | Harness | Append-only |
| `/evidence/decisions/**` | Harness | Append-only |
| `/evidence/signers/**` | Harness | Append-only |
| `<record>.yaml.sig` beside a signed record | Harness | Written once with its record; never rewritten |
| other `/evidence/**`         | Harness/toolchain/runtime | As contract permits                                         |
| `/src`, `/tests`, `/infra`   | Engineering execution     | Outside bootstrap mutation except authorised Work execution |
| Adapter overlay files, the managed block of `AGENTS.md`, `harness`, `harness.cmd`, `.engineering-harness-adapters` | Harness distribution | Adapter operations only (Section 69); never part of a fingerprint, validation subject or candidate |

A caller may never broaden these write permissions.

Every path in this table except `/src`, `/tests` and `/infra`, together with `.engineering-harness-template`, is a **reserved path**. No run may report a reserved path as changed, whatever the Work Item's `repository_scope` says (Section 64.4), and no registered change may name one (Section 66.2). Existing Work Items need no edit to protect the files of an adapter installed later.

Reserved paths also include both marker files, `.engineering-harness-adapter` and `.engineering-harness-adapters`.

---

# 9. Executable contract set

The version-1 JSON Schema Draft 2020-12 contracts under `schemas/` are normative and form part of this BRS. The schema catalogue is `schemas/schema-catalog.json`. Implementations shall resolve schema IDs through the governing Harness release; they shall not invent local variants of these contracts.

The implementation shall support the following schema families.

## 9.1 Common

- digest;
- timestamp;
- repository-relative path;
- Harness reference;
- issue;
- evidence reference;
- canonicalisation-version marker.

## 9.2 Provenance

- parsed distribution provenance;
- parsed adapter provenance;
- resolved Harness provenance.

The on-disk `.engineering-harness-template` and `.engineering-harness-adapter` grammars are defined in FR-033.

## 9.3 Project Engineering Pack

- project;
- Harness-profile selection;
- project policy;
- source manifest;
- override.

## 9.4 Harness resolution

- control;
- profile;
- technology;
- human gate;
- Engineering Harness release definition;
- engineering harness;
- engineering profile;
- engineering controls.

## 9.5 Lifecycle

- bootstrap workflow;
- lifecycle state;
- progress;
- blocking condition;
- next action.

## 9.6 Validation

- validation subject;
- validation evidence;
- control result.

## 9.7 Approval

- approval candidate;
- human-decision evidence;
- baseline.

## 9.8 Project state

- Project AI Policy;
- AI-policy provenance.

## 9.9 Engineering intent

- specification;
- requirement;
- acceptance criterion;
- architecture;
- ADR;
- contract reference.

## 9.10 Work

- Engineering Work Item;
- execution graph;
- repository scope.

## 9.11 Runtime

- `schema://result/operation/v1`, the normative shared operation-result schema;
- evidence envelope.

## 9.12 Maintenance

- change record;
- change closure;
- subject decision (task disposition, registered change).

## 9.13 Runtime state

- run;
- task result (the completion input document);
- legacy task state.

## 9.14 Adoption

- adoption record.

## 9.15 Adapters

- adapter manifest;
- installed-adapter provenance.

## 9.16 Workflows

- maintenance workflow;
- execution workflow.

## 9.17 Signatures

- signer record;
- signature assurance.

Every governed YAML document shall contain `schema_version: 1`. A release may add optional fields to a version-1 schema, add enumeration values and relax a minimum. It shall not remove a field, make an optional field required, or change the meaning or digest of a document that was valid under an earlier release from which it declares adoption (Section 67.7).

Schema references resolve only from the recorded Harness release. `schema://result/operation/v1` is the public machine contract consumed by CLI, CI and adapters; prose renderings are non-normative.

## 9.18 Schemas added and changed in v0.4.0

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
| `schema://approval/signer/v1` | `signer.schema.json` | `evidence/signers/SGN-*.yaml` |
| `schema://approval/signature-assurance/v1` | `signature-assurance.schema.json` | the signer reference shared by every signed record: identity where the record has no approver, key type and fingerprint, signer record |

Changed schemas. Every change adds optional content, an enumeration value or a relaxed minimum, so every v0.3.0 document stays valid and keeps its digest (absent members stay absent, Section 16.3):

| Schema | Change |
| --- | --- |
| `validation-subject` | optional `revision` (change record, baseline to be superseded) |
| `approval-candidate` | optional `items`; optional `revision` (as the subject, plus the delta) |
| `human-decision` | optional `captured_via.confirmation`; `identity_assurance` also accepts `mechanism: ssh-signature`, `level: signed` with the key and the signer record |
| `work-item` | optional `change_refs`; `minItems` of `requirement_refs` and `acceptance_refs` lowered to 0, with the rule of Section 32 enforced by `control://validation/work-graph` |
| `harness-release` | `core_contract`, `workflows`, `adapters`, `adoptable_from`; `bootstrap_workflow` no longer required (Section 71.3) |
| `next-action` | action `open_change` |
| `operation-result` | optional `regime`, `maintenance`, `work`, `permitted_operations`, `adapters`, `signers`; `provenance.installed_adapters`; `pending_gate.revision`, `pending_gate.authority` and `pending_gate.approver`; an optional `approval_assurance` in each baseline summary; the new operation names |
| `issue` | the codes and categories of Section 47 |

`baseline.schema.json` is unchanged: a baseline reaches its change record through its candidate. `human-gate.schema.json` is unchanged; two gate documents are added. The three baseline gate documents are byte-identical to v0.3.0: that a decision must be signed is a rule of this BRS for a project governed by v0.4.0, not a property of a gate and not a control, so it changes no engineering-resolution digest (Section 71.2).

The subject decision and the adoption record carry the signer reference as a required member. The adoption record also carries `declared_decisions`.

---

# 10. Common data rules

## 10.1 Digests

v0.3.0 supports SHA-256 only.

Representation:

```text
sha256:<64 lowercase hexadecimal characters>

```

## 10.2 Timestamps

Normative timestamps use RFC 3339 UTC:

```text
2026-09-03T12:30:00Z

```

## 10.3 Repository paths

Governed repository paths shall be:

- relative to project root;
- `/` separated;
- free of `.` and `..`;
- contained within the permitted root;
- non-symlink paths.

Backslash-separated governed paths are invalid.

## 10.4 Harness references

Stable namespaces are:

```text
schema://
profile://
technology://
control://
gate://
workflow://

```

References resolve only inside the governing Harness release.

Cross-release substitution is prohibited.

---

# 11. Functional requirements

## FR-001 — Deterministic core

The system shall provide one tool-independent deterministic Harness core.

## FR-002 — Repository-based state

The core shall derive project engineering state from repository evidence and the recorded Harness release.

## FR-003 — No conversational dependency

No deterministic conclusion may depend on conversational history.

## FR-004 — No AI inference

The core shall not use an LLM to infer repository facts, validation success, lifecycle state, authority, approval, currentness or next action.

## FR-005 — Equivalent callers

CLI, CI and adapters shall receive equivalent engineering conclusions for the same inputs.

## FR-006 — Fail closed

Where a required fact cannot be established, the prerequisite shall be treated as unsatisfied.

---

## FR-010 — Project-root boundary

Every public operation shall receive an explicit project root.

The core shall not search arbitrary parents or siblings for a project.

## FR-011 — Path containment

All governed project references shall remain inside the permitted project root or sub-boundary.

## FR-012 — Symlink prohibition

The Harness shall not follow symlinks as governed Harness/project artefacts.

---

## FR-020 — Repository structure

The core shall validate the clean-project structural contract.

Missing required directories are structural failures.

Missing lifecycle artefacts that have not yet been created are valid lifecycle facts.

Fabricated approval/baseline-looking records shall never be treated as valid lifecycle state.

---

## FR-030 — Harness provenance

The core shall reconcile:

```text
.engineering-harness-template
.engineering-harness-adapters
engineering/harness.yaml

```

where applicable.

In a project governed by v0.3.0 the core reads `.engineering-harness-adapter` under the v0.3.0 grammar.

## FR-031 — Recorded release

The project shall remain governed by its recorded Harness release. A newer available release shall not silently replace it. The governing release changes only through `adopt_release` (Section 67).

## FR-032 — Local release resolution

Every public core operation receives an explicit `harness_root` together with the explicit `project_root`. The core shall not discover a Harness registry from the working directory, user home directory, parent directories, network or conversational context.

`harness_root` is the local Harness release registry. A recorded release `vX.Y.Z` resolves only from:

```text
<harness_root>/releases/vX.Y.Z/
```

The resolved directory must contain the governing Harness release contracts, including `harness/harness.yaml` and the schema catalogue. Inspection shall not automatically download releases from the network.

Resolution status shall be:

```text
RESOLVED
NOT_RECORDED
NOT_FOUND
UNSUPPORTED
INCONSISTENT
```

A release declares the core contract it requires. A core resolves a release only when it implements that contract; otherwise the resolution status is `UNSUPPORTED` and nothing is written (Section 71.3).

The core API has no configuration fallback: missing `harness_root` is a caller/usage error. CLI/adapter resolution precedence is defined in Section 49.

## FR-033 — Distribution provenance grammar

`.engineering-harness-template` is UTF-8 without BOM, uses LF line endings, and contains exactly these lines in this order:

```text
repository=<non-empty repository URI/string>
version=<v-prefixed semantic version>
template=<canonical repository-relative path>
```

`.engineering-harness-adapter` uses the same encoding rules and contains exactly:

```text
name=<adapter identifier>
version=<v-prefixed semantic version>
source=<canonical repository-relative path>
```

`.engineering-harness-adapters` uses the same encoding rules and contains exactly:

```text
version=<v-prefixed semantic version>
adapters=<adapter identifier>[,<adapter identifier>...]
```

The identifiers are unique, in ascending code-point order, and each names an adapter of the governing release. `version` equals the governing release. The file is absent when no adapter is installed. Any violation, and the presence of `.engineering-harness-adapter` in a project governed by v0.4.0, produces `PROV_INCONSISTENT`.

Rules:

- no blank lines, comments or unknown keys;
- no whitespace around `=`;
- split each line at the first `=` only;
- keys are case-sensitive and may occur exactly once;
- values are non-empty and contain no CR, LF, NUL or other control characters;
- `template` and `source` obey the repository-relative path contract;
- malformed, duplicate, missing or extra entries produce `PROV_INCONSISTENT`;
- the template `version` is the recorded governing release before `/engineering` exists; and
- after `/engineering` exists, its resolved Harness version must match the recorded release.

The parsed forms conform to `schema://provenance/distribution/v1` and `schema://provenance/adapter/v1`.

## FR-034 — Harness-root convention

The deterministic core accepts only its explicit `harness_root` argument. Presentation layers (CLI, CI, adapters) obtain that argument by convention, in this precedence:

```text
1. ENGINEERING_HARNESS_ROOT environment variable
2. the directory named `_root` beside the core executable
3. no value → usage/configuration failure; do not inspect or download
```

The core executable, its `_root` registry and the governed projects are expected to sit side by side. The `_root` directory need not exist beforehand: project initialisation creates it, and for every other command a release missing under it is reported through release resolution (`NOT_FOUND`, Section 48), not as a usage failure. Step 3 applies only when no executable location is known (for example a checkout run through a script interpreter). No `--harness-root` argument exists; a presentation layer shall not accept one. The working directory, parent directories, the home directory and the network remain forbidden as registry sources. No other implicit registry is permitted in v0.3.0.

## FR-035 — Adapter distribution

Adapter distribution is defined in Section 69.

## FR-036 — Adapter execution command `/execute`

Adapter commands are defined in Section 70; runtime state in Section 64.

---

## FR-040 — Safe parsing

YAML/JSON shall be parsed deterministically.

The parser shall:

- reject duplicate mapping keys;
- disable unsafe/custom object construction;
- distinguish absent from explicit `null`;
- apply no schema defaults before hashing; and
- report parse and schema failures separately.

---

## FR-050 — Change records

Section 62.

## FR-051 — Revisions

Section 63.

## FR-052 — Permitted operations

Section 40.

## FR-053 — Runtime state

Section 64.

## FR-054 — Task dispositions

Section 65.

## FR-055 — Registered changes

Section 66.

## FR-056 — Release adoption

Section 67.

## FR-057 — Reserved operations and operator commands

Section 68.

## FR-058 — Adapters and adapter commands

Sections 69 and 70.

## FR-059 — Core contract of a release

Section 71.3.

## FR-060 — Signed records

Section 73.

---

# 12. Project Engineering Pack contract

The Pack is:

```text
project-pack/
├── project.yaml
├── harness-profile.yaml
├── project-policy.yaml
├── source/
│   ├── manifest.yaml
│   └── <declared sources>
└── overrides/
    └── <override records>

```

The Harness shall never modify this directory.

## 12.1 `project.yaml`

Contains:

- project ID;
- project name;
- recognised technology configuration; and
- project authority assignments.

At minimum the authority model supports:

```text
product_domain
architecture
security_platform
engineering
release

```

## 12.2 `harness-profile.yaml`

Contains exactly one selected profile.

It shall not define:

- Harness release;
- lifecycle;
- gates;
- controls; or
- central policy.

## 12.3 `project-policy.yaml`

May configure a Harness control only where that control explicitly exposes project configuration.

The core shall not infer whether arbitrary policy is stronger, weaker or equivalent.

## 12.4 Source manifest

Every source used for engineering shall be declared.

Each source shall have:

- unique source ID;
- path;
- role; and
- media type.

Source roles include:

```text
authoritative
supporting

```

At least one authoritative source is required.

Supporting material may inform engineering but may not silently override authoritative material.

## 12.5 Overrides

Controls are non-overrideable by default.

v0.3.0 supports only override points whose governing control explicitly declares:

```text
override.permitted = true
approval_required = false
```

A supported override is valid only if:

- target control exists;
- target permits override;
- the target does not require human approval for override;
- requested value satisfies the override contract;
- rationale is provided; and
- owner is a recognised project authority role.

**Approval-requiring overrides are explicitly out of scope for v0.3.0.** The core shall not create override approval candidates, capture override decisions or infer an approval. If an override targets a control whose override contract requires human approval, Project Pack validation fails with:

```text
CONTROL_OVERRIDE_APPROVAL_UNSUPPORTED
```

The Project Pack override schema therefore contains no approval-evidence field in version 1. A later Harness release may introduce an approval-requiring override flow through a new compatible contract/version.

---

# 13. Project Pack fingerprint

The Pack fingerprint shall be constructed from a canonical fingerprint subject.

It covers exactly:

```text
project-pack/project.yaml
project-pack/harness-profile.yaml
project-pack/project-policy.yaml
project-pack/source/manifest.yaml
all manifest-declared source files
all override records

```

No unrelated file participates.

## 13.1 Per-file digest rules

Harness-governed YAML/JSON:

```text
parse
→ harness-v1 canonical bytes
→ SHA-256

```

Arbitrary declared source files:

```text
exact raw file bytes
→ SHA-256

```

No line-ending or content transformation shall be applied to arbitrary source files.

## 13.2 Fingerprint subject

Each subject entry contains:

```text
canonical repository-relative path
digest

```

Entries are sorted by canonical path.

The full subject is canonicalised with `harness-v1` and SHA-256 hashed.

## 13.3 Fingerprint states

The core shall distinguish:

```text
observed_fingerprint
validated_fingerprint
resolution_source_fingerprint

```

An invalid Pack may have an observed fingerprint.

It may not have a new validated fingerprint.

If the fingerprint subject cannot be constructed deterministically:

```text
observed_fingerprint = null
fingerprint_status = UNCOMPUTABLE

```

A changed observed fingerprint immediately makes the existing `/engineering` resolution non-current.

---

# 14. Profile resolution

Effective project controls are:

```text
invariant Harness controls
+
one selected profile
+
recognised technology controls
+
permitted project configuration
+
valid supported overrides

```

v0.3.0 supports:

```text
one profile
no inheritance
no profile composition
no general last-write-wins

```

Profile resolution shall fail closed on:

- unknown profile;
- multiple profiles;
- unsupported inheritance;
- unknown technology;
- unknown control;
- project configuration at a non-configurable point;
- override of a non-overrideable control;
- approval-requiring override in v0.3.0;
- unresolved conflict;
- untraceable control provenance.

Technology definitions may add technology-specific:

- standards; and
- validations.

They may not redefine:

- lifecycle;
- mandatory gates; or
- organisation governance.

Effective controls shall be ordered by control ID before resolution hashing.

---

# 15. `/engineering`

Successful `bootstrap_repository` shall materialise:

```text
engineering/
├── harness.yaml
├── profile.yaml
└── controls.yaml

```

## 15.1 `harness.yaml`

Records:

- governing Harness release;
- source;
- selected profile; and
- validated Project Pack revision.

## 15.2 `profile.yaml`

Records:

- selected profile;
- recognised technologies;
- project configuration;
- applied overrides; and
- source Project Pack fingerprint.

## 15.3 `controls.yaml`

Records the complete effective control set and origin/provenance of every control.

`/engineering`:

- is project engineering state;
- is not independent organisation policy;
- is not a human-approved lifecycle baseline.

## 15.4 Materialisation safety

The complete new resolution shall be:

```text
calculated
→ validated
→ canonicalised
→ hashed
→ staged
→ published

```

as one logical mutation.

Failure must leave the previous authoritative `/engineering` state intact.

Read-only inspection shall never rematerialise `/engineering`.

---

# 16. Canonicalisation and hashing

One shared canonicalisation service shall implement `harness-v1`. The complete normative contract is `annexes/canonicalisation-harness-v1.md`; authoritative vectors are `annexes/canonicalisation-vectors.json`. This section summarises the required behaviour.

## 16.1 Allowed governed YAML subset

Governed YAML input uses **YAML 1.2.2** syntax restricted to the following JSON-compatible data model:

```text
mapping with string keys only
sequence
Unicode string
boolean
null
signed base-10 integer
```

The following are prohibited in governed content-addressed YAML:

- anchors, aliases and merge keys;
- explicit/custom tags;
- multiple YAML documents;
- non-string mapping keys;
- floats, exponent notation, NaN and infinities;
- hexadecimal, octal or other non-decimal integer lexical forms;
- `+`-prefixed integers;
- negative zero;
- duplicate mapping keys; and
- UTF BOM.

Accepted scalar spellings for typed YAML scalars are lowercase `true`, `false`, `null`, and decimal integers matching `0|-?[1-9][0-9]*`. Other scalar spellings are strings only when quoted.

Integers are limited to signed 64-bit range:

```text
-9223372036854775808 .. 9223372036854775807
```

Arbitrary manifest-declared source files are not governed YAML merely because their extension resembles YAML; their hashing rule remains exact raw bytes unless the source is itself a Harness-governed document.

## 16.2 String and key normalisation

For governed values, normalise string line endings `CRLF` and `CR` to `LF`, then normalise Unicode to NFC. Surrogate code points are invalid.

Mapping keys undergo the same normalisation before ordering. If two distinct parsed keys normalise to the same key, canonicalisation fails with:

```text
CANONICALISATION_KEY_COLLISION
```

No value is silently discarded.

## 16.3 Canonical JSON encoding

Canonical bytes are UTF-8 JSON with no BOM and no insignificant whitespace.

Object keys are sorted lexicographically by Unicode scalar-value sequence after line-ending/NFC normalisation.

Strings use exactly these escaping rules:

- `"` becomes `\"`;
- `\` becomes `\\`;
- U+0008, U+0009, U+000A, U+000C and U+000D use `\b`, `\t`, `\n`, `\f`, `\r`;
- all other U+0000–U+001F characters use lowercase `\u00xx`;
- all other Unicode scalar values are emitted directly as UTF-8, including U+2028 and U+2029.

Integers are emitted in minimal base-10 form with no leading zero and no plus sign. JSON booleans/null are exactly `true`, `false`, `null`.

Absent and explicit `null` remain different. Schema defaults are not inserted before hashing.

## 16.4 Collection ordering

User-authored arrays preserve their declared order unless their schema explicitly defines set semantics. Deterministically generated set-like collections shall be pre-sorted before canonical JSON generation as follows:

| Object / field | Sort key |
|---|---|
| Project Pack fingerprint `entries` | canonical `path` ascending |
| Engineering resolution `controls` | `id` ascending |
| Engineering profile `technology` | technology ID ascending |
| Engineering profile `configuration` | `control` ascending |
| Engineering profile `overrides` | override ID ascending |
| Validation subject `upstream` | `type`, then `baseline_id` ascending |
| Validation subject `artifacts` | canonical `path` ascending |
| Validation evidence `controls` | `control` ascending |
| Validation evidence/control-result `issues` | `code`, then `location` (empty last), then `message` ascending |
| Approval candidate `upstream` | `type`, then `baseline_id` ascending |
| Approval candidate `artifacts` | canonical `path` ascending |
| Project AI Policy `controls` | `control` ascending |
| Candidate `items` | `kind`, then `id` ascending |
| Candidate `revision.delta` lists (`added`, `changed`, `removed`) | artefact lists by `path`; item lists by `kind`, then `id` |
| Adoption record `baselines` | `type` ascending |
| Adoption record baseline `items` | `kind`, then `id` ascending |
| Change record `rework` | task ID ascending |
| Adoption record `declared_decisions` | `id` ascending |
| Signer record `retained` | `path` ascending |
| Any generated issue list included in a content-addressed object | `code`, `location` (empty last), `message` ascending |

All other arrays are order-significant and are preserved. An implementation shall not invent additional sorting.

## 16.5 Paths

Governed repository-path fields must already satisfy the canonical repository-path contract before serialisation. No platform-specific path separator conversion occurs after schema/semantic path validation.

## 16.6 Self-digest exclusion

Only the exact self-digest field declared by the object's version-1 schema is omitted from its hash preimage. Nested and upstream digests remain included. The authoritative exclusion paths are listed in the canonicalisation annex and vectors.

The self-digest fields of the objects added in v0.4.0 are: change record `change.binding.digest`; change closure `closure.binding.digest`; subject decision `decision.binding.digest`; adoption record `adoption.binding.digest`; signer record `signer.binding.digest`. Runs carry no self digest and are not canonicalised objects. A signature file is not a governed YAML document and is outside canonicalisation: it signs the self digest of its record (Section 73.2).

## 16.7 Digest

Canonical bytes are hashed with SHA-256 and represented as:

```text
sha256:<64 lowercase hexadecimal characters>
```

## 16.8 Conformance

The authoritative vectors cover at least:

- Project Pack fingerprint;
- engineering resolution;
- validation subject;
- approval candidate;
- approval evidence;
- Project AI Policy; and
- baseline.

`harness-v1` is unchanged: same algorithm, same vectors. The annex gains the pre-sort rows and the self-digest rows of Sections 16.4 and 16.6, the definition of an item's digest (Section 63.4), and one vector for each new content-addressed object (change record, change closure, subject decision, adoption record, signer record), for a validation subject with a revision and for a candidate with an item index and a revision context. Every existing vector must still reproduce.

A second annex, `annexes/signature-vectors.json`, holds signature vectors for Section 73.2: for each accepted key type a public key, a message, a signature made by OpenSSH and the expected result, and vectors that must fail (wrong namespace, altered message, altered signature, key of another type).

Any failed normative vector blocks release. Unsupported canonicalisation versions fail closed.

---

# 17. Validation model

Validation has two distinct modes.

## 17.1 Diagnostic checks

Diagnostic `check_*` operations:

- read current facts;
- return findings;
- write nothing;
- create no evidence;
- create no candidate;
- do not advance lifecycle.

## 17.2 Authoritative validation

Authoritative `validate_*` operations execute under the project mutation lock.

For a `FAIL` or `ERROR` control outcome:

```text
construct exact validation subject
→ canonicalise/hash
→ execute applicable deterministic controls
→ construct validation evidence
→ persist validation evidence only, append-only
```

A `FAIL` or `ERROR` creates no approval candidate. `ERROR` never satisfies a prerequisite.

For a `PASS` control outcome, PASS evidence and the candidate are one logical mutation:

```text
construct exact validation subject
→ canonicalise/hash
→ execute applicable deterministic controls
→ build PASS evidence in memory/staging
→ build candidate in memory/staging from that exact PASS subject/evidence
→ final reread/reconstruction of current subject
→ confirm current subject still matches the staged PASS subject
→ validate staged evidence + candidate
→ publish PASS evidence and candidate together atomically
→ enter AWAITING_*_APPROVAL
```

The implementation shall not expose a committed PASS evidence record without its corresponding candidate. If final subject re-verification fails, neither staged PASS evidence nor staged candidate is published; the operation returns `VALIDATION_SUBJECT_CHANGED` and validation must run again.

Candidate preparation is part of successful authoritative validation and is not a separate public lifecycle operation.

---

# 18. Validation subjects

A validation subject binds, as applicable:

- governing Harness release;
- engineering-resolution digest;
- Project Pack fingerprint;
- immediate upstream baseline;
- applicable Project AI Policy;
- artefact paths; and
- artefact digests.

The subject is content-addressed using `harness-v1`.

If current repository facts no longer reproduce the validated subject before candidate creation:

```text
VALIDATION_SUBJECT_CHANGED

```

and validation must run again.

In the maintenance regime a validation subject constructed by `validate_*` also binds the revision: the change record, by ID and digest, and the baseline to be superseded, by ID and digest. A subject constructed in the bootstrap regime has no such member, so every v0.3.0 subject keeps its digest. Validation evidence is therefore specific to one change record: content validated under one change record is not validated under another.

In the maintenance regime a chain has up to two subjects:

- The **baseline subject** is rebuilt from current facts with the revision member that the head baseline's own candidate records, or with none when that candidate records none, and with the release that candidate binds (Section 29). It is the subject used for the currentness of the head baseline (Section 29), for "Work graph valid" (Section 43) and for the upstream and Project AI Policy bindings of downstream chains. A baseline established in a revision therefore stays current after its change record is completed, for as long as its artefacts and bindings match, and opening a change record makes no baseline stale.
- The **revision subject** exists only for the chain X of the active revision change C (Section 37). It binds C, X's head baseline and the governing release. It is the subject of `validate_<x>`, of rows 9 to 11 and 13 of Section 37 and of the candidate offered for decision. No other chain has a revision subject.

---

# 19. Validation evidence

Authoritative validation evidence shall be stored under:

```text
evidence/validation/

```

Evidence shall identify:

- validation subject;
- subject digest;
- controls executed;
- per-control results;
- overall `PASS | FAIL | ERROR`;
- governing Harness release;
- engineering resolution; and
- authoritative capture timestamp.

Evidence is append-only.

A failed/error validation is never edited into a pass.

A new validation creates a new record.

---

# 20. Candidate artefact scopes

The following scopes are normative for v0.3.0.

## 20.1 Specification

Canonical specification:

```text
spec/specification.yaml

```

Specification candidate scope:

```text
spec/specification.yaml

```

The specification model contains:

- requirements;
- acceptance criteria;
- source references;
- stable IDs;
- assumptions/ambiguities where represented.

Deterministic checks cover structure, IDs and traceability.

The Harness does not deterministically claim business intent is semantically correct or complete.

## 20.2 Architecture

Canonical architecture artefacts:

```text
architecture/architecture.yaml
architecture/adrs/*.yaml
architecture/contracts/*.yaml

```

Architecture candidates bind all matching governed files sorted by canonical path.

Deterministic checks cover structure, IDs, references and traceability.

Architectural appropriateness remains human/AI-assisted judgement.

## 20.3 Project AI Policy

Canonical Project AI Policy:

```text
ai/policy.yaml

```

It is content-addressed but is not human-baselined.

## 20.4 Work

Work candidate scope:

```text
work/tasks/*.yaml
work/execution-graph.yaml

```

Explicitly excluded:

```text
work/state/**
README*
.gitkeep
temporary files
diagnostic outputs

```

Runtime Work state therefore never changes the approved Work definition.

---

# 21. Approval candidates

Candidates shall be stored under:

```text
evidence/candidates/

```

Each candidate binds:

- type;
- Harness release;
- engineering resolution;
- applicable Project Pack fingerprint;
- applicable immediate upstream baseline;
- applicable AI Policy;
- exact candidate artefact paths and hashes;
- PASS validation-subject digest;
- PASS validation-evidence path and digest;
- the item index of the candidate artefacts (Section 63.4); and
- in the maintenance regime, the revision context: the change record and the baseline to be superseded, as bound by the subject, and the delta (Section 63.4).
- digest algorithm;
- canonicalisation version; and
- candidate digest.

Candidate digest excludes only its own self-digest field.

A persisted candidate must contain enough information to reproduce its digest without relying on historical versions of current project files.

No `AWAITING_*_APPROVAL` state may exist without a valid persisted candidate.

In the maintenance regime a candidate is offered for decision and can establish a baseline only when its subject digest equals the revision subject of its chain. Its revision context then names the active revision change (Section 63.2) and the head baseline of its chain. A candidate without a revision context, or naming another change record, is never offered for decision and never establishes a baseline in the maintenance regime. The candidate of a head baseline keeps its role in the currentness of that baseline.

While a candidate's artefacts match the working tree, the core recomputes its item index and its delta. A difference invalidates the candidate (`REVISION_DELTA_MISMATCH`).

---

# 22. Human decisions

The supported candidate decisions are:

```text
approved
rejected

```

A decision must:

- reference one exact candidate;
- reproduce that candidate's digest;
- identify the required gate;
- identify the approver;
- identify the approver authority;
- satisfy required identity assurance;
- contain an authoritative Harness-generated timestamp.

Identity assurance in a project governed by v0.4.0 is:

```text
identity_assurance.mechanism = ssh-signature
identity_assurance.level = signed
```

The recorded approver identity matches the identity assigned to the required authority in the Project Engineering Pack, and the decision record carries a signature made with a key enrolled for that identity (Section 73). A decision record without such a signature satisfies no gate.

One exception keeps the BRS 1.2 assurance (`declared-project-identity`, `declared`): a decision recorded under a release without signed decisions, when an adoption record lists it (Section 67.4). Such a decision keeps its declared assurance and gains nothing: it claims no cryptographic authentication, and every result that reports a baseline resting on it says so.

A decision is captured only through a reserved operation under the guard of Section 68. The decision record states how it was captured, including the confirmation the guard obtained.

Caller-supplied timestamps are non-authoritative.

Silence is not approval.

Previous unrelated agreement is not approval.

AI-generated approval is not approval.

Decisions on a Work Item or on a registered change follow the same rules, with the subject of Section 65 or 66 in place of a candidate.

---

# 23. Decision finality

Each candidate may receive exactly one human decision.

After either:

```text
approved

```

or:

```text
rejected

```

the candidate is closed permanently.

A rejected candidate:

- remains historical evidence;
- cannot later be approved;
- cannot establish a baseline.

A later decision requires a new candidate.

---

# 24. Approved intermediate states

Approval and baseline establishment are separate controls.

The lifecycle therefore includes:

```text
SPECIFICATION_APPROVED
ARCHITECTURE_APPROVED
WORK_APPROVED

```

These states exist when:

- an exact current candidate has an approved human decision; and
- the corresponding baseline has not yet been established.

They allow deterministic recovery if a process stops after approval but before final baseline establishment.

If current facts cease to match the approved candidate before baseline establishment, the approved record remains historical evidence but the lifecycle falls back to the highest state still supported by current evidence.

---

# 25. Baseline establishment

Supported baseline types:

```text
specification
architecture
work

```

Before creating a baseline, the core shall reverify:

- candidate exists;
- candidate digest reproduces;
- validation evidence exists;
- validation evidence digest reproduces;
- validation result is `PASS`;
- approval evidence exists;
- approval evidence digest reproduces;
- approval references the exact candidate;
- decision is `approved`;
- required authority matches;
- identity assurance satisfies the gate;
- candidate artefacts still match;
- governing engineering resolution is correct/current;
- immediate upstream baseline is correct/current;
- Project AI Policy is correct/current for Work;
- in the maintenance regime, the candidate's change record exists, reproduces its digest and is the active revision change (Section 63.2);
- the candidate's item index and delta reproduce;
- the approval's identity assurance satisfies Section 22: its signature verifies under Section 73.3, or an adoption record carries it.
- lineage is valid.

Only then may the baseline be created.

Git commit data may be recorded as optional provenance.

Git is not the normative approval boundary.

---

# 26. Baseline persistence

Baselines shall be stored append-only under:

```text
baselines/specification/
baselines/architecture/
baselines/work/

```

Existing baseline records may never be:

- overwritten;
- edited;
- repaired;
- truncated; or
- reused for another approval.

Corrections create new records.

---

# 27. Baseline bindings

| BaselineRequired bindings |                                                                                                                             |
| ------------------------- | --------------------------------------------------------------------------------------------------------------------------- |
| Specification             | Project Pack fingerprint + engineering resolution + Specification candidate + validation + approval                         |
| Architecture              | current Specification Baseline + engineering resolution + Architecture candidate + validation + approval                    |
| Work                      | current Architecture Baseline + engineering resolution + current Project AI Policy + Work candidate + validation + approval |

Work does not directly bind Specification because the Architecture Baseline already carries that upstream dependency.

---

# 28. Baseline lineage

Same-type baselines form explicit supersession chains.

Required rules:

```text
same type
explicit supersedes
acyclic
single head

```

A new baseline supersedes the existing same-type head.

The following fail closed:

- two unsuperseded heads;
- supersession cycle;
- cross-type supersession;
- missing predecessor;
- invalid predecessor.

Timestamps never select the current baseline.

---

# 29. Validity and currentness

The core shall expose separately:

```text
integrity
historical_validity
currentness
lineage_position

```

A baseline is current only when:

```text
historically valid
+
unsuperseded lineage head
+
current candidate artefacts still match
+
all required governing/upstream state remains current

```

**Release binding through adoption.** A candidate and its validation evidence bind the Harness release under which they were written. That binding is satisfied by the governing release when the two are equal. It is also satisfied when an unbroken chain of valid, control-equivalent adoption records (Section 67) leads from the bound release to the governing release and the first record of the chain lists the candidate as the candidate of a baseline.

In the second case every rule of this BRS that compares that record's validation-subject digest with a subject rebuilt from current facts rebuilds it for the release the record binds (Section 18). This applies to candidate currentness (Section 21), to the latest authoritative validation of the subject (Sections 17.2 and 36) and to "Work graph valid" (Section 43), which is always evaluated on the baseline subject of the governing Work Baseline. Validation evidence for a revision subject counts only for rows 9 to 13 of Section 37. Every other binding is compared exactly as before.

The baseline subject of an adopted chain binds the head candidate's release exactly while the current facts reproduce that candidate's subject digest, and otherwise the governing release.

An adoption record that is missing, does not reproduce its digest or is not control-equivalent satisfies nothing: the binding fails and the baseline is stale.

The Project AI Policy binds no release. It is current when Section 31 holds under the governing release.

A historically valid baseline may become stale.

Staleness does not retroactively invalidate its historical approval.

A superseded baseline can never become current again.

An unsuperseded stale baseline becomes current again if all complete approved bindings later match current facts exactly.

No separate edit-history ledger is required in v0.3.0.

A baseline that a revision will supersede remains the lineage head until then, and remains historically valid after it is superseded. No operation edits it.

---

# 30. Staleness propagation

The following dependency rules are mandatory.

```text
Project Pack changes
    ↓
engineering resolution stale
    ↓
Specification stale
    ↓
Architecture stale
    ↓
AI Policy stale
    ↓
Work stale
    ↓
execution prohibited

```

```text
Specification stale
    ↓
Architecture stale
    ↓
AI Policy stale
    ↓
Work stale

```

```text
Architecture stale
    ↓
AI Policy stale
    ↓
Work stale

```

```text
AI Policy stale
    ↓
Work stale

```

```text
Work artefacts/graph changed
    ↓
Work stale

```

Staleness is derived.

Mutable `current`, `approved`, `stale` or `superseded` flags are not authoritative.

A control-equivalent adoption changes no engineering-resolution digest and propagates no staleness. An adoption that is not control-equivalent is refused in v0.4.0 (Section 67.3).

---

# 31. Project AI Policy

`ai/policy.yaml` shall bind:

- current Architecture Baseline;
- Architecture candidate digest; and
- current engineering-resolution digest.

It is current only when:

```text
its content digest reproduces
+
bound Architecture Baseline is current
+
bound engineering resolution is current

```

A stale/invalid AI Policy makes Work stale and prohibits execution.

---

# 32. Work contract

Each Engineering Work Item shall contain at least:

- unique ID;
- title;
- requirement references;
- acceptance-criterion references;
- architecture/contract references;
- dependencies;
- repository scope;
- change references (`change_refs`), optional;
- verification controls; and
- human gates.

The execution graph is authoritative for task dependency ordering.

Deterministic validation shall verify:

- Work Item schemas;
- graph schema;
- unique task IDs;
- all graph task references;
- all dependency references;
- acyclic graph;
- agreement between task and graph dependencies;
- required baseline references;
- requirement references;
- acceptance references;
- architecture/contract references;
- complete acceptance-criterion coverage required by v0.3.0;
- repository-scope validity;
- verification-control references;
- every change reference resolves to a change record held by the repository;
- when the validation subject binds a revision, every Work Item whose `task` item is added or changed against the baseline to be superseded lists the change record of the revision, or a planned record that it supersedes, in `change_refs`, and keeps every `change_refs` entry it has in that baseline;
- a Work Item whose `requirement_refs` or `acceptance_refs` is empty lists at least one change record whose kind is `documentation` or `defect` and which declares at least one acceptance statement.
- human-gate references.

The second of the three validations last listed evaluates only facts the validation subject binds. The first and third also read the change records the Work Items list; a listed record whose file does not reproduce its digest is `CHANGE_RECORD_INVALID`, a row-1 fault reported before any control runs. A Work Item that lists a change record for which no file exists is `CHANGE_REFERENCE_INVALID`, a validation failure of the work-graph control.

For the third validation the qualifying change record may have any status, also abandoned or superseded: its acceptance statements stay readable and content-addressed, and the approver sees the Work Item in the delta at the gate.

A requirement/acceptance criterion requiring implementation coverage must be covered by at least one Work Item. A deferred or withdrawn Work Item still counts as coverage for validation. Whether its criteria are met is reported by Section 65.4, not by validation.

Claims such as:

```text
the task is well decomposed
the architecture is sensible
the task is independently verifiable

```

shall not be represented as deterministic PASS results unless an executable rule explicitly exists.

---

# 33. Read-only operations

The required read-only operations are:

```text
inspect_project
check_repository_structure
read_provenance
check_project_pack
check_profile_resolution
check_specification
check_architecture
check_work_graph
check_baseline
check_execution_readiness
determine_bootstrap_state
determine_next_action
check_maintenance
check_adapters
check_signers
list_tasks
select_task

```

Read-only operations shall:

- write nothing;
- create no evidence;
- create no candidates;
- create no baselines;
- perform no repair;
- perform no migration;
- rematerialise nothing.

Repeated execution against unchanged inputs shall be idempotent.

---

# 34. Mutating lifecycle operations

The lifecycle operations are:

```text
bootstrap_repository
ingest_specification
validate_specification
record_specification_decision
baseline_specification
derive_architecture
validate_architecture
record_architecture_decision
baseline_architecture
derive_project_ai_policy
generate_work_items
validate_work_graph
record_work_decision
baseline_work

```

```text
Maintenance operations:   open_change, abandon_change
Runtime state operations: start_task, record_task_progress, block_task, complete_task, reopen_task
Reserved operations:      record_specification_decision, record_architecture_decision, record_work_decision,
                          record_task_decision, record_change_decision
```

Ownership:

| OperationExecution ownership    |                                           |
| ------------------------------- | ----------------------------------------- |
| `bootstrap_repository`          | Deterministic core                        |
| `ingest_specification`          | AI/adapter-assisted under Harness control |
| `validate_specification`        | Deterministic core                        |
| `record_specification_decision` | Core captures explicit human decision     |
| `baseline_specification`        | Deterministic core                        |
| `derive_architecture`           | AI/adapter-assisted under Harness control |
| `validate_architecture`         | Deterministic core                        |
| `record_architecture_decision`  | Core captures explicit human decision     |
| `baseline_architecture`         | Deterministic core                        |
| `derive_project_ai_policy`      | AI/adapter-assisted under Harness control |
| `generate_work_items`           | AI/adapter-assisted under Harness control |
| `validate_work_graph`           | Deterministic core                        |
| `record_work_decision`          | Core captures explicit human decision     |
| `baseline_work`                 | Deterministic core                        |

The AI-assisted operation may generate engineering content.

The core remains responsible for:

- whether the operation is permitted;
- its required inputs;
- allowed write scope;
- resulting deterministic validation;
- lifecycle state; and
- next action.

| Operation | Execution ownership | Who may invoke it |
| --- | --- | --- |
| `open_change` | Adapter-assisted under Harness control: the operator states the change, the core records it | adapter or operator |
| `abandon_change` | Deterministic core | adapter or operator |
| `start_task`, `record_task_progress`, `block_task`, `complete_task`, `reopen_task` | The core records what the caller reports and validates what it can check deterministically | adapter or operator |
| `record_*_decision`, `record_task_decision`, `record_change_decision` | Core captures explicit human decision | operator only |

The distribution commands are `init`, `adopt_release`, `enrol_signer`, `revoke_signer`, `trust_signers`, `adapter_add`, `adapter_remove`, `adapter_sync`, `render_adapters`, `adapter_guard`, `pack_questionnaire`, `pack_brief`, `approve_pending` and `reject_pending`. They share the executable and are not lifecycle operations. `approve_pending` and `reject_pending` are short forms of the three `record_*_decision` operations on a baseline candidate and are reserved in the same way. `adopt_release`, `enrol_signer`, `revoke_signer`, `trust_signers`, `adapter_add`, `adapter_remove` and `adapter_sync` are operator commands (Section 68).

Every lifecycle, maintenance, runtime state and reserved operation is accepted only when the core's current result offers it, as the next action or in `permitted_operations` (Section 40).

---

# 35. Authoritative lifecycle

The final v0.3.0 bootstrap states are:

```text
PROJECT_INPUT_REQUIRED
PROJECT_INPUT_READY
REPOSITORY_INITIALISED

SPECIFICATION_IN_PROGRESS
AWAITING_SPECIFICATION_APPROVAL
SPECIFICATION_APPROVED
SPECIFICATION_BASELINED

ARCHITECTURE_IN_PROGRESS
AWAITING_ARCHITECTURE_APPROVAL
ARCHITECTURE_APPROVED
ARCHITECTURE_BASELINED

WORK_DECOMPOSITION_IN_PROGRESS
AWAITING_WORK_APPROVAL
WORK_APPROVED
WORK_BASELINED

EXECUTION_READY

```

Progress is separate:

```text
ready
blocked

```

`BLOCKED` is therefore not a primary lifecycle state.

It is a progress condition attached to the highest supported lifecycle state.

---

# 36. State derivation contract

State shall never be trusted from a stored mutable state flag.

It is derived from:

```text
repository structure
+
Project Pack validity/currentness
+
engineering resolution validity/currentness
+
artefact existence
+
validation evidence
+
candidate evidence
+
human decision evidence
+
baseline integrity/currentness
+
AI Policy validity/currentness
+
Work graph validity
+
execution-readiness prerequisites
```

The result is the highest state whose complete prerequisite chain is currently supported.

The pre-engineering states are distinguished explicitly:

```text
PROJECT_INPUT_REQUIRED
    Project Pack is incomplete or invalid.

PROJECT_INPUT_READY
    Project Pack is valid and fingerprintable, but no current /engineering resolution exists for that exact validated Pack revision.

REPOSITORY_INITIALISED
    Project Pack is valid and a current resolved /engineering state exists for that exact validated Pack revision.
```

A valid changed Project Pack immediately makes the old engineering resolution non-current and therefore derives `PROJECT_INPUT_READY`, regardless of how far the project had previously progressed. Historical baselines/evidence remain intact but downstream currentness is stale until the Pack is resolved and the required lifecycle is re-established.

---

# 37. Complete lifecycle/state/next-action contract

| Derived state/condition | Required evidence | Progress | Next action kind | Next action |
|---|---|---|---|---|
| `PROJECT_INPUT_REQUIRED` — required input missing | Clean repository + Pack incomplete | ready | `HUMAN_INPUT` | `complete_project_pack` |
| `PROJECT_INPUT_REQUIRED` — Pack supplied but invalid | Pack parse/schema/semantic failure | blocked | `HUMAN_INPUT` | `correct_project_pack` |
| `PROJECT_INPUT_READY` | Pack valid + validated fingerprint exists + no current `/engineering` resolution for that exact Pack revision | ready | `HARNESS_OPERATION` | `bootstrap_repository` |
| `REPOSITORY_INITIALISED` | Valid Pack + current resolved `/engineering`; no Specification | ready | `HARNESS_OPERATION` | `ingest_specification` |
| `SPECIFICATION_IN_PROGRESS` — no authoritative validation | Specification exists | ready | `HARNESS_OPERATION` | `validate_specification` |
| `SPECIFICATION_IN_PROGRESS` — latest authoritative validation failed | Current specification has FAIL/ERROR evidence or rejected candidate requiring rework | blocked | `REWORK` | `correct_specification` |
| `AWAITING_SPECIFICATION_APPROVAL` | Current PASS validation + current persisted candidate + no decision | ready | `HUMAN_DECISION` | `record_specification_decision` |
| `SPECIFICATION_APPROVED` | Current candidate explicitly approved; no baseline | ready | `HARNESS_OPERATION` | `baseline_specification` |
| `SPECIFICATION_BASELINED` | Current Specification Baseline; no Architecture | ready | `HARNESS_OPERATION` | `derive_architecture` |
| `ARCHITECTURE_IN_PROGRESS` — no authoritative validation | Architecture exists | ready | `HARNESS_OPERATION` | `validate_architecture` |
| `ARCHITECTURE_IN_PROGRESS` — validation/rejection requires rework | Current architecture not approval-ready | blocked | `REWORK` | `correct_architecture` |
| `AWAITING_ARCHITECTURE_APPROVAL` | Current PASS validation + current candidate + no decision | ready | `HUMAN_DECISION` | `record_architecture_decision` |
| `ARCHITECTURE_APPROVED` | Current Architecture candidate approved; no baseline | ready | `HARNESS_OPERATION` | `baseline_architecture` |
| `ARCHITECTURE_BASELINED` — AI Policy absent/stale | Current Architecture Baseline | ready | `HARNESS_OPERATION` | `derive_project_ai_policy` |
| `ARCHITECTURE_BASELINED` — AI Policy current, Work absent | Current Architecture + current AI Policy | ready | `HARNESS_OPERATION` | `generate_work_items` |
| `WORK_DECOMPOSITION_IN_PROGRESS` — unvalidated | Work Items/graph exist | ready | `HARNESS_OPERATION` | `validate_work_graph` |
| `WORK_DECOMPOSITION_IN_PROGRESS` — validation/rejection requires rework | Current Work not approval-ready | blocked | `REWORK` | `correct_work_decomposition` |
| `AWAITING_WORK_APPROVAL` | Current Work PASS + persisted candidate + no decision | ready | `HUMAN_DECISION` | `record_work_decision` |
| `WORK_APPROVED` | Current Work candidate approved; no baseline | ready | `HARNESS_OPERATION` | `baseline_work` |
| `WORK_BASELINED` — readiness prerequisites fail | Current Work Baseline but execution not permitted | blocked | `REWORK` | `resolve_blocker` |
| `EXECUTION_READY` | All execution-readiness predicates satisfied | ready | `NO_ACTION` | `none_bootstrap_complete` |

**Maintenance regime.** In the maintenance regime the state and the next action are taken from the first row below that applies. Where the State column says "as derived" or "as BRS 1.2" the state is the one Section 36 derives. In rows 9, 10, 11 and 13 it is the state the row names, also when X's head baseline is still current. C is the active revision change (Section 63.2), if there is one. X is the first chain in C's reach, from the top, that is not settled for C. `<X>` and `<x>` stand for that chain's names in the bootstrap table; for the Work chain these are `WORK_DECOMPOSITION_IN_PROGRESS`, `AWAITING_WORK_APPROVAL`, `WORK_APPROVED`, `validate_work_graph`, `correct_work_decomposition`, `record_work_decision` and `baseline_work`.

| # | Condition | State | Progress | Next action kind | Next action |
| --- | --- | --- | --- | --- | --- |
| 1 | Pack incomplete or invalid; a lineage fault; a change record fault; a signer chain fault; a repository fault on the Project AI Policy; a failed readiness prerequisite on a current Work Baseline | as BRS 1.2 | as BRS 1.2 | as BRS 1.2 | as BRS 1.2 |
| 2 | Engineering resolution not current; the observed Pack fingerprint equals the one the head Specification Baseline binds | `PROJECT_INPUT_READY` | ready | `HARNESS_OPERATION` | `bootstrap_repository` |
| 3 | Engineering resolution not current; C has reach `specification` | `PROJECT_INPUT_READY` | ready | `HARNESS_OPERATION` | `bootstrap_repository` |
| 4 | Engineering resolution not current, otherwise | `PROJECT_INPUT_READY` | blocked | `HUMAN_INPUT` | `open_change` |
| 5 | The head of the Specification or Architecture chain is not current, and either there is no C or that chain is outside C's reach | as derived | blocked | `HUMAN_INPUT` | `open_change` |
| 6 | Architecture Baseline current; Project AI Policy absent, invalid or not current | as derived | ready | `HARNESS_OPERATION` | `derive_project_ai_policy` |
| 7 | No C; Work Baseline not current | as derived | blocked | `HUMAN_INPUT` | `open_change` |
| 8 | No C; every baseline current | `EXECUTION_READY` | ready | `NO_ACTION` | `none_bootstrap_complete` |
| 9 | C; X has a current undecided candidate | `AWAITING_<X>_APPROVAL` | ready | `HUMAN_DECISION` | `record_<x>_decision` |
| 10 | C; X has a current approved candidate | `<X>_APPROVED` | ready | `HARNESS_OPERATION` | `baseline_<x>` |
| 11 | C; X's artefacts cannot be read, or the latest authoritative validation of X's current subject is `FAIL` or `ERROR`, or the candidate for X's current subject was rejected | `<X>_IN_PROGRESS` | blocked | `REWORK` | `correct_<x>` |
| 12 | C; X's artefacts equal those of X's head baseline | as derived | ready | `HARNESS_OPERATION` | the authoring operation of X |
| 13 | C; otherwise | `<X>_IN_PROGRESS` | ready | `HARNESS_OPERATION` | `validate_<x>` |

Rows 4, 5 and 7 carry the issue `CHANGE_RECORD_REQUIRED` when there is no C and `CHANGE_REACH_INSUFFICIENT` when C's reach does not include the chain that changed. When C exists, `open_change` in rows 4 and 5 has C as its subject and the result names the reach required: only a record that supersedes C with at least that reach, or abandoning C, changes the result, and a record that does not supersede C waits (Section 63.2). The candidates of rows 9 and 10 are those Section 21 allows to be offered, which name C. The authoring operations are `ingest_specification`, `derive_architecture` and `generate_work_items`.

In rows 4 and 5 with an active change C, the result names C and the reach required through the `CHANGE_REACH_INSUFFICIENT` issue (`reference` = C) and a note on C in `maintenance.changes`; `next_action` gains no member.

In rows 2 and 3 the progress is the one BRS 1.2 derives for `PROJECT_INPUT_READY`: it is `blocked` when that derivation reports a blocker (for example a partly deleted `/engineering`), and `bootstrap_repository` is still the next action and is accepted.

A change record fault in row 1 is a record, closure or supersession that is `CHANGE_RECORD_INVALID` (Section 62.2). For it the state is as derived, progress is blocked, the next action is `REWORK` `resolve_blocker`, no revision change is active and execution is prohibited, until the records reproduce again or the hand-written record is removed. A signer chain fault is `SIGNER_CHAIN_INVALID` (Section 73.4) and has the same effect, in either regime.

Rows 2 and 6 need no change record: re-materialising `/engineering` for an unchanged Pack and re-deriving the Project AI Policy reproduce deterministic artefacts and replace no baseline.

In row 12 the core also lists `validate_<x>` as permitted: it is the explicit statement that this chain needs no change under C, and its candidate carries a delta with nothing added, changed or removed.

`check_execution_readiness` remains an explicit read-only operation.

It is not required to persist a transition: `EXECUTION_READY` is derived whenever its predicates are true.

---

# 38. Approval rejection transitions

Rejection transitions are:

```text
AWAITING_SPECIFICATION_APPROVAL
    → SPECIFICATION_IN_PROGRESS

```

```text
AWAITING_ARCHITECTURE_APPROVAL
    → ARCHITECTURE_IN_PROGRESS

```

```text
AWAITING_WORK_APPROVAL
    → WORK_DECOMPOSITION_IN_PROGRESS

```

Rejected candidate and decision records remain immutable evidence.

---

# 39. Upstream-change transitions

The lifecycle is not forward-only.

If a current upstream prerequisite becomes stale/invalid, the core recalculates the highest currently supported state.

For example:

```text
EXECUTION_READY
→ Specification changes
→ Specification Baseline stale
→ downstream state stale
→ execution prohibited
→ lifecycle falls back to highest currently supported state

```

No stored `EXECUTION_READY=true` flag can override this calculation.

A valid Project Pack change has a fixed pre-engineering fallback:

```text
current observed Pack != resolution-source Pack
+ current Pack validates successfully
→ PROJECT_INPUT_READY
→ next_action = bootstrap_repository
```

An invalid/incomplete Pack change derives `PROJECT_INPUT_REQUIRED` instead.

In the maintenance regime a changed valid Pack still derives `PROJECT_INPUT_READY`. The next action is `bootstrap_repository` only under an active revision change of reach `specification`; otherwise it is `open_change` (Section 37, rows 3 and 4).

---

# 40. Next-action contract

Action kinds are:

```text
HARNESS_OPERATION
HUMAN_INPUT
HUMAN_DECISION
REWORK
NO_ACTION

```

Final action IDs are:

```text
complete_project_pack
correct_project_pack

bootstrap_repository
ingest_specification
validate_specification
correct_specification
record_specification_decision
baseline_specification

derive_architecture
validate_architecture
correct_architecture
record_architecture_decision
baseline_architecture

derive_project_ai_policy

generate_work_items
validate_work_graph
correct_work_decomposition
record_work_decision
baseline_work

open_change

resolve_blocker
none_bootstrap_complete

```

There shall be at most one authoritative next action. It names the next step of the bootstrap lifecycle or of the revision in progress.

Operations that an operator may start at will are not next actions. The core lists them in `permitted_operations`. Each entry names the operation, the actor (`adapter` or `operator`) and the subject where one applies. An adapter performs only the next action, or a permitted operation whose actor is `adapter` and that the operator asked for through an adapter command.

An operation that is neither the next action nor listed is refused and writes nothing. In the maintenance regime the refusal is `CHANGE_RECORD_REQUIRED` when no change record permits it and `CHANGE_REACH_INSUFFICIENT` when the active revision change excludes it. In every other case it carries the code its section names and, where none is named, the BRS 1.2 code `MUTATION_PRECONDITION_CHANGED`.

**Bootstrap regime.** Beside the next action, as the v0.3.0 core accepts them:

| Operation | Actor | Listed when |
| --- | --- | --- |
| `ingest_specification` | adapter | the engineering resolution is current |
| `derive_architecture` | adapter | the state is `SPECIFICATION_BASELINED`, `ARCHITECTURE_IN_PROGRESS` or `ARCHITECTURE_BASELINED` |
| `derive_project_ai_policy` | adapter | the Architecture Baseline is current |
| `generate_work_items` | adapter | the state is `ARCHITECTURE_BASELINED` with a current Project AI Policy, or `WORK_DECOMPOSITION_IN_PROGRESS` |
| `validate_<x>` | adapter | the state is `<X>_IN_PROGRESS` and it is not the next action (after a rejection or a failed validation) |
| `bootstrap_repository` | adapter | the release resolves and the Project Pack is valid, and it is not the next action |

**Maintenance regime.** Beside the next action:

| Operation | Actor | Listed when | Subject |
| --- | --- | --- | --- |
| `open_change` | adapter | the release resolves | none |
| `abandon_change` | adapter | Section 62.6 holds | each such change record |
| the authoring operation of X | adapter | rows 11, 12 and 13 of Section 37 | C |
| `validate_<x>` | adapter | rows 11, 12 and 13 | C |
| `start_task` | adapter | Section 43 permits execution | each ready Work Item |
| `record_task_progress`, `block_task` | adapter | the Work Item's latest run is open on its current definition | each such Work Item |
| `complete_task` | adapter | as above, and Section 43 permits execution of the item | each such Work Item |
| `reopen_task` | adapter | Section 64.4 | each such Work Item and change record |
| `record_task_decision` | operator | a governing Work Baseline exists | each Work Item of its task set |
| `record_change_decision` | operator | a registered change awaits decision | each such change record |

An entry with actor `adapter` may also be invoked by an operator. An entry with actor `operator` is a reserved operation.

In the maintenance regime `bootstrap_repository` stays the next action of rows 2 and 3 of Section 37 only.

While a change record fault exists (Section 62.2) the permitted set is empty in the maintenance regime: no maintenance, runtime state or decision operation is accepted, and `open_change` and `abandon_change` are refused with `CHANGE_RECORD_INVALID` and write nothing, because the binding of runs, dispositions and registered changes to change records cannot be trusted, and derived statuses cannot be trusted under a fault, so the fault may never widen what is accepted. Read operations work. The way out is to restore or remove the faulty file. `enrol_signer` and `revoke_signer` stay permitted and listed under a change record fault; `revoke_signer` is listed only with two or more enrolled keys. For a row-1 fault that is not a change record fault (invalid Pack, structure fault) the tables above apply as written: `record_task_progress` and `block_task` stay listed for an open run on its current definition, `start_task` and `complete_task` do not (Section 43 prohibits execution).

The result may contain multiple issue/remediation details, but the caller shall not choose the lifecycle operation by interpretation.

---

# 41. `bootstrap_repository`

Inputs:

```text
project_root
harness_root
```

`bootstrap_repository` shall:

1. acquire the project mutation lock;
2. reread and reconcile `.engineering-harness-template` and `.engineering-harness-adapters`;
3. identify the recorded governing Harness release from provenance;
4. resolve that exact release locally from `<harness_root>/releases/<recorded-version>/`;
5. load that release's schema catalogue, controls, profiles, technology catalogue and workflow/gate contracts;
6. validate the Project Engineering Pack against that exact recorded release;
7. calculate the validated Project Pack fingerprint;
8. resolve profile/technology/project configuration and supported non-approval overrides;
9. calculate the effective control set;
10. construct the complete intended `/engineering` state in memory/staging;
11. canonicalise and calculate the engineering-resolution digest;
12. validate the complete intended result against the version-1 `/engineering` schemas and semantic contracts;
13. reread mutation preconditions and confirm the Project Pack fingerprint and recorded release have not changed; and
14. publish `/engineering` atomically.

Success establishes:

```text
REPOSITORY_INITIALISED
```

It shall never write to `/project-pack`.

If any step before publication fails, the previous authoritative `/engineering` state remains byte-for-byte intact. A valid changed Pack may therefore remain in `PROJECT_INPUT_READY` until a complete successful materialisation occurs.

---

# 42. `inspect_project`

`inspect_project` is the primary status operation.

Inputs are explicit:

```text
project_root
harness_root
```

It shall orchestrate narrower read-only operations.

It shall not implement a second lifecycle model.

Its result shall express, where applicable:

- operation;
- outcome;
- Harness provenance;
- lifecycle state;
- progress;
- Project Pack status;
- fingerprints;
- engineering-resolution status;
- Specification Baseline status;
- Architecture Baseline status;
- Work Baseline status;
- AI-policy currentness;
- Work-graph status;
- pending human gate;
- missing inputs;
- blocking conditions;
- next action;
- execution permission;
- the regime;
- the change records with their derived status;
- the revision in progress;
- the Work Item summary and the next runnable Work Item;
- the installed adapters and whether their files match the release;
- the signers (Section 73.8);
- the permitted operations;
- issues.

A pending gate in the maintenance regime carries the revision context of Section 63.4.

Repeated inspection of an unchanged repository shall:

- produce the same engineering conclusion;
- write nothing;
- create no evidence; and
- repair nothing.

---

# 43. Execution readiness

Execution is permitted only if all required conditions are true:

```text
governing Harness release resolved
+
Project Pack relationship valid
+
engineering resolution current
+
Specification Baseline current
+
Architecture Baseline current
+
Project AI Policy current
+
Work Baseline current
+
Work graph valid
+
required v0.3.0 cross-cutting gates satisfied

```

Any stale, invalid, missing or indeterminate required prerequisite prohibits execution, with one exception.

**Execution under a work revision.** While the active revision change has reach `work`, execution is permitted when every condition above holds except "Work Baseline current" and "Work graph valid", provided that the governing Work Baseline matches current facts in its release binding (Section 29), its engineering-resolution digest, its upstream Architecture Baseline and its Project AI Policy digest, and that the Work artefacts in the working tree can be read.

In that case a Work Item is executable only when both its `task` item and its `graph_entry` item in the working tree have the digests the governing Work Baseline's item index records. A Work Item the revision adds, changes or removes is not executable until the new Work Baseline exists.

No exception applies to a Specification Baseline, an Architecture Baseline or a Project AI Policy that is not current. A revision of reach `architecture` or `specification` therefore stops execution from its first changed artefact until its last baseline is established.

`EXECUTION_READY` does not execute a Work Item. Execution is performed by an agent through `execute` (Section 70) and recorded through the runtime state operations (Section 64).

No executable security-exception gate is part of the v0.3.0 vertical slice. The readiness calculation therefore shall not invent or query security-exception evidence unless a later contract version explicitly introduces that control.

`execution_permitted` in a result is true exactly when this section permits execution of at least the unchanged Work Items. It can therefore be true in a state other than `EXECUTION_READY`. `check_execution_readiness` returns outcome `OK` exactly when `execution_permitted` is true, and under a work revision lists the Work Items that are not executable. A change record fault (Section 37, row 1) prohibits execution.

---

# 44. Mutation semantics

Only one mutating Harness operation may execute against a project at a time.

Read-only operations may run concurrently.

A mutation shall:

```text
acquire project mutation lock
→ reread current repository facts
→ reverify preconditions
→ construct complete intended mutation
→ validate intended result
→ persist safely
→ release lock

```

If relevant facts changed after earlier inspection:

```text
MUTATION_PRECONDITION_CHANGED

```

and the operation fails closed.

---

# 45. Append-only semantics

The following are append-only:

```text
evidence/validation/**
evidence/candidates/**
evidence/approvals/**
baselines/**
evidence/changes/**
evidence/adoptions/**
evidence/decisions/**
evidence/signers/**

```

Creation shall use exclusive-create semantics.

If a target already exists:

```text
RECORD_ALREADY_EXISTS

```

The core shall never overwrite an existing authoritative record.

Every signature file is also append-only. A run whose status is `done` is never modified (Section 64.2).

---

# 46. Record IDs

Repository-local monotonic IDs shall be used.

Examples:

```text
VAL-SPEC-0001
CAND-SPEC-0001
APR-SPEC-0001
SPEC-0001

VAL-ARCH-0001
CAND-ARCH-0001
APR-ARCH-0001
ARCH-0001

VAL-WORK-0001
CAND-WORK-0001
APR-WORK-0001
WORK-0001

```

```text
CHG-0001      change record            evidence/changes/
CLO-0001      change closure           evidence/changes/
DEC-0001      subject decision         evidence/decisions/
ADOPT-0001    adoption record          evidence/adoptions/
SGN-0001      signer record            evidence/signers/
RUN-0001      run, numbered per task   work/state/<TASK-id>/
```

A signature file has the name of its record followed by `.sig`, for example `evidence/approvals/APR-WORK-0002.yaml.sig`. Record scans ignore it; Section 73 reads it.

Allocation occurs under the mutation lock.

Rule:

```text
highest existing sequence
→ +1
→ four-digit zero padding
→ exclusive create

```

Record IDs are human-readable identifiers.

Digests are the normative integrity identity.

---

# 47. Issue codes

The v0.3.0 implementation shall support at least the following stable codes.

## Provenance

```text
PROV_NOT_RECORDED
PROV_NOT_FOUND
PROV_UNSUPPORTED
PROV_INCONSISTENT

```

## Repository

```text
REPO_REQUIRED_PATH_MISSING
REPO_WRONG_OBJECT_TYPE
REPO_PATH_ESCAPE
REPO_FORBIDDEN_SYMLINK
REPO_INCONSISTENT_STATE

```

## Project Pack

```text
PACK_REQUIRED_INPUT_MISSING
PACK_PARSE_ERROR
PACK_SCHEMA_INVALID
PACK_SOURCE_UNDECLARED
PACK_SOURCE_NOT_FOUND
PACK_FINGERPRINT_UNCOMPUTABLE

```

## Profile/control

```text
PROFILE_UNKNOWN
TECHNOLOGY_UNKNOWN
CONTROL_UNKNOWN
CONTROL_CONFIG_NOT_PERMITTED
CONTROL_OVERRIDE_NOT_PERMITTED
CONTROL_OVERRIDE_APPROVAL_UNSUPPORTED
CONTROL_CONFLICT

```

## Canonicalisation/integrity

```text
CANONICALISATION_UNSUPPORTED
CANONICALISATION_KEY_COLLISION
YAML_UNSUPPORTED_FEATURE
DIGEST_INVALID
DIGEST_MISMATCH

```

## Validation

```text
VALIDATION_FAILED
VALIDATION_ERROR
VALIDATION_SUBJECT_CHANGED
VALIDATION_EVIDENCE_INVALID

```

## Approval

```text
APPROVAL_MISSING
APPROVAL_WRONG_CANDIDATE
APPROVAL_WRONG_AUTHORITY
APPROVAL_IDENTITY_ASSURANCE_INVALID
APPROVAL_DECISION_ALREADY_RECORDED
APPROVAL_CANDIDATE_REJECTED
DECISION_SUBJECT_INVALID
DECISION_RECORD_INVALID
APPROVAL_SIGNATURE_MISSING
APPROVAL_SIGNATURE_INVALID
APPROVAL_SIGNER_NOT_ENROLLED
SIGNER_CHAIN_INVALID
SIGNER_IDENTITY_UNKNOWN
SIGNER_KEY_INVALID
SIGNER_NOT_ENROLLED
SIGNER_LAST_KEY

```

## Baseline

```text
BASELINE_INTEGRITY_FAILURE
BASELINE_UPSTREAM_STALE
BASELINE_MULTIPLE_HEADS
BASELINE_CYCLE
BASELINE_CROSS_TYPE_SUPERSESSION
BASELINE_PREDECESSOR_MISSING

```

## AI Policy

```text
AI_POLICY_INVALID
AI_POLICY_STALE
AI_POLICY_WRONG_ARCHITECTURE

```

## Work

```text
WORK_TASK_DUPLICATE
WORK_REFERENCE_INVALID
WORK_DEPENDENCY_MISSING
WORK_GRAPH_CYCLE
WORK_SCOPE_ESCAPE
WORK_COVERAGE_INCOMPLETE

```

## Mutation

```text
MUTATION_LOCKED
RECORD_ALREADY_EXISTS
MUTATION_PRECONDITION_CHANGED
ATOMIC_WRITE_FAILED

```

## Maintenance

```text
CHANGE_RECORD_REQUIRED
CHANGE_REACH_INSUFFICIENT
CHANGE_REACH_INVALID
CHANGE_NOT_OPEN
CHANGE_RECORD_INVALID
CHANGE_REFERENCE_INVALID
REVISION_DELTA_MISMATCH
```

## Runtime state

```text
EXECUTION_NOT_PERMITTED
TASK_UNKNOWN
TASK_NOT_READY
TASK_ALREADY_DONE
TASK_NOT_EXECUTABLE
TASK_RUN_NOT_OPEN
TASK_VERIFICATION_INCOMPLETE
TASK_VERIFICATION_FAILED
TASK_SCOPE_VIOLATION
TASK_STATE_INVALID
```

## Adapter

```text
ADAPTER_UNKNOWN
ADAPTER_MISMATCH
ADAPTER_FILE_MISSING
ADAPTER_FILE_MODIFIED
ADAPTER_FILE_CONFLICT
```

## Adoption

```text
ADOPTION_NOT_PERMITTED
ADOPTION_UNSUPPORTED
ADOPTION_NOT_EQUIVALENT
ADOPTION_RECORD_INVALID
```

## Guard

```text
GUARD_AGENT_CONTEXT
GUARD_NOT_INTERACTIVE
GUARD_CONFIRMATION_FAILED
GUARD_ANCHOR_UNTRUSTED
GUARD_ANCHOR_CHANGED
GUARD_KEY_UNPROTECTED
GUARD_SIGNING_FAILED
```

## Distribution layer

```text
DECISION_PROVENANCE_UNRESOLVED
DECISION_NOTHING_PENDING
DECISION_GATE_UNKNOWN
INIT_GIT_FAILED
INIT_SOURCE_MISSING_PATH
INIT_SOURCE_SYMLINK
INIT_VERSION_MISMATCH
INIT_INSTALL_LOCKED
INIT_RELEASE_MISMATCH
INIT_RELEASE_UNUSABLE
INIT_TARGET_APPEARED
INIT_STAGE_EXISTS
INIT_IO_ERROR
INIT_ANSWER_INVALID
INIT_PROVENANCE_UNRESOLVED
INIT_ADAPTER_UNKNOWN
INIT_ADAPTER_MANIFEST_INVALID
INIT_ADAPTER_CONFLICT
```

## Conditions of the v0.4.0 codes

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

`APPROVAL_IDENTITY_ASSURANCE_INVALID` keeps its BRS 1.2 meaning and is also raised for a decision record with declared assurance that no adoption record carries.

`ADAPTER_FILE_MISSING` and `ADAPTER_FILE_MODIFIED` have the outcome above in `check_adapters`. In every other operation they are warnings and never change a lifecycle conclusion.

The guard of Section 68 is raised by the CLI before any operation runs. Its codes, `GUARD_AGENT_CONTEXT`, `GUARD_NOT_INTERACTIVE`, `GUARD_CONFIRMATION_FAILED`, `GUARD_ANCHOR_UNTRUSTED`, `GUARD_ANCHOR_CHANGED`, `GUARD_KEY_UNPROTECTED` and `GUARD_SIGNING_FAILED`, have category `guard`, outcome `BLOCKED` and exit 4, and appear in the result document of the refused command. They join the three distribution-layer codes v0.3.0 already has for `approve_pending` and `reject_pending` (`DECISION_PROVENANCE_UNRESOLVED`, `DECISION_NOTHING_PENDING`, `DECISION_GATE_UNKNOWN`), which Section 47 now lists.

Section 47 also lists the codes of `init`, all prefixed `INIT_`. Twelve exist in v0.3.0; `INIT_ADAPTER_UNKNOWN`, `INIT_ADAPTER_MANIFEST_INVALID` and `INIT_ADAPTER_CONFLICT` are added for a release of core contract 2 (Section 69.5). `adopt_release` reports an `INIT_*` code when installing the target release fails as `init` does (Section 67.1). Section 47 fixes only their names. This BRS defines no category, outcome or condition for them.

No existing code changes meaning.

Issue codes may be added in later compatible releases, but existing meanings shall not change within result schema version 1.

---

# 48. Result semantics

Every public operation returns `schema://result/operation/v1`. The schema is normative for field names, required/null rules, enums and nesting.

Overall outcomes are:

```text
OK
INCOMPLETE
INVALID
BLOCKED
ERROR
```

Precedence when several issues apply:

```text
ERROR > BLOCKED > INVALID > INCOMPLETE > OK
```

All applicable issues are returned even where one outcome has higher precedence.

## 48.1 Default issue outcome and exit mapping

| Issue code | Default outcome | Exit | Operation-specific exception |
|---|---:|---:|---|
| `PROV_NOT_RECORDED` | `ERROR` | 5 | none |
| `PROV_NOT_FOUND` | `ERROR` | 5 | none |
| `PROV_UNSUPPORTED` | `ERROR` | 5 | none |
| `PROV_INCONSISTENT` | `ERROR` | 5 | none |
| `REPO_REQUIRED_PATH_MISSING` | `INVALID` | 3 | none |
| `REPO_WRONG_OBJECT_TYPE` | `INVALID` | 3 | none |
| `REPO_PATH_ESCAPE` | `INVALID` | 3 | none |
| `REPO_FORBIDDEN_SYMLINK` | `INVALID` | 3 | none |
| `REPO_INCONSISTENT_STATE` | `BLOCKED` | 4 | none |
| `PACK_REQUIRED_INPUT_MISSING` | `INCOMPLETE` | 2 | none |
| `PACK_PARSE_ERROR` | `INVALID` | 3 | none |
| `PACK_SCHEMA_INVALID` | `INVALID` | 3 | none |
| `PACK_SOURCE_UNDECLARED` | `INVALID` | 3 | none |
| `PACK_SOURCE_NOT_FOUND` | `INVALID` | 3 | none |
| `PACK_FINGERPRINT_UNCOMPUTABLE` | `INVALID` | 3 | I/O/runtime inability to read an otherwise valid governed file is `ERROR` with the underlying runtime issue |
| `PROFILE_UNKNOWN` | `INVALID` | 3 | none |
| `TECHNOLOGY_UNKNOWN` | `INVALID` | 3 | none |
| `CONTROL_UNKNOWN` | `INVALID` | 3 | none |
| `CONTROL_CONFIG_NOT_PERMITTED` | `INVALID` | 3 | none |
| `CONTROL_OVERRIDE_NOT_PERMITTED` | `INVALID` | 3 | none |
| `CONTROL_OVERRIDE_APPROVAL_UNSUPPORTED` | `INVALID` | 3 | none |
| `CONTROL_CONFLICT` | `BLOCKED` | 4 | none |
| `CANONICALISATION_UNSUPPORTED` | `ERROR` | 5 | none |
| `CANONICALISATION_KEY_COLLISION` | `INVALID` | 3 | none |
| `YAML_UNSUPPORTED_FEATURE` | `INVALID` | 3 | none |
| `DIGEST_INVALID` | `INVALID` | 3 | none |
| `DIGEST_MISMATCH` | `INVALID` | 3 | when mismatch creates a lineage/currentness conflict, higher-precedence `BLOCKED` issues may also apply |
| `VALIDATION_FAILED` | `INVALID` | 3 | authoritative validation of current engineering content normally returns `INVALID`; lifecycle next action is rework |
| `VALIDATION_ERROR` | `ERROR` | 5 | none |
| `VALIDATION_SUBJECT_CHANGED` | `BLOCKED` | 4 | none |
| `VALIDATION_EVIDENCE_INVALID` | `INVALID` | 3 | none |
| `APPROVAL_MISSING` | `INCOMPLETE` | 2 | if an established baseline claims/requires missing approval evidence, use `INVALID` |
| `APPROVAL_WRONG_CANDIDATE` | `INVALID` | 3 | none |
| `APPROVAL_WRONG_AUTHORITY` | `INVALID` | 3 | none |
| `APPROVAL_IDENTITY_ASSURANCE_INVALID` | `INVALID` | 3 | none |
| `APPROVAL_DECISION_ALREADY_RECORDED` | `BLOCKED` | 4 | none |
| `APPROVAL_CANDIDATE_REJECTED` | `BLOCKED` | 4 | normal rejection also derives the relevant rework next action |
| `BASELINE_INTEGRITY_FAILURE` | `INVALID` | 3 | none |
| `BASELINE_UPSTREAM_STALE` | `BLOCKED` | 4 | none |
| `BASELINE_MULTIPLE_HEADS` | `BLOCKED` | 4 | none |
| `BASELINE_CYCLE` | `BLOCKED` | 4 | none |
| `BASELINE_CROSS_TYPE_SUPERSESSION` | `BLOCKED` | 4 | none |
| `BASELINE_PREDECESSOR_MISSING` | `BLOCKED` | 4 | none |
| `AI_POLICY_INVALID` | `INVALID` | 3 | none |
| `AI_POLICY_STALE` | `BLOCKED` | 4 | none |
| `AI_POLICY_WRONG_ARCHITECTURE` | `INVALID` | 3 | none |
| `WORK_TASK_DUPLICATE` | `INVALID` | 3 | none |
| `WORK_REFERENCE_INVALID` | `INVALID` | 3 | none |
| `WORK_DEPENDENCY_MISSING` | `INVALID` | 3 | none |
| `WORK_GRAPH_CYCLE` | `INVALID` | 3 | none |
| `WORK_SCOPE_ESCAPE` | `INVALID` | 3 | none |
| `WORK_COVERAGE_INCOMPLETE` | `INVALID` | 3 | none |
| `MUTATION_LOCKED` | `BLOCKED` | 4 | none |
| `RECORD_ALREADY_EXISTS` | `BLOCKED` | 4 | none |
| `MUTATION_PRECONDITION_CHANGED` | `BLOCKED` | 4 | none |
| `ATOMIC_WRITE_FAILED` | `ERROR` | 5 | none |
| `CHANGE_RECORD_REQUIRED` | `BLOCKED` | 4 | none |
| `CHANGE_REACH_INSUFFICIENT` | `BLOCKED` | 4 | none |
| `CHANGE_REACH_INVALID` | `INVALID` | 3 | none |
| `CHANGE_NOT_OPEN` | `BLOCKED` | 4 | none |
| `CHANGE_RECORD_INVALID` | `INVALID` | 3 | none |
| `CHANGE_REFERENCE_INVALID` | `INVALID` | 3 | none |
| `REVISION_DELTA_MISMATCH` | `INVALID` | 3 | none |
| `EXECUTION_NOT_PERMITTED` | `BLOCKED` | 4 | none |
| `TASK_UNKNOWN` | `INVALID` | 3 | none |
| `TASK_NOT_READY` | `BLOCKED` | 4 | none |
| `TASK_ALREADY_DONE` | `BLOCKED` | 4 | none |
| `TASK_NOT_EXECUTABLE` | `BLOCKED` | 4 | none |
| `TASK_RUN_NOT_OPEN` | `BLOCKED` | 4 | none |
| `TASK_VERIFICATION_INCOMPLETE` | `INVALID` | 3 | none |
| `TASK_VERIFICATION_FAILED` | `BLOCKED` | 4 | none |
| `TASK_SCOPE_VIOLATION` | `INVALID` | 3 | none |
| `TASK_STATE_INVALID` | `INVALID` | 3 | none |
| `DECISION_SUBJECT_INVALID` | `INVALID` | 3 | none |
| `DECISION_RECORD_INVALID` | `INVALID` | 3 | none |
| `ADAPTER_UNKNOWN` | `INVALID` | 3 | none |
| `ADAPTER_MISMATCH` | `INVALID` | 3 | none |
| `ADAPTER_FILE_MISSING` | `INVALID` | 3 | none |
| `ADAPTER_FILE_MODIFIED` | `INVALID` | 3 | none |
| `ADAPTER_FILE_CONFLICT` | `BLOCKED` | 4 | none |
| `ADOPTION_NOT_PERMITTED` | `BLOCKED` | 4 | none |
| `ADOPTION_UNSUPPORTED` | `ERROR` | 5 | none |
| `ADOPTION_NOT_EQUIVALENT` | `BLOCKED` | 4 | none |
| `ADOPTION_RECORD_INVALID` | `INVALID` | 3 | none |
| `APPROVAL_SIGNATURE_MISSING` | `INVALID` | 3 | none |
| `APPROVAL_SIGNATURE_INVALID` | `INVALID` | 3 | none |
| `APPROVAL_SIGNER_NOT_ENROLLED` | `INVALID` | 3 | none |
| `SIGNER_CHAIN_INVALID` | `INVALID` | 3 | none |
| `SIGNER_IDENTITY_UNKNOWN` | `INVALID` | 3 | none |
| `SIGNER_KEY_INVALID` | `INVALID` | 3 | none |
| `SIGNER_NOT_ENROLLED` | `BLOCKED` | 4 | none |
| `SIGNER_LAST_KEY` | `BLOCKED` | 4 | none |

A public operation with no issues uses the outcome implied by the requested engineering fact: e.g. a healthy but incomplete fresh project is `INCOMPLETE`, while a successful diagnostic check with all applicable prerequisites satisfied is `OK`.

A maintenance operation that wrote its record reports the outcome the resulting state implies, as every v0.3.0 mutation does (for example `BLOCKED` when the project is still blocked after `open_change`). Whether it wrote is read from `evidence`, never from the exit status.

`check_maintenance` and `inspect_project` report the outcome the derived state implies, by the result precedence of BRS 1.2, in both regimes. While a revision is in progress and an artefact differs from its head baseline the outcome is therefore `BLOCKED` (exit 4) although a next action exists, exactly as the v0.3.0 core answers for a changed baselined artefact.

---

# 49. CLI contract

The CLI shall be a thin wrapper around the same core used by CI and adapters.

Every command that inspects or mutates a project must supply the core with explicit `project_root` and `harness_root` values. The CLI resolves `harness_root` using exactly the FR-034 precedence:

```text
1. ENGINEERING_HARNESS_ROOT
2. <core executable directory>/_root
3. absent → exit 64 usage/configuration error
```

The CLI accepts no `--harness-root` argument; supplying one is a usage error (exit 64). There is no implicit current-directory, parent-directory, home-directory or network registry fallback. The resolved absolute/local registry path is passed to the core as an explicit argument; the core does not read the environment.

The CLI shall support machine-readable output conforming exactly to `schema://result/operation/v1`. Optional human-readable rendering may be provided but shall not change semantics.

Exit codes are:

```text
0   OK
2   INCOMPLETE
3   INVALID
4   BLOCKED
5   ERROR
64  command usage/configuration error
```

Machine callers shall never be required to parse prose to determine behaviour.

Every operation accepts `--adapter <identifier>`. An adapter passes its own identifier on every call. The value shall name an adapter installed in the project; otherwise the operation fails with `ADAPTER_UNKNOWN` and writes nothing. The result reports the declared adapter in `provenance.adapter` and the installed adapters in `provenance.installed_adapters`.

A maintenance or runtime state operation that writes requires exactly one of `--adapter <identifier>` and `--operator`; with neither or both the CLI exits 64. The record names the caller as declared. The declaration is not verified, with one check: when an agent session marker of the adapter manifest is present in the environment and the caller declares `--operator` or an adapter other than the marker's, the operation fails with `ADAPTER_MISMATCH`.

A reserved operation and an operator command reject `--adapter` (Section 68).

On a project governed by v0.3.0 the result of an operation that v0.3.0 defines conforms to the v0.3.0 result schema, `provenance.adapter` is taken from the v0.3.0 marker and `--adapter` has no effect other than on the guard.

## 49.1 Command-line flags

The flags of the commands are:

```text
approve_pending | reject_pending   --project-root <p> --approver <identity> --key <path> [--comment <text>] [--expected-candidate <digest>]
record_<x>_decision                --project-root <p> --decision approved|rejected --approver <identity> --authority <role> --key <path> [--comment] [--expected-candidate]
record_task_decision               --project-root <p> --task <TASK-id> --decision deferred|withdrawn|reinstated --reason <text> --approver <identity> --key <path> [--change <CHG-id>]
record_change_decision             --project-root <p> --change <CHG-id> --decision accepted|rejected --approver <identity> --key <path> [--comment <text>]
enrol_signer                       --project-root <p> --identity <identity> --key <path> [--public-key <file.pub>]
                                   (without --public-key the key enrolled is the signing key itself: the anchor case)
revoke_signer                      --project-root <p> --fingerprint <SHA256:...> --reason <text> --key <path>
check_signers                      --project-root <p> [--allowed-signers]
trust_signers                      --project-root <p>
adopt_release                      --project-root <p> --version <vX.Y.Z> --key <path> [--identity <identity>] [--adapters <list>]
                                   [--replace-adapter-files] [--source <dir> | --repository <url>]
                                   (--identity is required when the project has no signer chain)
open_change                        --project-root <p> --kind <k> --title <t> --statement <s> [--reach <r>] [--rework <TASK-id>]... [--acceptance <text>]...
                                   [--supersedes <CHG-id>] [--registered --changed-path <path>... [--commit <sha>]... [--touches <TASK-id>]...]
abandon_change                     --project-root <p> --change <CHG-id>
list_tasks | check_maintenance     --project-root <p>
select_task                        --project-root <p> [--task <TASK-id>]
start_task                         --project-root <p> --task <TASK-id>
record_task_progress               --project-root <p> --task <TASK-id> --note <text> [--changed-path <path>]...
block_task                         --project-root <p> --task <TASK-id> --reason <text> [--changed-path <path>]...
complete_task                      --project-root <p> --task <TASK-id> --file <task-result.yaml>
reopen_task                        --project-root <p> --task <TASK-id> --change <CHG-id>
```

Every maintenance or runtime operation that writes needs exactly one of `--adapter <id>` and `--operator`
(otherwise exit 64). Reserved operations and operator commands reject `--adapter`.

---

# 50. Validation classification

Every claimed validation shall belong to one of:

| LayerMeaning           |                                                      |
| ---------------------- | ---------------------------------------------------- |
| Parse                  | Document can be read                                 |
| Schema                 | Single-object structural validity                    |
| Deterministic semantic | Explicit facts can be evaluated algorithmically      |
| Cross-state            | Files, evidence, currentness or lineage are compared |
| AI-assisted/human      | Meaning/judgement not reduced to executable rules    |

AI-assisted/human review may be required by policy.

It shall never be represented as deterministic PASS unless an executable deterministic rule exists.

---

# 51. Non-functional requirements

## NFR-001 — Determinism

Identical repository bytes, governing release and operation input shall produce identical engineering conclusions.

## NFR-002 — Idempotent reads

Read-only operations shall make no repository changes.

Repeated reads over unchanged state shall produce equivalent results.

## NFR-003 — Integrity

Every content-addressed relationship shall be independently reproducible.

## NFR-004 — Fail closed

Missing or unverifiable proof shall never be interpreted as success.

## NFR-005 — Tool independence

Core behaviour shall not depend on Claude Code or any other AI environment.

## NFR-006 — Local operation

The core shall run as a local library/executable without requiring a central service or database.

## NFR-007 — No arbitrary network dependency

Normal inspection and validation shall not require arbitrary internet access.

## NFR-008 — Security

Repository content shall be treated as untrusted input.

Unsafe YAML object construction and governed symlink traversal are prohibited.

## NFR-009 — Atomicity

Authoritative mutations shall either publish a complete valid result or leave previous authoritative state intact.

## NFR-010 — Single writer

Only one project mutation may execute at a time.

## NFR-011 — Traceability

Every baseline shall remain traceable to:

```text
candidate
validation
approval
governing engineering resolution
required upstream state

```

## NFR-012 — Maintainability

There shall be one shared canonicalisation service and one authoritative lifecycle/next-action implementation.

## NFR-013 — Compatibility

Schema versions, result enums, issue-code meanings and canonicalisation versions are compatibility contracts.

Unsupported future versions fail explicitly.

## NFR-014 — Testability

All deterministic behaviour shall be testable without an LLM.

## NFR-015 — Performance

Inspection shall be suitable for normal interactive local and CI use.

Correctness and determinism take priority over optimisation.

## NFR-016 — Portability

The design shall not rely on OS-specific lifecycle semantics.

Implementation should operate on the agreed developer/CI operating systems.

## NFR-017 — Diagnostics

Errors shall identify machine-readable code, category and relevant file/reference/control where available.

---

# 52. Acceptance criteria

## AC-001 — Fresh repository

A clean new project with incomplete Project Pack shall:

```text
state = PROJECT_INPUT_REQUIRED
outcome = INCOMPLETE
next action = complete_project_pack
```

and inspection shall write nothing.

A clean new project with a complete valid Pack and no current `/engineering` resolution shall derive:

```text
state = PROJECT_INPUT_READY
outcome = INCOMPLETE
next action = bootstrap_repository
```

## AC-002 — No fabricated state

Fake or incomplete approved-looking baseline records shall never advance lifecycle state.

## AC-003 — Project Pack validation

A valid Pack shall validate deterministically.

Undeclared/missing/escaping sources and unknown profile/technology shall fail appropriately.

## AC-004 — Project Pack fingerprint

The same Pack shall reproduce the same fingerprint.

Changing any included input shall change the observed fingerprint.

Unrelated Pack files shall not affect it.

## AC-005 — Fingerprint uncomputable

If the fingerprint subject cannot be deterministically constructed, the fingerprint shall be `UNCOMPUTABLE`; no validated fingerprint shall be produced.

## AC-006 — Profile resolution

A valid default profile and recognised technology shall resolve to the same effective control set and engineering digest on repeated runs.

## AC-007 — Engineering materialisation

`bootstrap_repository` shall resolve provenance and the exact recorded local Harness release before validating the Pack against that release, then materialise exactly the validated `/engineering` state. It shall not leave partial output after failure.

## AC-008 — Harness release pinning

A project recording v0.3.0 shall remain governed by v0.3.0 even if a newer release exists.

## AC-009 — Canonicalisation

Every normative `harness-v1` test vector shall reproduce the exact canonical bytes and SHA-256 digest.

## AC-010 — Diagnostic validation

Diagnostic checks shall write no authoritative evidence.

## AC-011 — Authoritative validation

Authoritative `FAIL` or `ERROR` validation shall persist immutable evidence only. Authoritative `PASS` shall publish immutable PASS evidence and its corresponding approval candidate together as one logical atomic mutation against one exact subject.

## AC-012 — Candidate consistency

A staged PASS subject changed before final publication shall prevent publication of both PASS evidence and candidate and require revalidation.

## AC-013 — Awaiting approval

A project may enter an `AWAITING_*_APPROVAL` state only with a valid persisted undecided candidate.

## AC-014 — Explicit approval

Only an explicit decision by the required assigned authority on the exact candidate digest shall satisfy a human gate.

## AC-015 — Approved intermediate state

An approved current candidate with no baseline shall derive the corresponding `*_APPROVED` state and `baseline_*` next action.

## AC-016 — Rejection finality

A rejected candidate shall never later be approved or establish a baseline.

## AC-017 — Baseline establishment

A baseline shall be created only after complete candidate, validation, approval, authority, upstream and lineage re-verification.

## AC-018 — Baseline integrity

Modification of candidate/approval evidence after baseline creation shall make the baseline integrity invalid.

## AC-019 — Baseline lineage

Multiple heads, cycles, cross-type supersession and missing predecessors shall fail closed.

## AC-020 — Historical validity versus currentness

Changing an approved artefact shall make the baseline stale without retroactively invalidating its historical approval.

## AC-021 — Restoration

An unsuperseded stale baseline whose complete approved bindings are restored exactly shall become current again.

A superseded baseline shall not.

## AC-022 — Staleness propagation

An upstream Project Pack, engineering, Specification, Architecture or AI Policy currentness failure shall make all defined dependants stale and prohibit execution.

## AC-023 — AI Policy

Manual modification or wrong Architecture binding shall make AI Policy non-current and Work non-current.

## AC-024 — Work graph

A valid DAG with valid references shall pass.

Cycles, missing tasks, escaping scopes or required coverage gaps shall fail.

## AC-025 — State reconstruction

Bootstrap state shall be reconstructable from repository facts and the governing Harness release without conversational history.

## AC-026 — Next action

For every supported state/condition the core shall return at most one authoritative next action, and the complete set of permitted operations (Section 40).

## AC-027 — Rejection transition

Rejected Specification, Architecture or Work candidates shall return lifecycle to the corresponding rework state while preserving rejection evidence.

## AC-028 — Execution readiness

A current Work Baseline with any failed readiness prerequisite shall not produce `EXECUTION_READY`, except as Section 43 permits under a work revision.

## AC-029 — Read-only idempotence

Repeated status/diagnostic operations shall produce equivalent conclusions and no repository mutation.

## AC-030 — Append-only persistence

Existing validation, candidate, approval and baseline records shall never be overwritten.

## AC-031 — Mutation locking

Concurrent mutation shall not create competing normal lifecycle records.

## AC-032 — Mutation precondition recheck

A mutation whose prerequisites changed after previous inspection shall fail closed.

## AC-033 — Path security

Path traversal and governed symlinks shall be rejected.

## AC-034 — Result semantics

Overall result precedence and exit code shall match this BRS.

## AC-035 — Adapter independence

Replacing one adapter with another shall not change deterministic Harness semantics.

## AC-036 — End-to-end vertical slice

A reference project shall complete:

```text
PROJECT_INPUT_REQUIRED
→ bootstrap
→ Specification
→ validation
→ approval
→ Specification Baseline
→ Architecture
→ validation
→ approval
→ Architecture Baseline
→ AI Policy
→ Work generation
→ Work validation
→ Work approval
→ Work Baseline
→ EXECUTION_READY

```

without relying on conversational state or inferred approval.

---

## AC-037 — Approval-requiring overrides are unsupported

A Project Pack override targeting a control that requires human approval shall fail deterministic Pack validation with `CONTROL_OVERRIDE_APPROVAL_UNSUPPORTED`. No override candidate/decision artefact shall be created.

## AC-038 — Security exception flow is absent in v0.3.0

No v0.3.0 operation, schema or next-action rule shall require or fabricate security-exception approval evidence.

## AC-039 — Harness root convention

The core shall not inspect or mutate without an explicit `harness_root`. The CLI shall resolve it only by FR-034: `ENGINEERING_HARNESS_ROOT`, then `_root` beside the core executable; it shall exit 64 when neither yields a value and when a `--harness-root` argument is supplied.

## AC-040 — Provenance grammar

The two distribution provenance files shall parse only according to FR-033. Unknown/missing/duplicate keys or malformed canonical paths shall produce `PROV_INCONSISTENT`.

## AC-041 — Adapter distribution

Adapter distribution conforms to Section 69 (AC-059 to AC-062).

## AC-042 — Adapter execution boundaries

Adapter commands conform to Section 70 and hold no selection rule, transition rule or state grammar; runtime state conforms to Section 64.

## AC-043 — Change record

A revision in the maintenance regime starts only from a change record. The record is immutable and content-addressed. Every candidate of the revision names it, every baseline reaches it through its candidate, and every Work Item the revision adds or changes lists it.

## AC-044 — Offered steps

For every step of a revision the core returns the step as the next action or lists it as a permitted operation, with its actor and subject.

## AC-045 — Nothing unoffered

A lifecycle, maintenance, runtime state or reserved operation that the core's current result does not offer is refused and writes nothing.

## AC-046 — Identity of unchanged content

An artefact that a revision leaves byte-identical has the same digest in the superseding candidate. The candidate records what was added, changed and removed against the baseline it supersedes, and an item index or delta that does not reproduce invalidates the candidate.

## AC-047 — Supersession

A baseline established by a revision supersedes the previous head. The superseded baseline remains historically valid and its bytes are unchanged. A change record whose revision is complete is never made active again by a later revision.

## AC-048 — Gates in a revision

A revision is approved at the gate of each baseline it replaces, by that gate's authority, and at no other.

## AC-049 — Runtime state ownership

Runtime state is written only by core operations, validates against the release schema, and records on every write the caller as declared.

## AC-050 — Task selection

With a named Work Item the core returns that item when it is ready and no item otherwise. Without a name it returns the first ready item in execution-graph order whose run is in progress, and if there is none the first ready item that is pending or requires rework. An item it returns can be started.

## AC-051 — Carry-over

Under a superseding Work Baseline a Work Item whose definition digest is unchanged keeps its status, a Work Item whose definition changed requires rework, and the state of a removed Work Item remains as history.

## AC-052 — Finished work is not overwritten

Starting a finished Work Item is refused. Reopening it under a change record creates a new run and leaves the earlier run byte-identical.

## AC-053 — Disposition

A Work Item is deferred or withdrawn only by a decision of the `engineering` authority. Such an item is never selected or started.

## AC-054 — Open criteria

Every acceptance criterion and every change-record acceptance statement referenced by a Work Item that is not done is reported as open, with the items and statuses that keep it open.

## AC-055 — Maintenance status

`check_maintenance` reports the change records with their status, the revision in progress and the Work Item summary, and writes nothing.

## AC-056 — Adoption

A v0.3.0 project that adopts a control-equivalent v0.4.0 release keeps every baseline current and its lifecycle state. No v0.3.0 record is modified and no validation, candidate or decision record is created. The adoption record is signed, and it writes the signer anchor when the project has none.

## AC-057 — Adoption is never silent

The governing release of a project changes only through `adopt_release`. An adoption that is not control-equivalent is refused and writes nothing.

## AC-058 — Legacy state

A v0.3.0 state file is read under the legacy grammar, is never rewritten, and gives the same status as a run with the same content.

## AC-059 — Adapter subset

Project initialisation installs any subset of the release's adapters. Adding or removing an adapter changes no governed state, no digest and no lifecycle conclusion.

## AC-060 — One source

Every rendered adapter file of the release equals the rendering of the single authored source. The build fails when one differs.

## AC-061 — Installed adapters

`check_adapters` reports every installed adapter file that is missing or differs from the release.

## AC-062 — Core location

No adapter file names the location of the core. Every adapter invokes the launcher.

## AC-063 — Reserved operations

The CLI records a human decision only on a controlling terminal, outside every detected agent context, after the operator has confirmed the exact subject, and only with a signature that verifies for a key enrolled for the identity of the required authority.

## AC-064 — Hand-over

A run started through one adapter and continued through others is hand-over equivalent (Section 64.7) to a run of the same Work Item made through one adapter.

## AC-065 — Registered change

A change made outside a run can be recorded only as a registered change, is accepted or rejected by the `engineering` authority, and is never represented as a run.

## AC-066 — Core contract

A core that does not implement the core contract a release declares resolves nothing under that release and writes nothing. A v0.3.0 core fails in this way on a project governed by v0.4.0.

## AC-067 — Signed records

In a project governed by v0.4.0 a decision record, a subject decision, an adoption record or a signer record without a valid signature by an enrolled key has no effect: it satisfies no gate, establishes no baseline, changes no disposition, accepts no registered change, adopts no release and enrols or revokes no key. A record written as a file without the key is therefore rejected, and its presence is reported.

## AC-068 — Carried decisions

A decision recorded under a release without signed decisions keeps its declared assurance exactly when a valid adoption record lists it by ID and digest. Every other decision record with declared assurance is invalid.

## AC-069 — Signer chain

Keys are enrolled and revoked only by signed, append-only signer records that form one chain from the anchor. A gap, a fork or an invalid signature in the chain is reported, and no record verifies under a broken chain.

## AC-070 — Keys stay with their owner

The core never reads a private key. A signature is made by the operator's OpenSSH and verified by the core in process, and the same signature verifies with stock OpenSSH against the allowed-signers file the core prints.

## AC-071 — Anchor trust

The CLI performs a reserved operation or an operator command only on a project whose signer anchor the operator has accepted on that machine, and refuses when the anchor differs from the accepted one.

# 53. Contract-test traceability

Appendix A contains the complete definitive contract-test scenarios for this BRS. All scenarios in Appendix A are normative. There is no compatibility qualifier and no earlier chat/test wording overrides Appendix A.

| TestRequirement/acceptance coverage                     |                                                    |
| ------------------------------------------------------- | -------------------------------------------------- |
| CT-001 Fresh project expected incomplete                | AC-001, FR-020, lifecycle `PROJECT_INPUT_REQUIRED` |
| CT-002 Fake approved baseline                           | AC-002, baseline integrity                         |
| CT-003 Undeclared source                                | AC-003, Project Pack source contract               |
| CT-004 Source path traversal                            | AC-003, AC-033                                     |
| CT-005 Unknown technology                               | AC-003, profile fail-closed                        |
| CT-010 Distribution provenance only                     | AC-001, provenance                                 |
| CT-011 Governing release unavailable                    | AC-008, result `ERROR`                             |
| CT-012 Newer release exists                             | AC-008                                             |
| CT-020 Default profile resolves                         | AC-006                                             |
| CT-021 Forbidden project configuration                  | AC-006, control configuration                      |
| CT-022 Non-overrideable control                         | AC-006, override contract                          |
| CT-023 Control conflict                                 | AC-006, `BLOCKED`                                  |
| CT-024 Inspection does not rematerialise `/engineering` | AC-029                                             |
| CT-030 PASS evidence without candidate                  | AC-013                                             |
| CT-031 Subject changed before candidate                 | AC-012                                             |
| CT-032 Human approves exact candidate                   | AC-014                                             |
| CT-033 Approval references wrong candidate              | AC-017                                             |
| CT-034 Silence is not approval                          | AC-014                                             |
| CT-035 Rejected candidate cannot later be approved      | AC-016                                             |
| CT-040 Valid current Specification Baseline             | AC-017, AC-020                                     |
| CT-041 Specification changed after approval             | AC-020, AC-022                                     |
| CT-042 Multiple baseline heads                          | AC-019                                             |
| CT-043 Supersession cycle                               | AC-019                                             |
| CT-044 Cross-type supersession                          | AC-019                                             |
| CT-045 Approval evidence modified                       | AC-018                                             |
| CT-046 Optional Git provenance missing                  | AC-017; content evidence remains normative         |
| CT-050 Project Pack edited after execution-ready        | AC-022                                             |
| CT-051 Invalid partial Pack edit                        | AC-004, AC-022                                     |
| CT-052 Pack restored                                    | AC-021                                             |
| CT-060 Architecture on stale Specification              | AC-022                                             |
| CT-061 AI Policy changed                                | AC-023                                             |
| CT-062 AI Policy wrong Architecture binding             | AC-023                                             |
| CT-070 Valid Work DAG                                   | AC-024                                             |
| CT-071 Work graph cycle                                 | AC-024                                             |
| CT-072 Missing dependency                               | AC-024                                             |
| CT-073 Acceptance criterion orphan                      | AC-024                                             |
| CT-074 Non-executable semantic claim                    | Validation-classification contract                 |
| CT-075 Repository scope escape                          | AC-033                                             |
| CT-080 Specification exists/no validation               | Lifecycle: `SPECIFICATION_IN_PROGRESS`             |
| CT-081 PASS + candidate/no decision                     | AC-013; `AWAITING_SPECIFICATION_APPROVAL`          |
| CT-082 Current Specification Baseline                   | Lifecycle: `SPECIFICATION_BASELINED`               |
| CT-083 Architecture rejection                           | AC-027                                             |
| CT-084 Work Baseline but readiness failure              | AC-028                                             |
| CT-085 Upstream change from execution-ready             | AC-022, AC-025                                     |
| CT-090 Incomplete Pack                                  | AC-001, AC-026                                     |
| CT-091 Awaiting approval                                | AC-013, AC-026                                     |
| CT-092 Validation failure                               | AC-026; rework next action                         |
| CT-093 Execution ready                                  | AC-028, AC-026                                     |
| CT-100 Status idempotent                                | AC-029                                             |
| CT-101 Diagnostic versus authoritative validation       | AC-010, AC-011                                     |
| CT-102 Append-only baseline records                     | AC-030                                             |
| CT-110 Stable machine-readable issue                    | Result/issue-code contract                         |
| CT-111 Expected incomplete versus internal error        | AC-001, result semantics                           |
| CT-112 Unsupported canonicalisation                     | AC-009, fail-closed                                |
| CT-113 CLI exit semantics                               | AC-034                                             |
| CT-120 Approved intermediate Specification              | AC-015                                             |
| CT-121 Approved intermediate Architecture               | AC-015                                             |
| CT-122 Approved intermediate Work                       | AC-015                                             |
| CT-123 Fingerprint subject uncomputable                 | AC-005                                             |
| CT-124 Raw source hashing                               | AC-004, AC-009                                     |
| CT-125 Governed symlink                                 | AC-033                                             |
| CT-126 Mutation lock                                    | AC-031                                             |
| CT-127 Exclusive record creation                        | AC-030                                             |
| CT-128 Mutation precondition changed                    | AC-032                                             |
| CT-129 Multi-issue precedence                           | AC-034                                             |
| CT-130 Approved candidate becomes stale before baseline | AC-012, AC-017                                     |
| CT-131 Harness release resolution is local              | AC-008, AC-039                                     |
| CT-132 Valid Pack is ready for bootstrap                | AC-001, AC-026                                     |
| CT-133 Changed valid Pack falls back to input ready     | AC-022, AC-025                                     |
| CT-134 Approval-requiring override unsupported          | AC-037                                             |
| CT-135 No executable security-exception flow            | AC-038                                             |
| CT-136 PASS evidence and candidate atomic               | AC-011, AC-012                                     |
| CT-137 Harness root convention                          | AC-039                                             |
| CT-138 NFC-normalised key collision                     | AC-009                                             |
| CT-141 A revision needs a change record | AC-043, AC-045 |
| CT-142 Governed content changed without a change record | AC-043, AC-045 |
| CT-143 `open_change` records an immutable change record | AC-043 |
| CT-144 Reach follows the kind and cannot go below its minimum | AC-043 |
| CT-145 A work revision is offered step by step | AC-044, AC-045, AC-026 |
| CT-146 Unchanged content keeps its identity; the candidate states the delta | AC-046 |
| CT-147 An index or delta that does not reproduce invalidates the candidate | AC-046 |
| CT-148 The new baseline supersedes; the old one stays valid and untouched | AC-047 |
| CT-149 An architecture revision replaces two baselines | AC-044, AC-048 |
| CT-150 A chain that needs no change is confirmed, not skipped | AC-044, AC-045, AC-026 |
| CT-151 The reach is enforced | AC-043, AC-045 |
| CT-152 A wider reach is a superseding change record | AC-043, AC-045 |
| CT-153 Abandoning a change | AC-043, AC-045 |
| CT-154 One revision at a time | AC-043, AC-045 |
| CT-155 A maintenance task that traces to its change record | AC-043 |
| CT-156 Added and changed tasks name the revision | AC-043 |
| CT-157 `check_maintenance` reports and writes nothing | AC-055 |
| CT-158 Selection | AC-050 |
| CT-159 `start_task` creates a run | AC-049 |
| CT-160 `complete_task` checks what the core can check | AC-049 |
| CT-161 Blocking, progress and resuming | AC-049 |
| CT-162 A finished task is not overwritten | AC-052 |
| CT-163 Carry-over under a new Work Baseline | AC-051 |
| CT-164 Legacy state files are read, never rewritten | AC-058 |
| CT-165 Hand-over between adapters | AC-064 |
| CT-166 Runtime state never enters a subject | AC-049 |
| CT-167 Execution under a work revision | AC-028 as amended |
| CT-168 Deferring a task | AC-053 |
| CT-169 Only the engineering authority, only a human | AC-053 |
| CT-170 Reinstating; one decision chain per task | AC-053 |
| CT-171 Open acceptance criteria | AC-054 |
| CT-172 Registered change | AC-065 |
| CT-173 Changes outside a run are reported | AC-065 |
| CT-174 A v0.3.0 project adopts v0.4.0 without re-approval | AC-056 |
| CT-175 Currentness rests on the adoption record | AC-056 |
| CT-176 An adoption that is not control-equivalent is refused | AC-057 |
| CT-177 Adoption is explicit and has preconditions | AC-057 |
| CT-178 The first revision after adoption has a delta | AC-056 |
| CT-179 Any subset at initialisation | AC-059, AC-035 |
| CT-180 Adding, removing and synchronising on an existing project | AC-059, AC-035 |
| CT-181 Rendered files equal the source | AC-060 |
| CT-182 Installed files are checked against the release | AC-061 |
| CT-183 The core is found through the launcher | AC-062 |
| CT-184 The caller is declared | AC-049 |
| CT-185 Command files hold no lifecycle logic (replaces CT-140) | AC-042 as amended |
| CT-186 Each adapter ships its enforcement files | AC-063 |
| CT-187 `adapter_guard` | AC-063 |
| CT-188 No terminal, no decision | AC-063 |
| CT-189 No decision in an agent context | AC-063 |
| CT-190 Confirmation of the exact subject | AC-063 |
| CT-191 Two consecutive revisions | AC-047 |
| CT-192 Rejection and failed validation in a revision | AC-044, AC-045, AC-026 |
| CT-193 The maintenance regime keeps the unconditional rows | AC-043, AC-045 |
| CT-194 Repairs need no change record | AC-044, AC-045, AC-026 |
| CT-195 A specification revision with a changed Pack | AC-044, AC-045, AC-026 |
| CT-196 Change record integrity | AC-043 |
| CT-197 The permitted set is exact | AC-044, AC-045, AC-026 |
| CT-198 The item index covers the whole content | AC-046 |
| CT-199 An invalid run file | AC-049 |
| CT-200 A v0.3.0 core refuses an adopted project | AC-066 |
| CT-201 Adoption and v0.3.0 adapter files that were edited | AC-056 |
| CT-202 Adoption installs the target release | AC-056 |
| CT-203 Grammar of `.engineering-harness-adapters` | AC-059, AC-035 |
| CT-204 The managed block of `AGENTS.md` | AC-059, AC-035 |
| CT-205 Operator commands are guarded | AC-063 |
| CT-206 Hooks find the launcher from anywhere in the project | AC-062 |
| CT-207 Gated and withdrawn items | AC-053 |
| CT-208 Hand-over equivalence does not depend on what the callers wrote | AC-064 |
| CT-209 A v0.3.0 project under a v0.4.0 core | AC-066 |
| CT-210 `bootstrap` in the maintenance regime | AC-042 as amended |
| CT-211 Re-executing two finished tasks under one change record | AC-052 |
| CT-212 A work-reach change record that also re-executes a task | AC-052 |
| CT-213 A signed decision satisfies the gate | AC-067 |
| CT-214 A decision written as a file is rejected | AC-067 |
| CT-215 The key must be enrolled for the approver | AC-067 |
| CT-216 The signature covers the record | AC-067 |
| CT-217 The signer chain | AC-069 |
| CT-218 Revocation | AC-069 |
| CT-219 Key types and signature vectors | AC-070 |
| CT-220 Adoption carries declared decisions, and only those | AC-068, AC-056 |
| CT-221 Adoption needs the operator's signature | AC-068, AC-056 |
| CT-222 The CLI signs through OpenSSH and never reads the key | AC-070 |
| CT-223 The anchor is accepted once per machine | AC-071 |
| CT-224 Subject decisions are signed | AC-067 |
| CT-225 `check_signers` | AC-069 |
| CT-226 An agent cannot ask OpenSSH to sign through a guarded tool call | AC-063 |

---

# 54. Additional contract-test coverage

Appendix A is the single definitive contract-test set. It incorporates CT-001–CT-113, CT-120–CT-131, the additional closure tests CT-132–CT-138 and the BRS 1.2 tests CT-139–CT-140. No duplicate or earlier test wording is normative.

---

# 55. Requirements-to-acceptance summary

| Requirement areaAcceptance criteria |                        |
| ----------------------------------- | ---------------------- |
| Deterministic repository inspection | AC-001, AC-025, AC-029 |
| Clean repository contract           | AC-001, AC-002         |
| Provenance/release pinning          | AC-008, AC-039, AC-040 |
| Project Pack                        | AC-003, AC-004, AC-005, AC-037 |
| Profile resolution                  | AC-006                 |
| `/engineering`                      | AC-007                 |
| Canonicalisation                    | AC-009                 |
| Validation                          | AC-010, AC-011, AC-012 |
| Candidates                          | AC-012, AC-013         |
| Human approval                      | AC-014, AC-015, AC-016, AC-037 |
| Baselines                           | AC-017, AC-018, AC-019 |
| Currentness/staleness               | AC-020, AC-021, AC-022 |
| AI Policy                           | AC-023                 |
| Work graph                          | AC-024                 |
| Lifecycle/state                     | AC-025, AC-027         |
| Next action                         | AC-026                 |
| Execution readiness                 | AC-028, AC-038         |
| Read-only safety                    | AC-029                 |
| Mutation/persistence                | AC-030, AC-031, AC-032 |
| Filesystem security                 | AC-033                 |
| Results/CLI                         | AC-034                 |
| Tool independence                   | AC-035                 |
| Adapters                            | AC-035, AC-041, AC-042 |
| End-to-end solution                 | AC-036                 |

---

# 56. Test requirements

The implementation shall include:

## Unit tests

For:

- path validation;
- restricted YAML/JSON parsing and NFC key-collision detection;
- distribution-provenance grammar parsing;
- Harness-root convention and release resolution;
- schema resolution;
- Project Pack validation;
- fingerprint construction;
- profile resolution;
- conflict handling;
- canonicalisation;
- digest reproduction;
- candidate creation;
- approval validation;
- baseline validation;
- lineage;
- staleness;
- graph algorithms;
- state derivation;
- next-action derivation;
- outcome aggregation;
- record ID allocation.

## Conformance tests

For every normative `harness-v1` vector.

## Contract tests

For every `CT-*` scenario in Appendix A. Sections 53–54 provide traceability/history only; Appendix A is the definitive scenario text.

## Integration tests

At minimum:

```text
fresh project
→ complete valid Pack
→ PROJECT_INPUT_READY
→ bootstrap_repository
→ Specification creation
→ Specification validation PASS
→ Specification approval
→ Specification Baseline
→ Architecture creation
→ Architecture validation PASS
→ Architecture approval
→ Architecture Baseline
→ AI Policy
→ Work generation
→ Work validation PASS
→ Work approval
→ Work Baseline
→ EXECUTION_READY

```

Also test:

- validation failure/rework;
- rejection/rework;
- Pack change/staleness;
- artefact change/staleness;
- lineage conflict;
- evidence tampering;
- unavailable Harness release;
- invalid Work graph;
- two consecutive revisions;
- a specification-reach revision;
- adoption of a v0.3.0 fixture project that carries v0.3.0 adapter files;
- a three-adapter hand-over;
- the v0.3.0 executable against an adopted project;
- mutation collision.

No deterministic test may require an LLM.

---

# 57. Reference fixture

The release shall include a small neutral reference project.

Recommended domain:

```text
simple catalogue API

```

The fixture shall exercise the complete bootstrap path without relying on a business-specific example such as claims processing.

It shall include enough specification, architecture, AI Policy and Work artefacts to exercise every deterministic v0.3.0 control used by the vertical slice.

---

# 58. Definition of Done

The deterministic Harness core is complete when:

1. a fresh incomplete project is correctly identified as `PROJECT_INPUT_REQUIRED`;
2. a complete valid Pack without a current engineering resolution is identified as `PROJECT_INPUT_READY` with `bootstrap_repository` as the next action;
3. the Project Pack can be validated and fingerprinted deterministically;
4. the recorded Harness release is resolved from the explicit local `harness_root` without silently selecting another version;
5. provenance files are parsed exactly according to FR-033;
6. profile resolution deterministically produces `/engineering`;
7. approval-requiring overrides are rejected as unsupported and no override approval flow exists;
8. no executable security-exception flow is required or fabricated;
9. all normative canonicalisation vectors pass;
10. diagnostic checks are read-only;
11. authoritative FAIL/ERROR validations persist evidence only;
12. authoritative PASS validation atomically publishes PASS evidence and the exact approval candidate after final subject re-verification;
13. explicit authorised human decisions can be recorded;
14. approval and baseline establishment remain separate;
15. the three human-approved baselines can be established and verified;
16. rejected candidates cannot later establish baselines;
17. baseline lineage is deterministic and fail-closed;
18. historical validity and currentness are distinguished;
19. staleness propagates correctly;
20. AI Policy currentness is verified;
21. Work graph validity is deterministic;
22. lifecycle state is reconstructed from current evidence;
23. exactly one next bootstrap action is returned where applicable;
24. execution is prohibited whenever a required prerequisite is stale, invalid, missing or blocked, except as Section 43 permits under a work revision;
25. status inspection performs no repair or mutation;
26. append-only records cannot be overwritten by normal Harness operations;
27. mutation locking and precondition checks prevent normal competing mutations;
28. all public operation results conform to `schema://result/operation/v1`;
29. CLI results and exit statuses match Sections 48–49;
30. every definitive contract test in Appendix A passes;
31. every version-1 schema passes JSON Schema Draft 2020-12 meta-validation;
32. the complete reference fixture reaches `EXECUTION_READY`;
33. the same project state produces the same engineering conclusion through library, CLI, CI and adapter callers; and
34. no implementation behaviour depends on earlier design conversations.
35. every acceptance criterion AC-043 to AC-071 is satisfied; and
36. the acceptance scenario of Section 72.3 passes on a clone of a real v0.3.0 project.

---

# 59. Implementation freedom

The BRS does not prescribe:

- programming language;
- package names;
- class hierarchy;
- internal function decomposition;
- CLI framework;
- JSON Schema library;
- YAML library;
- local locking implementation;
- internal caching strategy.

These are development decisions provided that all observable requirements and contracts in this BRS remain satisfied.

---

# 60. Change control

If development discovers that a requirement cannot be implemented without changing:

- schema fields;
- enums;
- lifecycle semantics;
- gate semantics;
- authority rules;
- digest construction;
- canonicalisation;
- candidate bindings;
- baseline rules;
- currentness;
- staleness;
- next-action semantics;
- issue-code semantics; or
- exit-status semantics;
- provenance grammar;
- Harness-root/registry resolution semantics;
- normative schema definitions;
- change-record semantics;
- reach rules;
- the permitted-operation set;
- delta construction;
- runtime state transitions;
- disposition semantics;
- adoption equivalence;
- the reserved-operation guard;
- the signature format, the accepted key types and the signer chain;
- the adapter manifest;
- the core contract of a release;

the implementation team shall raise a contract change.

It shall not silently invent alternative behaviour in code.

A change set that alters a normative file updates the handover manifest in the same commit. BRS 2.0 is recorded against release v0.4.0.

---

## 60.1 Normative annex files

The following package files are part of this BRS and mandatory for implementation/conformance:

```text
schemas/schema-catalog.json
schemas/*.schema.json
annexes/canonicalisation-harness-v1.md
annexes/canonicalisation-vectors.json
annexes/contract-tests.md
annexes/signature-vectors.json
```

The same definitive contract tests are also reproduced in Appendix A below so the BRS remains readable as one document. The schema files remain separate because they are executable contracts rather than prose examples.

## 60.2 Decisions reflected in this version

| Decision | Subject | Option taken | Sections that carry it | Status |
| --- | --- | --- | --- | --- |
| D-01 | Base | (a) BRS 1.2 is the base; BRS 2.0 is published as `docs/v0.4.0/BRS.md` | Title block; whole document | decided |
| D-02 | Maintenance task without a requirement | (a) `requirement_refs` and `acceptance_refs` may be empty when the task lists a change record of kind `documentation` or `defect` that declares an acceptance statement | 32, 62.2, 65.4, AC-043 | decided |
| D-03 | Execution during a revision | (a) tasks untouched by a revision of reach `work` keep executing; a revision of reach `architecture` or `specification` stops execution | 37, 43, 64.3, AC-028 | decided |
| D-04 | Change made outside a task | (a) registrable as a change record with origin `registered` and reach `none` | 66, AC-065 | decided |
| D-05 | What a run records | (a) raw-byte digest of every changed path; `check_maintenance` reports later differences | 64.2, 66.5 | decided |
| D-06 | Decision guard | (c) signed decisions by SSH signature, with the guard of Section 68.2 kept | 22, 68, 73, AC-063, AC-067 to AC-071 | decided |
| D-07 | Adoption and currentness | (a) release binding through adoption only when control-equivalent; an adoption that is not control-equivalent is refused | 29, 30, 67.3, 71.2, AC-056, AC-057 | decided |
| D-08 | Who adopts | (a) `adopt_release` is an operator command, not a human decision, as amended by F-1 (the adoption record is signed) | 67.1, 68, AC-056 | decided |
| D-09 | Agent surfaces | (a) Claude Code, Codex and Copilot; one `AGENTS.md` with a managed block; identical command text | 69.1, 69.3, 69.7 | decided |
| D-10 | Revisions | (a) one change record per revision, one revision at a time | 63.1, 63.2 | decided |
| D-11 | Disposition and a changed definition | (a) the disposition stays in force and the change is reported | 65.3 | decided |
| D-12 | Schema evolution | (a) optional fields and enumeration values inside version 1 | 9, 9.18, 67.7 | decided |
| D-13 | `complete_task` | (a) refuses a failed or missing verification result and an out-of-scope path | 64.4 | decided |
| D-14 | Finding the core | (a) launcher `harness` and `harness.cmd` | 69.4 | decided |
| D-15 | Where Stage 2 is built | (a) a `v0.4.0` branch in each repository | none (build process, not a requirement) | decided |
| D-16 | What is run by the agent and what by the owner | confirmed: fixture tests simulate human decisions; on real clones every decision and `adopt_release` is the owner's | contract-test annex (fixture signers); 72.3 | decided |
| D-17 | Reach of a change | (a) the core fixes the reach when the record is opened | 62.3 | decided |
| D-18 | Refusal by a v0.3.0 core | (a) the release declares a core contract and drops the `bootstrap_workflow` key | FR-032, FR-059, 71.3, AC-066 | decided |
| D-19 | Who may sign an adoption record | any enrolled identity that holds an authority in the Pack | 67.4 | confirmed by the owner, 2026-11-20 |
| D-20 | Where trust in the keys starts | (a) signer chain, head named by every signed record, anchor accepted per machine | 68.2, 73.4, 73.7, AC-069, AC-071 | confirmed by the owner, 2026-11-23 |
| D-21 | A lost key | (a) no recovery; enrol a second key and keep it apart | 73.4 | confirmed by the owner, 2026-11-20 |
| D-22 | A key an agent cannot use | (a) the core never opens a private key; a private key file without a passphrase is refused unless hardware-backed | 68.3, 68.4, 73.6, AC-070 | confirmed by the owner, 2026-11-20 |
| D-23 | Typed confirmation | (a) kept: the operator types the last eight characters of the digest | 68.2, AC-063 | confirmed by the owner, 2026-11-20 |
| F-1 | Adoption record signed | (a) signed by any enrolled identity that holds an authority in the Pack | 67.4, 73.1, AC-056 | confirmed by the owner, 2026-11-20 |
| RUL-47 | Anchor that cannot be recorded in the trust file | the record stands and the operator is told on standard error | 73.7 | confirmed by the owner, 2026-11-20 |
| RUL-48 | Item 5 of 73.3 on subject decisions | applied on read: dispositions by a former holder of the authority have no effect and are reported | 73.3 | confirmed by the owner, 2026-11-20 |
| RUL-52 | Adoption records and declared decisions | the adoption records hold as one chain; without a valid record the declared decisions are not carried and their baselines are invalid and stale | 67.4, CT-175 | confirmed by the owner, 2026-11-20 |
| RUL-57 | Installing the target release during adoption | through the CLI the preflight installs the target release before the summary is shown | 67.1 | confirmed by the owner, 2026-11-20 |
| RUL-62 | Acceptance notes | a note names a criterion of the specification or a change record's acceptance statement; any other is `VALIDATION_FAILED` | 64.4 | decided by the owner, 2026-11-20 |
| RUL-63 | Who signs at a gate | under core contract 2 the pending gate names `authority` and `approver` | 63.4 | decided by the owner, 2026-11-20 |
| RUL-64 | Open runs and changes outside a run | a path an open run has reported is not listed under `outside_run` | 66.5 | decided by the owner, 2026-11-20 |
| RUL-65 | A project root that does not exist | `adopt_release` refuses it first with `REPO_REQUIRED_PATH_MISSING`, before installing | 67.2 | decided by the owner, 2026-11-20 |
| RUL-66 | The codes of `init` | the 15 `INIT_*` codes are listed by name in Section 47; no category, outcome or condition is defined for them | 47 | decided by the owner, 2026-11-23 |


# 61. Final implementation rule

> **Implement the Harness contracts; do not reinterpret them.**

The repository and recorded Harness release must contain enough authoritative evidence to reconstruct the current engineering state without an AI model, conversational history or inferred human approval.

---

# 62. Change records

## 62.1 Purpose

In the maintenance regime nothing replaces a baseline, re-executes a finished Work Item or records work done outside a run without a change record.

## 62.2 Content

A change record is stored under `evidence/changes/` and contains:

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

## 62.3 Reach

The core determines the reach when the record is opened and stores it.

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

"`execution` when the operator names only Work Items to re-execute" means: `rework` is given and no acceptance statement is given.

A requested reach below the minimum is refused with `CHANGE_REACH_INVALID`. A registered change has reach `none`.

| Reach | Baselines the revision replaces |
| --- | --- |
| `none` | none; no revision and no execution |
| `execution` | none; named finished Work Items are re-executed |
| `work` | Work |
| `architecture` | Architecture, then Work |
| `specification` | Specification, then Architecture, then Work |

The core enforces the reach from facts. A chain outside the reach that is not current blocks the revision (Section 37 row 5). A changed Pack needs reach `specification` (rows 3 and 4). A Work Item that names no requirement is allowed only under the kinds of Section 32. A revision that turns out to need more is continued under a superseding record of wider reach.

## 62.4 `open_change`

Inputs: the kind, the title, the statement, and optionally the requested reach, the Work Items to re-execute, acceptance statements and the record to supersede. Permitted in the maintenance regime whenever the release resolves. Every Work Item named for re-execution shall be in the task set of the governing Work Baseline with effective status `done`; otherwise `open_change` is refused with `TASK_UNKNOWN` or `TASK_NOT_READY`. It writes one record with exclusive-create semantics under the mutation lock.

`open_change` whose resulting reach is `execution` and which names no Work Item to re-execute is refused with `CHANGE_REACH_INVALID` and writes nothing: reach `execution` means that named finished Work Items are re-executed (62.3). A hand-written record of that shape is not a fault; it is `completed`.

## 62.5 Derived status

The status of a change record is derived, never stored. The first row that applies gives it:

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

The derived status of a change record is given by the table above alone. A record that waits behind the active revision change is `in_revision` when a candidate written while it was active still names it, otherwise `open`.

## 62.6 `abandon_change`

Permitted for a planned record whose status is `open` or `in_revision`, or whose reach is `execution`, while no chain is satisfied for it, no run is bound to it, no current undecided or approved candidate names it, and every chain in its reach has artefacts equal to those of its head baseline. It writes a closure record. After a baseline has been established under a change record the revision can only go forward.

---

# 63. Revisions

## 63.1 One revision at a time

A revision replaces baselines under exactly one change record.

## 63.2 Active revision change

The candidates are the planned change records of reach `work` or wider that are not superseded, not abandoned and have a chain in their reach that is not satisfied for them. A record's position is the sequence number of the oldest planned record in its supersession chain. The candidate with the lowest position is the active revision change. Later ones wait.

## 63.3 Steps

The steps of a revision are the next actions of Section 37. A revision is complete when every chain in the reach of its change record is satisfied for it.

## 63.4 Item index and delta

Every candidate written by a v0.4.0 core carries an item index. For each item it gives the kind, the ID, the artefact path and the `harness-v1` digest of the item.

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

## 63.5 Authoring in a revision

The authoring operations take a complete artefact set, as in the bootstrap regime. The core writes an unchanged artefact with identical bytes. The adapter authors a revision from the existing artefact and changes only what the change record requires: subject matter that changes keeps its ID, new subject matter gets a new ID, and a retired ID is never reused.

## 63.6 Upstream change notice

When a Work candidate is validated in a revision of reach `architecture` or `specification`, the core reports, with code `BASELINE_UPSTREAM_STALE` at severity `WARNING` and so without failing validation, every Work Item whose `task` item is unchanged and which references an item that the revision's Specification or Architecture baseline changed or removed.

---

# 64. Runtime state and task execution

## 64.1 Ownership

Runtime state is read and written only by the core. An adapter never writes under `work/state/`.

## 64.2 Run record

A run is stored as `work/state/<TASK-id>/RUN-<nnnn>.yaml` under the release schema and contains:

- the run ID and the Work Item ID;
- the Work Item definition it executes, by path and digest;
- the Work Baseline in force when it started, by ID, path and digest;
- the change record under which it was reopened, if any; the legacy file it continues, if any;
- the status: `in_progress`, `blocked` or `done`;
- the ordered events, each with a sequence number, a type (`started`, `resumed`, `progress`, `blocked`, `completed`), the Harness-generated timestamp, the caller as declared (an adapter identifier, or `operator`), and an optional note;
- the changed paths reported so far, in ascending path order;
- at completion: the verification result of every control, optional notes per acceptance criterion, and the raw-byte digest of each changed path.

Events are only appended. A run whose status is `done` is never modified. A run file that does not validate against the schema, or whose Work Item, number or path disagree, is `TASK_STATE_INVALID`: it is never modified, and its Work Item requires rework.

Under `work/state/` dot-files are ignored; any other unexpected file is `TASK_STATE_INVALID` at severity `WARNING` and changes no conclusion. When `work/state` itself cannot be read (symlink, not a directory, unlistable) the fault is an `ERROR` (`REPO_FORBIDDEN_SYMLINK` or `TASK_STATE_INVALID`), every Work Item's latest state counts as invalid (`rework_required`, never `pending`), no run is created, and execution is prohibited.

The `work/state` layout fault just described and an unreadable subject decision are errors that prohibit execution. An invalid latest state file of a Work Item is an error in the result but does not withdraw execution readiness: `start_task` stays possible. Superseded invalid files, history and stray files are warnings that take no part in any outcome.

## 64.3 Effective status

The task set is the task set of the governing Work Baseline; under a work revision it also includes the Work Items the working tree adds. Execution-graph order and dependencies are those of the working tree's graph. A Work Item of the governing Work Baseline that the working tree no longer holds is listed after all others, in ascending ID order. When the working tree's graph cannot be read, the items of the governing baseline's item index are listed in ascending ID order and none is ready. The status of a Work Item is the first row that applies:

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

## 64.4 Operations

`list_tasks` returns every Work Item of the task set in execution-graph order with its effective status, dependencies, readiness and the reason when it is not ready; the historical state; and the open acceptance criteria (Section 65.4). It writes nothing.

`select_task` returns the Work Item to execute. With a named item: that item when it is ready, and otherwise no item and the reason (`TASK_NOT_READY`, `TASK_ALREADY_DONE` or `TASK_NOT_EXECUTABLE`). Without a name: the first item in execution-graph order whose effective status is `in_progress` and which `start_task` would accept; if there is none, the first item whose effective status is `pending` or `rework_required` and which `start_task` would accept. When Section 43 prohibits execution it returns no item and `EXECUTION_NOT_PERMITTED`. A blocked item is returned only by name. `select_task` returns the definition, the open run with its events and notes if there is one, and the operations permitted on the item. It writes nothing.

`start_task` requires that Section 43 permits execution of the item and that the item is ready. If the latest run is open and its definition digest is current, it appends a `resumed` event. Otherwise it creates the next run. It is refused with `TASK_ALREADY_DONE` for a `done` item, `TASK_NOT_EXECUTABLE` for a deferred, withdrawn or gated item, `EXECUTION_NOT_PERMITTED` when Section 43 prohibits execution, and `TASK_NOT_READY` otherwise.

`record_task_progress` appends a `progress` event with a note to the open run, and accepts changed paths. Its purpose is hand-over: the note states what is done and what remains, so that the next session needs nothing but the repository. `block_task` sets the open run to `blocked` with a reason and accepts changed paths in the same way; `start_task` resumes it. Both require an open run on the current definition (`TASK_RUN_NOT_OPEN` otherwise) and not that execution is permitted, so that work can be parked.

The core checks every reported path at once: a path outside the item's `repository_scope.allowed`, inside its `forbidden`, or a reserved path is `TASK_SCOPE_VIOLATION` and nothing is written.

The patterns of `repository_scope` are read as follows: `**` matches any number of path segments, `*` and `?` match within one segment, every other character matches itself, a pattern that names a directory covers everything beneath it, and a trailing slash or an empty segment is ignored.

A changed path that no longer exists at completion is recorded as `{ path, absent: true }`. A reported path that exists but is not a regular file is `TASK_SCOPE_VIOLATION`. The scope check comes before the verification checks.

`complete_task` takes a task result document: a verification result (`PASS`, `FAIL` or `NOT_RUN`, with the command and a note) for every identifier in the item's `verification_controls`, optional notes per acceptance criterion, and changed paths. It requires an open run on the current definition and that Section 43 permits execution of the item, and it is refused with `TASK_NOT_EXECUTABLE` for an item under a disposition. The core refuses completion when a control has no result (`TASK_VERIFICATION_INCOMPLETE`) or a result is `FAIL` (`TASK_VERIFICATION_FAILED`). `NOT_RUN` is accepted and recorded; the core never turns it into `PASS` (Section 50). On success the run records the union of the paths reported during the run and in the result document, with the digest of each, and is `done`.

`reopen_task` requires a Work Item whose effective status is `done` or `rework_required` (`TASK_NOT_READY` otherwise), that Section 43 permits execution of it, and a change record with status `in_execution` that lists the item in `rework` and has no run bound to it for that item (`CHANGE_NOT_OPEN` otherwise). It creates the next run, bound to that change record. The earlier run is untouched.

The core does not run verification commands and does not observe the working tree. What a caller reports in `complete_task` is the caller's claim, recorded with the caller's name.

`select_task` with nothing selectable and no name returns no item and no issue code. A task result document that fails its schema is `VALIDATION_FAILED`. An acceptance note names a criterion of the specification (`AC-…`) or an acceptance statement of a change record (`CHG-nnnn-AC-nn`); a note that names a criterion neither defines is `VALIDATION_FAILED`, and nothing is written. Verification entries for controls the item does not list are recorded as given.

The `work` block of a result carries `dispositions` and `not_executable`.

## 64.5 Carry-over under a new Work Baseline

Establishing a Work Baseline writes nothing under `work/state/`. Carry-over is the derivation of 64.3: a Work Item whose definition digest is unchanged keeps its status; a changed one is `rework_required` and its next `start_task` creates a new run; a removed one keeps its state as history.

## 64.6 Legacy state

A file `work/state/<TASK-id>.yaml` written under the FR-036 grammar of BRS 1.2 is a legacy run. The core reads it as YAML and types only `task`, `status` and `work_baseline`; every other value is opaque and is ignored. It takes the definition digest from the candidate of the Work Baseline the file names, and treats the file as the run that precedes `RUN-0001`. It never rewrites, moves or deletes the file. A legacy file that cannot be read this way is `TASK_STATE_INVALID` and its Work Item requires rework.

An open legacy run is never appended to. `start_task` on its Work Item creates `RUN-0001`, whose first event has type `resumed` and which names the legacy file it continues.

The legacy state grammar is the runtime-state grammar of FR-036 of BRS 1.2. It is no longer written:

```yaml
schema_version: 1
task_state:
  task: TASK-001
  status: in_progress            # in_progress | done | blocked
  work_baseline: baselines/work/WORK-0001.yaml   # newest record under baselines/work/
  started: <RFC 3339 UTC timestamp>
  updated: <RFC 3339 UTC timestamp>
  verification:
    - control: <control id>
      result: PASS               # PASS | FAIL | NOT_RUN
      command: <optional>
      note: <optional>
  changed_paths: []
  notes: <optional>
```

## 64.7 Hand-over equivalence

Two runs of one Work Item are hand-over equivalent when they agree on the Work Item, the definition digest, the Work Baseline, the change record, the final status, the identifiers of the verification controls with a result, and the sequence of event types after `progress` and `resumed` events are removed; and when `list_tasks`, `inspect_project` and `check_maintenance` give the same conclusions for both projects. Callers, timestamps, notes, changed paths and digests are not compared.

---

# 65. Task dispositions

## 65.1 Decision

`record_task_decision` records that a Work Item of the governing Work Baseline's task set is `deferred`, `withdrawn` or `reinstated`. It is a reserved operation at `gate://task-disposition`, permitted whenever a governing Work Baseline exists, including during a revision. The decision record is stored under `evidence/decisions/` and binds the Work Item ID, its definition digest, the Work Baseline, the decision, the reason, the approver and authority, the identity assurance, the change record if one is given, and the previous decision on the same Work Item, which it supersedes. A Work Item with two unsuperseded decisions, or a decision with two successors, is `DECISION_RECORD_INVALID`; the item is then treated as deferred until the fault is removed.

A subject decision is a signed record (Section 73). One whose signature is missing or does not verify has no effect on any disposition or registered change: the chain is read as if the record were absent, and the record is reported as an error, which prohibits execution (Section 43) until it is removed. A forged reinstatement therefore starts nothing, and a forged deferral stops the project visibly instead of silently.

Under a release of core contract 2 no subject decision is declared: its `identity_assurance` is `ssh-signature`, `signed`, only.

## 65.2 Meaning

`deferred`: the item will not be executed in this project for now, for the reason given, for example because another team delivers it with its own tooling. `withdrawn`: the item will not be executed. `reinstated`: the previous disposition ends.

## 65.3 Effect

The disposition in force for a Work Item is the head of its decision chain. A deferred or withdrawn item is never selected and `start_task` refuses it. A Work Item that depends on it is not ready, and `list_tasks` says why. A disposition stays in force when a revision changes the item's definition; the core then reports that the definition changed after the decision. It ends when the item is reinstated or leaves the task set.

## 65.4 Open acceptance criteria

A criterion of the specification is closed when every Work Item that references it is `done`. Otherwise it is open. The acceptance statements of a change record are reported with the record: closed when every Work Item attributed to the record is done for it (Section 62.5), and otherwise open, also when an attributed Work Item is no longer in the task set. For each open criterion `list_tasks` and `check_maintenance` report the Work Items that are done and those that are not, with their effective status. A criterion with no done Work Item is reported as not delivered. A criterion kept open only by deferred or withdrawn items is reported as open by disposition. Nothing removes a criterion from the report.

An open-criterion entry is `{ id, source: specification | change, not_delivered, open_by_disposition, done: [ids], not_done: [{ id, status }] }` with `status` an effective status or `not_in_task_set`.

---

# 66. Registered changes

## 66.1 Purpose

A change made outside a run to a path that is not a reserved path cannot be turned into a run. It can be registered.

## 66.2 Registration

`open_change` with origin `registered` records the changed paths with the raw-byte digest of each at registration, optionally the Git commits that contain the change, and the finished Work Items whose deliverables the operator says it touches. The reach is `none`. A reserved path in the list is refused with `TASK_SCOPE_VIOLATION`. Git data is provenance, not authority.

## 66.3 Decision

`record_change_decision` records `accepted` or `rejected` at `gate://registered-change`. It is a reserved operation. Until then the change is `awaiting_decision`.

## 66.4 How it is told apart from work under a task

A registered change has origin `registered`, has no run, and carries no verification result. The runs of the Work Items it names are not modified. `list_tasks` and `check_maintenance` report those items as done, with the note that their deliverables were changed by a registered change and whether that change was accepted. A rejected registered change stays in every report until a planned change record names it as superseded.

## 66.5 Changes outside a run

`check_maintenance` reports every path whose current raw-byte digest equals none of the digests recorded for it by a done run or by a registered change that is not rejected. This is a report. It blocks nothing, and it covers only paths recorded by a v0.4.0 run or a registered change. A path that a run still open (`in_progress` or `blocked`) has reported is that run's work and is not listed while the run is open.

A path that is absent now and recorded absent counts as unchanged. `maintenance.outside_run` is reported by `check_maintenance` only, not by `inspect_project`.

---

# 67. Release adoption

## 67.1 Operation

`adopt_release` changes the governing release of a project. It is an operator command (Section 68) and records no human decision. Its record is signed by the operator (67.4), because it is the record that lets decisions without a signature stand. It takes the target version, the adapters to install (by default the adapter the project records), whether to replace adapter files that were edited (`--replace-adapter-files`), the operator's identity and signing key, and the same release source inputs as `init`. It first installs the target release under the Harness root by the rules of FR-032, reusing an installed release only when it is byte-identical. The result names the release directory.

`adopt_release` returns its own result document, not an operation result; a guard refusal of it is the five-member refusal document of Section 68.2. Through the CLI the preflight installs the target release under the Harness root before the summary is shown, and the result says `INSTALLED`. A refused or abandoned adoption leaves the release installed and the project untouched. The library adopts only into an installed release when no source is given (`ADOPTION_UNSUPPORTED` otherwise); it makes no silent clone.

## 67.2 Preconditions

- the project root exists and is a directory; otherwise `REPO_REQUIRED_PATH_MISSING`, checked first and before the target release is installed;
- the target release is available and its release definition lists the project's recorded release in `adoptable_from`; otherwise `ADOPTION_UNSUPPORTED`;
- the project resolves under its recorded release, its Pack is valid and its engineering resolution is current;
- no candidate is awaiting a decision and no approved candidate awaits its baseline;
- every baseline head is current or absent.

A failure of the last three is `ADOPTION_NOT_PERMITTED`. In every case nothing is written to the project.

A rejected candidate that is not baselined does not refuse adoption. An unreadable or non-reproducing decision record refuses adoption (`ADOPTION_NOT_PERMITTED`).

## 67.3 Control equivalence

The core resolves the effective control set of the project under the target release. The adoption is **control-equivalent** when the engineering-resolution digest is the same under both releases and the target release's deterministic validation controls, run in diagnostic mode on the artefacts of each current baseline as a subject without a revision member, all return `PASS`. The rule of Section 32 on added and changed Work Items does not apply to such a subject. An adoption that is not control-equivalent fails with `ADOPTION_NOT_EQUIVALENT`, lists the differences and writes nothing.

## 67.4 Adoption record

A successful adoption writes one record under `evidence/adoptions/` containing: the releases adopted from and to; the Project Pack fingerprint; the engineering-resolution digest before and after; the statement of control equivalence; for each current baseline its ID, digest, candidate digest, the controls run and their result, and the item index of its artefacts; the Project AI Policy digest; the previous adoption record, which it supersedes; the timestamp and how it was captured; and its self digest.

When the release adopted from has no signed decisions, the record also lists every decision record the repository holds at that moment, by ID, path and digest (`declared_decisions`). These, and no others, keep their declared assurance (Section 22).

The adoption record is a signed record (Section 73). It names the operator's identity, which shall hold at least one authority in the Project Engineering Pack, the key and the signer record that is the head of the chain. When the project has no signer chain, the same mutation writes the anchor for that identity and key, and the adoption record names the anchor. An adoption record without a valid signature satisfies nothing (Section 29): the release binding fails, every baseline it would carry is stale, and no decision it lists keeps its assurance.

The record is `evidence/adoptions/ADOPT-nnnn.yaml` with its signature file `ADOPT-nnnn.yaml.sig`. Who signed an adoption record is not compared with the Pack on read; the authority is checked when it is written.

The adoption records form one chain that holds as a unit: one present and invalid record and none satisfies anything. Each faulty record is reported `ADOPTION_RECORD_INVALID`, a row-1 fault (`resolve_blocker`). Without a valid adoption record the declared decisions are not carried: each is `APPROVAL_IDENTITY_ASSURANCE_INVALID`, and its baseline is invalid and stale.

## 67.5 What adoption writes

As one logical mutation under the lock:

- the adoption record with its signature file, and the signer anchor with its signature file when the project has no signer chain;
- `.engineering-harness-template` with the new version, and `engineering/` re-materialised for the target release;
- `.engineering-harness-adapters`; `.engineering-harness-adapter` is deleted;
- the adapter files, as follows. The target release carries, for each release in `adoptable_from`, the overlay files of that release's adapters. A v0.3.0 project does not record the core command it was initialised with, so the core recovers it from the files. A file whose release file holds no placeholder is **pristine** when it is byte-identical to the release file. A file whose release file holds the placeholder is pristine when one string exists that, substituted for every occurrence of the placeholder (escaped as a JSON string in a `.json` file, as v0.3.0 `init` wrote it), reproduces the project file byte for byte; the string must be the same in every such file of the recorded adapter, otherwise none of them is pristine. A pristine file is replaced by the new overlay file at that path, or removed when the new overlays have none. A file that is not pristine and lies at a path the new overlays write is `ADAPTER_FILE_CONFLICT`: the adoption writes nothing, unless the operator asks for replacement. A file that is not pristine and that the new overlays do not write is left in place. The result lists every file written, replaced, removed and left.

The write order is: the signer anchor, the adoption record (each signature file first), the files of `engineering/`, the adapter files and `.engineering-harness-adapters`, the removal of `.engineering-harness-adapter`, and `.engineering-harness-template` last. Adoption verifies its own effect after the mutation: every baseline summary, the Project AI Policy, the Work graph, the lifecycle state and `execution_permitted` are unchanged. Otherwise it restores every file and answers `ADOPTION_NOT_EQUIVALENT`.

It writes nothing else. It modifies no record under `baselines/` or `evidence/` and no file under `spec/`, `architecture/`, `ai/` or `work/`.

## 67.6 Effect

After a control-equivalent adoption every baseline that was current is current (Section 29), the Project AI Policy is current without being re-derived, the Work graph is valid, and the lifecycle state is what it was. No validation, candidate or decision record is created.

## 67.7 Compatibility duty of a release

A release that lists an earlier release in `adoptable_from` shall accept, under its schemas and controls, every document that was valid under the earlier release.

---

# 68. Reserved operations, operator commands and the guard

## 68.1 What is guarded

The reserved operations are `record_specification_decision`, `record_architecture_decision`, `record_work_decision`, `record_task_decision`, `record_change_decision` and the short forms `approve_pending` and `reject_pending`. The operator commands are `adopt_release`, `enrol_signer`, `revoke_signer`, `trust_signers`, `adapter_add`, `adapter_remove` and `adapter_sync`. `init` is not guarded: it creates a project and touches no governed state.

## 68.2 Guard in the CLI

The CLI performs a reserved operation only when all six conditions hold. Otherwise it writes nothing.

1. `--adapter` is absent. Otherwise `GUARD_AGENT_CONTEXT`.
2. The environment carries none of the agent session markers. These are the union of the markers built into the core (those of the adapters it ships: `CLAUDE_CODE_CHILD_SESSION` and `CLAUDECODE` for Claude Code, `CODEX_THREAD_ID` for Codex) and those of the governing release's adapter manifest when it has one; the guard therefore works on a project governed by v0.3.0 and never runs with an empty list. A marker set to the empty string counts as absent. Otherwise `GUARD_AGENT_CONTEXT`.
3. A controlling terminal is available. The CLI reads every confirmation from the controlling terminal device only, never from standard input. Otherwise `GUARD_NOT_INTERACTIVE`.
4. The signer anchor of the project is the one the operator accepted on this machine (Section 73.7), and the project's signer chain still contains the last chain head this machine has seen, with that digest. Otherwise `GUARD_ANCHOR_UNTRUSTED` or `GUARD_ANCHOR_CHANGED` (the latter also when the chain was rewritten).
5. The CLI has shown the operator, on that terminal, the gate, the subject, its digest, the signer it will sign as and, for a candidate in a revision, the delta summary; and the operator has typed the last eight characters of the subject's digest. Otherwise `GUARD_CONFIRMATION_FAILED`.
6. The operator's OpenSSH has signed the record and the signature verifies for a key enrolled for the approver (Section 73.6). Otherwise `GUARD_KEY_UNPROTECTED`, `GUARD_SIGNING_FAILED` or `SIGNER_NOT_ENROLLED`.

An operator command needs conditions 1 to 3. `adopt_release`, `enrol_signer` and `revoke_signer` write signed records and also need conditions 4 and 6; condition 4 does not apply to the command that writes the anchor.

After conditions 1 to 3 and the key path, the CLI asks the operation's own precondition and returns that refusal before anything is shown, confirmed or signed. The key-path usage error (exit 64) is decided after conditions 1 to 3.

The subject digest is the candidate digest, the Work Item definition digest or the change record digest. The decision record states `captured_via.interface = cli` and that the terminal confirmation was obtained.

Conditions 1 to 5 are part of the CLI and apply whatever release governs the project. On a project governed by v0.3.0, condition 4 does not apply and condition 6 is replaced by the declared identity of BRS 1.2. The library interface has no guard, because the guard concerns how the CLI captures a human act; but the signature of Section 73 is checked by the core itself whenever it reads a record, so a caller of the library cannot record a decision without one either. An embedding that exposes reserved operations to an agent violates this BRS.

A refusal by the CLI guard is the CLI's own five-member refusal document (the shape of the refusal of Section 72.1, valid under the v0.4.0 result schema), whatever release governs the project. On a project governed by v0.3.0 it is therefore not a v0.3.0 result.

## 68.3 `adapter_guard`

A distribution command that an agent's tool hook invokes before a tool call. It reads the call from standard input in the hook format of any shipped adapter, including the format one agent uses when it runs another agent's hook.

- For a shell command: when the command line contains, as a shell word, the name of a reserved operation or of an operator command, or invokes `ssh-keygen` with `-Y sign`, it exits with status 2 and writes the reason to standard error.
- For a file-writing tool: when the target is a reserved path other than under `project-pack/`, it exits with status 2 in the same way.
- For every other call, and for both kinds otherwise, it exits with status 0 and no output.

Every shipped agent treats exit status 2 as a denial, and GitHub Copilot CLI also denies on any status other than 0 and 2; the command therefore exits with status 0 or 2 and no other, whatever fails. Input it cannot read is unreadable input and is denied; after an internal error it applies the two rules above to the command line read as plain text, and otherwise allows. The command resolves a target path against the project root that the launcher passes to it. From the project it reads only `.engineering-harness-template`, to find the adapter manifest of the governing release; when that fails it uses the overlay paths of its own release. `AGENTS.md` is denied as a whole file. A call whose target it cannot determine is allowed. The command writes nothing and gives the same answer however often it is run for one call.

## 68.4 What this is and is not

The hooks, the agents' own deny rules and conditions 1 to 3 and 5 prevent an agent from recording a decision by following or misreading instructions. They are not authentication. Authentication is the signature of Section 73: a record written as a file, or a confirmation typed by an agent, yields nothing without a signature by an enrolled key.

What remains is no longer a gap in the Harness but a condition on its use, and `DECISIONS.md` Section 4 puts each to the owner:

1. **A key an agent can use.** A private key file without a passphrase, or a key held by an SSH agent that signs without asking, can be used by any process of the same user, including a coding agent. The CLI refuses a private key file that has no passphrase unless the key is hardware-backed. It cannot see how an SSH agent is configured. The operator shall use a key that needs them for every signature: a passphrase-protected key that is not loaded into an agent, an agent key added with per-use confirmation, a hardware key that requires touch, or a key manager that asks each time.
2. **The anchor.** The signer chain is stored in the repository, which an agent can write. Records signed under the chain bind it, so a replaced chain breaks them. But a chain replaced before any such record exists, or replaced together with everything signed under it, is consistent in itself. The CLI detects this on every machine where the operator accepted the anchor (Section 73.7); elsewhere it is found only by comparing the anchor's fingerprint.
3. **A signature given without reading.** The CLI shows the subject and the delta and asks for the digest; it cannot make the operator read them.

---

# 69. Adapters

## 69.1 Shipped adapters

v0.4.0 ships `claude-code`, `codex` and `copilot`. The supported surfaces of each are listed in its contract.

## 69.2 One source

The release holds, under `adapters/`:

- `source/instructions.md` and `source/commands/{bootstrap,execute,maintain}.md`: the single authored text of the project instructions and of each command;
- `adapters.yaml`: the adapter manifest. For each adapter it gives the identifier, the overlay files with the source each is rendered from and its native front matter, the files it shares with other adapters, its enforcement files and its agent session markers. It also gives, for each release in `adoptable_from`, the overlay files of that release's adapters (Section 67.5);
- `<adapter>/overlay/**`: the rendered files;
- `<adapter>/ADAPTER-CONTRACT.md`: the contract, never copied into a project;
- `common/overlay/**`: the files installed with any adapter.

The text of the instructions and of each command is identical in every rendering. A rendering adds only its path, its front matter and the files that the agent requires beside it. The text never states which adapter it was rendered for: it lists the identifiers of all adapters of the manifest and tells the agent to pass its own. This matters because agents read each other's files (`AGENT-SURFACES.md`).

`render_adapters` renders the overlays from the source and the manifest. With `--check` it writes nothing and fails when a rendered file differs. The build runs it. `adapters/` is a release component installed under `<harness_root>/releases/<version>/`.

## 69.3 Overlays of v0.4.0

The manifest is authoritative; this table reproduces it.

| Layer | Files |
| --- | --- |
| common | the managed block of `AGENTS.md` (project instructions); `harness`, `harness.cmd` (launcher) |
| `claude-code` | `CLAUDE.md` (one line that imports `AGENTS.md`), `.claude/commands/{bootstrap,execute,maintain}.md`, `.claude/settings.json` (allow, deny, hook) |
| `codex` | `.agents/skills/{bootstrap,execute,maintain}/SKILL.md` with `agents/openai.yaml`, `.codex/rules/engineering-harness.rules`, `.codex/hooks.json` |
| `copilot` | `.github/skills/{bootstrap,execute,maintain}/SKILL.md`, `.github/hooks/engineering-harness.json` |

An installed overlay file is byte-identical to the release file. No overlay file contains a value specific to a project or a machine. Each rendered `SKILL.md` has a `name` equal to its directory name and a description within the limit of the Agent Skills format.

The project instructions are installed as a **managed block** in `AGENTS.md`, between the lines `<!-- engineering-harness:begin -->` and `<!-- engineering-harness:end -->`. An adapter operation creates the file with the block when it is absent, appends the block when the file has none, and otherwise replaces the content of the block. Everything outside the block belongs to the project and is never read or changed. A file with two blocks or an unterminated block is `ADAPTER_FILE_CONFLICT`.

The managed block owns its separator: installing the block into a file and removing it again leaves the file byte-identical to what the project wrote.

## 69.4 Launcher

`harness` (POSIX shell) and `harness.cmd` (Windows) at the project root pass their arguments unchanged to the core, which they locate in this order: the `ENGINEERING_HARNESS_CORE` environment variable; `harness-core` in the parent directory of the launcher's own location; `harness-core` on the search path. When none exists they exit with status 64, except for `adapter_guard`, where they exit with status 0. For `adapter_guard` they also turn any exit status of the core other than 0 and 2 (a core that crashes or cannot start) into 0. Before starting the core they set `ENGINEERING_HARNESS_PROJECT_ROOT` to their own directory. They contain no other logic.

Every command text invokes the core as `./harness` from the project root. A hook registration invokes the launcher by a path resolved from the project root and not from the session's working directory, by the means its agent documents. The `claude-code` registration must also work when another agent runs it (`AGENT-SURFACES.md`, finding 1): it resolves the launcher from `CLAUDE_PROJECT_DIR` when that is set and otherwise from the Git root, and it exits with status 0 when it finds no launcher. No adapter file, and no agent settings file, names the location of the core.

For Codex and Copilot the project root must be the Git root, because their hook registrations resolve the launcher from it.

## 69.5 Installation

`init --adapters <list>` installs any subset, including none. `adapter_add` and `adapter_remove` change the set on an existing project, and `adapter_sync` reinstalls the files of the installed set from the governing release. These commands:

- write only overlay files, the managed block and `.engineering-harness-adapters`;
- install a file that several adapters share once and remove it with the last adapter that declares it;
- refuse to overwrite a file that exists and is not byte-identical to the overlay file (`ADAPTER_FILE_CONFLICT`) unless the operator asks for replacement, and then list every file replaced;
- never write a file under a governed directory.

Adapter operations never write under a governed directory or a project-owned directory (`ai`, `architecture`, `baselines`, `engineering`, `evidence`, `project-pack`, `spec`, `work`, `src`, `tests`, `infra`), nor onto a provenance file.

`--adapters none` and `--adapters ''` both mean the empty set at `init`. `adapter_add` or `adapter_remove` that names no adapter is a usage error (exit 64). `init` for v0.4.0 with neither `--adapter` nor `--adapters` installs `claude-code`. `adapter_add` of an installed adapter changes nothing and says so.

The next steps `init` prints for a v0.4.0 project follow the installed adapter set, tell the operator to enrol a signing key before the first gate, and show the decision command with `--key`.

Because adapter files are outside every fingerprint, subject and candidate, these commands change no digest and no lifecycle conclusion.

## 69.6 Verification

`check_adapters` compares every overlay file of every installed adapter, and the managed block, with the release and reports `ADAPTER_FILE_MISSING` and `ADAPTER_FILE_MODIFIED`. `inspect_project` and `check_maintenance` carry the same findings as warnings.

## 69.7 Enforcement per adapter

Each adapter ships the strongest repository-committed controls its agent documents, for shell commands and for its file-writing tools, and its contract states what they do and do not do:

| Adapter | Shipped controls | What they do |
| --- | --- | --- |
| `claude-code` | `permissions.deny` for the guarded command names and for file tools on reserved paths; a `PreToolUse` hook that runs `adapter_guard` | Block. Deny rules hold in every permission mode and cannot be overridden by local settings |
| `codex` | `forbidden` prefix rules for the guarded command names; a `PreToolUse` hook that runs `adapter_guard` | Block, once the operator has trusted the project's `.codex/` layer and reviewed the hook. A hook that fails to run lets the call through |
| `copilot` | a `preToolUse` hook that runs `adapter_guard` | Blocks in Copilot CLI once the folder is trusted, and not in prompt mode unless the operator opts in. In VS Code hooks are a preview feature |

Every one of these matches command text or tool arguments. None is a security boundary, and none sees a file written by a shell command. The guard of Section 68.2 applies whatever the agent does.

---

# 70. Adapter commands

## 70.1 Common rules

Every adapter exposes `bootstrap`, `execute` and `maintain`, each with a `status` form that writes nothing. A command:

- invokes the core only through the launcher, from the project root, and passes `--adapter` with the agent's own identifier;
- performs only the next action, or a permitted operation whose actor is `adapter`;
- never invokes a reserved operation or an operator command;
- never writes under a reserved path;
- stops at `HUMAN_INPUT`, `HUMAN_DECISION`, `REWORK`, `BLOCKED`, `INVALID` and `ERROR`, and presents the issue codes and the next action exactly.
- takes the next step from `next_action` and `permitted_operations` of the result document and never from the exit status: a non-zero exit status of a read operation is not a failure of the command, and whether an operation wrote is read from `evidence`.

An interrupted authoring step leaves nothing to hand over: the next session restarts that step from the next action.

## 70.2 `bootstrap`

`bootstrap status` renders `inspect_project`. In the bootstrap regime `bootstrap` performs the next action: it completes the Pack from the operator's brief while the state is `PROJECT_INPUT_REQUIRED`; it authors the input of `ingest_specification`, `derive_architecture` and `generate_work_items` from the Pack's sources and the baselined predecessor and hands it to the core; it invokes the deterministic operations; and it stops at each gate, where it presents the gate, the candidate digest and the decision command for the operator. At `REWORK` it stops and presents the issues; `bootstrap rework <instruction>` then authors a corrected artefact set and calls the authoring operation the core lists as permitted. In the maintenance regime it reports status and refers the operator to `maintain` and `execute`.

## 70.3 `execute`

`execute status` renders `list_tasks`. `execute [TASK-id]` calls `select_task`, then `start_task`, implements the Work Item inside its repository scope, runs the repository's check for each verification control where one exists, and calls `complete_task`, or `block_task` when it cannot finish. When it stops before completion it calls `record_task_progress` with a hand-over note and the paths changed so far. It holds no selection rule, no transition rule and no state format of its own.

## 70.4 `maintain`

`maintain status` renders `check_maintenance`. `maintain <statement>` records the operator's statement with `open_change`: the adapter proposes the kind, and the reach only when the statement requires one wider than the default, and asks the operator when the statement does not decide them. `maintain` without a statement continues the revision in progress: it performs the next action, authoring a revised artefact set from the existing one (Section 63.5), and stops at the gate, where it presents the change record, the candidate digest and the delta. For a change record that lists Work Items to re-execute it calls `reopen_task` for each. It never executes a Work Item; that is `execute`.

Four further forms use permitted operations. When the next action is an authoring operation and the change record requires no change to that chain, `maintain` invokes the `validate_<x>` the core lists as permitted instead, and says so. At `REWORK` `maintain` stops and presents the issues; `maintain rework <instruction>` then authors a corrected artefact set and calls the authoring operation the core lists as permitted. `maintain abandon <CHG-id>` calls `abandon_change`. `maintain register <statement>` registers a change made outside a run (Section 66.2): it establishes the changed paths from the commits or paths the operator names, proposes the kind and the finished Work Items the change touches for the operator to confirm, calls `open_change` with origin `registered`, and presents the `record_change_decision` command for the operator. Each is an operation the operator asked for through the command (Section 40), and the adapter performs it only when the core's current result lists it.

---

# 71. Release definition and workflows

## 71.1 Workflows

`workflows/maintenance.yaml` (`workflow://maintenance`) defines the change kinds with their minimum and default reach, the chains of each reach, and the gates `gate://task-disposition` and `gate://registered-change`. `workflows/execution.yaml` (`workflow://execution`) defines the run statuses, the event types and the permitted transitions between them. The content of the bootstrap workflow is unchanged. The two gates are added under `gates/`.

## 71.2 Controls

No control is added to or removed from the release or from any profile, and the files under `controls/`, `profiles/` and `technologies/` are byte-identical to v0.3.0. The engineering-resolution digest of every v0.3.0 project is therefore unchanged. The behaviour of `control://validation/work-graph` is extended as Section 32 states, and only for content v0.3.0 could not express. This is why adoption re-runs the controls on every baselined subject (Section 67.3).

## 71.3 Core contract

The release definition declares `core_contract: 2` and names its workflows, its adapter manifest and `adoptable_from`. A core implements one or more core contracts and resolves a release only when it implements the one the release declares. The v0.3.0 core predates this rule, so the v0.4.0 release definition is written so that the v0.3.0 core's own resolution fails: it does not carry the `bootstrap_workflow` key that the v0.3.0 core requires. A v0.3.0 core that is pointed at a project governed by v0.4.0 therefore reports `PROV_UNSUPPORTED` and writes nothing.

---

# 72. v0.3.0 projects

## 72.1 Reading

A v0.4.0 core implements core contracts 1 and 2. It operates a project governed by v0.3.0 with v0.3.0 semantics: the bootstrap rows of Section 37 in every state, the single adapter marker, the legacy state grammar and, for the operations v0.3.0 defines, the v0.3.0 result schema.

Every operation, read or writing, that v0.3.0 does not define (`check_maintenance`, `check_adapters`, `check_signers`, `list_tasks`, `select_task`, `open_change`, `abandon_change`, the five task operations, `record_task_decision`, `record_change_decision`, `enrol_signer`, `revoke_signer`, the adapter commands) is refused on a project governed by v0.3.0 (core contract 1) with outcome `ERROR`, issue `PROV_UNSUPPORTED` (message: the operation needs a project governed by v0.4.0; adopt the release first), exit 5, and writes nothing. Its result document conforms to the v0.4.0 result schema and carries only `schema_version`, `operation`, `outcome`, `provenance` and `issues`. A distribution command (`init`, `render_adapters`, `adapter_add`, `adapter_remove`, `adapter_sync`, `trust_signers`) keeps its own result document and, on a project governed by v0.3.0, answers with code `PROV_UNSUPPORTED`, exit 5, nothing written. `check_adapters` and `check_signers` are read operations and follow the first rule in full. `adopt_release` is the one v0.4.0 command that is meant for a project governed by v0.3.0 and is exempt.

It offers none of the operations of Sections 62 to 66 there. The guard of Section 68.2 applies.

## 72.2 Adopting

Section 67. For a project at `EXECUTION_READY` the result is `EXECUTION_READY` under v0.4.0 with the same three baselines current, the same Project AI Policy, the legacy state files untouched, one adoption record added and the adapter files of v0.4.0 in place of those of v0.3.0. After adoption the project must be operated with a v0.4.0 core; a v0.3.0 core refuses it (Section 71.3).

## 72.3 Acceptance scenario

On a clone of a v0.3.0 project that is `EXECUTION_READY` with fifteen of sixteen Work Items done:

1. `adopt_release` with all three adapters succeeds; the project is `EXECUTION_READY`; no decision was recorded. The adoption record is signed by the operator and the signer anchor is written; the three baselines are reported as resting on declared approvals.
2. Through `maintain` a change record of kind `defect` is opened and one Work Item is added. At `gate://work-baseline` the candidate reports sixteen `task` items unchanged and one added. The `engineering` authority approves with a signature.
3. `baseline_work` establishes the Work Baseline that supersedes the first one. The fifteen Work Items are `done`. The sixteenth is `deferred` by a decision of the `engineering` authority, and its acceptance criteria are reported as open.
4. The added Work Item is started through one adapter, continued through a second and completed through a third. Its run is hand-over equivalent (Section 64.7) to the run of the same Work Item made through one adapter on a second clone, every event names the adapter that made it, and no file outside the Work Item's scope and `work/state/` was needed or changed by the hand-over.

---

# 73. Signed records

## 73.1 Rule

In a project governed by v0.4.0 the following records are valid only with a signature by an enrolled key. They are the **signed records**:

| Record | Directory | Signed by |
| --- | --- | --- |
| Decision on a baseline candidate | `evidence/approvals/` | the approver |
| Subject decision (task disposition, registered change) | `evidence/decisions/` | the approver |
| Adoption record | `evidence/adoptions/` | the operator who adopts |
| Signer record | `evidence/signers/` | 73.4 |

The single exception is a decision that an adoption record carries with declared assurance (Sections 22 and 67.4). Change records, closures, validation evidence, candidates, baselines and runs are not signed: none of them states a human decision, and each takes effect only through a signed one.

## 73.2 Signature

A signature is an OpenSSH signature (the `SSHSIG` format that `ssh-keygen -Y sign` writes), armoured, stored beside its record as `<record file name>.sig`.

- The namespace is `engineering-harness`.
- The signed message is the record's self digest as ASCII text: `sha256:` followed by 64 lowercase hexadecimal digits, 71 bytes, no line terminator. The digest covers the record, so the signature covers the record.
- The hash algorithm is `sha512` or `sha256`.
- Accepted key types: `ssh-ed25519`, `ecdsa-sha2-nistp256`, `ecdsa-sha2-nistp384`, `ecdsa-sha2-nistp521`, `ssh-rsa` keys of at least 2048 bits signing with `rsa-sha2-256` or `rsa-sha2-512`, and the hardware-backed `sk-ssh-ed25519@openssh.com` and `sk-ecdsa-sha2-nistp256@openssh.com`. Certificates are not accepted.

A hardware-key (`sk-`) signature without the user-present flag is refused: on read `APPROVAL_SIGNATURE_INVALID`, in a signer record a chain fault, when writing `GUARD_SIGNING_FAILED`.

Inside its digest the record names who signed it: the identity; the key, by type and SHA-256 fingerprint; and the signer record that was the head of the signer chain when the record was written, by ID and digest. A decision record carries these in `identity_assurance` with `mechanism: ssh-signature` and `level: signed`.

## 73.3 Verification

The core verifies signatures in process, on every derivation, without starting another program. A signed record verifies when all of these hold:

1. the signature file exists and parses, and its namespace is `engineering-harness` (`APPROVAL_SIGNATURE_MISSING`, `APPROVAL_SIGNATURE_INVALID`);
2. the public key in the signature has the type and fingerprint the record names, and the signature verifies over the record's self digest (`APPROVAL_SIGNATURE_INVALID`);
3. the signer chain is valid (73.4) and holds the signer record the record names;
4. at that signer record the key is enrolled for the identity the record names and is not revoked; and if a later signer record revokes the key, that record lists this one as retained (`APPROVAL_SIGNER_NOT_ENROLLED`);
5. for a decision, the identity is the one the Project Engineering Pack assigns to the authority of the gate (BRS 1.2, unchanged).

A signed record whose signer record is not in the chain, or whose named digest differs, is `APPROVAL_SIGNER_NOT_ENROLLED`. Item 5 is applied on read to subject decisions: after the Pack assigns the authority to another identity, earlier dispositions by the former identity have no effect and are reported until removed. A baseline's historical validity never re-checks the identity.

A decision record that fails is an invalid decision record, with the consequences BRS 1.2 gives one: it satisfies no gate, and its candidate is blocked until the record is removed. A subject decision that fails has no effect (Section 65.1). An adoption record that fails satisfies nothing (Section 67.4).

Anyone can repeat the check with stock OpenSSH. `check_signers --allowed-signers` prints the chain as an OpenSSH allowed-signers file, and

```text
ssh-keygen -Y verify -f <allowed signers> -I <identity> -n engineering-harness -s <record>.yaml.sig
```

with the record's digest on standard input gives the same answer for a key that is not revoked.

## 73.4 Signer chain

A signer record is stored as `evidence/signers/SGN-<nnnn>.yaml` and contains: its ID; the action, `enrol` or `revoke`; the identity; the key, by type, public key and fingerprint; the previous signer record, by ID, path and digest; who signed it, by identity and key; the timestamp and how it was captured; and its self digest. A `revoke` record also gives the reason and the retained records: every signed record made with that key that verifies at the moment of revocation, by ID, path and digest.

- The first record is the **anchor**. It has no previous record, its action is `enrol`, and it is signed with the key it enrols, which proves that whoever enrolled the key holds it.
- Every later record names the record before it and is signed with a key that is enrolled and not revoked at that point. Records therefore form one chain, and its order is the order of enrolment and revocation.
- The identity of an `enrol` record shall hold at least one authority in the Project Engineering Pack when it is written (`SIGNER_IDENTITY_UNKNOWN`). The Pack still decides which identity holds which authority; the chain only says which keys speak for an identity.
- A key is enrolled at most once in the life of the chain, for one identity (`SIGNER_KEY_INVALID`).
- A revocation may be signed with any enrolled key, including the one it revokes. The last enrolled key cannot be revoked (`SIGNER_LAST_KEY`).

A validly signed revocation that leaves no enrolled key is not a chain fault; only the operation refuses it (`SIGNER_LAST_KEY`).

A record that does not reproduce its digest, a missing previous record, two records that name the same previous record, an anchor not signed by its own key, or a later record not signed by an enrolled key is `SIGNER_CHAIN_INVALID`. The chain is then invalid as a whole: no signed record verifies, the project is blocked with `resolve_blocker` (Section 37, row 1) and execution is prohibited, until the chain reproduces again.

v0.4.0 defines no way to continue a chain once every enrolled key is lost. Each project should enrol a second key that is kept apart from the first; `check_signers` and `inspect_project` warn while only one key is enrolled, and while an identity that holds an authority has none.

## 73.5 Operations

- `enrol_signer` takes the identity and the public key file. On a project without a chain it writes the anchor and must be signed with the key it enrols. Otherwise it is signed with a key already enrolled.
- `revoke_signer` takes the fingerprint and the reason. The core computes the retained records and shows them to the operator before the signature is made.
- `check_signers` is read-only. It reports the anchor, every key with its identity and status, the faults of the chain and the warnings above, and prints the allowed-signers file on request.
- `trust_signers` records, on this machine, that the operator accepts the project's anchor (73.7).

`enrol_signer`, `revoke_signer` and `trust_signers` are operator commands (Section 68.2). They are permitted in either regime, whenever the release resolves and the Project Engineering Pack is valid.

`enrol_signer` and `revoke_signer` stay permitted and listed under a change record fault; `revoke_signer` is listed only with two or more enrolled keys. `check_signers` warns for an authority identity of the Pack that has no enrolled key.

## 73.6 Signing

The core never reads, stores or passes on a private key or a passphrase.

The CLI obtains a signature by starting `ssh-keygen -Y sign -n engineering-harness -f <key>` with the record's digest on its standard input. `<key>` is the path the operator gives with `--key` or in `ENGINEERING_HARNESS_SIGNING_KEY`: a private key file, or a public key file whose private part is held by an SSH agent or a hardware token. Passphrase entry, agent confirmation and touch happen between the operator and OpenSSH, on the operator's terminal. The CLI then verifies the signature as 73.3 and writes the record and its signature file together, the signature file first; a signature by a key that is not enrolled for the required identity writes nothing (`SIGNER_NOT_ENROLLED`). When OpenSSH is not installed or returns no signature the command fails with `GUARD_SIGNING_FAILED`.

Before it signs, the CLI asks OpenSSH whether a private key file opens with an empty passphrase. If it does and the key is not hardware-backed, the command fails with `GUARD_KEY_UNPROTECTED`: any process of the operator's user could have made that signature.

The library interface obtains the signature from a function its caller supplies and verifies it in the same way.

`--key <path>` (or `ENGINEERING_HARNESS_SIGNING_KEY`) names a private key file whose public key is in `<path>.pub`, or a `.pub` file itself (private half in an SSH agent or token). The CLI reads only the `.pub` file. When there is none it exits 64 and tells the operator to create it with `ssh-keygen -y -f <key> > <key>.pub`. The key type and fingerprint from that file go into the record before its digest is computed; a signature made by another key writes nothing (`SIGNER_NOT_ENROLLED`).

For a decision, `--approver <identity>` is the approver and must be the identity the key is enrolled for. For `enrol_signer`, `revoke_signer` and `adopt_release` the signer's identity is the one the signing key is enrolled for; when the command writes the anchor it is `--identity`.

## 73.7 Accepting the anchor on a machine

The CLI keeps, per user and outside every project, the anchor it has been told to accept for each project root: a file under the user's configuration directory, or the file named by `ENGINEERING_HARNESS_TRUST_FILE`. It holds the project root path, the anchor's ID and digest and the anchor key's fingerprint.

- The command that writes an anchor records it as accepted only when this machine has accepted no other anchor for that project root; otherwise the mutation stands, the operator is told on standard error (the result document does not carry it), and `trust_signers` is needed.
- On a project whose anchor is not yet accepted on this machine, a reserved operation or operator command first shows the anchor (identity, key type, fingerprint, date) and asks the operator to type the last eight characters of the fingerprint. A wrong answer is `GUARD_ANCHOR_UNTRUSTED`.
- When the project's anchor differs from the accepted one the command is refused with `GUARD_ANCHOR_CHANGED` and names both. Only `trust_signers`, after the same confirmation, replaces the accepted anchor.

Beside the anchor, the trust file records for each project root the last signer-chain head this machine has seen (ID and digest). Condition 4 of Section 68.2 also requires that the project's chain still contains that record with that digest; otherwise `GUARD_ANCHOR_CHANGED` (the chain was rewritten). After every guarded command that passes condition 4, and after a command that writes a signer record, the pinned head is advanced to the current head. `trust_signers` resets both. A trust file that cannot be located, read, parsed or written is `GUARD_ANCHOR_UNTRUSTED`.

This is a check of the CLI on the operator's machine, like the terminal confirmation. No derived state depends on it, and a project is valid or invalid without it.

## 73.8 Reporting

`inspect_project`, `check_maintenance` and `check_signers` report, for each baseline, whether the approval it rests on is `signed` or `declared`, and for the project the anchor, the number of enrolled keys and the warnings of 73.4. A baseline that rests on a declared approval is as valid as BRS 1.2 made it and no more; a signed baseline whose upstream baseline rests on a declared approval is reported as such.

---

# Appendix A — Definitive Contract-Test Scenarios

The scenarios below are normative and are also supplied as `annexes/contract-tests.md`.

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
