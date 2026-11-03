#!/usr/bin/env bash
# bench/tools/in_bambu.sh <cmd> [args...]: run a command in the Bambu container (BAM1).
#
# Bambu 2024.10 builds its front end and its co-simulation driver with -m32; the EL8 host
# has no 32-bit glibc-devel, so Bambu runs in container/bambu's Ubuntu image instead.
#   - the repo is bind-mounted at its host path and the workdir is the current directory
#     (which must be inside the repo); tools/bambu/ comes with it (bench/tools/get_bambu.sh)
#   - Questa: the rc file below is sourced here on the host, the directory behind
#     $MGC_QUESTA_HOME is mounted read-only at the same path, and every variable the rc
#     exports (except PATH) is passed with -e, so --mentor-root=$MGC_QUESTA_HOME works
#   - --userns=keep-id: files stay owned by this user; --network=host: licence server
#   - a clean PATH inside: tools/bin, Questa's bin, then /usr/bin:/bin
# Image: BAMBU_IMAGE (default below). Example:
#   bench/tools/in_bambu.sh bambu --version
set -euo pipefail

IMAGE="${BAMBU_IMAGE:-localhost/hls-exercises-bambu:1}"
QUESTA_RC=/users/micas/micas/design/scripts/questasim_2022.4.rc

REPO="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd -P)"
CWD="$(pwd -P)"
case "$CWD/" in
    "$REPO"/*) ;;
    *) echo "in_bambu.sh: run from inside $REPO (now in $CWD)" >&2; exit 2 ;;
esac
[ $# -gt 0 ] || { echo "usage: in_bambu.sh <cmd> [args...]" >&2; exit 2; }

# The rc's variables, read in a subshell so this script's own environment is untouched.
mapfile -t RC_VARS < <(sed -n 's/^[[:space:]]*export[[:space:]]\+\([A-Za-z_][A-Za-z0-9_]*\)=.*/\1/p' "$QUESTA_RC" | grep -vx PATH | sort -u)
ENV_ARGS=()
for v in "${RC_VARS[@]}"; do
    val="$(bash -c "source '$QUESTA_RC' >/dev/null 2>&1; printf '%s' \"\${$v-}\"")"
    ENV_ARGS+=(-e "$v=$val")
done
QUESTA_HOME="$(bash -c "source '$QUESTA_RC' >/dev/null 2>&1; printf '%s' \"\$MGC_QUESTA_HOME\"")"
[ -n "$QUESTA_HOME" ] || { echo "in_bambu.sh: $QUESTA_RC sets no MGC_QUESTA_HOME" >&2; exit 2; }
QUESTA_DIR="$(readlink -f "$QUESTA_HOME")"

TTY=()
[ -t 0 ] && [ -t 1 ] && TTY=(-t)

exec podman run --rm -i "${TTY[@]}" --userns=keep-id --network=host \
    -v "$REPO:$REPO" -v "$QUESTA_DIR:$QUESTA_DIR:ro" -w "$CWD" \
    "${ENV_ARGS[@]}" \
    -e HOME=/tmp \
    -e "PATH=$REPO/tools/bin:$QUESTA_HOME/bin:/usr/bin:/bin" \
    "$IMAGE" "$@"
