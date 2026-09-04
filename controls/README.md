# v0.3.0 control catalogue

The v0.3.0 vertical slice keeps the catalogue deliberately small.

The lifecycle/governance controls that apply invariantly are:

- `control://validation/project-pack`
- `control://validation/specification`
- `control://validation/architecture`
- `control://validation/work-graph`
- `control://policy/human-approval`
- `control://policy/repository-scope`
- `control://policy/evidence-required`

The `default` profile selects the variable verification controls:

- `control://verification/build`
- `control://verification/unit-test`

Technology definitions in this distribution do not add further controls. The deterministic core remains authoritative for the resolution semantics defined by the BRS; this README is explanatory, not an alternative contract.
