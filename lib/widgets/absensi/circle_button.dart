import 'package:flutter/material.dart';
import 'package:netraya/constants/app_colors.dart';

class CircleButton extends StatelessWidget {
  const CircleButton({Key? key, required this.onPressed, required this.child})
      : super(key: key);
  final Function() onPressed;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 170,
      height: 170,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: AppColors.red,
        gradient: const LinearGradient(colors: [
          Color.fromRGBO(205, 81, 55, 1),
          Color.fromRGBO(205, 32, 45, 1),
        ], begin: Alignment.topLeft, end: Alignment.bottomRight),
        boxShadow: [
          BoxShadow(
            offset: const Offset(0, 0),
            blurRadius: 50,
            spreadRadius: 1,
            color: Colors.red[100]!,
          ),
        ],
      ),
      child: ElevatedButton(
        style: ButtonStyle(
          shape: MaterialStateProperty.all<CircleBorder>(
            const CircleBorder(),
          ),
          backgroundColor: MaterialStateProperty.all(Colors.transparent),
          shadowColor: MaterialStateProperty.all(Colors.transparent),
          elevation: MaterialStateProperty.all(0),
        ),
        onPressed: onPressed,
        child: child,
      ),
    );
  }
}
