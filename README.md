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
All ten effects are lightweight screen-space passes (no depth-buffer ray marching), so the
performance cost is negligible on this class of hardware and should stay small even on
mid-range GPUs.

## Screenshots

| Before                   | After              |
|--------------------------|--------------------|
| _vanilla (yellow grade)_ | _preset applied_   |

## What the preset does

Effects run in this exact order - cleanup first, color correction second, shaping third,
detail fourth, finish last:

### Stage 0 - Cleanup

- **SMAA** - morphological anti-aliasing on the raw frame, before anything downstream can
  sharpen the jaggies. Uses luma edge detection (no depth buffer required) with the
  threshold lowered to `0.08` and search steps raised to `48`, so near-horizontal edges -
  stair treads, ship railings, rigging lines - resolve into smooth gradients instead of
  staircases.
- **Deband** - dithers away color banding in smooth gradients (skies, ocean, haze) before
  any later pass can amplify it. Runs at default detection thresholds with a single
  iteration; visually invisible except where banding would have appeared.

### Stage 1 - Base color correction (the de-yellowing)

- **LiftGammaGain** - the main fix. Blue midtone gamma is raised (`1.035`) and red lowered
  (`0.98`), directly countering the warm cast in the midtones where it lives, with matching
  hair-width adjustments to shadows (lift) and highlights (gain). Exposure is untouched.
- **Tonemap** - a tiny `Defog` (`0.02`) with a **warm** fog color (`1.0, 0.8, 0.45`).
  Defog subtracts the fog color from the frame, so a warm fog color cancels the game's warm
  atmospheric haze layer specifically. Also applies a small global desaturation (`-0.05`),
  since the vanilla grade oversaturates, and a whisper of bleach-bypass (`0.02`).

### Stage 2 - Filmic shaping

- **Curves** - a gentle S-curve (`0.12` contrast) applied to **luma only**, so the added
  contrast never pumps saturation back up.
- **Vibrance** - selective saturation (`0.10`) with the RGB balance weighted away from red
  (`0.70`) and toward blue (`1.25`): ocean and jungle read rich again without re-warming
  skin tones, sand, and stone.

### Stage 3 - Detail & fidelity

- **Clarity** - local contrast at moderate strength (`0.25`), blend-masked so deep shadows
  and near-white highlights are excluded. This adds the "crisp midtone detail" look without
  halos or the HDR-photo effect.
- **LumaSharpen** - classic luma-only sharpening (`0.55` strength, clamped at `0.035`) for
  edge definition on rigging, foliage, and architecture without ringing artifacts.

### Stage 4 - Cinematic finish

- **Vignette** - a subtle elliptical darkening (`-0.35`), wide radius, gradual falloff.
  Present enough to focus the frame, not enough to read as an effect.
- **FilmGrain** - faint grain (`0.15` intensity) with a high signal-to-noise setting (`8`)
  so it lives in the shadows and stays out of bright sky and sand - reads as film, not
  sensor noise.

## Install

1. Download ReShade **6.7.3** from [reshade.me](https://reshade.me/) and run the installer.
2. Point it at the game's main executable (the one you actually launch to play - not a
   launcher/updater). Let it auto-detect the rendering API.
3. When the installer asks which effect packages to install, check these three:
   - **Standard effects** - provides `SMAA` and `Deband`
   - **SweetFX by CeeJay.dk** - provides `LiftGammaGain`, `Tonemap`, `Curves`, `Vibrance`,
     `LumaSharpen`, `Vignette`, `FilmGrain`
   - **AstrayFX by BlueSkyDefender** - provides `Clarity`
4. Copy `AC4BF_Natural_Cinematic.ini` next to the game executable (or anywhere you like).
5. Launch the game, press **Home** to open the ReShade overlay, and select the preset in
   the preset browser at the top. All ten techniques enable automatically in the correct
   order.

> [!TIP]
> If the game's own anti-aliasing option is available, SMAA stacks fine on top of it -
> ReShade's SMAA catches the edges the in-game AA misses (thin railings, rigging). If you
> see any residual shimmer in motion, that's temporal aliasing, which no injector-level AA
> can fully fix - prefer the game's TAA/DLSS/FSR option as the base and keep this SMAA pass
> for the leftover static edges.

## Files

- `AC4BF_Natural_Cinematic.ini` - the preset.

## Credits

- ReShade by crosire - [reshade.me](https://reshade.me/)
- SweetFX shaders by CeeJay.dk
- SMAA by Jorge Jimenez et al. (ReShade port in standard effects)
- Deband by haasn / crosire
- Clarity by Ioxa (distributed via AstrayFX by BlueSkyDefender)
