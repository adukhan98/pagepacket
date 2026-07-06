#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
BUILD_DIR="${TMPDIR:-/tmp}/pagepacket-regression-check"
BIN="$BUILD_DIR/pagepacket-regression-check"

mkdir -p "$BUILD_DIR"

swiftc -emit-library -emit-module \
  -module-name GraftCore \
  "$ROOT_DIR/Sources/GraftCore/Review/"*.swift \
  -emit-module-path "$BUILD_DIR/GraftCore.swiftmodule" \
  -o "$BUILD_DIR/libGraftCore.dylib"

swiftc -parse-as-library \
  -I "$BUILD_DIR" \
  -L "$BUILD_DIR" \
  -lGraftCore \
  "$ROOT_DIR/Sources/Graft/Models/"*.swift \
  "$ROOT_DIR/Sources/Graft/Services/"*.swift \
  "$ROOT_DIR/Sources/Graft/Views/Theme.swift" \
  "$ROOT_DIR/Sources/Graft/Stores/WorkspaceStore.swift" \
  "$ROOT_DIR/Tests/regression_check.swift" \
  -o "$BIN"

DYLD_LIBRARY_PATH="$BUILD_DIR${DYLD_LIBRARY_PATH:+:$DYLD_LIBRARY_PATH}" "$BIN"
