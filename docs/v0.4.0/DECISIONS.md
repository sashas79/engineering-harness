# Engineering Harness v0.4.0 — decisions needed

**Status:** D-01 to D-18 decided by the owner on 2026-11-13 (Section 0). `BRS-CHANGES.md` is written with the chosen option of every decision; the marker **[D-nn]** shows where each one lands. Section 4 holds what the choice of D-06 option (c) added after the approval: three points where it meets D-07 and D-08, and five further decisions, each built in the way recommended there and each open to change.

## 0. Record of the approval (2026-11-13)

| Decision | Outcome |
| --- | --- |
| D-01 to D-05, D-07, D-08, D-10 to D-14, D-17, D-18 | Recommended option accepted as written |
| D-06 | **Option (c)**: cryptographically signed human decisions, preferably standard SSH signatures. Private signing keys must remain inaccessible to agents. Existing valid v0.3.0 approvals may retain their declared assurance under D-07 adoption; new v0.4.0 decisions must be signed. Any conflict with D-07 is to be flagged, not resolved by assumption |
| D-09 | Option (a). Acceptance order: Claude Code CLI (the coding agent operates), Codex CLI (the owner operates), GitHub Copilot CLI (the owner operates). Each must pass independently against the same Harness contract |
| D-15 | Option (a). The core checkout may be modified in Stage 2 and its dependencies reinstalled for arm64 |
| D-16 | Confirmed. Fixture tests may simulate human decisions with fixture identities. On mentor clones every human decision and every `adopt_release` is reserved for the owner |

## 1. Where the brief and the BRS disagree

You asked to be told before I choose. In every row the brief asks for something BRS 1.2 forbids or does not allow for. My proposal in each case is to change the BRS as shown; none is applied until you approve.

| # | BRS 1.2 says | The brief asks | Proposed resolution |
| --- | --- | --- | --- |
| 1 | "Work Item execution … is performed by the adapter command `/execute`, never by a core operation." "Runtime state … is never read by the core." (FR-036, Sections 6.2, 8, 43) | Selection, transitions and state writes move into core operations | Section 64. The core records and validates state; it still executes nothing |
| 2 | "automatic Harness-version migration" is out of scope; every candidate binds the Harness release, and a baseline is current only while "all required governing/upstream state remains current" (Sections 6.2, 21, 29) | A v0.3.0 project adopts v0.4.0 without re-approval | Not possible under BRS 1.2 as written: I confirmed on a scratch copy that changing only the recorded version makes all three baselines stale and sends the project back to `validate_specification`. It becomes possible with one new rule, the release binding through adoption (Section 29) and Section 67. This changes a candidate binding rule, which Section 60 reserves for a contract change. **D-07, D-08** |
| 3 | "There shall be at most one authoritative next bootstrap action"; at `EXECUTION_READY` it is `none_bootstrap_complete`; the adapter performs only the next action (Sections 37, 40) | A revision starts at `EXECUTION_READY`, and nothing depends on an operation the core did not offer | A normative permitted-operation set beside the single next action (Section 40) |
| 4 | "Work artefacts/graph changed → Work stale", and anything stale prohibits execution (Sections 30, 43) | Decide whether untouched tasks keep executing | **D-03** |
| 5 | A Work Item contains requirement and acceptance references; the schema requires at least one of each (Section 32) | Decide whether a maintenance task may reference its change record instead | **D-02** |
| 6 | `.engineering-harness-adapter` contains "exactly" one adapter (FR-033) | Three adapters side by side | A second file with its own grammar, `.engineering-harness-adapters` (FR-033 as amended) |
| 7 | Init substitutes `{{harness_core}}` into adapter files; Claude Code's settings hold `ENGINEERING_HARNESS_CORE` (FR-035) | The core's location must not live in one agent's settings file | The launcher. **D-14** |
| 8 | Identity assurance is "declared"; nothing in the core distinguishes a human from an agent (Section 22) | Where an agent offers no enforcement, a guard in the core or a stated residual risk | Section 68. **D-06** |
| 9 | `/src`, `/tests`, `/infra` are "outside bootstrap mutation except authorised Work execution" (Section 8) | Decide whether a change made outside a task can be registered | **D-04** |

