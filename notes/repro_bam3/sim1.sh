#!/usr/bin/env bash
# notes/repro_bam3/sim1.sh <dir> <LANES>: Questa (vlog, vsim on the host) on the Verilog build1.sh wrote in <dir>,
# with notes/repro_bam3/tb.sv; prints PASS/FAIL and the wrong words.
set -u
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd -P)"
cd "$1" && top=$(grep -oE "^module \w+" vadd.v | tail -1 | cut -d' ' -f2)
rm -rf work && vlib work > /dev/null && timeout 600 vlog -sv -quiet +define+DUT=$top +define+LANES=$2 "$HERE/tb.sv" *.v > sim.log 2>&1 && timeout 600 vsim -c -quiet tb -do 'run -all; quit -f' 2>&1 | sed 's/^# //' >> sim.log
echo "$1: $(grep -E '^(PASS|FAIL)' sim.log) | $(grep -E '^  lane' sim.log | sed 's/^  //' | tr '\n' ';')"
