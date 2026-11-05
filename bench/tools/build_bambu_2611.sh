#!/usr/bin/env bash
# bench/tools/build_bambu_2611.sh [sources|bundle|install|all]: build Bambu (PandA) 2026.11
# from its git tag as an AppImage and install it next to 2024.10 (BAM3 step B0).
#
# Route: Bambu's own containerized AppImage build (README "AppImage (Docker) quick
# commands"): etc/scripts/appimage_build_in_container.sh runs cmake configure, build,
# install, the GLIBC audit and appimagetool inside bambuhls/dev:xenial-24.08, with the
# clang-16 bundle downloaded inside the container.
#
# Two setup fixes against the README's two cmake commands (no Bambu source is changed):
#  1. The README's host-side `cmake -S . -B build ...` runs the full project configure on
#     the host (GCC >= 13 gate, Boost, zlib, flex/bison and a host clang for the plugin
#     probe). The EL8 host has none of these, and the configure only serves to render
#     etc/appimage/appimage_compat_cache_init.cmake.in and call the container script.
#     So this script renders that template with `cmake -P` (configure_file @ONLY, the same
#     values a default configure gives) and calls the container script with the arguments
#     the appimage_bundle target passes.
#  2. The container script runs `podman run --user $(id -u):$(id -g)` without a user
#     namespace option. Rootless podman then maps that uid to a subuid, which cannot read
#     or write the mode-700 NFS tree. PODMAN_USERNS=keep-id makes it the caller's uid.
#
# Stages (default all): sources = clone the tag + the needed submodules;
# bundle = cache-init + container build, log in tools/src/build-2026.11.log;
# install = --appimage-extract into tools/bambu-2026.11/ + wrapper tools/bin/bambu-2026.11.
# Needs podman, git, curl, and cmake >= 3.16 on PATH (`pixi run bash bench/tools/...`).
set -euo pipefail

VERSION=2026.11
COMMIT=cda4db2e724df357f749c0c41b12bdc065462ced   # tag 2026.11, 2026-11-04
REPO_URL=https://github.com/ferrandi/PandA-bambu.git
IMAGE=docker.io/bambuhls/dev:xenial-24.08
# The examples submodules are not built, but the top CMakeLists stops on any uninitialized
# submodule (`git submodule status --recursive` with a leading -), so they are checked out too.
SUBMODULES=(ext/buddy ext/mockturtle/mockturtle ext/pugixml ext/gcem ext/glaze
            ext/abseil/abseil-cpp etc/ac_types etc/ac_math
            examples/CHStone/CHStone examples/MachSuite/MachSuite
            examples/OpenMP/GAPBS/gapbs examples/PolyBench/PolyBenchC)

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd -P)"
SRC="$ROOT/tools/src/panda-$VERSION"
BUILD="$ROOT/tools/src/build-$VERSION"
APPDIR="$BUILD/appimage-root"
NAME="bambu-$VERSION"
LOG="$ROOT/tools/src/build-$VERSION.log"
DEST="$ROOT/tools/bambu-$VERSION"
STAGE="${1:-all}"

sources() {
    if [ ! -d "$SRC/.git" ]; then
        git clone --depth 1 --branch "$VERSION" "$REPO_URL" "$SRC"
    fi
    local head
    head="$(git -C "$SRC" rev-parse HEAD)"
    if [ "$head" != "$COMMIT" ]; then
        echo "tag $VERSION is at $head, pinned $COMMIT" >&2
        exit 1
    fi
    git -C "$SRC" submodule update --init --depth 1 "${SUBMODULES[@]}"
}

