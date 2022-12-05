import 'package:flutter/material.dart';

class BottomSheetItem extends StatelessWidget {
  final String text;
  final String currentValue;
  final Function callback;
  const BottomSheetItem(
      {super.key,
      required this.text,
      required this.currentValue,
      required this.callback});

  @override
  Widget build(BuildContext context) {
    return InkWell(
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color:
                currentValue == text ? Colors.red.shade700 : Colors.grey[200],
          ),
          padding: const EdgeInsets.all(10),
          child: Text(
            text,
            style: TextStyle(
                color: currentValue == text ? Colors.white : Colors.black,
                fontSize: 12),
          ),
        ),
        onTap: () => callback(text));
  }
}
