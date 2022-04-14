import 'dart:async';

import 'package:efood_multivendor/helper/responsive_helper.dart';
import 'package:efood_multivendor/helper/route_helper.dart';
import 'package:efood_multivendor/helper/size_config.dart';
import 'package:efood_multivendor/util/dimensions.dart';
import 'package:efood_multivendor/util/images.dart';
import 'package:efood_multivendor/util/styles.dart';
import 'package:efood_multivendor/view/base/custom_button.dart';
import 'package:efood_multivendor/view/base/web_menu_bar.dart';
import 'package:efood_multivendor/view/screens/checkout/widget/payment_failed_dialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OrderSuccessfulScreen extends StatelessWidget {
  final String orderID;
  final int status;
  OrderSuccessfulScreen({@required this.orderID, @required this.status});

  @override
  Widget build(BuildContext context) {
    if (status == 0) {
      Future.delayed(Duration(seconds: 1), () {
        Get.dialog(PaymentFailedDialog(orderID: orderID),
            barrierDismissible: false);
      });
    }
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: ResponsiveHelper.isDesktop(context) ? WebMenuBar() : null,
      body: Center(
          child: SizedBox(
              width: Dimensions.WEB_MAX_WIDTH,
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                        status == 1 ? Images.order_placed : Images.warning,
                        width: 27.h,
                        height: 27.h),
                    SizedBox(height: Dimensions.PADDING_SIZE_LARGE),
                    Text(
                      status == 1
                          ? 'you_placed_the_order_successfully'.tr
                          : 'your_order_is_failed_to_place'.tr,
                      style: sfMedium.copyWith(
                          fontSize: Dimensions.fontSizeLarge * 1.5),
                    ),
                    SizedBox(height: Dimensions.PADDING_SIZE_SMALL),
                    Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: Dimensions.PADDING_SIZE_LARGE,
                          vertical: Dimensions.PADDING_SIZE_SMALL),
                      child: Text(
                        status == 1
                            ? 'your_order_is_placed_successfully'.tr
                            : 'your_order_is_failed_to_place_because'.tr,
                        style: sfMedium.copyWith(
                            fontSize: Dimensions.fontSizeSmall * 1.3,
                            color: Theme.of(context).disabledColor),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    SizedBox(height: 30),
                    Padding(
                      padding: EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
                      child: CustomButton(
                          buttonText: 'done'.tr,
                          onPressed: () =>
                              Get.offAllNamed(RouteHelper.getInitialRoute())),
                    ),
                    SizedBox(height: Dimensions.PADDING_SIZE_SMALL * 2),
                    GestureDetector(
                      onTap: () => Get.offAllNamed(
                          RouteHelper.getOrderTrackingRoute(
                              int.parse(orderID), true)),
                      child: Text(
                        status == 1 ? 'track_my_order'.tr : ''.tr,
                        style: sfMedium.copyWith(
                            fontSize: Dimensions.fontSizeLarge * 1.2),
                      ),
                    ),
                  ]))),
    );
  }
}
