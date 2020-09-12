#set -euo pipefail
set -xv pipefail

commitInfo() {
  git rev-parse HEAD | tr -d '\n' || return 1
  if [[ "$(git status --porcelain | wc -l)" -gt 0 ]]; then
    echo "+"
  else
    echo
  fi
}

if [[ $# -ne 1 && $# -ne 2 ]]; then
  echo "usage: release/build.bash OUT [VERSION]" 1>&2
  exit 64
fi

#COMMIT=$(git rev-parse HEAD)
BUILD_TIME=$(date -u '+%a %d %b %Y %H:%M:%S GMT')
RUNTIME=$(go version | cut -d' ' -f 3)

cd "$(dirname "$(dirname "${BASH_SOURCE[0]}")")"
ls
#commit="${GITHUB_SHA:-$(commitInfo)}"
VERSION="${2:-}"
go build -o "$1" -ldflags="-s -w -X main.version=${VERSION} main.runtimeVer=${RUNTIME} -X main.commit=${GITHUB_SHA} -X main.binary=${BINARY}" github.com/xitonix/${BINARY}