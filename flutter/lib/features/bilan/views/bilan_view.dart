import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:stacked/stacked.dart';

import '../../../core/extensions/context_extensions.dart';
import '../../../design_system/design_system.dart';
import '../viewmodels/bilan_viewmodel.dart';
import '../widgets/bilan_domain_chart.dart';
import '../widgets/bilan_highlights.dart';
import '../widgets/bilan_share_widget.dart';

/// Weekly bilan / summary view.
class BilanView extends StackedView<BilanViewModel> {
  const BilanView({Key? key}) : super(key: key);

  @override
  Widget builder(
    BuildContext context,
    BilanViewModel viewModel,
    Widget? child,
  ) {
    final brightness = Theme.of(context).brightness;
    final l10n = context.l10n;

    if (viewModel.isBusy) {
      return Scaffold(
        appBar: AppBar(title: Text(l10n.bilanTitle)),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    if (viewModel.hasError) {
      return Scaffold(
        appBar: AppBar(title: Text(l10n.bilanTitle)),
        body: Center(
          child: AppEmptyState(
            icon: Icons.error_outline,
            title: l10n.errorOccurred,
            description: viewModel.modelError.toString(),
            actionLabel: l10n.retry,
            onAction: viewModel.init,
          ),
        ),
      );
    }

    final bilan = viewModel.bilan;
    final weekLabel =
        _weekLabel(context, viewModel.weekStart, viewModel.weekEnd);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.bilanTitle),
      ),
      body: Stack(
        children: [
          // Main scrollable content
          SingleChildScrollView(
            padding: EdgeInsets.all(AppSpacing.md),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ── Week navigator ──
                _WeekNavigator(
                  weekLabel: weekLabel,
                  isCurrentWeek: viewModel.isCurrentWeek,
                  onPrevious: viewModel.previousWeek,
                  onNext: viewModel.nextWeek,
                ),
                SizedBox(height: AppSpacing.lg),

                // ── Total card ──
                AppCard.elevated(
                  padding: EdgeInsets.all(AppSpacing.md),
                  child: Row(
                    children: [
                      Icon(Icons.timer_outlined,
                          size: AppSizing.iconXl, color: AppColors.primary),
                      SizedBox(width: AppSpacing.sm),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _formatMinutes(bilan.totalMinutes),
                              style: AppTypography.headlineMedium.copyWith(
                                color: AppColors.textPrimary(brightness),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              l10n.counterTotal,
                              style: AppTypography.labelMedium.copyWith(
                                color: AppColors.textSecondary(brightness),
                              ),
                            ),
                          ],
                        ),
                      ),
                      if (!bilan.isFirstWeek) _DeltaBadge(bilan.deltaMinutes),
                    ],
                  ),
                ),
                SizedBox(height: AppSpacing.lg),

                // ── Completion rate ──
                AppCard.outlined(
                  padding: EdgeInsets.all(AppSpacing.md),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            l10n.bilanCompletionRate,
                            style: AppTypography.titleSmall.copyWith(
                              color: AppColors.textPrimary(brightness),
                            ),
                          ),
                          Text(
                            bilan.completionRateLabel,
                            style: AppTypography.titleMedium.copyWith(
                              color: AppColors.primary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: AppSpacing.sm),
                      AppLinearProgress(
                        value: bilan.completionRate.clamp(0.0, 1.0),
                        height: 8,
                      ),
                    ],
                  ),
                ),
                SizedBox(height: AppSpacing.lg),

                // ── Domain chart ──
                Text(
                  l10n.bilanWeekOf(''),
                  style: AppTypography.titleMedium.copyWith(
                    color: AppColors.textPrimary(brightness),
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: AppSpacing.sm),
                BilanDomainChart(
                  counters: bilan.domainTimes,
                  totalMinutes: bilan.totalMinutes,
                ),
                SizedBox(height: AppSpacing.lg),

                // ── Highlights ──
                BilanHighlights(bilan: bilan),
                SizedBox(height: AppSpacing.lg),

                // ── First week message ──
                if (bilan.isFirstWeek)
                  AppCard.filled(
                    padding: EdgeInsets.all(AppSpacing.md),
                    backgroundColor: AppColors.info.withValues(alpha: 0.1),
                    child: Row(
                      children: [
                        Text('🌱', style: TextStyle(fontSize: 24)),
                        SizedBox(width: AppSpacing.sm),
                        Expanded(
                          child: Text(
                            l10n.bilanFirstWeek,
                            style: AppTypography.textSmall.copyWith(
                              color: AppColors.textPrimary(brightness),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                if (bilan.isFirstWeek) SizedBox(height: AppSpacing.lg),

                // ── Share button ──
                AppButton.primary(
                  label: l10n.bilanShare,
                  leftIcon: Icons.share,
                  isFullWidth: true,
                  onPressed: () => _shareBilan(context, viewModel, weekLabel),
                ),

                SizedBox(height: AppSpacing.xl),
              ],
            ),
          ),

          // Offscreen share widget (hidden, used for screenshot)
          Positioned(
            left: -500,
            top: -500,
            child: BilanShareWidget(
              repaintKey: viewModel.shareWidgetKey,
              bilan: bilan,
              weekLabel: weekLabel,
            ),
          ),
        ],
      ),
    );
  }

  @override
  BilanViewModel viewModelBuilder(BuildContext context) => BilanViewModel();

  @override
  void onViewModelReady(BilanViewModel viewModel) => viewModel.init();

  /// Format "12 jan – 18 jan 2025".
  String _weekLabel(BuildContext context, DateTime start, DateTime end) {
    final locale = Localizations.localeOf(context).toString();
    final df = DateFormat('d MMM', locale);
    final yearFmt = DateFormat('yyyy');
    return '${df.format(start)} – ${df.format(end)} ${yearFmt.format(end)}';
  }

  /// Format minutes to readable string.
  String _formatMinutes(int minutes) {
    final h = minutes ~/ 60;
    final m = minutes % 60;
    if (h == 0) return '${m}min';
    if (m == 0) return '${h}h';
    return '${h}h${m.toString().padLeft(2, '0')}';
  }

  /// Capture screenshot and share.
  Future<void> _shareBilan(
    BuildContext context,
    BilanViewModel viewModel,
    String weekLabel,
  ) async {
    final Uint8List? imageBytes = await viewModel.captureShareImage();
    if (imageBytes == null) return;

    final tempDir = await getTemporaryDirectory();
    final file = File('${tempDir.path}/bilan_lifeflow.png');
    await file.writeAsBytes(imageBytes);

    await Share.shareXFiles(
      [XFile(file.path)],
      text: '📊 Mon bilan LifeFlow — $weekLabel',
    );
  }
}

