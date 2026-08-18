// lib/src/emergency/view/emergency_services_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:medpik/res/constants/string_constants.dart';
import 'package:medpik/res/enums/enums.dart';
import 'package:medpik/res/styles/color_palette.dart';
import 'package:medpik/res/styles/font_palette.dart';
import 'package:medpik/src/emergency/notifier/emergency_notifier.dart';
import 'package:medpik/src/emergency/view/widget/emergency_services_shimmer_widget.dart';
import 'package:medpik/src/emergency/view/widget/emergency_services_tab_list.dart';
import 'package:medpik/utils/common_widgets/common_app_bar.dart';
import 'package:medpik/utils/common_widgets/common_refresh_indicator.dart';
import 'package:medpik/utils/common_widgets/common_scaffold.dart';
import 'package:medpik/utils/common_widgets/common_switch_state.dart';
import 'package:tuple/tuple.dart';

class EmergencyServicesScreen extends ConsumerWidget {
  const EmergencyServicesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = context.appColors;
    final notifier = ref.read(emergencyNotifierProvider.notifier);

    return DefaultTabController(
      length: 2,
      child: CommonScaffold(
        backgroundColor: colors.background,
        appBar: CommonAppBar(
          title: Strings.emergencyServices,
          bottom: TabBar(
            labelColor: colors.primary,
            unselectedLabelColor: colors.secondaryText,
            indicatorColor: colors.primary,
            labelStyle: FontPalette.base600(14, color: colors.primary),
            unselectedLabelStyle: FontPalette.base500(
              14,
              color: colors.secondaryText,
            ),
            tabs: const [
              Tab(text: Strings.ambulances),
              Tab(text: Strings.doctors),
            ],
          ),
        ),
        body: CommonRefreshIndicator(
          onRefresh: notifier.fetchEmergencyServices,
          child: const TabBarView(children: [_AmbulancesTab(), _DoctorsTab()]),
        ),
      ),
    );
  }
}

class _AmbulancesTab extends ConsumerWidget {
  const _AmbulancesTab();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final data = ref.watch(
      emergencyNotifierProvider.select(
        (s) => Tuple3(s.loaderState, s.isAmbulancesEmpty, s.ambulances),
      ),
    );
    final loaderState = data.item1;
    final isAmbulancesEmpty = data.item2;
    final ambulances = data.item3;
    final notifier = ref.read(emergencyNotifierProvider.notifier);

    return CommonSwitchState(
      loaderState: isAmbulancesEmpty ? LoaderState.noData : loaderState,
      reload: notifier.fetchEmergencyServices,
      loader: const EmergencyServicesShimmerWidget(),
      buttonText: Strings.refresh,
      emptyScreenTitle: Strings.noEmergencyServices,
      emptyScreenDescription: Strings.noEmergencyServicesDesc,
      child: EmergencyAmbulancesTabList(ambulances: ambulances),
    );
  }
}

class _DoctorsTab extends ConsumerWidget {
  const _DoctorsTab();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final data = ref.watch(
      emergencyNotifierProvider.select(
        (s) => Tuple3(s.loaderState, s.isDoctorsEmpty, s.doctors),
      ),
    );
    final loaderState = data.item1;
    final isDoctorsEmpty = data.item2;
    final doctors = data.item3;
    final notifier = ref.read(emergencyNotifierProvider.notifier);

    return CommonSwitchState(
      loaderState: isDoctorsEmpty ? LoaderState.noData : loaderState,
      reload: notifier.fetchEmergencyServices,
      loader: const EmergencyServicesShimmerWidget(),
      buttonText: Strings.refresh,
      emptyScreenTitle: Strings.noEmergencyServices,
      emptyScreenDescription: Strings.noEmergencyServicesDesc,
      child: EmergencyDoctorsTabList(doctors: doctors),
    );
  }
}
