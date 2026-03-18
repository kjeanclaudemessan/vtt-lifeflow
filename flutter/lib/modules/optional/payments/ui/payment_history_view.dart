import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:stacked/stacked.dart';

import '../../../../app/app.locator.dart';
import '../../../../design_system/design_system.dart';
import '../../../../l10n/generated/app_localizations.dart';
import '../config/payments_config.dart';
import '../domain/entities/payment_entity.dart';
import '../payment_service.dart';

/// View displaying payment history for an organization.
///
/// Supports three visual styles via [PaymentsStyle]:
/// - [PaymentsStyle.cards]: Each payment in an elevated card (default).
/// - [PaymentsStyle.grouped]: Payments grouped by month with section headers.
/// - [PaymentsStyle.compact]: Dense list with minimal spacing.
class PaymentHistoryView extends StackedView<PaymentHistoryViewModel> {
  /// The organization ID to load payments for.
  final String organizationId;

  /// Optional callback when a payment is tapped.
  final void Function(PaymentEntity payment)? onPaymentTap;

  /// Optional callback when retry is tapped.
  final void Function(PaymentEntity payment)? onRetry;

  /// Visual configuration.
  final PaymentsConfig config;

  const PaymentHistoryView({
    required this.organizationId,
    this.onPaymentTap,
    this.onRetry,
    this.config = const PaymentsConfig(),
    super.key,
  });

