import 'dart:math';

import 'package:serverpod/serverpod.dart';

/// Service for sending emails (password reset, verification, etc.).
///
/// This is a placeholder implementation. In production, integrate with:
/// - SendGrid
/// - AWS SES
/// - Mailgun
/// - Or any other email provider
class EmailService {
  final Session _session;

  EmailService(this._session);

  /// Send a password reset email.
  Future<bool> sendPasswordResetEmail({
    required String email,
    required String resetToken,
    required String resetUrl,
  }) async {
    // TODO: Integrate with actual email provider
    // For now, log the reset link (development only!)
    _session.log(
      'Password reset requested for $email',
      level: LogLevel.info,
    );
    _session.log(
      'Reset URL: $resetUrl?token=$resetToken',
      level: LogLevel.debug,
    );

    // In production:
    // 1. Create email template with reset link
    // 2. Send via email provider API
    // 3. Return success/failure

    return true;
  }

  /// Send a welcome/verification email.
  Future<bool> sendWelcomeEmail({
    required String email,
    required String username,
    String? verificationToken,
    String? verificationUrl,
  }) async {
    // TODO: Integrate with actual email provider
    _session.log(
      'Welcome email for $username ($email)',
      level: LogLevel.info,
    );

    return true;
  }

  /// Send a notification email.
  Future<bool> sendNotificationEmail({
    required String email,
    required String subject,
    required String body,
  }) async {
    // TODO: Integrate with actual email provider
    _session.log(
      'Notification email to $email: $subject',
      level: LogLevel.info,
    );

    return true;
  }

  /// Generate a secure random token for password reset.
  static String generateResetToken() {
    final random = Random.secure();
    final values = List<int>.generate(32, (i) => random.nextInt(256));
    return values.map((v) => v.toRadixString(16).padLeft(2, '0')).join();
  }
}

/// Configuration for email templates.
class EmailTemplates {
  static String passwordResetSubject = 'Reset Your Tamagotchi Password';

  static String passwordResetBody(String username, String resetUrl) => '''
Hello $username,

You requested to reset your password for your Tamagotchi account.

Click the link below to reset your password:
$resetUrl

This link will expire in 1 hour.

If you did not request this password reset, please ignore this email.

Best regards,
The Tamagotchi Team
''';

  static String welcomeSubject = 'Welcome to Tamagotchi!';

  static String welcomeBody(String username) => '''
Hello $username,

Welcome to Tamagotchi! Your account has been created successfully.

Start your adventure by creating your first creature!

Best regards,
The Tamagotchi Team
''';
}
