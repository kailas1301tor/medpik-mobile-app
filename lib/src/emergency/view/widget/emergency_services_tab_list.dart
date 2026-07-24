// lib/src/emergency/view/widget/emergency_services_tab_list.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:medpik/res/constants/string_constants.dart';
import 'package:medpik/src/emergency/model/emergency_services_model.dart';
import 'package:medpik/src/emergency/view/widget/emergency_service_tile.dart';
import 'package:medpik/utils/common_widgets/common_empty_state.dart';

class EmergencyAmbulancesTabList extends StatelessWidget {
  const EmergencyAmbulancesTabList({
    super.key,
    required this.ambulances,
  });

  final List<EmergencyAmbulanceModel> ambulances;

  @override
  Widget build(BuildContext context) {
    if (ambulances.isEmpty) {
      return CommonEmptyState(
        title: Strings.noAmbulances,
        message: Strings.noAmbulancesDesc,
      );
    }

    return ListView.builder(
      padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 24.h),
      itemCount: ambulances.length,
      addAutomaticKeepAlives: false,
      addRepaintBoundaries: false,
      itemBuilder: (context, index) {
        final ambulance = ambulances[index];
        return EmergencyServiceTile(
          name: ambulance.name,
          phoneNumber: ambulance.phoneNumber,
          locationLine: ambulance.locationDetail?.displayLine ?? '',
          leadingIcon: Icons.local_hospital_outlined,
        );
      },
    );
  }
}

class EmergencyDoctorsTabList extends StatelessWidget {
  const EmergencyDoctorsTabList({
    super.key,
    required this.doctors,
  });

  final List<EmergencyDoctorModel> doctors;

  @override
  Widget build(BuildContext context) {
    if (doctors.isEmpty) {
      return CommonEmptyState(
        title: Strings.noDoctors,
        message: Strings.noDoctorsDesc,
      );
    }

    return ListView.builder(
      padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 24.h),
      itemCount: doctors.length,
      addAutomaticKeepAlives: false,
      addRepaintBoundaries: false,
      itemBuilder: (context, index) {
        final doctor = doctors[index];
        return EmergencyServiceTile(
          name: doctor.name,
          phoneNumber: doctor.phoneNumber,
          locationLine: doctor.locationDetail?.displayLine ?? '',
          designation: doctor.designation,
          leadingIcon: Icons.medical_services_outlined,
        );
      },
    );
  }
}