  @override
  Widget builder(
    BuildContext context,
    PaymentHistoryViewModel viewModel,
    Widget? child,
  ) {
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppAppBar(
        title: 'Payments', // TODO: Add to l10n
        leading: const AppBackButton(),
        actions: [
          if (viewModel.isLoading)
            Padding(
              padding: EdgeInsets.all(AppSpacing.md),
              child: const AppLoader.small(),
            )
          else
            IconButton(
              icon: const Icon(Icons.refresh),
              onPressed: viewModel.refresh,
            ),
        ],
      ),
      body: _buildBody(context, viewModel, l10n),
    );
  }

  Widget _buildBody(
    BuildContext context,
    PaymentHistoryViewModel viewModel,
    AppLocalizations l10n,
  ) {
    if (viewModel.hasError) {
      return _buildError(context, viewModel, l10n);
    }

    if (viewModel.payments.isEmpty &&
        !viewModel.isLoading &&
        !viewModel.isBusy) {
      return _buildEmpty(context, l10n);
    }

    return switch (config.style) {
      PaymentsStyle.cards => _buildCardsStyle(context, viewModel, l10n),
      PaymentsStyle.grouped => _buildGroupedStyle(context, viewModel, l10n),
      PaymentsStyle.compact => _buildCompactStyle(context, viewModel, l10n),
    };
  }

  Widget _buildError(
    BuildContext context,
    PaymentHistoryViewModel viewModel,
    AppLocalizations l10n,
  ) {
    return AppEmptyState(
      icon: Icons.error_outline,
      title: l10n.errorOccurred,
      description: viewModel.modelError?.toString(),
      actionLabel: l10n.retry,
      onAction: viewModel.refresh,
    );
  }

  Widget _buildEmpty(BuildContext context, AppLocalizations l10n) {
    return const AppEmptyState(
      icon: Icons.payment_outlined,
      title: 'No payments yet', // TODO: Add to l10n
      description: 'Your payment history will appear here',
    );
  }

  // ── Cards style (default) ───────────────────────────────────────────

  Widget _buildCardsStyle(
    BuildContext context,
    PaymentHistoryViewModel viewModel,
    AppLocalizations l10n,
  ) {
    return AppRefreshIndicator(
      onRefresh: viewModel.refresh,
      child: ListView.separated(
        padding: EdgeInsets.all(AppSpacing.md),
        itemCount: viewModel.payments.length,
        separatorBuilder: (_, __) => SizedBox(height: AppSpacing.sm),
        itemBuilder: (context, index) {
          final payment = viewModel.payments[index];
          return PaymentListItem(
            payment: payment,
            onTap: () => onPaymentTap?.call(payment),
            onRetry: payment.status == PaymentStatus.failed
                ? () => onRetry?.call(payment)
                : null,
          );
        },
      ),
    );
  }

  // ── Grouped style ──────────────────────────────────────────────────

  Widget _buildGroupedStyle(
    BuildContext context,
    PaymentHistoryViewModel viewModel,
    AppLocalizations l10n,
  ) {
    final grouped = _groupByMonth(viewModel.payments);

    return AppRefreshIndicator(
      onRefresh: viewModel.refresh,
      child: ListView.builder(
        padding: EdgeInsets.all(AppSpacing.md),
        itemCount: grouped.length,
        itemBuilder: (context, sectionIndex) {
          final entry = grouped.entries.elementAt(sectionIndex);
          final monthLabel = entry.key;
          final payments = entry.value;

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (sectionIndex > 0) SizedBox(height: AppSpacing.lg),
              Text(
                monthLabel,
                style: AppTypography.labelLarge.copyWith(
                  color: AppColors.contrastMediumLight,
                ),
              ),
              SizedBox(height: AppSpacing.sm),
              ...payments.map((payment) {
                return Padding(
                  padding: EdgeInsets.only(bottom: AppSpacing.sm),
                  child: PaymentListItem(
                    payment: payment,
                    onTap: () => onPaymentTap?.call(payment),
                    onRetry: payment.status == PaymentStatus.failed
                        ? () => onRetry?.call(payment)
                        : null,
                  ),
                );
              }),
            ],
          );
        },
      ),
    );
  }

  // ── Compact style ──────────────────────────────────────────────────

  Widget _buildCompactStyle(
    BuildContext context,
    PaymentHistoryViewModel viewModel,
    AppLocalizations l10n,
  ) {
    final paymentService = locator<PaymentService>();

    return AppRefreshIndicator(
      onRefresh: viewModel.refresh,
      child: ListView.separated(
        padding: EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.sm,
        ),
        itemCount: viewModel.payments.length,
        separatorBuilder: (_, __) => const AppDivider(),
        itemBuilder: (context, index) {
          final payment = viewModel.payments[index];
          return AppListTile(
            leading: _buildCompactStatusIcon(payment.status),
            title: Text(
              paymentService.formatAmount(payment.amount, payment.currency),
              style: AppTypography.bodyLarge.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            subtitle: Text(
              payment.description ?? _formatDate(payment.createdAt),
              style: AppTypography.bodySmall.copyWith(
                color: AppColors.contrastMediumLight,
              ),
            ),
            trailing: _buildStatusChipCompact(payment.status),
            onTap: () => onPaymentTap?.call(payment),
          );
        },
      ),
    );
  }

  Widget _buildCompactStatusIcon(PaymentStatus status) {
    final (IconData icon, Color color) = switch (status) {
      PaymentStatus.success => (Icons.check_circle, AppColors.success),
      PaymentStatus.pending ||
      PaymentStatus.processing => (Icons.hourglass_empty, AppColors.warning),
      PaymentStatus.failed => (Icons.error, AppColors.error),
      PaymentStatus.cancelled => (Icons.cancel, AppColors.contrastMediumLight),
      PaymentStatus.refunded => (Icons.undo, AppColors.info),
      PaymentStatus.expired => (Icons.timer_off, AppColors.contrastMediumLight),
    };
    return Icon(icon, color: color, size: AppSpacing.iconMd);
  }

  Widget _buildStatusChipCompact(PaymentStatus status) {
    return switch (status) {
      PaymentStatus.success => const AppStatusChip.success(label: 'SUCCESS'),
      PaymentStatus.pending => const AppStatusChip.warning(label: 'PENDING'),
      PaymentStatus.processing => const AppStatusChip.info(label: 'PROCESSING'),
      PaymentStatus.failed => const AppStatusChip.error(label: 'FAILED'),
      PaymentStatus.cancelled => const AppStatusChip.info(label: 'CANCELLED'),
      PaymentStatus.refunded => const AppStatusChip.info(label: 'REFUNDED'),
      PaymentStatus.expired => const AppStatusChip.warning(label: 'EXPIRED'),
    };
  }

  Map<String, List<PaymentEntity>> _groupByMonth(List<PaymentEntity> payments) {
    final map = <String, List<PaymentEntity>>{};
    for (final payment in payments) {
      final key = DateFormat('MMMM yyyy').format(payment.createdAt);
      map.putIfAbsent(key, () => []).add(payment);
    }
    return map;
  }

  String _formatDate(DateTime date) {
    return DateFormat('dd/MM/yyyy HH:mm').format(date);
  }

  @override
  PaymentHistoryViewModel viewModelBuilder(BuildContext context) =>
      PaymentHistoryViewModel(organizationId: organizationId);

  @override
  void onViewModelReady(PaymentHistoryViewModel viewModel) {
    viewModel.loadPayments();
  }
}

