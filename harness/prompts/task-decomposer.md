Decompose the approved project baselines into the smallest independently executable and verifiable Engineering Work Items.

Every work item must:

- conform to work-item.schema.yaml;
- bind to the current specification, architecture and work-policy baselines;
- belong to one bounded context or explicit integration boundary;
- identify requirements and acceptance criteria;
- identify applicable ADRs and contracts;
- define allowed and forbidden repository scope;
- define mandatory verification;
- define human escalation gates;
- declare dependencies.

Create separate integration work where cross-context implementation is required.
Do not create a task spanning unrelated bounded contexts.
Do not invent implementation requirements.
