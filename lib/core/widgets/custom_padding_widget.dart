import 'package:flutter/material.dart';

class CustomPaddingWidget extends StatelessWidget {
  const CustomPaddingWidget({
    super.key,
    this.pLeft = 0,
    this.pRight = 0,
    this.pTop = 0,
    this.pBottom = 0,
    required this.child,
  });

  final double pLeft;
  final double pRight;
  final double pTop;
  final double pBottom;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: pLeft,
        right: pRight,
        top: pTop,
        bottom: pBottom,
      ),
      child: child,
    );
  }
}
