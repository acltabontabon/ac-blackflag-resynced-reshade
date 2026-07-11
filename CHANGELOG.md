# Changelog

All notable changes to Orange Begone preset are documented here.

## [1.1.2] – 2026-07-12

DLAA variant only. The base preset is unchanged.

### Changed
- **DLAA variant:** CAS `Contrast` raised to 0.12 (was 0.00). Biases sharpening toward
  the low-contrast texture DLAA actually leaves soft, instead of pushing harder on edges
  that are already clean. Prefer raising this over raising `Sharpening`.
- **DLAA variant:** Deband `t1` lowered to 0.005 (was 0.007). DLAA's temporal jitter
  already acts as mild dithering, so Deband can smooth less aggressively and preserve
  more fine detail. Revert to 0.007 if banding reappears in night skies.
- **DLAA variant:** `ORANGE_SATURATION` set to -0.20 (was -0.18 in the base preset).
  An interim build of this release shipped -0.22, which over-drained the orange band and
  made skin read ashy — dark skin in night interiors and lit faces in direct daylight
  both showed it, which pointed at the preset rather than the game. `ORANGE_HUESHIFT`
  (-0.06) is unchanged and is the lever that actually removes the orange cast, so -0.20
  keeps nearly all of the correction while giving skin its warmth back.

Both CAS and Deband changes are spatial-only and do not touch hue, saturation, or white
balance, so they cannot affect the orange fix.

### Added
- **DLAA variant:** documented the NVIDIA driver settings the preset assumes — leave the
  DLSS Override dialogs at their defaults and select DLAA in-game; keep frame generation
  and Smooth Motion off (they interpolate *after* ReShade runs); don't stack DSR with
  DLAA; and keep **RTX Dynamic Vibrance off**, as it re-saturates after the grade and is
  the one driver setting that will actively undo the preset.

## [1.1.0] – 2026-07-11

### Added
- **DLAA variant** (`AC4BF_OrangeBegone_DLAA.ini`) for NVIDIA DLAA / DLSS / TAA users:
  SMAA removed (temporal AA already handles edges), CAS raised to 0.40, orange band
  deepened for more natural skin, and a gentler -0.05 white-balance cooling.
- Before/after comparison screenshots for both the base preset and the DLAA variant.
- "Recommended Game & Driver Settings" section in the README (anti-aliasing guidance,
  anisotropic filtering, NVIDIA DLDSR, frame generation).
- SDR compatibility note (disable Auto HDR / RTX HDR).

### Changed
- Comparison images reorganized under `docs/images/base/` and `docs/images/dlaa/`.

## [1.0.0] – 2026-07-11

### Initial Release

First official release of Orange Begone—a ReShade preset for AC4 Black Flag (Resynced) that removes the game's baked-in orange/yellow color grade.

**Includes:**
- SMAA anti-aliasing for clean edges
- Deband pass to remove color banding in gradients
- qUINT Lightroom selective color grading (removes orange/yellow cast)
- CAS contrast-adaptive sharpening

**Tested on:**
- Windows 11
- NVIDIA RTX 5070 Ti (16 GB)
- AMD Ryzen 7 7800X3D
- 32 GB RAM

See [README.md](README.md) for full details on how the preset works and how to install it.
