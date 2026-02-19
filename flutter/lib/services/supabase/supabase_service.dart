import 'package:supabase_flutter/supabase_flutter.dart';

import '../../core/config/app_config.dart';

/// Supabase client service.
///
/// Provides access to the Supabase client for database, auth, storage, etc.
///
/// Example:
/// ```dart
/// final supabase = locator<SupabaseService>();
///
/// // Access Supabase client
/// final client = supabase.client;
///
/// // Query data
/// final data = await client.from('users').select();
///
/// // Check auth status
/// if (supabase.isAuthenticated) {
///   final user = supabase.currentUser;
/// }
/// ```
class SupabaseService {
  late SupabaseClient _client;

  /// Creates a [SupabaseService].
  ///
  /// Optionally accepts a pre-configured [SupabaseClient] for testing.
  /// In production, call [init] to initialize via `Supabase.initialize()`.
  SupabaseService({SupabaseClient? client}) {
    if (client != null) _client = client;
  }

  /// The Supabase client instance.
  SupabaseClient get client => _client;

  /// Initializes Supabase.
  ///
  /// Must be called during app startup before using any Supabase features.
  /// Skipped if a client was provided via constructor (test mode).
  Future<void> init() async {
    // If client was injected (tests), skip Flutter initialization
    try {
      // ignore: unnecessary_null_comparison
      if (_client != null) return;
    } catch (_) {
      // _client not yet assigned — continue with init
    }

    await Supabase.initialize(
      url: AppConfig.instance.supabaseUrl,
      anonKey: AppConfig.instance.supabaseAnonKey,
      authOptions: const FlutterAuthClientOptions(
        authFlowType: AuthFlowType.pkce,
      ),
      realtimeClientOptions: const RealtimeClientOptions(
        logLevel: RealtimeLogLevel.info,
      ),
    );
    _client = Supabase.instance.client;
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // AUTH SHORTCUTS
  // ═══════════════════════════════════════════════════════════════════════════

  /// Current authenticated user.
  User? get currentUser => _client.auth.currentUser;

  /// Current session.
  Session? get currentSession => _client.auth.currentSession;

  /// Whether user is authenticated.
  bool get isAuthenticated => currentUser != null;

  /// Auth state changes stream.
  Stream<AuthState> get authStateChanges => _client.auth.onAuthStateChange;

  // ═══════════════════════════════════════════════════════════════════════════
  // DATABASE SHORTCUTS
  // ═══════════════════════════════════════════════════════════════════════════

  /// Access a database table.
  SupabaseQueryBuilder from(String table) => _client.from(table);

  /// Execute a stored procedure (RPC).
  PostgrestFilterBuilder<T> rpc<T>(
    String fn, {
    Map<String, dynamic>? params,
  }) =>
      _client.rpc(fn, params: params);

  // ═══════════════════════════════════════════════════════════════════════════
  // STORAGE SHORTCUTS
  // ═══════════════════════════════════════════════════════════════════════════

  /// Access a storage bucket.
  StorageFileApi storage(String bucket) => _client.storage.from(bucket);

  // ═══════════════════════════════════════════════════════════════════════════
  // REALTIME SHORTCUTS
  // ═══════════════════════════════════════════════════════════════════════════

  /// Subscribe to a channel.
  RealtimeChannel channel(String name) => _client.channel(name);

  /// Remove a channel subscription.
  Future<String> removeChannel(RealtimeChannel channel) =>
      _client.removeChannel(channel);

  /// Remove all channel subscriptions.
  Future<List<String>> removeAllChannels() => _client.removeAllChannels();
}
