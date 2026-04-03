import 'dart:async';

/// In-memory rate limiter for protecting endpoints against abuse.
///
/// Uses a sliding window algorithm for rate limiting.
/// In production, consider using Redis for distributed rate limiting.
class RateLimiterService {
  // Store: key -> list of timestamps
  static final Map<String, List<DateTime>> _requestLog = {};

  // Cleanup timer
  static Timer? _cleanupTimer;

  /// Initialize the rate limiter with periodic cleanup.
  static void initialize() {
    _cleanupTimer?.cancel();
    _cleanupTimer = Timer.periodic(
      const Duration(minutes: 5),
      (_) => _cleanup(),
    );
  }

  /// Check if a request is allowed for the given key.
  ///
  /// [key] - Unique identifier (e.g., IP address, user ID, or combined)
  /// [maxRequests] - Maximum requests allowed in the window
  /// [windowDuration] - Time window for rate limiting
  ///
  /// Returns a [RateLimitResult] indicating if the request is allowed.
  static RateLimitResult checkLimit({
    required String key,
    required int maxRequests,
    required Duration windowDuration,
  }) {
    final now = DateTime.now();
    final windowStart = now.subtract(windowDuration);

    // Get or create request log for this key
    final requests = _requestLog[key] ?? [];

    // Remove expired requests
    requests.removeWhere((time) => time.isBefore(windowStart));

    // Check if under limit
    if (requests.length < maxRequests) {
      // Record this request
      requests.add(now);
      _requestLog[key] = requests;

      return RateLimitResult(
        allowed: true,
        remainingRequests: maxRequests - requests.length,
        resetAt: requests.isEmpty ? now.add(windowDuration) : requests.first.add(windowDuration),
      );
    }

    // Rate limited
    final oldestRequest = requests.first;
    final resetAt = oldestRequest.add(windowDuration);

    return RateLimitResult(
      allowed: false,
      remainingRequests: 0,
      resetAt: resetAt,
      retryAfter: resetAt.difference(now),
    );
  }

  /// Record a request for the given key.
  static void recordRequest(String key) {
    final requests = _requestLog[key] ?? [];
    requests.add(DateTime.now());
    _requestLog[key] = requests;
  }

  /// Clear all rate limit data for a key.
  static void clearKey(String key) {
    _requestLog.remove(key);
  }

  /// Cleanup old entries to prevent memory leaks.
  static void _cleanup() {
    final cutoff = DateTime.now().subtract(const Duration(hours: 1));
    _requestLog.removeWhere((key, requests) {
      requests.removeWhere((time) => time.isBefore(cutoff));
      return requests.isEmpty;
    });
  }

  /// Dispose the rate limiter.
  static void dispose() {
    _cleanupTimer?.cancel();
    _cleanupTimer = null;
    _requestLog.clear();
  }
}

/// Result of a rate limit check.
class RateLimitResult {
  /// Whether the request is allowed.
  final bool allowed;

  /// Number of remaining requests in the current window.
  final int remainingRequests;

  /// When the rate limit will reset.
  final DateTime resetAt;

  /// How long to wait before retrying (only set if not allowed).
  final Duration? retryAfter;

  RateLimitResult({
    required this.allowed,
    required this.remainingRequests,
    required this.resetAt,
    this.retryAfter,
  });
}

/// Rate limit configurations for different endpoints.
class RateLimitConfig {
  /// Login attempts: 5 per 15 minutes per IP
  static const loginMaxRequests = 5;
  static const loginWindow = Duration(minutes: 15);

  /// Registration: 3 per hour per IP
  static const registerMaxRequests = 3;
  static const registerWindow = Duration(hours: 1);

  /// Password reset requests: 3 per hour per email
  static const passwordResetMaxRequests = 3;
  static const passwordResetWindow = Duration(hours: 1);

  /// Token refresh: 10 per minute per user
  static const refreshMaxRequests = 10;
  static const refreshWindow = Duration(minutes: 1);

  /// General API: 100 per minute per user
  static const apiMaxRequests = 100;
  static const apiWindow = Duration(minutes: 1);
}

/// Extension for creating rate limit keys.
extension RateLimitKeyExtension on String {
  /// Create a rate limit key for login attempts.
  String get loginKey => 'login:$this';

  /// Create a rate limit key for registration.
  String get registerKey => 'register:$this';

  /// Create a rate limit key for password reset.
  String get passwordResetKey => 'password_reset:$this';

  /// Create a rate limit key for token refresh.
  String get refreshKey => 'refresh:$this';

  /// Create a rate limit key for general API.
  String get apiKey => 'api:$this';
}
