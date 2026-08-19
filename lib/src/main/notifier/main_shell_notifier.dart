// lib/src/main/notifier/main_shell_notifier.dart
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:medpik/providers/cart_providers.dart';
import 'package:medpik/providers/wishlist_providers.dart';
import 'package:medpik/res/constants/string_constants.dart';
import 'package:medpik/services/onesignal_service.dart';
import 'package:medpik/src/home/notifier/home_notifier.dart';
import 'package:medpik/utils/common_widgets/custom_toast.dart';

part 'main_shell_notifier.g.dart';

@Riverpod(keepAlive: false)
class MainShellNotifier extends _$MainShellNotifier {
  DateTime? _lastBackPressTime;
  bool _didBootstrap = false;

  @override
  int build() {
    ref.onDispose(() {
      _didBootstrap = false;
    });

    Future.microtask(_bootstrapSessionData);
    return 0;
  }

  Future<void> _bootstrapSessionData() async {
    if (_didBootstrap) return;
    _didBootstrap = true;

    final oneSignal = ref.read(oneSignalServiceProvider);
    await oneSignal.initialize();
    await oneSignal.requestNotificationPermission();
    await oneSignal.refreshDeviceRegistration();
    await oneSignal.registerDeviceWithBackend();
    await ref.read(homeNotifierProvider.notifier).fetchCustomerGeneralData();
    ref.read(cartNotifierProvider.notifier).fetchCart(showLoader: true);
    ref.read(wishlistNotifierProvider.notifier).fetchWishlist(showLoader: true);
    ref.read(homeNotifierProvider.notifier).fetchHomeFeed();
  }

  void setTab(int index) => state = index;

  bool handleBackPress() {
    if (state != 0) {
      state = 0;
      return false;
    }

    final now = DateTime.now();
    const doubleTapDuration = Duration(seconds: 2);

    if (_lastBackPressTime == null ||
        now.difference(_lastBackPressTime!) > doubleTapDuration) {
      _lastBackPressTime = now;
      showCustomToast(message: Strings.pressBackAgainToExit);
      return false;
    }
    return true;
  }
}
