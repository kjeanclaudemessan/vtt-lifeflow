import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:stacked/stacked.dart';

import '../../../../app/app.locator.dart';
import '../../../../design_system/design_system.dart';
import '../../../../l10n/generated/app_localizations.dart';
import '../domain/entities/payment_entity.dart';
import '../payment_service.dart';

/// View displaying detailed payment information.
///
/// This is a reusable view that can be used in any app based on the template.
///
/// Example:
/// ```dart
/// Navigator.push(
///   context,
///   MaterialPageRoute(
///     builder: (_) => PaymentDetailView(payment: paymentEntity),
///   ),
/// );
/// ```
class PaymentDetailView extends StackedView<PaymentDetailViewModel> {
  /// The payment to display.
  final PaymentEntity payment;

  /// Optional callback to retry payment.
  final VoidCallback? onRetry;

  /// Optional callback when payment is refunded.
  final VoidCallback? onRefunded;

  const PaymentDetailView({
    required this.payment,
    this.onRetry,
    this.onRefunded,
    super.key,
  });

  @override
  Widget builder(
    BuildContext context,
    PaymentDetailViewModel viewModel,
    Widget? child,
  ) {
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppAppBar(
        title: 'Payment Details', // TODO: Add to l10n
        leading: const AppBackButton(),
        actions: [
          if (viewModel.isBusy)
            Padding(
              padding: EdgeInsets.all(AppSpacing.md),
              child: const AppLoader.small(),
            )
          else
            IconButton(
              icon: const Icon(Icons.refresh),
              onPressed: viewModel.refreshStatus,
            ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildAmountCard(context, viewModel, l10n),
            SizedBox(height: AppSpacing.md),
            _buildDetailsCard(context, viewModel, l10n),
            SizedBox(height: AppSpacing.md),
            _buildStatusCard(context, viewModel, l10n),
            if (viewModel.currentPayment.checkoutUrl != null) ...[
              SizedBox(height: AppSpacing.md),
              _buildCheckoutCard(context, viewModel, l10n),
            ],
            if (viewModel.showActions) ...[
              SizedBox(height: AppSpacing.lg),
              _buildActions(context, viewModel, l10n),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildAmountCard(
    BuildContext context,
    PaymentDetailViewModel viewModel,
    AppLocalizations l10n,
  ) {
    final paymentService = locator<PaymentService>();

    return AppCard.filled(
      backgroundColor: AppColors.primaryLight,
      child: Column(
        children: [
          Text(
            'Amount', // TODO: Add to l10n
            style: AppTypography.labelMedium.copyWith(
              color: AppColors.primaryDark,
            ),
          ),
          SizedBox(height: AppSpacing.xs),
          Text(
            paymentService.formatAmount(
              viewModel.currentPayment.amount,
              viewModel.currentPayment.currency,
            ),
            style: AppTypography.displaySmall.copyWith(
              color: AppColors.primaryDark,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: AppSpacing.sm),
          _buildStatusChip(viewModel.currentPayment.status),
        ],
      ),
    );
  }

  Widget _buildDetailsCard(
    BuildContext context,
    PaymentDetailViewModel viewModel,
    AppLocalizations l10n,
  ) {
    final payment = viewModel.currentPayment;

    return AppCard.outlined(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Details', // TODO: Add to l10n
            style: AppTypography.headingSmall,
          ),
          SizedBox(height: AppSpacing.md),
          _DetailRow(
            label: 'Description',
            value: payment.description ?? '-',
          ),
          SizedBox(height: AppSpacing.sm),
          const AppDivider(),
          SizedBox(height: AppSpacing.sm),
          _DetailRow(
            label: 'Payment Method',
            value: payment.paymentMethod ?? '-',
          ),
          SizedBox(height: AppSpacing.sm),
          const AppDivider(),
          SizedBox(height: AppSpacing.sm),
          _DetailRow(
            label: 'Currency',
            value: payment.currency,
          ),
          SizedBox(height: AppSpacing.sm),
          const AppDivider(),
          SizedBox(height: AppSpacing.sm),
          _DetailRow(
            label: 'Created',
            value: _formatDateTime(payment.createdAt),
          ),
          if (payment.completedAt != null) ...[
            SizedBox(height: AppSpacing.sm),
            const AppDivider(),
            SizedBox(height: AppSpacing.sm),
            _DetailRow(
              label: 'Completed',
              value: _formatDateTime(payment.completedAt!),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildStatusCard(
    BuildContext context,
    PaymentDetailViewModel viewModel,
    AppLocalizations l10n,
  ) {
    final payment = viewModel.currentPayment;

    return AppCard.outlined(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Transaction Info', // TODO: Add to l10n
            style: AppTypography.headingSmall,
          ),
          SizedBox(height: AppSpacing.md),
          _DetailRow(
            label: 'Payment ID',
            value: payment.id,
            isCopyable: true,
          ),
          if (payment.providerTxId != null) ...[
            SizedBox(height: AppSpacing.sm),
            const AppDivider(),
            SizedBox(height: AppSpacing.sm),
            _DetailRow(
              label: 'External ID',
              value: payment.providerTxId!,
              isCopyable: true,
            ),
          ],
          SizedBox(height: AppSpacing.sm),
          const AppDivider(),
          SizedBox(height: AppSpacing.sm),
          _DetailRow(
            label: 'Status',
            value: payment.statusDisplayName,
          ),
          if (payment.metadata.isNotEmpty) ...[
            SizedBox(height: AppSpacing.sm),
            const AppDivider(),
            SizedBox(height: AppSpacing.sm),
            Text(
              'Metadata', // TODO: Add to l10n
              style: AppTypography.labelMedium.copyWith(
                color: AppColors.contrastMediumLight,
              ),
            ),
            SizedBox(height: AppSpacing.xs),
            ...payment.metadata.entries.map(
              (entry) => Padding(
                padding: EdgeInsets.only(bottom: AppSpacing.xxs),
                child: Text(
                  '${entry.key}: ${entry.value}',
                  style: AppTypography.bodySmall,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildCheckoutCard(
    BuildContext context,
    PaymentDetailViewModel viewModel,
    AppLocalizations l10n,
  ) {
    return AppCard.outlined(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Checkout URL', // TODO: Add to l10n
            style: AppTypography.headingSmall,
          ),
          SizedBox(height: AppSpacing.md),
          AppListTile.navigation(
            leading: const Icon(Icons.open_in_new, color: AppColors.primary),
            title: 'Open Checkout',
            subtitle: 'Complete your payment in browser',
            onTap: () => viewModel.openCheckout(context),
          ),
        ],
      ),
    );
  }

  Widget _buildActions(
    BuildContext context,
    PaymentDetailViewModel viewModel,
    AppLocalizations l10n,
  ) {
    final payment = viewModel.currentPayment;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (payment.canRetry && onRetry != null)
          AppButton(
            label: 'Retry Payment', // TODO: Add to l10n
            variant: AppButtonVariant.primary,
            leftIcon: Icons.refresh,
            onPressed: onRetry,
          ),
        if (payment.checkoutUrl != null && payment.isPending) ...[
          SizedBox(height: AppSpacing.sm),
          AppButton.secondary(
            label: 'Open Checkout',
            leftIcon: Icons.open_in_new,
            onPressed: () => viewModel.openCheckout(context),
          ),
        ],
      ],
    );
  }

  Widget _buildStatusChip(PaymentStatus status) {
    switch (status) {
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

  String _formatDateTime(DateTime date) {
    final day = date.day.toString().padLeft(2, '0');
    final month = date.month.toString().padLeft(2, '0');
    final year = date.year;
    final hour = date.hour.toString().padLeft(2, '0');
    final minute = date.minute.toString().padLeft(2, '0');
    return '$day/$month/$year $hour:$minute';
  }

  @override
  PaymentDetailViewModel viewModelBuilder(BuildContext context) =>
      PaymentDetailViewModel(payment: payment);
}

// =============================================================================
// VIEW MODEL
// =============================================================================

/// ViewModel for PaymentDetailView.
class PaymentDetailViewModel extends BaseViewModel {
  final _paymentService = locator<PaymentService>();
  PaymentEntity _currentPayment;

  PaymentDetailViewModel({required PaymentEntity payment})
      : _currentPayment = payment;

  PaymentEntity get currentPayment => _currentPayment;

  bool get showActions => _currentPayment.canRetry || _currentPayment.isPending;

  Future<void> refreshStatus() async {
    setBusy(true);
    final result =
        await _paymentService.refreshPaymentStatus(_currentPayment.id);
    result.fold(
      (failure) => setError(failure.message),
      (updatedPayment) => _currentPayment = updatedPayment,
    );
    setBusy(false);
  }

  Future<void> openCheckout(BuildContext context) async {
    if (_currentPayment.checkoutUrl == null) return;

    await _paymentService.openCheckout(
      context,
      _currentPayment,
      onSuccess: () => refreshStatus(),
      onFailure: () => setError('Payment failed'),
      onCancel: () => setError('Payment cancelled'),
    );
  }
}

// =============================================================================
// HELPER WIDGETS
// =============================================================================

class _DetailRow extends StatelessWidget {
  final String label;
  final String value;
  final bool isCopyable;

  const _DetailRow({
    required this.label,
    required this.value,
    this.isCopyable = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 2,
          child: Text(
            label,
            style: AppTypography.bodyMedium.copyWith(
              color: AppColors.contrastMediumLight,
            ),
          ),
        ),
        Expanded(
          flex: 3,
          child: Row(
            children: [
              Expanded(
                child: Text(
                  value,
                  style: AppTypography.bodyMedium.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              if (isCopyable)
                IconButton(
                  icon: const Icon(
                    Icons.copy,
                    size: 16,
                    color: AppColors.contrastMediumLight,
                  ),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                  onPressed: () => _copyToClipboard(context, value),
                ),
            ],
          ),
        ),
      ],
    );
  }

  void _copyToClipboard(BuildContext context, String text) {
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Copied to clipboard')),
    );
  }
}
