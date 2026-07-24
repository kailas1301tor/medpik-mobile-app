import 'package:flutter_test/flutter_test.dart';
import 'package:medpik/res/constants/app_constants.dart';

void main() {
  group('device platform constants', () {
    test('android platform constant matches backend contract', () {
      expect(AppConstants.devicePlatformAndroid, 'android');
    });

    test('ios platform constant matches backend contract', () {
      expect(AppConstants.devicePlatformIos, 'ios');
    });
  });
}
