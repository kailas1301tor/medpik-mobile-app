// lib/data/models/prescription_model.dart
import 'package:medpik/data/models/prescription_selected_product_model.dart';
import 'package:medpik/utils/helpers/safe_converters.dart';

class PrescriptionDraftModel {
  const PrescriptionDraftModel({
    required this.filePaths,
    this.notes = '',
    required this.uploadedAt,
    this.selectedProducts = const [],
  });

  final List<String> filePaths;
  final String notes;
  final DateTime uploadedAt;
  final List<PrescriptionSelectedProductModel> selectedProducts;

  factory PrescriptionDraftModel.fromJson(Map<String, dynamic> json) {
    final rawPaths = convertToList(json['file_paths']);
    final legacyPath = convertToString(json['file_path']);

    final paths = rawPaths.isNotEmpty
        ? rawPaths.map((e) => convertToString(e)).where((e) => e.isNotEmpty).toList()
        : legacyPath.isNotEmpty
            ? [legacyPath]
            : <String>[];

    return PrescriptionDraftModel(
      filePaths: paths,
      notes: convertToString(json['notes']),
      uploadedAt: DateTime.tryParse(convertToString(json['uploaded_at'])) ??
          DateTime.now(),
      selectedProducts: convertToList(json['selected_products'])
          .map(
            (item) => PrescriptionSelectedProductModel.fromJson(
              convertToMap(item),
            ),
          )
          .toList(),
    );
  }
}
