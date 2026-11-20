# Deterministic core integration

This distribution package supplies the compiled Harness core for four platforms (`harness-core-<platform>`) but intentionally does **not** hold its source: the Harness core implementation is merged and built separately.

Merge the already implemented v0.4.0 core (`src/`, package/build files, tests, and generated `dist/` as appropriate) into this repository's build. The core must continue to implement the supplied BRS 2.0 (`docs/v0.4.0/BRS.md`), schemas, canonicalisation contract, signature vectors, and contract tests without redefining them. It implements core contract 2, which `harness/harness.yaml` declares.

The distribution boundary supplied here provides:

- Harness release contracts/catalogues, including the execution and maintenance workflows and the gates for task dispositions and registered changes;
- clean project and Project Engineering Pack templates;
- the adapter manifest (`adapters/adapters.yaml`), the one authored text of the adapter commands (`adapters/source/`), and the rendered overlays for Claude Code, OpenAI Codex CLI and GitHub Copilot CLI with the shared `AGENTS.md` and the `harness` launcher (`adapters/*/overlay/`, `adapters/common/overlay/`);
- the adapter files of v0.3.0 (`adapters/adoptable/v0.3.0/`), which `adopt_release` uses to recognise an unedited v0.3.0 project; and
- the `init` command of the core, which installs the exact release locally and creates a new project shell (`./harness-core init --target <dir> --version v0.4.0`).
