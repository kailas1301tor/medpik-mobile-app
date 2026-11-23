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

/// Skips hit testing in the top [skipHeight] of [child], then defers to the child.
///
/// Lets a sheet [CustomScrollView] paint over a hero gallery while still allowing
/// the gallery [PageView] underneath to receive horizontal swipes. [IgnorePointer]
/// on a spacer sliver is not enough — [Scrollable] uses opaque hit testing.
class HitTestSkipTop extends SingleChildRenderObjectWidget {
  const HitTestSkipTop({
    super.key,
    required this.skipHeight,
    super.child,
  });

  final double skipHeight;

  @override
  RenderHitTestSkipTop createRenderObject(BuildContext context) {
    return RenderHitTestSkipTop(skipHeight: skipHeight);
  }

  @override
  void updateRenderObject(
    BuildContext context,
    RenderHitTestSkipTop renderObject,
  ) {
    renderObject.skipHeight = skipHeight;
  }
}

class RenderHitTestSkipTop extends RenderProxyBox {
  RenderHitTestSkipTop({required double skipHeight}) : _skipHeight = skipHeight;

  double _skipHeight;

  double get skipHeight => _skipHeight;

  set skipHeight(double value) {
    if (_skipHeight == value) return;
    _skipHeight = value;
  }

  @override
  bool hitTest(BoxHitTestResult result, {required Offset position}) {
    if (position.dy < _skipHeight) {
      return false;
    }
    return super.hitTest(result, position: position);
  }
}
