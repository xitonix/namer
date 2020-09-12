#set -euo pipefail
set -xv

parse_tag_ref() {
  python -c 'import re, sys; x = sys.stdin.readline().strip(); x = x[x.rindex("/")+1:] if x.rfind("/") != -1 else x; print(x.lstrip("v") if re.match(r"v[0-9]", x) else "")'
}

if [[ $# -gt 1 ]]; then
  echo "usage: release/release.bash [VERSION]" 1>&2
  exit 64
fi
SOURCE_ROOT="$(dirname "$(dirname "${BASH_SOURCE[0]}")")"
ls $SOURCE_ROOT
RELEASE_VERSION="${1:-$(echo "${GITHUB_REF:-}" | parse_tag_ref)}"
if [[ -z "$RELEASE_VERSION" ]]; then
  echo "release/release.bash: cannot infer version, please pass explicitly" 1>&2
  exit 1
fi

RELEASE_OS="$(go env GOOS)"
RELEASE_ARCH="$(go env GOARCH)"
RELEASE_NAME="${BINARY}_${RELEASE_VERSION}_${RELEASE_OS}_${RELEASE_ARCH}"

echo "Creating ${RELEASE_NAME}.tar.gz..." 1>&2
STAGE_DIR=$(mktemp -d 2>/dev/null || mktemp -d -t ${BINARY}_release)
trap "rm -rf ${STAGE_DIR}" EXIT
DIST_ROOT="${STAGE_DIR}/${RELEASE_NAME}"
mkdir "$DIST_ROOT"
"$SOURCE_ROOT/release/build.bash" "$DIST_ROOT/$BINARY" "$RELEASE_VERSION"
tar -zcf - -C "$STAGE_DIR" "$RELEASE_NAME" > "${RELEASE_NAME}.tar.gz"
echo "::set-output name=file::${RELEASE_NAME}.tar.gz"