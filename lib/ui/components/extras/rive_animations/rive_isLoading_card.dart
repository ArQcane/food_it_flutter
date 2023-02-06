import 'package:flutter/material.dart';
import 'package:food_it_flutter/ui/components/extras/gradient_text.dart';
import 'package:rive/rive.dart';

class RiveIsLoadingContainer extends StatefulWidget {
  const RiveIsLoadingContainer({Key? key}) : super(key: key);

  @override
  State<RiveIsLoadingContainer> createState() => _RiveIsLoadingContainerState();
}

class _RiveIsLoadingContainerState extends State<RiveIsLoadingContainer> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children:
      [
        Container(
        alignment: Alignment.center,
        child: RiveAnimation.asset(
          "assets/rive/material_loader.riv",
              animations: ["animate"],
              fit: BoxFit.contain,
        ),
      ),
        Positioned(left: 50,bottom: 100, child:GradientText(text: "Please wait while we load...",))
    ],
    );
  }
}
