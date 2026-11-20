# Claude Code adapter contract — Engineering Harness v0.4.0

The `claude-code` adapter lets Claude Code work in a project governed by the Engineering Harness. It presents what the deterministic Harness core returns and performs the operations the core offers. It defines no lifecycle state, no validation, no approval and no next action of its own.

This contract is never copied into a project. The statements about Claude Code are quoted from its documentation at `code.claude.com/docs`, read from copies saved on 2026-11-12. Where a point was not run against Claude Code itself, the section "Not verified" says so.

## Supported surfaces

| Surface | Supported in v0.4.0 |
| --- | --- |
| Claude Code CLI, on a local checkout | Yes |
| Claude Code IDE extensions and desktop app, on a local checkout | Yes |
| Claude Code on the web, GitHub Actions | No. The core and its release directory live outside the repository and would have to be provisioned there; this is not built or tested |

"Supported" means designed for. The project root must be the directory Claude Code is started in, or the root of the Git repository.

## Adapter files

`init --adapters`, `adapter_add` and `adapter_sync` install these files. Each is byte-identical to the release file, and none holds a value specific to a project or a machine.

| File | What it is | Documentation relied on |
| --- | --- | --- |
| `AGENTS.md` (managed block, shared with the other adapters) | The project instructions, between the lines `<!-- engineering-harness:begin -->` and `<!-- engineering-harness:end -->`. Everything outside the block is the project's | `code.claude.com/docs/en/memory`: "An `AGENTS.md` and a `CLAUDE.md` or `CLAUDE.local.md` in your working directory or above it" gives "Your `CLAUDE.md` files only" |
| `CLAUDE.md` | Exactly one line, `@AGENTS.md`, so that Claude Code reads the shared instructions in every version and session | `code.claude.com/docs/en/memory`: "you can still keep it as the one file every tool shares by putting an `@AGENTS.md` import in a `CLAUDE.md` next to it" |
| `.claude/commands/bootstrap.md`, `execute.md`, `maintain.md` | The three commands. The text is the same as in every other adapter; the front matter is `description`, `argument-hint` and `disable-model-invocation: true` | `code.claude.com/docs/en/skills`: "a Markdown file in `.claude/commands/` is the older format and still works. It supports the same frontmatter except `name` and `paths`"; `disable-model-invocation`: "Set to `true` to prevent Claude from automatically loading this skill" |
| `.claude/settings.json` | One allow rule, the deny rules and the hook registration described below | `code.claude.com/docs/en/permissions`, `code.claude.com/docs/en/hooks` |
| `harness`, `harness.cmd` (shared) | The launcher. It finds the core: `ENGINEERING_HARNESS_CORE`, then `harness-core` beside the project directory, then `harness-core` on the search path | BRS Section 69.4 |

The operator types `/bootstrap status`, `/bootstrap`, `/bootstrap rework <instruction>`, `/execute status`, `/execute [TASK-id]`, `/maintain status`, `/maintain <statement>`, `/maintain`, `/maintain rework <instruction>` and `/maintain abandon <CHG-id>`. Claude Code appends what follows the command name to the command text ("When no placeholder receives an argument, Claude Code appends them as `ARGUMENTS: <value>`"), and the command text reads the form from there.

`.claude/settings.json` belongs to the Harness as a whole file. A project that adds its own entries to it will see `check_adapters` report the file as modified. Personal settings go into `.claude/settings.local.json`, which the Harness does not touch.

## What the operator does once

1. Have a core the launcher can find: place `harness-core` beside the project directory, or put it on the search path, or set `ENGINEERING_HARNESS_CORE` in the environment Claude Code is started from. No adapter file names the location of the core.
2. Start Claude Code in the project root and accept the workspace trust prompt. The hook is a command the repository supplies: read `.claude/settings.json` before trusting it. `/hooks` shows the registered hook.
3. Run `./harness check_adapters --project-root .` after an update of Claude Code or of the Harness. It reports any adapter file that is missing or differs from the release.

## The shipped controls

**Allow rule.** `Bash(./harness *)` lets Claude Code call the launcher without a prompt.

**Deny rules** (`permissions.deny`):

- `Bash(./harness <name> *)` for every reserved operation (`record_specification_decision`, `record_architecture_decision`, `record_work_decision`, `record_task_decision`, `record_change_decision`, `approve_pending`, `reject_pending`) and every operator command (`adopt_release`, `enrol_signer`, `revoke_signer`, `trust_signers`, `adapter_add`, `adapter_remove`, `adapter_sync`), and `Bash(ssh-keygen -Y sign *)`.
- `Edit(/<path>)` for the governed directories (`spec/`, `architecture/`, `engineering/`, `ai/`, `work/tasks/`, `work/state/`, `baselines/`, `evidence/`), for `work/execution-graph.yaml`, the two provenance files, the launcher, `AGENTS.md`, `CLAUDE.md` and every overlay file of the three adapters. The documentation says: "`Edit` rules apply to all built-in tools that edit files", and a pattern that starts with one `/` is a "Path relative to the settings source".

**Hook.** A `PreToolUse` hook for `Bash`, `PowerShell`, `Write`, `Edit`, `MultiEdit` and `NotebookEdit` runs `adapter_guard` of the Harness core through the project's launcher. Its command line is:

