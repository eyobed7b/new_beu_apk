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
          shaderCallback: (shade) {
            return LinearGradient(
              colors: [Color(0xffff8022), Color(0xffff2222)],
              tileMode: TileMode.mirror,
            ).createShader(shade);
          },
          child: CircularProgressIndicator.adaptive()),
    ));
  }
}