Three findings are not disagreements with the brief but you should know them before approving:

- **This repository carries BRS 1.1. The core implements BRS 1.2**, which adds FR-034 to FR-036, CT-139 and CT-140 and lives only in the core repository (`engineering-harness-cli`). **D-01.**
- **v0.3.0's statement that Copilot "can never run" the decision commands is wrong.** The VS Code setting it relies on asks for confirmation and does not block (`AGENT-SURFACES.md`, finding 4).
- **A v0.3.0 core does not refuse a project it does not understand.** Pointed at a project governed by a later release it would resolve that release, call every baseline stale and accept lifecycle operations. **D-18.**

## 2. Decisions

### D-01 — Which BRS is the base

**Found.** `docs/v0.3.0/BRS.md` here is version 1.1. The core repository's `BRS.md` is 1.2 and is what the released binary implements. The core's own manifest guard is failing because `BRS.md` was edited after the manifest was written (one test of 339 fails; the other 337 pass, one is skipped).

**Options.** (a) Base v0.4.0 on 1.2 and publish BRS 2.0 here as `docs/v0.4.0/BRS.md`, mirrored to the core repository with a fresh manifest. (b) Treat 1.1 as authoritative and first reconcile the core to it.

**Recommend (a).** 1.2 is what v0.3.0 projects were built with. `docs/v0.3.0/BRS.md` stays as it is.

### D-02 — May a maintenance task reference its change record in place of a requirement

**Options.** (a) Yes, narrowly: `requirement_refs` and `acceptance_refs` may be empty when the task lists at least one change record of kind `documentation` or `defect` that declares an acceptance statement. Those statements are then reported open and closed with their change record, and a later revision of the task may add to its change references but not drop one. (b) Yes for every kind. (c) No: every task traces to a requirement, so a documentation task forces a specification revision. (d) Leave it: tasks borrow references, as mentor would have to.

**Recommend (a).** A borrowed reference makes the traceability record false, and no control can find that out. With (a) the approver sees at the work gate that the task has no requirement and what its change record says "done" means.

**What (a) gives up.** A task without a requirement passes only the work gate, decided by `engineering`, not the specification gate, decided by `product_domain`. Restricting it to `documentation` and `defect` keeps new behaviour out: a `follow_up` or `new_requirement` task must name a requirement. Whether a given `defect` task is really a fix and not a new requirement stays a judgement the `engineering` approver makes with the change record in front of them. The coverage rule is untouched: every requirement and criterion of the specification must still be covered by some task. Tests: CT-155, CT-171.

### D-03 — May tasks untouched by a pending revision keep executing

**Options.** (a) Yes, when the revision's reach is `work`: a task whose definition and graph entry are byte-identical in the working tree and in the Work Baseline may run; tasks the revision adds, changes or removes wait. A revision of reach `architecture` or `specification` stops everything from its first changed artefact. (b) No: all execution stops until the new Work Baseline exists, as today.

**Recommend (a).** In a work revision the Specification and Architecture Baselines, the Project AI Policy and the task's own definition are exactly what was approved, so nothing the task depends on is in question. If the revision later changes that task after all, the carry-over rule marks it for rework. An upstream revision is different: the approved basis of every task is being re-decided. Cost: `execution_permitted` can be true outside `EXECUTION_READY`. Tests: CT-167.

### D-04 — Can a change already made outside a task be registered

**Options.** (a) Yes, as a change record with origin `registered` and reach `none`, which the `engineering` authority accepts or rejects. It names the changed paths with their digests, optionally the commits, and the finished tasks it touches. Any path that is not reserved can be named. (b) No: the only route is a planned change and a new task that redoes or re-verifies the work.

