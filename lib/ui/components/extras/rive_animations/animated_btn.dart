import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rive/rive.dart';

class AnimatedBtn extends StatelessWidget {
  const AnimatedBtn({
    Key? key,
    required RiveAnimationController btnAnimationController,
    required this.press,
    this.isLoading = false,
    required this.text,
  })  : _btnAnimationController = btnAnimationController,
        super(key: key);

  final RiveAnimationController _btnAnimationController;
  final void Function() press;
  final String text;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: isLoading ? null : press,
      child: SizedBox(
        height: 64,
        width: 236,
        child: Stack(
          children: [
            RiveAnimation.asset(
              "assets/rive/button.riv",
              controllers: [_btnAnimationController],
            ),
            Positioned.fill(
              top: 8,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Icon(CupertinoIcons.arrow_right),
                  const SizedBox(width: 8),
                  isLoading
                      ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(),
                  )
                      : Text(
                    text,
                    style: Theme.of(context).textTheme.button,
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
