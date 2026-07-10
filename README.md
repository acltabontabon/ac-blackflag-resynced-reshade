# Orange Begone - AC4 Black Flag (Resynced) ReShade Preset

A ReShade **6.7.3** preset for Assassin's Creed IV: Black Flag Resynced that does one thing
and does it well: it removes the game's strong baked-in orange/yellow grade and leaves a
clean, neutral image behind. No stylized filter, no "cinematic" gimmicks - just the orange
gone. The heavy lifting is done by a single selective color-grading pass (qUINT Lightroom)
rather than a stack of blunt global adjustments, so the correction is decisive and toggling
ReShade shows a clear, obvious difference.

All parameter names are verified against the actual shader sources
([martymcmodding/qUINT](https://github.com/martymcmodding/qUINT),
[CeeJayDK/SweetFX](https://github.com/CeeJayDK/SweetFX),
[crosire/reshade-shaders](https://github.com/crosire/reshade-shaders)) as shipped by the
ReShade 6.x installer, so every value loads exactly as written - no silent fallbacks to
shader defaults.

Tested on: **Windows 11 · NVIDIA RTX 5070 Ti (16 GB) · AMD Ryzen 7 7800X3D · 32 GB RAM.**
All four active effects are lightweight screen-space passes (no depth-buffer ray marching),
so the performance cost is negligible on this class of hardware and should stay small even
on mid-range GPUs.

## Screenshots

| Before                   | After              |
|--------------------------|--------------------|
| _vanilla (orange grade)_ | _preset applied_   |

## What the preset does

Four passes, in this exact order - clean up, grade, sharpen:

```
SMAA  ->  Deband  ->  Lightroom  ->  CAS
```

### Stage 0 - Cleanup

- **SMAA** - morphological anti-aliasing on the raw frame, before anything downstream can
  sharpen the jaggies. Uses luma edge detection (no depth buffer required) at threshold
  `0.10` with `32` search steps.
- **Deband** - dithers away color banding in smooth gradients (skies, ocean, haze) before
  the grade can amplify it. Runs at default detection thresholds with a single iteration;
  visually invisible except where banding would have appeared.

### Stage 1 - Grade (qUINT Lightroom)

A single static color-grading pass replaces the old LiftGammaGain + Tonemap + Curves +
Vibrance stack. One shader now handles white balance, exposure/tone shaping, and per-band
(HSL) selective color, so no two passes fight over the same operation. Lightroom is
LUT-based and must run before sharpening, hence its position here.

**How the orange/yellow is selectively reduced:**

- **Cooler white balance** - global temperature `-0.08` shifts the whole frame off the
  warm cast (toward blue ~202°). Enough to keep the image neutral and anti-orange without
  tipping cold or gray.
- **Orange & yellow saturation pulled down** - orange `-0.18`, yellow `-0.18`, so skin,
  sand, pale stone, blonde/brown hair, and cream fabric don't read gold. Orange is eased so
  shaded faces don't look pale; yellow is held a touch stronger to clear remaining gold in
  sand and painted walls. Red is only lightly trimmed (`-0.04`) so Edward's coat stays rich.
- **Warm-highlight luminance** - orange exposure `-0.01`, yellow exposure `-0.05`. Orange is
  near neutral so shaded skin regains natural brightness through luminance, not saturation;
  yellow stays trimmed so bright beige surfaces stay controlled - no orange returns.
- **Hue nudges** - yellow shifted slightly toward green (`+0.06`) so blondes read blonde,
  not gold; orange shifted toward red/peach (`-0.05`) so skin reads natural peach.
- **Foliage & sky** - green saturation `+0.08` keeps vegetation natural green; blue
  saturation `+0.05` keeps the sky clean blue. Aqua stays neutral (`0`) so nothing turns
  turquoise and clouds stay neutral white. A gentle global vibrance (`+0.025`) lifts
  low-saturation colors back without pumping the whole image.
- **Green/cyan cast fix** - a very small tint `-0.005` (toward magenta) keeps shadows and
  neutral architecture neutral without any pink/gray influence.

**Tone:** global exposure is neutral (`0`); highlights curve `-0.19` and whites curve `-0.05`
keep warm highlights in range while leaving sunlight and sand their tropical energy and
texture; shadows are raised slightly (`+0.03`), blacks left at `0` to preserve depth without
crushing dark interiors, and a small midtone lift (`+0.02`) plus `+0.10` contrast restore
face and material depth without Clarity or FakeHDR.

### Stage 2 - Sharpening

- **CAS (AMD FidelityFX Contrast Adaptive Sharpening)** - sharpens soft, low-contrast areas
  and backs off where contrast is already high, so it's less prone to ringing than uniform
  sharpening. Runs after the grade at `0.30` - crisp detail on faces and sails at 1080p
  without a visible "sharpened" edge.

> [!NOTE]
> This preset uses only static, depth-independent passes. Earlier revisions tried Bloom and
> MXAO (depth-based ambient occlusion) and removed both: Bloom's auto-exposure fought the
> game's built-in eye adaptation (darkened image, exposure flicker) and MXAO shimmered on
> this remake's unstable depth buffer. FakeHDR, Defog, LUTs, and film grain are intentionally
> not used - the goal is a clean neutral grade, not a stylized layer over the top.

## Install

1. Download ReShade **6.7.3** from [reshade.me](https://reshade.me/) and run the installer.
2. Point it at the game's main executable (the one you actually launch to play - not a
   launcher/updater). Let it auto-detect the rendering API.
3. When the installer asks which effect packages to install, check these three:
   - **Standard effects** - provides `Deband`
   - **SweetFX by CeeJay.dk** - provides `SMAA` and `CAS`
   - **qUINT by Marty McFly / Pascal Gilcher** - provides `Lightroom` (`qUINT_lightroom.fx`)
4. Copy `AC4BF_OrangeBegone.ini` next to the game executable (or anywhere you like).
5. Launch the game, press **Home** to open the ReShade overlay, and select the preset in
   the preset browser at the top (listed as `AC4BF_OrangeBegone`). All four active techniques
   enable automatically in the correct order.

> [!TIP]
> If the game's own anti-aliasing option is available, SMAA stacks fine on top of it -
> ReShade's SMAA catches the edges the in-game AA misses (thin railings, rigging). If you
> see any residual shimmer in motion, that's temporal aliasing, which no injector-level AA
> can fully fix - prefer the game's TAA/DLSS/FSR option as the base and keep this SMAA pass
> for the leftover static edges.

## Stronger anti-orange variant

If direct-sun scenes are still too warm for your taste, push the same Lightroom controls
further. Change only these lines in the `[qUINT_lightroom.fx]` section, then reload the
preset in the overlay (no restart needed):

```ini
[qUINT_lightroom.fx]
LIGHTROOM_ORANGE_SATURATION=-0.400000
LIGHTROOM_YELLOW_SATURATION=-0.280000
LIGHTROOM_ORANGE_EXPOSURE=-0.200000
LIGHTROOM_YELLOW_EXPOSURE=-0.150000
LIGHTROOM_GLOBAL_TEMPERATURE=-0.140000
LIGHTROOM_GREEN_SATURATION=0.120000
```

This deepens the cooling and de-golds sand/skin/stone more aggressively while the extra
green saturation keeps foliage from going dull. Watch skin in shade - if it starts to read
gray, ease the temperature back toward `-0.12`.

## Files

- `AC4BF_OrangeBegone.ini` - the preset.
- `packaging/INSTALL.txt` - short install guide bundled inside the release zip.
- `scripts/package.sh` - builds the Nexus-ready zip.
- `.github/workflows/release.yml` - auto-builds the zip and publishes a GitHub Release on tag push.

## Building a release

To build the distributable zip locally (output goes to `dist/`, which is git-ignored):

```sh
./scripts/package.sh v1.0.0
```

This produces `dist/AC4BF-OrangeBegone-v1.0.0.zip` containing the `.ini`, this README,
and `INSTALL.txt` at the top level - ready to upload to Nexus Mods.

To cut a GitHub Release automatically, push a version tag:

```sh
git tag v1.0.0
git push origin v1.0.0
```

The `Release` workflow builds the same zip and attaches it to a new GitHub Release. Download
that zip and upload it to Nexus, or link the release page. You can also trigger the workflow
manually from the Actions tab for a dry run (builds the zip as a downloadable artifact without
creating a release).

## Credits

- ReShade by crosire - [reshade.me](https://reshade.me/)
- qUINT Lightroom by Marty McFly (Pascal Gilcher)
- SMAA by Jorge Jimenez et al. (ReShade port by CeeJay.dk, ships with SweetFX)
- CAS (FidelityFX Contrast Adaptive Sharpening) by AMD (ReShade port by CeeJay.dk)
- Deband by haasn / crosire
