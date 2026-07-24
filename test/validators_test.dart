import 'package:flutter_test/flutter_test.dart';
import 'package:medpik/res/constants/string_constants.dart';
import 'package:medpik/utils/helpers/validators.dart';

void main() {
  group('Validators Unit Tests', () {
    test('validatePhone validation rules', () {
      // Valid cases (exactly 10 digits)
      expect(Validators.validatePhone('1234567890'), isNull);
      expect(Validators.validatePhone(' 9876543210 '), isNull); // spaces allowed but stripped

      // Invalid cases
      expect(Validators.validatePhone(''), Strings.invalidPhone);
      expect(Validators.validatePhone(null), Strings.invalidPhone);
      expect(Validators.validatePhone('12345'), Strings.invalidPhone); // too short
      expect(Validators.validatePhone('12345678901'), Strings.invalidPhone); // too long
      expect(Validators.validatePhone('123456789a'), Strings.invalidPhone); // non-digits
      expect(Validators.validatePhone('+1234567890'), Strings.invalidPhone); // exact 10 digits check, no prefix
    });

    test('validateName validation rules', () {
      // Valid cases
      expect(Validators.validateName('John'), isNull);
      expect(Validators.validateName('Al'), isNull); // minimum 2 chars

      // Invalid cases
      expect(Validators.validateName(''), Strings.invalidName);
      expect(Validators.validateName(null), Strings.invalidName);
      expect(Validators.validateName('a'), Strings.invalidName); // too short
    });

    test('validateRequired validation rules', () {
      // Valid cases
      expect(Validators.validateRequired('content'), isNull);

      // Invalid cases
      expect(Validators.validateRequired(''), Strings.fieldRequired);
      expect(Validators.validateRequired(null), Strings.fieldRequired);
      expect(Validators.validateRequired('', 'Name'), 'Name is required');
    });

    test('validateEmail validation rules', () {
      // Valid cases
      expect(Validators.validateEmail('test@medpik.com'), isNull);
      expect(Validators.validateEmail('user.name+label@medpik.co.in'), isNull);

      // Invalid cases
      expect(Validators.validateEmail(''), Strings.emailRequired);
      expect(Validators.validateEmail(null), Strings.emailRequired);
      expect(Validators.validateEmail('invalid-email'), Strings.invalidEmail);
      expect(Validators.validateEmail('test@com'), Strings.invalidEmail);
    });
  });

  group('ValidatorExtension Extension Tests', () {
    test('validateName extension getter', () {
      const name = 'Bob';
      expect(name.validateName, isNull);
    });

    test('validatePhone extension getter', () {
      const phone = '9999999999';
      expect(phone.validatePhone, isNull);
    });
  });
}
