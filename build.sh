#!/usr/bin/env sh

BASE_BUILD_DIR=_builds
PLATFORM=macos
GENERATOR=Xcode
GENERATOR_DIR=$(echo "${GENERATOR}" | tr '[:upper:]' '[:lower:]')
BUILD_DIR=${BASE_BUILD_DIR}/${PLATFORM}-${GENERATOR_DIR}
BUILD_TYPE=Debug
JOBS=8

DO_CLEAR=false
DO_BUILD=true
DO_CONFIG=true
DO_RECONFIG=false
DRY_RUN=false

while [ $# -gt 0 ]; do
  case "$1" in
    -h|--help)
      echo "usage: ./build [options]"
      echo "-h, --help           Show help"
      echo "--clear              Remove the build directory"
      echo "--dry-run            Output commands only"
      echo "--debug              Specify Debug build type"
      echo "--release            Specify Release build type"
      echo "--reconfig           Reconfigure the project"
      exit 0
      ;;
    --debug)
      BUILD_TYPE=Debug
      shift
      ;;
    --release)
      BUILD_TYPE=Release
      shift
      ;;
    --clear)
      DO_CLEAR=true
      shift
      ;;
    --reconfig)
      DO_RECONFIG=true
      shift
      ;;
    --dry-run)
      DRY_RUN=true
      shift
      ;;
    *)
      break
      ;;
  esac
done

if [ "$DRY_RUN" = true ]; then
  run="echo"
else
  run=''
fi

if [ "$DO_CLEAR" = true ]; then
  $run rm -rf "$BUILD_DIR"
fi

# Force a re-configure by deleting the cache
if [ "$DO_RECONFIG" = true ]; then
  $run rm -f "$BUILD_DIR/CMakeCache.txt"
fi

# Do not configure if cache already exists
if [ -f "$BUILD_DIR/CMakeCache.txt" ]; then
  DO_CONFIG=false
fi

if [ "${DO_CONFIG}" = true ]; then
  $run cmake \
    -S. \
    -B"${BUILD_DIR}" \
    -G"${GENERATOR}" \
    "$@"
fi

if [ "$DO_BUILD" = true ]; then
  $run cmake \
    --build "${BUILD_DIR}" \
    --parallel "${JOBS}" \
    --config "${BUILD_TYPE}"
fi
