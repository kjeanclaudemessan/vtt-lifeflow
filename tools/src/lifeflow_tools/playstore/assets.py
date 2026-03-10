"""Play Store asset generation.

Generates:
- Icon 512x512 (from existing 1024x1024)
- Feature graphic 1024x500
- Phone screenshot frames (1080x1920)
- Tablet 7" screenshot frames (1200x1920)
- Tablet 10" screenshot frames (1600x2560)
"""

from __future__ import annotations

import shutil
from pathlib import Path

import click
from PIL import Image, ImageDraw, ImageFilter

from lifeflow_tools.utils.image import (
    add_rounded_corners,
    create_gradient,
    get_font,
    load_image,
    save_png,
)

# ── Paths ────────────────────────────────────────────────────────────────────
ROOT = Path(__file__).resolve().parents[4]  # lifeflow/
FLUTTER = ROOT / "flutter"
ICON_SRC = FLUTTER / "assets" / "icon" / "app_icon.png"
OUTPUT = ROOT / "tools" / "output" / "playstore"

# ── Brand Colors ─────────────────────────────────────────────────────────────
PRIMARY = (13, 148, 136)        # 0xFF0D9488 — Teal
PRIMARY_LIGHT = (20, 184, 166)  # 0xFF14B8A6
PRIMARY_DARK = (15, 118, 110)   # 0xFF0F766E
WHITE = (255, 255, 255)
BLACK = (0, 0, 0)
NEUTRAL_100 = (245, 245, 245)
NEUTRAL_800 = (66, 66, 66)

# ── Screen definitions for screenshots ───────────────────────────────────────
SCREENS = [
    {
        "id": "01_login",
        "title": "Connexion sécurisée",
        "subtitle": "Créez votre compte en quelques secondes",
        "emoji": "🔐",
    },
    {
        "id": "02_dashboard",
        "title": "Tableau de bord",
        "subtitle": "Vue d'ensemble de tous vos domaines",
        "emoji": "📊",
    },
    {
        "id": "03_habits",
        "title": "Suivi d'habitudes",
        "subtitle": "Suivez votre progression quotidienne",
        "emoji": "🎯",
    },
    {
        "id": "04_domains",
        "title": "5 Domaines de vie",
        "subtitle": "Santé, Travail, Relations, Finances, Dev. perso",
        "emoji": "🌐",
    },
    {
        "id": "05_stats",
        "title": "Statistiques détaillées",
        "subtitle": "Visualisez votre progression",
        "emoji": "📈",
    },
]


def _ensure_output() -> None:
    """Create output directories."""
    for sub in ["icon", "feature", "phone", "tablet_7", "tablet_10"]:
        (OUTPUT / sub).mkdir(parents=True, exist_ok=True)


# ═════════════════════════════════════════════════════════════════════════════
# 1. ICON 512x512
# ═════════════════════════════════════════════════════════════════════════════


def generate_icon() -> Path:
    """Resize the 1024x1024 app icon to 512x512 for Play Store."""
    icon = Image.open(ICON_SRC).convert("RGB")
    icon = icon.resize((512, 512), Image.LANCZOS)
    out = save_png(icon, OUTPUT / "icon" / "icon_512x512.png")
    click.echo(f"  ✅ Icon 512×512 → {out.relative_to(ROOT)}")
    return out


# ═════════════════════════════════════════════════════════════════════════════
# 2. FEATURE GRAPHIC 1024x500
# ═════════════════════════════════════════════════════════════════════════════


