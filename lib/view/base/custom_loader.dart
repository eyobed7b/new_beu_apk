import 'package:efood_multivendor/util/dimensions.dart';
import 'package:flutter/material.dart';

class CustomLoader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
        child: Container(
      height: 100,
      width: 100,
      decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(Dimensions.RADIUS_SMALL)),
      alignment: Alignment.center,
      child: ShaderMask(
          shaderCallback: (Rect bounds) {
            return RadialGradient(
              center: Alignment.topLeft,
              radius: 0.5,
              colors: <Color>[Color(0xffff8022), Color(0xffff2222)],
              tileMode: TileMode.repeated,
            ).createShader(bounds);
          },
          child: CircularProgressIndicator.adaptive()),
    ));
  }
}
