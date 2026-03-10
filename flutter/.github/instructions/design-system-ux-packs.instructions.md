```instructions
---
applyTo: "**/*.dart"
---
# Design System — UX Packs (Flow, Pro, Community)

> Specialized component kits for each app family.
> Built ON TOP of the Generic Core — they reuse AppCard, AppButton, etc.
> Each app uses exactly ONE UX Pack based on its family.

---

## Architecture

```
Generic Core Components
  ├── AppButton, AppCard, AppListTile, AppTextField...
  │
  ├── Flow Pack (personal growth apps)
  │   ├── DashboardCard
  │   ├── HabitTrackerRow
  │   ├── StreakCounter
  │   ├── ProgressRing
  │   ├── WeeklyChart
  │   ├── AiChatBubble
  │   ├── CheckInSlider
  │   └── ReviewTemplate
  │
  ├── Pro Pack (business tools)
  │   ├── VoiceInputFab
  │   ├── ClientCard
  │   ├── DocumentPreview
  │   ├── PaymentTimeline
  │   ├── WhatsAppShareButton
  │   ├── QuickEntrySheet
  │   ├── DebtTracker
  │   └── PdfViewer
  │
  └── Community Pack (collective platforms)
      ├── RoleBadge
      ├── MemberCard
      ├── EventCard
      ├── CalendarView
      ├── NotificationBell
      ├── AdminKpiCard
      └── AttendanceTracker