// =============================================================================
// VIEW MODEL
// =============================================================================

/// ViewModel for PaymentHistoryView.
class PaymentHistoryViewModel extends BaseViewModel {
  final String organizationId;
  final _paymentService = locator<PaymentService>();

  PaymentHistoryViewModel({required this.organizationId});

  List<PaymentEntity> get payments => _paymentService.payments;

  bool get isLoading => _paymentService.isLoading;

  Future<void> loadPayments() async {
    final result = await _paymentService.loadPayments(
      organizationId: organizationId,
    );
    result.fold((failure) => setError(failure.message), (_) => null);
  }

  Future<void> refresh() async {
    clearErrors();
    await loadPayments();
  }
}

// =============================================================================
// PAYMENT LIST ITEM WIDGET
// =============================================================================

/// A single payment list item using Design System components.
class PaymentListItem extends StatelessWidget {
  final PaymentEntity payment;
  final VoidCallback? onTap;
  final VoidCallback? onRetry;

  const PaymentListItem({
    required this.payment,
    this.onTap,
    this.onRetry,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final paymentService = locator<PaymentService>();

    return AppCard.elevated(
      onTap: onTap,
      child: Row(
        children: [
          _buildStatusIcon(),
          SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  payment.description ?? 'Payment',
                  style: AppTypography.bodyLarge.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: AppSpacing.xxs),
                Text(
                  _formatDate(payment.createdAt),
                  style: AppTypography.bodySmall.copyWith(
                    color: AppColors.contrastMediumLight,
                  ),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                paymentService.formatAmount(payment.amount, payment.currency),
                style: AppTypography.bodyLarge.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: AppSpacing.xxs),
              _buildStatusChip(),
            ],
          ),
          if (onRetry != null) ...[
            SizedBox(width: AppSpacing.sm),
            AppButton.ghost(
              label: '',
              leftIcon: Icons.refresh,
              onPressed: onRetry,
              isFullWidth: false,
              size: AppButtonSize.small,
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildStatusIcon() {
    IconData icon;
    Color color;

    switch (payment.status) {
      case PaymentStatus.success:
        icon = Icons.check_circle;
        color = AppColors.success;
      case PaymentStatus.pending:
      case PaymentStatus.processing:
        icon = Icons.hourglass_empty;
        color = AppColors.warning;
      case PaymentStatus.failed:
        icon = Icons.error;
        color = AppColors.error;
      case PaymentStatus.cancelled:
        icon = Icons.cancel;
        color = AppColors.contrastMediumLight;
      case PaymentStatus.refunded:
        icon = Icons.undo;
        color = AppColors.info;
      case PaymentStatus.expired:
        icon = Icons.timer_off;
        color = AppColors.contrastMediumLight;
    }

    return Container(
      padding: EdgeInsets.all(AppSpacing.sm),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: AppRadius.button,
      ),
      child: Icon(icon, color: color, size: AppSpacing.iconMd),
    );
  }

  Widget _buildStatusChip() {
    switch (payment.status) {
      case PaymentStatus.success:
        return const AppStatusChip.success(label: 'SUCCESS');
      case PaymentStatus.pending:
        return const AppStatusChip.warning(label: 'PENDING');
      case PaymentStatus.processing:
        return const AppStatusChip.info(label: 'PROCESSING');
      case PaymentStatus.failed:
        return const AppStatusChip.error(label: 'FAILED');
      case PaymentStatus.cancelled:
        return const AppStatusChip.info(label: 'CANCELLED');
      case PaymentStatus.refunded:
        return const AppStatusChip.info(label: 'REFUNDED');
      case PaymentStatus.expired:
        return const AppStatusChip.warning(label: 'EXPIRED');
    }
  }

  String _formatDate(DateTime date) {
    final day = date.day.toString().padLeft(2, '0');
    final month = date.month.toString().padLeft(2, '0');
    final year = date.year;
    final hour = date.hour.toString().padLeft(2, '0');
    final minute = date.minute.toString().padLeft(2, '0');
    return '$day/$month/$year $hour:$minute';
  }
}
