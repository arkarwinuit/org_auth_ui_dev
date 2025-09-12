import 'package:flutter_test/flutter_test.dart';
import 'package:org_auth_ui_dev/src/validation/validators.dart';

void main() {
  group('User ID Validation', () {
    test('returns null for valid email', () {
      expect(validateField('test@example.com', 'userid'), isNull);
      expect(validateField('user.name@example.co.uk', 'userid'), isNull);
    });

    test('returns error message for invalid user ID', () {
      expect(validateField('plainaddress', 'userid'), 'Invalid User ID');
      expect(validateField('@missingusername.com', 'userid'), 'Invalid User ID');
      expect(validateField('', 'userid'), 'Invalid User ID');
    });
  });

  group('Sign-in User ID Validation', () {
    test('returns null for non-empty value', () {
      expect(validateField('test@example.com', 'singinUserid'), isNull);
    });

    test('returns error message for empty value', () {
      expect(validateField('', 'singinUserid'), 'Invalid User ID');
    });
  });

  group('Password Validation', () {
    test('returns null for valid password', () {
      expect(validateField('password123', 'Password'), isNull);
    });

    test('returns error message for empty password', () {
      expect(validateField('', 'Password'), 'Invalid Password');
    });

    test('returns error message for short password', () {
      expect(validateField('1234567', 'Password'), 'Enter at least 8 characters');
    });
  });
}
