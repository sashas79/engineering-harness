# Engineering Harness v0.4.0 — what the three agents' documentation says

**Status:** PROPOSED. Stage 1 evidence, revision 3 (after two rounds of independent review), for `BRS-CHANGES.md` Sections 68 to 70 and for decisions D-06, D-09 and D-14.

**Corrections of 2026-11-20 (package R6c).** The three agents' documentation was fetched again on 2026-11-20 (local copies, each with its URL and date, were kept in the core's Stage 2 working notes and removed when Stage 2 ended) and compared with this document. Each correction below is marked "[R6c correction, 2026-11-20; source: ...]". Statements not marked were found consistent with the pages, except where Section 7 says a point is still not established. The OpenAI Codex pages are now served at `developers.openai.com/codex/...` (the page text still links to `learn.chatgpt.com/docs/...`); the Copilot CLI pages are the `github/docs` sources of the pages named below.

**How this was checked.** Every statement below is taken from the vendor's own documentation or source, read from copies fetched on 2026-11-12. They were not re-fetched on 2026-11-13. A second reader then checked each quotation and table cell against the same copies; five statements were corrected as a result. The pages are: OpenAI's Codex documentation at `learn.chatgpt.com/docs` and the `openai/codex` source at tag `rust-v0.167.2` (released 2026-11-11); GitHub's Copilot documentation at `docs.github.com/en/copilot`; the VS Code documentation sources (`microsoft/vscode-docs`, pages dated 11/11/2026); and the Claude Code documentation at `code.claude.com/docs`. Where a point rests on source code and not on documentation, it says so. Nothing here comes from memory, and several points contradict what v0.3.0 assumed.

## 1. Findings that change the design

1. **Agents read each other's files.** Copilot CLI and the Copilot cloud agent read `AGENTS.md`, `CLAUDE.md` and `GEMINI.md` as agent instructions, and read project skills from `.github/skills`, `.agents/skills` and `.claude/skills`. **Copilot CLI also reads custom commands from `.claude/commands/*.md`** [R6c correction, 2026-11-20; source: Copilot CLI command reference (`cli-command-reference.md`), saved copy of 2026-11-20]: "Commands are an alternative to skills stored as individual `.md` files in `.claude/commands/`. The command name is derived from the filename. Command files use a simplified format (no `name` field required) and support `argument-hint`, `description`, `allowed-tools`, and `disable-model-invocation`. Commands have lower priority than skills with the same name." It also reads `.claude/rules/**/*.md` as instructions, and `.claude/CLAUDE.md`. Claude Code reads `AGENTS.md` when there is no `CLAUDE.md`. Copilot CLI and the Copilot harness in VS Code read hook settings from `.claude/settings.json`, and hooks from all sources run. A file that says "you are the Claude Code adapter" will therefore be read by Copilot, and a hook shipped for Claude Code will also fire in Copilot, with a Claude-format payload. The adapter text must not say which adapter it is, and the hook handler must accept every format and give the same answer when run twice.
2. **One instruction file serves all three.** `AGENTS.md` is read by Codex, by Copilot Chat in VS Code, by Copilot CLI, by the Copilot cloud agent and by Claude Code. Claude Code reads it natively only when no `CLAUDE.md` exists and only from v2.1.277, and its documentation recommends a `CLAUDE.md` that imports it.
3. **Agent Skills are the common command format.** All three load a `SKILL.md` directory and let the user invoke it by name. Only the directory differs. Codex custom prompts are deprecated and were never repository-scoped.
4. **v0.3.0's Copilot "deny" does not deny.** The VS Code documentation says of `chat.tools.terminal.autoApprove`: "A `false` rule requires approval. It does not block the command." In Copilot harness sessions "the runtime can approve read-only commands or sandboxed commands before terminal approval rules are evaluated. These calls do not prompt, even with a matching `false` rule". The v0.3.0 README and Copilot contract say the agent "can never run these commands". That is not what the setting does.
5. **A pre-tool hook is the one blocking mechanism all three have**, and all three treat exit status 2 as a denial. Each needs something from the operator before a repository hook runs: Codex and Copilot CLI need the project or folder to be trusted, and Codex also a review of the hook; in VS Code hooks are a preview feature.
6. **The three differ on a hook that fails to run.** Claude Code and Codex let the tool call through; Copilot denies it. A hook that cannot find the core must therefore not fail.
7. **No agent's command-text control is a security boundary**, and each vendor says so. None of them sees a file written by a shell command.
8. **Only Claude Code documents a reliable marker of an agent-run command.** `CLAUDE_CODE_CHILD_SESSION`. `CLAUDECODE` is also set by IDE extensions in their integrated terminals, where a human types. Codex sets `CODEX_THREAD_ID` in its source but does not document it. Copilot documents none.

