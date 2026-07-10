# 🎮 Orange Begone – AC4 Black Flag ReShade Preset

**Tired of that overwhelming orange cast?** This ReShade preset does one thing and does it beautifully: **removes the baked-in orange/yellow filter** and reveals a clean, neutral image underneath.

> No stylized filters. No "cinematic" gimmicks. Just the orange gone. ✨

---

## What You Get

✅ **Smart color grading** – uses a single selective pass instead of blunt global adjustments  
✅ **Obvious difference** – toggle ReShade on/off and see the transformation instantly  
✅ **Lightweight** – negligible performance cost even on mid-range GPUs  
✅ **Verified precision** – every parameter is checked against actual shader sources  

---

## 📸 Before & After

| Before | After |
|:---:|:---:|
| 🟠 Vanilla (orange grade) | ✨ Preset applied |

---

## 🛠 How It Works

The preset uses **4 passes** working in sequence:

```
SMAA  →  Deband  →  Lightroom  →  CAS
```

### 1️⃣ **Cleanup Stage**

**SMAA** *(Morphological Anti-Aliasing)*
- Smooths jagged edges before sharpening makes them worse
- Edge detection: luma-based (no depth buffer needed)
- Settings: threshold `0.10`, 32 search steps

**Deband**
- Removes color banding in smooth gradients (skies, ocean, water)
- Runs at default thresholds with one pass
- Visually invisible—only shows up where banding would have appeared

### 2️⃣ **Color Grade** (qUINT Lightroom)

This is where the magic happens. A single selective color-grading pass replaces multiple competing filters:

**How the orange/yellow gets removed:**
- **Cooler white balance** – shifts the whole frame slightly toward blue to neutralize the warm cast
- **Orange & yellow pulled back** – reduces saturation so skin, sand, and stone look natural instead of golden
- **Hue nudges** – yellows shift toward green (so blondes stay blonde), oranges shift toward red (so skin looks natural)
- **Smart saturation** – greens and blues stay vibrant so foliage and skies look fresh and clean
- **Tone adjustments** – highlights are controlled so bright surfaces don't blow out, shadows stay visible
- **Vibrance** – lifts muted colors without oversaturating everything

💡 **Result:** Edward looks like Edward, the Caribbean looks tropical, and nothing looks filtered.

### 3️⃣ **Sharpening** (CAS)

**CAS** *(Contrast Adaptive Sharpening by AMD)*
- Sharpens soft details on faces and sails
- Backs off where contrast is already high (no halos or weird artifacts)
- Crisp detail at `0.30` intensity without that "over-sharpened" look

---

## ⚡ Performance

| Metric | Details |
|--------|---------|
| **Resolution** | Tested at 1080p+ |
| **GPU** | NVIDIA RTX 5070 Ti (tested) |
| **CPU** | AMD Ryzen 7 7800X3D (tested) |
| **RAM** | 32 GB (tested) |
| **Impact** | Negligible – all passes are lightweight screen-space effects (no ray marching) |

---

## 🚀 Installation

### Step 1: Install ReShade
1. Download **ReShade 6.7.3** from [reshade.me](https://reshade.me/)
2. Run the installer and point it at your game executable (the one you actually launch to play)
3. Let it auto-detect your rendering API

### Step 2: Install Effect Packages
When the installer asks which effects to install, **check these three:**
- **Standard effects** → provides `Deband`
- **SweetFX by CeeJay.dk** → provides `SMAA` and `CAS`
- **qUINT by Marty McFly** → provides `Lightroom`

### Step 3: Add the Preset
1. Copy `AC4BF_OrangeBegone.ini` to your game folder (same location as the executable)
2. Launch the game
3. Press **Home** to open the ReShade overlay
4. Select **AC4BF_OrangeBegone** from the preset browser at the top
5. All four effects enable automatically in the correct order ✓

---

## 🎓 Technical Notes

> This preset uses **only static, depth-independent passes**. Earlier versions tried Bloom and MXAO (ambient occlusion) and removed both:
> - **Bloom** fought the game's built-in eye adaptation (caused darkening and exposure flicker)
> - **MXAO** shimmered on this remake's unstable depth buffer
>
> FakeHDR, Defog, LUTs, and film grain are intentionally excluded—the goal is a clean neutral grade, not a stylized layer on top.

**Parameter verification:** All shader parameters are verified against the actual shader sources to ensure they load exactly as written with no silent fallbacks to defaults.

---

## 🙏 Credits

- **ReShade** – [crosire](https://github.com/crosire/reshade-shaders) • [reshade.me](https://reshade.me/)
- **qUINT Lightroom** – Marty McFly (Pascal Gilcher)
- **SMAA** – Jorge Jimenez et al. (ReShade port by CeeJay.dk, ships with SweetFX)
- **CAS** – AMD FidelityFX (ReShade port by CeeJay.dk)
- **Deband** – haasn / crosire
