import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../tokens/app_colors.dart';
import '../tokens/app_radius.dart';
import '../tokens/app_shadows.dart';
import '../tokens/app_typography.dart';
import 'app_button.dart';

/// A hero card with image background and overlay content.
///
/// Example:
/// ```dart
/// AppHeroCard(
///   imageUrl: 'https://example.com/image.jpg',
///   title: 'Welcome Back',
///   subtitle: 'Continue your journey',
///   actionLabel: 'Get Started',
///   onAction: () {},
/// )
/// ```
class AppHeroCard extends StatelessWidget {
  /// Background image URL.
  final String? imageUrl;

  /// Background asset image path.
  final String? assetImage;

  /// Custom background widget.
  final Widget? background;

  /// Hero title.
  final String title;

  /// Hero subtitle.
  final String? subtitle;

  /// Primary action label.
  final String? actionLabel;

  /// Primary action callback.
  final VoidCallback? onAction;

  /// Card height.
  final double? height;

  /// Gradient overlay colors.
  final List<Color>? gradientColors;

  /// Content alignment.
  final Alignment contentAlignment;

  /// Border radius.
  final BorderRadius? borderRadius;

  /// Creates an [AppHeroCard].
  const AppHeroCard({
    super.key,
    this.imageUrl,
    this.assetImage,
    this.background,
    required this.title,
    this.subtitle,
    this.actionLabel,
    this.onAction,
    this.height,
    this.gradientColors,
    this.contentAlignment = Alignment.bottomLeft,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height ?? 200.h,
      decoration: BoxDecoration(
        borderRadius: borderRadius ?? AppRadius.card,
        boxShadow: AppShadows.md,
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        fit: StackFit.expand,
        children: [
          // Background
          _buildBackground(),

          // Gradient overlay
          _buildGradient(),

          // Content
          _buildContent(),
        ],
      ),
    );
  }

  Widget _buildBackground() {
    if (background != null) return background!;

    if (assetImage != null) {
      return Image.asset(
        assetImage!,
        fit: BoxFit.cover,
      );
    }

    if (imageUrl != null) {
      return Image.network(
        imageUrl!,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => _buildPlaceholder(),
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return _buildPlaceholder();
        },
      );
    }

    return _buildPlaceholder();
  }

  Widget _buildPlaceholder() {
    return Container(
      color: AppColors.contrastHighLight,
      child: Icon(
        Icons.image_outlined,
        size: 48.sp,
        color: AppColors.contrastMediumLight,
      ),
    );
  }

  Widget _buildGradient() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: gradientColors ??
              [
                AppColors.black.withValues(alpha: 0.0),
                AppColors.black.withValues(alpha: 0.7),
              ],
        ),
      ),
    );
  }

  Widget _buildContent() {
    return Align(
      alignment: contentAlignment,
      child: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: _getCrossAxisAlignment(),
          children: [
            Text(
              title,
              style: AppTypography.headlineSmall.copyWith(
                color: AppColors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            if (subtitle != null) ...[
              SizedBox(height: 4.h),
              Text(
                subtitle!,
                style: AppTypography.bodyMedium.copyWith(
                  color: AppColors.white.withValues(alpha: 0.85),
                ),
              ),
            ],
            if (actionLabel != null && onAction != null) ...[
              SizedBox(height: 12.h),
              AppButton.primary(
                label: actionLabel!,
                onPressed: onAction,
                size: AppButtonSize.small,
                isFullWidth: false,
              ),
            ],
          ],
        ),
      ),
    );
  }

  CrossAxisAlignment _getCrossAxisAlignment() {
    if (contentAlignment == Alignment.bottomLeft ||
        contentAlignment == Alignment.topLeft ||
        contentAlignment == Alignment.centerLeft) {
      return CrossAxisAlignment.start;
    }
    if (contentAlignment == Alignment.bottomRight ||
        contentAlignment == Alignment.topRight ||
        contentAlignment == Alignment.centerRight) {
      return CrossAxisAlignment.end;
    }
    return CrossAxisAlignment.center;
  }
}

/// A stat item for displaying metrics.
class AppStatItem {
  /// Stat value (e.g., "1,234").
  final String value;

  /// Stat label (e.g., "Total Users").
  final String label;

  /// Optional icon.
  final IconData? icon;

  /// Optional trend indicator (+5%, -2%).
  final String? trend;

  /// Whether trend is positive.
  final bool? isTrendPositive;

  /// Creates an [AppStatItem].
  const AppStatItem({
    required this.value,
    required this.label,
    this.icon,
    this.trend,
    this.isTrendPositive,
  });
}

