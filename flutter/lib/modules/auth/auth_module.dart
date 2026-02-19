/// Auth Module barrel file.
///
/// Exports all auth-related components for easy import.
///
/// Usage:
/// ```dart
/// import 'package:lifeflow/modules/auth/auth_module.dart';
/// ```
library auth_module;

// Config
export 'config/auth_config.dart';
export 'viewmodels/forgot_password_viewmodel.dart';
// ViewModels
export 'viewmodels/login_viewmodel.dart';
export 'viewmodels/register_viewmodel.dart';
export 'views/forgot_password_view.dart';
// Views
export 'views/login_view.dart';
export 'views/register_view.dart';
export 'widgets/auth_form_fields.dart';
export 'widgets/auth_header.dart';
// Widgets
export 'widgets/social_login_buttons.dart';
