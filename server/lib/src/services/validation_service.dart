/// Service for input validation.
class ValidationService {
  /// Validate email format.
  static ValidationResult validateEmail(String email) {
    if (email.isEmpty) {
      return ValidationResult.invalid('Email is required');
    }

    // RFC 5322 compliant email regex (simplified)
    final emailRegex = RegExp(
      r'^[a-zA-Z0-9.!#$%&*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$',
    );

    if (!emailRegex.hasMatch(email)) {
      return ValidationResult.invalid('Invalid email format');
    }

    if (email.length > 254) {
      return ValidationResult.invalid('Email is too long');
    }

    return ValidationResult.valid();
  }

  /// Validate username format.
  static ValidationResult validateUsername(String username) {
    if (username.isEmpty) {
      return ValidationResult.invalid('Username is required');
    }

    if (username.length < 3) {
      return ValidationResult.invalid('Username must be at least 3 characters');
    }

    if (username.length > 20) {
      return ValidationResult.invalid('Username must be at most 20 characters');
    }

    // Alphanumeric and underscores only
    final usernameRegex = RegExp(r'^[a-zA-Z0-9_]+$');
    if (!usernameRegex.hasMatch(username)) {
      return ValidationResult.invalid(
        'Username can only contain letters, numbers, and underscores',
      );
    }

    // Must start with a letter
    if (!RegExp(r'^[a-zA-Z]').hasMatch(username)) {
      return ValidationResult.invalid('Username must start with a letter');
    }

    // Check for reserved words
    final reserved = ['admin', 'root', 'system', 'moderator', 'support'];
    if (reserved.contains(username.toLowerCase())) {
      return ValidationResult.invalid('This username is reserved');
    }

    return ValidationResult.valid();
  }

  /// Validate creature name.
  static ValidationResult validateCreatureName(String name) {
    if (name.isEmpty) {
      return ValidationResult.invalid('Creature name is required');
    }

    if (name.length < 2) {
      return ValidationResult.invalid('Creature name must be at least 2 characters');
    }

    if (name.length > 20) {
      return ValidationResult.invalid('Creature name must be at most 20 characters');
    }

    // Letters, numbers, spaces, and basic punctuation
    final nameRegex = RegExp(r'^[a-zA-Z0-9 \-_.]+$');
    if (!nameRegex.hasMatch(name)) {
      return ValidationResult.invalid(
        'Creature name can only contain letters, numbers, spaces, and basic punctuation',
      );
    }

    return ValidationResult.valid();
  }

  /// Validate positive integer within range.
  static ValidationResult validatePositiveInt(
    int value, {
    required String fieldName,
    int? min,
    int? max,
  }) {
    if (value < 0) {
      return ValidationResult.invalid('$fieldName must be positive');
    }

    if (min != null && value < min) {
      return ValidationResult.invalid('$fieldName must be at least $min');
    }

    if (max != null && value > max) {
      return ValidationResult.invalid('$fieldName must be at most $max');
    }

    return ValidationResult.valid();
  }

  /// Validate amount in satoshis.
  static ValidationResult validateSatoshiAmount(
    int amount, {
    int minAmount = 1,
    int? maxAmount,
  }) {
    if (amount < minAmount) {
      return ValidationResult.invalid(
        'Amount must be at least $minAmount satoshis',
      );
    }

    if (maxAmount != null && amount > maxAmount) {
      return ValidationResult.invalid(
        'Amount must be at most $maxAmount satoshis',
      );
    }

    return ValidationResult.valid();
  }

  /// Validate Lightning address format.
  static ValidationResult validateLightningAddress(String address) {
    if (address.isEmpty) {
      return ValidationResult.invalid('Lightning address is required');
    }

    // Lightning Address format: user@domain
    if (address.contains('@')) {
      final parts = address.split('@');
      if (parts.length == 2 && parts[0].isNotEmpty && parts[1].isNotEmpty) {
        return ValidationResult.valid();
      }
    }

    // LNURL format: starts with lnurl
    if (address.toLowerCase().startsWith('lnurl')) {
      return ValidationResult.valid();
    }

    // BOLT11 invoice: starts with ln
    if (address.toLowerCase().startsWith('ln')) {
      return ValidationResult.valid();
    }

    return ValidationResult.invalid('Invalid Lightning address format');
  }

  /// Sanitize string input (remove potential XSS).
  static String sanitizeString(String input) {
    return input
        .replaceAll('<', '&lt;')
        .replaceAll('>', '&gt;')
        .replaceAll('"', '&quot;')
        .replaceAll("'", '&#x27;')
        .replaceAll('/', '&#x2F;')
        .trim();
  }

  /// Validate multiple fields and return all errors.
  static MultiValidationResult validateAll(
    Map<String, ValidationResult> validations,
  ) {
    final errors = <String, String>{};

    for (final entry in validations.entries) {
      if (!entry.value.isValid) {
        errors[entry.key] = entry.value.error!;
      }
    }

    return MultiValidationResult(
      isValid: errors.isEmpty,
      errors: errors,
    );
  }
}

/// Result of a single validation.
class ValidationResult {
  final bool isValid;
  final String? error;

  ValidationResult._({
    required this.isValid,
    this.error,
  });

  factory ValidationResult.valid() {
    return ValidationResult._(isValid: true);
  }

  factory ValidationResult.invalid(String error) {
    return ValidationResult._(isValid: false, error: error);
  }
}

/// Result of validating multiple fields.
class MultiValidationResult {
  final bool isValid;
  final Map<String, String> errors;

  MultiValidationResult({
    required this.isValid,
    required this.errors,
  });

  /// Get error message for a specific field.
  String? errorFor(String field) => errors[field];

  /// Get all error messages as a list.
  List<String> get errorMessages => errors.values.toList();

  /// Get a formatted error string.
  String get formattedErrors => errors.entries
      .map((e) => '${e.key}: ${e.value}')
      .join('; ');
}
