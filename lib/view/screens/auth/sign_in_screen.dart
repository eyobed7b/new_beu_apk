import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:country_code_picker/country_code.dart';
import 'package:efood_multivendor/controller/auth_controller.dart';
import 'package:efood_multivendor/controller/localization_controller.dart';
import 'package:efood_multivendor/controller/splash_controller.dart';
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
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:otp_text_field/style.dart';
import 'package:phone_number/phone_number.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:otp_text_field/otp_field.dart';
import 'package:timer_button/timer_button.dart';

class SignInScreen extends StatefulWidget {
  final bool exitFromApp;
  SignInScreen({@required this.exitFromApp});

  @override
  _SignInScreenState createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final FocusNode _phoneFocus = FocusNode();
  final FocusNode _passwordFocus = FocusNode();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  String _countryDialCode;
  bool _canExit = GetPlatform.isWeb ? true : false;
  @override
  void initState() {
    super.initState();

    _countryDialCode =
        Get.find<AuthController>().getUserCountryCode().isNotEmpty
            ? Get.find<AuthController>().getUserCountryCode()
            : CountryCode.fromCountryCode(
                    Get.find<SplashController>().configModel.country)
                .dialCode;
    _phoneController.text = Get.find<AuthController>().getUserNumber() ?? '';
    _passwordController.text =
        Get.find<AuthController>().getUserPassword() ?? '';
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(onWillPop: () async {
      if (widget.exitFromApp) {
        if (_canExit) {
          if (GetPlatform.isAndroid) {
            SystemNavigator.pop();
          } else if (GetPlatform.isIOS) {
            exit(0);
          } else {
            Navigator.pushNamed(context, RouteHelper.getInitialRoute());
          }
          return Future.value(false);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text('back_press_again_to_exit'.tr,
                style: TextStyle(color: Colors.white)),
            behavior: SnackBarBehavior.floating,
            backgroundColor: Colors.green,
            duration: Duration(seconds: 2),
            margin: EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
          ));
          _canExit = true;
          Timer(Duration(seconds: 2), () {
            _canExit = false;
          });
          return Future.value(false);
        }
      } else {
        return true;
      }
    }, child: GetBuilder<AuthController>(builder: (authController) {
      return Scaffold(
        appBar: ResponsiveHelper.isDesktop(context)
            ? WebMenuBar()
            : !widget.exitFromApp && !authController.isWaitingForOTP
                ? AppBar(
                    leading: IconButton(
                      onPressed: () {
                        authController.back();
                        Get.back();
                      },
                      icon: Icon(Icons.arrow_back_ios_rounded,
                          color: Theme.of(context).textTheme.bodyText1.color),
                    ),
                    elevation: 0,
                    backgroundColor: Colors.transparent)
                : null,
        body: SafeArea(
          child: Scrollbar(
            child: SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              padding: EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
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
                              color: Colors.grey[Get.isDarkMode ? 700 : 300],
                              blurRadius: 5,
                              spreadRadius: 1)
                        ],
                      )
                    : null,
                child: GetBuilder<AuthController>(builder: (authController) {
                  return !authController.isWaitingForOTP
                      ? Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                              Stack(
                                children: [
                                  Image.asset(Images.illustration,
                                      width: 100.h),
                                  Positioned(
                                      bottom: 1.h,
                                      child: Text(
                                        "Enter your phone number",
                                        style: sfBlack.copyWith(fontSize: 3.h),
                                      ))
                                ],
                              ),
                              SizedBox(
                                  height: Dimensions.PADDING_SIZE_EXTRA_LARGE),
                              Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(
                                      Dimensions.RADIUS_SMALL),
                                  color: Theme.of(context).cardColor,
                                  boxShadow: [
                                    BoxShadow(
                                        color: Colors
                                            .grey[Get.isDarkMode ? 800 : 200],
                                        spreadRadius: 1,
                                        blurRadius: 5)
                                  ],
                                ),
                                child: Column(children: [
                                  Row(children: [
                                    CodePickerWidget(
                                      alignLeft: true,
                                      onChanged: (CountryCode countryCode) {
                                        _countryDialCode = countryCode.dialCode;
                                      },
                                      initialSelection: _countryDialCode != null
                                          ? _countryDialCode
                                          : Get.find<LocalizationController>()
                                              .locale
                                              .countryCode,
                                      favorite: [_countryDialCode],
                                      flagDecoration:
                                          BoxDecoration(shape: BoxShape.circle),
                                      showCountryOnly: true,
                                      padding: EdgeInsets.zero,
                                      showDropDownButton: true,
                                      flagWidth: 50,
                                      hideMainText: true,
                                      textStyle: sfRegular.copyWith(
                                        fontSize: Dimensions.fontSizeLarge,
                                        color: Theme.of(context)
                                            .textTheme
                                            .bodyText1
                                            .color,
                                      ),
                                    ),
                                    Expanded(
                                        flex: 100,
                                        child: CustomTextField(
                                          hintText: 'phone'.tr,
                                          controller: _phoneController,
                                          focusNode: _phoneFocus,
                                          nextFocus: _passwordFocus,
                                          inputType: TextInputType.phone,
                                          divider: false,
                                        )),
                                    !authController.isLoading
                                        ? GestureDetector(
                                            onTap: () {
                                              authController.waitForOTP(true);
                                              _login(authController,
                                                  _countryDialCode);
                                            },
                                            child: Container(
                                              height: 6.h,
                                              width: 6.h,
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          2.w),
                                                  gradient: LinearGradient(
                                                      colors: [
                                                        Theme.of(context)
                                                            .primaryColor,
                                                        Theme.of(context)
                                                            .colorScheme
                                                            .secondary
                                                      ])),
                                              child: Icon(
                                                Icons.arrow_forward,
                                                color: Colors.white,
                                                size: 3.h,
                                              ),
                                            ),
                                          )
                                        : CircularProgressIndicator()
                                  ]),
                                ]),
                              ),
                              GuestButton(),
                            ])
                      : Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                GestureDetector(
                                  onTap: () => authController.waitForOTP(false),
                                  child: Container(
                                    width: 12.w,
                                    height: 12.w,
                                    decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(1.5.h),
                                        color: Theme.of(context)
                                            .primaryColor
                                            .withOpacity(0.3)),
                                    child: Icon(
                                      Icons.arrow_back,
                                      color: Theme.of(context).primaryColor,
                                    ),
                                  ),
                                ),
                                SizedBox(height: 5.h),
                                Text(
                                  "Enter the \ncode from the SMS",
                                  maxLines: 2,
                                  style: sfRegular.copyWith(
                                      fontSize: 30,
                                      color: Color.fromARGB(255, 9, 5, 28)),
                                ),
                                SizedBox(height: 3.h),
                                Text(
                                  "We sent a code to $_countryDialCode ${_phoneController.text}. Please enter the code below to verify your phone number.",
                                  style: sfRegular.copyWith(fontSize: 16),
                                ),
                                SizedBox(height: 3.h),
                                OTPTextField(
                                  onChanged: (value) {},
                                  length: 6,
                                  width: 336,
                                  fieldWidth: 50,
                                  style: const TextStyle(fontSize: 17),
                                  textFieldAlignment:
                                      MainAxisAlignment.spaceAround,
                                  fieldStyle: FieldStyle.underline,
                                  onCompleted: (pin) {
                                    if (kDebugMode) {
                                      print("Completed: " + pin);
                                    }
                                    authController.verifyOTP(pin);
                                  },
                                ),
                                SizedBox(height: 3.h),
                                Align(
                                    alignment: Alignment.center,
                                    child: TimerButton(
                                      label: "Send OTP Again",
                                      buttonType: ButtonType.TextButton,
                                      timeOutInSeconds: 20,
                                      onPressed: () {},
                                      disabledColor: Colors.transparent,
                                      color: Colors.transparent,
                                      disabledTextStyle: const TextStyle(
                                          fontSize: 16.0, color: Colors.grey),
                                      activeTextStyle: const TextStyle(
                                          fontSize: 16.0,
                                          color: Colors.deepOrange),
                                    )),
                                SizedBox(
                                  height: 38.h,
                                ),
                                Container(
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
                                        ? Text("Next",
                                            style: sfBold.copyWith(
                                                fontSize: 18,
                                                color: Colors.white))
                                        : CircularProgressIndicator(),
                                  ),
                                )
                              ]),
                        );
                }),
              ),
            ),
          ),
        ),
      );
    }));
  }

  void _login(AuthController authController, String countryDialCode) async {
    String _phone = _phoneController.text.trim();
    String _numberWithCountryCode = countryDialCode + _phone;
    bool _isValid = GetPlatform.isWeb ? true : false;
    if (!GetPlatform.isWeb) {
      try {
        PhoneNumber phoneNumber =
            await PhoneNumberUtil().parse(_numberWithCountryCode);
        _numberWithCountryCode =
            '+' + phoneNumber.countryCode + phoneNumber.nationalNumber;

        _isValid = true;
      } catch (e) {
        if (kDebugMode) {
          print("Phone Number: $_numberWithCountryCode");
        }
      }
    }
    if (_phone.isEmpty) {
      showCustomSnackBar('enter_phone_number'.tr);
    } else if (!_isValid) {
      showCustomSnackBar('invalid_phone_number'.tr);
    } else {
      if (kDebugMode) {
        print("Phone number: $_numberWithCountryCode");
      }
      verifyNumber(_numberWithCountryCode, authController);
    }
  }

  verifyNumber(String phonenumber, AuthController controller) async {
    if (kDebugMode) {
      print("FirebaseAuth Verifying he number $phonenumber");
    }
    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: phonenumber,
      verificationCompleted: (PhoneAuthCredential credential) async {
        if (kDebugMode) {
          print("token is ${credential.token}");
        }

        FirebaseAuth.instance.signInWithCredential(credential).then((value) {
          FirebaseAuth.instance.currentUser.getIdToken().then((token) {
            if (kDebugMode) {
              print("token is $token");
            }
            controller.loginUser(token);
          });
        });
      },
      verificationFailed: (FirebaseAuthException e) {
        if (e.code == 'invalid-phone-number') {
          if (kDebugMode) {
            print('The provided phone number is not valid.');
          }
        } else {
          if (kDebugMode) {
            print(e.message);
          }
        }
      },
      codeSent: (String verificationId, int resendToken) {
        if (kDebugMode) {
          print("Verification ID set");
        }
        controller.setVerificationId(verificationId);
        controller.waitForOTP(true);
      },
      codeAutoRetrievalTimeout: (String verificationId) {},
    );
  }
}
