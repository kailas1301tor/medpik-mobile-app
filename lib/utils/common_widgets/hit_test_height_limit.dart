// lib/utils/common_widgets/hit_test_height_limit.dart
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

/// Only participates in hit testing within [hitHeight] from the top of the child.
///
/// Used so a full-bleed hero gallery can sit above a sheet scroll view while
/// still letting sheet gestures win in the overlapping curve region.
class HitTestHeightLimit extends SingleChildRenderObjectWidget {
  const HitTestHeightLimit({
    super.key,
    required this.hitHeight,
    super.child,
  });

  final double hitHeight;

  @override
  RenderHitTestHeightLimit createRenderObject(BuildContext context) {
    return RenderHitTestHeightLimit(hitHeight: hitHeight);
  }

  @override
  void updateRenderObject(
    BuildContext context,
    RenderHitTestHeightLimit renderObject,
  ) {
    renderObject.hitHeight = hitHeight;
  }
}

class RenderHitTestHeightLimit extends RenderProxyBox {
  RenderHitTestHeightLimit({required double hitHeight})
      : _hitHeight = hitHeight;

  double _hitHeight;

  double get hitHeight => _hitHeight;

  set hitHeight(double value) {
    if (_hitHeight == value) return;
    _hitHeight = value;
  }

  @override
  bool hitTest(BoxHitTestResult result, {required Offset position}) {
    if (position.dy < 0 || position.dy > _hitHeight) {
      return false;
    }
    return super.hitTest(result, position: position);
  }
}
