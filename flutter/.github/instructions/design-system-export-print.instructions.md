```instructions
---
applyTo: "**/*_view.dart,**/*_viewmodel.dart,**/*_service.dart"
---
# Design System — Impression & Export (Phase 35)

> Users must be able to export and share their data beautifully.
> PDF exports are branded. Share cards are social-ready.
> CSV for structured data. QR codes for quick sharing.

---

## PDF Export (35.1)

### Style Rules

| Element | Rule |
|---------|------|
| **Header** | App logo (left) + document title (right) + generation date |
| **Colors** | Brand primary for headers, neutral for body |
| **Font** | Inter (default) or brand font, 12pt body, 16pt headings |
| **Footer** | "Généré par {appName} — {date}" + page number |
| **Page size** | A4 portrait (default), landscape for tables |
| **Margins** | 2cm all sides |
| **Package** | `pdf` (dart:pdf) + `printing` for preview/print |

### PDF Layout Template

```dart
// ✅ CORRECT — branded PDF document
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

pw.Document generateReport({
  required String title,
  required String appName,
  required String logoPath,
  required Color brandColor,
  required List<pw.Widget> content,
}) {
  final pdf = pw.Document();

  pdf.addPage(
    pw.MultiPage(
      pageFormat: PdfPageFormat.a4,
      margin: const pw.EdgeInsets.all(2 * PdfPageFormat.cm),

      // Header: logo + title
      header: (context) => pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        children: [
          pw.Image(pw.MemoryImage(logoBytes), height: 32),
          pw.Text(title, style: pw.TextStyle(
            fontSize: 16,
            fontWeight: pw.FontWeight.bold,
            color: PdfColor.fromInt(brandColor.value),
          )),
        ],
      ),

      // Footer: "Généré par AppName — date" + page number
      footer: (context) => pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        children: [
          pw.Text('Généré par $appName — ${_formatDate(DateTime.now())}',
              style: const pw.TextStyle(fontSize: 9, color: PdfColors.grey600)),
          pw.Text('Page ${context.pageNumber}/${context.pagesCount}',
              style: const pw.TextStyle(fontSize: 9, color: PdfColors.grey600)),
        ],
      ),

      build: (context) => content,
    ),
  );

  return pdf;
}
```

### Export Flow UX

```
User taps "Exporter en PDF"
  → Show loading state in button
  → Generate PDF in isolate (no UI jank)
  → Show preview (printing package)
  → User can: Print, Share, Save to Files
```

```dart
// ✅ CORRECT — PDF export with preview
Future<void> exportAsPdf() async {
  setBusyForObject(exportBusyKey, true);

  final pdf = await compute(_generatePdf, exportData);

  await Printing.layoutPdf(
    onLayout: (_) => pdf.save(),
    name: '${brandSkin.appName}_report_${_dateStamp()}.pdf',
  );

  setBusyForObject(exportBusyKey, false);
  HapticFeedback.mediumImpact();
  _snackbarService.showSuccess(message: context.l10n.exportComplete);
}
```

---

## Share Cards (35.2)

Social-shareable images showing achievements, stats, or streaks.

### Share Card Layout

```
┌──────────────────────────┐
│  ┌────────────────────┐  │
│  │   [App Logo]       │  │  ← Brand identity
│  │                    │  │
│  │    🔥 42 jours     │  │  ← Hero stat (large, centered)
│  │    de streak !     │  │
│  │                    │  │
│  │    [Username]      │  │  ← User name
│  │    @lifeflow       │  │  ← App branding
│  │                    │  │
│  │  ───────────────   │  │
│  │  lifeflow.app      │  │  ← Optional URL / QR
│  └────────────────────┘  │
│                          │
│  [Partager]  [Enregistrer]│  ← Action buttons
└──────────────────────────┘
```

### Rules

| Rule | Value |
|------|-------|
| Size | 1080×1080px (Instagram square) or 1080×1920 (Stories) |
| Background | Gradient using brand primary → primaryDark |
| Text | White on dark gradient, Inter Bold |
| Logo | App icon, white variant, top-left or centered |
| QR code | Optional — links to app download page |
| Generation | Use `RepaintBoundary` + `RenderRepaintBoundary.toImage()` |
| Share | via `share_plus` package |
| Haptic | `mediumImpact` on share button tap |

```dart
// ✅ CORRECT — generate share card image
Future<Uint8List> generateShareCard({
  required String statValue,
  required String statLabel,
  required String username,
}) async {
  final boundary = _shareCardKey.currentContext!
      .findRenderObject() as RenderRepaintBoundary;
  final image = await boundary.toImage(pixelRatio: 3.0);
  final byteData = await image.toByteData(format: ImageByteFormat.png);
  return byteData!.buffer.asUint8List();
}

