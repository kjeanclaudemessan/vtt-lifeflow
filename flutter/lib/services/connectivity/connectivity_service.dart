import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:stacked/stacked.dart';

/// Service for monitoring network connectivity.
///
/// Provides reactive state for online/offline status and connection type.
/// ViewModels can listen to this service for connectivity changes.
///
/// Example:
/// ```dart
/// class MyViewModel extends ReactiveViewModel {
///   final _connectivity = locator<ConnectivityService>();
///
///   @override
///   List<ListenableServiceMixin> get listenableServices => [_connectivity];
///
///   bool get isOnline => _connectivity.isOnline;
///
///   void doSomething() {
///     if (!isOnline) {
///       setError('No internet connection');
///       return;
///     }
///     // proceed with online operation
///   }
/// }
/// ```
class ConnectivityService with ListenableServiceMixin {
  final Connectivity _connectivity = Connectivity();
  StreamSubscription<List<ConnectivityResult>>? _subscription;

  // ═══════════════════════════════════════════════════════════════════════════
  // REACTIVE VALUES
  // ═══════════════════════════════════════════════════════════════════════════

  final _isOnline = ReactiveValue<bool>(true);
  final _connectionType = ReactiveValue<ConnectivityResult>(
    ConnectivityResult.none,
  );
  final _connectionTypes = ReactiveValue<List<ConnectivityResult>>([]);

  /// Whether the device is online.
  bool get isOnline => _isOnline.value;

  /// Whether the device is offline.
  bool get isOffline => !_isOnline.value;

  /// Primary connection type.
  ConnectivityResult get connectionType => _connectionType.value;

  /// All active connection types.
  List<ConnectivityResult> get connectionTypes => _connectionTypes.value;

  /// Whether connected via WiFi.
  bool get isWifi => _connectionTypes.value.contains(ConnectivityResult.wifi);

  /// Whether connected via mobile data.
  bool get isMobile =>
      _connectionTypes.value.contains(ConnectivityResult.mobile);

  /// Whether connected via ethernet.
  bool get isEthernet =>
      _connectionTypes.value.contains(ConnectivityResult.ethernet);

  /// Whether connected via VPN.
  bool get isVpn => _connectionTypes.value.contains(ConnectivityResult.vpn);

  // ═══════════════════════════════════════════════════════════════════════════
  // CONSTRUCTOR & INITIALIZATION
  // ═══════════════════════════════════════════════════════════════════════════

  /// Creates a [ConnectivityService].
  ConnectivityService() {
    listenToReactiveValues([_isOnline, _connectionType, _connectionTypes]);
  }

  /// Initializes the service and starts listening for connectivity changes.
  ///
  /// Must be called during app startup.
  Future<void> init() async {
    // Get initial connectivity status
    final results = await _connectivity.checkConnectivity();
    _updateStatus(results);

    // Listen for changes
    _subscription = _connectivity.onConnectivityChanged.listen(_updateStatus);
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // PUBLIC METHODS
  // ═══════════════════════════════════════════════════════════════════════════

  /// Manually checks and returns the current connectivity status.
  Future<bool> checkConnectivity() async {
    final results = await _connectivity.checkConnectivity();
    _updateStatus(results);
    return isOnline;
  }

  /// Returns a human-readable connection status.
  String get connectionStatusText {
    if (isOffline) return 'Offline';

    final types = <String>[];
    if (isWifi) types.add('WiFi');
    if (isMobile) types.add('Mobile');
    if (isEthernet) types.add('Ethernet');
    if (isVpn) types.add('VPN');

    if (types.isEmpty) return 'Online';
    return types.join(' + ');
  }

  /// Returns the connection quality (rough estimate).
  ConnectionQuality get connectionQuality {
    if (isOffline) return ConnectionQuality.none;
    if (isEthernet || isWifi) return ConnectionQuality.high;
    if (isMobile) return ConnectionQuality.medium;
    return ConnectionQuality.low;
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // PRIVATE METHODS
  // ═══════════════════════════════════════════════════════════════════════════

  void _updateStatus(List<ConnectivityResult> results) {
    _connectionTypes.value = results;
    _connectionType.value = results.isNotEmpty
        ? _getPrimaryConnectionType(results)
        : ConnectivityResult.none;
    _isOnline.value =
        results.isNotEmpty && !results.contains(ConnectivityResult.none);
  }

  ConnectivityResult _getPrimaryConnectionType(
      List<ConnectivityResult> results) {
    // Priority: Ethernet > WiFi > Mobile > VPN > Bluetooth > Other
    if (results.contains(ConnectivityResult.ethernet)) {
      return ConnectivityResult.ethernet;
    }
    if (results.contains(ConnectivityResult.wifi)) {
      return ConnectivityResult.wifi;
    }
    if (results.contains(ConnectivityResult.mobile)) {
      return ConnectivityResult.mobile;
    }
    if (results.contains(ConnectivityResult.vpn)) {
      return ConnectivityResult.vpn;
    }
    return results.first;
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // CLEANUP
  // ═══════════════════════════════════════════════════════════════════════════

  /// Disposes resources.
  void dispose() {
    _subscription?.cancel();
    _subscription = null;
  }
}

/// Connection quality levels.
enum ConnectionQuality {
  /// No connection.
  none,

  /// Low quality (e.g., slow mobile).
  low,

  /// Medium quality (e.g., mobile data).
  medium,

  /// High quality (e.g., WiFi, Ethernet).
  high,
}
