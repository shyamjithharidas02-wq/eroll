import 'package:flutter/material.dart';

class EmptyStaffWidget extends StatelessWidget {
  final String image;
  final String label;

  const EmptyStaffWidget({super.key, required this.image, required this.label});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.maxFinite,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(image, height: 300),
          SizedBox(height: 15),
          Text(label, style: TextStyle(fontWeight: FontWeight.w700)),
        ],
      ),
    );
  }
}
