# Changelog

All notable changes to Orange Begone preset are documented here.

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
