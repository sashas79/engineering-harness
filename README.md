# Engineering Harness v0.2.1

The **Engineering Harness** is an experimental executable engineering system for building production-grade software with AI under explicit engineering and human control.

v0.2.1 is the current **discovery/proof baseline**. It demonstrates the core model, project initialisation mechanism and first Claude Code adapter. It is intended to expose and test the engineering model rather than represent a finished production Harness.

## Core model

```text
HUMAN CONTROL PLANE
Product | Architecture | Security | Engineering | Release
                         |
                         v
                ENGINEERING HARNESS
schemas | standards | workflows | prompts | policies
                         |
                         v
              PROJECT ENGINEERING PACK
project configuration | source inputs | policy overrides
                         |
                         v
                 PROJECT BOOTSTRAP
                         |
                         v
SPECIFICATION
    → validate
    → human approval
    → Specification Baseline
                         |
                         v
ARCHITECTURE
    → validate
    → human approval
    → Architecture Baseline
                         |
                         v
PROJECT AI POLICY
                         |
                         v
ENGINEERING WORK ITEMS
    → validate work graph
    → human approval
    → Work Baseline
                         |
                         v
                 EXECUTION READY
                         |
                         v
Engineering Work Item
    → Plan
    → Build Context
    → Execute
    → Verify
    → Review
         |
         └── rework on failure
```

AI performs bounded engineering work inside this system. It does not determine its own engineering authority or approve its own outputs.

## Package structure

```text
engineering-harness/
├── harness/
│   ├── schemas/
│   ├── standards/
│   ├── workflows/
│   ├── prompts/
│   ├── policies/
│   └── harness.yaml
│
├── project-pack/
│   ├── project.yaml
│   ├── harness-profile.yaml
│   ├── project-policy.yaml
│   ├── source/
│   └── overrides/
│
├── project/
│   ├── spec/
│   ├── architecture/
│   ├── engineering/
│   ├── ai/
│   ├── work/
│   ├── baselines/
│   ├── evidence/
│   ├── src/
│   ├── tests/
│   └── infra/
│
└── adapters/
    └── claude-code/
        ├── CLAUDE.md
        ├── ADAPTER-CONTRACT.md
        └── .claude/
            └── commands/
                └── bootstrap.md
```

### `harness/`

Reusable organisation-level Harness machinery.

It contains the workflows, policies, prompts, schemas and standards intended to govern AI-driven engineering.

### `project-pack/`

Project-specific bootstrap inputs, including project configuration, source material and project policy.

In v0.2.1 this exists in the central Harness package but is **not yet copied into the generated project by `harness-init.sh`**. This is a known design gap.

### `project/`

Template used to initialise an engineered project repository.

### `adapters/`

Tool-specific adapters to the Harness.

v0.2.1 includes the first adapter for **Claude Code**.

Claude Code is an execution adapter. It is not the Engineering Harness itself.

## Initialise a project

The standalone `harness-init.sh` script retrieves a tagged Harness release and creates an independent project repository.

Requirements:

* Bash
* Git
* access to the Engineering Harness Git repository
* Claude Code if using the supplied adapter

Run:

```bash
bash ./harness-init.sh ecommerce-platform v0.2.1 claude-code
```

The initializer:

1. retrieves the `v0.2.1` Harness release;
2. copies the `project/` template into `ecommerce-platform/`;
3. overlays the Claude Code adapter files;
4. records Harness provenance in `.engineering-harness-template`;
5. records adapter provenance in `.engineering-harness-adapter`; and
6. creates a new independent Git repository.

Then:

```bash
cd ecommerce-platform
git status
claude
```

Inside Claude Code:

```text
/bootstrap status
```

> In the supplied v0.2.1 initializer, the default release is still `v0.1.0`. Pass `v0.2.1` explicitly.

## Claude Code bootstrap commands

### Inspect the project

```text
/bootstrap status
```

This is intended to be read-only.

It inspects the repository and reports:

* detected bootstrap state;
* missing prerequisites;
* unresolved ambiguities;
* human gates;
* blockers; and
* the next permitted action.

### Progress bootstrap

```text
/bootstrap
```

Runs the next permitted non-gated bootstrap stage and stops when human input or approval is required.

### Request a particular stage

```text
/bootstrap <stage>
```

The requested stage may run only when its prerequisites are satisfied.

The bootstrap command does not execute Engineering Work Items.

## Project artefacts

The intended authoritative project locations are:

