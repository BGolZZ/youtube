# Dunfaire Guardian console video

One 114 second motion video, 1920x1080, 30 fps, H.264, with female narration (`en-US-AvaNeural`) and a quiet
original music bed. Everything on screen and in the voice is English. Same look and render pipeline as
`../watchman-video` (that folder is untouched).

## What the console shows (read from the live console at http://127.0.0.1:8743/, signed in as the lab admin)

| Area | What it does |
|---|---|
| Mission Control | One health score, seven areas (Network, Firewalls, Clients, Servers, Backup, Security, Incidents), Live/24h/7d/30d, next steps, today's actions, shift handover, capacity, what changed, sites |
| Overview and Graphs | Incidents, business impact, asset health, data collection health, events, top problems; pinned graph widgets and metric findings |
| Alerts | Open alerts (security and availability), my queue, unassigned, overdue, dormant, severity and category filters, S.L.A. clock, saved views, insights, C.S.V. export |
| Assets | Cards, table, tree and services views; agents, connectors, collectors, discovery; add asset, merge duplicates, C.S.V. export |
| Network | Traffic, busiest interfaces, C.P.U. and memory per device, peak utilisation, device inventory and types, network alerts |
| Protection | Vulnerabilities: C.V.E.s and configuration checks, actively exploited, severity and score, top vulnerable assets, scan coverage and history |
| Administration | People and access, detection and response, estate and connections, data and records, this Guardian (licence, maintenance, about), quick actions |
| Reports and more | Nine report kinds, history, schedules and deliveries; Update Center; setup wizard; tutorial; notifications and data collection status; night or day tone |

Not opened one by one: the sub-pages behind each Administration card, and the Update Center page itself (named from
the console's links only).

## Build

```
PLAYWRIGHT_DIR=<folder with node_modules/playwright> node console-video/render.mjs console-video/export/dunfaire-guardian-console-1920x1080.mp4
bash console-video/narration/make-narration.sh [path to edge-tts]   # narrated mp4 from narration/script.txt
bash console-video/narration/make-music.sh                          # adds the original music bed (no third-party track)
```

Music: original generated pad, no licence terms and no Content ID risk, about 18 dB under the voice.

## Rollback

The folder is new and nothing else uses it: `git revert <commit>` or `git rm -r console-video`.
