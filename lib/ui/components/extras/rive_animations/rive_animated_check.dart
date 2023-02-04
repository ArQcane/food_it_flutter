import 'package:flutter/material.dart';
import 'package:rive/rive.dart';

class RiveAnimationCheck extends StatelessWidget {
  const RiveAnimationCheck({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      width: 80,
      height: 80,
      child: const RiveAnimation.asset('assets/rive/check-button.riv'),
    );
  }
}
