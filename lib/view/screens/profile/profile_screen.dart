import 'package:efood_multivendor/controller/auth_controller.dart';
import 'package:efood_multivendor/controller/cart_controller.dart';
import 'package:efood_multivendor/controller/splash_controller.dart';
import 'package:efood_multivendor/controller/theme_controller.dart';
import 'package:efood_multivendor/controller/user_controller.dart';
import 'package:efood_multivendor/helper/responsive_helper.dart';
import 'package:efood_multivendor/helper/route_helper.dart';
import 'package:efood_multivendor/helper/size_config.dart';
import 'package:efood_multivendor/util/dimensions.dart';
import 'package:efood_multivendor/util/styles.dart';
import 'package:efood_multivendor/view/base/custom_image.dart';
import 'package:efood_multivendor/view/base/web_menu_bar.dart';
import 'package:efood_multivendor/view/screens/profile/widget/logout_dialog.dart';
import 'package:efood_multivendor/view/screens/profile/widget/profile_bg_widget.dart';
import 'package:efood_multivendor/view/screens/profile/widget/profile_button.dart';
import 'package:efood_multivendor/view/screens/profile/widget/profile_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:get/get.dart';

import '../../../controller/localization_controller.dart';
import 'widget/profile_header.dart';
import 'widget/profile_list_item.dart';

class ProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    bool _isLoggedIn = Get.find<AuthController>().isLoggedIn();
    if (_isLoggedIn && Get.find<UserController>().userInfoModel == null) {
      Get.find<UserController>().getUserInfo();
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        // backgroundColor: widget.backgroundColor,
        title: Text(
          'profile'.tr,
          style: const TextStyle(
            // fontSize: _high * 3.1,
            color: Colors.black,
            fontWeight: FontWeight.w500,
          ),
        ),
        centerTitle: true,
        elevation: 0.0,
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 4.w),
            child: GestureDetector(
              onTap: () {
                Get.toNamed(RouteHelper.getUpdateProfileRoute());
              },
              child: Column(
                children: [
                  SizedBox(
                    height: 2.2.h,
                  ),
                  Text(
                    'edit_profile'.tr,
                    style: TextStyle(
                      color: Colors.blue,
                      fontWeight: FontWeight.w200,
                      // fontSize: 2.2.h,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),

      // backgroundColor: Theme.of(context).cardColor,
      body: GetBuilder<UserController>(builder: (userController) {
        return (_isLoggedIn && userController.userInfoModel == null)
            ? Center(
                child: ShaderMask(
                    shaderCallback: (shade) {
                      return LinearGradient(
                        colors: [Color(0xffff8022), Color(0xffff2222)],
                        tileMode: TileMode.mirror,
                      ).createShader(shade);
                    },
                    child: CircularProgressIndicator.adaptive()),
              )
            : SingleChildScrollView(
                physics: BouncingScrollPhysics(),
                child: Column(
                  children: [
                    SizedBox(height: 3.h),
                    Center(
                        child: HeaderSection(
                      userController: userController,
                      isLoggedIn: _isLoggedIn,
                    )),
                    SizedBox(height: 9.h),
                    Column(
                      children: [
                        _isLoggedIn
                            ? Column(
                                children: [
                                  ListItem(
                                    title: 'delivery_address'.tr,
                                    iconColor: const Color(0xff0DEA8D),
                                    onTap: () {
                                      // doNavigationWithAuthCheck(1);
                                      Get.toNamed(
                                          RouteHelper.getAddressRoute());
                                    },
                                    icons: FeatherIcons.mapPin,
                                    showArrow: true,
                                  ),
                                  SizedBox(height: 3.h),
                                ],
                              )
                            : SizedBox(),
                        // Divider(
                        //   color: Color.fromARGB(255, 255, 255, 255),
                        //   thickness: 0.04.h,
                        // ),
                        ListItem(
                          title: 'language'.tr,
                          iconColor: const Color(0xffFA4EFE),
                          onTap: () {
                            // doNavigationWithAuthCheck(1);
                            Get.toNamed(RouteHelper.getLanguageRoute('menu'));
                          },
                          icons: Icons.translate_sharp,
                          showArrow: true,
                          seconderyText:
                              '${Get.find<LocalizationController>().languages[Get.find<LocalizationController>().selectedIndex].languageName}',
                        ),
                        SizedBox(height: 3.h),
                        // Divider(
                        //   color: Color.fromARGB(255, 250, 250, 250),
                        //   thickness: 0.04.h,
                        // ),
                        ListItem(
                          title: 'coupon'.tr,
                          iconColor: const Color(0xff12D3C8),
                          onTap: () {
                            Get.toNamed(RouteHelper.getCouponRoute());
                            // doNavigationWithAuthCheck(1);
                          },
                          icons: FeatherIcons.gift,
                          showArrow: true,
                        ),
                        SizedBox(height: 3.h),
                        // Divider(
                        //   color: Color.fromARGB(255, 255, 255, 255),
                        //   thickness: 0.04.h,
                        // ),
                        ListItem(
                          title: 'help_support'.tr,
                          iconColor: Color.fromARGB(255, 187, 239, 47),
                          onTap: () {
                            Get.toNamed(RouteHelper.getSupportRoute());
                          },
                          icons: FeatherIcons.lifeBuoy,
                          showArrow: true,
                        ),
                        SizedBox(height: 3.h),
                        ListItem(
                          title: 'privacy_policy'.tr,
                          iconColor: Color.fromARGB(255, 0, 162, 237),
                          onTap: () {
                            Get.toNamed(
                                RouteHelper.getHtmlRoute('privacy-policy'));
                            ;
                          },
                          icons: FeatherIcons.shield,
                          showArrow: true,
                        ),
                        SizedBox(height: 3.h),
                        ListItem(
                          title: 'terms_conditions'.tr,
                          iconColor: Color.fromARGB(255, 134, 231, 219),
                          onTap: () {
                            Get.toNamed(RouteHelper.getHtmlRoute(
                                'terms-and-condition'));
                            ;
                          },
                          icons: FeatherIcons.fileText,
                          showArrow: true,
                        ),
                        SizedBox(height: 3.h),
                        // SizedBox(height: 3.h),
                        // Divider(
                        //   color: Color.fromARGB(255, 255, 255, 255),
                        //   thickness: 0.04.h,
                        // ),
                        _isLoggedIn
                            ? Column(
                                children: [
                                  ListItem(
                                    title: 'logout'.tr,
                                    iconColor: const Color(0xff1A16F8),
                                    onTap: () async {
                                      showCustomDialog(context);
                                      // Get.find<AuthController>()
                                      //     .clearSharedData();
                                      // Get.find<CartController>()
                                      //     .clearCartList();

                                      // Get.offAllNamed(RouteHelper.signIn);

                                      // doNavigationWithAuthCheck(1);
                                    },
                                    icons: Icons.logout_rounded,
                                    showArrow: false,
                                  ),
                                ],
                              )
                            : SizedBox(),
                        SizedBox(
                          height: 15.h,
                        ),
                      ],
                    )
                  ],
                ),
              );
      }),
    );
  }
}
