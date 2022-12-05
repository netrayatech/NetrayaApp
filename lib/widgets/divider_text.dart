import 'package:flutter/material.dart';

class DividerText extends StatelessWidget {
  const DividerText({
    Key? key,
    required this.text,
  }) : super(key: key);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Expanded(
          child: Divider(
            height: 1,
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(text),
        ),
        const Expanded(
          child: Divider(
            height: 1,
          ),
        ),
      ],
    );
  }
}
