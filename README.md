# AC4 Black Flag (Resynced) - Natural Cinematic ReShade Preset

A ReShade **6.7.3** preset for Assassin's Creed IV: Black Flag Resynced that removes the
game's baked-in yellow/sepia grade and replaces it with a neutral, filmic-but-restrained
look, plus a light detail/fidelity pass.

All parameter names are verified against the actual shader sources
([CeeJayDK/SweetFX](https://github.com/CeeJayDK/SweetFX),
[crosire/reshade-shaders](https://github.com/crosire/reshade-shaders),
[BlueSkyDefender/AstrayFX](https://github.com/BlueSkyDefender/AstrayFX),
[martymcmodding/qUINT](https://github.com/martymcmodding/qUINT)) as shipped by the
ReShade 6.x installer, so every value loads exactly as written - no silent fallbacks to
shader defaults.

Tested on: **Windows 11 · NVIDIA RTX 5070 Ti (16 GB) · AMD Ryzen 7 7800X3D · 32 GB RAM.**
Eleven of the twelve effects are lightweight screen-space passes; MXAO (depth-based
ambient occlusion) is the heavier one, but at these settings the total cost stays
comfortably small on this class of hardware. On mid-range GPUs, drop
`MXAO_GLOBAL_SAMPLE_QUALITY_PRESET` to `2` and/or `MXAO_GLOBAL_RENDER_SCALE` to `0.75`
before touching anything else.

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

### Stage 0.5 - Lighting (depth-based)

- **MXAO** - screen-space ambient occlusion in GTAO mode (`MXAO_HIGH_QUALITY=1`), which is
  the physically-based variant with no halo artifacts. Adds the contact shadows the game's
  baked AO misses - under ledges, between planks, where props meet the ground - so flat
  scenes gain real depth. Amount is kept at `0.70` (below neutral) because it stacks on top
  of the game's own AO; a depth fade-out at `0.4` keeps distant haze and sky untouched.

It runs **before** the color grade, so the de-yellowing pass tames its output too.

> [!NOTE]
> Bloom is deliberately **not** part of this preset. Injector-level bloom shaders bring
> their own auto-exposure, which fights the game's built-in eye adaptation - the result is
> a darkened image and visible exposure flicker. The remake's native bloom is already good;
> leave it to the game.

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
- **FakeHDR** - static local dynamic-range expansion: shadows get deeper, highlights get
  brighter, midtone detail gains "pop". Unlike bloom-style shaders it has **no exposure or
  adaptation logic** - the same pixel always maps the same way - so it cannot pump or
  flicker. Power is kept at `1.15` (below the `1.30` default) since Curves already carries
  global contrast.
- **Vibrance** - selective saturation (`0.10`) with the RGB balance weighted away from red
  (`0.70`) and toward blue (`1.25`): ocean and jungle read rich again without re-warming
  skin tones, sand, and stone.

### Stage 3 - Detail & fidelity

- **Clarity** - local contrast at moderate strength (`0.25`), blend-masked so deep shadows
  and near-white highlights are excluded. This adds the "crisp midtone detail" look without
  halos or the HDR-photo effect.
- **CAS (AMD FidelityFX Contrast Adaptive Sharpening)** - the adaptive successor to
  classic sharpening: it sharpens soft, low-contrast areas strongly and automatically backs
  off where contrast is already high, so it never rings or halos - and never re-jags the
  edges SMAA smoothed in Stage 0. Full strength (`1.0`) is safe precisely because of that
  adaptivity.

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
3. When the installer asks which effect packages to install, check these four:
   - **Standard effects** - provides `Deband` (and `DisplayDepth` for the depth check below)
   - **SweetFX by CeeJay.dk** - provides `SMAA`, `LiftGammaGain`, `Tonemap`, `Curves`,
     `FakeHDR`, `Vibrance`, `CAS`, `Vignette`, `FilmGrain`
   - **AstrayFX by BlueSkyDefender** - provides `Clarity`
   - **qUINT by Marty McFly** - provides `MXAO`
4. Copy `AC4BF_Natural_Cinematic.ini` next to the game executable (or anywhere you like).
5. Launch the game, press **Home** to open the ReShade overlay, and select the preset in
   the preset browser at the top. All twelve techniques enable automatically in the correct
   order.

### Depth buffer (required for MXAO)

MXAO is the one effect here that needs the game's **depth buffer**. Verify it once:

1. In the ReShade overlay, enable the `DisplayDepth` shader (ships with Standard effects).
2. You should see a grayscale depth view (near = dark, far = light) on one half and normals
   on the other. If so, disable `DisplayDepth` again - you're done.
3. If instead it's solid black/white: open the **Add-ons** tab → **Generic Depth**, and try
   the listed depth buffer candidates until the preview looks right. Usually the highest-
   resolution candidate is the correct one.
4. If depth stays unavailable, MXAO simply has no effect (everything else still works).
   In that case disable the `MXAO` technique to save the GPU time.

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
- SMAA by Jorge Jimenez et al. (ReShade port by CeeJay.dk, ships with SweetFX)
- CAS (FidelityFX Contrast Adaptive Sharpening) by AMD (ReShade port by CeeJay.dk)
- MXAO by Marty McFly (Pascal Gilcher) - [qUINT](https://github.com/martymcmodding/qUINT)
- Deband by haasn / crosire
- Clarity by Ioxa (distributed via AstrayFX by BlueSkyDefender)
