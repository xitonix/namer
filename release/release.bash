set -euxo pipefail

SRC="$(dirname "$(dirname "${BASH_SOURCE[0]}")")"
RELEASE_VERSION=$(echo ${GITHUB_REF} | cut -d'v' -f2)
RELEASE_OS="$(go env GOOS)"
RELEASE_ARCH="$(go env GOARCH)"
RELEASE_NAME="${BINARY}_${RELEASE_VERSION}_${RELEASE_OS}_${RELEASE_ARCH}"
BIN_DIR="${SRC}/bin/${RELEASE_NAME}"
RPM_ITERATION=1
mkdir -p $BIN_DIR
echo "Creating ${RELEASE_NAME}.tar.gz..." 1>&2
"$SRC/release/build.bash" "$BIN_DIR/$BINARY" "$RELEASE_VERSION"
tar -C "${BIN_DIR}" -cvzf "${RELEASE_NAME}.tar.gz" "${BINARY}"
if [[ $# -eq 1 ]]; then
  docker run --rm -v $(pwd):/app xitonix/fpm-rpm -s tar -t rpm -n ${BINARY} -p /app -v ${RELEASE_VERSION} --iteration ${RPM_ITERATION} "/app/${RELEASE_NAME}.tar.gz"
  docker run --rm -v $(pwd):/app xitonix/fpm-rpm -s tar -t deb -n ${BINARY} -p /app -v ${RELEASE_VERSION} --deb-no-default-config-files "/app/${RELEASE_NAME}.tar.gz"
fi
echo "::set-output name=file::${RELEASE_NAME}.tar.gz"

if [[ $# -eq 1 ]]; then
  echo "::set-output name=rpm::${BINARY}-${RELEASE_VERSION}-${RPM_ITERATION}.x86_64.rpm"
  echo "::set-output name=deb::${BINARY}_${RELEASE_VERSION}_${RELEASE_ARCH}.deb"
fi