// Share via system share sheet
Future<void> shareCard(Uint8List imageBytes) async {
  final tempDir = await getTemporaryDirectory();
  final file = File('${tempDir.path}/share_card.png');
  await file.writeAsBytes(imageBytes);

  await Share.shareXFiles(
    [XFile(file.path)],
    text: context.l10n.shareCardCaption(brandSkin.appName),
  );
  HapticFeedback.mediumImpact();
}
```

---

## CSV Export (35.3)

### Rules

| Rule | Value |
|------|-------|
| Delimiter | Semicolon `;` for French locale (comma conflicts with decimal separator) |
| Header row | Always present — column names in user's language |
| Encoding | UTF-8 with BOM (for Excel compatibility) |
| Date format | ISO 8601 (`2026-01-15T10:30:00`) in data, localized in display column |
| File name | `{appName}_{dataType}_{date}.csv` |

### CSV Content Types

| Data type | Columns | Example |
|-----------|---------|---------|
| **Habits** | Date; Habitude; Statut; Streak | `2026-01-15;Méditation;Complété;42` |
| **Transactions** | Date; Description; Montant; Catégorie | `2026-01-15;Courses;-15000;Alimentation` |
| **Tasks** | Date; Tâche; Priorité; Statut | `2026-01-15;Appeler banque;Haute;Terminé` |
| **Notes** | Date; Titre; Contenu (truncated) | `2026-01-15;Idée projet;Créer une app...` |

```dart
// ✅ CORRECT — CSV generation with BOM for Excel
String generateCsv(List<Map<String, dynamic>> data, List<String> headers) {
  final buffer = StringBuffer();

  // UTF-8 BOM for Excel compatibility
  buffer.write('\uFEFF');

  // Header row
  buffer.writeln(headers.join(';'));

  // Data rows
  for (final row in data) {
    buffer.writeln(headers.map((h) => _escapeCsv(row[h]?.toString() ?? '')).join(';'));
  }

  return buffer.toString();
}

