/// Configuration for the Payments module.
///
/// Customizes the payment history visual style and display options.
class PaymentsConfig {
  /// Visual style of the payment history list.
  final PaymentsStyle style;

  /// Whether to show the status filter chips.
  final bool showStatusFilters;

  /// Whether to show the pull-to-refresh indicator.
  final bool enablePullToRefresh;

  const PaymentsConfig({
    this.style = PaymentsStyle.cards,
    this.showStatusFilters = false,
    this.enablePullToRefresh = true,
  });

  /// Default configuration.
  static const PaymentsConfig defaultConfig = PaymentsConfig();
}

/// Visual styles for the payment history.
enum PaymentsStyle {
  /// Card-based layout — each payment in an elevated card.
  cards,

  /// Grouped layout — payments grouped by month with section headers.
  grouped,

  /// Compact layout — dense list with minimal spacing.
  compact,
}
