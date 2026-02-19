import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:stacked/stacked.dart';

import '../../../design_system/design_system.dart';
import 'design_showcase_viewmodel.dart';

/// Design System Showcase View.
///
/// A comprehensive view showing all design system components.
class DesignShowcaseView extends StackedView<DesignShowcaseViewModel> {
  const DesignShowcaseView({super.key});

  @override
  Widget builder(
    BuildContext context,
    DesignShowcaseViewModel viewModel,
    Widget? child,
  ) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text('Design System'),
        actions: [
          IconButton(
            icon: Icon(
              viewModel.isDarkMode ? Icons.light_mode : Icons.dark_mode,
            ),
            onPressed: viewModel.toggleTheme,
          ),
        ],
      ),
      body: DefaultTabController(
        length: 8,
        child: Column(
          children: [
            const TabBar(
              isScrollable: true,
              tabs: [
                Tab(text: 'Colors'),
                Tab(text: 'Typography'),
                Tab(text: 'Buttons'),
                Tab(text: 'Inputs'),
                Tab(text: 'Forms'),
                Tab(text: 'Feedback'),
                Tab(text: 'Navigation'),
                Tab(text: 'Components'),
              ],
              labelColor: AppColors.primary,
              unselectedLabelColor: AppColors.textSecondaryLight,
              indicatorColor: AppColors.primary,
            ),
            Expanded(
              child: TabBarView(
                children: [
                  _ColorsTab(),
                  _TypographyTab(),
                  _ButtonsTab(viewModel: viewModel),
                  _InputsTab(),
                  _FormsTab(),
                  _FeedbackTab(viewModel: viewModel),
                  _NavigationTab(),
                  _ComponentsTab(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  DesignShowcaseViewModel viewModelBuilder(BuildContext context) =>
      DesignShowcaseViewModel();
}

// ============================================
// COLORS TAB
// ============================================
class _ColorsTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: AppSpacing.screenPadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _SectionTitle('Brand Colors'),
          const _ColorRow([
            _ColorItem('Primary', AppColors.primary),
            _ColorItem('Light', AppColors.primaryLight),
            _ColorItem('Dark', AppColors.primaryDark),
          ]),
          AppSpacing.verticalXxl,
          const _SectionTitle('Contrast Colors (Light Theme)'),
          const _ColorRow([
            _ColorItem('High', AppColors.contrastHighLight),
            _ColorItem('Medium', AppColors.contrastMediumLight),
            _ColorItem('Low', AppColors.contrastLowLight),
          ]),
          AppSpacing.verticalXxl,
          const _SectionTitle('Contrast Colors (Dark Theme)'),
          const _ColorRow([
            _ColorItem('High', AppColors.contrastHighDark),
            _ColorItem('Medium', AppColors.contrastMediumDark),
            _ColorItem('Low', AppColors.contrastLowDark),
          ]),
          AppSpacing.verticalXxl,
          const _SectionTitle('Semantic Colors'),
          const _ColorRow([
            _ColorItem('Success', AppColors.success),
            _ColorItem('Error', AppColors.error),
            _ColorItem('Warning', AppColors.warning),
            _ColorItem('Info', AppColors.info),
          ]),
          AppSpacing.verticalXxl,
          const _SectionTitle('Base Colors'),
          Wrap(
            spacing: 8.w,
            runSpacing: 8.h,
            children: const [
              _ColorItem('White', AppColors.white, small: true),
              _ColorItem('Black', AppColors.black, small: true),
              _ColorItem('Background L', AppColors.backgroundLight,
                  small: true),
              _ColorItem('Background D', AppColors.backgroundDark, small: true),
              _ColorItem('Surface L', AppColors.surfaceLight, small: true),
              _ColorItem('Surface D', AppColors.surfaceDark, small: true),
            ],
          ),
        ],
      ),
    );
  }
}

class _ColorRow extends StatelessWidget {
  final List<Widget> children;

  const _ColorRow(this.children);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(children: children),
    );
  }
}

class _ColorItem extends StatelessWidget {
  final String name;
  final Color color;
  final bool small;

  const _ColorItem(this.name, this.color, {this.small = false});

  @override
  Widget build(BuildContext context) {
    final size = small ? 50.w : 80.w;

    return Padding(
      padding: EdgeInsets.only(right: small ? 0 : 12.w),
      child: Column(
        children: [
          Container(
            width: size,
            height: size,
            decoration: BoxDecoration(
              color: color,
              borderRadius: AppRadius.md,
              border: Border.all(color: AppColors.borderLight),
            ),
          ),
          AppSpacing.verticalXxs,
          Text(
            name,
            style: AppTypography.caption,
          ),
        ],
      ),
    );
  }
}

// ============================================
// TYPOGRAPHY TAB
// ============================================
class _TypographyTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: AppSpacing.screenPadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _SectionTitle('Display Styles'),
          Text('Display Large', style: AppTypography.displayLarge),
          AppSpacing.verticalSm,
          Text('Display Medium', style: AppTypography.displayMedium),
          AppSpacing.verticalSm,
          Text('Display Small', style: AppTypography.displaySmall),
          AppSpacing.verticalXxl,
          const _SectionTitle('Headline Styles'),
          Text('Headline Large', style: AppTypography.headlineLarge),
          AppSpacing.verticalSm,
          Text('Headline Medium', style: AppTypography.headlineMedium),
          AppSpacing.verticalSm,
          Text('Headline Small', style: AppTypography.headlineSmall),
          AppSpacing.verticalXxl,
          const _SectionTitle('Title Styles'),
          Text('Title Large', style: AppTypography.titleLarge),
          AppSpacing.verticalSm,
          Text('Title Medium', style: AppTypography.titleMedium),
          AppSpacing.verticalSm,
          Text('Title Small', style: AppTypography.titleSmall),
          AppSpacing.verticalXxl,
          const _SectionTitle('Body Styles'),
          Text('Body Large - Regular text for content',
              style: AppTypography.bodyLarge),
          AppSpacing.verticalSm,
          Text('Body Medium - Secondary text', style: AppTypography.bodyMedium),
          AppSpacing.verticalSm,
          Text('Body Small - Supporting text', style: AppTypography.bodySmall),
          AppSpacing.verticalXxl,
          const _SectionTitle('Label Styles'),
          Text('Label Large', style: AppTypography.labelLarge),
          AppSpacing.verticalSm,
          Text('Label Medium', style: AppTypography.labelMedium),
          AppSpacing.verticalSm,
          Text('Label Small', style: AppTypography.labelSmall),
          AppSpacing.verticalXxl,
          const _SectionTitle('Special Styles'),
          Text('Caption text', style: AppTypography.caption),
          AppSpacing.verticalSm,
          Text('OVERLINE TEXT', style: AppTypography.overline),
          AppSpacing.verticalSm,
          Text('Link Text', style: AppTypography.link),
          AppSpacing.verticalXxl,
          const _SectionTitle('Number Styles'),
          Text('1,234,567', style: AppTypography.numberLarge),
          AppSpacing.verticalSm,
          Text('12,345', style: AppTypography.numberMedium),
          AppSpacing.verticalSm,
          Text('123', style: AppTypography.numberSmall),
        ],
      ),
    );
  }
}

