# Engineering Harness v0.4.0: Stage 2 report

Date: 2026-11-20. Branch `v0.4.0` in the core checkout and in this repository, both committed at your request.
The adoption in the first acceptance clone is also committed, which you allowed.

## 1. Result

All four done criteria of the brief pass on a clone of mentor.

| # | Criterion | Result | Evidence |
| --- | --- | --- | --- |
| 1 | The clone adopts v0.4.0 with all three adapters and is `EXECUTION_READY` without re-approval | Met | `ADOPT-0001` and signer anchor `SGN-0001`, signed by you. All three baselines stayed current with `declared` assurance. `check_adapters` clean. The v0.3.0 core then refuses the project (`PROV_UNSUPPORTED`). |
| 2 | `/maintain` takes a change record and adds one task; the gate shows 16 definitions unchanged and one added; you approve | Met | `CHG-0002` (documentation, reach `work`). Candidate `CAND-WORK-0002`: artefacts 1 added, 1 changed (graph), 16 unchanged; items: task 16 unchanged, graph entry 16 unchanged. You approved it (`APR-WORK-0002`, signed). |
| 3 | Back to `EXECUTION_READY`; the new Work Baseline supersedes the old; the 15 finished tasks stay finished; TASK-16 deferred by your decision | Met | `WORK-0002` supersedes `WORK-0001`, current, `signed`. 15 done. TASK-16 `deferred` by `DEC-0002`. Its acceptance criteria are reported as open by disposition, not dropped. |
| 4 | The new task is started with one agent, continued with a second and finished with a third; apart from the adapter named on each state write, the result matches a single-agent run | Met, with Codex and Copilot run in their VS Code extensions, not their CLIs (section 4) | `RUN-0001` of TASK-17: `started` and `progress` by `claude-code`, `resumed` and `progress` by `codex`, `resumed` and `completed` by `copilot`. Compared with a single-agent run of the same task on a copy: `list_tasks`, `inspect_project` and `check_maintenance` return identical JSON (0 differences each). The run records agree on every member BRS 64.7 compares. |

You also asked for the commit made outside the Harness on 2026-11-12 (`f6e07ec`) to be brought under control
without disturbing the 15/16 state. It is recorded as the registered change `CHG-0001` (TASK-02, 7 paths, reach
`none`), and you accepted it (`DEC-0001`). TASK-02 stays done, with the note that a registered change you accepted
changed its deliverables.

## 2. What was built

- **Core (contract 2):**
  - change records and revisions in the maintenance regime;
  - runtime state with runs under `work/state/<TASK>/RUN-nnnn.yaml`, and hand-over between agents;
  - task dispositions and registered changes;
  - `permitted_operations` on every result;
  - release adoption from v0.3.0 without re-approval;
  - signed human decisions (SSH signatures, a signer chain, a trust file per machine);
  - the CLI guard for decisions and operator commands, and the tool-call guard `adapter_guard`;
  - the launcher `./harness`.
- **Release data (this repository):**
  - VERSION v0.4.0, core contract 2, adoptable from v0.3.0;
  - the schemas, gates, workflows and adapters;
  - BRS 2.0 and the contract-test annex;
  - four binaries.
- **Adapters:** Claude Code, Codex and GitHub Copilot, each with `bootstrap`, `execute` and `maintain` rendered from one source, plus its own enforcement files. They install side by side.
- **Documentation:** README, CORE-INTEGRATION, BRS 2.0, BRS-CHANGES, contract tests, AGENT-SURFACES and DECISIONS.

### Fixes after the acceptance run (round R8)

| Fix | Change |
| --- | --- |
| 1 | New form `maintain register <statement>` in all three agents (BRS 70.4 gains one sentence). It lists the changed paths from the commits you name, proposes the kind and the finished Work Items it touches for you to confirm, calls `open_change --registered`, and shows you the `record_change_decision` command. |
| 2 | README and AGENT-SURFACES: headless Claude Code in a folder never trusted; what is and is not known about the Codex VS Code extension; one troubleshooting entry. |
| 4 | The header comment of a decision on a registered change no longer speaks of a Work Item. |

Fix 3 (refuse an agent before reading the flags) was withdrawn: every decision and operator command already does
this. See section 4.

### Your decisions on the four questions from the run (rulings RUL-62 to RUL-65)

You answered yes to each. All four are built, tested and written into the BRS.