## 2. Project instruction file

| Agent | File | Source |
| --- | --- | --- |
| Codex | `AGENTS.md`, from the project root down to the working directory; `AGENTS.override.md` wins in its directory; combined size capped by `project_doc_max_bytes` (32 KiB by default) | `learn.chatgpt.com/docs/agent-configuration/agents-md` |
| Copilot | `.github/copilot-instructions.md`, `.github/instructions/**/*.instructions.md`, and agent instructions: `AGENTS.md` in VS Code Copilot Chat; `AGENTS.md`, `CLAUDE.md` or `GEMINI.md` in Copilot CLI and the cloud agent (Copilot CLI: in the Git root and the working directory; also `.claude/CLAUDE.md` and `.claude/rules/**/*.md`, and `.github/copilot-instructions.md` is read too) | `docs.github.com/en/copilot/reference/custom-instructions-support` |
| Claude Code | `CLAUDE.md`; `AGENTS.md` when no `CLAUDE.md`, `.claude/CLAUDE.md` or `CLAUDE.local.md` exists in the working directory or above; `@path` imports | `code.claude.com/docs/en/memory` |

Quotations:

- Codex: "Codex reads `AGENTS.md` files before doing any work." And: "Starting at the project root …, Codex walks down to your current working directory."
- Claude Code: "An `AGENTS.md` and a `CLAUDE.md` … in your working directory or above it | Your `CLAUDE.md` files only", and "Reading `AGENTS.md` directly requires Claude Code v2.1.277 or later. In some sessions Claude can't read `AGENTS.md`, so import it from a `CLAUDE.md` there instead."
- Copilot CLI "loads custom instructions from these locations simultaneously (all are merged)" (`cli-command-reference`, "Custom instructions locations"; `custom-instructions-cli`: "does not define a general precedence order between these files"), supports `@path` imports in `AGENTS.md` and `CLAUDE.md`, and "removes duplicate copies of identical … agent instructions".

- [R6c correction, 2026-11-20; source: `cli-command-reference.md`, "Repository custom instructions for subagents"] A custom agent that Copilot CLI runs as a subagent "doesn't receive repository instruction files (`copilot-instructions.md`, `AGENTS.md`, `CLAUDE.md`) by default"; only `include-custom-instructions: true` in the agent's front matter opts in. The Harness block of `AGENTS.md` therefore does not reach a subagent that Copilot starts through its `task` tool.

**Design consequences.**

- The project instructions are rendered into `AGENTS.md`. The `claude-code` overlay adds a `CLAUDE.md` that is exactly one line importing it. Copilot CLI reads both; because the expanded `CLAUDE.md` is identical to `AGENTS.md`, it is one copy after de-duplication. Stage 2 verifies this with Copilot's `/instructions`.
- `.github/copilot-instructions.md` is dropped: every supported Copilot surface reads `AGENTS.md`, and a second file is a second copy to keep in step.
- A project needs a place for its own guidance that all three agents read. A nested file such as `src/AGENTS.md` is not that place: Claude Code ignores it once a root `CLAUDE.md` exists, and Codex reads only from the root down to the working directory, which is the root. So the Harness owns a marked block inside `AGENTS.md` and nothing else in that file (decision D-09).

## 3. Reusable commands