// ============================================
// BUTTONS TAB
// ============================================
class _ButtonsTab extends StatelessWidget {
  final DesignShowcaseViewModel viewModel;

  const _ButtonsTab({required this.viewModel});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: AppSpacing.screenPadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _SectionTitle('Button Variants'),
          AppButton.primary(
            label: 'Primary Button',
            onPressed: () {},
          ),
          AppSpacing.verticalMd,
          AppButton.secondary(
            label: 'Secondary Button',
            onPressed: () {},
          ),
          AppSpacing.verticalMd,
          AppButton.outline(
            label: 'Outlined Button',
            onPressed: () {},
          ),
          AppSpacing.verticalMd,
          AppButton.danger(
            label: 'Danger Button',
            onPressed: () {},
          ),
          AppSpacing.verticalMd,
          AppButton.ghost(
            label: 'Ghost Button',
            onPressed: () {},
          ),
          AppSpacing.verticalXxl,
          const _SectionTitle('Button Sizes'),
          AppButton(
            label: 'Large Button',
            size: AppButtonSize.large,
            onPressed: () {},
          ),
          AppSpacing.verticalMd,
          AppButton(
            label: 'Medium Button',
            size: AppButtonSize.medium,
            onPressed: () {},
          ),
          AppSpacing.verticalMd,
          AppButton(
            label: 'Small Button',
            size: AppButtonSize.small,
            onPressed: () {},
          ),
          AppSpacing.verticalXxl,
          const _SectionTitle('Button with Icons'),
          AppButton(
            label: 'With Left Icon',
            leftIcon: Icons.add,
            onPressed: () {},
          ),
          AppSpacing.verticalMd,
          AppButton(
            label: 'With Right Icon',
            rightIcon: Icons.arrow_forward,
            onPressed: () {},
          ),
          AppSpacing.verticalXxl,
          const _SectionTitle('Button States'),
          AppButton(
            label: 'Loading Button',
            isLoading: viewModel.isLoading,
            onPressed: viewModel.simulateLoading,
          ),
          AppSpacing.verticalMd,
          const AppButton(
            label: 'Disabled Button',
            onPressed: null,
          ),
          AppSpacing.verticalXxl,
          const _SectionTitle('Icon Buttons'),
          Row(
            children: [
              AppIconButton(
                icon: Icons.notifications_outlined,
                onTap: () {},
              ),
              AppSpacing.horizontalMd,
              AppIconButton(
                icon: Icons.notifications_outlined,
                hasBadge: true,
                onTap: () {},
              ),
              AppSpacing.horizontalMd,
              AppIconButton(
                icon: Icons.shopping_cart_outlined,
                badgeCount: 3,
                onTap: () {},
              ),
              AppSpacing.horizontalMd,
              AppIconButton(
                icon: Icons.favorite,
                backgroundColor: AppColors.errorLight,
                iconColor: AppColors.error,
                onTap: () {},
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ============================================
// INPUTS TAB
// ============================================
class _InputsTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: AppSpacing.screenPadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _SectionTitle('Text Fields'),
          const AppTextField(
            label: 'Email',
            hint: 'Enter your email',
            prefixIcon: Icon(Icons.email_outlined),
          ),
          AppSpacing.verticalLg,
          const AppTextField(
            label: 'Username',
            hint: 'Choose a username',
          ),
          AppSpacing.verticalLg,
          const AppTextField(
            label: 'With Error',
            hint: 'Enter something',
            errorText: 'This field is required',
          ),
          AppSpacing.verticalLg,
          const AppTextField(
            label: 'Disabled',
            hint: 'Cannot edit',
            enabled: false,
          ),
          AppSpacing.verticalXxl,
          const _SectionTitle('Password Field'),
          const AppPasswordField(
            label: 'Password',
            hint: 'Enter your password',
          ),
          AppSpacing.verticalXxl,
          const _SectionTitle('Search Field'),
          const AppSearchField(
            hint: 'Search products...',
          ),
          AppSpacing.verticalXxl,
          const _SectionTitle('Text Area'),
          const AppTextField(
            label: 'Description',
            hint: 'Enter a description...',
            maxLines: 4,
          ),
        ],
      ),
    );
  }
}

