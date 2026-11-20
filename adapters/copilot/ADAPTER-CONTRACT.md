# GitHub Copilot adapter contract — Engineering Harness v0.4.0

The `copilot` adapter lets GitHub Copilot work in a project governed by the Engineering Harness. It presents what the deterministic Harness core returns and performs the operations the core offers. It defines no lifecycle state, no validation, no approval and no next action of its own.

This contract is never copied into a project. The statements about Copilot are quoted from GitHub's documentation at `docs.github.com/en/copilot` and from the VS Code documentation at `code.visualstudio.com/docs`, read from copies saved on 2026-11-12. Copilot was not run against these files in this release round; the section "Not verified" lists what follows from that.

## Supported surfaces

| Surface | Supported in v0.4.0 |
| --- | --- |
| Copilot CLI, on a local checkout | Yes |
| The Copilot harness in VS Code (agent mode), on a local checkout | Yes. Hooks are a preview feature of VS Code |
| Copilot cloud agent | No. The core would have to be provisioned there, and nobody is at the gate |
| Visual Studio, JetBrains, Xcode, Eclipse | No. They support skills and hooks partly or in preview and are untested |

"Supported" means designed for. The project root must be the root of the Git repository: Copilot CLI loads `AGENTS.md` "In Git root and cwd", and repository hooks from "`.github/hooks/*.json` in the repository root".

## What changed from v0.3.0

The v0.3.0 adapter shipped `.github/copilot-instructions.md`, two prompt files under `.github/prompts/` and `.vscode/settings.json`. v0.4.0 ships none of them:

- every supported Copilot surface reads `AGENTS.md`, so a second instruction file would be a second copy to keep in step;
- prompt files do not work in Copilot CLI, and skills are slash commands in the CLI and in VS Code;
- the terminal auto-approve setting never blocked. The VS Code documentation says of it: "A `false` rule requires approval. It does not block the command."

`adopt_release` replaces or removes the v0.3.0 files when they are as `init` wrote them.

## Adapter files

`init --adapters`, `adapter_add` and `adapter_sync` install these files. Each is byte-identical to the release file, and none holds a value specific to a project or a machine.

| File | What it is | Documentation relied on |
| --- | --- | --- |
| `AGENTS.md` (managed block, shared with the other adapters) | The project instructions, between the lines `<!-- engineering-harness:begin -->` and `<!-- engineering-harness:end -->`. Everything outside the block is the project's | `docs.github.com/en/copilot/reference/copilot-cli-reference/cli-command-reference`: "Copilot CLI loads custom instructions from these locations simultaneously (all are merged)", with `AGENTS.md` among them |
| `.github/skills/bootstrap/SKILL.md`, `execute/SKILL.md`, `maintain/SKILL.md` | The three commands as Agent Skills. The text is the same as in every other adapter; the front matter is `name`, `description`, `argument-hint` and `disable-model-invocation: true` | The same page, "Skill frontmatter fields": `name` "Max 64 characters", `description` "Max 1024 characters", `disable-model-invocation` "Prevent the agent from automatically invoking this skill"; and `code.visualstudio.com/docs/agent-customization/agent-skills`: the name "Must match the parent directory name" |
| `.github/hooks/engineering-harness.json` | The registration of the `preToolUse` hook | `docs.github.com/en/copilot/reference/hooks-reference`; `code.visualstudio.com/docs/agent-customization/hooks` |
| `harness`, `harness.cmd` (shared) | The launcher. It finds the core: `ENGINEERING_HARNESS_CORE`, then `harness-core` beside the project directory, then `harness-core` on the search path | BRS Section 69.4 |

The operator types `/bootstrap status`, `/bootstrap`, `/bootstrap rework <instruction>`, `/execute status`, `/execute [TASK-id]`, `/maintain status`, `/maintain <statement>`, `/maintain`, `/maintain rework <instruction>` and `/maintain abandon <CHG-id>`.

**Copilot also reads the files of the other adapters.** When they are installed in the same project:

