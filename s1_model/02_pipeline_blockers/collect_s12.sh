#!/usr/bin/env bash
# collect_s12.sh — resource + latency tables for every S1.2 project
set -euo pipefail
C=../../common

for spec in "accf_proj accumulate" "acci_proj accumulate" "fir_proj fir3"; do
  read -r p t <<< "$spec"
  [[ -d "$p" ]] || { echo "skip $p (not found)"; continue; }
  s=$(ls -d "$p"/*/syn/report 2>/dev/null | cut -d/ -f2 | xargs)
  echo "== $p: $s"
  PROJ=$p TOP=$t SOLS="$s" OUT=res_${p%_proj}.md bash $C/collect_resources.sh > /dev/null
  PROJ=$p TOP=$t SOLS="$s" OUT=lat_${p%_proj}.md bash $C/collect_latency.sh   > /dev/null
done
ls -1 res_*.md lat_*.md