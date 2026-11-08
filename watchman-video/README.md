# Dunfaire Watchman video

One 80 second motion video, 1920x1080, 30 fps, H.264, no audio track. Everything on screen is English.

Source decks (the owner's files): `Dunfaire_Watchman_Dark.pptx` (9 slides, used for text, scenes and colours) and
`Dunfaire_Watchman_Light.pptx` (same story, checked against the dark deck). No other deck describes Watchman.

Logo: the official `src/assets/official/dunfaire-d-icon-dark.svg` is used unchanged (white D, cyan `#00CBF8` dot).
Colours: night `#0B1416`, panel `#122023`, line `#2A3D41`, text `#EAF2F3`, cyan `#00CBF8`, green `#55D69E`,
red `#F26B73`, violet `#8B5CF6` (the deck's dark theme plus the logo cyan). Font: Inter Tight (`src/assets`, OFL).

## Scene script

| Time | Scene | On screen (deck slide) |
|---|---|---|
| 0-6 s | Intro | Logo, "Every company needs a watchman." (1) |
| 6-14 s | After hours | "6:00 P.M.", 24 machines, "Yours has hundreds." (2) |
| 14-22 s | All night | Sweep checks every machine, clock to 2:14 A.M., "A green dot = checked and fine." (3) |
| 22-30 s | 2:14 A.M. | One tile turns red: Camera 4 stopped recording, flat line (4) |
| 30-40 s | 2:15 A.M. | One message on a phone, "No sirens. No 200 e-mails." (5) |
| 40-50 s | Plain words | Camera code struck out, plain sentences (6) |
| 50-60 s | 8:41 A.M. | Timeline 02:14, 02:15, 08:40, 08:41 (7) |
| 60-70 s | Three things | You sleep. No Monday surprises. One screen, every site. (8) |
| 70-80 s | Outro | "The watchman who never sleeps.", demo link (9) |

The phone screen is marked "Illustrative screen", as in the deck.

## Render

`index.html` is a pure function of time (`window.render(t)`), so every frame is exact. `render.mjs` opens it in Chrome,
takes a PNG per frame and pipes them to ffmpeg (libx264, CRF 15, yuv420p, faststart).

```
PLAYWRIGHT_DIR=<folder with node_modules/playwright> node watchman-video/render.mjs watchman-video/export/dunfaire-watchman-1920x1080.mp4
node watchman-video/render.mjs --stills <dir> 3,13.8,27     # stills at those seconds, to check a scene
```

Needs node, ffmpeg on PATH and Chrome.

## Narration

`narration/script.txt` holds one line per scene (`start seconds|text`), read by Microsoft's neural voice
`en-US-AvaNeural` through edge-tts. `narration/make-narration.sh` speaks each line, places it at its start time,
normalises the mix to -16 LUFS and muxes it (AAC 192k, 48 kHz stereo) into
`export/dunfaire-watchman-1920x1080-narrated.mp4`. The silent video stays as it was.

```
pip install edge-tts
bash watchman-video/narration/make-narration.sh [path to edge-tts]
```

Every line ends before its scene ends (checked with ffmpeg silencedetect).

## Rollback

The folder is new and nothing else uses it: `git revert <commit>` or `git rm -r watchman-video`.
