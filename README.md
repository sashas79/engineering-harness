# Engineering Harness v0.1

This package separates the reusable engineering harness from the project-specific configuration that instantiates it and from the engineered project repository it creates.

## Model

```text
ENGINEERING HARNESS
schemas | standards | workflows | prompts | policies
        |
        v
PROJECT ENGINEERING PACK
project config | source inputs | policy overrides
        |
        v
BOOTSTRAP ORCHESTRATION
        |
        +--> repository foundation + /engineering baseline
        +--> normalise source into /spec
        +--> validate + approve SPEC BASELINE
        +--> derive /architecture
        +--> validate + approve ARCHITECTURE BASELINE
        +--> derive project-specific /ai policy
        +--> decompose /work/tasks
        +--> validate coverage + dependency graph
        +--> approve WORK BASELINE
        v
EXECUTION READY
        |
        v
Engineering Task -> Plan -> Build Context -> Execute -> Verify -> Review
                                      ^                    |
                                      +------ rework ------+
```

## Terminology

- **Engineering Harness**: reusable organisation-level executable engineering system.
- **Project Engineering Pack**: project-specific bootstrap configuration and source inputs.
- **Engineering Work Item**: atomic executable unit of engineering intent and control.
- **Structured Execution Policy**: rules, dependency graph, scopes, gates and validation constraints governing how Engineering Work Items may execute.
- **Baseline**: approved, versioned state against which downstream work is derived or executed.

## Top-level package

```text
/harness       reusable organisation-level machinery
/project-pack  project-specific bootstrap inputs
/project       example/resulting engineered repository structure
```
