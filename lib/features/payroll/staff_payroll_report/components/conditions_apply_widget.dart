import 'package:flutter/material.dart';

class ConditionsApplyWidget extends StatelessWidget {
  const ConditionsApplyWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Text('*'),
        Text(
          'This is a salary sheet of only one month',
          style: Theme.of(context).textTheme.bodySmall!
              .copyWith(color: Colors.black45),
        ),
      ],
    );
  }
}
