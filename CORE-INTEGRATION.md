# Deterministic core integration

This distribution package intentionally does **not** recreate the deterministic Harness core implementation.

Merge the already implemented v0.3.0 core (`src/`, package/build files, tests, and generated `dist/` as appropriate) into this repository. The core must continue to implement the supplied BRS, schemas, canonicalisation contract, and contract tests without redefining them.

The distribution boundary supplied here provides:

- Harness release contracts/catalogues;
- clean project and Project Engineering Pack templates;
- Claude Code adapter files; and
- `harness-init.sh`, which installs the exact release locally and creates a new project shell.
