# AC4 Black Flag (Resynced) - Natural Cinematic ReShade Preset

A ReShade **6.7.3** preset for Assassin's Creed IV: Black Flag Resynced that removes the
game's baked-in yellow/sepia grade and replaces it with a neutral, filmic-but-restrained
look, plus a light detail/fidelity pass.

All parameter names are verified against the actual shader sources
([CeeJayDK/SweetFX](https://github.com/CeeJayDK/SweetFX),
[crosire/reshade-shaders](https://github.com/crosire/reshade-shaders),
[BlueSkyDefender/AstrayFX](https://github.com/BlueSkyDefender/AstrayFX)) as shipped by the
ReShade 6.x installer, so every value loads exactly as written - no silent fallbacks to
shader defaults.

Tested on: **Windows 11 · NVIDIA RTX 5070 Ti (16 GB) · AMD Ryzen 7 7800X3D · 32 GB RAM.**
All nine active effects are lightweight screen-space passes (no depth-buffer ray marching),
so the performance cost is negligible on this class of hardware and should stay small even
on mid-range GPUs.

## Screenshots

| Before                   | After              |
|--------------------------|--------------------|
| _vanilla (yellow grade)_ | _preset applied_   |

## What the preset does

Effects run in this exact order - cleanup first, color correction second, shaping third,
detail fourth, finish last:

### Stage 0 - Cleanup

- **SMAA** - morphological anti-aliasing on the raw frame, before anything downstream can
  sharpen the jaggies. Uses luma edge detection (no depth buffer required) at threshold
  `0.10` with `32` search steps - close to shader defaults, tuned down from an earlier,
  more aggressive pass that over-smoothed low-contrast edges and read as an obvious
  ReShade effect.
- **Deband** - dithers away color banding in smooth gradients (skies, ocean, haze) before
  any later pass can amplify it. Runs at default detection thresholds with a single
  iteration; visually invisible except where banding would have appeared.

> [!NOTE]
> Bloom and MXAO (depth-based ambient occlusion) were both tried and removed. Bloom's
> auto-exposure fought the game's built-in eye adaptation, causing a darkened image with
> visible exposure flicker. MXAO flickered too - this remake's depth buffer isn't stable
> enough for screen-space AO to lock onto. Both effects need something this game doesn't
> reliably provide, so this preset sticks to static, depth-independent passes only. The
> remake's native lighting and AO are already good; leave them to the game.

### Stage 1 - Base color correction (the de-yellowing)

- **LiftGammaGain** - the main fix, softened further from earlier passes. Blue midtone
  gamma is raised only slightly (`1.018`) and red lowered a little (`0.988`) to counter the
  warm cast without pushing shadows toward cyan; blue lift is left at neutral (`1.0`) since
  raising it darkened shadows toward blue faster than gamma/gain alone.
- **Tonemap** - `Defog` is off (`0.0`). LiftGammaGain now carries all of the de-yellowing,
  and running Defog alongside it double-corrected the warmth out of the image. The fog
  color stays **warm** (`1.0, 0.8, 0.45`) so re-enabling Defog later still cancels the right
  tint. A small global desaturation (`-0.04`) and a slight `-0.01` exposure trim rein in
  highlights; bleach-bypass is off.

### Stage 2 - Filmic shaping

- **Curves** - a gentle S-curve (`0.09` contrast) applied to **luma only**, so the added
  contrast doesn't pump saturation back up.
- **Vibrance** - light selective saturation (`0.04`) with the RGB balance nudged only
  slightly off 1:1:1 (`0.95 / 1.00 / 1.05`): ocean and jungle read a touch richer without
  visibly cooling skin tones, sand, or sails.

### Stage 3 - Detail & fidelity

- **Clarity** - local contrast at low strength (`0.12`), blend-masked so deep shadows and
  near-white highlights are excluded, with the dark-side intensity lowered (`0.30`) so
  shadow-side foliage and rigging don't gain contrast faster than the sunlit side. This
  reduces (not eliminates) halo risk at edges.
- **CAS (AMD FidelityFX Contrast Adaptive Sharpening)** - the adaptive successor to
  classic sharpening: it sharpens soft, low-contrast areas and backs off where contrast is
  already high, so it's less prone to ringing than uniform sharpening. Run under half
  strength (`0.4`) to stay clear of visible sharpening on faces and sails.

### Stage 4 - Cinematic finish

- **Vignette** - a light elliptical darkening (`-0.10`), wide radius, gradual falloff.
  Present enough to draw focus without reading as an added effect.

> [!NOTE]
> **FakeHDR and FilmGrain are not part of the active chain.** FakeHDR's highlight expansion
> stacked with Clarity/CAS read as overexposed in bright Caribbean daylight, and grain adds
> visible texture noise during normal play - both fight the "natural, not stylized" goal.
> FilmGrain's config is left commented out at the bottom of the `.ini` for screenshot use:
> uncomment it, add `FilmGrain@FilmGrain.fx` to `Techniques`/`TechniqueSorting`, and reload
> the preset.

## Install

1. Download ReShade **6.7.3** from [reshade.me](https://reshade.me/) and run the installer.
2. Point it at the game's main executable (the one you actually launch to play - not a
   launcher/updater). Let it auto-detect the rendering API.
3. When the installer asks which effect packages to install, check these three:
   - **Standard effects** - provides `Deband`
   - **SweetFX by CeeJay.dk** - provides `SMAA`, `LiftGammaGain`, `Tonemap`, `Curves`,
     `Vibrance`, `CAS`, `Vignette` (and `FilmGrain`, used only if you enable the optional
     block described above)
   - **AstrayFX by BlueSkyDefender** - provides `Clarity`
4. Copy `AC4BF_Natural_Cinematic.ini` next to the game executable (or anywhere you like).
5. Launch the game, press **Home** to open the ReShade overlay, and select the preset in
   the preset browser at the top. All nine active techniques enable automatically in the
   correct order.

> [!TIP]
> If the game's own anti-aliasing option is available, SMAA stacks fine on top of it -
> ReShade's SMAA catches the edges the in-game AA misses (thin railings, rigging). If you
> see any residual shimmer in motion, that's temporal aliasing, which no injector-level AA
> can fully fix - prefer the game's TAA/DLSS/FSR option as the base and keep this SMAA pass
> for the leftover static edges.

## Warmer / cooler variants

The whole grade lives in three `LiftGammaGain.fx` lines. To retune warmth without touching
anything else, adjust only these (Tonemap's `FogColor`/`Defog` are tuned to the neutral
values below and don't need to change for a mild shift):

**Warmer** (dial back the blue-up/red-down correction by about a third):

```ini
[LiftGammaGain.fx]
RGB_Lift=1.000000,1.000000,1.002000
RGB_Gamma=0.992000,0.999000,1.012000
RGB_Gain=0.996000,1.000000,1.004000
```

**Cooler** (push the correction about a third further than the default preset):

```ini
[LiftGammaGain.fx]
RGB_Lift=1.000000,1.000000,1.004000
RGB_Gamma=0.984000,0.997000,1.024000
RGB_Gain=0.992000,1.000000,1.008000
```

Edit these three lines directly in the `.ini`, then reload the preset in the ReShade
overlay (no restart needed).

## Files

- `AC4BF_Natural_Cinematic.ini` - the preset.

## Credits

- ReShade by crosire - [reshade.me](https://reshade.me/)
- SweetFX shaders by CeeJay.dk
- SMAA by Jorge Jimenez et al. (ReShade port by CeeJay.dk, ships with SweetFX)
- CAS (FidelityFX Contrast Adaptive Sharpening) by AMD (ReShade port by CeeJay.dk)
- Deband by haasn / crosire
- Clarity by Ioxa (distributed via AstrayFX by BlueSkyDefender)
