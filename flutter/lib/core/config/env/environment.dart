/// Application environments.
///
/// Used to configure different settings based on the build environment.
enum Environment {
  /// Development environment - for local development.
  development,

  /// Staging environment - for testing before production.
  staging,

  /// Production environment - for end users.
  production,
}

/// Extension methods for [Environment].
extension EnvironmentExtension on Environment {
  /// Returns `true` if this is the development environment.
  bool get isDevelopment => this == Environment.development;

  /// Returns `true` if this is the staging environment.
  bool get isStaging => this == Environment.staging;

  /// Returns `true` if this is the production environment.
  bool get isProduction => this == Environment.production;

  /// Returns `true` if this is a debug environment (dev or staging).
  bool get isDebug => isDevelopment || isStaging;

  /// Returns `true` if this is a release environment (production).
  bool get isRelease => isProduction;

  /// Returns the environment name as a string.
  String get name {
    switch (this) {
      case Environment.development:
        return 'Development';
      case Environment.staging:
        return 'Staging';
      case Environment.production:
        return 'Production';
    }
  }

  /// Returns a short label for the environment.
  String get label {
    switch (this) {
      case Environment.development:
        return 'DEV';
      case Environment.staging:
        return 'STG';
      case Environment.production:
        return 'PROD';
    }
  }
}
