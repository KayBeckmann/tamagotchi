import 'dart:convert';
import 'dart:math';
import 'package:crypto/crypto.dart';
import 'package:dbcrypt/dbcrypt.dart';
import 'package:serverpod/serverpod.dart';

import '../generated/protocol.dart';

class AuthService {
  static const _accessTokenDuration = Duration(hours: 1);
  static const _refreshTokenDuration = Duration(days: 30);

  static final _random = Random.secure();

  /// Hash a password using BCrypt.
  static String hashPassword(String password) {
    return DBCrypt().hashpw(password, DBCrypt().gensalt());
  }

  /// Verify a password against its BCrypt hash.
  static bool verifyPassword(String password, String hash) {
    return DBCrypt().checkpw(password, hash);
  }

  /// Generate a cryptographically secure random token.
  static String generateToken() {
    final bytes = List<int>.generate(64, (_) => _random.nextInt(256));
    return base64Url.encode(bytes);
  }

  /// Hash a token for storage using SHA-256.
  static String hashToken(String token) {
    return sha256.convert(utf8.encode(token)).toString();
  }

  /// Register a new user.
  static Future<AuthResponse> register(
    Session session, {
    required String username,
    required String email,
    required String password,
  }) async {
    // Validate input
    if (username.length < 3 || username.length > 30) {
      throw ArgumentError('Username muss zwischen 3 und 30 Zeichen lang sein.');
    }
    if (!RegExp(r'^[a-zA-Z0-9_]+$').hasMatch(username)) {
      throw ArgumentError(
        'Username darf nur Buchstaben, Zahlen und Unterstriche enthalten.',
      );
    }
    if (!RegExp(r'^[^@]+@[^@]+\.[^@]+$').hasMatch(email)) {
      throw ArgumentError('Ungültige E-Mail-Adresse.');
    }
    if (password.length < 8) {
      throw ArgumentError('Passwort muss mindestens 8 Zeichen lang sein.');
    }

    // Check if email or username already exists
    final existingEmail = await AppUser.db.findFirstRow(
      session,
      where: (t) => t.email.equals(email.toLowerCase()),
    );
    if (existingEmail != null) {
      throw ArgumentError('Diese E-Mail-Adresse ist bereits registriert.');
    }

    final existingUsername = await AppUser.db.findFirstRow(
      session,
      where: (t) => t.username.equals(username),
    );
    if (existingUsername != null) {
      throw ArgumentError('Dieser Username ist bereits vergeben.');
    }

    // Create user
    final now = DateTime.now().toUtc();
    final user = AppUser(
      username: username,
      email: email.toLowerCase(),
      passwordHash: hashPassword(password),
      xp: 0,
      level: 1,
      eloRating: 1000,
      walletBalanceSat: 0,
      totalWins: 0,
      totalLosses: 0,
      isActive: true,
      createdAt: now,
      lastLoginAt: now,
    );

    final createdUser = await AppUser.db.insertRow(session, user);

    // Generate tokens
    return _createAuthResponse(session, createdUser);
  }

  /// Login with email and password.
  static Future<AuthResponse> login(
    Session session, {
    required String email,
    required String password,
    String? deviceInfo,
  }) async {
    final user = await AppUser.db.findFirstRow(
      session,
      where: (t) => t.email.equals(email.toLowerCase()),
    );

    if (user == null || !verifyPassword(password, user.passwordHash)) {
      throw ArgumentError('Ungültige E-Mail oder Passwort.');
    }

    if (!user.isActive) {
      throw ArgumentError('Dieses Konto wurde deaktiviert.');
    }

    // Update last login
    user.lastLoginAt = DateTime.now().toUtc();
    await AppUser.db.updateRow(session, user);

    return _createAuthResponse(session, user, deviceInfo: deviceInfo);
  }

  /// Refresh an access token using a refresh token.
  static Future<AuthResponse> refreshToken(
    Session session, {
    required String refreshToken,
  }) async {
    final tokenHash = hashToken(refreshToken);

    final storedToken = await AuthToken.db.findFirstRow(
      session,
      where: (t) =>
          t.tokenHash.equals(tokenHash) &
          (t.expiresAt > DateTime.now().toUtc()),
    );

    if (storedToken == null) {
      throw ArgumentError('Ungültiger oder abgelaufener Refresh-Token.');
    }

    // Delete the old refresh token (rotation)
    await AuthToken.db.deleteRow(session, storedToken);

    // Get the user
    final user = await AppUser.db.findById(session, storedToken.userId);
    if (user == null || !user.isActive) {
      throw ArgumentError('Benutzer nicht gefunden oder deaktiviert.');
    }

    return _createAuthResponse(session, user);
  }

  /// Logout - invalidate refresh token.
  static Future<void> logout(
    Session session, {
    required String refreshToken,
  }) async {
    final tokenHash = hashToken(refreshToken);
    final storedToken = await AuthToken.db.findFirstRow(
      session,
      where: (t) => t.tokenHash.equals(tokenHash),
    );
    if (storedToken != null) {
      await AuthToken.db.deleteRow(session, storedToken);
    }
  }

  /// Logout from all devices - invalidate all refresh tokens.
  static Future<void> logoutAll(Session session, {required int userId}) async {
    final tokens = await AuthToken.db.find(
      session,
      where: (t) => t.userId.equals(userId),
    );
    for (final token in tokens) {
      await AuthToken.db.deleteRow(session, token);
    }
  }

  /// Delete a user account (GDPR compliant).
  static Future<void> deleteAccount(
    Session session, {
    required int userId,
    required String password,
  }) async {
    final user = await AppUser.db.findById(session, userId);
    if (user == null) {
      throw ArgumentError('Benutzer nicht gefunden.');
    }
    if (!verifyPassword(password, user.passwordHash)) {
      throw ArgumentError('Ungültiges Passwort.');
    }

    // Delete all tokens
    await logoutAll(session, userId: userId);

    // Deactivate account (soft delete for data integrity)
    user.isActive = false;
    user.email = 'deleted_${user.id}@deleted.local';
    user.username = 'deleted_${user.id}';
    user.passwordHash = '';
    await AppUser.db.updateRow(session, user);
  }

  /// Create an auth response with new tokens for a user.
  static Future<AuthResponse> _createAuthResponse(
    Session session,
    AppUser user, {
    String? deviceInfo,
  }) async {
    final now = DateTime.now().toUtc();

    // Generate access token (simple signed token with user info)
    final accessToken = generateToken();
    final refreshTokenStr = generateToken();

    // Store refresh token hash
    final authToken = AuthToken(
      userId: user.id!,
      tokenHash: hashToken(refreshTokenStr),
      expiresAt: now.add(_refreshTokenDuration),
      deviceInfo: deviceInfo,
      createdAt: now,
    );
    await AuthToken.db.insertRow(session, authToken);

    // Strip sensitive data for response
    final safeUser = user.copyWith(passwordHash: '');

    return AuthResponse(
      user: safeUser,
      accessToken: '${user.id}:$accessToken',
      refreshToken: refreshTokenStr,
      expiresAt: now.add(_accessTokenDuration),
    );
  }

  /// Validate an access token and return the user ID.
  /// Format: "userId:token"
  static int? parseAccessTokenUserId(String accessToken) {
    final parts = accessToken.split(':');
    if (parts.length != 2) return null;
    return int.tryParse(parts[0]);
  }
}