// ============================================
// COMPONENTS TAB
// ============================================
class _ComponentsTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: AppSpacing.screenPadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _SectionTitle('Cards'),
          AppCard.elevated(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Elevated Card', style: AppTypography.titleLarge),
                AppSpacing.verticalSm,
                Text('This card has a shadow elevation.',
                    style: AppTypography.bodyMedium),
              ],
            ),
          ),
          AppSpacing.verticalMd,
          AppCard.outlined(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Outlined Card', style: AppTypography.titleLarge),
                AppSpacing.verticalSm,
                Text('This card has a border.',
                    style: AppTypography.bodyMedium),
              ],
            ),
          ),
          AppSpacing.verticalMd,
          AppCard.filled(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Filled Card', style: AppTypography.titleLarge),
                AppSpacing.verticalSm,
                Text('This card has a filled background.',
                    style: AppTypography.bodyMedium),
              ],
            ),
          ),
          AppSpacing.verticalMd,
          AppDarkCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Dark Card',
                    style: AppTypography.titleLarge
                        .copyWith(color: AppColors.white)),
                AppSpacing.verticalSm,
                Text('This is a dark themed card.',
                    style: AppTypography.bodyMedium
                        .copyWith(color: AppColors.contrastMediumDark)),
              ],
            ),
          ),
          AppSpacing.verticalXxl,
          const _SectionTitle('Chips'),
          Wrap(
            spacing: 8.w,
            runSpacing: 8.h,
            children: [
              const AppChip(label: 'Filled', variant: AppChipVariant.filled),
              const AppChip(
                  label: 'Outlined', variant: AppChipVariant.outlined),
              const AppChip(label: 'Tonal', variant: AppChipVariant.tonal),
              const AppChip.filter(label: 'Filter', isSelected: true),
              AppChip.removable(label: 'Removable', onTrailingTap: () {}),
            ],
          ),
          AppSpacing.verticalXxl,
          const _SectionTitle('Status Chips'),
          Wrap(
            spacing: 8.w,
            runSpacing: 8.h,
            children: const [
              AppStatusChip.success(label: 'Success'),
              AppStatusChip.error(label: 'Error'),
              AppStatusChip.warning(label: 'Warning'),
              AppStatusChip.info(label: 'Info'),
            ],
          ),
          AppSpacing.verticalXxl,
          const _SectionTitle('Avatars'),
          Row(
            children: [
              const AppAvatar.small(name: 'John Doe'),
              AppSpacing.horizontalMd,
              const AppAvatar(name: 'Jane Smith', isOnline: true),
              AppSpacing.horizontalMd,
              const AppAvatar.large(name: 'Bob Wilson'),
            ],
          ),
          AppSpacing.verticalMd,
          const AppAvatarGroup(
            avatars: [
              AvatarData(name: 'John'),
              AvatarData(name: 'Jane'),
              AvatarData(name: 'Bob'),
              AvatarData(name: 'Alice'),
              AvatarData(name: 'Charlie'),
            ],
          ),
          AppSpacing.verticalXxl,
          const _SectionTitle('Badges'),
          Row(
            children: [
              const AppBadge.dot(),
              AppSpacing.horizontalLg,
              const AppBadge(label: 'New'),
              AppSpacing.horizontalLg,
              const AppBadge.count(count: 5),
              AppSpacing.horizontalLg,
              const AppBadge.count(count: 99),
              AppSpacing.horizontalLg,
              const AppBadge.count(count: 150),
            ],
          ),
          AppSpacing.verticalMd,
          Row(
            children: [
              AppBadgeWrapper(
                count: 3,
                child: Container(
                  width: 40.w,
                  height: 40.w,
                  decoration: BoxDecoration(
                    color: AppColors.contrastLowLight,
                    borderRadius: AppRadius.md,
                  ),
                  child: const Icon(Icons.notifications_outlined),
                ),
              ),
              AppSpacing.horizontalLg,
              const AppBadgeWrapper(
                isDot: true,
                child: AppAvatar(name: 'User'),
              ),
            ],
          ),
          AppSpacing.verticalXxl,
          const _SectionTitle('Loaders'),
          Row(
            children: [
              const AppLoader.small(),
              AppSpacing.horizontalLg,
              const AppLoader.medium(),
              AppSpacing.horizontalLg,
              const AppLoader.large(),
            ],
          ),
          AppSpacing.verticalXxl,
          const _SectionTitle('Skeletons'),
          Row(
            children: [
              const AppSkeleton.circle(size: 48),
              AppSpacing.horizontalMd,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const AppSkeleton.text(width: 120),
                    AppSpacing.verticalXs,
                    const AppSkeleton.text(),
                  ],
                ),
              ),
            ],
          ),
          AppSpacing.verticalXxl,
          const _SectionTitle('Dividers'),
          const AppDivider(),
          AppSpacing.verticalMd,
          const AppSectionDivider(label: 'OR'),
          AppSpacing.verticalXxl,

          // ============================================
          // ADVANCED COMPONENTS
          // ============================================
          const _SectionTitle('🔥 Advanced: Hero Card'),
          AppHeroCard(
            title: 'Porsche Design\nInspired System',
            subtitle: 'Bold. Premium. High contrast.',
            actionLabel: 'Get Started',
            onAction: () {},
            gradientColors: [
              AppColors.black.withValues(alpha: 0.0),
              AppColors.contrastHighLight,
            ],
            background: Container(color: AppColors.contrastHighLight),
          ),
          AppSpacing.verticalXxl,

          const _SectionTitle('📊 Advanced: Stats Card'),
          const AppStatsCard(
            title: 'Performance Metrics',
            stats: [
              AppStatItem(
                value: '2.4M',
                label: 'Users',
                trend: '+12%',
                isTrendPositive: true,
              ),
              AppStatItem(
                value: '99.9%',
                label: 'Uptime',
                trend: '+0.1%',
                isTrendPositive: true,
              ),
              AppStatItem(
                value: '4.9★',
                label: 'Rating',
                trend: '+0.2',
                isTrendPositive: true,
              ),
              AppStatItem(
                value: '\$8.2k',
                label: 'Revenue',
                trend: '-3%',
                isTrendPositive: false,
              ),
            ],
          ),
          AppSpacing.verticalXxl,

          const _SectionTitle('🛒 Advanced: Product Card'),
          SizedBox(
            width: 220.w,
            child: AppProductCard(
              title: 'Taycan Turbo S',
              description: 'Electric Sports Car',
              price: '\$185,000',
              originalPrice: '\$199,000',
              badge: 'NEW',
              rating: 4.9,
              reviewCount: 128,
              isFavorite: true,
              onTap: () {},
              onFavorite: () {},
            ),
          ),
          AppSpacing.verticalXxl,

          const _SectionTitle('👤 Advanced: Profile Header'),
          AppProfileHeader(
            name: 'John Doe',
            subtitle: 'Premium Member • Software Engineer',
            stats: const [
              ProfileStat(value: '1.2k', label: 'Followers'),
              ProfileStat(value: '356', label: 'Following'),
              ProfileStat(value: '42', label: 'Posts'),
            ],
            showEditButton: true,
            onEdit: () {},
          ),
          AppSpacing.verticalXxl,

          const _SectionTitle('📝 Advanced: Action List'),
          Container(
            decoration: BoxDecoration(
              color: AppColors.surfaceLight,
              borderRadius: AppRadius.card,
              border: Border.all(color: AppColors.contrastLowLight),
            ),
            child: Column(
              children: [
                AppListTile(
                  leading: const Icon(Icons.settings,
                      color: AppColors.contrastHighLight),
                  title: 'Settings',
                  subtitle: 'Manage your preferences',
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {},
                ),
                const AppDivider(),
                AppListTile(
                  leading: const Icon(Icons.notifications,
                      color: AppColors.contrastHighLight),
                  title: 'Notifications',
                  subtitle: '3 new alerts',
                  trailing: Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: AppRadius.xs,
                    ),
                    child: Text(
                      '3',
                      style: AppTypography.labelSmall.copyWith(
                        color: AppColors.white,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  onTap: () {},
                ),
                const AppDivider(),
                AppListTile(
                  leading: const Icon(Icons.security,
                      color: AppColors.contrastHighLight),
                  title: 'Security',
                  subtitle: 'Two-factor enabled',
                  trailing:
                      const Icon(Icons.check_circle, color: AppColors.success),
                  onTap: () {},
                ),
                const AppDivider(),
                AppListTile(
                  leading: const Icon(Icons.logout, color: AppColors.error),
                  title: Text(
                    'Sign Out',
                    style: AppTypography.titleSmall
                        .copyWith(color: AppColors.error),
                  ),
                  subtitle: 'End your session',
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {},
                ),
              ],
            ),
          ),
          AppSpacing.verticalXxl,
        ],
      ),
    );
  }
}