/// A stats card displaying multiple metrics.
///
/// Example:
/// ```dart
/// AppStatsCard(
///   title: 'Overview',
///   stats: [
///     AppStatItem(value: '12.5k', label: 'Users', trend: '+12%', isTrendPositive: true),
///     AppStatItem(value: '\$8.2k', label: 'Revenue', trend: '+8%', isTrendPositive: true),
///   ],
/// )
/// ```
class AppStatsCard extends StatelessWidget {
  /// Card title.
  final String? title;

  /// List of stats to display.
  final List<AppStatItem> stats;

  /// Number of columns for stats grid.
  final int columns;

  /// Card padding.
  final EdgeInsetsGeometry? padding;

  /// Creates an [AppStatsCard].
  const AppStatsCard({
    super.key,
    this.title,
    required this.stats,
    this.columns = 2,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: padding ?? EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
        borderRadius: AppRadius.card,
        border: Border.all(
          color: isDark ? AppColors.borderDark : AppColors.borderLight,
        ),
        boxShadow: AppShadows.sm,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (title != null) ...[
            Text(
              title!,
              style: AppTypography.titleMedium.copyWith(
                color: isDark
                    ? AppColors.textPrimaryDark
                    : AppColors.textPrimaryLight,
              ),
            ),
            SizedBox(height: 16.h),
          ],
          _buildStatsGrid(isDark),
        ],
      ),
    );
  }

  Widget _buildStatsGrid(bool isDark) {
    final rows = <Widget>[];
    for (var i = 0; i < stats.length; i += columns) {
      final rowItems = stats.skip(i).take(columns).toList();
      rows.add(
        Row(
          children: rowItems.map((stat) {
            return Expanded(
              child: _StatItemWidget(stat: stat, isDark: isDark),
            );
          }).toList(),
        ),
      );
      if (i + columns < stats.length) {
        rows.add(SizedBox(height: 16.h));
      }
    }
    return Column(children: rows);
  }
}

class _StatItemWidget extends StatelessWidget {
  final AppStatItem stat;
  final bool isDark;

