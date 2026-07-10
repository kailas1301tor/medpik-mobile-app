import 'package:flutter/material.dart';

/// A reusable loading indicator widget.
class CommonLoader extends StatelessWidget {
  final double size;
  final Color? color;
  final double strokeWidth;

  const CommonLoader({
    super.key,
    this.size = 40,
    this.color,
    this.strokeWidth = 3,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: size,
        height: size,
        child: CircularProgressIndicator.adaptive(
          strokeWidth: strokeWidth,
          valueColor: AlwaysStoppedAnimation<Color>(
            color ?? Theme.of(context).primaryColor,
          ),
        ),
      ),
    );
  }
}
