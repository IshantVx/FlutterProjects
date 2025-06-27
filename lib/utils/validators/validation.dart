class IValidator {
  // ✅ Email validation
  static String? cValidateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email is required.';
    }

    final emailRegExp = RegExp(
      r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
    );

    if (!emailRegExp.hasMatch(value)) {
      return 'Invalid email address.';
    }

    return null;
  }

  // ✅ Password validation
  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required.';
    }

    // Optional: Add more password rules here
    return null;
  }

  // ✅ Phone number validation (simple)
  static String? validatePhoneNumber(String? value) {
    if (value == null || value.isEmpty) {
      return 'Phone number is required.';
    }

    final phoneRegExp = RegExp(r'^[0-9]{10,15}$');

    if (!phoneRegExp.hasMatch(value)) {
      return 'Invalid phone number.';
    }

    return null;
  }
}
