#!/usr/bin/env python3
"""
Generate Play Store tablet screenshots (7-inch & 10-inch) from phone golden screenshots.

Requirements:
  - 7-inch tablet:  16:9 or 9:16, each side 320–3840 px, PNG/JPEG, ≤ 8 MB
  - 10-inch tablet: 16:9 or 9:16, each side 1080–7680 px, PNG/JPEG, ≤ 8 MB

This script takes the phone-sized golden screenshots and places them centered
on a tablet-ratio canvas with a styled background.

Usage:
    python generate_tablet_screenshots.py [--source DIR] [--output DIR]

Dependencies:
    pip install Pillow
"""

from __future__ import annotations

import argparse
import os
import sys
from pathlib import Path
from typing import NamedTuple

from PIL import Image, ImageDraw, ImageFilter, ImageFont

# ---------------------------------------------------------------------------
# Configuration
# ---------------------------------------------------------------------------

class TabletSpec(NamedTuple):
    name: str
    width: int   # portrait width  (9:16)
    height: int  # portrait height (9:16)
    min_side: int
    max_side: int


# Target resolutions — portrait 9:16
TABLET_7_INCH = TabletSpec(
    name="7inch",
    width=1200,   # 9 * 133.33
    height=2133,  # 16 * 133.33  → ratio 9:16, sides in [320..3840]
    min_side=320,
    max_side=3840,
)

TABLET_10_INCH = TabletSpec(
    name="10inch",
    width=1620,   # 9 * 180
    height=2880,  # 16 * 180 → ratio 9:16, sides in [1080..7680]
    min_side=1080,
    max_side=7680,
)


# Background gradient colours (top, bottom) — matches app dark theme
BG_COLOR_TOP = (14, 14, 14)       # #0E0E0E — app backgroundDark
BG_COLOR_BOTTOM = (26, 26, 26)    # #1A1A1A — app surfaceDark

# Accent glow (teal, matching app primary #0D9488)
ACCENT_COLOR = (13, 148, 136)
ACCENT_GLOW_OPACITY = 40          # subtle glow behind the phone

# Device frame
PHONE_CORNER_RADIUS = 28
PHONE_BORDER_COLOR = (38, 38, 38) # #262626 — app surfaceSecondaryDark
PHONE_BORDER_WIDTH = 2
PHONE_SHADOW_OFFSET = 16
PHONE_SHADOW_COLOR = (0, 0, 0, 140)

MAX_FILE_SIZE = 8 * 1024 * 1024  # 8 MB


# ---------------------------------------------------------------------------
# Helpers
# ---------------------------------------------------------------------------

def make_gradient(width: int, height: int, top: tuple, bottom: tuple) -> Image.Image:
    """Create a vertical linear gradient image."""
    img = Image.new("RGB", (width, height), top)
    draw = ImageDraw.Draw(img)
    for y in range(height):
        ratio = y / max(height - 1, 1)
        r = int(top[0] + (bottom[0] - top[0]) * ratio)
        g = int(top[1] + (bottom[1] - top[1]) * ratio)
        b = int(top[2] + (bottom[2] - top[2]) * ratio)
        draw.line([(0, y), (width, y)], fill=(r, g, b))
    return img


def add_rounded_corners(img: Image.Image, radius: int) -> Image.Image:
    """Return RGBA image with rounded corners."""
    img = img.convert("RGBA")
    w, h = img.size
    mask = Image.new("L", (w, h), 0)
    draw = ImageDraw.Draw(mask)
    draw.rounded_rectangle([(0, 0), (w - 1, h - 1)], radius=radius, fill=255)
    img.putalpha(mask)
    return img


def create_shadow(size: tuple[int, int], offset: int, color: tuple) -> Image.Image:
    """Create a drop-shadow image (RGBA)."""
    w, h = size
    shadow = Image.new("RGBA", (w + offset * 2, h + offset * 2), (0, 0, 0, 0))
    draw = ImageDraw.Draw(shadow)
    draw.rounded_rectangle(
        [(offset, offset), (w + offset - 1, h + offset - 1)],
        radius=PHONE_CORNER_RADIUS,
        fill=color,
    )
    shadow = shadow.filter(ImageFilter.GaussianBlur(radius=offset))
    return shadow


