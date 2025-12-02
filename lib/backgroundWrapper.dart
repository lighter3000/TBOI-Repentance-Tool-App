import 'package:flutter/material.dart';

class Backgroundwrapper extends StatelessWidget{
  final Widget child;

  const Backgroundwrapper({required this.child});
  
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(
          child: Image.asset(
            "assets/images/background_desc.png",
            centerSlice: Rect.fromLTWH(60, 60, 340, 200),
            fit: BoxFit.fill,
          ),
        ),
        child,
      ],
    );
  }

  
}