```sh
d="${CLAUDE_PROJECT_DIR:-$(git rev-parse --show-toplevel 2>/dev/null)}"; [ -x "$d/harness" ] || exit 0; exec "$d/harness" adapter_guard
```

It finds the launcher from the project root and not from the session's directory. Claude Code documents `CLAUDE_PROJECT_DIR` as "the project root where the session started" and exports it to hook commands. Other agents read `.claude/settings.json` too and run this hook; nothing says they set that variable, so the command falls back to the Git root, and it exits 0 when it finds no launcher. The launcher itself exits 0 for `adapter_guard` when it finds no core.

`adapter_guard` denies with exit status 2 ("Exit with code 2 to block the action") and writes the reason to standard error:

- a shell command that contains, as a shell word, the name of a reserved operation or of an operator command, in any position and behind any executable name, also inside `sh -c '...'`, `eval`, a command substitution or a pipeline;
- a shell command that runs `ssh-keygen` with `-Y sign`;
- a file-writing call whose target is one of the paths listed under the deny rules.

It allows everything else, including every write under `project-pack/`, `src/`, `tests/` and `infra/`, and a call whose target it cannot determine.

## What the shipped controls block

- The documented invocation of every decision and operator command, `./harness <name> ...`, in every permission mode. "Deny rules block in every mode, including `bypassPermissions`", and "If a tool is denied at any level, no other level can allow it", so a local or user setting cannot allow it again.
- The same names behind another executable or inside a compound command, through the hook: `../harness-core approve_pending`, `sh -c './harness approve_pending'`, `echo y | ./harness adopt_release`.
- `ssh-keygen -Y sign`, by a deny rule and by the hook.
- Claude Code's file tools (`Write`, `Edit`, `NotebookEdit`) on the governed directories, the provenance files, the launcher, `AGENTS.md` and the adapter files, by the deny rules and by the hook.

Beside these, the guard of the core itself (BRS Section 68.2) refuses a reserved operation or an operator command when `--adapter` is given, when the environment carries `CLAUDE_CODE_CHILD_SESSION` or `CLAUDECODE` and when no controlling terminal is available. Claude Code sets `CLAUDE_CODE_CHILD_SESSION` to `1` "in subprocesses Claude Code spawns via the Bash, PowerShell, and Monitor tools", and `CLAUDECODE` in every session (observed 2026-11-20). Because "IDE extensions also set this in their integrated terminals", an operator command typed in such a terminal is refused too (`GUARD_AGENT_CONTEXT`): run operator commands in a terminal that is not opened by Claude Code or its IDE extension.

## What they do not block

- **A file written by a shell command.** No control of any agent sees it. A deny rule for a path covers the file tools, "file commands Claude Code recognizes in Bash, such as `cat`, `head`, `tail`, `sed`, and `tee`", and redirection targets; it does not cover "arbitrary subprocesses that read or write files indirectly, like a Python or Node script that opens files itself". The hook does not look at where a shell command writes.
- **A command the text rules do not recognise.** A Bash rule "covers the invocation Claude usually produces and isn't a security boundary around the program". The hook reads the command line as a POSIX shell would and looks for the guarded names as words; a name that is assembled at run time (`n=approve; ./harness ${n}_pending`), read from a file, or hidden in an encoded string is not found.
- **A hook that does not run.** "On most events, when a hook fails or times out, Claude Code still carries out the action." The registration does not ask Claude Code to block on failure, because the same registration runs under other agents that deny every tool call when a hook fails. The deny rules do not depend on the hook.
- **A relative target in a session below the project root** is judged from the session directory and from the project root, and is denied under either reading. A write to `src/app/spec/x.ts`, given as `spec/x.ts` from a session in `src/app`, is therefore refused; Claude Code itself always passes absolute paths ("`tool_input.file_path` is always absolute"), so this does not arise with it.
- **Reading.** Nothing here restricts what Claude Code reads.

## Residual risk

The controls above stop an agent from recording a decision by following or misreading instructions. They are not authentication. Authentication is the signature of BRS Section 73: a decision record, an adoption record or a signer record takes effect only with a signature by a key enrolled for the approver, and the core checks that signature whenever it reads the record. What remains is a condition on the operator's side:

1. **A key the agent can use.** A private key without a passphrase, or a key in an SSH agent that signs without asking, can be used by any process of the same user, Claude Code included. The CLI refuses a private key file with an empty passphrase; it cannot see how an SSH agent is configured. Use a key that needs you for every signature.
2. **A record written as a file.** Claude Code can write a file under `evidence/` with a shell command. Without a valid signature such a record satisfies no gate and is reported as an error.
3. **A confirmation typed by the agent.** The terminal confirmation of the core stops a mistake. With `CLAUDE_CODE_CHILD_SESSION` or `CLAUDECODE` set the core refuses before it asks, and without a signature the confirmation yields nothing.

## Not verified

- Whether Claude Code runs `PreToolUse` hooks in `bypassPermissions` mode. The deny rules are documented to hold there.
- Behaviour on Windows. The hook command is POSIX shell, which Claude Code runs through Git Bash; "On Windows without Git Bash, a shell-form `PreToolUse` or `PermissionRequest` command hook that fails with `onFailure` unset can instead block the tool call". No deny rule is shipped for the PowerShell spelling `.\harness.cmd <name>`; the hook covers the PowerShell tool.
- In this release round the files were checked against the documentation and by tests that run the hook's command line against a launcher. Claude Code itself is run against them in the acceptance scenario.