// ============================================
// FORMS TAB
// ============================================
class _FormsTab extends StatefulWidget {
  @override
  State<_FormsTab> createState() => _FormsTabState();
}

class _FormsTabState extends State<_FormsTab> {
  bool _switchValue = true;
  bool _checkboxValue1 = true;
  bool _checkboxValue2 = false;
  bool? _checkboxValue3;
  int _radioValue = 1;
  double _sliderValue = 0.6;
  RangeValues _rangeValues = const RangeValues(20, 80);
  String? _dropdownValue = 'opt1';
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;
  int _segmentValue = 0;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: AppSpacing.screenPadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ═══════════════════════════════════════════════════════════════════
          // SWITCHES (using AppSwitch component)
          // ═══════════════════════════════════════════════════════════════════
          const _SectionTitle('Switches'),
          AppSwitch(
            value: _switchValue,
            onChanged: (v) => setState(() => _switchValue = v),
            label: 'Notifications',
            subtitle: 'Receive push notifications',
          ),
          AppSpacing.verticalSm,
          const AppSwitch(
            value: false,
            label: 'Dark Mode',
            subtitle: 'Enable dark theme (disabled)',
            isDisabled: true,
          ),
          AppSpacing.verticalXxl,

          // ═══════════════════════════════════════════════════════════════════
          // CHECKBOXES (using AppCheckbox component)
          // ═══════════════════════════════════════════════════════════════════
          const _SectionTitle('Checkboxes'),
          AppCheckbox(
            value: _checkboxValue1,
            onChanged: (v) => setState(() => _checkboxValue1 = v ?? false),
            label: 'Email notifications',
          ),
          AppSpacing.verticalXs,
          AppCheckbox(
            value: _checkboxValue2,
            onChanged: (v) => setState(() => _checkboxValue2 = v ?? false),
            label: 'SMS notifications',
            subtitle: 'Standard rates may apply',
          ),
          AppSpacing.verticalXs,
          AppCheckbox(
            value: _checkboxValue3,
            onChanged: (v) => setState(() => _checkboxValue3 = v),
            label: 'Tristate checkbox',
            subtitle: 'Tap multiple times',
            tristate: true,
          ),
          AppSpacing.verticalXxl,

          // ═══════════════════════════════════════════════════════════════════
          // RADIO BUTTONS (using AppRadioGroup component)
          // ═══════════════════════════════════════════════════════════════════
          const _SectionTitle('Radio Buttons'),
          AppRadioGroup<int>(
            options: const [
              AppRadioOption(
                value: 1,
                label: 'Standard Delivery',
                subtitle: 'Free - 5-7 business days',
              ),
              AppRadioOption(
                value: 2,
                label: 'Express Delivery',
                subtitle: '\$9.99 - 2-3 business days',
              ),
              AppRadioOption(
                value: 3,
                label: 'Next Day Delivery',
                subtitle: '\$19.99 - Next business day',
              ),
            ],
            groupValue: _radioValue,
            onChanged: (v) => setState(() => _radioValue = v ?? 1),
          ),
          AppSpacing.verticalXxl,

          // ═══════════════════════════════════════════════════════════════════
          // SLIDERS
          // ═══════════════════════════════════════════════════════════════════
          const _SectionTitle('Sliders'),
          AppSlider(
            value: _sliderValue,
            onChanged: (v) => setState(() => _sliderValue = v),
            label: 'Volume',
            showValue: true,
          ),
          AppSpacing.verticalMd,
          AppRangeSlider(
            values: _rangeValues,
            onChanged: (v) => setState(() => _rangeValues = v),
            min: 0,
            max: 100,
            label: 'Price Range',
            showValues: true,
            valueFormatter: (v) => '\$${v.toInt()}',
          ),
          AppSpacing.verticalXxl,

          // ═══════════════════════════════════════════════════════════════════
          // DROPDOWN (using AppDropdown component)
          // ═══════════════════════════════════════════════════════════════════
          const _SectionTitle('Dropdown / Select'),
          AppDropdown<String>(
            value: _dropdownValue,
            label: 'Select Option',
            hint: 'Choose an option',
            items: const [
              AppDropdownItem(value: 'opt1', label: 'Option 1'),
              AppDropdownItem(value: 'opt2', label: 'Option 2'),
              AppDropdownItem(
                value: 'opt3',
                label: 'Option 3',
                subtitle: 'With subtitle',
              ),
              AppDropdownItem(
                value: 'opt4',
                label: 'Option 4',
                icon: Icons.star,
              ),
            ],
            onChanged: (v) => setState(() => _dropdownValue = v),
            showClearButton: true,
          ),
          AppSpacing.verticalXxl,

          // ═══════════════════════════════════════════════════════════════════
          // DATE & TIME PICKERS (using AppDatePicker/AppTimePicker components)
          // ═══════════════════════════════════════════════════════════════════
          const _SectionTitle('Date & Time Pickers'),
          AppDatePicker(
            value: _selectedDate,
            onChanged: (date) => setState(() => _selectedDate = date),
            label: 'Select Date',
            hint: 'Pick a date',
            helperText: 'Styled DatePicker using Porsche Design System',
          ),
          AppSpacing.verticalMd,
          AppTimePicker(
            value: _selectedTime,
            onChanged: (time) => setState(() => _selectedTime = time),
            label: 'Select Time',
            hint: 'Pick a time',
            helperText: 'Styled TimePicker using Porsche Design System',
          ),
          AppSpacing.verticalXxl,

          // ═══════════════════════════════════════════════════════════════════
          // SEGMENTED BUTTON (using AppSegmentedButton component)
          // ═══════════════════════════════════════════════════════════════════
          const _SectionTitle('Segmented Button'),
          AppSegmentedButton<int>(
            segments: const [
              AppSegment(value: 0, label: 'Day'),
              AppSegment(value: 1, label: 'Week'),
              AppSegment(value: 2, label: 'Month'),
              AppSegment(value: 3, label: 'Year'),
            ],
            selected: _segmentValue,
            onChanged: (v) => setState(() => _segmentValue = v),
          ),
          AppSpacing.verticalMd,
          Text('With icons only:', style: AppTypography.labelMedium),
          AppSpacing.verticalXs,
          AppSegmentedButton<int>(
            segments: const [
              AppSegment(value: 0, icon: Icons.list),
              AppSegment(value: 1, icon: Icons.grid_view),
              AppSegment(value: 2, icon: Icons.map),
            ],
            selected: _segmentValue % 3,
            onChanged: (v) => setState(() => _segmentValue = v),
            showLabels: false,
            size: AppSegmentedButtonSize.small,
          ),
          AppSpacing.verticalXxl,

