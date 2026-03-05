import 'package:flutter/material.dart';

import '../../../core/extensions/context_extensions.dart';
import '../../../design_system/design_system.dart';

/// Default domain option displayed during onboarding.
class _DefaultDomain {
  final String name;
  final String icon;
  final String colorHex;
  bool selected = true;

  _DefaultDomain({
    required this.name,
    required this.icon,
    required this.colorHex,
  });

  Color get color =>
      Color(int.parse('FF${colorHex.replaceFirst('#', '')}', radix: 16));
}

/// Domain selection step for the onboarding flow.
///
/// Displays the 5 default life domains with checkboxes.
/// The user can toggle on/off. At least one must be selected.
class OnboardingDomainStep extends StatefulWidget {
  /// Callback with the list of selected domain names when confirmed.
  final ValueChanged<List<Map<String, String>>> onDomainsSelected;

  const OnboardingDomainStep({
    super.key,
    required this.onDomainsSelected,
  });

  @override
  State<OnboardingDomainStep> createState() => _OnboardingDomainStepState();
}

class _OnboardingDomainStepState extends State<OnboardingDomainStep> {
  late final List<_DefaultDomain> _domains;
  bool _initialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_initialized) {
      final l10n = context.l10n;
      _domains = [
        _DefaultDomain(
            name: l10n.defaultDomainHealth, icon: '💪', colorHex: '#4CAF50'),
        _DefaultDomain(
            name: l10n.defaultDomainWork, icon: '💼', colorHex: '#2196F3'),
        _DefaultDomain(
            name: l10n.defaultDomainRelationships,
            icon: '❤️',
            colorHex: '#E91E63'),
        _DefaultDomain(
            name: l10n.defaultDomainFinances, icon: '💰', colorHex: '#FF9800'),
        _DefaultDomain(
            name: l10n.defaultDomainPersonalDev,
            icon: '🌱',
            colorHex: '#9C27B0'),
      ];
      _initialized = true;
    }
  }

  int get _selectedCount => _domains.where((d) => d.selected).length;
  bool get _isValid => _selectedCount >= 1;

  void _toggle(int index) {
    setState(() {
      _domains[index].selected = !_domains[index].selected;
    });
  }

  void _confirm() {
    if (!_isValid) return;
    final selected = _domains
        .where((d) => d.selected)
        .map((d) => {
              'name': d.name,
              'icon': d.icon,
              'color': d.colorHex,
            })
        .toList();
    widget.onDomainsSelected(selected);
  }

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    final l10n = context.l10n;

    return Padding(
      padding: EdgeInsets.all(AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: AppSpacing.xl),
          Text(
            l10n.onboardingDomainsTitle,
            style: AppTypography.headlineSmall.copyWith(
              color: AppColors.textPrimary(brightness),
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: AppSpacing.sm),
          Text(
            l10n.onboardingDomainsDescription,
            style: AppTypography.textMedium.copyWith(
              color: AppColors.textSecondary(brightness),
            ),
          ),
          SizedBox(height: AppSpacing.xl),

          // Domain list
          Expanded(
            child: ListView.separated(
              itemCount: _domains.length,
              separatorBuilder: (_, __) => SizedBox(height: AppSpacing.sm),
              itemBuilder: (context, index) {
                final domain = _domains[index];
                return AppCard.outlined(
                  onTap: () => _toggle(index),
                  padding: EdgeInsets.symmetric(
                    horizontal: AppSpacing.md,
                    vertical: AppSpacing.sm,
                  ),
                  child: Row(
                    children: [
                      Text(domain.icon, style: TextStyle(fontSize: 28)),
                      SizedBox(width: AppSpacing.md),
                      Expanded(
                        child: Text(
                          domain.name,
                          style: AppTypography.titleSmall.copyWith(
                            color: AppColors.textPrimary(brightness),
                          ),
                        ),
                      ),
                      Checkbox(
                        value: domain.selected,
                        onChanged: (_) => _toggle(index),
                        activeColor: domain.color,
                      ),
                    ],
                  ),
                );
              },
            ),
          ),

          // Minimum warning
          if (!_isValid)
            Padding(
              padding: EdgeInsets.only(bottom: AppSpacing.sm),
              child: Text(
                l10n.onboardingDomainsMinimum,
                style: AppTypography.labelSmall.copyWith(
                  color: AppColors.error,
                ),
              ),
            ),

          // Confirm button
          AppButton.primary(
            label: l10n.next,
            isFullWidth: true,
            onPressed: _isValid ? _confirm : null,
          ),
          SizedBox(height: AppSpacing.md),
        ],
      ),
    );
  }
}
