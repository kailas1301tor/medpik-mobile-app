// test/data/models/personal_information_args_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:medpik/data/models/personal_information_args.dart';

void main() {
  group('PersonalInformationArgs', () {
    test('from PersonalInformationArgs preserves isOnboarding', () {
      final input = PersonalInformationArgs(isOnboarding: true);
      final args = PersonalInformationArgs.from(input);
      expect(args.isOnboarding, isTrue);
    });

    test('from null defaults to non-onboarding', () {
      final args = PersonalInformationArgs.from(null);
      expect(args.isOnboarding, isFalse);
    });

    test('from unrelated type defaults to non-onboarding', () {
      final args = PersonalInformationArgs.from('invalid');
      expect(args.isOnboarding, isFalse);
    });
  });
}