          // ═══════════════════════════════════════════════════════════════════
          // STEPPER (using AppStepper component)
          // ═══════════════════════════════════════════════════════════════════
          const _SectionTitle('Stepper'),
          const AppStepper(
            currentStep: 1,
            steps: [
              AppStep(title: 'Account'),
              AppStep(title: 'Profile'),
              AppStep(title: 'Complete'),
            ],
          ),
          AppSpacing.verticalLg,
          Text('Vertical:', style: AppTypography.labelMedium),
          AppSpacing.verticalXs,
          const AppStepper(
            currentStep: 1,
            orientation: Axis.vertical,
            steps: [
              AppStep(title: 'Account', subtitle: 'Create your account'),
              AppStep(title: 'Profile', subtitle: 'Set up your profile'),
              AppStep(title: 'Complete', subtitle: 'Finish setup'),
            ],
          ),
          AppSpacing.verticalXxl,

          // ═══════════════════════════════════════════════════════════════════
          // EXPANSION PANEL (using AppExpansionTile component)
          // ═══════════════════════════════════════════════════════════════════
          const _SectionTitle('Expansion Panels'),
          AppExpansionTile(
            title: 'How do I reset my password?',
            leadingIcon: Icons.help_outline,
            content: Text(
              'You can reset your password by going to Settings > Account > Change Password.',
              style: AppTypography.bodyMedium,
            ),
          ),
          AppExpansionTile(
            title: 'How do I contact support?',
            leadingIcon: Icons.support_agent,
            initiallyExpanded: true,
            content: Text(
              'You can contact our support team via email at support@example.com or call us at 1-800-SUPPORT.',
              style: AppTypography.bodyMedium,
            ),
          ),
          AppExpansionTile(
            title: 'What payment methods are accepted?',
            leadingIcon: Icons.payment,
            content: Text(
              'We accept Visa, Mastercard, American Express, PayPal, and Apple Pay.',
              style: AppTypography.bodyMedium,
            ),
          ),
          AppSpacing.verticalXxl,
        ],
      ),
    );
  }
}

// ============================================
// FEEDBACK TAB
// ============================================
class _FeedbackTab extends StatelessWidget {
  final DesignShowcaseViewModel viewModel;

  const _FeedbackTab({required this.viewModel});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: AppSpacing.screenPadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ═══════════════════════════════════════════════════════════════════
          // DIALOGS (using AppDialog component)
          // ═══════════════════════════════════════════════════════════════════
          const _SectionTitle('Dialogs'),
          Wrap(
            spacing: AppSpacing.xs,
            runSpacing: AppSpacing.xs,
            children: [
              AppButton.primary(
                label: 'Alert Dialog',
                onPressed: () => AppDialog.alert(
                  context: context,
                  title: 'Alert',
                  message: 'This is a simple alert dialog message.',
                ),
                isFullWidth: false,
                size: AppButtonSize.small,
              ),
              AppButton.outline(
                label: 'Confirm Dialog',
                onPressed: () async {
                  final confirmed = await AppDialog.confirm(
                    context: context,
                    title: 'Confirm Action',
                    message:
                        'Are you sure you want to proceed with this action?',
                  );
                  if (confirmed == true && context.mounted) {
                    AppSnackbar.info(context, 'Action confirmed!');
                  }
                },
                isFullWidth: false,
                size: AppButtonSize.small,
              ),
              AppButton.outline(
                label: 'Success Dialog',
                onPressed: () => AppDialog.success(
                  context: context,
                  title: 'Success!',
                  message: 'Your action has been completed successfully.',
                ),
                isFullWidth: false,
                size: AppButtonSize.small,
              ),
              AppButton.outline(
                label: 'Error Dialog',
                onPressed: () => AppDialog.error(
                  context: context,
                  title: 'Error',
                  message: 'Something went wrong. Please try again.',
                ),
                isFullWidth: false,
                size: AppButtonSize.small,
              ),
            ],
          ),
          AppSpacing.verticalXxl,