def generate_feature_graphic() -> Path:
    """Create the Play Store feature graphic (1024x500)."""
    W, H = 1024, 500
    img = Image.new("RGB", (W, H))

    # Gradient background (primary dark → primary)
    grad = create_gradient((W, H), PRIMARY_DARK, PRIMARY, direction="horizontal")
    img.paste(grad)

    draw = ImageDraw.Draw(img)

    # App icon (centered left area, with rounded corners, shadow)
    icon = Image.open(ICON_SRC).convert("RGBA")
    icon_size = 200
    icon = icon.resize((icon_size, icon_size), Image.LANCZOS)
    icon = add_rounded_corners(icon, 40)

    icon_x = 80
    icon_y = (H - icon_size) // 2

    # Shadow
    shadow = Image.new("RGBA", (icon_size + 20, icon_size + 20), (0, 0, 0, 0))
    shadow_draw = ImageDraw.Draw(shadow)
    shadow_draw.rounded_rectangle(
        [(10, 10), (icon_size + 10, icon_size + 10)],
        radius=40,
        fill=(0, 0, 0, 60),
    )
    shadow = shadow.filter(ImageFilter.GaussianBlur(8))
    img.paste(shadow, (icon_x - 5, icon_y + 5), shadow)
    img.paste(icon, (icon_x, icon_y), icon)

    # Title text
    font_title = get_font(64, bold=True)
    font_sub = get_font(28)
    font_tagline = get_font(22)

    text_x = icon_x + icon_size + 60

    draw.text((text_x, 140), "LifeFlow", fill=WHITE, font=font_title)
    draw.text(
        (text_x, 220),
        "Organisez votre vie.",
        fill=(*WHITE[:3], 230),
        font=font_sub,
    )
    draw.text(
        (text_x, 260),
        "Suivez vos habitudes.",
        fill=(*WHITE[:3], 230),
        font=font_sub,
    )
    draw.text(
        (text_x, 300),
        "Atteignez vos objectifs.",
        fill=(*WHITE[:3], 230),
        font=font_sub,
    )

    # Bottom tagline
    draw.text(
        (text_x, 370),
        "🌱 Santé · Travail · Relations · Finances · Dev. perso",
        fill=(*WHITE[:3], 180),
        font=font_tagline,
    )

    # Decorative dots (right side)
    for i in range(5):
        for j in range(8):
            cx = W - 120 + j * 18
            cy = 100 + i * 60
            alpha = max(40, 120 - (i + j) * 10)
            draw.ellipse(
                [(cx - 3, cy - 3), (cx + 3, cy + 3)],
                fill=(*WHITE[:3], alpha),
            )

    out = save_png(img, OUTPUT / "feature" / "feature_graphic_1024x500.png")
    click.echo(f"  ✅ Feature graphic 1024×500 → {out.relative_to(ROOT)}")
    return out


# ═════════════════════════════════════════════════════════════════════════════
# 3. SCREENSHOT FRAMES
# ═════════════════════════════════════════════════════════════════════════════


