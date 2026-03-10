/// UX Pack families for VTT apps.
///
/// Each app belongs to a UX Pack that determines which
/// specialized widgets and interaction patterns are available.
///
/// - [flow] — Personal growth apps (LifeFlow, IronFlow, SpiritFlow…)
/// - [pro] — Business/productivity apps (HustlePro, ForgePro…)
/// - [community] — Collective platform apps (ChurchFlow, PrepExam…)
enum UxPack {
  /// Personal growth apps — dashboards, habit tracking, streaks,
  /// progress rings, weekly charts, IA coach bubbles, check-in sliders.
  flow,

  /// Business / productivity apps — voice input FAB, client cards,
  /// document preview, payment timeline, WhatsApp share, quick-entry
  /// bottom sheet, debt tracker, PDF viewer.
  pro,

  /// Collective platform apps — role badges, member cards, event cards,
  /// calendar views, notification bell with count, admin KPI cards,
  /// attendance tracker.
  community,
}
