# Dunfaire Guardian story video

One 95 second story-style ad for **Dunfaire Guardian** (the console: Mission Control, Alerts, Protection), not Guardian
Vision. 1920x1080, 30 fps, H.264, female narration (`en-US-AvaNeural`, rate -4%) and an original quiet music bed.
Everything on screen and in the voice is English. Same look and pipeline as the other story video (untouched).

## Story

| Time | Scene |
|---|---|
| 0-9 s | Monday 08:40, five tools, five streams of alerts, one tired I.T. manager |
| 9-20 s | 09:00 finance calls, the invoices will not load. Which server? Since when? Who owns it? |
| 20-30 s | "Have you ever run into this problem?" then "The solution is with us." |
| 30-41 s | Dunfaire Guardian: one console, on your premises, for every machine, device and threat |
| 41-54 s | Mission Control: one health score, seven areas, next steps, today's actions, shift handover |
| 54-66 s | Alerts: my queue, unassigned, overdue, S.L.A. clock, the right one first |
| 66-76 s | Protection: actively exploited vulnerabilities first; Backup is a Mission Control area |
| 76-85 s | Same Monday, new story (marked illustrative) |
| 85-95 s | Outro, book a guided demo, dunfaire.com |

Claims come from `../console-video` notes of the live console. Alert names, the score 82 and the story times are
sample data, labelled on screen. No accuracy or speed numbers are claimed.

## Motion (v2)

Eight different scene transitions (slide left, zoom-through with blur, wipe, slide up, zoom-out, diagonal wipe, tilt, slide right), each with a
light sweep; kinetic headlines (word by word); per-element entrances (card wipe, chip pop, row slide, label tracking, note reveal, logo spin-in);
slow push-in on every scene, floating cards, drifting particles, pulse rings on the Guardian reveal and the outro. Timing is unchanged, so the
narration and music files match. Rollback to the plain version: `git revert` the motion commit (previous video = commit `a75e6ee`).

## YouTube text

Title: `Dunfaire Guardian: one console for every machine, device and threat`

Description: `It is Monday morning, finance cannot open the invoices, and nobody knows which server, since when, or who owns it. Dunfaire Guardian is one console, on your premises, for every machine, device and threat: Mission Control with one health score and seven areas, ranked Alerts with an S.L.A. clock, and Protection that lists actively exploited vulnerabilities first. Book a guided demo at dunfaire.com. (The story and sample data are illustrative, not a measured result.)`

## Build

```
PLAYWRIGHT_DIR=<folder with node_modules/playwright> node guardian-story-video/render.mjs guardian-story-video/export/dunfaire-guardian-story-1920x1080.mp4
bash guardian-story-video/narration/make-narration.sh [path to edge-tts]
bash guardian-story-video/narration/make-music.sh
```

Music: original generated sine-chord pad, no third-party track, no Content ID risk. Measured: voice mean -18.7 dB, music
only gaps -36.6 and -34.8 dB (about 16-18 dB under the voice). Only the final `-narrated-music.mp4` is committed; the
two intermediate files are rebuilt by the commands above.

## Rollback

The folder is new and nothing else uses it: `git revert <commit>` or `git rm -r guardian-story-video`.

## Video file on GitHub

A single push of the mp4 kept failing (connection reset), so the final video (28 MB, motion version) is stored as eight parts. Join:
`cat guardian-story-video/export/parts/final.mp4.part0* > dunfaire-guardian-story-1920x1080-narrated-music.mp4`
(or rebuild it with the Build commands). Joined SHA-256 is printed by `sha256sum`; local copy:
2f71cdfeecab2a80fe47169096f1219af92373f3c353065136dd3d12dcc7b070
