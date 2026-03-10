"""Common image helpers for LifeFlow tools."""

from __future__ import annotations

from pathlib import Path

from PIL import Image, ImageDraw, ImageFont


def load_image(path: str | Path) -> Image.Image:
    """Load an image from disk."""
    return Image.open(path).convert("RGBA")


def resize_contain(img: Image.Image, size: tuple[int, int]) -> Image.Image:
    """Resize image to fit within `size`, preserving aspect ratio."""
    img.thumbnail(size, Image.LANCZOS)
    return img


def resize_cover(img: Image.Image, size: tuple[int, int]) -> Image.Image:
    """Resize image to cover `size`, cropping excess."""
    w, h = size
    ratio = max(w / img.width, h / img.height)
    resized = img.resize(
        (int(img.width * ratio), int(img.height * ratio)), Image.LANCZOS
    )
    left = (resized.width - w) // 2
    top = (resized.height - h) // 2
    return resized.crop((left, top, left + w, top + h))


def create_gradient(
    size: tuple[int, int],
    color_start: tuple[int, ...],
    color_end: tuple[int, ...],
    direction: str = "horizontal",
) -> Image.Image:
    """Create a gradient image."""
    w, h = size
    img = Image.new("RGBA", size)
    for i in range(w if direction == "horizontal" else h):
        ratio = i / (w if direction == "horizontal" else h)
        r = int(color_start[0] + (color_end[0] - color_start[0]) * ratio)
        g = int(color_start[1] + (color_end[1] - color_start[1]) * ratio)
        b = int(color_start[2] + (color_end[2] - color_start[2]) * ratio)
        a = 255
        if direction == "horizontal":
            ImageDraw.Draw(img).line([(i, 0), (i, h)], fill=(r, g, b, a))
        else:
            ImageDraw.Draw(img).line([(0, i), (w, i)], fill=(r, g, b, a))
    return img


def add_rounded_corners(img: Image.Image, radius: int) -> Image.Image:
    """Add rounded corners to an image."""
    mask = Image.new("L", img.size, 0)
    draw = ImageDraw.Draw(mask)
    draw.rounded_rectangle([(0, 0), img.size], radius=radius, fill=255)
    result = img.copy()
    result.putalpha(mask)
    return result


def get_font(size: int, bold: bool = False) -> ImageFont.FreeTypeFont:
    """Get a font, falling back to default if system fonts aren't available."""
    font_candidates = [
        "C:/Windows/Fonts/segoeui.ttf",
        "C:/Windows/Fonts/segoeuib.ttf",
        "C:/Windows/Fonts/arial.ttf",
        "C:/Windows/Fonts/arialbd.ttf",
    ]
    if bold:
        font_candidates = [
            "C:/Windows/Fonts/segoeuib.ttf",
            "C:/Windows/Fonts/arialbd.ttf",
        ] + font_candidates

    for font_path in font_candidates:
        try:
            return ImageFont.truetype(font_path, size)
        except OSError:
            continue
    return ImageFont.load_default()


def save_png(img: Image.Image, path: str | Path) -> Path:
    """Save image as PNG, creating parent dirs if needed."""
    path = Path(path)
    path.parent.mkdir(parents=True, exist_ok=True)
    # Convert RGBA to RGB if saving as JPEG-like PNG without transparency
    if img.mode == "RGBA":
        bg = Image.new("RGB", img.size, (255, 255, 255))
        bg.paste(img, mask=img.split()[3])
        bg.save(path, "PNG", optimize=True)
    else:
        img.save(path, "PNG", optimize=True)
    return path
