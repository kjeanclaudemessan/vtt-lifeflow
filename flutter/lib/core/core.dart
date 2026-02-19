/// Core library barrel file.
///
/// Export all core utilities and classes for easy import.
///
/// Usage:
/// ```dart
/// import 'package:lifeflow/core/core.dart';
/// ```
library core;

// L10n (for AppLocalizations type)
export '../l10n/generated/app_localizations.dart';
// Config
export 'config/app_config.dart';
export 'config/env/env_config.dart';
export 'config/env/environment.dart';
export 'config/feature_flags.dart';
// Constants
export 'constants/api_constants.dart';
export 'constants/app_constants.dart';
export 'constants/regex_patterns.dart';
export 'constants/storage_keys.dart';
export 'errors/error_handler.dart';
export 'errors/exceptions.dart';
// Errors
export 'errors/failures.dart';
export 'extensions/context_extensions.dart';
export 'extensions/datetime_extensions.dart';
export 'extensions/either_extensions.dart';
export 'extensions/list_extensions.dart';
export 'extensions/num_extensions.dart';
// Extensions
export 'extensions/string_extensions.dart';
// Typedefs
export 'typedefs/typedefs.dart';
export 'utils/debouncer.dart';
export 'utils/formatters.dart';
export 'utils/logger.dart';
// Utils
export 'utils/validators.dart';
