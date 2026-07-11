# Interactive before/after comparison

A self-contained drag-to-compare page (`index.html`) for the Orange Begone preset.
No build step, no dependencies — just static HTML/CSS/JS.

## Add a scene

Each scene needs **two full-frame screenshots of the same spot** — one with ReShade
off, one with it on:

1. In-game, frame a shot and stand still.
2. Press the ReShade **screenshot** key (default `PrtScn`) with the preset **off**,
   then toggle the preset **on** (default `Home` → toggle, or your effects-toggle key)
   and press screenshot again. Don't move between the two.
3. Rename the pair and drop them in `images/`:
   - `images/havana-before.jpg` + `images/havana-after.jpg`
   - `images/harbor-before.jpg`  + `images/harbor-after.jpg`
   - `images/encounter-before.jpg` + `images/encounter-after.jpg`

The page already lists those three scenes. Until the files exist, each shows a
placeholder telling you exactly which filenames to drop in. To add more scenes,
edit the `SCENES` array near the bottom of `index.html`.

JPG keeps the repo light; PNG works too (update the paths in `SCENES`).

## Publish it (GitHub Pages)

1. Repo **Settings → Pages**.
2. **Source:** Deploy from a branch → **Branch:** `main` → **Folder:** `/docs` → Save.
3. After it builds, the page is at:
   `https://acltabontabon.github.io/ac-blackflag-resynced-reshade/compare/`
4. Link that URL from your Nexus description (e.g. "▶ Interactive comparison").

The built-in **Demo (sample)** scene works immediately, so you can confirm the page
is live before adding real captures.
