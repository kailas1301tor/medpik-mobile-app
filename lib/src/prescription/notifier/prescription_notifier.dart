// lib/src/prescription/notifier/prescription_notifier.dart
import 'package:either_dart/either.dart';
import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:tsuite/data/models/prescription_selected_product_model.dart';
import 'package:tsuite/res/constants/string_constants.dart';
import 'package:tsuite/res/enums/enums.dart';
import 'package:tsuite/services/repo_di.dart';
import 'package:tsuite/src/prescription/repo/prescription_repository.dart';
import 'package:tsuite/src/prescription/state/prescription_state.dart';
import 'package:tsuite/utils/common_widgets/custom_toast.dart';
import 'package:tsuite/utils/helpers/api_error_handler.dart';
import 'package:tsuite/utils/helpers/file_picker.dart';

part 'prescription_notifier.g.dart';

@Riverpod(keepAlive: true)
class PrescriptionNotifier extends _$PrescriptionNotifier {
  late final TextEditingController notesController;
  late PrescriptionRepo prescriptionRepo;
  final _fileService = FileSelectionService.instance;

  @override
  PrescriptionState build() {
    notesController = TextEditingController();
    prescriptionRepo = ref.read(prescriptionRepositoryProvider);

    ref.onDispose(() {
      notesController.dispose();
    });

    Future.microtask(loadDraft);
    return const PrescriptionState();
  }

  Future<void> loadDraft() async {
    await prescriptionRepo.getDraft().fold(
          (error) {
            debugPrint("🔴 PRESCRIPTION DRAFT ERROR: ${error.message}");
          },
          (draft) {
            if (draft != null) {
              notesController.text = draft.notes;
              state = state.copyWith(
                draft: draft,
                pickedPaths: List<String>.from(draft.filePaths),
                selectedProducts: List<PrescriptionSelectedProductModel>.from(
                  draft.selectedProducts,
                ),
              );
            }
          },
        );
  }

  Future<void> pickFromCamera() async {
    state = state.copyWith(loaderState: LoaderState.loading);
    try {
      final file = await _fileService.captureImage();
      if (file == null) {
        state = state.copyWith(loaderState: LoaderState.loaded);
        return;
      }
      _appendPaths([file.path]);
      state = state.copyWith(loaderState: LoaderState.loaded);
    } catch (e) {
      debugPrint("🔴 CAMERA PICK ERROR: $e");
      state = state.copyWith(loaderState: LoaderState.error);
    }
  }

  Future<void> pickFromGallery() async {
    state = state.copyWith(loaderState: LoaderState.loading);
    try {
      final files = await _fileService.pickMultipleImages();
      if (files.isEmpty) {
        state = state.copyWith(loaderState: LoaderState.loaded);
        return;
      }
      _appendPaths(files.map((f) => f.path).toList());
      state = state.copyWith(loaderState: LoaderState.loaded);
    } catch (e) {
      debugPrint("🔴 GALLERY PICK ERROR: $e");
      state = state.copyWith(loaderState: LoaderState.error);
    }
  }

  Future<void> pickFiles() async {
    state = state.copyWith(loaderState: LoaderState.loading);
    try {
      final files = await _fileService.pickFiles();
      if (files.isEmpty) {
        state = state.copyWith(loaderState: LoaderState.loaded);
        return;
      }
      _appendPaths(files.map((f) => f.path).toList());
      state = state.copyWith(loaderState: LoaderState.loaded);
    } catch (e) {
      debugPrint("🔴 FILE PICK ERROR: $e");
      state = state.copyWith(loaderState: LoaderState.error);
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

  Future<bool> submit() async {
    if (state.pickedPaths.isEmpty) {
      showCustomToast(
        message: Strings.atLeastOneFileRequired,
        isSuccess: false,
      );
      return false;
    }

    state = state.copyWith(loaderState: LoaderState.loading);

    return await prescriptionRepo
        .uploadPrescription(
          filePaths: state.pickedPaths,
          notes: notesController.text.trim(),
          selectedProducts: state.selectedProducts,
        )
        .fold(
          (error) {
            final loaderState = handleResponseError(error.key);
            debugPrint("🔴 UPLOAD PRESCRIPTION ERROR: ${error.message}");
            state = state.copyWith(loaderState: loaderState);
            showCustomToast(
              message: error.message ?? Strings.somethingWentWrong,
              isSuccess: false,
            );
            return false;
          },
          (draft) {
            debugPrint("🟢 PRESCRIPTION UPLOADED");
            state = state.copyWith(
              loaderState: LoaderState.loaded,
              draft: draft,
            );
            showCustomToast(
              message: Strings.prescriptionUploaded,
              isSuccess: true,
            );
            return true;
          },
        )
        .catchError((error) {
          debugPrint("🔴 UNEXPECTED UPLOAD ERROR: $error");
          state = state.copyWith(loaderState: LoaderState.error);
          return false;
        });
  }
}
