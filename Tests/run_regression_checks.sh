#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
BUILD_DIR="${TMPDIR:-/tmp}/pagepacket-regression-check"
BIN="$BUILD_DIR/pagepacket-regression-check"

mkdir -p "$BUILD_DIR"

swiftc -parse-as-library \
  "$ROOT_DIR/Sources/Graft/Models/"*.swift \
  "$ROOT_DIR/Sources/Graft/Services/"*.swift \
  "$ROOT_DIR/Sources/Graft/Stores/WorkspaceStore.swift" \
  "$ROOT_DIR/Tests/regression_check.swift" \
  -o "$BIN"

"$BIN"
