# Run this in a path you don't care about, things may get deleted!
VERSION="0.9.14"
BUILD="betable1"

set -e -x
ORIGPWD="$(pwd)"
TMP="$(mktemp -d)"
cd $TMP
trap "rm -rf \"$TMP\"" EXIT INT QUIT TERM

git clone git@github.com:graphite-project/whisper
cd whisper
git checkout -B "$VERSION" "0.9.14"

python setup.py install --install-data $TMP/prepare/var/lib/graphite --install-lib $TMP/prepare/opt/graphite/lib --prefix $TMP/prepare/opt/graphite
cd ../prepare

rm -f "$ORIGPWD/whisper${VERSION}-${BUILD}_amd64.deb"

fakeroot fpm -m "Max Furman <max@betable.com>" \
             -n "whisper" -v "$VERSION-$BUILD" \
             -p "$ORIGPWD/whisper_${VERSION}-${BUILD}_amd64.deb" \
             -s "dir" -t "deb" "."
