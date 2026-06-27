#!/usr/bin/env bash
set -euo pipefail

APP_NAME="Graft"

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
DIST_DIR="$ROOT_DIR/dist"
APP_BUNDLE="$DIST_DIR/$APP_NAME.app"
ZIP_PATH="$DIST_DIR/$APP_NAME.zip"
BUILD_SCRIPT="$ROOT_DIR/script/build_and_run.sh"
PACKAGE_BUILD_PATH="$(mktemp -d "${TMPDIR:-/tmp}/graft-package-build.XXXXXX")"

cleanup() {
  rm -rf "$PACKAGE_BUILD_PATH"
}
trap cleanup EXIT

if [[ ! -x "$BUILD_SCRIPT" ]]; then
  echo "error: missing executable build helper: $BUILD_SCRIPT" >&2
  exit 1
fi

GRAFT_BUILD_PATH="$PACKAGE_BUILD_PATH" "$BUILD_SCRIPT" --verify

if [[ ! -d "$APP_BUNDLE" ]]; then
  echo "error: expected app bundle was not created: $APP_BUNDLE" >&2
  exit 1
fi

pkill -x "$APP_NAME" >/dev/null 2>&1 || true

rm -f "$ZIP_PATH"
(
  cd "$DIST_DIR"
  /usr/bin/ditto -c -k --keepParent "$APP_NAME.app" "$APP_NAME.zip"
)

echo "packaged $ZIP_PATH"
