# Before/after comparison page

A self-contained page (`index.html`) — no build step, no dependencies.

Each scene is one of two kinds:

- **Interactive drag-wipe** — needs a matched pair of full frames (same spot, ReShade
  off + on) at `images/<id>-before.jpg` and `images/<id>-after.jpg`.
  Current interactive scenes: `street`, `encounter` (DLAA variant).
- **Static split** — falls back to an existing before/after composite in
  `../images/base/<id>.jpg`. Current static scenes: Havana rooftops, Harbor, Town
  square, Faces.

## Add an interactive scene

1. Capture two full-frame screenshots of the same spot — one ReShade off, one on
   (don't move the camera between them).
2. Save them as `images/<id>-before.jpg` + `images/<id>-after.jpg`.
3. Add an entry to the `SCENES` array in `index.html`:
   `{label:'My scene', before:'images/myscene-before.jpg', after:'images/myscene-after.jpg', cap:'…'}`

## Publish (GitHub Pages)

Enabled for this repo (`main` / `/docs`). Live at:
`https://acltabontabon.com/ac-blackflag-resynced-reshade/compare/`
