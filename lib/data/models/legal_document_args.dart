// lib/data/models/legal_document_args.dart
class LegalDocumentArgs {
  const LegalDocumentArgs({
    required this.title,
    required this.url,
  });

  final String title;
  final String url;

  static LegalDocumentArgs from(Object? arguments) {
    if (arguments is LegalDocumentArgs) return arguments;
    throw ArgumentError('LegalDocumentArgs required for legal document route');
  }
}