          // ═══════════════════════════════════════════════════════════════════
          // BOTTOM SHEETS (using AppBottomSheet component)
          // ═══════════════════════════════════════════════════════════════════
          const _SectionTitle('Bottom Sheets'),
          Wrap(
            spacing: AppSpacing.xs,
            runSpacing: AppSpacing.xs,
            children: [
              AppButton.primary(
                label: 'Modal Sheet',
                onPressed: () => AppBottomSheet.show(
                  context: context,
                  title: 'Modal Bottom Sheet',
                  subtitle: 'This is a styled bottom sheet',
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'This is a modal bottom sheet using AppBottomSheet component.',
                        style: AppTypography.bodyMedium,
                      ),
                      AppSpacing.verticalLg,
                      AppButton.primary(
                        label: 'Close',
                        onPressed: () => Navigator.pop(context),
                      ),
                    ],
                  ),
                ),
                isFullWidth: false,
                size: AppButtonSize.small,
              ),
              AppButton.outline(
                label: 'Action Sheet',
                onPressed: () => AppBottomSheet.showActions(
                  context: context,
                  title: 'Choose Action',
                  subtitle: 'Select an option below',
                  actions: [
                    const AppSheetAction(label: 'Share', icon: Icons.share),
                    const AppSheetAction(label: 'Copy Link', icon: Icons.link),
                    const AppSheetAction(label: 'Edit', icon: Icons.edit),
                    const AppSheetAction(
                      label: 'Delete',
                      icon: Icons.delete,
                      isDestructive: true,
                    ),
                  ],
                ),
                isFullWidth: false,
                size: AppButtonSize.small,
              ),
              AppButton.outline(
                label: 'Draggable Sheet',
                onPressed: () => AppBottomSheet.showDraggable(
                  context: context,
                  initialChildSize: 0.5,
                  builder: (context, scrollController) => ListView(
                    controller: scrollController,
                    padding: EdgeInsets.symmetric(horizontal: 24.w),
                    children: [
                      AppSpacing.verticalXs,
                      Text('Draggable Sheet', style: AppTypography.titleLarge),
                      AppSpacing.verticalXs,
                      Text(
                        'Drag up or down to resize. Scroll content inside.',
                        style: AppTypography.bodyMedium,
                      ),
                      AppSpacing.verticalMd,
                      ...List.generate(
                        15,
                        (i) => AppListTile(
                          leading: AppAvatar.small(name: '${i + 1}'),
                          title: 'Item ${i + 1}',
                          subtitle: 'Subtitle text',
                        ),
                      ),
                    ],
                  ),
                ),
                isFullWidth: false,
                size: AppButtonSize.small,
              ),
            ],
          ),
          AppSpacing.verticalXxl,

          // ═══════════════════════════════════════════════════════════════════
          // SNACKBARS (using AppSnackbar component)
          // ═══════════════════════════════════════════════════════════════════
          const _SectionTitle('Snackbars / Toasts'),
          Wrap(
            spacing: AppSpacing.xs,
            runSpacing: AppSpacing.xs,
            children: [
              AppButton.primary(
                label: 'Default',
                onPressed: () => AppSnackbar.show(
                  context: context,
                  message: 'This is a neutral snackbar message.',
                  action: AppSnackbarAction(
                    label: 'Undo',
                    onPressed: () {},
                  ),
                ),
                isFullWidth: false,
                size: AppButtonSize.small,
              ),
              AppButton.outline(
                label: 'Success',
                onPressed: () => AppSnackbar.success(
                  context,
                  'Action completed successfully!',
                ),
                isFullWidth: false,
                size: AppButtonSize.small,
              ),
              AppButton.outline(
                label: 'Error',
                onPressed: () => AppSnackbar.error(
                  context,
                  'Something went wrong. Please try again.',
                ),
                isFullWidth: false,
                size: AppButtonSize.small,
              ),
              AppButton.outline(
                label: 'Warning',
                onPressed: () => AppSnackbar.warning(
                  context,
                  'Please review your input.',
                ),
                isFullWidth: false,
                size: AppButtonSize.small,
              ),
              AppButton.outline(
                label: 'Info',
                onPressed: () => AppSnackbar.info(
                  context,
                  'Here is some information for you.',
                ),
                isFullWidth: false,
                size: AppButtonSize.small,
              ),
            ],
          ),
          AppSpacing.verticalXxl,

          // ═══════════════════════════════════════════════════════════════════
          // BANNERS (using AppBanner component)
          // ═══════════════════════════════════════════════════════════════════
          const _SectionTitle('Banners'),
          const AppBanner(
            title: 'Information',
            message: 'This is an informational message for the user.',
            variant: AppBannerVariant.info,
          ),
          AppSpacing.verticalSm,
          const AppBanner(
            title: 'Success',
            message: 'Your changes have been saved successfully.',
            variant: AppBannerVariant.success,
          ),
          AppSpacing.verticalSm,
          AppBanner(
            title: 'Warning',
            message: 'Please review before proceeding.',
            variant: AppBannerVariant.warning,
            isDismissible: true,
            onDismiss: () {},
          ),
          AppSpacing.verticalSm,
          AppBanner(
            title: 'Error',
            message: 'Something went wrong. Please try again.',
            variant: AppBannerVariant.error,
            action: AppBannerAction(
              label: 'Retry',
              onPressed: () {},
            ),
          ),
          AppSpacing.verticalXxl,

          // ═══════════════════════════════════════════════════════════════════
          // PROGRESS INDICATORS
          // ═══════════════════════════════════════════════════════════════════
          const _SectionTitle('Progress Indicators'),
          const AppLinearProgress(
            value: 0.7,
            label: 'Upload progress',
            showPercentage: true,
          ),
          AppSpacing.verticalMd,
          const AppLinearProgress.indeterminate(
            label: 'Loading...',
          ),
          AppSpacing.verticalLg,
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Column(
                children: [
                  const AppCircularProgress.indeterminate(
                    size: AppProgressSize.large,
                  ),
                  AppSpacing.verticalXs,
                  Text('Indeterminate', style: AppTypography.caption),
                ],
              ),
              Column(
                children: [
                  const AppCircularProgress(
                    value: 0.75,
                    size: AppProgressSize.large,
                  ),
                  AppSpacing.verticalXs,
                  Text('75%', style: AppTypography.caption),
                ],
              ),
              Column(
                children: [
                  const AppCircularProgress(
                    value: 0.45,
                    size: AppProgressSize.large,
                    showPercentage: true,
                  ),
                  AppSpacing.verticalXs,
                  Text('With label', style: AppTypography.caption),
                ],
              ),
            ],
          ),
          AppSpacing.verticalXxl,

          // ═══════════════════════════════════════════════════════════════════
          // TOOLTIPS
          // ═══════════════════════════════════════════════════════════════════
          const _SectionTitle('Tooltips'),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              AppTooltip(
                message: 'Add new item',
                child: IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.add_circle_outline),
                ),
              ),
              AppTooltip(
                message: 'Edit settings',
                child: IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.settings_outlined),
                ),
              ),
              AppTooltip(
                message: 'Delete item',
                child: IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.delete_outline),
                ),
              ),
            ],
          ),
          AppSpacing.verticalXxl,

          // ═══════════════════════════════════════════════════════════════════
          // EMPTY STATES
          // ═══════════════════════════════════════════════════════════════════
          const _SectionTitle('Empty State'),
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: AppColors.surfaceSecondaryLight,
              borderRadius: AppRadius.card,
            ),
            child: AppEmptyState(
              icon: Icons.inbox_outlined,
              title: 'No items yet',
              description: 'Items you add will appear here.',
              actionLabel: 'Add Item',
              onAction: () {},
            ),
          ),
          AppSpacing.verticalXxl,
        ],
      ),
    );
  }
}

// ============================================
// NAVIGATION TAB
// ============================================
class _NavigationTab extends StatefulWidget {
  @override
  State<_NavigationTab> createState() => _NavigationTabState();
}

