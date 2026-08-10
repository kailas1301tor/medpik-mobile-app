// lib/utils/helpers/legal_url_helper.dart
import 'package:flutter/material.dart';
import 'package:medpik/data/models/legal_document_args.dart';
import 'package:medpik/res/constants/app_constants.dart';
import 'package:medpik/res/constants/string_constants.dart';
import 'package:medpik/utils/routes/route_constants.dart';

void openPrivacyPolicy(BuildContext context) {
  openLegalDocument(
    context,
    title: Strings.privacyPolicy,
    url: AppConstants.privacyPolicyUrl,
  );
}

void openTermsAndConditions(BuildContext context) {
  openLegalDocument(
    context,
    title: Strings.termsAndConditions,
    url: AppConstants.termsAndConditionsUrl,
  );
}

void openLegalDocument(
  BuildContext context, {
  required String title,
  required String url,
}) {
  Navigator.pushNamed(
    context,
    RouteConstants.routeLegalDocumentScreen,
    arguments: LegalDocumentArgs(title: title, url: url),
  );
}
