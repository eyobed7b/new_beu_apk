import 'package:efood_multivendor/helper/size_config.dart';
import 'package:efood_multivendor/util/dimensions.dart';
import 'package:efood_multivendor/util/images.dart';
import 'package:efood_multivendor/util/styles.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NoDataScreen extends StatelessWidget {
  final bool isCart;
  final String text;
  final String images;
  NoDataScreen({@required this.text, this.isCart = false, this.images = ''});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(Dimensions.PADDING_SIZE_LARGE),
      child: Column(
          // mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(
              height: 20.h,
            ),
            Image.asset(
              images.isEmpty
                  ? isCart
                      ? Images.empty_cart
                      : Images.empty_box
                  : images,
              width: MediaQuery.of(context).size.height * 0.22,
              height: MediaQuery.of(context).size.height * 0.22,
            ),
            SizedBox(
              height: 5.h,
            ),
            Text(
              isCart ? 'cart_is_empty'.tr : text,
              style: sfMedium.copyWith(
                  fontSize: 2.1.h, color: Theme.of(context).disabledColor),
              textAlign: TextAlign.center,
            ),
          ]),
    );
  }
}
