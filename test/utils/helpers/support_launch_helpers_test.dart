import 'package:flutter_test/flutter_test.dart';
import 'package:medpik/utils/helpers/email_launch_helper.dart';
import 'package:medpik/utils/helpers/phone_launch_helper.dart';
import 'package:medpik/utils/helpers/whatsapp_launch_helper.dart';

void main() {
  test('buildPhoneUri sanitizes display formatting', () {
    expect(
      buildPhoneUri(' +91 (987) 654-3210 ')?.toString(),
      'tel:+919876543210',
    );
    expect(buildPhoneUri(' - () '), isNull);
  });

  test('buildSupportEmailUri trims and encodes the address', () {
    expect(
      buildSupportEmailUri(' support+care@medpik.com ')?.toString(),
      'mailto:support+care@medpik.com',
    );
    expect(buildSupportEmailUri('  '), isNull);
  });

  test('buildWhatsAppUri strips non-digits and encodes message', () {
    expect(
      buildWhatsAppUri(' +91 (987) 654-3210 ')?.toString(),
      'https://wa.me/919876543210',
    );
    expect(
      buildWhatsAppUri(
        '+919876543210',
        message: 'Hi, order please',
      )?.toString(),
      'https://wa.me/919876543210?text=Hi%2C+order+please',
    );
    expect(buildWhatsAppUri(' - () '), isNull);
  });
}
