import 'package:flutter_test/flutter_test.dart';
import 'package:medpik/utils/helpers/haptic_helper.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('AppHaptics', () {
    test('selection completes without throwing', () async {
      await expectLater(AppHaptics.selection(), completes);
    });

    test('light completes without throwing', () async {
      await expectLater(AppHaptics.light(), completes);
    });

    test('success and error complete without throwing', () async {
      await expectLater(AppHaptics.success(), completes);
      await expectLater(AppHaptics.error(), completes);
    });
  });
}
