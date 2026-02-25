# App Icon Assets

Place your icon files here:

1. **`app_icon.png`** — Main app icon (1024×1024 PNG, no alpha for iOS)
2. **`app_icon_foreground.png`** — Android adaptive icon foreground (1024×1024, content in safe zone ~66%)

Then run:
```bash
dart run flutter_launcher_icons
```

This generates all platform-specific icons (Android mipmap, iOS Assets.xcassets, Web favicon, Windows/macOS).
