// lib/src/orders/view/widget/order_horizontal_stepper.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:medpik/res/styles/color_palette.dart';
import 'package:medpik/res/enums/enums.dart';
import 'package:medpik/src/orders/view/widget/order_horizontal_stepper_node.dart';
import 'package:medpik/src/orders/view/widget/order_horizontal_stepper_painter.dart';
import 'package:medpik/utils/helpers/order_status_helper.dart';

class OrderHorizontalStepper extends StatefulWidget {
  const OrderHorizontalStepper({
    super.key,
    required this.steps,
    this.activeColor,
    this.inactiveColor,
  });

  final List<OrderHorizontalStep> steps;
  final Color? activeColor;
  final Color? inactiveColor;

  @override
  State<OrderHorizontalStepper> createState() => _OrderHorizontalStepperState();
}

class _OrderHorizontalStepperState extends State<OrderHorizontalStepper>
    with TickerProviderStateMixin {
  late final AnimationController _entranceController;
  late final AnimationController _pulseController;
  late final Animation<double> _entranceAnimation;

  @override
  void initState() {
    super.initState();
    _entranceController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    )..repeat(reverse: true);
    _entranceAnimation = CurvedAnimation(
      parent: _entranceController,
      curve: Curves.easeOutCubic,
    );
    _entranceController.forward();
  }

  @override
  void dispose() {
    _entranceController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  double _targetProgress(List<OrderHorizontalStep> steps) {
    final index = steps.indexWhere(
      (step) => step.state != OrderStepperNodeState.completed,
    );
    if (index < 0) return (steps.length - 1).toDouble();
    return switch (steps[index].state) {
      OrderStepperNodeState.current => index + 0.55,
      OrderStepperNodeState.failed => index + 0.2,
      OrderStepperNodeState.pending => index.toDouble(),
      OrderStepperNodeState.completed => index.toDouble(),
    };
  }

  int? _failedSegmentIndex(List<OrderHorizontalStep> steps) {
    final index = steps.indexWhere(
      (step) => step.state == OrderStepperNodeState.failed,
    );
    return index < 0 ? null : index;
  }

  List<Offset> _nodeCenters(double width) {
    if (widget.steps.isEmpty) return const [];
    final stepWidth = width / widget.steps.length;
    final centerY = 20.h;
    return List.generate(
      widget.steps.length,
      (index) => Offset(stepWidth * index + stepWidth / 2, centerY),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final activeColor = widget.activeColor ?? colors.primary;
    final inactiveColor =
        widget.inactiveColor ?? colors.inputBorder.withValues(alpha: 0.55);
    final strokeWidth = 3.h;

    return AnimatedBuilder(
      animation: Listenable.merge([_entranceAnimation, _pulseController]),
      builder: (context, _) {
        final progress =
            _targetProgress(widget.steps) * _entranceAnimation.value;

        return LayoutBuilder(
          builder: (context, constraints) {
            final centers = _nodeCenters(constraints.maxWidth);
            final lineY = centers.isEmpty ? 0.0 : centers.first.dy;

            return SizedBox(
              height: 74.h,
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  if (centers.length >= 2)
                    CustomPaint(
                      size: Size(constraints.maxWidth, 74.h),
                      painter: OrderStepperTrackPainter(
                        nodeCenters: centers,
                        progress: progress,
                        activeColor: activeColor,
                        inactiveColor: inactiveColor,
                        failedSegmentIndex: _failedSegmentIndex(widget.steps),
                        lineY: lineY,
                        strokeWidth: strokeWidth,
                      ),
                    ),
                  Row(
                    children: [
                      for (var i = 0; i < widget.steps.length; i++)
                        Expanded(
                          child: OrderHorizontalStepperNode(
                            step: widget.steps[i],
                            primaryColor: activeColor,
                            inactiveColor: inactiveColor,
                            pulseValue:
                                widget.steps[i].state ==
                                    OrderStepperNodeState.current
                                ? _pulseController.value
                                : 0,
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
