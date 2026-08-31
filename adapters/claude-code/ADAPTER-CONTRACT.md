# Claude Code Adapter Contract — v0.1

## Purpose

The Claude Code adapter maps Claude Code behaviour onto the Engineering Harness without redefining the Engineering Harness.

The harness remains tool-independent and authoritative. The adapter provides only the Claude Code-specific entry points and operating instructions needed to follow it.

## v0.1 surface

The initial adapter has two runtime artefacts:

```text
CLAUDE.md
.claude/
└── commands/
    └── bootstrap.md
```

`CLAUDE.md` establishes repository authority, control rules, baseline semantics, human approval rules and the task lifecycle for every Claude Code session.

`/bootstrap` is the Claude Code command that progresses an initialised project through the existing bootstrap workflow.

## Contract

### Adapter MUST

- treat repository artefacts and approved baselines as authoritative;
- preserve harness lifecycle and gate ordering;
- fail closed when prerequisites, policy, schema, evidence or approvals are missing;
- record ambiguities instead of silently resolving material ones;
- persist required evidence;
- stop at human gates;
- report current state and the next permitted action;
- keep bootstrap separate from Engineering Work Item execution.

### Adapter MUST NOT

- contain a second copy of organisation engineering standards;
- redefine harness schemas, policies or workflow semantics;
- approve its own outputs;
- infer that missing baselines are approved;
- execute backlog work before the work baseline exists;
- bypass an Engineering Work Item by coding directly from prose requirements;
- silently broaden repository scope;
- turn Claude Code into the human control plane.

## Bootstrap state machine

```text
REPOSITORY INITIALISED
        |
        v
SPECIFICATION IN PROGRESS
        |
        v
AWAITING SPECIFICATION APPROVAL
        |
        | human approval
        v
SPECIFICATION BASELINED
        |
        v
ARCHITECTURE IN PROGRESS
        |
        v
AWAITING ARCHITECTURE APPROVAL
        |
        | human approval
        v
ARCHITECTURE BASELINED
        |
        +--> AI POLICY IN PROGRESS
        |
        +--> WORK DECOMPOSITION IN PROGRESS
                    |
                    v
             AWAITING WORK APPROVAL
                    |
                    | human approval
                    v
             EXECUTION READY
```

Any stage may move to `BLOCKED` when fail-closed conditions apply.

## Command semantics

### `/bootstrap status`

Read-only. Detect and report bootstrap state, blockers and next permitted stage.

### `/bootstrap`

Perform the next permitted non-gated bootstrap stage. Stop when a human gate is reached.

### `/bootstrap <stage>`

Perform the named bootstrap stage only if all prerequisites are satisfied.

The command never starts runtime implementation.

## Source of truth

This adapter assumes the Engineering Harness project model currently expressed by the central repository:

- `/spec` — functional intent
- `/architecture` — structural intent
- `/engineering` — engineering standards
- `/ai` — project AI policy
- `/work/tasks` — authorised work
- `/work/execution-graph.yaml` — dependency policy
- `/baselines` — approved states
- `/evidence` — execution and validation evidence

Future adapter versions should remain thin even if the harness grows.
