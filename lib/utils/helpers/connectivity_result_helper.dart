// lib/utils/helpers/connectivity_result_helper.dart
import 'package:connectivity_plus/connectivity_plus.dart';

/// True when the device reports at least one non-[ConnectivityResult.none]
/// interface. Does not prove internet reachability — only that a link exists.
bool isOnlineFromConnectivityResults(List<ConnectivityResult> results) {
  if (results.isEmpty) return false;
  return results.any((result) => result != ConnectivityResult.none);
}
