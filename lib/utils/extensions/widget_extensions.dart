// lib/utils/extensions/widget_extensions.dart
import 'package:flutter/material.dart';

extension WidgetExtension on Widget {
  Widget paddingAll(double value) =>
      Padding(padding: EdgeInsets.all(value), child: this);

  Widget paddingSymmetric({double h = 0, double v = 0}) => Padding(
        padding: EdgeInsets.symmetric(horizontal: h, vertical: v),
        child: this,
      );

  Widget paddingOnly({
    double left = 0,
    double top = 0,
    double right = 0,
    double bottom = 0,
  }) =>
      Padding(
        padding: EdgeInsets.only(
            left: left, top: top, right: right, bottom: bottom),
        child: this,
      );

  Widget get center => Center(child: this);
  Widget get expanded => Expanded(child: this);
  Widget get flexible => Flexible(child: this);

  Widget opacity(double value) =>
      Opacity(opacity: value.clamp(0.0, 1.0), child: this);

  Widget onTap(VoidCallback onTap) => GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.opaque,
        child: this,
      );

  Widget visible(bool isVisible) =>
      Visibility(visible: isVisible, child: this);

  Widget sizedBox({double? width, double? height}) =>
      SizedBox(width: width, height: height, child: this);
}

extension AlignExtension on Widget {
  Widget align(Alignment alignment) =>
      Align(alignment: alignment, child: this);

  Widget get alignTopLeft => align(Alignment.topLeft);
  Widget get alignTopRight => align(Alignment.topRight);
  Widget get alignTopCenter => align(Alignment.topCenter);
  Widget get alignBottomLeft => align(Alignment.bottomLeft);
  Widget get alignBottomRight => align(Alignment.bottomRight);
  Widget get alignBottomCenter => align(Alignment.bottomCenter);
  Widget get alignCenterLeft => align(Alignment.centerLeft);
  Widget get alignCenterRight => align(Alignment.centerRight);
}

extension ClipExtension on Widget {
  Widget clipRRect(double radius) => ClipRRect(
        borderRadius: BorderRadius.circular(radius),
        child: this,
      );

  Widget clipOval() => ClipOval(child: this);

  Widget clipRect() => ClipRect(child: this);

  Widget withBorder({
    double radius = 8,
    Color color = Colors.grey,
    double width = 1,
  }) =>
      DecoratedBox(
        decoration: BoxDecoration(
          border: Border.all(color: color, width: width),
          borderRadius: BorderRadius.circular(radius),
        ),
        child: this,
      );
}

extension BorderRadiusExtension on double {
  BorderRadius get allRounded => BorderRadius.circular(this);

  BorderRadius get topRounded =>
      BorderRadius.vertical(top: Radius.circular(this));

  BorderRadius get bottomRounded =>
      BorderRadius.vertical(bottom: Radius.circular(this));

  BorderRadius get leftRounded =>
      BorderRadius.horizontal(left: Radius.circular(this));

  BorderRadius get rightRounded =>
      BorderRadius.horizontal(right: Radius.circular(this));

  BorderRadius get pill => BorderRadius.circular(999);
}

extension GradientExtension on List<Color> {
  LinearGradient toLinearGradient({
    AlignmentGeometry begin = Alignment.centerLeft,
    AlignmentGeometry end = Alignment.centerRight,
  }) =>
      LinearGradient(colors: this, begin: begin, end: end);

  LinearGradient toVerticalGradient() => LinearGradient(
        colors: this,
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      );

  RadialGradient toRadialGradient({double radius = 0.5}) =>
      RadialGradient(colors: this, radius: radius);
}

extension EdgeInsetsExtension on EdgeInsets {
  EdgeInsets addBottom(double value) => copyWith(bottom: bottom + value);
  EdgeInsets addTop(double value) => copyWith(top: top + value);
}

extension SizeExtension on Size {
  bool get isPortrait => height > width;
  bool get isLandscape => width > height;
  double get aspectRatio => width / height;
  Offset get center => Offset(width / 2, height / 2);
}

extension OffsetExtension on Offset {
  double distanceTo(Offset other) {
    final dx = this.dx - other.dx;
    final dy = this.dy - other.dy;
    return (dx * dx + dy * dy);
  }
}
