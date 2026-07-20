// lib/src/home/view/widget/home_offer_carousel.dart
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smooth_corner/smooth_corner.dart';
import 'package:tsuite/res/constants/string_constants.dart';
import 'package:tsuite/res/styles/color_palette.dart';
import 'package:tsuite/res/styles/font_palette.dart';
import 'package:tsuite/src/home/model/home_model.dart';
import 'package:tsuite/utils/helpers/hex_color_helper.dart';

part 'home_offer_carousel_state.dart';
part 'home_offer_carousel_autoscroll.dart';
part 'home_offer_carousel_banner_card.dart';
part 'home_offer_carousel_indicators.dart';

class HomeOfferCarousel extends StatefulWidget {
  const HomeOfferCarousel({
    super.key,
    required this.offers,
    this.onOfferTap,
  });

  final List<OfferModel> offers;
  final ValueChanged<OfferModel>? onOfferTap;

  @override
  State<HomeOfferCarousel> createState() => _HomeOfferCarouselState();
}
