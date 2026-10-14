#!/usr/bin/env bash
# Local Linux build: opt in to the GoW III frame-zero flip-gate workaround.
set -euo pipefail
root=$(cd -- "$(dirname -- "$0")/.." && pwd)
export GOW3_DATA_DIR="${GOW3_DATA_DIR:-${XDG_DATA_HOME:-$HOME/.local/share}/gow3}"
export LD_LIBRARY_PATH="$root/out/gpu:${XDG_DATA_HOME:-$HOME/.local/share}/gow3-build-deps/usr/lib/x86_64-linux-gnu${LD_LIBRARY_PATH:+:$LD_LIBRARY_PATH}"
export GOW3_BOOTSTRAP_FLIP_GATE=1
export GOW3_DRAW_PIPE=0
export GOW3_FRAME_STATS=1
exec python3 "$root/launcher/gow3_launcher_win.py" --play "$@"
