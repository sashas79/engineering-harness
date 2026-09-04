#!/usr/bin/env bash
set -euo pipefail

REPO_URL="https://github.com/sashas79/engineering-harness.git"
DEFAULT_VERSION="v0.3.0"
DEFAULT_ADAPTER="claude-code"
SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd -P)"

usage() {
  cat <<USAGE
Usage:
  $0 <target-directory> [version] [adapter] [harness-root]

The Harness root may also be supplied through ENGINEERING_HARNESS_ROOT.
No implicit home-directory/default registry is selected.

Examples:
  $0 ecommerce-platform v0.3.0 claude-code "$HOME/.engineering-harness"
  ENGINEERING_HARNESS_ROOT="$HOME/.engineering-harness" \\
    $0 ecommerce-platform v0.3.0 claude-code

What this command does:
  1. obtains the exact requested Engineering Harness release;
  2. installs its runtime contracts under <harness-root>/releases/<version>/;
  3. creates a clean project from project-template/;
  4. installs project-pack-template/ as <project>/project-pack/;
  5. overlays the selected adapter;
  6. writes the two v0.3.0 provenance files; and
  7. initialises the new project as an independent Git repository.

It does NOT complete project-specific Project Pack inputs and does NOT run
bootstrap_repository.
USAGE
  exit 64
}

TARGET="${1:-}"
VERSION="${2:-$DEFAULT_VERSION}"
ADAPTER="${3:-$DEFAULT_ADAPTER}"
HARNESS_ROOT="${4:-${ENGINEERING_HARNESS_ROOT:-}}"

[[ -z "$TARGET" ]] && usage
[[ "$#" -gt 4 ]] && usage
[[ -z "$HARNESS_ROOT" ]] && {
  echo "Error: harness root is required as argument 4 or ENGINEERING_HARNESS_ROOT." >&2
  exit 64
}

if [[ ! "$VERSION" =~ ^v[0-9]+\.[0-9]+\.[0-9]+([+-][0-9A-Za-z.-]+)?$ ]]; then
  echo "Error: version must be a v-prefixed semantic version: $VERSION" >&2
  exit 64
fi

if ! command -v git >/dev/null 2>&1; then
  echo "Error: git is required." >&2
  exit 64
fi

if [[ -e "$TARGET" ]]; then
  echo "Error: target already exists: $TARGET" >&2
  exit 64
fi

TMP_DIR="$(mktemp -d)"
INSTALL_LOCK=""
PROJECT_STAGE=""
cleanup() {
  [[ -n "$PROJECT_STAGE" && -e "$PROJECT_STAGE" ]] && rm -rf "$PROJECT_STAGE"
  [[ -n "$INSTALL_LOCK" && -d "$INSTALL_LOCK" ]] && rmdir "$INSTALL_LOCK" 2>/dev/null || true
  rm -rf "$TMP_DIR"
}
trap cleanup EXIT

# Prefer the current checkout when it is the requested release. This allows the
# initializer to work directly from a checked-out/tagged v0.3.0 repository.
SOURCE_ROOT=""
if [[ -f "$SCRIPT_DIR/VERSION" ]] && [[ "$(tr -d '\r\n' < "$SCRIPT_DIR/VERSION")" == "$VERSION" ]]; then
  SOURCE_ROOT="$SCRIPT_DIR"
else
  echo "Fetching Engineering Harness $VERSION..."
  git clone --quiet --depth 1 --branch "$VERSION" "$REPO_URL" "$TMP_DIR/engineering-harness"
  SOURCE_ROOT="$TMP_DIR/engineering-harness"
fi

required_source_paths=(
  VERSION
  harness/harness.yaml
  schemas/schema-catalog.json
  controls
  profiles
  technologies
  gates
  workflows/bootstrap.yaml
  standards
  annexes/canonicalisation-harness-v1.md
  annexes/canonicalisation-vectors.json
  project-template
  project-pack-template
  "adapters/$ADAPTER/CLAUDE.md"
  "adapters/$ADAPTER/.claude"
)

for path in "${required_source_paths[@]}"; do
  if [[ ! -e "$SOURCE_ROOT/$path" ]]; then
    echo "Error: requested release is missing required path: $path" >&2
    exit 5
  fi
done

if [[ "$(tr -d '\r\n' < "$SOURCE_ROOT/VERSION")" != "$VERSION" ]]; then
  echo "Error: release VERSION does not match requested version $VERSION." >&2
  exit 5
fi

# Governed Harness/project artefacts must not be supplied through symlinks.
if find "$SOURCE_ROOT/harness" "$SOURCE_ROOT/schemas" "$SOURCE_ROOT/controls" \
        "$SOURCE_ROOT/profiles" "$SOURCE_ROOT/technologies" "$SOURCE_ROOT/gates" \
        "$SOURCE_ROOT/workflows" "$SOURCE_ROOT/standards" "$SOURCE_ROOT/project-template" \
        "$SOURCE_ROOT/project-pack-template" "$SOURCE_ROOT/adapters/$ADAPTER" \
        -type l -print -quit | grep -q .; then
  echo "Error: release contains a symlink in a governed distribution path." >&2
  exit 5