| Agent | Mechanism | Repository location | How the operator invokes it | Source |
| --- | --- | --- | --- | --- |
| Codex | Agent Skills | `.agents/skills/<name>/SKILL.md`, scanned from the working directory up to the repository root | `$bootstrap status`, or `/skills` | `learn.chatgpt.com/docs/build-skills` |
| Codex | Custom prompts | none: `~/.codex/prompts` only | `/prompts:name` | `learn.chatgpt.com/docs/custom-prompts` |
| Copilot | Agent Skills | `.github/skills`, `.agents/skills` or `.claude/skills` | `/bootstrap status` | `docs.github.com/en/copilot/how-tos/copilot-cli/customize-copilot/add-skills`, `…/reference/copilot-cli-reference/cli-command-reference` |
| Copilot | Custom commands (alternative skill format) [R6c correction, 2026-11-20] | `.claude/commands/<name>.md` | `/bootstrap status` | `cli-command-reference.md`, "Commands (alternative skill format)" |
| Copilot | Prompt files | `.github/prompts/*.prompt.md` | `/name` in VS Code | `docs.github.com/en/copilot/reference/customization-cheat-sheet` |
| Claude Code | Skills and commands | `.claude/skills/<name>/SKILL.md` or `.claude/commands/<name>.md` | `/bootstrap status` | `code.claude.com/docs/en/skills` |

Quotations:

- Codex: "Custom prompts are deprecated. Use skills", and "live in your local Codex home directory …, so they're not shared through your repository."
- Codex: "For repositories, Codex scans `.agents/skills` in every directory from your current working directory up to the repository root." Implicit use is turned off with `policy: allow_implicit_invocation: false` in the skill's `agents/openai.yaml`: "explicit `$skill` invocation still works."
- Copilot CLI: "To tell Copilot to use a specific skill, include the skill name in your prompt, preceded by a forward slash." And: "Skills are loaded from these locations in priority order (first found wins for duplicate names)", with `.github/skills/` first, then `.agents/skills/`, then `.claude/skills/`.
- GitHub's support table: prompt files are not supported on GitHub.com or in Copilot CLI; agent skills are supported in VS Code, GitHub.com and Copilot CLI.
- VS Code: "Skills can appear as slash commands in chat"; `disable-model-invocation: true` "require[s] manual invocation through the `/` slash command only". The skill `name` "Must match the parent directory name"; a wrong name makes the skill "silently fail to load". Its table of project skill locations gives `.github/skills/` for the Copilot harness, `.claude/skills/` for Claude and `.agents/skills/` for Codex.
- Claude Code: "Custom commands have been merged into skills. A file at `.claude/commands/deploy.md` and a skill at `.claude/skills/deploy/SKILL.md` both create `/deploy` and work the same way." And: "`.claude/commands/` is the older format and still works. It supports the same frontmatter except `name` and `paths`."

**Design consequence.** Each command is rendered three times with identical text:

| Adapter | Rendered as | Why this form |
| --- | --- | --- |
| `claude-code` | `.claude/commands/<name>.md` | Same paths as v0.3.0; takes `disable-model-invocation`. [R6c correction, 2026-11-20; source: `cli-command-reference.md`] Copilot CLI does scan `.claude/commands/` (as commands, below skills of the same name), so a project with only the `claude-code` adapter already offers `/bootstrap`, `/execute` and `/maintain` in Copilot CLI, and a project with `claude-code` and `copilot` shows each name from `.github/skills` first and `.claude/commands` second |
| `codex` | `.agents/skills/<name>/SKILL.md` and `agents/openai.yaml` | The only repository mechanism Codex has |
| `copilot` | `.github/skills/<name>/SKILL.md` | The one location both Copilot CLI and the Copilot harness in VS Code document. Prompt files would not work in the CLI |

With `codex` and `copilot` both installed, Copilot CLI finds each command in `.github/skills` and in `.agents/skills` and uses the first. The text is the same in both. With `claude-code` installed as well, a third copy sits in `.claude/commands`; the documentation gives skills priority over commands of the same name, so the order is `.github/skills`, `.agents/skills`, `.claude/commands`. [R6c correction, 2026-11-20]

The command names stay `bootstrap`, `execute` and `maintain`. In Codex the operator types `$bootstrap`, not `/bootstrap`. No built-in command or bundled skill of these names appears in the pages read.

## 4. Command permissions: what blocks and what only asks