**Recommend (a).** The work exists; refusing to record it keeps it invisible, which is the gap. It is told apart from work under a task in four ways: its origin is `registered`; it has no run; it carries no verification result; and the tasks it names stay `done` with a note that a registered change touched their deliverables and whether it was accepted. A rejected one stays in every report until a planned change supersedes it. Tests: CT-172.

For mentor: commit `f6e07ec` changed two files under `src/`, one under `tests/` and four under `docs/handover/`. All seven can be registered as one `defect` change naming TASK-02. The acceptance scenario instead adds a task, as you specified; both routes exist.

### D-05 — Record what a run changed, and report later changes

**Options.** (a) Runs store the raw-byte digest of every changed path at completion; `check_maintenance` reports a path whose current content matches none of the digests recorded for it by a done run or by a registered change that is not rejected. A report only. (b) Store paths without digests; no report.

**Recommend (a).** It is the only deterministic way to make a change outside a run visible without depending on Git. It costs one hash per changed file. It cannot see changes to paths no v0.4.0 run recorded, so mentor's fifteen legacy tasks are not covered. Tests: CT-173.

### D-06 — The decision guard and the risk that remains

**Found.** Per agent, what blocks today (`AGENT-SURFACES.md` Section 4): Claude Code's deny rules and hook block in every mode. Codex's rules and hook block once the operator has trusted the project's `.codex/` layer and reviewed the hook. Copilot CLI's hook blocks once the folder is trusted. Copilot in VS Code blocks only through hooks, a preview feature; its auto-approve setting only asks. All of these match command text or tool arguments, and each vendor says they are not a security boundary.

**Proposed.**

- In the core (Section 68.2): the CLI records a decision only (1) without `--adapter`, (2) with no agent session marker in the environment, (3) on a controlling terminal, read from the terminal device and never from standard input, (4) after the operator typed the last eight characters of the subject's digest.
- In each adapter (Sections 68.3, 69.7): a pre-tool hook that runs the core's `adapter_guard`, which denies a shell command naming a decision operation and denies the agent's file-writing tools on the evidence directories; plus Claude Code deny rules and Codex forbidden rules for the same. For Copilot's file tools this is not yet effective: its documentation does not say which argument carries the target path (`AGENT-SURFACES.md` Section 7).

**Residual risk.** Two routes remain for an agent that sets out to evade this, on any of the three agents:

1. **Typing the confirmation.** An agent on a surface that gives its commands a terminal and sets no marker can answer the prompt. That is Copilot (no marker documented) and Codex if its undocumented marker is absent.
2. **Writing the record as a file.** A decision record is a YAML file with a digest. An agent that computes the digest and writes the file with a shell command produces a record the core accepts. No guard on command names or file tools sees it.

Either is a deliberate act against explicit instructions, a hook and a prompt, not a slip. But the resulting record is indistinguishable from yours, so identity assurance stays "declared". Instructions are the only barrier against route 2, which is what you said is not enough.

**Options.** (a) Accept this for v0.4.0 with the controls above. (b) Add now a secret only the approver knows: a passphrase verifier per authority, entered on the terminal and bound into the record. It closes route 1 and, if the record carries a keyed value, route 2. It needs set-up per approver, a recovery procedure, and a home for the verifier that an agent cannot rewrite; if that home is the Project Pack, adding it changes the Pack fingerprint and forces re-approval of mentor's baselines. (c) Add now signed decisions (SSH or hardware key): the real fix for both routes, the larger change, and the same question of where the public keys live.

**Recommend (a)** for v0.4.0 and (c) as the subject of the next release, designed so that the keys sit outside the fingerprinted Pack files. I would not start (b): it is a weaker version of (c) with most of its cost. If route 2 is not acceptable to you even for one release, choose (c) now and I will add it to this design before Stage 2.

**Decided: (c).** The design is BRS Section 73, with the guard of Section 68.2 kept around it. Both routes above are closed: a typed confirmation and a hand-written record are worth nothing without a signature by an enrolled key. What remains, and where the choice meets D-07 and D-08, is in Section 4.