- It finds each command again in `.agents/skills/` and uses its own: "Skills are loaded from these locations in priority order (first found wins for duplicate names)", with `.github/skills/` first. It also reads `.claude/commands/`: "Commands have lower priority than skills with the same name." The text is the same in all of them.
- It reads `CLAUDE.md` as well as `AGENTS.md`. `CLAUDE.md` only imports `AGENTS.md`, and Copilot CLI "removes duplicate copies of identical ... agent instructions".
- It runs the hook that `.claude/settings.json` registers: "Cross-tool `.claude/settings.json` and `.claude/settings.local.json` files in the repository are also read", and "When the same event appears in multiple sources, all hook entries from all sources are run." `adapter_guard` then runs twice for one call and gives the same answer both times.

`.github/hooks/engineering-harness.json` belongs to the Harness as a whole file. A project's own hooks go into other files of `.github/hooks/`.

## What the operator does once

1. Have a core the launcher can find: place `harness-core` beside the project directory, or put it on the search path, or set `ENGINEERING_HARNESS_CORE` in the environment Copilot is started from. No adapter file names the location of the core.
2. Trust the folder in Copilot CLI. Repository hooks load only then. Read `.github/hooks/engineering-harness.json` first: it is a command the repository supplies.
3. In prompt mode (`copilot -p`), pass `--trust-folder` ("Trust the working directory's hooks, workspace MCP servers, and repository plugin settings for one new non-interactive session") or set `GITHUB_COPILOT_PROMPT_MODE_REPO_HOOKS` ("Set to `true` to load repository hooks in prompt mode"). Without one of them the hook does not load in prompt mode.
4. With Copilot's local sandbox on, grant the directory that holds the core and its release data for reading. "The sandbox is **deny-by-default**: unless a path is explicitly granted, a command cannot use it", and "command hooks from the repository, your user settings, and plugins run inside it". Without the grant neither the commands nor the hook can run the core.
5. Do not set `disableAllHooks` for the repository.
6. Run `./harness check_adapters --project-root .` after an update of Copilot or of the Harness.

## The shipped controls

**Hook.** One `preToolUse` hook, registered without a matcher so that it runs before every tool, runs `adapter_guard` of the Harness core through the project's launcher. Copilot's file tools are named differently on its surfaces; the guard decides which calls it judges.

```json
{
  "type": "command",
  "bash": "d=.; [ -x ./harness ] || d=\"$(git rev-parse --show-toplevel 2>/dev/null)\"; [ -x \"$d/harness\" ] || exit 0; exec \"$d/harness\" adapter_guard",
  "powershell": "(the same steps for PowerShell and harness.cmd)",
  "cwd": ".",
  "timeoutSec": 30
}
```

It finds the launcher from the repository root and not from the session's directory, through the `cwd` field of the registration: "Working directory for the command (relative to repository root or absolute)". When the command is started elsewhere it falls back to the Git root. It exits 0 when it finds no launcher, and the launcher exits 0 for `adapter_guard` when it finds no core. This matters for Copilot more than for the other agents, because "Command `preToolUse` hooks are **fail-closed** on errors—a crash or non-zero exit (including exit `2`) denies the tool call": a hook that failed for want of a core would deny every tool call.

`adapter_guard` denies with exit status 2 ("For `permissionRequest` and `preToolUse`, exit `2` is treated as a deny") and writes the reason to standard error:

- a shell command (`bash`, `powershell`) that contains, as a shell word, the name of a reserved operation (`record_specification_decision`, `record_architecture_decision`, `record_work_decision`, `record_task_decision`, `record_change_decision`, `approve_pending`, `reject_pending`) or of an operator command (`adopt_release`, `enrol_signer`, `revoke_signer`, `trust_signers`, `adapter_add`, `adapter_remove`, `adapter_sync`), in any position and behind any executable name;
- a shell command that runs `ssh-keygen` with `-Y sign`;
- a file-writing call (`create`, `edit`, `str_replace_editor`, `apply_patch`, and `Write` or `Edit` as Copilot names them for a hook registered as `PreToolUse`) whose target lies in a governed directory (`spec/`, `architecture/`, `engineering/`, `ai/`, `work/tasks/`, `work/state/`, `baselines/`, `evidence/`) or is `work/execution-graph.yaml`, a provenance file, the launcher, `AGENTS.md` or an adapter file.