| Ruling | Change | BRS |
| --- | --- | --- |
| RUL-62 | An acceptance note may name a change record's acceptance statement (`CHG-0002-AC-01`). `complete_task` refuses a note naming a criterion that neither the specification nor a change record defines (`VALIDATION_FAILED`, nothing written). | 64.4 |
| RUL-63 | On a project under v0.4.0, the pending gate names its `authority` and, as `approver`, the identity the Pack assigns to it. The adapters fill the decision command from it. A v0.3.0 result is unchanged. | 63.4 |
| RUL-64 | `check_maintenance` no longer lists a path under `outside_run` while a run that reported it is still open. | 66.5 |
| RUL-65 | `adopt_release` on a folder that does not exist says so (`REPO_REQUIRED_PATH_MISSING`), before it installs anything. | 67.2 |

## 3. Verified by running it

- **Core tests:** `tsc` clean; full suite 110 files and 1722 tests passed, 1 skipped (the same skip as before Stage 2). This was run after the last change.
- **v0.3.0 behaviour:** a differential run against the real v0.3.0 binary made 1051 comparisons with 0 differences.
- **Release consistency:** the release manifest is regenerated and checked (70 normative files). The adapters and schemas in this repository are identical to the core's fixture, and `docs/v0.4.0/BRS.md` is identical to the core's `BRS.md`.
- **Binaries:** compiled by bun 1.4.4 against the bun 1.4.1 runtime, the one the v0.3.0 binaries embed. With the 1.4.4 runtime the Linux and Windows binaries were over GitHub's 100 MB file limit. The runtime is almost all of the size; the core's own code is about 1.3 MB. Size in bytes and SHA-256:

  | File | Bytes | SHA-256 |
  | --- | --- | --- |
  | `harness-core-macos-arm64` | 63630434 | `b01dce63afbf53d671870261bef785d6539a23194e8190642b55b58072ef23d4` |
  | `harness-core-macos-x64` | 70643936 | `b2104dfc74473fcb45c8e2589c1fd95517caf6edded41a16ac39888e025881be` |
  | `harness-core-linux-x64` | 82687456 | `cb15b7b87429287a38bc72ccad6b63541f0f6d37b4a2287532a3a927979a1070` |
  | `harness-core-win-x64.exe` | 87481856 | `e820087aa50da16ef3a442a5902b656ded48ec8a7669e2441db76722a5752a28` |

  The macOS arm64 build was compared with the 1.4.4 build of the same commit. Byte-identical results: 8 read operations and `check_adapters` on the acceptance clone, and 4 guard decisions. Identical project tree and result: `init` with all three adapters. Identical result and record apart from timestamps and digests: `open_change`. Not compared: signing through the CLI, which needs a terminal.

- **Smoke test of the macOS arm64 binary:**
  - `init` with all three adapters, then `check_adapters` clean;
  - the guard refuses `record_change_decision` with exit 2 and allows `git show` with exit 0;
  - `init` without `--version` is refused with `INIT_VERSION_MISMATCH` (your ruling RUL-61).
- **Acceptance on a clone of mentor (`acceptance-v040/mentor`)**, the four criteria above:
  - Claude Code was run headless by me, on Sonnet.
  - Codex and Copilot were run by you, each in its VS Code extension.
  - Every decision and the adoption were recorded by you, in your own terminal.
- **Re-check on a fresh clone with the final release (`acceptance-v040b/mentor`):**
  - your `adopt_release` succeeded: `EXECUTION_READY`, all three adapters, `check_adapters` clean;
  - Claude Code then registered `f6e07ec` from a plain request, without being told the command form: it listed the 7 paths with `git show`, proposed the kind and the touched tasks, and asked before registering;
  - it named `sasha` as the approver.

  The registered change there awaits a decision; none is needed.

  The re-check ran on the release before rulings RUL-62 to RUL-65. Those four changes are covered by the test suite and the smoke test, not by another run on a clone.
- **Behaviour seen during the run:**
  - a mistyped passphrase writes nothing (`GUARD_SIGNING_FAILED`);
  - the CLI shows gate, digest, delta, signer and anchor before the typed confirmation;
  - the guard hook ran on every Claude Code tool call;
  - in a folder never trusted, headless Claude Code drops the project's allow rule but keeps the 43 deny rules and the hook.

## 4. Not verified, and known limits

- **The Codex CLI and the Copilot CLI.** Your acceptance order (D-09) named the three CLIs. The Codex leg ran in the Codex VS Code extension and the Copilot leg in Copilot in VS Code. Both read the installed adapter files and ran `./harness` with their own `--adapter`, and the hand-over result is the one criterion 4 asks for. Neither CLI was run.
- **The guard inside the two VS Code extensions.**
  - Codex: not established whether the extension loads `.codex/rules` and `.codex/hooks.json`, or whether it sets `CODEX_THREAD_ID`. It did start `../harness-core` outside the workspace in its local mode.
  - Copilot: not established whether the extension ran the repository hook `.github/hooks/engineering-harness.json`.
  - No agent in either extension was asked to run a decision command. The check `./harness approve_pending --project-root .` was run by you in a terminal, where the usage text is the expected answer. With `CODEX_THREAD_ID` set, the core refuses that command with `GUARD_AGENT_CONTEXT` (checked by me).