def composite_phone_on_tablet(
    phone_img: Image.Image,
    canvas_w: int,
    canvas_h: int,
) -> Image.Image:
    """Place a phone screenshot centred on a tablet-sized gradient canvas."""
    # --- background ---
    bg = make_gradient(canvas_w, canvas_h, BG_COLOR_TOP, BG_COLOR_BOTTOM)

    # --- scale phone to fit nicely (≈75 % of canvas height) ---
    target_h = int(canvas_h * 0.72)
    scale = target_h / phone_img.height
    target_w = int(phone_img.width * scale)
    phone_resized = phone_img.resize((target_w, target_h), Image.LANCZOS)

    # rounded corners
    phone_rounded = add_rounded_corners(phone_resized, PHONE_CORNER_RADIUS)

    # border
    border_img = Image.new("RGBA", (target_w + PHONE_BORDER_WIDTH * 2,
                                     target_h + PHONE_BORDER_WIDTH * 2), (0, 0, 0, 0))
    draw = ImageDraw.Draw(border_img)
    draw.rounded_rectangle(
        [(0, 0), (border_img.width - 1, border_img.height - 1)],
        radius=PHONE_CORNER_RADIUS + PHONE_BORDER_WIDTH,
        outline=PHONE_BORDER_COLOR,
        width=PHONE_BORDER_WIDTH,
    )
    border_img.paste(phone_rounded, (PHONE_BORDER_WIDTH, PHONE_BORDER_WIDTH), phone_rounded)

    # shadow
    shadow = create_shadow(
        (border_img.width, border_img.height),
        PHONE_SHADOW_OFFSET,
        PHONE_SHADOW_COLOR,
    )
    total_w = shadow.width
    total_h = shadow.height

    # centre on canvas
    x = (canvas_w - total_w) // 2
    y = (canvas_h - total_h) // 2

    bg_rgba = bg.convert("RGBA")

    # --- subtle teal accent glow behind the phone ---
    glow_w = int(border_img.width * 1.3)
    glow_h = int(border_img.height * 1.1)
    glow = Image.new("RGBA", (glow_w, glow_h), (0, 0, 0, 0))
    glow_draw = ImageDraw.Draw(glow)
    glow_draw.rounded_rectangle(
        [(0, 0), (glow_w - 1, glow_h - 1)],
        radius=glow_w // 3,
        fill=(*ACCENT_COLOR, ACCENT_GLOW_OPACITY),
    )
    glow = glow.filter(ImageFilter.GaussianBlur(radius=glow_w // 4))
    glow_x = (canvas_w - glow_w) // 2
    glow_y = (canvas_h - glow_h) // 2
    bg_rgba.paste(glow, (glow_x, glow_y), glow)

    bg_rgba.paste(shadow, (x, y), shadow)
    bx = x + PHONE_SHADOW_OFFSET
    by = y + PHONE_SHADOW_OFFSET
    bg_rgba.paste(border_img, (bx, by), border_img)

    return bg_rgba.convert("RGB")


def resolve_dimensions(spec: TabletSpec) -> tuple[int, int]:
    """Return (width, height) that satisfies the spec constraints (portrait 9:16)."""
    w, h = spec.width, spec.height
    # Scale up if any side is below min
    if w < spec.min_side or h < spec.min_side:
        factor = max(spec.min_side / w, spec.min_side / h)
        w = int(w * factor)
        h = int(h * factor)
    # Ensure exact 9:16 ratio after rounding
    # Use h = w * 16 / 9, keep w a multiple of 9
    w = max(w, spec.min_side)
    # Round w to nearest multiple of 9
    w = (w // 9) * 9
    h = w * 16 // 9
    # Clamp
    if h > spec.max_side:
        h = (spec.max_side // 16) * 16
        w = h * 9 // 16
    if w < spec.min_side:
        w = ((spec.min_side + 8) // 9) * 9
        h = w * 16 // 9

    assert spec.min_side <= w <= spec.max_side, f"w={w} out of range"
    assert spec.min_side <= h <= spec.max_side, f"h={h} out of range"
    assert abs(w / h - 9 / 16) < 0.001, f"ratio {w/h:.4f} != 9/16"
    return w, h


def save_optimised(img: Image.Image, path: Path) -> None:
    """Save as PNG; if > 8 MB fall back to high-quality JPEG."""
    img.save(path, "PNG", optimize=True)
    if path.stat().st_size <= MAX_FILE_SIZE:
        return
    # Fallback: JPEG
    jpeg_path = path.with_suffix(".jpg")
    img.save(jpeg_path, "JPEG", quality=92, optimize=True)
    path.unlink()
    print(f"  ↳ PNG too large, saved as JPEG: {jpeg_path.name}")


# ---------------------------------------------------------------------------
# Main
# ---------------------------------------------------------------------------

def main() -> None:
    default_source = Path(__file__).resolve().parent.parent / "test" / "golden" / "goldens" / "playstore"
    default_output = Path(__file__).resolve().parent.parent / "test" / "golden" / "goldens" / "playstore"

    parser = argparse.ArgumentParser(description="Generate tablet screenshots for Play Store")
    parser.add_argument("--source", type=Path, default=default_source,
                        help="Directory containing phone golden PNGs")
    parser.add_argument("--output", type=Path, default=default_output,
                        help="Root output directory (sub-folders will be created)")
    args = parser.parse_args()

    source_dir: Path = args.source
    output_root: Path = args.output

    if not source_dir.is_dir():
        print(f"ERROR: Source directory not found: {source_dir}", file=sys.stderr)
        sys.exit(1)

    screenshots = sorted(source_dir.glob("*.png"))
    if not screenshots:
        print(f"ERROR: No PNG files found in {source_dir}", file=sys.stderr)
        sys.exit(1)

    print(f"Found {len(screenshots)} source screenshot(s) in {source_dir}")

    specs = [TABLET_7_INCH, TABLET_10_INCH]

    for spec in specs:
        canvas_w, canvas_h = resolve_dimensions(spec)
        out_dir = output_root / f"tablet_{spec.name}"
        out_dir.mkdir(parents=True, exist_ok=True)

        print(f"\n{'='*60}")
        print(f"Generating {spec.name} tablet screenshots  ({canvas_w}×{canvas_h}, 9:16)")
        print(f"  Min side: {spec.min_side} px  |  Max side: {spec.max_side} px")
        print(f"  Output: {out_dir}")
        print(f"{'='*60}")

        for src_path in screenshots[:8]:  # max 8 per spec
            phone_img = Image.open(src_path)
            result = composite_phone_on_tablet(phone_img, canvas_w, canvas_h)

            out_path = out_dir / src_path.name
            save_optimised(result, out_path)

            size_kb = out_path.stat().st_size / 1024
            final_path = out_path if out_path.exists() else out_path.with_suffix(".jpg")
            print(f"  ✓ {final_path.name}  ({canvas_w}×{canvas_h}, {size_kb:.0f} KB)")

    print(f"\nDone! Generated screenshots in:")
    for spec in specs:
        print(f"  • {output_root / f'tablet_{spec.name}'}")


if __name__ == "__main__":
    main()