def _create_screenshot_frame(
    screen: dict,
    size: tuple[int, int],
    output_dir: Path,
) -> Path:
    """Create a branded screenshot frame for a given screen definition.

    The frame contains:
    - Gradient background
    - Title + subtitle text at top
    - Placeholder phone/tablet mockup in center
    - Brand footer
    """
    W, H = size
    is_phone = W < 1200
    img = Image.new("RGBA", (W, H))

    # Gradient background (white to light teal)
    grad = create_gradient(
        (W, H),
        NEUTRAL_100,
        (230, 247, 245),  # primaryContainer-ish
        direction="vertical",
    )
    img.paste(grad)

    draw = ImageDraw.Draw(img)

    # ── Top section: emoji + title + subtitle ────────────────────────────
    scale = W / 1080  # Scale factor relative to phone size
    title_size = int(52 * scale)
    sub_size = int(28 * scale)
    emoji_size = int(60 * scale)
    top_margin = int(80 * scale)

    font_emoji = get_font(emoji_size)
    font_title = get_font(title_size, bold=True)
    font_sub = get_font(sub_size)

    # Emoji
    emoji_text = screen["emoji"]
    emoji_bbox = draw.textbbox((0, 0), emoji_text, font=font_emoji)
    emoji_w = emoji_bbox[2] - emoji_bbox[0]
    draw.text(
        ((W - emoji_w) // 2, top_margin),
        emoji_text,
        font=font_emoji,
    )

    # Title
    title_y = top_margin + int(80 * scale)
    title_text = screen["title"]
    title_bbox = draw.textbbox((0, 0), title_text, font=font_title)
    title_w = title_bbox[2] - title_bbox[0]
    draw.text(
        ((W - title_w) // 2, title_y),
        title_text,
        fill=BLACK,
        font=font_title,
    )

    # Subtitle
    sub_y = title_y + int(60 * scale)
    sub_text = screen["subtitle"]
    sub_bbox = draw.textbbox((0, 0), sub_text, font=font_sub)
    sub_w = sub_bbox[2] - sub_bbox[0]
    draw.text(
        ((W - sub_w) // 2, sub_y),
        sub_text,
        fill=NEUTRAL_800,
        font=font_sub,
    )

    # ── Center: device mockup placeholder ────────────────────────────────
    mockup_top = sub_y + int(80 * scale)
    mockup_margin = int(80 * scale)
    mockup_w = W - 2 * mockup_margin
    mockup_h = H - mockup_top - int(100 * scale)
    mockup_radius = int(24 * scale)

    # Shadow
    shadow = Image.new("RGBA", (mockup_w + 30, mockup_h + 30), (0, 0, 0, 0))
    s_draw = ImageDraw.Draw(shadow)
    s_draw.rounded_rectangle(
        [(15, 15), (mockup_w + 15, mockup_h + 15)],
        radius=mockup_radius,
        fill=(0, 0, 0, 40),
    )
    shadow = shadow.filter(ImageFilter.GaussianBlur(12))
    img.paste(shadow, (mockup_margin - 8, mockup_top + 8), shadow)

    # Device frame (white rounded rect)
    draw.rounded_rectangle(
        [
            (mockup_margin, mockup_top),
            (mockup_margin + mockup_w, mockup_top + mockup_h),
        ],
        radius=mockup_radius,
        fill=WHITE,
        outline=(*PRIMARY, 60),
        width=2,
    )

    # ── Screen content placeholder (gradient + icon + text) ──────────────
    content_margin = int(12 * scale)
    cx = mockup_margin + content_margin
    cy = mockup_top + content_margin
    cw = mockup_w - 2 * content_margin
    ch = mockup_h - 2 * content_margin

    # Status bar simulation
    bar_h = int(32 * scale)
    draw.rounded_rectangle(
        [(cx, cy), (cx + cw, cy + bar_h)],
        radius=int(8 * scale),
        fill=PRIMARY,
    )
    bar_font = get_font(int(14 * scale))
    draw.text(
        (cx + int(12 * scale), cy + int(8 * scale)),
        "LifeFlow",
        fill=WHITE,
        font=bar_font,
    )

    # Content area — centered icon + feature text
    center_y = cy + ch // 2 - int(40 * scale)
    center_icon = Image.open(ICON_SRC).convert("RGBA")
    ci_size = int(80 * scale)
    center_icon = center_icon.resize((ci_size, ci_size), Image.LANCZOS)
    center_icon = add_rounded_corners(center_icon, int(16 * scale))
    icon_x = (W - ci_size) // 2
    img.paste(center_icon, (icon_x, center_y), center_icon)

    feature_font = get_font(int(20 * scale))
    feature_text = f"Écran : {screen['title']}"
    fb = draw.textbbox((0, 0), feature_text, font=feature_font)
    fw = fb[2] - fb[0]
    draw.text(
        ((W - fw) // 2, center_y + ci_size + int(20 * scale)),
        feature_text,
        fill=NEUTRAL_800,
        font=feature_font,
    )

    hint_font = get_font(int(14 * scale))
    hint = "Remplacez par une vraie capture d'écran"
    hb = draw.textbbox((0, 0), hint, font=hint_font)
    hw = hb[2] - hb[0]
    draw.text(
        ((W - hw) // 2, center_y + ci_size + int(50 * scale)),
        hint,
        fill=(*NEUTRAL_800, 120),
        font=hint_font,
    )

    # ── Bottom brand bar ─────────────────────────────────────────────────
    brand_font = get_font(int(16 * scale))
    brand_text = "LifeFlow — VitaTech Solutions"
    bb = draw.textbbox((0, 0), brand_text, font=brand_font)
    bw = bb[2] - bb[0]
    draw.text(
        ((W - bw) // 2, H - int(50 * scale)),
        brand_text,
        fill=(*PRIMARY, 150),
        font=brand_font,
    )

    filename = f"{screen['id']}.png"
    out = save_png(img, output_dir / filename)
    return out


def generate_phone_screenshots() -> list[Path]:
    """Generate phone screenshot frames (1080x1920)."""
    results = []
    for screen in SCREENS:
        out = _create_screenshot_frame(screen, (1080, 1920), OUTPUT / "phone")
        results.append(out)
    click.echo(
        f"  ✅ Phone screenshots ({len(results)}) → "
        f"{(OUTPUT / 'phone').relative_to(ROOT)}"
    )
    return results


def generate_tablet_7_screenshots() -> list[Path]:
    """Generate tablet 7" screenshot frames (1200x1920)."""
    results = []
    for screen in SCREENS:
        out = _create_screenshot_frame(screen, (1200, 1920), OUTPUT / "tablet_7")
        results.append(out)
    click.echo(
        f"  ✅ Tablet 7\" screenshots ({len(results)}) → "
        f"{(OUTPUT / 'tablet_7').relative_to(ROOT)}"
    )
    return results


def generate_tablet_10_screenshots() -> list[Path]:
    """Generate tablet 10" screenshot frames (1600, 2560)."""
    results = []
    for screen in SCREENS:
        out = _create_screenshot_frame(screen, (1600, 2560), OUTPUT / "tablet_10")
        results.append(out)
    click.echo(
        f"  ✅ Tablet 10\" screenshots ({len(results)}) → "
        f"{(OUTPUT / 'tablet_10').relative_to(ROOT)}"
    )
    return results


# ═════════════════════════════════════════════════════════════════════════════
# CLI COMMANDS
# ═════════════════════════════════════════════════════════════════════════════


@click.group("playstore")
def playstore() -> None:
    """Play Store asset generation."""


@playstore.command()
@click.option("--clean", is_flag=True, help="Remove output folder before generating")
def generate(clean: bool) -> None:
    """Generate all Play Store assets."""
    click.echo("\n╔══════════════════════════════════════════════╗")
    click.echo("║   LifeFlow — Play Store Asset Generator      ║")
    click.echo("╚══════════════════════════════════════════════╝\n")

    if clean and OUTPUT.exists():
        shutil.rmtree(OUTPUT)
        click.echo("  🗑️  Cleaned output folder\n")

    _ensure_output()

    if not ICON_SRC.exists():
        click.echo(f"  ❌ Icon not found: {ICON_SRC}")
        raise click.Abort()

    click.echo("━━━ Generating assets...\n")

    generate_icon()
    generate_feature_graphic()
    generate_phone_screenshots()
    generate_tablet_7_screenshots()
    generate_tablet_10_screenshots()

    # Summary
    total = sum(1 for _ in OUTPUT.rglob("*.png"))
    click.echo(f"\n━━━ Done! {total} assets generated.")
    click.echo(f"    📁 {OUTPUT.relative_to(ROOT)}")
    click.echo()
    click.echo("  📱 Phone:     tools/output/playstore/phone/")
    click.echo("  📱 Tablet 7\": tools/output/playstore/tablet_7/")
    click.echo("  📱 Tablet 10\":tools/output/playstore/tablet_10/")
    click.echo("  🖼️  Icon:      tools/output/playstore/icon/")
    click.echo("  🎨 Feature:   tools/output/playstore/feature/")
    click.echo()
    click.echo("  ⚠️  Remplacez les placeholders par de vraies captures d'écran")
    click.echo("     en plaçant vos PNG dans les frames générées.\n")


@playstore.command()
@click.argument("screenshot_dir", type=click.Path(exists=True))
@click.option(
    "--device",
    type=click.Choice(["phone", "tablet_7", "tablet_10"]),
    default="phone",
)
def frame(screenshot_dir: str, device: str) -> None:
    """Frame real screenshots into Play Store-ready images.

    Provide a directory containing raw screenshots (PNG).
    They will be inserted into branded frames.
    """
    sizes = {
        "phone": (1080, 1920),
        "tablet_7": (1200, 1920),
        "tablet_10": (1600, 2560),
    }
    W, H = sizes[device]
    src = Path(screenshot_dir)
    dest = OUTPUT / f"{device}_framed"
    dest.mkdir(parents=True, exist_ok=True)

    screenshots = sorted(src.glob("*.png"))
    if not screenshots:
        click.echo(f"  ❌ No PNG files found in {src}")
        raise click.Abort()

    click.echo(f"\n  Framing {len(screenshots)} screenshots for {device}...\n")

    for i, ss_path in enumerate(screenshots):
        screen = SCREENS[i] if i < len(SCREENS) else {
            "id": f"{i + 1:02d}_screen",
            "title": f"Écran {i + 1}",
            "subtitle": "",
            "emoji": "📱",
        }

        # Create frame
        frame_img = Image.new("RGBA", (W, H))
        scale = W / 1080
        grad = create_gradient(
            (W, H), NEUTRAL_100, (230, 247, 245), direction="vertical"
        )
        frame_img.paste(grad)
        draw = ImageDraw.Draw(frame_img)

        # Title area
        top_margin = int(80 * scale)
        font_emoji = get_font(int(60 * scale))
        font_title = get_font(int(52 * scale), bold=True)
        font_sub = get_font(int(28 * scale))

        emoji_bbox = draw.textbbox((0, 0), screen["emoji"], font=font_emoji)
        ew = emoji_bbox[2] - emoji_bbox[0]
        draw.text(((W - ew) // 2, top_margin), screen["emoji"], font=font_emoji)

        title_y = top_margin + int(80 * scale)
        tb = draw.textbbox((0, 0), screen["title"], font=font_title)
        tw = tb[2] - tb[0]
        draw.text(((W - tw) // 2, title_y), screen["title"], fill=BLACK, font=font_title)

        sub_y = title_y + int(60 * scale)
        sb = draw.textbbox((0, 0), screen["subtitle"], font=font_sub)
        sw = sb[2] - sb[0]
        draw.text(((W - sw) // 2, sub_y), screen["subtitle"], fill=NEUTRAL_800, font=font_sub)

        # Insert screenshot
        mockup_top = sub_y + int(80 * scale)
        mockup_margin = int(80 * scale)
        mockup_w = W - 2 * mockup_margin
        mockup_h = H - mockup_top - int(100 * scale)
        mockup_radius = int(24 * scale)

        # Shadow
        shadow = Image.new("RGBA", (mockup_w + 30, mockup_h + 30), (0, 0, 0, 0))
        s_draw = ImageDraw.Draw(shadow)
        s_draw.rounded_rectangle(
            [(15, 15), (mockup_w + 15, mockup_h + 15)],
            radius=mockup_radius, fill=(0, 0, 0, 40),
        )
        shadow = shadow.filter(ImageFilter.GaussianBlur(12))
        frame_img.paste(shadow, (mockup_margin - 8, mockup_top + 8), shadow)

        # Real screenshot
        ss = load_image(ss_path)
        ss = ss.resize((mockup_w, mockup_h), Image.LANCZOS)
        ss = add_rounded_corners(ss, mockup_radius)
        frame_img.paste(ss, (mockup_margin, mockup_top), ss)

        # Brand
        brand_font = get_font(int(16 * scale))
        brand = "LifeFlow — VitaTech Solutions"
        bb = draw.textbbox((0, 0), brand, font=brand_font)
        bw = bb[2] - bb[0]
        draw.text(((W - bw) // 2, H - int(50 * scale)), brand, fill=(*PRIMARY, 150), font=brand_font)

        out = save_png(frame_img, dest / f"{screen['id']}.png")
        click.echo(f"  ✅ {out.name}")

    click.echo(f"\n  📁 Framed screenshots → {dest.relative_to(ROOT)}\n")