It reads both payload formats of the hooks reference: `toolName` with `toolArgs` as JSON text, and `tool_name` with `tool_input`. It allows everything else, including every write under `project-pack/`, `src/`, `tests/` and `infra/`, and a call whose target it cannot determine.

Copilot CLI denies a call when a `preToolUse` command hook exits with any status other than 0 or 2 ("a non-zero exit (other than exit 2) denies the tool call"). `adapter_guard` and the launcher therefore exit with 0 or 2 only, whatever fails: input that is not a tool call is denied; a project it cannot read is judged with the overlay paths of the core's own release; after an internal error the command line is read as plain text for the guarded names; a missing core, or a core that crashes or cannot start, allows the call (BRS Sections 68.3 and 69.4).

## What the shipped controls block

Once the folder is trusted:

- Every decision and operator command in a shell tool call, in Copilot CLI and, where hooks are available, in the Copilot harness in VS Code.
- `ssh-keygen -Y sign` in a shell tool call.
- A file tool call on the governed directories, the provenance files, the launcher, `AGENTS.md` and the adapter files, when the call names its target in an argument the guard knows: `path`, `file_path`, `filePath`, or a patch in the `apply_patch` format.

Beside these, the guard of the core itself (BRS Section 68.2) refuses a reserved operation or an operator command when `--adapter` is given and when no controlling terminal is available, and asks for a confirmation on the terminal. Copilot documents no environment variable that marks a command it runs, so the core cannot recognise a Copilot session by its environment.

## What they do not block

- **Anything, before the folder is trusted**, in prompt mode without the opt-in, or when hooks are disabled. Copilot ships no deny rule a repository can commit: `--deny-tool` is a launch option.
- **A file written by a shell command.** No control of any agent sees it.
- **A file tool call whose target the guard cannot find.** The hooks reference types the tool arguments as `unknown`. GitHub's SDK pages use `path` for the file tools, and the guard reads that; if a surface names the argument differently, the call is allowed. This is the weakest point of this adapter.
- **A hook that times out.** "Timeouts are always fail-open": the call then goes through the normal permission flow.
- **A missing or broken core.** The launcher then exits 0 and the call goes through the normal permission flow, as on a timeout.
- **A name the guard cannot see.** The hook reads the command line as a POSIX shell would and looks for the guarded names as words; a name that is assembled at run time or read from a file is not found.
- **A relative target in a session below the project root** is judged from the session directory and from the project root, and is denied under either reading; start Copilot in the project root, as the commands assume.
- **Reading.** Nothing here restricts what Copilot reads.

## Residual risk

The controls above stop an agent from recording a decision by following or misreading instructions. They are not authentication. Authentication is the signature of BRS Section 73: a decision record, an adoption record or a signer record takes effect only with a signature by a key enrolled for the approver, and the core checks that signature whenever it reads the record. What remains is a condition on the operator's side, and it weighs more for Copilot than for the other agents because the core has no session marker to refuse on:

1. **A key the agent can use.** A private key without a passphrase, or a key in an SSH agent that signs without asking, can be used by any process of the same user, Copilot included. The CLI refuses a private key file with an empty passphrase; it cannot see how an SSH agent is configured. Use a key that needs you for every signature.
2. **A record written as a file.** Copilot can write a file under `evidence/` with a shell command. Without a valid signature such a record satisfies no gate and is reported as an error.
3. **A confirmation typed by the agent.** If the shell tool gives a command a terminal, Copilot could answer the confirmation of the core. Without a signature the confirmation yields nothing.

## Not verified

- Copilot was not run in this release round. The acceptance scenario runs Copilot CLI against these files: `/bootstrap status`, `/maintain status`, `/execute status` and one complete `/execute`.
- Which argument carries the target path in each file tool of each surface.
- Whether Copilot sets or expands `CLAUDE_PROJECT_DIR` when it runs the hook of `.claude/settings.json`. That registration does not depend on it.
- Whether Copilot CLI reduces `CLAUDE.md` plus `AGENTS.md` to one copy; check with `/instructions`.
- Whether the Copilot harness in VS Code applies the `cwd` field as the CLI does. The command falls back to the Git root.
- Behaviour on Windows. The `powershell` command of the registration was written from the documentation and not run.
