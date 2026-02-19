/// Profile module.
///
/// Provides user profile management functionality.
///
/// ## Features
/// - View user profile
/// - Edit profile information
/// - Avatar upload and management
/// - Configurable fields
/// - Multiple visual styles
///
/// ## Usage
/// ```dart
/// import 'package:lifeflow/modules/profile/profile_module.dart';
///
/// // Use with default config
/// ProfileView()
///
/// // Use with custom config
/// ProfileView(
///   config: ProfileConfig(
///     fields: [
///       ProfileField.displayName(required: true),
///       ProfileField.email(editable: false),
///       ProfileField.custom(key: 'company', label: 'Company'),
///     ],
///     enableAvatar: true,
///     style: ProfileStyle.hero,
///   ),
/// )
/// ```
library;

// Config
export 'config/profile_config.dart';
export 'viewmodels/edit_profile_viewmodel.dart';
// ViewModels
export 'viewmodels/profile_viewmodel.dart';
export 'views/edit_profile_view.dart';
// Views
export 'views/profile_view.dart';
// Widgets
export 'widgets/avatar_widget.dart';
export 'widgets/profile_field_widget.dart';
export 'widgets/profile_section.dart';
