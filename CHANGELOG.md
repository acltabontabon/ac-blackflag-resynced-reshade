# Changelog

All notable changes to Orange Begone preset are documented here.

## [1.1.1] – 2026-07-11

DLAA variant only. The base preset is unchanged.

### Changed
- **DLAA variant:** CAS `Contrast` raised to 0.12 (was 0.00). Biases sharpening toward
  the low-contrast texture DLAA actually leaves soft, instead of pushing harder on edges
  that are already clean. Prefer raising this over raising `Sharpening`.
- **DLAA variant:** Deband `t1` lowered to 0.005 (was 0.007). DLAA's temporal jitter
  already acts as mild dithering, so Deband can smooth less aggressively and preserve
  more fine detail. Revert to 0.007 if banding reappears in night skies.

Both changes are spatial-only and do not touch hue, saturation, or white balance — the
orange fix is unaffected. `ORANGE_SATURATION` deliberately stays at -0.22.

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