```

---

## Flow Pack

> For: LifeFlow, IronFlow, SpiritFlow, MindFlow, WealthFlow, LingoFlow, CoupleFlow, ReadFlow, PresenceFlow

### DashboardCard

Summary card for the home screen — shows key metric + trend.

```dart
DashboardCard(
  title: context.l10n.dailyProgress,
  value: '7/10',
  trend: TrendDirection.up,       // ↑ green, ↓ red, → neutral
  trendLabel: '+2 vs hier',
  icon: LucideIcons.target,
  onTap: viewModel.openDetail,
)
```

- Uses `AppCard.elevated` as base.
- Progress ring or sparkline inline.
- Tap → navigate to detail.

### HabitTrackerRow

Single habit row with check action.

```dart
HabitTrackerRow(
  name: habit.name,
  icon: habit.icon,
  isCompleted: habit.completedToday,
  streak: habit.currentStreak,
  onToggle: () => viewModel.toggleHabit(habit.id),
)
```

- Leading: category icon.
- Trailing: AnimatedScale checkmark.
- Swipeable: edit (left), skip (right).
- Haptic on toggle.

### StreakCounter

Flame icon + count + visual upgrade by milestone.

```dart
StreakCounter(
  count: 14,
  milestone: StreakMilestone.bronze, // 7+: bronze, 30+: silver, 100+: gold
)
```

### ProgressRing

Circular progress with percentage label.

```dart
ProgressRing(
  value: 0.7,            // 0.0 to 1.0
  size: AppSizing.circularProgressLg,
  label: '70%',
  color: context.colorScheme.primary,
)
```

### WeeklyChart

Bar chart showing 7 days of data.

```dart
WeeklyChart(
  data: viewModel.weeklyData, // List<double> of 7 values
  labels: ['L', 'M', 'M', 'J', 'V', 'S', 'D'],
  highlightToday: true,
)
```

### AiChatBubble

Chat message bubble for AI coach.

```dart
AiChatBubble(
  message: 'Essaie de méditer 5 minutes ce soir.',
  isUser: false,       // AI = left, User = right
  timestamp: DateTime.now(),
  actions: [           // Optional inline actions
    BubbleAction(label: context.l10n.tryIt, onTap: viewModel.tryMeditation),
  ],
)
```

### CheckInSlider

Mood/energy slider for daily check-ins.

```dart
CheckInSlider(
  label: context.l10n.howAreYouFeeling,
  min: 1,
  max: 5,
  value: viewModel.moodValue,
  onChanged: viewModel.setMood,
  emojis: ['😞', '😐', '🙂', '😊', '🤩'],
)
```

### ReviewTemplate

End-of-day or end-of-week review card.

```dart
ReviewTemplate(
  period: ReviewPeriod.daily,
  completedCount: 7,
  totalCount: 10,
  topAchievement: context.l10n.longestStreak,
  reflection: viewModel.reflectionText,
)
```

---

## Pro Pack

> For: HustlePro, ForgePro, StockPilot, StyleFlow, EventPro

### VoiceInputFab

FAB with microphone icon for voice-to-text input.

```dart
VoiceInputFab(
  onTranscription: viewModel.handleVoiceInput,
  language: 'fr-FR',
)
```

- Long-press to start recording.
- Waveform animation during recording.
- Transcription preview before confirm.

### ClientCard

Client info card with quick actions.

```dart
ClientCard(
  name: client.fullName,
  phone: client.phone,
  lastContact: client.lastContactDate,
  totalDue: client.outstandingBalance,
  onCall: () => viewModel.callClient(client),
  onWhatsApp: () => viewModel.whatsAppClient(client),
)
```

### DocumentPreview

Thumbnail preview of a PDF/invoice.

```dart
DocumentPreview(
  title: document.title,
  type: DocumentType.invoice,
  createdAt: document.createdAt,
  thumbnail: document.thumbnailUrl,
  onTap: () => viewModel.openDocument(document),
  onShare: () => viewModel.shareDocument(document),
)
```

### PaymentTimeline

Timeline of payments (paid, pending, overdue).

```dart
PaymentTimeline(
  payments: viewModel.payments,
  // Each entry: { date, amount, status: paid|pending|overdue }
)
```

### WhatsAppShareButton

Quick share via WhatsApp with pre-formatted message.

```dart
WhatsAppShareButton(
  message: viewModel.shareMessage,  // Pre-formatted text
  phone: client.phone,              // Optional direct contact
)
```

### QuickEntrySheet

Bottom sheet for rapid data entry (sale, expense, client note).

```dart
QuickEntrySheet(
  fields: [
    QuickField.amount(label: context.l10n.amount),
    QuickField.text(label: context.l10n.description),
    QuickField.category(options: viewModel.categories),
  ],
  onSubmit: viewModel.quickSave,
)
```

### DebtTracker

Visual tracker for client debts.

```dart
DebtTracker(
  totalDebt: 150000,         // FCFA
  paidAmount: 75000,
  currency: 'FCFA',
  dueDate: DateTime(2026, 4, 1),
)
```

### PdfViewer

In-app PDF viewer for invoices, documents.

```dart
PdfViewer(
  url: document.pdfUrl,
  title: document.title,
  actions: [
    PdfAction.share,
    PdfAction.download,
    PdfAction.print,
  ],
)
```

---

## Community Pack

> For: ChurchFlow, PrepExam, CareFlow

### RoleBadge

Visual indicator of user role within organization.

```dart
RoleBadge(
  role: MemberRole.admin,    // admin, leader, member, guest
  size: BadgeSize.small,
)
```

- Admin: primary color.
- Leader: accent color.
- Member: neutral.
- Guest: outlined.

### MemberCard

Organization member card.

```dart
MemberCard(
  name: member.fullName,
  role: member.role,
  avatar: member.avatarUrl,
  joinedAt: member.joinedDate,
  onTap: () => viewModel.openMember(member),
)
```

### EventCard

Upcoming event card.

```dart
EventCard(
  title: event.title,
  date: event.dateTime,
  location: event.location,
  attendeeCount: event.attendees.length,
  onTap: () => viewModel.openEvent(event),
  onRsvp: () => viewModel.rsvp(event),
)
```

### CalendarView

Monthly/weekly calendar with event dots.

```dart
CalendarView(
  events: viewModel.events,
  selectedDate: viewModel.selectedDate,
  onDateSelected: viewModel.selectDate,
  onMonthChanged: viewModel.loadMonth,
)
```

### NotificationBell

Notification icon with count badge.

```dart
NotificationBell(
  unreadCount: viewModel.unreadNotifications,
  onTap: viewModel.openNotifications,
)
```

### AdminKpiCard

Key metric card for admin dashboards.

```dart
AdminKpiCard(
  title: context.l10n.totalMembers,
  value: '247',
  trend: '+12 ce mois',
  icon: LucideIcons.users,
)
```

### AttendanceTracker

Visual attendance tracking for events/services.

```dart
AttendanceTracker(
  totalExpected: 200,
  presentCount: 187,
  date: event.date,
)
```

---

## Which Pack for Which App?

| App | Family | Pack |
|-----|--------|------|
| LifeFlow | Flow | `UxPack.flow` |
| IronFlow | Flow | `UxPack.flow` |
| SpiritFlow | Flow | `UxPack.flow` |
| MindFlow | Flow | `UxPack.flow` |
| WealthFlow | Flow | `UxPack.flow` |
| HustlePro | Pro | `UxPack.pro` |
| ForgePro | Pro | `UxPack.pro` |
| StockPilot | Pro | `UxPack.pro` |
| StyleFlow | Pro | `UxPack.pro` |
| EventPro | Pro | `UxPack.pro` |
| ChurchFlow | Community | `UxPack.community` |
| PrepExam | Community | `UxPack.community` |
| CareFlow | Community | `UxPack.community` |

---

## Rules

1. **Pack widgets reuse Generic Core** — they wrap AppCard, AppButton, etc.
2. **Pack widgets follow all DS rules** — tokens, a11y, haptics, animations.
3. **One app = one pack** — no mixing Flow + Pro widgets in the same app.
4. **Pack lives in** `lib/ui/packs/flow/`, `lib/ui/packs/pro/`, `lib/ui/packs/community/`.
5. **Pack selection is in the Brand Skin** — `uxPack: UxPack.flow`.
```