String _escapeCsv(String value) {
  if (value.contains(';') || value.contains('"') || value.contains('\n')) {
    return '"${value.replaceAll('"', '""')}"';
  }
  return value;
}
```

---

## Print Support (35.4)

### Rules

- Use the `printing` package for native print dialog.
- Always offer **print preview** before sending to printer.
- Reuse the PDF generation template (consistent branding).

```dart
// ✅ CORRECT — print with preview
Future<void> printReport() async {
  await Printing.layoutPdf(
    onLayout: (format) async {
      final pdf = generateReport(
        title: context.l10n.reportTitle,
        appName: brandSkin.appName,
        logoPath: brandSkin.appIcon,
        brandColor: brandSkin.primary,
        content: _buildReportContent(),
      );
      return pdf.save();
    },
    name: '${brandSkin.appName}_report',
  );
}
```

---

## QR Codes (35.5)

### Style

| Element | Rule |
|---------|------|
| Size | 200×200dp on screen, 300×300px when exported |
| Color | Brand primary for dots, white background |
| Logo | App icon centered (20% of QR size) |
| Error correction | High (30%) — allows logo in center |
| Package | `qr_flutter` |
| Content | Short URL or deep link |

### Implementation

```dart
// ✅ CORRECT — branded QR code
QrImageView(
  data: viewModel.shareUrl,
  version: QrVersions.auto,
  size: 200,
  eyeStyle: QrEyeStyle(
    eyeShape: QrEyeShape.roundedOuter,
    color: context.brandSkin.primary,
  ),
  dataModuleStyle: QrDataModuleStyle(
    dataModuleShape: QrDataModuleShape.roundedOutsideCorners,
    color: context.brandSkin.primary,
  ),
  embeddedImage: AssetImage(context.brandSkin.appIcon),
  embeddedImageStyle: QrEmbeddedImageStyle(size: Size(40, 40)),
  semanticsLabel: context.l10n.qrCodeForSharing,
)
```

### QR Code Uses

| Use case | Content | Where shown |
|----------|---------|-------------|
| **Share profile** | `https://app.link/profile/{userId}` | Profile screen |
| **Share content** | `https://app.link/item/{itemId}` | Item detail |
| **Invite friend** | `https://app.link/invite/{code}` | Invite screen |
| **Receipt/invoice** | `https://app.link/receipt/{id}` | Payment confirmation |

---

## Export UX Patterns

### Export Button Placement

- **List screen**: overflow menu → "Exporter"
- **Detail screen**: AppBar action → share icon
- **Settings**: Settings > Données > Exporter
- **Profile**: Stats section → "Partager mes stats"

### Export Options Bottom Sheet

```
┌──────────────────────────┐
│  ━━━━━━━━━━━━━━━━━━━━━━  │  ← Drag handle
│                          │
│  Exporter                │  ← Title
│                          │
│  📄 PDF (rapport)        │  ← PDF with preview
│  📊 CSV (données brutes) │  ← CSV download
│  🖼️ Image (carte)        │  ← Share card
│  🖨️ Imprimer             │  ← Print dialog
│                          │
└──────────────────────────┘
```

```dart
// ✅ CORRECT — export options bottom sheet
AppBottomSheet(
  title: context.l10n.export,
  children: [
    AppListTile(
      leading: Icon(LucideIcons.fileText, semanticLabel: context.l10n.pdfExport),
      title: context.l10n.pdfExport,
      subtitle: context.l10n.pdfExportDescription,
      onTap: viewModel.exportAsPdf,
    ),
    AppListTile(
      leading: Icon(LucideIcons.table, semanticLabel: context.l10n.csvExport),
      title: context.l10n.csvExport,
      subtitle: context.l10n.csvExportDescription,
      onTap: viewModel.exportAsCsv,
    ),
    AppListTile(
      leading: Icon(LucideIcons.image, semanticLabel: context.l10n.shareCard),
      title: context.l10n.shareCard,
      subtitle: context.l10n.shareCardDescription,
      onTap: viewModel.generateShareCard,
    ),
    AppListTile(
      leading: Icon(LucideIcons.printer, semanticLabel: context.l10n.print),
      title: context.l10n.print,
      subtitle: context.l10n.printDescription,
      onTap: viewModel.printReport,
    ),
  ],
)
```

---

## Export Checklist

- [ ] PDF includes branded header (logo + title) and footer (app name + date + page)
- [ ] PDF generated in isolate (no UI jank)
- [ ] Share cards are 1080×1080 or 1080×1920 with brand gradient
- [ ] CSV uses semicolon delimiter and UTF-8 BOM
- [ ] CSV header row uses localized column names
- [ ] Print uses native print dialog with preview
- [ ] QR codes use brand primary color with app icon embedded
- [ ] Export options presented via bottom sheet
- [ ] Haptic feedback on export complete
- [ ] Success snackbar after export
```