- **Copilot details:** not checked whether it listed `/execute` twice, or whether it delegated to a subagent.
- **Platforms:** Windows not run (`harness.cmd` untested). The macOS x64 binary not run (no Rosetta here). The Linux binary not run.
- **Keys:** hardware keys and keys held in an SSH agent not tested. Only your passphrase-protected key file and the committed fixture keys were used.
- **Not observed:** Copilot `CLAUDE_PROJECT_DIR` handling; Codex sandbox reads in the CLI's default policy; Copilot subagent hooks.
- **Pre-v0.4.0 CLI tests:** the tests that predate v0.4.0 and record a decision through the CLI pass through a simulated operator terminal (`test/support/cli.ts`). They meet the guard's conditions 3 and 5; they do not test them.
- **Guard limits that text matching cannot close:** a name computed at run time, a script written and then executed, a shell write to a reserved path, and signing by another program. The CLI guard and the signature itself stop these; the tool-call guard does not.
- **What headless Claude Code did that was denied.** On Sonnet, the agent's exploratory shell commands included:
  - calling `../harness-core` directly instead of `./harness`;
  - one command that ended in `ls ~/.ssh`.

  Claude Code's permissions denied all of them, and none ran. In an interactive session each would have been a prompt for you to refuse.

## 5. Decisions

### Decided after the report (2026-11-20)

The four questions from the acceptance run are decided and built (section 2). You confirmed these as built; the
BRS table of decisions now marks each one confirmed:

| Item | Decision |
| --- | --- |
| RUL-52 (DD-4) | Without a valid adoption record the carried v0.3.0 baselines are invalid and stale. CT-175 says so; the Stage 1 contract-test document is aligned. |
| RUL-47 | A second anchor for the same project root on this machine: the record stands, and you are told on stderr only. |
| RUL-48 | BRS 73.3 item 5 on subject decisions: after the Pack moves an authority to another identity, earlier dispositions by the former identity have no effect and are reported. |
| RUL-57 | `adopt_release` installs the target release before showing the summary; a refused or abandoned adoption leaves it installed beside the project. |
| F-1, D-19 | Any enrolled identity that holds an authority in the Pack may sign an adoption record. |
| D-21 | A lost key: no recovery. Enrol a second key; the core warns while there is only one. |
| D-22 | A passphrase or a hardware key is required. A key loaded into an SSH agent that signs silently is your risk. |
| D-23 | The typed confirmation is kept. |

### Decided 2026-11-23

| Item | Decision |
| --- | --- |
| D-20 | Option (a), as built: the signer anchor is trusted on first use, and each machine keeps a trust file. You accept the SSH-style residual risk for v0.4.0. Two gaps remain: a machine that never accepted the anchor relies on a person checking the fingerprint, and an agent without a sandbox can write the trust file. Option (c), an anchor published outside the machine, is the next step if that risk becomes too much. It is not designed. |

No decision is open.

The 15 `INIT_*` issue codes are used by the core but not defined in the BRS text.

## 6. Tests that predate v0.4.0 and changed

| File | Change | Why |
| --- | --- | --- |
| `test/contract/m-manifest-guard.test.ts` | Compares the manifest with the normative files on disk instead of a hard-coded count of 56 | The release adds normative files; the count was the only thing that broke |
| `test/e2e/init.test.ts` | `r.result.adapter` read as `r.result.adapter!` (two lines) | The member became optional in the result type; no assertion changed |
| `test/unit/release.test.ts` | The count of 49 schemas reads the v0.3.0 schema folder | The v0.4.0 release has more schemas; the v0.3.0 count still holds |

The test support files (`test/support/*`) were extended, and every other changed or new test file belongs to v0.4.0.

## 7. Cost

Subagent tokens per round, where recorded:

| Round | Tokens | Duration |
| --- | --- | --- |
| R5b finish | 161k | |
| R6a, BRS 2.0 | 309k | |
| R6b, release | 115k | |
| R7r, review | 442k | |
| R6c, docs | 217k | |
| R7f, fixes | 259k | |

The earlier rounds (R1 to R4i) were not recorded per round. The headless Claude Code runs of the acceptance, on Sonnet, cost about $2.51 in total. R8 ran in the main session.

## 8. Left to do

- The core's working notes folder `.stage2/` (logs, briefs, hand-over notes, saved documentation pages) was deleted at your request after this report; the figures above are copied from it.
- If the trust-on-first-use risk of D-20 becomes too much, design option (c): an anchor published outside the machine.
