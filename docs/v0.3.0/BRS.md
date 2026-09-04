# Engineering Harness v0.3.0

# Deterministic Harness Core — Business Requirements Specification

**Version:** 1.1
**Status:** Development Handover — Normative
**Release:** Engineering Harness v0.3.0

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
- automatic Harness-version migration;
- profile inheritance;
- multiple-profile composition;
- broad enterprise standards catalogue;
- semantic interpretation of business requirements;
- deterministic assessment of architectural appropriateness;
- automatic human approval;
- approval-requiring project overrides;
- executable security-exception control/gate flow;
- production deployment;
- production release implementation; or
- the complete Engineering Work Item execution engine.

---

# 7. Clean project contract

A freshly initialised project must contain structure and provenance but no fabricated lifecycle state.

The expected project shape is:

```text
project/
├── .engineering-harness-template
├── .engineering-harness-adapter
├── CLAUDE.md / adapter files where installed
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
├── src/
├── tests/
└── infra/

```

A fresh project must not contain:

- approved Specification Baseline;
- approved Architecture Baseline;
- approved Work Baseline;
- generated Project AI Policy;
- generated Work Items;
- execution graph;
- task runtime state;
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
| `/work/state/**`             | Runtime                   | Runtime only                                                |
| `/baselines/**`              | Harness                   | Append-only                                                 |
| `/evidence/validation/**`    | Harness                   | Append-only                                                 |
| `/evidence/candidates/**`    | Harness                   | Append-only                                                 |
| `/evidence/approvals/**`     | Harness                   | Append-only                                                 |
| other `/evidence/**`         | Harness/toolchain/runtime | As contract permits                                         |
| `/src`, `/tests`, `/infra`   | Engineering execution     | Outside bootstrap mutation except authorised Work execution |

A caller may never broaden these write permissions.

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

Every governed YAML document shall contain:

```yaml
schema_version: 1
```

Schema references resolve only from the recorded Harness release. `schema://result/operation/v1` is the public machine contract consumed by CLI, CI and adapters; prose renderings are non-normative.

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
.engineering-harness-adapter
engineering/harness.yaml

```

where applicable.

## FR-031 — Recorded release

The project shall remain governed by its recorded Harness release.

A newer available release shall not silently replace it.

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

## FR-034 — Harness-root configuration precedence

The deterministic core accepts only its explicit `harness_root` argument. Presentation layers may obtain that argument using this precedence:

```text
1. explicit caller/CLI/adapter parameter
2. ENGINEERING_HARNESS_ROOT environment variable
3. no value → usage/configuration failure; do not inspect or download
```

No other implicit registry is permitted in v0.3.0.

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
| Any generated issue list included in a content-addressed object | `code`, `location` (empty last), `message` ascending |

All other arrays are order-significant and are preserved. An implementation shall not invent additional sorting.

## 16.5 Paths

Governed repository-path fields must already satisfy the canonical repository-path contract before serialisation. No platform-specific path separator conversion occurs after schema/semantic path validation.

## 16.6 Self-digest exclusion

Only the exact self-digest field declared by the object's version-1 schema is omitted from its hash preimage. Nested and upstream digests remain included. The authoritative exclusion paths are listed in the canonicalisation annex and vectors.

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
- digest algorithm;
- canonicalisation version; and
- candidate digest.

Candidate digest excludes only its own self-digest field.

A persisted candidate must contain enough information to reproduce its digest without relying on historical versions of current project files.

No `AWAITING_*_APPROVAL` state may exist without a valid persisted candidate.

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

For v0.3.0:

```text
identity_assurance.mechanism = declared-project-identity
identity_assurance.level = declared

```

This means the recorded approver identity matches the identity assigned to the required authority in the Project Engineering Pack.

It does not claim cryptographic authentication.

Caller-supplied timestamps are non-authoritative.

Silence is not approval.

Previous unrelated agreement is not approval.

AI-generated approval is not approval.

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

A historically valid baseline may become stale.

Staleness does not retroactively invalidate its historical approval.

A superseded baseline can never become current again.

An unsuperseded stale baseline becomes current again if all complete approved bindings later match current facts exactly.

No separate edit-history ledger is required in v0.3.0.

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
- human-gate references.

A requirement/acceptance criterion requiring implementation coverage must be covered by at least one Work Item.

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

resolve_blocker
none_bootstrap_complete

```