| Agent and surface | Repository-committed control | Blocks or asks | Conditions and limits | Source |
| --- | --- | --- | --- | --- |
| Claude Code, all local surfaces | `permissions.deny` in `.claude/settings.json`, for shell commands and for file tools | Blocks | Holds in every permission mode, including `bypassPermissions`. "If a tool is denied at any level, no other level can allow it." Shell rules match command text: "isn't a security boundary around the program" (`sh -c '…'` and other forms are not matched) | `code.claude.com/docs/en/permissions`, `…/permission-modes` |
| Claude Code | `PreToolUse` hook in `.claude/settings.json` | Blocks (exit status 2) | A hook that exits otherwise or does not start lets the call through, unless it is registered with `"onFailure": "block"` (a failure then blocks like exit 2) [R6c correction, 2026-11-20; source: `claude/hooks.md`, "Block the action when a hook fails"; a timeout counts as a failure when set]. `permissions.md`: "PreToolUse hooks run before the permission prompt, for every tool except `EndConversation`"; whether hooks run in `bypassPermissions` mode is still not stated in as many words | `code.claude.com/docs/en/hooks` |
| Codex CLI, IDE extension | `prefix_rule(..., decision = "forbidden")` in `.codex/rules/*.rules` | Blocks: "Block the request without prompting" | "Rules are experimental and may change." "Project-local rules under `<repo>/.codex/rules/` load only when the project `.codex/` layer is trusted." A script that uses redirection, substitution, variables or wildcards is matched as one `bash -lc` invocation, so the rule does not see the command inside it | `learn.chatgpt.com/docs/agent-configuration/rules`; `codex-rs/core/src/exec_policy.rs` maps `Forbidden` to a refused execution |
| Codex | `PreToolUse` hook in `.codex/hooks.json` | Blocks (deny output or exit status 2) | "Project-local hooks load only when the project `.codex/` layer is trusted." "Non-managed hooks must be reviewed and trusted before they run." "A PreToolUse error, timeout, or malformed response can let the tool run." Hooks run with the session's working directory: "prefer resolving from the git root" | `learn.chatgpt.com/docs/hooks` |
| Copilot CLI | `preToolUse` hook in `.github/hooks/*.json` | Blocks. A hook error denies; a hook time-out lets the call through | Repository hooks load when the folder is trusted; in prompt mode (`-p`) only with `--trust-folder` or `GITHUB_COPILOT_PROMPT_MODE_REPO_HOOKS`; a user can set `disableAllHooks`. `--deny-tool` also blocks but is a launch option, not something a repository commits. [R6c correction, 2026-11-20; source: `hooks-reference.md`] Every hook source runs and the results combine (any `deny` blocks). A command `preToolUse` hook is fail-closed on exit 2, on a crash and on any other non-zero exit; only a timeout lets the call through. The CLI also reads the `hooks` and `disableAllHooks` keys of `.claude/settings.json` (not its `permissions`), and a hook there is a PascalCase `PreToolUse` with Claude matcher semantics and snake_case payload (`tool_name` as Claude's name: `bash` and `powershell` are `Bash`, `create` is `Write`, `edit` and `apply_patch` are `Edit`) | `docs.github.com/en/copilot/reference/hooks-reference`, `…/reference/copilot-cli-reference/cli-command-reference`, `…/how-tos/copilot-cli/use-copilot-cli/allowing-tools` |
| Copilot in VS Code | `chat.tools.terminal.autoApprove` | Asks only, and not always (finding 4) | **Allow all** and **Autopilot** skip the prompt | `code.visualstudio.com/docs/agents/run/approvals` |
| Copilot in VS Code | `.github/hooks/*.json` | Blocks | Hooks are a preview feature of VS Code. The Copilot harness loads them without a setting; the older Local harness needs `chat.useHooks` | `code.visualstudio.com/docs/agent-customization/hooks`; GitHub's support table marks hooks "P" for VS Code |
| Copilot cloud agent | `.github/hooks/*.json` on the default branch | Blocks; `ask` is treated as deny | Not a supported surface in v0.4.0 | `docs.github.com/en/copilot/how-tos/copilot-on-github/customize-copilot/customize-cloud-agent/use-hooks` |

**What enforces "an agent never records a decision", per agent:**

- **Claude Code:** the shipped deny rules and hook block the documented invocation in every mode, and the deny rules also block its file tools on the evidence directories. The core guard (BRS Section 68.2) refuses on `CLAUDE_CODE_CHILD_SESSION`, which Claude Code sets for every command it runs, and on the absence of a terminal.
- **Codex:** the shipped rules and hook block once the operator has trusted the project's `.codex/` layer and reviewed the hook. Until then nothing on the Codex side blocks. The core guard refuses on `CODEX_THREAD_ID` (set in source, not documented) and asks for a terminal confirmation. Codex can give a command a terminal and type into it, so the confirmation stops a mistake and not a deliberate act.
- **Copilot CLI:** the shipped hook blocks once the folder is trusted. No session marker is documented, so the core guard has only the terminal confirmation, which the CLI's shell tool could answer.
- **Copilot in VS Code:** the hook blocks where the preview feature is available. Otherwise nothing on the Copilot side blocks; the auto-approve setting at best asks. The core guard has only the terminal confirmation.

So instructions alone are never the only barrier against the decision commands. They are the only barrier against one thing on every agent: a decision record written as a file by a shell command. That, and the confirmation an agent with a terminal could type, are the residual risk of decision D-06.

## 5. Environment of an agent-run command

| Agent | Marker | Status | Source |
| --- | --- | --- | --- |
| Claude Code | `CLAUDE_CODE_CHILD_SESSION=1` | Documented; set only by Claude Code for commands it spawns; from v2.1.172. [R6c correction, 2026-11-20; source: `claude/env-vars.md`] Set in the Bash, PowerShell and Monitor tools' subprocesses and also in hook commands and status-line commands, so `adapter_guard` itself runs with it set; an inherited value (a `screen` or background launcher first started by Claude's Bash tool) makes a genuine top-level session look nested | `code.claude.com/docs/en/env-vars` |
| Claude Code | `CLAUDECODE=1` | Documented, but "IDE extensions also set this in their integrated terminals". [R7f, RUL-59, 2026-11-20] Observed set in every Claude Code session; now a built-in marker and in the manifest beside `CLAUDE_CODE_CHILD_SESSION`, so an operator command typed in a terminal of the IDE extension is refused too | same |
| Codex | `CODEX_THREAD_ID`, `CODEX_SANDBOX`, `CODEX_SANDBOX_NETWORK_DISABLED` | In source only. The public page lists "stable public environment variables" and names none of these (re-checked 2026-11-20: `environment-variables.md` lists `CODEX_HOME`, `CODEX_SQLITE_HOME`, installer, authentication and diagnostics variables only). `shell_environment_policy` (`inherit = all/core/none`, `filters`, `set`) decides which variables a command receives; whether Codex's own variables pass it is not documented | `codex-rs/core/src/exec_env.rs`, `spawn.rs`; `learn.chatgpt.com/docs/config-file/environment-variables` |
| Copilot | none | No variable identifying an agent-run command is documented | searched the Copilot and VS Code documentation |