### D-07 — Adoption keeps baselines current only when the controls are unchanged

**Found.** The engineering-resolution digest covers the effective control set and nothing else. I confirmed on a scratch copy of mentor that a release with identical controls yields the same digest (`sha256:d17c01e4…`), and that the Harness version bound into every validation subject is the one thing that makes the baselines stale.

**Proposed.** A candidate's release binding is satisfied through an adoption record when the adoption is control-equivalent: same resolution digest, and the new release's validation controls pass on every baselined subject. Only candidates the adoption record lists are covered. v0.4.0 adds or removes no control. An adoption that is not control-equivalent is refused.

**What it gives up.** v0.4.0 cannot add a control. In particular the source-coverage control proposed in the core repository's `MAINTENANCE-PLAN.md` does not ship: it would change the digest of every project and force full re-approval on adoption. And a later release that does change the controls cannot be adopted by this rule; that release must define what happens to stale baselines.

**Options.** (a) As proposed. (b) Also allow adoption that leaves baselines stale, to be re-validated and re-approved. (c) Ship the source-coverage control and accept re-approval of every adopting project.

**Recommend (a).** It is the only option that meets "without re-approval where content is unchanged". (b) can be added when a release needs it. Tests: CT-174 to CT-178.

### D-08 — Adoption is an operator command, not a human decision

**Options.** (a) `adopt_release` is run by the operator and recorded in an adoption record without an approver. The CLI refuses it with `--adapter`, with an agent session marker set, and without a controlling terminal; every adapter's hook and deny rules cover it. (b) It requires a decision by the `engineering` authority, with the full guard including the typed confirmation.

**Recommend (a).** The adoption record holds the proof that nothing approved changed, so there is nothing to judge. The marker check stops Claude Code and Codex; for Copilot, which sets no documented marker, the barrier is the hook and the terminal requirement, as for decisions.

Consequences for Stage 2: I run inside Claude Code, so the CLI refuses `adopt_release` from me. On the acceptance clone you run it (one command). In automated tests the library call is used.

`adopt_release` replaces the v0.3.0 adapter files the project was initialised with. It recognises them by content, because a v0.3.0 project does not record the core command that was written into them. A file you edited since is not overwritten: the adoption stops and names it, and you decide (CT-201).

### D-09 — Agent surfaces and the form of each adapter

**Proposed** (evidence in `AGENT-SURFACES.md`):