class _NavigationTabState extends State<_NavigationTab> {
  int _bottomNavIndex = 0;
  int _navBarIndex = 0;
  int _navRailIndex = 0;
  bool _isDrawerOpen = false;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: AppSpacing.screenPadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ═══════════════════════════════════════════════════════════════════
          // APP BAR VARIANTS
          // ═══════════════════════════════════════════════════════════════════
          const _SectionTitle('App Bar Variants'),
          Text('Standard', style: AppTypography.labelMedium),
          AppSpacing.verticalXs,
          Container(
            decoration: BoxDecoration(
              border: Border.all(color: AppColors.contrastLowLight),
              borderRadius: AppRadius.card,
            ),
            clipBehavior: Clip.hardEdge,
            child: AppBar(
              title: const Text('Page Title'),
              leading: IconButton(
                  onPressed: () {}, icon: const Icon(Icons.arrow_back)),
              actions: [
                IconButton(onPressed: () {}, icon: const Icon(Icons.search)),
                IconButton(onPressed: () {}, icon: const Icon(Icons.more_vert)),
              ],
            ),
          ),
          AppSpacing.verticalMd,
          Text('With Logo', style: AppTypography.labelMedium),
          AppSpacing.verticalXs,
          Container(
            decoration: BoxDecoration(
              border: Border.all(color: AppColors.contrastLowLight),
              borderRadius: AppRadius.card,
            ),
            clipBehavior: Clip.hardEdge,
            child: AppBar(
              title: Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(6.w),
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: AppRadius.xs,
                    ),
                    child:
                        Icon(Icons.bolt, color: AppColors.white, size: 18.sp),
                  ),
                  AppSpacing.horizontalSm,
                  const Text('Brand'),
                ],
              ),
              actions: [
                IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.notifications_outlined)),
                AppSpacing.horizontalXs,
                const AppAvatar.small(name: 'JD'),
                AppSpacing.horizontalSm,
              ],
            ),
          ),
          AppSpacing.verticalMd,
          Text('Search Bar', style: AppTypography.labelMedium),
          AppSpacing.verticalXs,
          Container(
            decoration: BoxDecoration(
              border: Border.all(color: AppColors.contrastLowLight),
              borderRadius: AppRadius.card,
            ),
            clipBehavior: Clip.hardEdge,
            child: AppBar(
              title: Container(
                height: 40.h,
                decoration: BoxDecoration(
                  color: AppColors.surfaceSecondaryLight,
                  borderRadius: AppRadius.input,
                ),
                child: TextField(
                  decoration: InputDecoration(
                    hintText: 'Search...',
                    prefixIcon: const Icon(Icons.search),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(vertical: 8.h),
                  ),
                ),
              ),
              actions: [
                IconButton(onPressed: () {}, icon: const Icon(Icons.tune)),
              ],
            ),
          ),
          AppSpacing.verticalXxl,

          // ═══════════════════════════════════════════════════════════════════
          // BOTTOM NAVIGATION BAR
          // ═══════════════════════════════════════════════════════════════════
          const _SectionTitle('Bottom Navigation Bar'),
          Container(
            decoration: BoxDecoration(
              border: Border.all(color: AppColors.contrastLowLight),
              borderRadius: AppRadius.card,
            ),
            clipBehavior: Clip.hardEdge,
            child: AppBottomNav(
              currentIndex: _bottomNavIndex,
              onTap: (i) => setState(() => _bottomNavIndex = i),
              items: const [
                AppBottomNavItem(
                    icon: Icons.home_outlined,
                    selectedIcon: Icons.home,
                    label: 'Home'),
                AppBottomNavItem(
                    icon: Icons.search_outlined,
                    selectedIcon: Icons.search,
                    label: 'Search'),
                AppBottomNavItem(
                    icon: Icons.favorite_outline,
                    selectedIcon: Icons.favorite,
                    label: 'Favorites'),
                AppBottomNavItem(
                    icon: Icons.person_outline,
                    selectedIcon: Icons.person,
                    label: 'Profile'),
              ],
            ),
          ),
          AppSpacing.verticalXxl,

          // ═══════════════════════════════════════════════════════════════════
          // NAVIGATION BAR (Material 3)
          // ═══════════════════════════════════════════════════════════════════
          const _SectionTitle('Navigation Bar (M3)'),
          Container(
            decoration: BoxDecoration(
              border: Border.all(color: AppColors.contrastLowLight),
              borderRadius: AppRadius.card,
            ),
            clipBehavior: Clip.hardEdge,
            child: AppNavigationBar(
              selectedIndex: _navBarIndex,
              onDestinationSelected: (i) => setState(() => _navBarIndex = i),
              destinations: const [
                AppNavDestination(
                    icon: Icons.home_outlined,
                    selectedIcon: Icons.home,
                    label: 'Home'),
                AppNavDestination(
                    icon: Icons.explore_outlined,
                    selectedIcon: Icons.explore,
                    label: 'Explore'),
                AppNavDestination(
                    icon: Icons.bookmark_outline,
                    selectedIcon: Icons.bookmark,
                    label: 'Saved'),
                AppNavDestination(
                    icon: Icons.person_outline,
                    selectedIcon: Icons.person,
                    label: 'Profile'),
              ],
            ),
          ),
          AppSpacing.verticalXxl,

          // ═══════════════════════════════════════════════════════════════════
          // NAVIGATION RAIL
          // ═══════════════════════════════════════════════════════════════════
          const _SectionTitle('Navigation Rail (Desktop)'),
          Container(
            height: 280.h,
            decoration: BoxDecoration(
              border: Border.all(color: AppColors.contrastLowLight),
              borderRadius: AppRadius.card,
            ),
            clipBehavior: Clip.hardEdge,
            child: Row(
              children: [
                AppNavigationRail(
                  selectedIndex: _navRailIndex,
                  onDestinationSelected: (i) =>
                      setState(() => _navRailIndex = i),
                  labelType: NavigationRailLabelType.selected,
                  leading: AppFab.small(
                    icon: Icons.add,
                    onPressed: () {},
                    heroTag: 'nav_rail_fab',
                  ),
                  destinations: const [
                    AppRailDestination(
                        icon: Icons.home_outlined,
                        selectedIcon: Icons.home,
                        label: 'Home'),
                    AppRailDestination(
                        icon: Icons.analytics_outlined,
                        selectedIcon: Icons.analytics,
                        label: 'Analytics'),
                    AppRailDestination(
                        icon: Icons.settings_outlined,
                        selectedIcon: Icons.settings,
                        label: 'Settings'),
                  ],
                ),
                const AppVerticalDivider(height: double.infinity),
                Expanded(
                  child: Center(
                    child: Text(
                      'Content Area',
                      style: AppTypography.bodyMedium
                          .copyWith(color: AppColors.textSecondaryLight),
                    ),
                  ),
                ),
              ],
            ),
          ),
          AppSpacing.verticalXxl,

          // ═══════════════════════════════════════════════════════════════════
          // DRAWER PREVIEW
          // ═══════════════════════════════════════════════════════════════════
          const _SectionTitle('Drawer Preview'),
          AppButton.secondary(
            label: _isDrawerOpen ? 'Hide Drawer' : 'Show Drawer Preview',
            leftIcon: Icons.menu,
            onPressed: () => setState(() => _isDrawerOpen = !_isDrawerOpen),
            isFullWidth: false,
          ),
          if (_isDrawerOpen) ...[
            AppSpacing.verticalMd,
            Container(
              width: 280.w,
              decoration: BoxDecoration(
                color: AppColors.surfaceLight,
                borderRadius: AppRadius.card,
                border: Border.all(color: AppColors.contrastLowLight),
                boxShadow: AppShadows.lg,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: EdgeInsets.all(20.w),
                    decoration: BoxDecoration(
                      color: AppColors.contrastHighLight,
                      borderRadius:
                          BorderRadius.vertical(top: Radius.circular(8.r)),
                    ),
                    child: Row(
                      children: [
                        const AppAvatar.large(name: 'JD'),
                        AppSpacing.horizontalSm,
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('John Doe',
                                style: AppTypography.titleSmall
                                    .copyWith(color: AppColors.white)),
                            Text('john@example.com',
                                style: AppTypography.bodySmall.copyWith(
                                    color: AppColors.contrastMediumDark)),
                          ],
                        ),
                      ],
                    ),
                  ),
                  AppDrawerItem(
                    icon: Icons.home,
                    label: 'Home',
                    isSelected: true,
                    onTap: () {},
                  ),
                  AppDrawerItem(
                    icon: Icons.person,
                    label: 'Profile',
                    onTap: () {},
                  ),
                  AppDrawerItem(
                    icon: Icons.settings,
                    label: 'Settings',
                    onTap: () {},
                  ),
                  const AppDivider(),
                  AppDrawerItem(
                    icon: Icons.help_outline,
                    label: 'Help',
                    onTap: () {},
                  ),
                  AppDrawerItem(
                    icon: Icons.logout,
                    label: 'Logout',
                    onTap: () {},
                  ),
                ],
              ),
            ),
          ],
          AppSpacing.verticalXxl,

          // ═══════════════════════════════════════════════════════════════════
          // TABS
          // ═══════════════════════════════════════════════════════════════════
          const _SectionTitle('Tab Bar'),
          DefaultTabController(
            length: 3,
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(color: AppColors.contrastLowLight),
                borderRadius: AppRadius.card,
              ),
              clipBehavior: Clip.hardEdge,
              child: Column(
                children: [
                  const TabBar(
                    tabs: [
                      Tab(text: 'Overview'),
                      Tab(text: 'Analytics'),
                      Tab(text: 'Reports'),
                    ],
                  ),
                  SizedBox(
                    height: 100.h,
                    child: const TabBarView(
                      children: [
                        Center(child: Text('Overview Content')),
                        Center(child: Text('Analytics Content')),
                        Center(child: Text('Reports Content')),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          AppSpacing.verticalXxl,

          // ═══════════════════════════════════════════════════════════════════
          // FAB VARIANTS
          // ═══════════════════════════════════════════════════════════════════
          const _SectionTitle('Floating Action Buttons'),
          Wrap(
            spacing: 16.w,
            runSpacing: 16.h,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              AppFab.small(
                heroTag: 'fab1',
                onPressed: () {},
                icon: Icons.add,
              ),
              AppFab(
                heroTag: 'fab2',
                onPressed: () {},
                icon: Icons.add,
              ),
              AppFab.large(
                heroTag: 'fab3',
                onPressed: () {},
                icon: Icons.add,
              ),
              AppFabExtended(
                heroTag: 'fab4',
                onPressed: () {},
                icon: Icons.add,
                label: 'Create',
              ),
            ],
          ),
          AppSpacing.verticalXxl,

          // ═══════════════════════════════════════════════════════════════════
          // STEPPER
          // ═══════════════════════════════════════════════════════════════════
          const _SectionTitle('Stepper'),
          _StepperDemo(),
          AppSpacing.verticalXxl,

          // ═══════════════════════════════════════════════════════════════════
          // EXPANSION PANELS
          // ═══════════════════════════════════════════════════════════════════
          const _SectionTitle('Expansion Panels'),
          _ExpansionDemo(),
          AppSpacing.verticalXxl,
        ],
      ),
    );
  }
}

