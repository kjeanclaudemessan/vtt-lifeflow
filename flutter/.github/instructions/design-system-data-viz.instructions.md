```instructions
---
applyTo: "**/*_view.dart,**/widgets/**/*.dart"
---
# Design System — Data Visualization (Phase 25)

> All charts use `fl_chart` — no other charting library.
> Charts are animated on first appearance and on data change.
> Every chart is accompanied by a key textual stat.
> Use the data palette (`AppColors.dataPalette`) — never the primary color alone for multiple series.

---

## Charting Library

| Decision | Value |
|----------|-------|
| Library | `fl_chart` (pub.dev) |
| Fallback | `CustomPainter` for simple sparklines only |
| Never use | syncfusion (license), graphic (unstable), charts_flutter (deprecated) |

---

## Chart Types

| Type | When | UX Pack |
|------|------|---------|
| **Line chart** | Trends over time (habits, moods, weights) | Flow |
| **Bar chart** | Comparisons (weekly, categories) | Flow, Pro |
| **Donut chart** | Proportions (budget, time allocation) | Flow, Pro |
| **Sparkline** | Mini inline trend in cards/list tiles | Flow, Pro, Community |
| **Progress ring** | Single metric completion (daily %) | Flow |
| **Heatmap calendar** | Streak visualization (GitHub-style) | Flow |
| **Radar chart** | Multi-dimension comparison (wheel of life) | Flow |
| **Stacked bar** | Composition over time | Pro |

### NOT Supported

- 3D charts — never. Flat 2D only.
- Pie charts — always donut (with label in center) instead.
- Complex Sankey/treemap — out of scope for mobile.

---

## Data Color Palette

```dart
// AppColors.dataPalette — 12 colors for multi-series charts
static const dataPalette = [
  Color(0xFF0D9488),  // Teal (primary fallback)
  Color(0xFF2563EB),  // Blue
  Color(0xFFF59E0B),  // Amber
  Color(0xFFEF4444),  // Red
  Color(0xFF8B5CF6),  // Violet
  Color(0xFF10B981),  // Emerald
  Color(0xFFF97316),  // Orange
  Color(0xFFEC4899),  // Pink
  Color(0xFF06B6D4),  // Cyan
  Color(0xFF84CC16),  // Lime
  Color(0xFF6366F1),  // Indigo
  Color(0xFFD4A853),  // Gold (premium accent)
];
```

### Usage Rules

| Rule | Value |
|------|-------|
| Single series | Use `colorScheme.primary` |
| 2 series | primary + `dataPalette[1]` (blue) |
| 3+ series | Use `dataPalette` sequentially |
| Max series | 6 visible at once (more = confusing on mobile) |
| Dark mode | Same palette — all colors are designed for both modes |
| Category colors | Consistent per category across all charts in the app |

---

## Chart Styling Tokens

### Axes

| Element | Style |
|---------|-------|
| X axis labels | `AppTypography.labelSmall`, `onSurfaceVariant` color |
| Y axis labels | `AppTypography.labelSmall`, `onSurfaceVariant` color |
| Grid lines | 1px, `onSurface.withOpacity(0.06)` — subtle |
| Axis lines | Hidden by default (clean look) |
| Label rotation | 0° (horizontal). If text overlaps, show every 2nd label |

### Chart Area

| Element | Style |
|---------|-------|
| Background | Transparent (inherits card/surface) |
| Padding | `AppSpacing.staticMd` on all sides |
| Border | None (chart floats in card) |
| Aspect ratio | 16:9 for full-width, 1:1 for square cards |
| Min height | 200px for full-width charts |

---

## Line Chart

```dart
// ✅ CORRECT — styled line chart
LineChart(
  LineChartData(
    gridData: FlGridData(
      show: true,
      drawVerticalLine: false,
      horizontalInterval: 1,
      getDrawingHorizontalLine: (value) => FlLine(
        color: context.colorScheme.onSurface.withOpacity(0.06),
        strokeWidth: 1,
      ),
    ),
    titlesData: FlTitlesData(
      leftTitles: AxisTitles(
        sideTitles: SideTitles(
          showTitles: true,
          reservedSize: 32,
          getTitlesWidget: (value, meta) => Text(
            value.toInt().toString(),
            style: AppTypography.labelSmall.copyWith(
              color: context.colorScheme.onSurfaceVariant,
            ),
          ),
        ),
      ),
      bottomTitles: AxisTitles(
        sideTitles: SideTitles(
          showTitles: true,
          getTitlesWidget: (value, meta) => Text(
            dayLabels[value.toInt()],
            style: AppTypography.labelSmall.copyWith(
              color: context.colorScheme.onSurfaceVariant,
            ),
          ),
        ),
      ),
      topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
      rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
    ),
    borderData: FlBorderData(show: false),
    lineBarsData: [
      LineChartBarData(
        spots: dataPoints,
        isCurved: true,
        curveSmoothness: 0.3,
        color: context.colorScheme.primary,
        barWidth: 2.5,
        dotData: FlDotData(show: false),
        belowBarData: BarAreaData(
          show: true,
          color: context.colorScheme.primary.withOpacity(0.1),
        ),
      ),
    ],
    lineTouchData: LineTouchData(
      touchTooltipData: LineTouchTooltipData(
        getTooltipColor: (_) => context.colorScheme.inverseSurface,
        getTooltipItems: (touchedSpots) => touchedSpots.map((spot) =>
          LineTooltipItem(
            spot.y.toStringAsFixed(1),
            AppTypography.labelSmall.copyWith(
              color: context.colorScheme.onInverseSurface,
            ),
          ),
        ).toList(),
      ),
    ),
  ),
  duration: AppAnimations.medium,
  curve: AppAnimations.easeOut,
)
```

### Line Chart Rules

| Rule | Value |
|------|-------|
| Curved lines | `isCurved: true`, smoothness 0.3 |
| Line width | 2.5px |
| Individual dots | Hidden by default, shown on touch |
| Area fill | Primary at 10% opacity below line |
| Tooltip | Inverse surface background, labeled value |
| Animation | `AppAnimations.medium` duration, `easeOut` curve |

---

## Bar Chart

```dart
// ✅ CORRECT — rounded bar chart
BarChart(
  BarChartData(
    barGroups: data.map((item) => BarChartGroupData(
      x: item.index,
      barRods: [
        BarChartRodData(
          toY: item.value,
          color: context.colorScheme.primary,
          width: 16,
          borderRadius: BorderRadius.vertical(top: AppRadius.sm),
        ),
      ],
    )).toList(),
    // ... same grid/titles styling as line chart
  ),
  duration: AppAnimations.medium,
  curve: AppAnimations.easeOut,
)
```

### Bar Chart Rules

| Rule | Value |
|------|-------|
| Bar width | 16px default, 12px if > 7 bars |
| Bar radius | Top corners rounded (`AppRadius.sm`) |
| Spacing | Equal spacing, computed by `fl_chart` |
| Max bars visible | 7 without horizontal scroll |
| Comparison | Previous period shown as 30% opacity bars behind |

---

## Donut Chart (NOT Pie)

```dart
// ✅ CORRECT — donut with center label
Stack(
  alignment: Alignment.center,
  children: [
    SizedBox(
      height: 200, width: 200,
      child: PieChart(
        PieChartData(
          sectionsSpace: 2,
          centerSpaceRadius: 60,
          sections: segments.asMap().entries.map((entry) =>
            PieChartSectionData(
              value: entry.value.percentage,
              color: AppColors.dataPalette[entry.key % 12],
              radius: 30,
              showTitle: false,
            ),
          ).toList(),
        ),
      ),
    ),
    // Center label
    Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(centerValue, style: AppTypography.headingLarge),
        Text(centerLabel, style: AppTypography.labelSmall.copyWith(
          color: context.colorScheme.onSurfaceVariant,
        )),
      ],
    ),
  ],
)
```

### Donut Rules

| Rule | Value |
|------|-------|
| Center space | 60px radius (shows key metric inside) |
| Section spacing | 2px gap between sections |
| Section radius | 30px (ring thickness) |
| Max sections | 6 (group smaller into "Autres") |
| Labels | Legend below chart, not on sections |
| Center label | Main metric (total, percentage, score) |

---

## Sparkline (Mini Inline Chart)

For compact trend display inside cards, list items, or dashboards.

```dart
// ✅ CORRECT — simple sparkline in a card
SizedBox(
  width: 80, height: 32,
  child: LineChart(
    LineChartData(
      gridData: FlGridData(show: false),
      titlesData: FlTitlesData(show: false),
      borderData: FlBorderData(show: false),
      lineBarsData: [
        LineChartBarData(
          spots: last7Days,
          isCurved: true,
          color: trendIsPositive
              ? AppColors.success
              : AppColors.error,
          barWidth: 1.5,
          dotData: FlDotData(show: false),
          belowBarData: BarAreaData(show: false),
        ),
      ],
      lineTouchData: LineTouchData(enabled: false),
    ),
  ),
)
```

### Sparkline Rules

| Rule | Value |
|------|-------|
| Size | 80x32 px (width x height) |
| Axes | Hidden |
| Touch | Disabled |
| Color | Green (up trend), Red (down trend), Primary (neutral) |
| Line width | 1.5px |
| Data points | Last 7 values minimum |

---

## Progress Ring

```dart
// ✅ CORRECT — animated circular progress
TweenAnimationBuilder<double>(
  tween: Tween(begin: 0.0, end: viewModel.progress),
  duration: AppAnimations.slow,
  curve: AppAnimations.decelerate,
  builder: (context, value, _) => SizedBox(
    width: 120, height: 120,
    child: Stack(
      alignment: Alignment.center,
      children: [
        CircularProgressIndicator(
          value: value,
          strokeWidth: 8,
          strokeCap: StrokeCap.round,
          backgroundColor: context.colorScheme.primary.withOpacity(0.1),
          valueColor: AlwaysStoppedAnimation(context.colorScheme.primary),
        ),
        Text(
          '${(value * 100).toInt()}%',
          style: AppTypography.headingMd,
        ),
      ],
    ),
  ),
)
```

### Progress Ring Rules

| Rule | Value |
|------|-------|
| Stroke width | 8px |
| Stroke cap | `StrokeCap.round` |
| Background | Primary at 10% opacity |
| Animation | `AppAnimations.slow` + `decelerate` curve |
| Label | Percentage centered, `headingMd` style |
| Sizes | Small (64px), Medium (120px), Large (200px) |

---

## Heatmap Calendar (Streak Grid)

GitHub-style contribution/streak grid.

```dart
// ✅ CORRECT — custom heatmap grid
GridView.builder(
  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
    crossAxisCount: 7, // Mon-Sun
    mainAxisSpacing: 3,
    crossAxisSpacing: 3,
  ),
  itemCount: daysInRange,
  itemBuilder: (context, index) {
    final intensity = dayData[index]?.intensity ?? 0.0;
    return Container(
      decoration: BoxDecoration(
        color: _getHeatmapColor(context, intensity),
        borderRadius: AppRadius.xs,
      ),
    );
  },
)

