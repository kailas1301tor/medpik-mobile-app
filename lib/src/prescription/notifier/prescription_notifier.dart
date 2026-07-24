// lib/src/prescription/notifier/prescription_notifier.dart
import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:medpik/data/models/prescription_model.dart';
import 'package:medpik/data/models/prescription_selected_product_model.dart';
import 'package:medpik/res/constants/string_constants.dart';
import 'package:medpik/src/prescription/state/prescription_state.dart';
import 'package:medpik/utils/common_widgets/custom_toast.dart';
import 'package:medpik/utils/helpers/file_picker.dart';

part 'prescription_notifier.g.dart';

@Riverpod(keepAlive: true)
class PrescriptionNotifier extends _$PrescriptionNotifier {
  late final TextEditingController notesController;
  late final TextEditingController productQuantityController;
  final _fileService = FileSelectionService.instance;

  @override
  PrescriptionState build() {
    notesController = TextEditingController();
    productQuantityController = TextEditingController(
      text: Strings.defaultQuantityHint,
    );

    ref.onDispose(() {
      notesController.dispose();
      productQuantityController.dispose();
    });

    return const PrescriptionState();
  }

  void clearDraft() {
    notesController.clear();
    state = state.copyWith(
      draft: null,
      pickedPaths: const [],
      selectedProducts: const [],
      errorMessage: null,
    );
  }

  Future<void> pickFromCamera() async {
    state = state.copyWith(isPickingFiles: true, errorMessage: null);
    try {
      final file = await _fileService.captureImage();
      if (file == null) return;
      _appendPaths([file.path]);
    } catch (e) {
      debugPrint("🔴 CAMERA PICK ERROR: $e");
      showCustomToast(
        message: Strings.somethingWentWrong,
        isSuccess: false,
      );
    } finally {
      state = state.copyWith(isPickingFiles: false);
    }
  }

  Future<void> pickFromGallery() async {
    state = state.copyWith(isPickingFiles: true, errorMessage: null);
    try {
      final files = await _fileService.pickMultipleImages();
      if (files.isEmpty) return;
      _appendPaths(files.map((f) => f.path).toList());
    } catch (e) {
      debugPrint("🔴 GALLERY PICK ERROR: $e");
      showCustomToast(
        message: Strings.somethingWentWrong,
        isSuccess: false,
      );
    } finally {
      state = state.copyWith(isPickingFiles: false);
    }
  }

  Future<void> pickFiles() async {
    state = state.copyWith(isPickingFiles: true, errorMessage: null);
    try {
      final files = await _fileService.pickFiles();
      if (files.isEmpty) return;
      _appendPaths(files.map((f) => f.path).toList());
    } catch (e) {
      debugPrint("🔴 FILE PICK ERROR: $e");
      showCustomToast(
        message: Strings.somethingWentWrong,
        isSuccess: false,
      );
    } finally {
      state = state.copyWith(isPickingFiles: false);
    }
  }

  void removeFileAt(int index) {
    if (index < 0 || index >= state.pickedPaths.length) return;
    final updated = List<String>.from(state.pickedPaths)..removeAt(index);
    state = state.copyWith(pickedPaths: updated);
  }

  void _appendPaths(List<String> paths) {
    if (paths.isEmpty) return;
    final existing = state.pickedPaths.toSet();
    final updated = List<String>.from(state.pickedPaths);
    for (final path in paths) {
      if (!existing.contains(path)) {
        updated.add(path);
        existing.add(path);
      }
    }
    state = state.copyWith(pickedPaths: updated);
  }

  void appendMissingProductToDescription({
    required String name,
    required int quantity,
  }) {
    final trimmedName = name.trim();
    if (trimmedName.isEmpty || quantity < 1) return;

    final line = Strings.missingProductDescriptionLine(trimmedName, quantity);
    final current = notesController.text.trim();
    notesController.text = current.isEmpty ? line : '$current\n$line';
    debugPrint("🟢 MISSING PRODUCT APPENDED TO DESCRIPTION: $line");
  }

  void addOrUpdateSelectedProduct({
    required PrescriptionSelectedProductModel selectedProduct,
  }) {
    final updated = List<PrescriptionSelectedProductModel>.from(
      state.selectedProducts,
    );
    final existingIndex = updated.indexWhere(
      (item) => item.product.id == selectedProduct.product.id,
    );

    if (existingIndex >= 0) {
      updated[existingIndex] = updated[existingIndex].copyWith(
        quantity: selectedProduct.quantity,
      );
    } else {
      updated.add(selectedProduct);
    }

    state = state.copyWith(selectedProducts: updated);
  }

  void removeSelectedProduct(int productId) {
    state = state.copyWith(
      selectedProducts: state.selectedProducts
          .where((item) => item.product.id != productId)
          .toList(),
    );
  }

  int selectedProductQuantity(int productId) {
    for (final item in state.selectedProducts) {
      if (item.product.id == productId) return item.quantity;
    }
    return 0;
  }

  void prepareProductQuantityEditor(int productId) {
    final currentQty = selectedProductQuantity(productId);
    productQuantityController.text = '${currentQty < 1 ? 1 : currentQty}';
  }

  int parsedProductQuantity() {
    final parsed = int.tryParse(productQuantityController.text.trim());
    if (parsed == null || parsed < 1) return 1;
    return parsed;
  }

  Future<bool> submit() async {
    if (state.pickedPaths.isEmpty) {
      showCustomToast(
        message: Strings.atLeastOneFileRequired,
        isSuccess: false,
      );
      return false;
    }

    state = state.copyWith(isSubmitting: true, errorMessage: null);

    try {
      final draft = PrescriptionDraftModel(
        filePaths: List<String>.from(state.pickedPaths),
        notes: notesController.text.trim(),
        uploadedAt: DateTime.now(),
        selectedProducts: List<PrescriptionSelectedProductModel>.from(
          state.selectedProducts,
        ),
      );
      debugPrint("🟢 PRESCRIPTION DRAFT READY");
      state = state.copyWith(draft: draft);
      return true;
    } catch (e) {
      debugPrint("🔴 PRESCRIPTION SUBMIT ERROR: $e");
      showCustomToast(
        message: Strings.somethingWentWrong,
        isSuccess: false,
      );
      return false;
    } finally {
      state = state.copyWith(isSubmitting: false);
    }
  }
}
