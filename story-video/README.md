# Dunfaire Guardian Vision story video

One 98 second story-style ad, 1920x1080, 30 fps, H.264, female narration (`en-US-AvaNeural`, rate -4%) and an
original quiet music bed. Everything on screen and in the voice is English. Same look and render pipeline as
`../console-video` and `../watchman-video` (both untouched).

## Story

| Time | Scene | Voice |
|---|---|---|
| 0-8 s | 2 A.M., a warehouse, 40 cameras, one tired guard | "Forty cameras, and one tired guard." |
| 8-17 s | A door opens at 02:14 and nobody sees it | "Nobody sees it." |
| 17-30 s | Next morning: empty shelf, hours of footage, nothing to point at | "Which camera? What time? Who?" |
| 30-40 s | The question | "Have you ever run into this problem?" then "The solution is with us." |
| 40-50 s | Guardian Vision reads the streams on your own server | on-premise, all night |
| 50-63 s | One event with a snapshot and a short clip | zone time, line crossing, object left behind |
| 63-76 s | Events ranked; the operator confirms or dismisses; the recorder keeps recording | the final decision is a person's |
| 76-86 s | Same night, new story (marked illustrative) | "the door is closed, before morning" |
| 86-98 s | Outro, book a guided demo, dunfaire.com | |

Claims are taken from the product README (reads camera streams on a local GPU, prioritised evidence-backed events,
operator decides, the NVR keeps recording). No accuracy or speed numbers are claimed. The last story scene says it is
an illustration, not a measured result.

## Build

```
PLAYWRIGHT_DIR=<folder with node_modules/playwright> node story-video/render.mjs story-video/export/dunfaire-guardian-vision-story-1920x1080.mp4
bash story-video/narration/make-narration.sh [path to edge-tts]   # narrated mp4 from narration/script.txt
bash story-video/narration/make-music.sh                          # adds the original music bed
```

Music: original generated pad (sine chords), no third-party track, no licence terms, no Content ID risk. About 18 dB
under the voice (measured: voice mean -19.3 dB, music-only gap -38.3 dB), fade in 3 s, fade out 4 s.

## Rollback

The folder is new and nothing else uses it: `git revert <commits>` or `git rm -r story-video`.