- Supported: Claude Code CLI, IDE extensions and desktop app; Codex CLI and IDE extension; Copilot CLI and the Copilot harness in VS Code. All on a local checkout. No cloud agent in v0.4.0.
- One `AGENTS.md` for all three; `CLAUDE.md` is one line that imports it.
- Commands: `.claude/commands/`, `.agents/skills/`, `.github/skills/`, identical text. Where Copilot CLI finds a command twice it uses the first, which is its own.
- The Copilot adapter drops `.github/copilot-instructions.md` (Copilot reads `AGENTS.md`), `.github/prompts/` (not available in Copilot CLI; skills are slash commands in VS Code) and `.vscode/settings.json` (it only asked, never blocked; and mentor's `.gitignore` excludes `.vscode/`, so it was never shared).
- In `AGENTS.md` the Harness owns one marked block. Everything else in the file is the project's, and `check_adapters` compares only the block. Every other overlay file belongs to the Harness as a whole file: a project cannot add its own entries to `CLAUDE.md`, `.claude/settings.json` or `.codex/hooks.json` without `check_adapters` reporting the file as modified.
- The caller named on a state write is what the agent declares. The command text lists the three identifiers and tells the agent to pass its own. The core checks the declaration only against an agent session marker, where one exists.

**Options.** (a) As proposed. (b) Keep prompt files and `copilot-instructions.md` as well, for older Copilot clients. (c) Whole-file ownership of `AGENTS.md` too.

**Recommend (a).** (b) keeps a second command copy to drift. (c) leaves a project no place for its own guidance that all three agents read: a nested `AGENTS.md` is ignored by Claude Code once a root `CLAUDE.md` exists and is not reached by Codex.

**I need from you:** which of the three agents you will run for step 4 of the acceptance scenario, and in which order. I can drive Claude Code only.

### D-10 — One change record per revision, one revision at a time

**Options.** (a) As proposed: later change records wait in order. Two fixes that belong together are stated as one change record. (b) A revision may carry several change records.

**Recommend (a)** for v0.4.0. (b) needs an operation that picks which records enter a revision and a rule for partial abandonment. Nothing in the brief needs it. Tests: CT-154, CT-191.

### D-11 — A disposition survives a change to the task's definition

**Options.** (a) It stays in force and is reported as decided on an earlier definition. (b) It lapses, and the task becomes runnable until someone decides again.

**Recommend (a).** With (b) an unrelated edit to TASK-16's definition would let an agent start a task you said another team delivers. Tests: CT-171.

### D-12 — Schemas evolve inside version 1

**Options.** (a) v0.4.0 adds optional fields and enumeration values to the version-1 schemas, each release carrying its own copy. v0.3.0 records stay valid and keep their digests. (b) New `v2` schema identifiers for every changed document, with the core reading both.

**Recommend (a).** The canonicalisation never inserts defaults and absent members stay absent, so (a) changes no existing digest; the review confirmed this against the canonicaliser. (b) doubles the record handling for no gain in safety.

### D-13 — `complete_task` refuses a failed verification and an out-of-scope path

**Found.** v0.3.0's prompt tells the agent not to do this; nothing checks. In mentor, TASK-04's state file was rewritten by a later fix commit with nothing recording that the first result was superseded.

**Options.** (a) The core refuses completion when a control result is `FAIL`, when a control has no result, or when a reported path is outside the task's scope or on a reserved path. (b) The core records whatever is reported.

**Recommend (a).** These are the checks the core can make deterministically. It still cannot verify that a reported `PASS` is true; the run records it as the caller's claim. Tests: CT-160.

### D-14 — How every agent finds the core

**Options.** (a) A launcher committed in the project, `./harness` and `harness.cmd`, that resolves the core from `ENGINEERING_HARNESS_CORE`, then `harness-core` beside the project, then the search path. Identical in every project, so adapter files need no substitution and can be compared byte for byte. (b) No launcher; every adapter calls `harness-core` on the search path. (c) Keep substituting the path into each adapter file from one neutral project file.

**Recommend (a).** It keeps the "binary beside the projects" convention working with no set-up, gives permission rules one stable command prefix, and moves a non-standard location to where it belongs, the developer's environment. (b) depends on each agent's shell inheriting the search path. (c) keeps machine-specific paths in committed files. Tests: CT-183, CT-206.

Three things follow from the agents' documentation: hook registrations resolve the launcher from the project root, not from the session's directory; the launcher answers `adapter_guard` with success when it finds no core, because Copilot denies every tool call when a hook fails; and with Copilot's local sandbox on, the core's directory must be granted for reading. Not verified: each agent's Windows shell.

### D-15 — Where Stage 2 is built

**Found.** The core's source is not in this repository. It is in `engineering-harness-cli` (checked out beside this one as `harness-project/engineering-harness-v030`), and this repository ships only its binaries. That checkout's `node_modules` holds x64 native modules and does not run under the arm64 Node on this machine; the tests run after reinstalling two native packages in a copy.

**Options.** (a) Stage 2 works on a `v0.4.0` branch in each repository: release data, adapters and documents here; core, tests and fixtures there; binaries built there and copied here as today. (b) Merge the core into this repository first, as `CORE-INTEGRATION.md` describes.

**Recommend (a).** It changes nothing about how you release. I will need your confirmation that I may write to the core checkout, and I will reinstall its dependencies for arm64 in that checkout (or work in a copy, if you prefer it left alone).

### D-16 — What I run myself and what I hand to you

**Proposed.** On synthetic fixture projects the automated tests exercise every operation, including decisions, with fixture identities, as the v0.3.0 suite already does. On any clone of mentor I never record a decision: approval, rejection, deferral and acceptance commands go to you, and I wait. `adopt_release` on a mentor clone also goes to you (D-08).

**I need from you:** confirmation of this reading of "never record a decision yourself, even on a clone".

### D-17 — How the reach of a change is decided

**Found.** The brief says the core decides the reach. At the moment a change is opened the core has only the operator's statement and its kind; it has no fact from which to tell that a defect needs an architecture change.

**Options.** (a) The core fixes the reach when the record is opened: the default of the kind, or a wider reach the operator asks for, never below the kind's minimum. From then on the core enforces it from facts: a changed chain outside the reach blocks the revision, a changed Pack needs reach `specification`, and a task without a requirement is allowed only under the kinds of D-02. A revision that needs more continues under a superseding record. (b) The operator never states a reach; it is the kind's fixed reach, and widening means a superseding record of another kind. (c) No reach is stored; the core derives it from whatever the revision changes.

**Recommend (a).** (b) forces a `defect` that touches an ADR to be relabelled. (c) gives the core nothing to offer as the first step, and nothing to refuse: any revision could quietly grow into the specification.

### D-18 — After adoption, a v0.3.0 core must refuse the project

**Found.** By reading its source: a v0.3.0 core pointed at a project governed by v0.4.0 would resolve the v0.4.0 release, find every baseline stale, and accept `validate_specification` and the rest with no change record. The launcher runs whatever `harness-core` sits beside the project, so one developer with an old binary could do this.

**Proposed.** The v0.4.0 release definition declares a core contract number and drops the `bootstrap_workflow` key, without which a v0.3.0 core cannot resolve the release. It then reports `PROV_UNSUPPORTED` and writes nothing. A contract test runs the real v0.3.0 executable against an adopted fixture (CT-200).

**Options.** (a) As proposed. (b) Accept the risk and state it in the release notes.

**Recommend (a).** Consequence: once a project is adopted, everyone working on it needs the v0.4.0 core. That is what adoption means.

## 3. Choices I made without asking

Object to any of these and I will change it; none alters the structure.

- **Names.** Operations as listed in `BRS-CHANGES.md` 2.17; records `CHG-`, `CLO-`, `DEC-`, `ADOPT-`, `RUN-`; directories `evidence/changes`, `evidence/adoptions`, `evidence/decisions`; BRS version 2.0.
- **A fourth and fifth reach.** The brief lists three. `execution` is the brief's "maintenance action that keeps the earlier record" (re-run a finished task under its approved definition). `none` is a registered change.
- **Runs are separate files**, `work/state/<TASK-id>/RUN-0001.yaml`. A v0.3.0 file `work/state/<TASK-id>.yaml` stays where it is and is never rewritten, so the fifteen finished mentor tasks are not touched.
- **Carry-over is derived, not written.** `baseline_work` writes nothing under `work/state/`. A task is done when its latest run is done on the definition digest the governing baseline holds.
- **An item index in every candidate.** Without it a specification revision could only say "the specification file changed". With it the approver sees which requirements and criteria were added, changed or removed. Everything that is not an item is covered by one `document` item per artefact, so a reordering shows too.
- **The validation subject binds the change record** in the maintenance regime. Validation evidence is then per change record, and a superseded change record's validation does not carry over.
- **A chain that needs no change is confirmed by validating it**, and still passes its gate.
- **Two repairs need no change record:** re-materialising `/engineering` for an unchanged Pack and re-deriving the Project AI Policy. Both reproduce deterministic artefacts.
- **Selection resumes work in progress first** and returns a blocked task only by name, so that an unattended `execute` does not loop on a task that is stuck.
- **A caller of a state-writing operation must say who it is:** `--adapter <id>` or `--operator`. Neither is a usage error.
- **A task with a human gate stays as in v0.3.0:** reported, never started by an adapter. v0.4.0 adds no way to satisfy a task gate.
- **What a change record owes is fixed when its Work Baseline is established.** The tasks attributed to it and whether each was done for it do not change when a later revision touches those tasks. Its acceptance statements stay in the report until they are met.
- **`maintain` and `bootstrap` have a `rework` form, and `maintain` an `abandon` form,** so that an adapter can use the operations the core permits after a rejection or a failed validation.
- **A corrupt or missing change record blocks the project** (`resolve_blocker`) and prohibits execution until it is restored. It does not invalidate the baselines established under it.
- **`adapter_guard` denies any shell command that contains a guarded name as a word.** It will also stop a harmless `grep approve_pending`. I prefer that to a pattern that can be stepped around.
- **A v0.4.0 core treats a v0.3.0 project exactly as v0.3.0 does** until it is adopted, except that the CLI guard applies.

## 4. D-06 option (c): what it adds, and where it meets D-07 and D-08

You chose signed decisions and asked that any conflict with D-07 be flagged and not resolved by assumption. Nothing in D-07 makes signed decisions impossible, and nothing in signed decisions breaks adoption without re-approval. But the two meet in three places. In each I had to build something to keep working; what I built is stated, is the narrowest thing that keeps both decisions true, and can be changed without touching the rest.

### 4.1 Where D-06 (c) meets D-07 and D-08

**F-1. The adoption record now has to be signed. This changes D-08 as you approved it.**

D-07 lets a v0.3.0 approval stand because an adoption record lists it. D-08 (a) said that record has no approver and is protected only by the terminal guard. With signed decisions that would leave one unsigned record that exempts other records from being signed: an agent could write a v0.3.0-style approval and baseline as files, add them to the adoption record, recompute its digest, and the core would accept them. Route 2 of D-06 would survive, for adopted projects only.

- **Built:** the adoption record is a signed record. It lists every decision record the project held at adoption, and only those keep declared assurance. You sign it with your key when you run `adopt_release`.
- **What that means for you:** adoption needs your signature. It decides nothing about content, so I do not count it as re-approval, and the acceptance criterion "without any re-approval" is met as I read it. If you read it differently, say so.
- **Options.** (a) As built: signed by any enrolled identity that holds an authority in the Pack. (b) Signed specifically by the `engineering` authority, which makes adoption a decision in all but name and reverses D-08. (c) Unsigned, as D-08 (a) literally says, accepting that a forged v0.3.0-style approval can be slipped in through a rewritten adoption record.
- **Recommend (a).**

**F-2. D-07 rules out the strongest home for the keys.**

The identities that may decide are named in `project-pack/project.yaml`. Putting each identity's public key there would bind keys to authorities under the Specification Baseline, and a key could then be changed only through a revision approved by `product_domain`. But the Pack is fingerprinted, so adding keys to mentor's Pack makes its Specification Baseline stale and forces re-approval of all three baselines, which D-07 and the first acceptance criterion forbid.

- **Built:** keys live in their own append-only, signed chain (`evidence/signers/`), outside every fingerprint. Its first record, the anchor, is trusted on first use. See D-20.
- **Consequence you should weigh:** the anchor is the one thing in the scheme that is not itself protected by a signature made before it.

**F-3. An adopted project has two levels of assurance side by side.**

D-07 keeps mentor's three baselines current on approvals that nobody signed. After the acceptance scenario the new Work Baseline is signed, but it rests on a Specification and an Architecture Baseline that are not, and they stay that way until a revision replaces them.

- **Built:** every result reports each baseline as `signed` or `declared`, and says when a signed baseline rests on a declared one. Nothing is upgraded silently.
- **Not built, and yours to ask for:** a way to countersign carried approvals without a revision. The signed adoption record already fixes which unsigned approvals exist; it does not turn them into signed ones, and I think it should not.

### 4.2 Further decisions

**D-19 — Who may sign an adoption record.** See F-1. Built: any enrolled identity that holds an authority in the Pack. Recommend keeping it.

**D-20 — Where trust in the keys starts.**

**Found.** A signature proves which key signed. It does not prove that the key belongs in the project. The list of enrolled keys is in the repository, and an agent can write to the repository.

**Built.** Three layers. (1) Every signer record after the first must be signed with a key already enrolled, so nobody can add a key without one. (2) Every signed record names the head of the chain at the time, so replacing the chain breaks everything signed under it. (3) The CLI remembers, per user and outside the project, which anchor you accepted for each project path, and refuses a reserved operation when the project's anchor is another one (`GUARD_ANCHOR_CHANGED`).

**Residual risk.** An agent that replaces the whole chain before anything is signed under it, or together with everything signed under it, produces a repository that is consistent in itself. Layer 3 catches that on your machine. On a machine that never accepted the anchor, a person has to compare the fingerprint the CLI shows with the one they expect, as with a new SSH host. The file of layer 3 is in your home directory, which an agent without a sandbox can also write.

**Options.** (a) As built. (b) Keys in the Project Pack: no trust on first use, at the price of re-approving mentor (F-2) and a specification revision for every key change. (c) As built, plus an anchor published outside the machine, for example as a signed Git tag that the CLI checks. I have not designed (c).

**Recommend (a)** for v0.4.0, and (c) as the next step if the residual risk is too much.

**Decided: (a)** by the owner, 2026-11-23. You accept trust on first use of the anchor, as with SSH, for v0.4.0. Option (c) stays the next step if the residual risk becomes too much.

**D-21 — A lost key.**

**Built.** There is no recovery. A new key can be enrolled only with a signature from one already enrolled. If every enrolled key is lost the chain cannot continue, and the project's signed decisions cannot be added to; the documented way out is a new chain and re-approval. The core warns while a project has a single key.

**Options.** (a) As built: enrol a second key and keep it apart. (b) A recovery record that starts a new anchor without a signature, accepted after each operator confirms it. That makes replacing the anchor a supported act, which weakens D-20.

**Recommend (a).** Before the acceptance run, decide whether you want to enrol a second key on the mentor clone; it is one command.

**D-22 — What counts as a key an agent cannot use.**

**Found.** "Private signing keys must remain inaccessible to agents" cannot be enforced by the Harness alone. A coding agent runs as you. It can read an unencrypted key file, and it can ask your SSH agent to sign if the agent signs without asking.

**Built.** The core never opens a private key; your own `ssh-keygen` signs. The CLI refuses a private key file that has no passphrase, unless it is hardware-backed. Each adapter's hook denies an agent's tool call that runs `ssh-keygen -Y sign`. The CLI cannot see how your SSH agent is configured.

**What you have to do.** Use a key that needs you for every signature: a passphrase-protected key that is not loaded into `ssh-agent`; or a key added with `ssh-add -c`; or a hardware key that needs touch; or a key manager that asks each time. If your everyday key is loaded in an agent that signs silently, use a separate key for the Harness.

**Options.** (a) As built. (b) Accept only hardware-backed keys. (c) Drop the passphrase check and leave it all to the operator.

**Recommend (a).** (b) is the strict reading of your requirement; say so if you want it, it is a one-line rule.

**D-23 — The typed confirmation stays.**

**Built.** Before the signature the CLI still shows the subject and the delta and asks for the last eight characters of the digest. With a key that needs a passphrase or a touch this is a second act; with a key in an SSH agent it is the only moment you are asked anything.

**Options.** (a) Keep it. (b) Drop it; the signature is the confirmation.

**Recommend (a).**

### 4.3 What option (c) costs in use

- One command to enrol each person's key, and your signature on each decision and on the adoption.
- `ssh-keygen` from OpenSSH 8.1 or later on the machine where a decision is recorded. Reading and checking a project needs nothing but the core.
- A decision can no longer be recorded from a script or by CI.