  const _StatItemWidget({
    required this.stat,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            if (stat.icon != null) ...[
              Icon(
                stat.icon,
                size: 16.sp,
                color: AppColors.primary,
              ),
              SizedBox(width: 4.w),
            ],
            Text(
              stat.value,
              style: AppTypography.headlineSmall.copyWith(
                color: isDark
                    ? AppColors.textPrimaryDark
                    : AppColors.textPrimaryLight,
                fontWeight: FontWeight.bold,
              ),
            ),
            if (stat.trend != null) ...[
              SizedBox(width: 8.w),
              _buildTrend(),
            ],
          ],
        ),
        SizedBox(height: 4.h),
        Text(
          stat.label,
          style: AppTypography.bodySmall.copyWith(
            color: isDark
                ? AppColors.textSecondaryDark
                : AppColors.textSecondaryLight,
          ),
        ),
      ],
    );
  }

  Widget _buildTrend() {
    final isPositive = stat.isTrendPositive ?? true;
    final color = isPositive ? AppColors.success : AppColors.error;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: AppRadius.xs,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            isPositive ? Icons.trending_up : Icons.trending_down,
            size: 12.sp,
            color: color,
          ),
          SizedBox(width: 2.w),
          Text(
            stat.trend!,
            style: AppTypography.caption.copyWith(
              color: color,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

/// A product card for e-commerce style displays.
///
/// Example:
/// ```dart
/// AppProductCard(
///   imageUrl: 'https://example.com/product.jpg',
///   title: 'Product Name',
///   price: '\$99.99',
///   originalPrice: '\$149.99',
///   rating: 4.5,
///   onTap: () {},
/// )
/// ```
class AppProductCard extends StatelessWidget {
  /// Product image URL.
  final String? imageUrl;

  /// Product asset image path.
  final String? assetImage;

  /// Product title.
  final String title;

  /// Product description.
  final String? description;

  /// Current price.
  final String price;

  /// Original price (for discount display).
  final String? originalPrice;

  /// Rating (0-5).
  final double? rating;

  /// Number of reviews.
  final int? reviewCount;

  /// Badge text (e.g., "Sale", "New").
  final String? badge;

  /// Badge color.
  final Color? badgeColor;

  /// Callback when card is tapped.
  final VoidCallback? onTap;

  /// Callback when favorite is toggled.
  final VoidCallback? onFavorite;

  /// Whether product is favorited.
  final bool isFavorite;

  /// Creates an [AppProductCard].
  const AppProductCard({
    super.key,
    this.imageUrl,
    this.assetImage,
    required this.title,
    this.description,
    required this.price,
    this.originalPrice,
    this.rating,
    this.reviewCount,
    this.badge,
    this.badgeColor,
    this.onTap,
    this.onFavorite,
    this.isFavorite = false,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
          borderRadius: AppRadius.card,
          border: Border.all(
            color: isDark ? AppColors.borderDark : AppColors.borderLight,
          ),
          boxShadow: AppShadows.sm,
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image section
            _buildImageSection(isDark),

            // Content section
            Padding(
              padding: EdgeInsets.all(12.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppTypography.titleSmall.copyWith(
                      color: isDark
                          ? AppColors.textPrimaryDark
                          : AppColors.textPrimaryLight,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (description != null) ...[
                    SizedBox(height: 4.h),
                    Text(
                      description!,
                      style: AppTypography.bodySmall.copyWith(
                        color: isDark
                            ? AppColors.textSecondaryDark
                            : AppColors.textSecondaryLight,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                  SizedBox(height: 8.h),
                  _buildPriceRow(isDark),
                  if (rating != null) ...[
                    SizedBox(height: 8.h),
                    _buildRatingRow(isDark),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImageSection(bool isDark) {
    return AspectRatio(
      aspectRatio: 1.2,
      child: Stack(
        fit: StackFit.expand,
        children: [
          // Image
          _buildImage(),

          // Badge
          if (badge != null)
            Positioned(
              top: 8.h,
              left: 8.w,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                decoration: BoxDecoration(
                  color: badgeColor ?? AppColors.primary,
                  borderRadius: AppRadius.xs,
                ),
                child: Text(
                  badge!,
                  style: AppTypography.caption.copyWith(
                    color: AppColors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),

          // Favorite button
          if (onFavorite != null)
            Positioned(
              top: 8.h,
              right: 8.w,
              child: GestureDetector(
                onTap: onFavorite,
                child: Container(
                  padding: EdgeInsets.all(6.w),
                  decoration: BoxDecoration(
                    color: isDark
                        ? AppColors.surfaceDark.withValues(alpha: 0.9)
                        : AppColors.white.withValues(alpha: 0.9),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    isFavorite ? Icons.favorite : Icons.favorite_outline,
                    size: 18.sp,
                    color: isFavorite
                        ? AppColors.error
                        : AppColors.contrastMediumLight,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildImage() {
    if (assetImage != null) {
      return Image.asset(assetImage!, fit: BoxFit.cover);
    }

    if (imageUrl != null) {
      return Image.network(
        imageUrl!,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => _buildPlaceholder(),
      );
    }

    return _buildPlaceholder();
  }

  Widget _buildPlaceholder() {
    return Container(
      color: AppColors.surfaceSecondaryLight,
      child: Icon(
        Icons.image_outlined,
        size: 48.sp,
        color: AppColors.contrastMediumLight,
      ),
    );
  }

  Widget _buildPriceRow(bool isDark) {
    return Row(
      children: [
        Text(
          price,
          style: AppTypography.titleMedium.copyWith(
            color: AppColors.primary,
            fontWeight: FontWeight.bold,
          ),
        ),
        if (originalPrice != null) ...[
          SizedBox(width: 8.w),
          Text(
            originalPrice!,
            style: AppTypography.bodySmall.copyWith(
              color: isDark
                  ? AppColors.textTertiaryDark
                  : AppColors.textTertiaryLight,
              decoration: TextDecoration.lineThrough,
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildRatingRow(bool isDark) {
    return Row(
      children: [
        Icon(Icons.star, size: 14.sp, color: AppColors.warning),
        SizedBox(width: 4.w),
        Text(
          rating!.toStringAsFixed(1),
          style: AppTypography.bodySmall.copyWith(
            color:
                isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
            fontWeight: FontWeight.w600,
          ),
        ),
        if (reviewCount != null) ...[
          SizedBox(width: 4.w),
          Text(
            '($reviewCount)',
            style: AppTypography.bodySmall.copyWith(
              color: isDark
                  ? AppColors.textTertiaryDark
                  : AppColors.textTertiaryLight,
            ),
          ),
        ],
      ],
    );
  }
}

/// A profile header card for user profiles.
///
/// Example:
/// ```dart
/// AppProfileHeader(
///   name: 'John Doe',
///   subtitle: 'Software Engineer',
///   avatarUrl: 'https://example.com/avatar.jpg',
///   stats: [
///     ProfileStat(value: '1.2k', label: 'Followers'),
///     ProfileStat(value: '356', label: 'Following'),
///   ],
/// )
/// ```
class AppProfileHeader extends StatelessWidget {
  /// User name.
  final String name;

  /// Subtitle (role, bio, etc.).
  final String? subtitle;

  /// Avatar image URL.
  final String? avatarUrl;

  /// Avatar asset image path.
  final String? avatarAsset;

  /// Profile stats.
  final List<ProfileStat>? stats;

  /// Whether to show edit button.
  final bool showEditButton;

  /// Edit button callback.
  final VoidCallback? onEdit;

  /// Custom action button.
  final Widget? actionButton;

  /// Cover image URL.
  final String? coverImageUrl;

  /// Cover image height.
  final double? coverHeight;

  /// Creates an [AppProfileHeader].
  const AppProfileHeader({
    super.key,
    required this.name,
    this.subtitle,
    this.avatarUrl,
    this.avatarAsset,
    this.stats,
    this.showEditButton = false,
    this.onEdit,
    this.actionButton,
    this.coverImageUrl,
    this.coverHeight,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
        borderRadius: AppRadius.card,
        border: Border.all(
          color: isDark ? AppColors.borderDark : AppColors.borderLight,
        ),
        boxShadow: AppShadows.sm,
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          // Cover image
          if (coverImageUrl != null) _buildCover(),

          // Profile content
          Padding(
            padding: EdgeInsets.all(16.w),
            child: Column(
              children: [
                // Avatar and info row
                Row(
                  children: [
                    _buildAvatar(),
                    SizedBox(width: 16.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            name,
                            style: AppTypography.titleLarge.copyWith(
                              color: isDark
                                  ? AppColors.textPrimaryDark
                                  : AppColors.textPrimaryLight,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          if (subtitle != null) ...[
                            SizedBox(height: 4.h),
                            Text(
                              subtitle!,
                              style: AppTypography.bodyMedium.copyWith(
                                color: isDark
                                    ? AppColors.textSecondaryDark
                                    : AppColors.textSecondaryLight,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                    if (showEditButton || actionButton != null)
                      actionButton ??
                          IconButton(
                            onPressed: onEdit,
                            icon: const Icon(
                              Icons.edit_outlined,
                              color: AppColors.primary,
                            ),
                          ),
                  ],
                ),

                // Stats row
                if (stats != null && stats!.isNotEmpty) ...[
                  SizedBox(height: 16.h),
                  _buildStatsRow(isDark),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCover() {
    return Container(
      height: coverHeight ?? 80.h,
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.primaryLight,
        image: coverImageUrl != null
            ? DecorationImage(
                image: NetworkImage(coverImageUrl!),
                fit: BoxFit.cover,
              )
            : null,
      ),
    );
  }

  Widget _buildAvatar() {
    return Container(
      width: 64.w,
      height: 64.w,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: AppColors.primary,
        border: Border.all(color: AppColors.white, width: 3),
        boxShadow: AppShadows.sm,
        image: avatarUrl != null
            ? DecorationImage(
                image: NetworkImage(avatarUrl!),
                fit: BoxFit.cover,
              )
            : avatarAsset != null
                ? DecorationImage(
                    image: AssetImage(avatarAsset!),
                    fit: BoxFit.cover,
                  )
                : null,
      ),
      child: (avatarUrl == null && avatarAsset == null)
          ? Center(
              child: Text(
                name.isNotEmpty ? name[0].toUpperCase() : '?',
                style: AppTypography.headlineSmall.copyWith(
                  color: AppColors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            )
          : null,
    );
  }

  Widget _buildStatsRow(bool isDark) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: stats!.map((stat) {
        return Column(
          children: [
            Text(
              stat.value,
              style: AppTypography.titleMedium.copyWith(
                color: isDark
                    ? AppColors.textPrimaryDark
                    : AppColors.textPrimaryLight,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 2.h),
            Text(
              stat.label,
              style: AppTypography.bodySmall.copyWith(
                color: isDark
                    ? AppColors.textSecondaryDark
                    : AppColors.textSecondaryLight,
              ),
            ),
          ],
        );
      }).toList(),
    );
  }
}

/// A stat for the profile header.
class ProfileStat {
  /// Stat value.
  final String value;

  /// Stat label.
  final String label;

  /// Creates a [ProfileStat].
  const ProfileStat({
    required this.value,
    required this.label,
  });
}