Color _getHeatmapColor(BuildContext context, double intensity) {
  if (intensity == 0) {
    return context.colorScheme.surfaceContainerHighest;
  }
  return context.colorScheme.primary.withOpacity(
    0.2 + (intensity * 0.8), // 20% to 100% opacity based on intensity
  );
}
```

### Heatmap Rules

| Rule | Value |
|------|-------|
| Cell size | Square, auto-sized to fit width |
| Cell spacing | 3px |
| Cell radius | `AppRadius.xs` (slightly rounded) |
| Empty color | `surfaceContainerHighest` |
| Intensity scale | 4 levels: 0%, 25%, 50%, 100% of primary color opacity |
| Columns | 7 (Monday → Sunday) |
| Range | Last 12 weeks visible by default |
| Day labels | Mon, Wed, Fri on left side |
| Month labels | Abbreviated month name above each month column start |

---

## Tooltips / Touch Info

```dart
// Standard tooltip style for all charts
LineTouchTooltipData(
  getTooltipColor: (_) => context.colorScheme.inverseSurface,
  tooltipRoundedRadius: AppRadius.smValue,
  tooltipPadding: EdgeInsets.symmetric(
    horizontal: AppSpacing.staticSm,
    vertical: AppSpacing.staticXs,
  ),
  getTooltipItems: (spots) => spots.map((spot) =>
    LineTooltipItem(
      '${spot.y.toStringAsFixed(1)}',
      AppTypography.labelSmall.copyWith(
        color: context.colorScheme.onInverseSurface,
        fontWeight: FontWeight.w600,
      ),
    ),
  ).toList(),
)
```

### Tooltip Rules

| Rule | Value |
|------|-------|
| Background | `inverseSurface` |
| Text color | `onInverseSurface` |
| Font | `labelSmall`, bold |
| Radius | `AppRadius.sm` |
| Trigger | Tap (not hover — mobile first) |
| Auto-dismiss | After 3 seconds or tap elsewhere |

---

## Comparison Mode

### Previous Period Overlay

```dart
// Show previous period as dashed/transparent overlay
LineChartBarData(
  spots: previousPeriodData,
  isCurved: true,
  color: context.colorScheme.onSurface.withOpacity(0.2),
  barWidth: 1.5,
  dashArray: [6, 4], // Dashed line
  dotData: FlDotData(show: false),
  belowBarData: BarAreaData(show: false),
)
```

### Rules

| Rule | Value |
|------|-------|
| Previous period | Dashed line, 20% opacity |
| Toggle | User can toggle comparison ON/OFF |
| Label | Legend clearly marks "Cette semaine" vs "Semaine précédente" |

---

## Chart + Text Rule

> Every chart MUST be accompanied by at least one key textual stat.

```
┌─────────────────────────────┐
│  Progression cette semaine  │  ← Title
│  ┌───────────────────────┐  │
│  │    [Line Chart]       │  │  ← Chart
│  └───────────────────────┘  │
│  85% complété · +12% ↑     │  ← Key stat + trend indicator
└─────────────────────────────┘
```

### Trend Indicator

| Trend | Icon | Color |
|-------|------|-------|
| Positive | `↑` or `LucideIcons.trendingUp` | `AppColors.success` |
| Negative | `↓` or `LucideIcons.trendingDown` | `AppColors.error` |
| Neutral | `→` or `LucideIcons.minus` | `onSurfaceVariant` |

---

## Animation

| Event | Animation | Duration |
|-------|-----------|----------|
| First appearance | Draw-in (line grows, bars rise from 0) | `AppAnimations.slow` |
| Data change | Morph to new values (fl_chart built-in) | `AppAnimations.medium` |
| Tooltip show | Fade in | `AppAnimations.fast` |
| Segment tap (donut) | Radius grows slightly | `AppAnimations.fast` |

---

## Accessibility

| Rule | Implementation |
|------|----------------|
| **Alt text** | `Semantics(label: 'Weekly progress chart: 85% completed')` |
| **Data table fallback** | Provide "Voir les données" link to tabular view |
| **Color-blind safe** | Don't rely on color alone — use patterns/icons alongside |
| **High contrast** | Ensure chart lines have ≥ 3:1 contrast ratio |

---

## Self-Check

- [ ] Every chart uses `fl_chart` — no other library.
- [ ] Multi-series charts use `AppColors.dataPalette`.
- [ ] Single-series charts use `colorScheme.primary`.
- [ ] No pie charts — always donut with center label.
- [ ] Every chart has at least one textual stat next to it.
- [ ] Charts animate on first appearance.
- [ ] Tooltips use `inverseSurface` background.
- [ ] Heatmap uses 4-level intensity scale.
- [ ] Sparklines disable touch interaction.
- [ ] Chart axes use `labelSmall` + `onSurfaceVariant`.
```
