import 'package:efood_multivendor/controller/auth_controller.dart';
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
            ? Center(child: CircularProgressIndicator())
            : Column(
                children: [
                  SizedBox(height: 3.h),
                  Center(
                      child: HeaderSection(
                    userController: userController,
                    isLoggedIn: _isLoggedIn,
                  )),
                  SizedBox(height: 9.h),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          _isLoggedIn
                              ? Column(
                                  children: [
                                    ListItem(
                                      title: 'delivery_address'.tr,
                                      iconColor: const Color(0xff0DEA8D),
                                      onTap: () {
                                        // doNavigationWithAuthCheck(1);
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
                            },
                            icons: Icons.translate_sharp,
                            showArrow: true,
                            seconderyText:
                                '${Get.find<LocalizationController>().languages.toList()[Get.find<LocalizationController>().selectedIndex].languageName}',
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
                          // ListItem(
                          //   title: 'Send Money',
                          //   iconColor: const Color(0xffFF8700),
                          //   onTap: () {
                          //     // doNavigationWithAuthCheck(1);
                          //   },
                          //   icons: Icons.local_shipping_outlined,
                          //   showArrow: true,
                          // ),
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
                                      onTap: () {
                                        // doNavigationWithAuthCheck(1);
                                      },
                                      icons: Icons.logout_rounded,
                                      showArrow: true,
                                    ),
                                  ],
                                )
                              : SizedBox(),
                        ],
                      ),
                    ),
                  )
                ],
              );

        // ProfileBgWidget(
        //   backButton: true,
        //   circularImage: Container(
        //     decoration: BoxDecoration(
        //       border: Border.all(width: 2, color: Theme.of(context).cardColor),
        //       shape: BoxShape.circle,
        //     ),
        //     alignment: Alignment.center,
        //     child: ClipOval(
        //         child: CustomImage(
        //       image:
        //           '${Get.find<SplashController>().configModel.baseUrls.customerImageUrl}'
        //           '/${(userController.userInfoModel != null && _isLoggedIn) ? userController.userInfoModel.image : ''}',
        //       height: 100,
        //       width: 100,
        //       fit: BoxFit.cover,
        //     )),
        //   ),
        //   mainWidget: SingleChildScrollView(
        //       physics: BouncingScrollPhysics(),
        //       child: Center(
        //           child: Container(
        //         width: Dimensions.WEB_MAX_WIDTH,
        //         color: Theme.of(context).cardColor,
        //         padding: EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
        //         child: Column(children: [
        //           Text(
        //             _isLoggedIn
        //                 ? '${userController.userInfoModel.fName} ${userController.userInfoModel.lName}'
        //                 : 'guest'.tr,
        //             style:
        //                 sfMedium.copyWith(fontSize: Dimensions.fontSizeLarge),
        //           ),
        //           SizedBox(height: 30),
        //           _isLoggedIn
        //               ? Row(children: [
        //                   ProfileCard(
        //                       title: 'since_joining'.tr,
        //                       data:
        //                           '${userController.userInfoModel.memberSinceDays} ${'days'.tr}'),
        //                   SizedBox(width: Dimensions.PADDING_SIZE_SMALL),
        //                   ProfileCard(
        //                       title: 'total_order'.tr,
        //                       data: userController.userInfoModel.orderCount
        //                           .toString()),
        //                 ])
        //               : SizedBox(),
        //           SizedBox(height: _isLoggedIn ? 30 : 0),
        //           ProfileButton(
        //               icon: Icons.dark_mode,
        //               title: 'dark_mode'.tr,
        //               isButtonActive: Get.isDarkMode,
        //               onTap: () {
        //                 Get.find<ThemeController>().toggleTheme();
        //               }),
        //           SizedBox(height: Dimensions.PADDING_SIZE_SMALL),
        //           _isLoggedIn
        //               ? GetBuilder<AuthController>(builder: (authController) {
        //                   return ProfileButton(
        //                     icon: Icons.notifications,
        //                     title: 'notification'.tr,
        //                     isButtonActive: authController.notification,
        //                     onTap: () {
        //                       authController.setNotificationActive(
        //                           !authController.notification);
        //                     },
        //                   );
        //                 })
        //               : SizedBox(),
        //           SizedBox(
        //               height: _isLoggedIn ? Dimensions.PADDING_SIZE_SMALL : 0),
        //           _isLoggedIn
        //               ? ProfileButton(
        //                   icon: Icons.lock,
        //                   title: 'change_password'.tr,
        //                   onTap: () {
        //                     Get.toNamed(RouteHelper.getResetPasswordRoute(
        //                         '', '', 'password-change'));
        //                   })
        //               : SizedBox(),
        //           SizedBox(
        //               height: _isLoggedIn ? Dimensions.PADDING_SIZE_SMALL : 0),
        //           ProfileButton(
        //               icon: Icons.edit,
        //               title: 'edit_profile'.tr,
        //               onTap: () {
        //                 Get.toNamed(RouteHelper.getUpdateProfileRoute());
        //               }),
        //           SizedBox(height: Dimensions.PADDING_SIZE_SMALL),
        //         ]),
        //       ))),
        // );
      }),
    );
  }
}