/// Week navigator with prev/next arrows.
class _WeekNavigator extends StatelessWidget {
  final String weekLabel;
  final bool isCurrentWeek;
  final VoidCallback onPrevious;
  final VoidCallback onNext;

  const _WeekNavigator({
    required this.weekLabel,
    required this.isCurrentWeek,
    required this.onPrevious,
    required this.onNext,
  });

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
          icon: const Icon(Icons.chevron_left),
          onPressed: onPrevious,
        ),
        Expanded(
          child: Text(
            weekLabel,
            textAlign: TextAlign.center,
            style: AppTypography.titleSmall.copyWith(
              color: AppColors.textPrimary(brightness),
            ),
          ),
        ),
        IconButton(
          icon: const Icon(Icons.chevron_right),
          onPressed: isCurrentWeek ? null : onNext,
        ),
      ],
    );
  }
}

/// Small delta badge showing +/- minutes change.
class _DeltaBadge extends StatelessWidget {
  final int deltaMinutes;

  const _DeltaBadge(this.deltaMinutes);

  @override
  Widget build(BuildContext context) {
    final isPositive = deltaMinutes >= 0;
    final color = isPositive ? AppColors.success : AppColors.error;
    final prefix = isPositive ? '▲' : '▼';
    final absDelta = deltaMinutes.abs();
    final h = absDelta ~/ 60;
    final m = absDelta % 60;
    final label = h > 0
        ? '${h}h${m > 0 ? '${m.toString().padLeft(2, '0')}' : ''}'
        : '${m}min';

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: AppSpacing.xxs,
      ),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: AppRadius.sm,
      ),
      child: Text(
        '$prefix $label',
        style: AppTypography.labelSmall.copyWith(
          color: color,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