class _StepperDemo extends StatefulWidget {
  @override
  State<_StepperDemo> createState() => _StepperDemoState();
}

class _StepperDemoState extends State<_StepperDemo> {
  int _currentStep = 1;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Horizontal stepper (using design system)
        Text('Horizontal Stepper', style: AppTypography.labelMedium),
        AppSpacing.verticalSm,
        AppStepper(
          currentStep: _currentStep,
          steps: const [
            AppStep(title: 'Account', subtitle: 'Create account'),
            AppStep(title: 'Address', subtitle: 'Shipping info'),
            AppStep(title: 'Payment', subtitle: 'Pay securely'),
          ],
          onStepTapped: (step) => setState(() => _currentStep = step),
        ),
        AppSpacing.verticalLg,

        // Vertical stepper (using design system)
        Text('Vertical Stepper', style: AppTypography.labelMedium),
        AppSpacing.verticalSm,
        AppStepper(
          currentStep: _currentStep,
          orientation: Axis.vertical,
          steps: const [
            AppStep(title: 'Account', subtitle: 'Create your account'),
            AppStep(title: 'Address', subtitle: 'Enter shipping address'),
            AppStep(title: 'Payment', subtitle: 'Select payment method'),
          ],
          onStepTapped: (step) => setState(() => _currentStep = step),
        ),
      ],
    );
  }
}

class _ExpansionDemo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AppExpansionPanel(
      children: [
        AppExpansionTile(
          title: 'What is your return policy?',
          leadingIcon: Icons.help_outline,
          content: Padding(
            padding: EdgeInsets.all(16.w),
            child: Text(
              'You can return any item within 30 days of purchase for a full refund. Items must be in original condition.',
              style: AppTypography.bodyMedium,
            ),
          ),
        ),
        AppExpansionTile(
          title: 'How long does shipping take?',
          leadingIcon: Icons.local_shipping_outlined,
          content: Padding(
            padding: EdgeInsets.all(16.w),
            child: Text(
              'Standard shipping takes 5-7 business days. Express shipping is available for 2-3 day delivery.',
              style: AppTypography.bodyMedium,
            ),
          ),
        ),
        AppExpansionTile(
          title: 'Do you ship internationally?',
          leadingIcon: Icons.public,
          content: Padding(
            padding: EdgeInsets.all(16.w),
            child: Text(
              'Yes, we ship to over 100 countries worldwide. International shipping rates vary by location.',
              style: AppTypography.bodyMedium,
            ),
          ),
        ),
      ],
    );
  }
}

// ============================================
// HELPERS
// ============================================
class _SectionTitle extends StatelessWidget {
  final String title;

  const _SectionTitle(this.title);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 16.h),
      child: Text(
        title,
        style: AppTypography.titleLarge.copyWith(
          color: AppColors.primary,
        ),
      ),
    );
  }
}
