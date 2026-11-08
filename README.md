# Dunfaire YouTube channel: profile picture and banner

Built from the owner's official Dunfaire logo files (supplied 2026-11-08). The logo is not redrawn: the three official
SVGs are copied unchanged into `src/assets/official/` and placed in the images as they are. All text is English.

| File | Size | Use |
|---|---|---|
| `export/dunfaire-youtube-profile-800x800.png` | 800 x 800 | YouTube Studio > Customisation > Branding > Picture (dark: white D on the night background) |
| `export/dunfaire-youtube-profile-800x800-light.png` | 800 x 800 | Same place, light alternative (black D on white); upload one of the two |
| `export/dunfaire-youtube-banner-2560x1440.png` | 2560 x 1440 | YouTube Studio > Customisation > Branding > Banner image |
| `export/dunfaire-youtube-profile-4096x4096-light.png` | 4096 x 4096 | 4K light profile picture (black D on white), the same `src/profile-light.svg` rendered larger |
| `export/dunfaire-youtube-banner-3840x2160.png` | 3840 x 2160 | 4K banner, the same `src/banner.svg` rendered at 1.5x |
| `src/profile-dark.svg`, `src/profile-light.svg` | vector | Sources of the profile pictures |
| `src/banner.svg` | vector | Source of the banner |
| `src/assets/official/` | vector | The official logo files, byte-identical to the owner's |
| `render.sh` | | Checks every SVG parses, renders `src/` to `export/` with Chrome, checks every PNG's size |

## Official logo files

| File here | Owner's file | SHA-256 |
|---|---|---|
| `dunfaire-logo-light.svg` | `dunfaire-logo-light (2).svg` | `97264a6cf63fc8f3987a54c9fa8cfcacd0201bbf7e8a0f38dc588cd44574887a` |
| `dunfaire-d-icon-light.svg` | `dunfaire-d-icon-light (2).svg` | `e60a37401c7ce8f501187f844cf2befb54ec418ec35632a8741102acb80c071b` |
| `dunfaire-d-icon-dark.svg` | `dunfaire-d-icon-dark (2).svg` | `b41e050a6bce0aa8f2cb1a41f5fc50c45b402dff6dca946a5f409e1f6eeafb55` |

The full wordmark exists only in the light version (black lettering), so the banner uses the light theme of
dunfaire.com (background `#fff`, text `#0b191c`, accent `#006f79`) and shows the wordmark without recolouring it.
The tagline is the home page hero line in Inter Tight 600, the site's font file (`src/assets/inter-tight-latin.woff2`,
SIL Open Font License, `src/assets/OFL-InterTight.txt`). The dark profile picture uses the night background `#050708`.

## Fit

- Banner: everything sits inside the 1546 x 423 centre area that every device shows (x 507 to 2053, y 508.5 to
  931.5); measured content box: x 674 to 1884, y 563 to 883. The rest is plain background.
- Profile: the D icon fills a 440 px box in the centre; measured mark box x 188 to 611, y 180 to 619, so its farthest
  corner is 305 px from the centre, inside the 400 px circle YouTube cuts.
- 4K banner: the safe area scales 1.5x to 2319 x 634.5 (x 760.5 to 3079.5, y 762.75 to 1397.25); measured content box
  x 1011 to 2826, y 845 to 1324.
- 4K profile: measured mark box x 962 to 3126, y 922 to 3167; even its box corners are at most 1564 px from the centre,
  inside the 2048 px circle. The official D icon is drawn with straight segments, which shows as small angles at 4K.

## Render again

```bash
PLAYWRIGHT_CLI=playwright-cli bash design/youtube-channel/render.sh
```

Needs python (a local web server, so the font and the logo files load) and playwright-cli.

## Way back

- Files: `git revert <commit>` brings back the previous version of this folder; nothing else in the repository uses it.
- YouTube: Studio keeps no history of branding images, so download the current picture and banner from the channel
  before uploading these; to go back, upload those saved files again.
