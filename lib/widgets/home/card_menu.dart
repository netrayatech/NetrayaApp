import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class CardMenu extends StatelessWidget {
  const CardMenu({
    Key? key,
    required this.assetPath,
    required this.text,
    required this.onTap,
  }) : super(key: key);
  final String assetPath;
  final String text;
  final Function() onTap;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Material(
        borderRadius: BorderRadius.circular(8),
        color: Colors.white,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(8),
          child: Container(
            height: 156,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SvgPicture.asset(
                  assetPath,
                  width: 55,
                ),
                const SizedBox(
                  height: 16,
                ),
                Text(text),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
