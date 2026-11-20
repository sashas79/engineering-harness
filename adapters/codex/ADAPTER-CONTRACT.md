# Codex adapter contract — Engineering Harness v0.4.0

The `codex` adapter lets OpenAI Codex work in a project governed by the Engineering Harness. It presents what the deterministic Harness core returns and performs the operations the core offers. It defines no lifecycle state, no validation, no approval and no next action of its own.

This contract is never copied into a project. The statements about Codex are quoted from its documentation at `learn.chatgpt.com/docs` and from the `openai/codex` source at tag `rust-v0.167.2`, read from copies saved on 2026-11-12. Codex was not run against these files in this release round; the section "Not verified" lists what follows from that.

## Supported surfaces

| Surface | Supported in v0.4.0 |
| --- | --- |
| Codex CLI, on a local checkout | Yes |
| Codex IDE extension, on a local checkout | Yes |
| ChatGPT desktop app | Expected to work, because it loads repository skills; untested |
| Codex cloud | No. Repository skills are available in cloud tasks, but the core and its release directory are not; this is not built or tested |

"Supported" means designed for. The project root must be the root of the Git repository: Codex reads `AGENTS.md` from "the project root (typically the Git root)", and the hook finds the launcher from the Git root.

## Adapter files

`init --adapters`, `adapter_add` and `adapter_sync` install these files. Each is byte-identical to the release file, and none holds a value specific to a project or a machine.

| File | What it is | Documentation relied on |
| --- | --- | --- |
| `AGENTS.md` (managed block, shared with the other adapters) | The project instructions, between the lines `<!-- engineering-harness:begin -->` and `<!-- engineering-harness:end -->`. Everything outside the block is the project's | `learn.chatgpt.com/docs/agent-configuration/agents-md`: "Codex reads `AGENTS.md` files before doing any work." |
| `.agents/skills/bootstrap/SKILL.md`, `execute/SKILL.md`, `maintain/SKILL.md` | The three commands as Agent Skills. The text is the same as in every other adapter; the front matter is `name` and `description` | `learn.chatgpt.com/docs/build-skills`: "The `SKILL.md` file must include `name` and `description`", and "For repositories, Codex scans `.agents/skills` in every directory from your current working directory up to the repository root." |
| `.agents/skills/<name>/agents/openai.yaml` | `policy: allow_implicit_invocation: false`, so that a command runs only when the operator names it | The same page: "When `false`, Codex won't implicitly invoke the skill based on user prompt; explicit `$skill` invocation still works." |
| `.codex/rules/engineering-harness.rules` | Three `prefix_rule` entries with `decision = "forbidden"` | `learn.chatgpt.com/docs/agent-configuration/rules` |
| `.codex/hooks.json` | The registration of the `PreToolUse` hook | `learn.chatgpt.com/docs/hooks` |
| `harness`, `harness.cmd` (shared) | The launcher. It finds the core: `ENGINEERING_HARNESS_CORE`, then `harness-core` beside the project directory, then `harness-core` on the search path | BRS Section 69.4 |

The operator types `$bootstrap status`, `$bootstrap`, `$bootstrap rework <instruction>`, `$execute status`, `$execute [TASK-id]`, `$maintain status`, `$maintain <statement>`, `$maintain`, `$maintain rework <instruction>` and `$maintain abandon <CHG-id>`, or picks the skill with `/skills`. In Codex the commands start with `$`, not with `/`. Codex custom prompts are not used: "Custom prompts are deprecated", and they were never stored in a repository.

Every file above belongs to the Harness as a whole file. A project that adds its own entries to `.codex/hooks.json` or to the rules file will see `check_adapters` report the file as modified; a project's own hooks and rules go into other files of `.codex/`.

## What the operator does once

1. Have a core the launcher can find: place `harness-core` beside the project directory, or put it on the search path, or set `ENGINEERING_HARNESS_CORE` in the environment Codex is started from. No adapter file names the location of the core.
2. Trust the project. "Project-local rules under `<repo>/.codex/rules/` load only when the project `.codex/` layer is trusted", and "Project-local hooks load only when the project `.codex/` layer is trusted."
3. Review and trust the hook. "Before a non-managed hook can run, Codex requires you to review and trust the exact hook definition. Codex records trust against the hook's current hash, so new or changed hooks are marked for review and skipped until trusted." Open `/hooks` in the CLI, read the one hook of `.codex/hooks.json` and trust it. Do this again after every `adapter_sync` that changes the file.
4. Restart Codex after the rules file is installed or changed; rules are read at startup.
5. Run `./harness check_adapters --project-root .` after an update of Codex or of the Harness.

Until steps 2 and 3 are done, nothing on the Codex side blocks. The guard of the core applies whatever Codex does.

## The shipped controls

**Rules.** `.codex/rules/engineering-harness.rules` forbids:

- `./harness <name>` for every reserved operation (`record_specification_decision`, `record_architecture_decision`, `record_work_decision`, `record_task_decision`, `record_change_decision`, `approve_pending`, `reject_pending`);
- `./harness <name>` for every operator command (`adopt_release`, `enrol_signer`, `revoke_signer`, `trust_signers`, `adapter_add`, `adapter_remove`, `adapter_sync`);
- `ssh-keygen -Y sign`.

A `forbidden` rule means "Block the request without prompting". Each rule carries `match` and `not_match` examples, which Codex validates when it loads the file.

**Hook.** A `PreToolUse` hook for `Bash` and `apply_patch` runs `adapter_guard` of the Harness core through the project's launcher. Its command line is:

```sh
d="$(git rev-parse --show-toplevel 2>/dev/null)"; [ -x "$d/harness" ] || exit 0; exec "$d/harness" adapter_guard
```

It finds the launcher from the Git root and not from the session's directory, as the hooks page recommends: "Commands run with the session `cwd` as their working directory", and "For repo-local hooks, prefer resolving from the git root instead of using a relative path". It exits 0 when it finds no launcher, and the launcher exits 0 for `adapter_guard` when it finds no core.

`adapter_guard` denies with exit status 2 ("You can also use exit code `2` and write the blocking reason to `stderr`"):

- a shell command that contains, as a shell word, the name of a reserved operation or of an operator command, in any position and behind any executable name, also inside `bash -lc '...'`, `eval`, a command substitution or a pipeline;
- a shell command that runs `ssh-keygen` with `-Y sign`;
- an `apply_patch` call in which a file that is added, updated, deleted or moved to lies in a governed directory (`spec/`, `architecture/`, `engineering/`, `ai/`, `work/tasks/`, `work/state/`, `baselines/`, `evidence/`) or is `work/execution-graph.yaml`, a provenance file, the launcher, `AGENTS.md` or an adapter file. The hook input carries the patch in `tool_input.command` ("`Bash` and `apply_patch` use `tool_input.command`").

It allows everything else, including every write under `project-pack/`, `src/`, `tests/` and `infra/`, and a call whose target it cannot determine.

## What the shipped controls block

Once the project's `.codex/` layer is trusted and the hook is reviewed:

- The documented invocation of every decision and operator command, `./harness <name> ...`, by the rules, also as one command of a chain that Codex can split: "Codex then evaluates each command against your rules, and the most restrictive result wins."
- The same names behind another executable or inside a script Codex does not split, through the hook: `../harness-core approve_pending`, `bash -lc 'x=1; ./harness approve_pending'`.
- `ssh-keygen -Y sign`, by a rule and by the hook.
- File edits through `apply_patch` on the governed directories, the provenance files, the launcher, `AGENTS.md` and the adapter files, by the hook.

Beside these, the guard of the core itself (BRS Section 68.2) refuses a reserved operation or an operator command when `--adapter` is given, when the environment carries `CODEX_THREAD_ID` and when no controlling terminal is available. Codex sets `CODEX_THREAD_ID` for the commands it runs in its source (`codex-rs/core/src/exec_env.rs`); its documentation does not list the variable, so this may change without notice.

In the default `workspace-write` sandbox Codex also cannot change its own skills, rules or hooks (`learn.chatgpt.com/docs/agent-approvals-security`): "`<writable_root>/.agents` is protected as read-only when it exists as a directory", and the same holds for `<writable_root>/.codex`.

## What they do not block

- **Anything, before the operator has trusted the project and reviewed the hook.** A changed hook definition is skipped until it is trusted again.
- **A file written by a shell command.** No control of any agent sees it. The rules match command prefixes and the hook looks for names in the command line; neither looks at where a shell command writes.
- **A script the rules cannot split.** With redirection, substitution, variables or wildcards "the entire invocation is treated as" one `bash -lc` call "and your rules are applied to that single invocation", so the prefix rule for `./harness <name>` does not see the command inside it. The hook reads the script and finds the name as a word; a name that is assembled at run time or read from a file is not found.
- **A hook that does not run or fails.** "A `PreToolUse` error, timeout, or malformed response can let the tool run." The documentation says of hooks in general: "Treat tool hooks as a useful guardrail, not a complete enforcement boundary", and of rules: "Rules are experimental and may change."
- **A relative target in a session below the project root** is judged from the session directory and from the project root, and is denied under either reading. A patch that adds `spec/x.ts` from a session in `src/app` is therefore refused although it would create `src/app/spec/x.ts`; start Codex in the project root, as the commands assume.
- **Reading.** Nothing here restricts what Codex reads.

## Residual risk

The controls above stop an agent from recording a decision by following or misreading instructions. They are not authentication. Authentication is the signature of BRS Section 73: a decision record, an adoption record or a signer record takes effect only with a signature by a key enrolled for the approver, and the core checks that signature whenever it reads the record. What remains is a condition on the operator's side:

1. **A key the agent can use.** A private key without a passphrase, or a key in an SSH agent that signs without asking, can be used by any process of the same user, Codex included. The CLI refuses a private key file with an empty passphrase; it cannot see how an SSH agent is configured. Use a key that needs you for every signature.
2. **A record written as a file.** Codex can write a file under `evidence/` with a shell command. Without a valid signature such a record satisfies no gate and is reported as an error.
3. **A confirmation typed by the agent.** Codex can give a command a terminal and type into it, so the terminal confirmation of the core stops a mistake and not a deliberate act. With `CODEX_THREAD_ID` set the core refuses before it asks, and without a signature the confirmation yields nothing.

## Not verified

- Codex was not run in this release round. The rules file was checked against the grammar of the rules page and of `codex-rs/execpolicy/README.md`, not loaded by Codex; check it with `codex execpolicy check --rules .codex/rules/engineering-harness.rules -- ./harness approve_pending`, which must report `forbidden`.
- Whether the shell tool gives a command a controlling terminal.
- Behaviour on Windows. The hook command is POSIX shell; no `commandWindows` override is shipped.
- The acceptance scenario runs Codex against these files: `$bootstrap status`, `$maintain status`, `$execute status` and one complete `$execute`.
