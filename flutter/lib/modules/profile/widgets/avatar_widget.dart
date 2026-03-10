import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/core.dart';
import '../../../core/extensions/context_extensions.dart';
import '../../../design_system/design_system.dart';

/// Avatar widget with edit functionality.
///
/// Displays a user avatar from URL, file, or initials placeholder.
class AvatarWidget extends StatelessWidget {
  /// Avatar URL.
  final String? url;

  /// Avatar file (for local preview).
  final File? file;

  /// User initials for placeholder.
  final String initials;

  /// Size of the avatar.
  final double size;

  /// Whether the avatar is editable.
  final bool editable;

  /// Callback when avatar is tapped.
  final VoidCallback? onTap;

  /// Callback when edit button is tapped.
  final VoidCallback? onEditTap;

  /// Background color for placeholder.
  final Color? backgroundColor;

  const AvatarWidget({
    this.url,
    this.file,
    this.initials = '',
    this.size = 80,
    this.editable = false,
    this.onTap,
    this.onEditTap,
    this.backgroundColor,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveSize = size.w;

    return GestureDetector(
      onTap: editable ? (onEditTap ?? onTap) : onTap,
      child: Stack(
        children: [
          // Avatar container
          Container(
            width: effectiveSize,
            height: effectiveSize,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: backgroundColor ?? AppColors.neutral200,
              border: Border.all(color: AppColors.neutral300, width: 2.w),
            ),
            child: ClipOval(child: _buildContent(context, effectiveSize)),
          ),

          // Edit button
          if (editable)
            Positioned(
              right: 0,
              bottom: 0,
              child: Container(
                width: 32.w,
                height: 32.w,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Theme.of(context).colorScheme.primary,
                  border: Border.all(
                    color: context.colorScheme.surface,
                    width: 2.w,
                  ),
                ),
                child: Icon(
                  Icons.camera_alt_rounded,
                  size: 16.sp,
                  color: AppColors.white,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildContent(BuildContext context, double effectiveSize) {
    // Show file if available (local preview)
    if (file != null) {
      return Image.file(
        file!,
        fit: BoxFit.cover,
        width: effectiveSize,
        height: effectiveSize,
      );
    }

    // Show URL if available
    if (url != null && url!.isNotEmpty) {
      return Image.network(
        url!,
        fit: BoxFit.cover,
        width: effectiveSize,
        height: effectiveSize,
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return Center(
            child: CircularProgressIndicator(
              value: loadingProgress.expectedTotalBytes != null
                  ? loadingProgress.cumulativeBytesLoaded /
                        loadingProgress.expectedTotalBytes!
                  : null,
              strokeWidth: 2.w,
              color: Theme.of(context).colorScheme.primary,
            ),
          );
        },
        errorBuilder: (context, error, stackTrace) {
          return _buildPlaceholder(context, effectiveSize);
        },
      );
    }

    // Show initials placeholder
    return _buildPlaceholder(context, effectiveSize);
  }

  Widget _buildPlaceholder(BuildContext context, double effectiveSize) {
    if (initials.isEmpty) {
      return Icon(
        Icons.person_rounded,
        size: effectiveSize * 0.5,
        color: AppColors.neutral500,
      );
    }

    return Center(
      child: Text(
        initials,
        style: AppTypography.headlineMedium.copyWith(
          fontSize: effectiveSize * 0.35,
          fontWeight: FontWeight.w600,
          color: AppColors.neutral600,
        ),
      ),
    );
  }
}

/// Avatar picker bottom sheet.
///
/// Shows options to take photo, choose from gallery, or remove avatar.
class AvatarPickerOptions extends StatelessWidget {
  /// Callback for camera option.
  final VoidCallback? onCamera;

  /// Callback for gallery option.
  final VoidCallback? onGallery;

  /// Callback for remove option.
  final VoidCallback? onRemove;

  /// Whether remove option is available.
  final bool canRemove;

  const AvatarPickerOptions({
    this.onCamera,
    this.onGallery,
    this.onRemove,
    this.canRemove = true,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        _buildOption(
          context,
          icon: Icons.camera_alt_rounded,
          label: context.l10n.avatarTakePhoto,
          onTap: onCamera,
        ),
        _buildOption(
          context,
          icon: Icons.photo_library_rounded,
          label: context.l10n.avatarChooseFromGallery,
          onTap: onGallery,
        ),
        if (canRemove)
          _buildOption(
            context,
            icon: Icons.delete_rounded,
            label: context.l10n.avatarRemovePhoto,
            onTap: onRemove,
            isDestructive: true,
          ),
      ],
    );
  }

  Widget _buildOption(
    BuildContext context, {
    required IconData icon,
    required String label,
    VoidCallback? onTap,
    bool isDestructive = false,
  }) {
    final color = isDestructive
        ? AppColors.error
        : context.colorScheme.onSurface;

    return ListTile(
      leading: Icon(icon, color: color),
      title: Text(
        label,
        style: AppTypography.bodyMedium.copyWith(color: color),
      ),
      onTap: onTap,
    );
  }
}