bundle() {
    mkdir -p "$BUILD" "$APPDIR"
    # Values of a default configure plus the README's -D options
    # (PANDA_APPIMAGE_NAME, PANDA_DIST_COMPILERS=clang-16; the template forces
    # PANDA_SYNC_PARAMETER_METADATA OFF itself).
    cat > "$BUILD/render-cache-init.cmake" <<'EOF'
set(CMAKE_BUILD_TYPE "")
set(CMAKE_INSTALL_MESSAGE "")
set(PANDA_BUILD_BAMBU ON)
set(PANDA_BUILD_EUCALYPTUS ON)
set(PANDA_BUILD_CC ON)
set(PANDA_ENABLE_RELEASE ON)
set(PANDA_ENABLE_ASSERTS ON)
set(PANDA_ENABLE_OPT ON)
set(PANDA_ENABLE_WERROR ON)
set(PANDA_ENABLE_DEBUG OFF)
set(PANDA_ENABLE_UNORDERED OFF)
set(_compat_appdir_container "/appdir")
set(PANDA_APPIMAGE_CONTAINER_IMAGE "bambuhls/dev:xenial-24.08")
set(PANDA_APPIMAGE_RUNTIME_FILE "")
set(PANDA_APPIMAGE_MAX_GLIBC "2.17")
set(PANDA_APPIMAGE_PARALLEL "")
set(PANDA_LIBBAMBU_COMPILER "I386_CLANG13")
set(PANDA_MIN_CLANG_VERSION "4.0.0")
set(PANDA_MAX_CLANG_VERSION "20.0.0")
set(PANDA_DIST_COMPILERS "clang-16")
set(PANDA_DIST_COMPILERS_BACKUP "")
configure_file("${TEMPLATE}" "${OUT}" @ONLY)
EOF
    cmake -DPANDA_APPIMAGE_NAME="$NAME" \
          -DTEMPLATE="$SRC/etc/appimage/appimage_compat_cache_init.cmake.in" \
          -DOUT="$BUILD/appimage-compat-cache.cmake" \
          -P "$BUILD/render-cache-init.cmake"

    local t0=$SECONDS
    (
        cd "$BUILD"
        PODMAN_USERNS=keep-id bash "$SRC/etc/scripts/appimage_build_in_container.sh" \
            --source-dir "$SRC" \
            --build-dir "$BUILD" \
            --appdir "$APPDIR" \
            --cache-init "$BUILD/appimage-compat-cache.cmake" \
            --cache-init-in-container /build/appimage-compat-cache.cmake \
            --build-dir-in-container /build/appimage-compat-build \
            --appdir-in-container /appdir \
            --generator Ninja \
            --parallel "" \
            --compilers clang-16 \
            --compilers-backup "" \
            --appimage-name "$NAME" \
            --appimage-arch x86_64 \
            --max-glibc 2.17 \
            --runtime-file "" \
            --runtime podman \
            --image "$IMAGE"
    ) > "$LOG" 2>&1
    echo "container build done in $(( SECONDS - t0 )) s; log $LOG"
    ls -l "$APPDIR/$NAME.AppImage"
}

install_appimage() {
    local img="$APPDIR/$NAME.AppImage"
    [ -f "$img" ] || { echo "missing $img (run the bundle stage)" >&2; exit 1; }
    rm -rf "$DEST"
    mkdir -p "$DEST" "$ROOT/tools/bin"
    cp "$img" "$DEST/"
    chmod +x "$DEST/$NAME.AppImage"
    (cd "$DEST" && "./$NAME.AppImage" --appimage-extract > /dev/null)
    cat > "$ROOT/tools/bin/$NAME" <<WRAP
#!/usr/bin/env bash
# Generated by bench/tools/build_bambu_2611.sh: Bambu ${VERSION} (${COMMIT:0:8}) from the
# extracted AppImage. The AppImage runtime normally sets APPDIR, ARGV0 and OWD; the
# extracted AppRun needs them to find usr/bin/bambu and the caller's directory.
export APPDIR="$DEST/squashfs-root"
export ARGV0=bambu
export OWD="\$PWD"
exec "$DEST/squashfs-root/AppRun" "\$@"
WRAP
    chmod +x "$ROOT/tools/bin/$NAME"
    echo "wrote $ROOT/tools/bin/$NAME"
}

case "$STAGE" in
    sources) sources ;;
    bundle)  bundle ;;
    install) install_appimage ;;
    all)     sources; bundle; install_appimage ;;
    *) echo "usage: $0 [sources|bundle|install|all]" >&2; exit 2 ;;
esac
