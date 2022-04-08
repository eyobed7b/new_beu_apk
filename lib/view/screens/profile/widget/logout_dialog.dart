import 'package:efood_multivendor/helper/size_config.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../controller/auth_controller.dart';
import '../../../../controller/cart_controller.dart';
import '../../../../helper/route_helper.dart';
import '../../../../util/dimensions.dart';
import '../../../../util/images.dart';
import '../../../base/custom_button.dart';

void showCustomDialog(BuildContext context) {
  showDialog(
    barrierDismissible: true,
    context: context,
    builder: (BuildContext cxt) {
      return Align(
        alignment: Alignment.center,
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Material(
            color: Colors.white,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Center(
                    child: Image.asset(
                      Images.exit,
                      height: 27.h,
                    ),
                  ),
                  Text(
                    'logout_msg'.tr,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 3.2.h,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(
                    height: 6.2.h,
                  ),
                  CustomButton(
                    onPressed: () {
                      Get.back();
                    },
                    radius: 15,
                    margin: EdgeInsets.only(
                        left: Dimensions.PADDING_SIZE_SMALL * 3.9,
                        right: Dimensions.PADDING_SIZE_SMALL * 3.9,
                        bottom: Dimensions.PADDING_SIZE_SMALL),
                    buttonText: 'logout_no_btn'.tr,
                  ),
                  GestureDetector(
                    onTap: () {
                      Get.find<AuthController>().clearSharedData();
                      Get.find<CartController>().clearCartList();

                      Get.offAllNamed(RouteHelper.signIn);
                    },
                    child: Text(
                      'logout_yes_btn'.tr,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 1.8.h,
                          fontWeight: FontWeight.w500,
                          decoration: TextDecoration.underline),
                    ),
                  ),
                  SizedBox(
                    height: 4.2.h,
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    },
  );
}
