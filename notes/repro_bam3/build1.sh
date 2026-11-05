#!/usr/bin/env bash
# notes/repro_bam3/build1.sh <dir> <bambu binary> <LANES> <INIT>: copy repro.cpp into <dir> (inside the repo,
# e.g. build/repro_bam3/2611_L28_init1) and run Bambu there in the container, with the `bambu` case's flags.
set -u
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd -P)"
ROOT="$(cd "$HERE/../.." && pwd -P)"
mkdir -p "$1" && cp "$HERE/repro.cpp" "$1/" && cd "$1" && t0=$SECONDS
timeout 1200 "$ROOT/bench/tools/in_bambu.sh" "$2" repro.cpp --top-fname=vadd --device-name=nangate45 --clock-period=10 --compiler=I386_CLANG16 --std=c++14 --generate-interface=INFER -DLANES="$3" -DINIT="$4" > bambu.log 2>&1
echo "$1 rc=$? $((SECONDS-t0))s $(ls *.v 2>/dev/null | tr '\n' ' ')"
