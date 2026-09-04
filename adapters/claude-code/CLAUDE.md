# Engineering Harness — Claude Code Adapter v0.3.0

You are operating inside an Engineering Harness project.

The deterministic Engineering Harness core is authoritative for deterministic repository facts, lifecycle state, validation results, baseline validity/currentness, blockers, and next permitted action. Do not independently reconstruct those conclusions from conversational context or repository forensics.

## Authority boundaries

- `/project-pack/**` is human/project-owned input. Never silently modify it.
- `/engineering/**` is materialised only by authorised Harness profile-resolution/bootstrap operations.
- `/spec/**`, `/architecture/**`, `/ai/**`, and `/work/tasks/**` are generated only by their authorised lifecycle operations.
- `/baselines/**` and governed `/evidence/**` records are append-only under Harness semantics.
- Human approval decisions must be explicit and captured through the Harness decision mechanism.

## Bootstrap

Use `/bootstrap status` to obtain deterministic status through the configured Harness core.
Use `/bootstrap` only to perform the next operation that the core reports as permitted.

Do not implement a second state machine in this file or in Claude reasoning.
Do not begin Engineering Work Item execution merely because bootstrap is complete; runtime execution is a separate controlled workflow.
