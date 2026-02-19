import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../tokens/app_colors.dart';
import '../tokens/app_spacing.dart';
import '../tokens/app_typography.dart';

/// Avatar sizes.
enum AppAvatarSize {
  /// Small - 32dp.
  small,

  /// Medium - 40dp (default).
  medium,

  /// Large - 56dp.
  large,

  /// Extra large - 80dp.
  extraLarge,
}

/// A customizable avatar component.
///
/// Example:
/// ```dart
/// AppAvatar(
///   imageUrl: 'https://example.com/avatar.jpg',
///   name: 'John Doe',
/// )
/// ```
class AppAvatar extends StatelessWidget {
  /// Image URL.
  final String? imageUrl;

  /// Fallback name for initials.
  final String? name;

  /// Avatar size.
  final AppAvatarSize size;

  /// Custom background color.
  final Color? backgroundColor;

  /// Whether the avatar has a border.
  final bool hasBorder;

  /// Border color.
  final Color? borderColor;

  /// Whether the avatar is online (shows indicator).
  final bool isOnline;

  /// Creates an [AppAvatar].
  const AppAvatar({
    super.key,
    this.imageUrl,
    this.name,
    this.size = AppAvatarSize.medium,
    this.backgroundColor,
    this.hasBorder = false,
    this.borderColor,
    this.isOnline = false,
  });

  /// Creates a small avatar.
  const AppAvatar.small({
    super.key,
    this.imageUrl,
    this.name,
    this.backgroundColor,
    this.hasBorder = false,
    this.borderColor,
    this.isOnline = false,
  }) : size = AppAvatarSize.small;

  /// Creates a large avatar.
  const AppAvatar.large({
    super.key,
    this.imageUrl,
    this.name,
    this.backgroundColor,
    this.hasBorder = false,
    this.borderColor,
    this.isOnline = false,
  }) : size = AppAvatarSize.large;

  @override
  Widget build(BuildContext context) {
    final avatarSize = _getSize();
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Stack(
      children: [
        Container(
          width: avatarSize,
          height: avatarSize,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: backgroundColor ?? _getBackgroundColor(isDark),
            border: hasBorder
                ? Border.all(
                    color: borderColor ?? AppColors.white,
                    width: 2,
                  )
                : null,
            image: imageUrl != null
                ? DecorationImage(
                    image: NetworkImage(imageUrl!),
                    fit: BoxFit.cover,
                  )
                : null,
          ),
          child: imageUrl == null ? _buildInitials() : null,
        ),
        if (isOnline) _buildOnlineIndicator(avatarSize),
      ],
    );
  }

  double _getSize() {
    switch (size) {
      case AppAvatarSize.small:
        return AppSpacing.avatarSm;
      case AppAvatarSize.medium:
        return AppSpacing.avatarMd;
      case AppAvatarSize.large:
        return AppSpacing.avatarLg;
      case AppAvatarSize.extraLarge:
        return AppSpacing.avatarXl;
    }
  }

  Color _getBackgroundColor(bool isDark) {
    if (name == null || name!.isEmpty) {
      return isDark ? AppColors.contrastLowDark : AppColors.contrastLowLight;
    }

    // Generate a consistent color based on name
    final colors = [
      AppColors.primary,
      AppColors.info,
      AppColors.warning,
      AppColors.success,
      AppColors.contrastMediumLight,
    ];
    final index = name!.hashCode.abs() % colors.length;
    return colors[index];
  }

  Widget _buildInitials() {
    final initials = _getInitials();
    final fontSize = _getFontSize();

    return Center(
      child: Text(
        initials,
        style: TextStyle(
          color: AppColors.white,
          fontSize: fontSize,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  String _getInitials() {
    if (name == null || name!.isEmpty) return '?';

    final parts = name!.trim().split(' ');
    if (parts.length >= 2) {
      return '${parts.first[0]}${parts.last[0]}'.toUpperCase();
    }
    return parts.first[0].toUpperCase();
  }

  double _getFontSize() {
    switch (size) {
      case AppAvatarSize.small:
        return 12.sp;
      case AppAvatarSize.medium:
        return 14.sp;
      case AppAvatarSize.large:
        return 18.sp;
      case AppAvatarSize.extraLarge:
        return 24.sp;
    }
  }

  Widget _buildOnlineIndicator(double avatarSize) {
    final indicatorSize = avatarSize * 0.25;
    final offset = avatarSize * 0.05;

    return Positioned(
      right: offset,
      bottom: offset,
      child: Container(
        width: indicatorSize,
        height: indicatorSize,
        decoration: BoxDecoration(
          color: AppColors.success,
          shape: BoxShape.circle,
          border: Border.all(
            color: AppColors.white,
            width: 2,
          ),
        ),
      ),
    );
  }
}

/// Avatar group for showing multiple avatars.
class AppAvatarGroup extends StatelessWidget {
  /// List of image URLs or names.
  final List<AvatarData> avatars;

  /// Maximum number of visible avatars.
  final int maxVisible;

  /// Avatar size.
  final AppAvatarSize size;

  /// Creates an [AppAvatarGroup].
  const AppAvatarGroup({
    super.key,
    required this.avatars,
    this.maxVisible = 4,
    this.size = AppAvatarSize.small,
  });

  @override
  Widget build(BuildContext context) {
    final visibleCount = avatars.length.clamp(0, maxVisible);
    final remaining = avatars.length - visibleCount;
    final avatarSize = _getSize();
    final overlap = avatarSize * 0.3;

    return SizedBox(
      width: avatarSize +
          (visibleCount - 1) * (avatarSize - overlap) +
          (remaining > 0 ? avatarSize - overlap : 0),
      height: avatarSize,
      child: Stack(
        children: [
          for (int i = 0; i < visibleCount; i++)
            Positioned(
              left: i * (avatarSize - overlap),
              child: AppAvatar(
                imageUrl: avatars[i].imageUrl,
                name: avatars[i].name,
                size: size,
                hasBorder: true,
              ),
            ),
          if (remaining > 0)
            Positioned(
              left: visibleCount * (avatarSize - overlap),
              child: Container(
                width: avatarSize,
                height: avatarSize,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.contrastLowLight,
                  border: Border.all(color: AppColors.white, width: 2),
                ),
                child: Center(
                  child: Text(
                    '+$remaining',
                    style: AppTypography.labelSmall.copyWith(
                      color: AppColors.textSecondaryLight,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  double _getSize() {
    switch (size) {
      case AppAvatarSize.small:
        return AppSpacing.avatarSm;
      case AppAvatarSize.medium:
        return AppSpacing.avatarMd;
      case AppAvatarSize.large:
        return AppSpacing.avatarLg;
      case AppAvatarSize.extraLarge:
        return AppSpacing.avatarXl;
    }
  }
}

/// Data for an avatar.
class AvatarData {
  /// Image URL.
  final String? imageUrl;

  /// Name for fallback initials.
  final String? name;

  /// Creates an [AvatarData].
  const AvatarData({this.imageUrl, this.name});
}
