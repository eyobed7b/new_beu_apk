import 'dart:convert';

import 'package:country_code_picker/country_code.dart';
import 'package:efood_multivendor/controller/auth_controller.dart';
import 'package:efood_multivendor/controller/splash_controller.dart';
import 'package:efood_multivendor/data/model/body/signup_body.dart';
import 'package:efood_multivendor/data/model/response/response_model.dart';
import 'package:efood_multivendor/helper/responsive_helper.dart';
import 'package:efood_multivendor/helper/route_helper.dart';
import 'package:efood_multivendor/helper/size_config.dart';
import 'package:efood_multivendor/util/dimensions.dart';
import 'package:efood_multivendor/util/images.dart';
import 'package:efood_multivendor/util/styles.dart';
import 'package:efood_multivendor/view/base/custom_button.dart';
import 'package:efood_multivendor/view/base/custom_snackbar.dart';
import 'package:efood_multivendor/view/base/custom_text_field.dart';
import 'package:efood_multivendor/view/base/web_menu_bar.dart';
import 'package:efood_multivendor/view/screens/auth/widget/code_picker_widget.dart';
import 'package:efood_multivendor/view/screens/auth/widget/condition_check_box.dart';
import 'package:efood_multivendor/view/screens/auth/widget/guest_button.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:phone_number/phone_number.dart';

class SignUpScreen extends StatefulWidget {
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final FocusNode _firstNameFocus = FocusNode();
  final FocusNode _lastNameFocus = FocusNode();
  final FocusNode _emailFocus = FocusNode();
  final FocusNode _phoneFocus = FocusNode();
  final FocusNode _passwordFocus = FocusNode();
  final FocusNode _confirmPasswordFocus = FocusNode();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  String _countryDialCode;

  @override
  void initState() {
    super.initState();

    _countryDialCode = CountryCode.fromCountryCode(
            Get.find<SplashController>().configModel.country)
        .dialCode;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: ResponsiveHelper.isDesktop(context) ? WebMenuBar() : null,
        body: SafeArea(
          child: Stack(children: [
            Image.asset(
              Images.setLocation,
              height: 100.h,
              width: 100.w,
              fit: BoxFit.fitHeight,
            ),
            Scrollbar(
              child: SingleChildScrollView(
                padding: EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
                physics: BouncingScrollPhysics(),
                child: Center(
                  child: Container(
                    width: context.width > 700 ? 700 : context.width,
                    padding: context.width > 700
                        ? EdgeInsets.all(Dimensions.PADDING_SIZE_DEFAULT)
                        : null,
                    decoration: context.width > 700
                        ? BoxDecoration(
                            color: Theme.of(context).cardColor,
                            borderRadius:
                                BorderRadius.circular(Dimensions.RADIUS_SMALL),
                            boxShadow: [
                              BoxShadow(
                                  color:
                                      Colors.grey[Get.isDarkMode ? 700 : 300],
                                  blurRadius: 5,
                                  spreadRadius: 1)
                            ],
                          )
                        : null,
                    child:
                        GetBuilder<AuthController>(builder: (authController) {
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(height: 10.h),
                              Text(
                                'fill_in_info'.tr,
                                textAlign: TextAlign.start,
                                style: sfMedium.copyWith(
                                    fontWeight: FontWeight.bold,
                                    fontSize:
                                        Dimensions.fontSizeExtraLarge * 1.8),
                              ),
                              SizedBox(
                                height: 2.h,
                              ),
                              SizedBox(
                                width: 80.h,
                                child: Text(
                                  'fill_in_info_desc'.tr,
                                  textAlign: TextAlign.start,
                                  style: sfRegular.copyWith(
                                      fontSize: Dimensions.fontSizeSmall * 1.1,
                                      color: Theme.of(context).disabledColor),
                                ),
                              ),
                              SizedBox(height: 1.h),
                              CustomTextField(
                                hintText: 'name'.tr,
                                controller: _firstNameController,
                                focusNode: _firstNameFocus,
                                inputType: TextInputType.name,
                                capitalization: TextCapitalization.words,
                                divider: true,
                              ),

                              // !authController.isLoading
                              //     ? Row(children: [
                              //         Expanded(
                              //             child: CustomButton(
                              //           buttonText: 'sign_in'.tr,
                              //           transparent: true,
                              //           onPressed: () => Get.toNamed(
                              //               RouteHelper.getSignInRoute(
                              //                   RouteHelper.signUp)),
                              //         )),
                              //         Expanded(
                              //             child: CustomButton(
                              //           buttonText: 'sign_up'.tr,
                              //           onPressed: authController.acceptTerms
                              //               ? () => _register(
                              //                   authController, _countryDialCode)
                              //               : null,
                              //         )),
                              //       ])
                              //     : Center(child: CircularProgressIndicator()),
                              SizedBox(height: 50.h),
                              GestureDetector(
                                onTap: () async {
                                  _register(authController);
                                },
                                child: Container(
                                  height: 7.h,
                                  width: 90.w,
                                  decoration: BoxDecoration(
                                      borderRadius:
                                          BorderRadius.circular(1.5.h),
                                      gradient: LinearGradient(
                                          begin: Alignment.topLeft,
                                          end: Alignment.bottomRight,
                                          colors: [
                                            Theme.of(context).primaryColor,
                                            Theme.of(context)
                                                .colorScheme
                                                .secondary
                                          ])),
                                  child: Center(
                                    child: !authController.isLoading
                                        ? Text("next".tr,
                                            style: sfBold.copyWith(
                                                fontSize: 18,
                                                color: Colors.white))
                                        : CircularProgressIndicator(),
                                  ),
                                ),
                              )
                              // SocialLoginWidget(),
                            ]),
                      );
                    }),
                  ),
                ),
              ),
            )
          ]),
        ));
  }

  void _register(AuthController authController) async {
    authController.registerUser(_firstNameController.text).then((status) async {
      if (status.isSuccess) {
        Get.toNamed(RouteHelper.getAccessLocationRoute(RouteHelper.signUp));
      } else {
        showCustomSnackBar(status.message);
      }
    });
  }
}
