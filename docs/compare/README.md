# Before/after gallery

A self-contained page (`index.html`) that shows the Orange Begone before/after
comparison shots with a scene picker. No build step, no dependencies, nothing to
add — it displays the composite images already in `docs/images/`.

## Add or change scenes

Edit the `SCENES` array near the bottom of `index.html`. Each entry points at an
image already in the repo, e.g.:

```js
{label:'Harbor', src:'../images/base/harbor.jpg', cap:'Open water reads properly blue.'}
```

## Publish it (GitHub Pages)

Already enabled for this repo (Settings → Pages → `main` / `/docs`). The page is at:
`https://acltabontabon.com/ac-blackflag-resynced-reshade/compare/`
