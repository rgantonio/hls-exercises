#!/usr/bin/env bash
# bench/tools/in_bambu.sh <cmd> [args...]: run a command in the Bambu container (BAM1).
#
# Bambu 2024.10 builds its front end and its co-simulation driver with -m32; the EL8 host
# has no 32-bit glibc-devel, so Bambu runs in container/bambu's Ubuntu image instead, and
# simulates with the image's Verilator (Questa is not used in the container).
#   - the repo is bind-mounted at its host path; tools/bambu/ comes with it
#     (bench/tools/get_bambu.sh)
#   - the command runs in the current directory, which must be inside the repo
#   - --userns=keep-id: files stay owned by this user
#   - a clean PATH inside: tools/bin, then /usr/bin:/bin
# Image: BAMBU_IMAGE (default below). Example:
#   bench/tools/in_bambu.sh bambu --version
set -euo pipefail

IMAGE="${BAMBU_IMAGE:-localhost/hls-exercises-bambu:4}"

REPO="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd -P)"
CWD="$(pwd -P)"
case "$CWD/" in
    "$REPO"/*) ;;
    *) echo "in_bambu.sh: run from inside $REPO (now in $CWD)" >&2; exit 2 ;;
esac
[ $# -gt 0 ] || { echo "usage: in_bambu.sh <cmd> [args...]" >&2; exit 2; }

TTY=()
[ -t 0 ] && [ -t 1 ] && TTY=(-t)

# The workdir is the repo root and the cd to $CWD happens inside, as this user: the repo
# is mode 700 on NFS, and runc resolves -w as the container's root before switching
# to the user, so -w on a subdirectory fails with "mkdir ...: permission denied".
exec podman run --rm -i "${TTY[@]}" --userns=keep-id \
    -v "$REPO:$REPO" -w "$REPO" \
    -e HOME=/tmp \
    -e "PATH=$REPO/tools/bin:/usr/bin:/bin" \
    "$IMAGE" /bin/bash -c 'cd "$0" && exec "$@"' "$CWD" "$@"
