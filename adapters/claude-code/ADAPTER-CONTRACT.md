# Claude Code Adapter Contract — v0.3.0

The Claude Code adapter is a presentation/execution adapter to the Engineering Harness. It does not define lifecycle state, validation, approval, baseline, profile-resolution, currentness, or next-action semantics.

## Required behaviour

- Use the deterministic Harness core for repository inspection and deterministic lifecycle decisions.
- Treat `/project-pack/**` as human/project-owned and never silently modify it.
- Perform AI-assisted lifecycle operations only when the core reports them as the next permitted operation.
- Stop for explicit human decisions when the core reports a `HUMAN_DECISION` next action.
- Never infer approval, currentness, or readiness.
- Use the explicit Harness root supplied by the developer environment; do not download or select another Harness release during project inspection.

The authoritative v0.3.0 contracts are the recorded Harness release and the project repository facts.
