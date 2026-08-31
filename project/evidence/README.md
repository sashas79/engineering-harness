# Evidence and telemetry

Evidence is first-class output of bootstrap and runtime execution.

Expected structure:

```text
/evidence
  /bootstrap
    /spec-ingestion
    /architecture
    /work-validation
  /executions
    /EXEC-000001
      plan.yaml
      context-manifest.yaml
      build.log
      test-results/
      scans/
      review.yaml
      telemetry.yaml
```

Evidence should make it possible to determine what was attempted, against which baselines, with which context and tools, what passed or failed, and who approved any required human gate.
