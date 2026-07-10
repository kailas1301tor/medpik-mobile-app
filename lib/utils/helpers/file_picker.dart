// lib/utils/helpers/file_picker.dart
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:tsuite/res/constants/app_constants.dart';
import 'package:tsuite/utils/common_widgets/custom_toast.dart';

class FileSelectionService {
  FileSelectionService._();

  static final FileSelectionService _instance = FileSelectionService._();
  static FileSelectionService get instance => _instance;

  final ImagePicker _picker = ImagePicker();

  static const double _maxDimension = 800;
  static const int _pickQuality = 50;

  static const _imageExtensions = ['.png', '.heic', '.jpg', '.jpeg'];
  static const _documentExtensions = ['pdf', 'doc', 'docx', 'png', 'jpg', 'jpeg'];

  Future<File?> _validateImage(File file) async {
    try {
      if (!await file.exists()) {
        showCustomToast(
          message: 'Could not access the selected file.',
          isSuccess: false,
        );
        return null;
      }

      final ext = p.extension(file.path).toLowerCase();
      if (!_imageExtensions.contains(ext)) {
        showCustomToast(message: 'Unsupported file type.', isSuccess: false);
        return null;
      }

      final sizeKb = (await file.length()) / 1024;
      if (sizeKb > AppConstants.maxImageSizeMb * 1024) {
        showCustomToast(
          message: 'File too large (max ${AppConstants.maxImageSizeMb} MB).',
          isSuccess: false,
        );
        return null;
      }

      return file;
    } catch (_) {
      showCustomToast(message: 'File processing failed.', isSuccess: false);
      return null;
    }
  }

  Future<File?> _validateDocument(File file) async {
    try {
      if (!await file.exists()) {
        showCustomToast(
          message: 'Could not access the selected file.',
          isSuccess: false,
        );
        return null;
      }

      if (await file.length() > AppConstants.maxImageSizeMb * 1024 * 1024) {
        showCustomToast(
          message: 'File too large (max ${AppConstants.maxImageSizeMb} MB).',
          isSuccess: false,
        );
        return null;
      }

      return file;
    } catch (_) {
      showCustomToast(message: 'File processing failed.', isSuccess: false);
      return null;
    }
  }

  Future<File?> pickImage() async {
    try {
      final pickedFile = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: _pickQuality,
        maxWidth: _maxDimension,
        maxHeight: _maxDimension,
      );

      if (pickedFile == null) return null;
      return await _validateImage(File(pickedFile.path));
    } catch (_) {
      showCustomToast(message: 'Image picking failed.', isSuccess: false);
      return null;
    }
  }

  Future<List<File>> pickMultipleImages() async {
    try {
      final pickedFiles = await _picker.pickMultiImage(
        imageQuality: _pickQuality,
        maxWidth: _maxDimension,
        maxHeight: _maxDimension,
      );
      if (pickedFiles.isEmpty) return [];

      final results = <File>[];

      for (final xFile in pickedFiles) {
        final file = File(xFile.path);
        final safeCopy = await _copyToTemp(file);
        if (safeCopy == null) continue;

        try {
          final validated = await _validateImage(safeCopy);
          if (validated != null) results.add(validated);
        } catch (_) {
          await _safeDelete(safeCopy);
        }
      }

      return results;
    } catch (_) {
      showCustomToast(message: 'Image picking failed.', isSuccess: false);
      return [];
    }
  }

  Future<File?> captureImage() async {
    try {
      final pickedFile = await _picker.pickImage(
        source: ImageSource.camera,
        imageQuality: _pickQuality,
        maxWidth: _maxDimension,
        maxHeight: _maxDimension,
      );

      if (pickedFile == null) return null;

      final safeCopy = await _copyToTemp(File(pickedFile.path));
      if (safeCopy == null) return null;

      return await _validateImage(safeCopy);
    } on PlatformException catch (_) {
      showCustomToast(
        message: 'Please allow camera access from settings.',
        isSuccess: false,
      );
    } catch (_) {
      showCustomToast(message: 'Camera failed.', isSuccess: false);
    }
    return null;
  }

  Future<List<File>> pickFiles({
    List<String>? allowedExtensions,
    bool allowMultiple = true,
  }) async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: allowedExtensions ?? _documentExtensions,
        allowMultiple: allowMultiple,
      );

      if (result == null || result.files.isEmpty) return [];

      final results = <File>[];

      for (final platformFile in result.files) {
        final path = platformFile.path;
        if (path == null) continue;

        final file = File(path);
        final ext = p.extension(path).toLowerCase();

        if (_imageExtensions.contains(ext)) {
          final validated = await _validateImage(file);
          if (validated != null) results.add(validated);
        } else {
          final validated = await _validateDocument(file);
          if (validated != null) results.add(validated);
        }
      }

      return results;
    } on PlatformException catch (_) {
      showCustomToast(
        message: 'Please allow storage access from settings.',
        isSuccess: false,
      );
    } catch (_) {
      showCustomToast(message: 'File selection failed.', isSuccess: false);
    }
    return [];
  }

  Future<File?> _copyToTemp(File source) async {
    try {
      if (!await source.exists()) return null;
      final tempDir = await getTemporaryDirectory();
      final dest = p.join(
        tempDir.path,
        '${DateTime.now().microsecondsSinceEpoch}_${p.basename(source.path)}',
      );
      return await source.copy(dest);
    } catch (_) {
      return null;
    }
  }

  static Future<void> _safeDelete(File? file) async {
    try {
      if (file != null && await file.exists()) await file.delete();
    } catch (_) {}
  }

  Future<void> clearTempImages() async {
    try {
      final tempDir = await getTemporaryDirectory();
      final entities = await tempDir.list().toList();
      for (final entity in entities) {
        if (entity is File && p.basename(entity.path).contains('_compressed')) {
          await _safeDelete(entity);
        }
      }
    } catch (_) {}
  }
}

bool isImageFilePath(String path) {
  final ext = p.extension(path).toLowerCase();
  return const ['.png', '.heic', '.jpg', '.jpeg', '.webp', '.gif']
      .contains(ext);
}
