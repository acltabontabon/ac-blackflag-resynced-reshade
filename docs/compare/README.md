# Interactive before/after comparison

A self-contained drag-to-compare page (`index.html`) for the Orange Begone preset.
No build step, no dependencies — just static HTML/CSS/JS.

## How scenes display

Each scene tries three things, in order:

1. **Interactive wipe** — if a matched pair `images/<id>-before.jpg` + `images/<id>-after.jpg`
   exists, the scene becomes a drag-to-compare slider.
2. **Static split** — otherwise it falls back to the existing before/after composite
   in `../images/base/<id>.jpg` (already shipped), shown as a static image.
3. **Placeholder** — only if neither exists.

So every scene shows real content out of the box (the static composites); adding a
matched pair upgrades that scene to the interactive wipe.

## Upgrade a scene to the interactive wipe

Capture **two full-frame screenshots of the same spot** — one ReShade off, one on:

1. Frame a shot and stand still.
2. Press the ReShade **screenshot** key (default `PrtScn`) with the preset **off**,
   toggle the preset **on**, then screenshot again. Don't move between the two.
3. Drop the pair in `images/`, named by scene id:
   - `images/havana-rooftops-before.jpg` + `images/havana-rooftops-after.jpg`
   - `images/harbor-before.jpg` + `images/harbor-after.jpg`
   - `images/town-square-before.jpg` + `images/town-square-after.jpg`
   - `images/faces-before.jpg` + `images/faces-after.jpg`

To add or rename scenes, edit the `SCENES` array near the bottom of `index.html`.
JPG keeps the repo light; PNG works too.

## Publish it (GitHub Pages)

1. Repo **Settings → Pages**.
2. **Source:** Deploy from a branch → **Branch:** `main` → **Folder:** `/docs` → Save.
3. After it builds, the page is at:
   `https://acltabontabon.github.io/ac-blackflag-resynced-reshade/compare/`
4. Link that URL from your Nexus description (e.g. "▶ Interactive comparison").

The built-in **Demo (sample)** scene works immediately, so you can confirm the page
is live before adding real captures.