There shall be at most one authoritative next bootstrap action.

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
2. reread and reconcile `.engineering-harness-template` and `.engineering-harness-adapter`;
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
- issues.

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

Any stale, invalid, missing or indeterminate required prerequisite prohibits execution.

`EXECUTION_READY` does not execute a Work Item.

No executable security-exception gate is part of the v0.3.0 vertical slice. The readiness calculation therefore shall not invent or query security-exception evidence unless a later contract version explicitly introduces that control.

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

```

Creation shall use exclusive-create semantics.

If a target already exists:

```text
RECORD_ALREADY_EXISTS

```

The core shall never overwrite an existing authoritative record.

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

A public operation with no issues uses the outcome implied by the requested engineering fact: e.g. a healthy but incomplete fresh project is `INCOMPLETE`, while a successful diagnostic check with all applicable prerequisites satisfied is `OK`.

---

# 49. CLI contract

The CLI shall be a thin wrapper around the same core used by CI and adapters.

Every command that inspects or mutates a project must supply the core with explicit `project_root` and `harness_root` values. The CLI resolves `harness_root` using exactly this precedence:

```text
1. --harness-root <path>
2. ENGINEERING_HARNESS_ROOT
3. absent → exit 64 usage/configuration error
```

There is no implicit current-directory, parent-directory, home-directory or network registry fallback. The resolved absolute/local registry path is passed to the core as an explicit argument; the core does not read the environment.

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

For every supported state/condition the core shall return at most one authoritative bootstrap next action.

## AC-027 — Rejection transition

Rejected Specification, Architecture or Work candidates shall return lifecycle to the corresponding rework state while preserving rejection evidence.

## AC-028 — Execution readiness

A current Work Baseline with any failed readiness prerequisite shall not produce `EXECUTION_READY`.

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

## AC-039 — Explicit Harness root

The core shall not inspect or mutate without an explicit `harness_root`. The CLI shall use only `--harness-root`, then `ENGINEERING_HARNESS_ROOT`, otherwise exit 64.

## AC-040 — Provenance grammar

The two distribution provenance files shall parse only according to FR-033. Unknown/missing/duplicate keys or malformed canonical paths shall produce `PROV_INCONSISTENT`.

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
| CT-137 Explicit Harness root required                   | AC-039                                             |
| CT-138 NFC-normalised key collision                     | AC-009                                             |

---

# 54. Additional contract-test coverage

Appendix A is the single definitive contract-test set. It incorporates CT-001–CT-113, CT-120–CT-131 and the additional closure tests CT-132–CT-138. No duplicate or earlier test wording is normative.

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
| End-to-end solution                 | AC-036                 |

---

# 56. Test requirements

The implementation shall include:

## Unit tests

For:

- path validation;
- restricted YAML/JSON parsing and NFC key-collision detection;
- distribution-provenance grammar parsing;
- explicit Harness-root and release resolution;
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
24. execution is prohibited whenever a required prerequisite is stale, invalid, missing or blocked;
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

the implementation team shall raise a contract change.

It shall not silently invent alternative behaviour in code.

---

## 60.1 Normative annex files

The following package files are part of this BRS and mandatory for implementation/conformance:

```text
schemas/schema-catalog.json
schemas/*.schema.json
annexes/canonicalisation-harness-v1.md
annexes/canonicalisation-vectors.json
annexes/contract-tests.md
```

The same definitive contract tests are also reproduced in Appendix A below so the BRS remains readable as one document. The schema files remain separate because they are executable contracts rather than prose examples.

# 61. Final implementation rule

> **Implement the Harness contracts; do not reinterpret them.**

The repository and recorded Harness release must contain enough authoritative evidence to reconstruct the current engineering state without an AI model, conversational history or inferred human approval.

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