Sandboxes and the launcher:

- **Codex:** in the default `workspace-write` policy `.git`, `.agents` and `.codex` are read-only, so Codex cannot modify its own skills, rules or hooks (confirmed: `approvals-security.md`, "Protected paths in writable roots"). [R6c correction, 2026-11-20] That reading outside the workspace is allowed is not stated on the pages read: they say commands "read accessible files", and mention "restricted read access" as a configurable policy. Whether `./harness` can run `../harness-core` under the default sandbox is to be shown in the acceptance run, not assumed.
- **Claude Code:** its sandbox, when on, also allows reading outside the working directory by default.
- **Copilot:** its local sandbox (off by default: `sandbox.enabled` is `false`) "is deny-by-default: unless a path is explicitly granted, a command cannot use it" (`understanding-local-sandboxing.md`; read access spans the repository, not its parent directory), and repository hooks run inside it [R6c, 2026-11-20: confirmed, `hooks-reference.md`, "Sandboxed sessions"]. With the sandbox on, the directory that holds the core and its release data must be granted for reading, or neither the commands nor the hook can run.

Hooks and the working directory. A hook registered as `./harness adapter_guard` fails when the session is not at the project root. Each registration therefore resolves the launcher from the project root by the means its agent documents (Claude Code's `CLAUDE_PROJECT_DIR`; the Git root for Codex; the `cwd` field for Copilot), and the launcher exits 0 for `adapter_guard` when it finds no core, because Copilot would otherwise deny every tool call.

One case follows from finding 1. Copilot also runs the hook registered in `.claude/settings.json`, and nothing in the Copilot or VS Code pages says it sets `CLAUDE_PROJECT_DIR`. A registration that relied on that variable alone would fail to start under Copilot, and Copilot would deny every shell and file-writing call in any project that has the `claude-code` adapter. The `claude-code` registration therefore falls back to the Git root and exits 0 when it finds no launcher.

## 6. Surfaces supported in v0.4.0

| Agent | Supported | Not supported in v0.4.0 | Reason |
| --- | --- | --- | --- |
| Claude Code | CLI, IDE extensions and desktop app, on a local checkout | Claude Code on the web, GitHub Actions | The core and its release directory live outside the repository and would have to be provisioned by a setup script; not built or tested |
| Codex | CLI and IDE extension, on a local checkout | Codex cloud; the ChatGPT desktop app is expected to work (it loads repository skills) and is untested | As above. Repository skills are available in cloud tasks, but the core is not |
| Copilot | Copilot CLI; the Copilot harness in VS Code (agent mode) | Copilot cloud agent; Visual Studio, JetBrains, Xcode, Eclipse | The cloud agent needs the core provisioned and has nobody at the gate. The other IDEs support skills and hooks partly or in preview and are untested |

"Supported" here means designed for. Stage 2 can run Claude Code. Codex and Copilot sessions need you; Stage 2 gives the steps and what to check.

## 7. Not established

Status after R6c (2026-11-20): the documentation fetched that day settles none of the points below; it adds the three marked [R6c].

- Whether Claude Code runs `PreToolUse` hooks in `bypassPermissions` mode. Deny rules are documented to hold there.
- Whether Copilot sets any environment variable for the commands it runs.
- Whether Copilot sets or expands `CLAUDE_PROJECT_DIR` when it runs a hook from `.claude/settings.json`. Stage 2 checks this before step 4 of the acceptance scenario.
- Which argument carries the target path in Copilot's file tools. Its hooks reference types the tool arguments as unknown. Until this is known, `adapter_guard` cannot deny a Copilot file write and allows it.
- Whether the shell tool of each agent gives a command a controlling terminal. The Codex documentation describes a unified exec tool with `write_stdin`, which implies it can.
- Whether Copilot CLI really reduces `CLAUDE.md` plus `AGENTS.md` to one copy when the first only imports the second. The documentation says identical copies are removed; Stage 2 checks.
- Behaviour on Windows. The launcher has a `harness.cmd`, and each agent's Windows shell handling is not verified.
- [R6c, 2026-11-20] Whether a Copilot hook or a Copilot file tool runs inside a subagent that Copilot starts (the subagent does not receive `AGENTS.md` by default). The hooks reference does not say.
- [R6c, 2026-11-20] Whether `CODEX_THREAD_ID` survives `shell_environment_policy.inherit = "core"` or `"none"`.
- [R6c, 2026-11-20] Whether the Codex default sandbox lets a command read `../harness-core` outside the workspace.
- [Acceptance, 2026-11-20] Codex in VS Code (the IDE extension), used for one hand-over leg: it ran `./harness`, and so `../harness-core` outside the workspace, in its local mode, with whatever sandbox setting that mode had; it read `.agents/skills`. Whether it loads `.codex/rules` and `.codex/hooks.json` and whether it sets `CODEX_THREAD_ID` is not established.
- [Acceptance, 2026-11-20] Copilot in VS Code, used for the last hand-over leg: it read `.github/skills` (`/execute`), called `./harness` with `--adapter copilot` and completed the run. Whether it ran the repository hook is not established.
- [Acceptance, 2026-11-20] Claude Code headless (`claude -p`, 2.1.327) in a folder never trusted: the project's `permissions.allow` entry is dropped (stderr: "this workspace has not been trusted"), the 43 deny rules and the `PreToolUse` hook still apply (debug log: hook ran on every Bash call, exit 0 or 2).
- [R6c, 2026-11-20] The VS Code pages cited in Sections 3 and 4 (`code.visualstudio.com`, `microsoft/vscode-docs`) were not fetched again; every statement about VS Code stands as of 2026-11-12.
