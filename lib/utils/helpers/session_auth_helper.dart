// lib/utils/helpers/session_auth_helper.dart
import 'package:flutter/material.dart';
import 'package:medpik/res/constants/app_constants.dart';
import 'package:medpik/utils/routes/route_constants.dart';

bool requireLogin(BuildContext context) {
  if (AppConstants.hasSession) return true;
  Navigator.pushNamed(context, RouteConstants.routeLoginScreen);
  return false;
}
