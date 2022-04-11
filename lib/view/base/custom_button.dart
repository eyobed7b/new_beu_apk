import 'package:efood_multivendor/helper/size_config.dart';
import 'package:efood_multivendor/util/dimensions.dart';
import 'package:efood_multivendor/util/styles.dart';
import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final Function onPressed;
  final String buttonText;
  final bool transparent;
  final EdgeInsets margin;
  final double height;
  final double width;
  final double fontSize;
  final double radius;
  final IconData icon;
  CustomButton(
      {this.onPressed,
      @required this.buttonText,
      this.transparent = false,
      this.margin,
      this.width,
      this.height,
      this.fontSize,
      this.radius = 5,
      this.icon});

  @override
  Widget build(BuildContext context) {
    final ButtonStyle _flatButtonStyle = TextButton.styleFrom(
      backgroundColor: onPressed == null
          ? Theme.of(context).disabledColor
          : transparent
              ? Colors.transparent
              : Theme.of(context).primaryColor,
      minimumSize: Size(width != null ? width : Dimensions.WEB_MAX_WIDTH,
          height != null ? height : 50),
      padding: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(radius),
      ),
    );

    return Center(
        child: SizedBox(
            width: width != null ? width : Dimensions.WEB_MAX_WIDTH * 2.9,
            child: Padding(
                padding: margin == null ? EdgeInsets.all(0) : margin,
                child: GestureDetector(
                  onTap: onPressed,
                  child: Container(
                    height: 6.h,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(radius),
                        color: transparent
                            ? Colors.transparent
                            : Theme.of(context).primaryColor,
                        gradient: LinearGradient(
                          colors: [Color(0xffff8022), Color(0xffff2222)],
                        )),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          icon != null
                              ? Padding(
                                  padding: EdgeInsets.only(
                                      right:
                                          Dimensions.PADDING_SIZE_EXTRA_SMALL),
                                  child: Icon(icon,
                                      color: transparent
                                          ? Theme.of(context).primaryColor
                                          : Theme.of(context).cardColor),
                                )
                              : SizedBox(),
                          Text(buttonText ?? '',
                              textAlign: TextAlign.center,
                              style: sfBold.copyWith(
                                color: transparent
                                    ? Theme.of(context).colorScheme.secondary
                                    : Theme.of(context).cardColor,
                                fontSize: fontSize != null
                                    ? fontSize
                                    : Dimensions.fontSizeLarge,
                              )),
                        ]),
                  ),
                ))));
  }
}