fi

mkdir -p "$HARNESS_ROOT/releases"
RELEASE_DEST="$HARNESS_ROOT/releases/$VERSION"

# Keep release installation single-writer. mkdir is used as an atomic lock.
INSTALL_LOCK="$HARNESS_ROOT/releases/.$VERSION.install.lock"
if ! mkdir "$INSTALL_LOCK" 2>/dev/null; then
  echo "Error: Harness release installation is already in progress for $VERSION." >&2
  exit 4
fi

release_components=(harness schemas controls profiles technologies gates workflows standards annexes)

if [[ -d "$RELEASE_DEST" ]]; then
  # Never overwrite an existing version with different bytes. Compare it with
  # the exact tagged/current source and reuse only when it is identical.
  mismatch=0
  for component in "${release_components[@]}"; do
    if [[ ! -e "$RELEASE_DEST/$component" ]] || ! diff -qr "$SOURCE_ROOT/$component" "$RELEASE_DEST/$component" >/dev/null 2>&1; then
      mismatch=1
      break
    fi
  done
  if [[ "$mismatch" -ne 0 ]]; then
    echo "Error: $RELEASE_DEST already exists but does not match $VERSION source contracts." >&2
    echo "Remove or repair that installed release explicitly; it will not be overwritten." >&2
    exit 5
  fi
  echo "Harness release already installed and verified: $RELEASE_DEST"
else
  RELEASE_STAGE="$HARNESS_ROOT/releases/.$VERSION.stage.$$"
  rm -rf "$RELEASE_STAGE"
  mkdir -p "$RELEASE_STAGE"
  for component in "${release_components[@]}"; do
    cp -R "$SOURCE_ROOT/$component" "$RELEASE_STAGE/$component"
  done
  printf '%s\n' "$VERSION" > "$RELEASE_STAGE/VERSION"
  mv "$RELEASE_STAGE" "$RELEASE_DEST"
  echo "Installed Harness release: $RELEASE_DEST"
fi

rmdir "$INSTALL_LOCK"
INSTALL_LOCK=""

TARGET_PARENT="$(dirname -- "$TARGET")"
TARGET_NAME="$(basename -- "$TARGET")"
mkdir -p "$TARGET_PARENT"
PROJECT_STAGE="$TARGET_PARENT/.$TARGET_NAME.init.$$"
if [[ -e "$PROJECT_STAGE" ]]; then
  echo "Error: project staging path already exists: $PROJECT_STAGE" >&2
  exit 5
fi
mkdir -p "$PROJECT_STAGE"

cp -R "$SOURCE_ROOT/project-template/." "$PROJECT_STAGE/"
mkdir -p "$PROJECT_STAGE/project-pack"
cp -R "$SOURCE_ROOT/project-pack-template/." "$PROJECT_STAGE/project-pack/"

# Adapter documentation remains central. Only runtime adapter files are overlaid.
cp "$SOURCE_ROOT/adapters/$ADAPTER/CLAUDE.md" "$PROJECT_STAGE/CLAUDE.md"
cp -R "$SOURCE_ROOT/adapters/$ADAPTER/.claude" "$PROJECT_STAGE/.claude"

# v0.3.0 provenance grammar: exact keys, order, LF, no comments/blank lines.
printf 'repository=%s\nversion=%s\ntemplate=%s\n' \
  "$REPO_URL" "$VERSION" "project-template" \
  > "$PROJECT_STAGE/.engineering-harness-template"

printf 'name=%s\nversion=%s\nsource=%s\n' \
  "$ADAPTER" "$VERSION" "adapters/$ADAPTER" \
  > "$PROJECT_STAGE/.engineering-harness-adapter"

git -C "$PROJECT_STAGE" init --quiet

# Publish the project only after the full shell has been constructed successfully.
if [[ -e "$TARGET" ]]; then
  echo "Error: target appeared during initialisation: $TARGET" >&2
  exit 4
fi
mv "$PROJECT_STAGE" "$TARGET"
PROJECT_STAGE=""

cat <<DONE

Project created successfully.

Project:      $TARGET
Harness:      $VERSION
Adapter:      $ADAPTER
Harness root: $HARNESS_ROOT
Installed:    $RELEASE_DEST

Next:
  1. Complete the human-owned Project Engineering Pack under:
       $TARGET/project-pack/

  2. Supply the same Harness root to the deterministic core, for example:
       export ENGINEERING_HARNESS_ROOT="$HARNESS_ROOT"

  3. Inspect the project using your existing v0.3.0 core implementation:
       node <path-to-core>/dist/src/cli.js inspect_project \\
         --project-root "$TARGET" \\
         --harness-root "$HARNESS_ROOT"

When the Pack is valid, inspection should derive PROJECT_INPUT_READY and
bootstrap_repository becomes the next permitted action. The initializer itself
does not perform that lifecycle mutation.
DONE
