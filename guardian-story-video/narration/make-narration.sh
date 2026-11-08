#!/usr/bin/env bash
# Builds the narrated video from script.txt (start seconds|line). Needs edge-tts and ffmpeg on PATH.
# Usage: bash guardian-story-video/narration/make-narration.sh [edge-tts command]
set -euo pipefail
here="$(cd "$(dirname "$0")" && pwd)"
tts="${1:-edge-tts}"
voice="en-US-AvaNeural"
rate="-4%"
src="$here/../export/dunfaire-guardian-story-1920x1080.mp4"
out="$here/../export/dunfaire-guardian-story-1920x1080-narrated.mp4"
work="$(mktemp -d)"
trap 'rm -rf "$work"' EXIT

inputs=() filters="" mix="" i=0
while IFS='|' read -r start text; do
  [ -z "$start" ] && continue
  "$tts" --voice "$voice" --rate="$rate" --text "$text" --write-media "$work/l$i.mp3" >/dev/null
  dur=$(ffprobe -v error -show_entries format=duration -of csv=p=0 "$work/l$i.mp3")
  echo "line $i at ${start}s lasts ${dur}s"
  ms=$(awk "BEGIN{printf \"%d\", $start*1000}")
  inputs+=(-i "$work/l$i.mp3")
  filters+="[$((i+1)):a]aresample=48000,adelay=${ms}|${ms}[a$i];"
  mix+="[a$i]"
  i=$((i+1))
done < <(tr -d '\r' < "$here/script.txt")

# Mix the lines, normalise to -16 LUFS (YouTube speech level), pad or cut to the video length.
ffmpeg -v error -y -i "$src" "${inputs[@]}" -filter_complex \
  "${filters}${mix}amix=inputs=$i:normalize=0,loudnorm=I=-16:TP=-1.5:LRA=11,aresample=48000,apad,atrim=0:95[aout]" \
  -map 0:v -map "[aout]" -c:v copy -c:a aac -b:a 192k -ac 2 -movflags +faststart "$out"
echo "wrote $out"