| Path                         | Purpose                                    |
| ---------------------------- | ------------------------------------------ |
| `/spec`                      | Functional intent                          |
| `/architecture`              | Structural intent                          |
| `/engineering`               | Project engineering baseline/configuration |
| `/ai`                        | Project-specific AI policy                 |
| `/work/tasks`                | Engineering Work Items                     |
| `/work/execution-graph.yaml` | Work dependencies and execution ordering   |
| `/work/state`                | Runtime work state                         |
| `/baselines`                 | Approved engineering states                |
| `/evidence`                  | Validation, review and execution evidence  |
| `/src`                       | Implementation                             |
| `/tests`                     | Tests                                      |
| `/infra`                     | Infrastructure artefacts                   |

The repository is intended to be the durable source of project engineering state. Conversational history is not authoritative project state.

## Human approval

The Harness separates automated engineering activity from accountable human decisions.

Required approvals include:

```text
Specification
    → Product / Domain authority

Architecture
    → Architecture authority

Work decomposition
    → appropriate engineering authority

Production release
    → Release authority
```

AI may prepare material for approval.

AI must not:

* approve its own work;
* infer approval from silence;
* fabricate approval;
* skip required gates; or
* treat missing approval as approval.

## Execution model

Once a valid Work Baseline exists, implementation is intended to proceed through authorised Engineering Work Items:

```text
Engineering Work Item
        ↓
       Plan
        ↓
   Build Context
        ↓
      Execute
        ↓
      Verify
        ↓
      Review
        │
        └── rework → Verify → Review
```

Generated implementation is not trusted merely because it was generated.

Required verification must pass before the work is considered valid engineering output.

## Evidence

The Harness treats evidence as an engineering output.

Evidence may include:

* specification validation;
* architecture validation;
* work-graph validation;
* test results;
* verification results;
* review results;
* human approvals;
* rework history; and
* execution records.

The objective is not merely to show that AI generated software, but to retain evidence of the controlled engineering process used to produce it.

## v0.2.1 limitations

v0.2.1 is deliberately a discovery release and contains several known limitations.

### Project template contains example state

The supplied `project/` template contains example/generated project artefacts, including:

```text
work/tasks/TASK-042.yaml
work/state/TASK-042.yaml
work/execution-graph.yaml

baselines/specification.yaml
baselines/architecture.yaml
baselines/work.yaml

ai/context-policy.yaml
ai/runtime-policy.yaml
```

Some of these contain claims-specific example content and approved-looking state.

They must **not** be interpreted as valid engineering state for a newly created real project.

### Project Engineering Pack is not connected to initialisation

The central package contains `/project-pack`, but `harness-init.sh` currently copies only `/project` and the selected adapter into a new repository.

The human-input boundary therefore exists conceptually but is not yet cleanly connected to project initialisation.

### Claude performs repository-state inspection

`/bootstrap status` currently relies substantially on Claude reading the repository and reasoning about its state.

Deterministic facts such as repository structure, lifecycle state, baseline currentness and next permitted action are not yet provided by a deterministic Harness runtime.

### Lifecycle semantics are duplicated

Lifecycle behaviour currently appears across:

```text
harness/harness.yaml
harness/workflows/bootstrap.yaml
harness/policies/human-gates.yaml
CLAUDE.md
.claude/commands/bootstrap.md
```

These representations are not yet completely aligned.

### Baseline approval is not yet strongly bound

v0.2.1 demonstrates the baseline concept but does not yet provide a complete deterministic, content-addressed approval and currentness model.

### Schemas and standards are incomplete

Several supplied schemas and standards are placeholders sufficient to explore the model rather than complete executable engineering contracts.

### Internal version metadata still contains v0.1 values

Parts of the v0.2.1 package retain earlier identifiers such as:

```text
Engineering Harness v0.1
harness version: 0.1.0
Claude Code Adapter Contract — v0.1
```

These are known release-metadata inconsistencies rather than separate Harness releases.

## What v0.2.1 proves

Despite those limitations, v0.2.1 establishes the main architectural direction:

```text
centrally governed Engineering Harness
        ↓
versioned release
        ↓
lightweight project initialisation
        ↓
independent project repository
        ↓
AI execution adapter
        ↓
controlled bootstrap and runtime model
```

It also demonstrates why the Harness must become more deterministic as more engineering activity is delegated to AI.

v0.2.1 should therefore be treated as the **frozen discovery baseline from which the v0.3.0 design is derived**, rather than incrementally expanded into the next architecture.

## Terminology

**Engineering Harness**
Reusable organisation-level executable engineering system.

**Project Engineering Pack**
Project-specific configuration and source inputs supplied to bootstrap.

**Engineering Work Item**
Atomic, bounded unit of authorised engineering work.

**Structured Execution Policy**
The work definitions, dependency graph, scopes, gates and applicable controls governing execution.

**Baseline**
An approved engineering state from which downstream work is derived or executed.

**Execution adapter**
Tool-specific integration that maps an AI execution environment onto Harness semantics without becoming a second source of engineering policy.
