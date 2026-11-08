#!/usr/bin/env bash
# Renders the SVG sources in src/ to the PNG files in export/ with a real Chrome (playwright-cli),
# then checks each PNG's pixel size. Needs python (for a local web server, so the font loads) and playwright-cli.
# Usage: bash design/youtube-channel/render.sh
set -euo pipefail
here="$(cd "$(dirname "$0")" && pwd)"
pw="${PLAYWRIGHT_CLI:-playwright-cli}"
port="${PORT:-8762}"
session="yt-render-$$"
# a broken SVG still renders (as Chrome's error page) at the right size, so parse every source first
python -c "import sys, xml.etree.ElementTree as E; [E.parse(f) for f in sys.argv[1:]]" "$here"/src/*.svg "$here"/src/assets/official/*.svg
cd "$(mktemp -d)" # playwright-cli writes page snapshots into the current folder; keep them out of the repo

python -m http.server "$port" --bind 127.0.0.1 --directory "$here/src" >/dev/null 2>&1 &
server=$!
trap '"$pw" -s="$session" close >/dev/null 2>&1 || true; kill "$server" 2>/dev/null || true' EXIT
sleep 1
"$pw" -s="$session" open >/dev/null

shot() { # source width height output
  "$pw" -s="$session" resize "$2" "$3" >/dev/null
  # playwright-cli goto times out on an SVG page (it loads, the tool waits on), so navigate from the page itself
  url="http://127.0.0.1:$port/$1?out=$4"
  "$pw" -s="$session" eval "location.href='$url'" >/dev/null
  "$pw" -s="$session" eval "new Promise(r => { const f = () => location.href === '$url' && document.readyState === 'complete' ? document.fonts.ready.then(() => r(1)) : setTimeout(f, 50); f(); })" >/dev/null
  "$pw" -s="$session" screenshot --filename="$here/export/$4" >/dev/null
  size="$(python -c "import struct,sys; d=open(sys.argv[1],'rb').read(24); print('%dx%d' % struct.unpack('>II', d[16:24]))" "$here/export/$4")"
  [ "$size" = "$2x$3" ] || { echo "FAIL $4 is $size, want $2x$3" >&2; exit 1; }
  echo "ok $4 $size"
}

shot profile-dark.svg 800 800 dunfaire-youtube-profile-800x800.png
shot profile-light.svg 800 800 dunfaire-youtube-profile-800x800-light.png
shot banner.svg 2560 1440 dunfaire-youtube-banner-2560x1440.png
# 4K: the same vector sources at a larger window (the SVGs fill it), so every position scales with them
shot profile-light.svg 4096 4096 dunfaire-youtube-profile-4096x4096-light.png
shot banner.svg 3840 2160 dunfaire-youtube-banner-3840x2160.png
