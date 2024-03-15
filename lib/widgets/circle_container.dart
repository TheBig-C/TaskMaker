import 'package:flutter/material.dart';

class CircleContainer extends StatelessWidget {
  const CircleContainer({
    Key? key,
    this.child,
    required this.color, // Make color required
    this.borderWidth,
    this.borderColor,
  }) : super(key: key);

  final Widget? child;
  final Color color; // Make color non-nullable
  final double? borderWidth;
  final Color? borderColor;

  @override
  Widget build(BuildContext context) {
    final effectiveColor = color;

    return Container(
      padding: const EdgeInsets.all(9),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Color.fromARGB(255, 243, 242, 242), // Soft green color
        border: Border.all(
          width: borderWidth ?? 2,
          color: effectiveColor,
        ),
      ),
      child: Center(
        child: child,
      ),
    );
  }
}
