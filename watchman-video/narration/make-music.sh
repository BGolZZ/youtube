#!/usr/bin/env bash
# Original ambient pad (sine chords Am-F-C-G, 10 s each), mixed under the narrated video. Needs ffmpeg only.
# Usage: bash watchman-video/narration/make-music.sh
set -euo pipefail
here="$(cd "$(dirname "$0")" && pwd)"
src="$here/../export/dunfaire-watchman-1920x1080-narrated.mp4"
out="$here/../export/dunfaire-watchman-1920x1080-narrated-music.mp4"
chords=("110 220 261.63 329.63" "87.31 174.61 220 261.63" "130.81 261.63 329.63 392" "98 196 246.94 293.66")
in=() f="" mix="" n=0
for k in 0 1 2 3 4 5 6 7; do
  for hz in ${chords[$((k%4))]}; do
    in+=(-f lavfi -t 12 -i "sine=frequency=$hz:sample_rate=48000")
    ms=$((k*10000))
    f+="[$n:a]afade=t=in:d=3,afade=t=out:st=9:d=3,adelay=${ms}|${ms}[m$n];"
    mix+="[m$n]"; n=$((n+1))
  done
done
# music: lowpass + soft echo, -14 dB before the mix, about 18 dB under the voice, fade in 3 s / out 4 s; voice untouched; limiter on the sum
ffmpeg -v error -y -i "$src" "${in[@]}" -filter_complex \
 "${f}${mix}amix=inputs=$n:normalize=0,lowpass=f=1200,aecho=0.8:0.6:700:0.3,aformat=channel_layouts=stereo,atrim=0:80,volume=-14dB,afade=t=in:d=3,afade=t=out:st=76:d=4[mus];[0:a][mus]amix=inputs=2:normalize=0:duration=first,alimiter=limit=0.89[aout]" \
 -map 0:v -map "[aout]" -c:v copy -c:a aac -b:a 192k -ar 48000 -ac 2 -movflags +faststart "$out"
echo "wrote $out"
