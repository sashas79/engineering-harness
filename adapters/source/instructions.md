# Engineering Harness

This project is governed by the Engineering Harness. The deterministic Harness core is the only authority for repository facts, the lifecycle state, validation results, the validity and currentness of baselines, blockers, the status of Work Items and the next action. Never reconstruct any of these from the conversation or from the files of the repository: ask the core and present what it returns.

## Calling the core

Call the core only through the launcher, from the project root, in this form:

```sh
./harness inspect_project --project-root . --adapter <id>
```

`<id>` is the identifier of the agent you are. The adapter identifiers are `claude-code`, `codex` and `copilot`. Claude Code is `claude-code`, Codex is `codex` and GitHub Copilot is `copilot`. Pass your own identifier with `--adapter` on every call and never another agent's: the core records it as the caller.

- The launcher finds the core. Never name, guess or search for the location of the core, never pass a Harness root, and never download or select a Harness release.
- When the launcher exits with status 64 it found no core. Stop and report its message.
- The result is one JSON document. Take `outcome`, `regime`, `lifecycle.state`, `next_action`, `permitted_operations` and `issues` from it. Never derive them yourself.

## What an agent may do

- Perform only the next action the core returns, or an operation that the core's current result lists in `permitted_operations` with actor `adapter` and that the operator asked for through one of the commands below.
- Stop at `HUMAN_INPUT`, `HUMAN_DECISION`, `REWORK`, `BLOCKED`, `INVALID` and `ERROR`, and present the issue codes and the next action exactly as the core returned them.
- You must never run a reserved operation or an operator command. The reserved operations are `record_specification_decision`, `record_architecture_decision`, `record_work_decision`, `record_task_decision`, `record_change_decision`, `approve_pending` and `reject_pending`. The operator commands are `adopt_release`, `enrol_signer`, `revoke_signer`, `trust_signers`, `adapter_add`, `adapter_remove` and `adapter_sync`. They belong to the operator, who runs them in their own terminal.
- Never run `ssh-keygen -Y sign`, and never ask for, read or use a signing key. A human decision is valid only with the operator's own signature.
- Never write under a reserved path: `spec/`, `architecture/`, `engineering/`, `ai/`, `work/`, `baselines/`, `evidence/`, `.engineering-harness-template`, `.engineering-harness-adapters`, the launcher (`harness`, `harness.cmd`), this block of `AGENTS.md`, and the files the Harness installed for the agents (`CLAUDE.md` and the Harness commands, skills, settings, rules and hooks under `.claude/`, `.agents/`, `.codex/` and `.github/`). The core writes the governed files itself when you hand it an operation.
- `project-pack/` belongs to the project. Write there only to complete the Pack from the operator's brief, as the `bootstrap` command describes.
- Change the product (`src/`, `tests/`, `infra/`) only while executing a Work Item through the `execute` command, inside that item's repository scope.

## Commands

The operator works through three commands. Each has a `status` form that writes nothing.

- `bootstrap`: `bootstrap status` reports the project. `bootstrap` performs the next action of the bootstrap lifecycle. `bootstrap rework <instruction>` corrects an artefact set the core sent back.
- `execute`: `execute status` reports every Work Item. `execute` or `execute <TASK-id>` executes one Work Item.
- `maintain`: `maintain status` reports the change records and the revision in progress. `maintain <statement>` opens a change record. `maintain register <statement>` registers a change made outside a run. `maintain` continues the revision. `maintain rework <instruction>` and `maintain abandon <CHG-id>` do what their names say.

Never start a Work Item from `bootstrap` or `maintain`, or on your own initiative. Never keep a state machine of your own: the commands hold no rule of selection or transition, they call the core and present its result.

## Human decisions

At a gate the core returns a `HUMAN_DECISION`. Stop. Present the gate, the candidate digest, the delta when the result carries one, and the command the operator runs in their own terminal:

```text
./harness approve_pending --project-root . --approver <identity> --key <path>
```

`<identity>` is `pending_gate.approver`, the identity the Project Engineering Pack assigns to the authority of the gate (`pending_gate.authority`). `<path>` is the operator's signing key. The command asks the operator to confirm the subject on the terminal and to sign with OpenSSH. An agent must never run it, never answer its questions and never run `ssh-keygen -Y sign`: a decision recorded by an agent is not a decision.
