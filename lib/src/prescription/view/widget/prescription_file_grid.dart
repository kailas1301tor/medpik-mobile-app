// lib/src/prescription/view/widget/prescription_file_grid.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tsuite/src/prescription/notifier/prescription_notifier.dart';
import 'package:tsuite/src/prescription/view/widget/prescription_add_more_tile.dart';
import 'package:tsuite/src/prescription/view/widget/prescription_file_tile.dart';
import 'package:tsuite/src/prescription/view/widget/prescription_source_sheet.dart';

class PrescriptionFileGrid extends ConsumerWidget {
  const PrescriptionFileGrid({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pickedPaths = ref.watch(
      prescriptionNotifierProvider.select((s) => s.pickedPaths),
    );
    final notifier = ref.read(prescriptionNotifierProvider.notifier);

    if (pickedPaths.isEmpty) return const SizedBox.shrink();

    return Padding(
      padding: EdgeInsets.only(top: 16.h),
      child: Wrap(
        spacing: 12.w,
        runSpacing: 12.h,
        children: [
          for (var i = 0; i < pickedPaths.length; i++)
            PrescriptionFileTile(
              filePath: pickedPaths[i],
              onRemove: () => notifier.removeFileAt(i),
            ),
          PrescriptionAddMoreTile(
            onTap: () => PrescriptionSourceSheet.show(context, ref),
          ),
        ],
      ),
    );
  }
}
