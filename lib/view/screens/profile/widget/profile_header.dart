import 'package:efood_multivendor/helper/size_config.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../controller/splash_controller.dart';
import '../../../../controller/user_controller.dart';
import '../../../base/custom_image.dart';

class HeaderSection extends StatelessWidget {
  HeaderSection({
    Key key,
    this.userController,
    this.isLoggedIn,
  }) : super(key: key);
  UserController userController;
  bool isLoggedIn;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          // if (Constants.userId != null) {
          // } else
          //   signUpFirstPopup(context, false);
        },
        child: Row(
          // mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(width: 9.w),
            Container(
              decoration: BoxDecoration(
                border:
                    Border.all(width: 2, color: Theme.of(context).cardColor),
                shape: BoxShape.circle,
              ),
              alignment: Alignment.center,
              child: ClipOval(
                  child: CustomImage(
                image:
                    '${Get.find<SplashController>().configModel.baseUrls.customerImageUrl}'
                    '/${(userController.userInfoModel != null && isLoggedIn) ? userController.userInfoModel.image : ''}',
                height: 100,
                width: 100,
                fit: BoxFit.cover,
              )),
            ),
            SizedBox(width: 10.w),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // SizedBox(height: _high * 10),
                Text(
                  isLoggedIn
                      ? '${userController.userInfoModel.fName}'
                      : 'guest'.tr,
                  style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w600,
                      fontSize: 2.2.h),
                ),
                SizedBox(height: 0.5.h),
                Text(
                  isLoggedIn
                      ? '${userController.userInfoModel.phone} '
                      : '+2519XXXXXXXX',
                  style: TextStyle(
                      color: const Color(0XFF2C3A4B),
                      fontWeight: FontWeight.w300,
                      fontSize: 1.9.h),
                )
              ],
            ),
          ],
        ));
  }
}
