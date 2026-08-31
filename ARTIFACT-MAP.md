# Recommended artefacts

| Artefact | Owner | Format | Purpose |
|---|---|---|---|
| `harness/harness.yaml` | Harness team | YAML | Reusable engine behaviour and lifecycle |
| `harness/schemas/*.schema.yaml` | Harness team | JSON Schema expressed as YAML | Machine validation of generated artefacts |
| `harness/standards/*` | Engineering organisation | Markdown / tool-native config | Mandatory engineering baseline |
| `harness/prompts/*.md` | Harness team | Markdown | Provider-independent role/stage instructions |
| `harness/workflows/*.yaml` | Harness team | YAML | Bootstrap and execution state machines |
| `harness/policies/*.yaml` | Harness/governance owners | YAML | Decision, model, scope and human-control policies |
| `project-pack/project.yaml` | Project initiation | YAML | Project facts and selected technology/configuration |
| `project-pack/harness-profile.yaml` | Project initiation | YAML | Harness version/profile and required controls |
| `project-pack/project-policy.yaml` | Project governance | YAML | Project-specific autonomy and control decisions |
| `project-pack/source/**` | Product/client | Original formats | Authoritative source inputs |
| `project/spec/**` | Product + harness | Markdown/YAML | Normalised functional intent |
| `project/architecture/**` | Architecture + harness | Markdown/YAML/OpenAPI/etc. | Structural intent and contracts |
| `project/ai/**` | Harness-derived | YAML | Project-specific runtime context and execution policy |
| `project/work/tasks/*.yaml` | Harness-derived | YAML | Atomic Engineering Work Items |
| `project/work/execution-graph.yaml` | Harness-derived | YAML | Dependency graph and executable ordering rules |
| `project/work/state/*.yaml` | Runtime | YAML | Mutable execution state, separate from task definition |
| `project/baselines/*.yaml` | Human authorities | YAML | Approved specification, architecture and work baselines |
| `project/evidence/**` | Harness/runtime | Structured files | Traceability, validation, test, review and telemetry evidence |
