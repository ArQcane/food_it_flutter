import 'package:flutter/material.dart';
import 'package:food_it_flutter/ui/theme/colors.dart';
import 'package:rive/rive.dart';

class RiveEmptyFavouritesAnimation extends StatelessWidget {
  const RiveEmptyFavouritesAnimation({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: background,
        height: MediaQuery.of(context).size.height - 300,
        width: MediaQuery
            .of(context)
            .size
            .width,
        child: Stack(
          children: [
            const RiveAnimation.asset(
              "assets/rive/1465-2853-sea-salt-ice-cream.riv",
            ),
          ],
        )
    );
  }
}