import 'package:efood_multivendor/helper/responsive_helper.dart';
import 'package:efood_multivendor/util/dimensions.dart';
import 'package:efood_multivendor/util/styles.dart';
import 'package:flutter/material.dart';
import 'package:get/utils.dart';

class TitleWidget extends StatelessWidget {
  final String title;
  final Function onTap;
  TitleWidget({@required this.title, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      Text(title, style: sfMedium.copyWith(fontSize: Dimensions.fontSizeLarge)),
      (onTap != null && !ResponsiveHelper.isDesktop(context))
          ? InkWell(
              onTap: onTap,
              child: Padding(
                padding: EdgeInsets.fromLTRB(10, 5, 0, 5),
                child: ShaderMask(
                  shaderCallback: (shade) {
                    return LinearGradient(
                      colors: [Color(0xffff8022), Color(0xffff2222)],
                      tileMode: TileMode.mirror,
                    ).createShader(shade);
                  },
                  child: Text('view_all'.tr,
                      style: TextStyle(
                          fontSize: Dimensions.PADDING_SIZE_DEFAULT,
                          color: Colors.white)),
                ),
              ),
            )
          : SizedBox(),
    ]);
  }
}
