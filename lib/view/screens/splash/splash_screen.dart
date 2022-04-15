import 'dart:async';

import 'package:connectivity/connectivity.dart';
import 'package:efood_multivendor/controller/auth_controller.dart';
import 'package:efood_multivendor/controller/cart_controller.dart';
import 'package:efood_multivendor/controller/location_controller.dart';
import 'package:efood_multivendor/controller/splash_controller.dart';
import 'package:efood_multivendor/controller/wishlist_controller.dart';
import 'package:efood_multivendor/helper/route_helper.dart';
import 'package:efood_multivendor/util/app_constants.dart';
import 'package:efood_multivendor/util/images.dart';
import 'package:efood_multivendor/view/base/no_internet_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:efood_multivendor/helper/size_config.dart' as Size;

import '../../../controller/filter_controller.dart';

class SplashScreen extends StatefulWidget {
  final String orderID;
  SplashScreen({@required this.orderID});
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  GlobalKey<ScaffoldState> _globalKey = GlobalKey();
  StreamSubscription<ConnectivityResult> _onConnectivityChanged;

  @override
  void initState() {
    super.initState();
    bool _firstTime = true;
    _onConnectivityChanged = Connectivity()
        .onConnectivityChanged
        .listen((ConnectivityResult result) {
      if (!_firstTime) {
        bool isNotConnected = result != ConnectivityResult.wifi &&
            result != ConnectivityResult.mobile;
        isNotConnected
            ? SizedBox()
            : ScaffoldMessenger.of(context).hideCurrentSnackBar();
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          backgroundColor: isNotConnected ? Colors.red : Colors.green,
          duration: Duration(seconds: isNotConnected ? 6000 : 3),
          content: Text(
            isNotConnected ? 'no_connection'.tr : 'connected'.tr,
            textAlign: TextAlign.center,
          ),
        ));
        if (!isNotConnected) {
          _route();
        }
      }
      _firstTime = false;
    });

    Get.find<SplashController>().initSharedData();
    Get.find<CartController>().getCartData();
    _route();
  }

  @override
  void dispose() {
    super.dispose();

    _onConnectivityChanged.cancel();
  }

  void _route() {
    Get.find<SplashController>().getConfigData().then((isSuccess) {
      if (isSuccess) {
        Timer(Duration(seconds: 1), () async {
          int _minimumVersion = 0;
          if (GetPlatform.isAndroid) {
            _minimumVersion = Get.find<SplashController>()
                .configModel
                .appMinimumVersionAndroid;
          } else if (GetPlatform.isIOS) {
            _minimumVersion =
                Get.find<SplashController>().configModel.appMinimumVersionIos;
          }
          if (AppConstants.APP_VERSION < _minimumVersion ||
              Get.find<SplashController>().configModel.maintenanceMode) {
            Get.offNamed(RouteHelper.getUpdateRoute(
                AppConstants.APP_VERSION < _minimumVersion));
          } else {
            if (widget.orderID != null) {
              Get.offNamed(
                  RouteHelper.getOrderDetailsRoute(int.parse(widget.orderID)));
            } else {
              if (Get.find<AuthController>().isLoggedIn()) {
                Get.find<AuthController>().updateToken();
                await Get.find<WishListController>().getWishList();
                if (Get.find<LocationController>().getUserAddress() != null) {
                  Get.offNamed(RouteHelper.getInitialRoute());
                } else {
                  Get.offNamed(RouteHelper.getAccessLocationRoute('splash'));
                }
              } else {
                if (Get.find<SplashController>().showIntro()) {
                  if (AppConstants.languages.length > 1) {
                    Get.offNamed(RouteHelper.getLanguageRoute('splash'));
                  } else {
                    Get.offNamed(RouteHelper.getOnBoardingRoute());
                  }
                } else {
                  Get.offNamed(RouteHelper.getSignInRoute(RouteHelper.splash));
                }
              }
            }
          }
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    Size.init(context);
    Get.find<FilterController>().clearFilters();

    return Stack(children: <Widget>[
      Container(
        color: Colors.white,
        child: Image.asset(
          Images.pattern_bg,
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          fit: BoxFit.cover,
        ),
      ),
      Scaffold(
        key: _globalKey,
        backgroundColor: Colors.transparent,
        body: GetBuilder<SplashController>(builder: (splashController) {
          return splashController.hasConnection
              ? Align(
                  alignment: Alignment.bottomCenter,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Image.asset(Images.logo, width: 150),
                      SizedBox(height: height * 0.2),
                      ShaderMask(
                          shaderCallback: (Rect bounds) {
                            return RadialGradient(
                              center: Alignment.topLeft,
                              radius: 0.5,
                              colors: <Color>[
                                Color(0xffff8022),
                                Color(0xffff2222)
                              ],
                              tileMode: TileMode.repeated,
                            ).createShader(bounds);
                          },
                          child: CircularProgressIndicator.adaptive()),
                      SizedBox(
                        height: height * 0.05,
                      ),
                      Image.asset(Images.name, width: 150),
                      SizedBox(height: height * 0.08),

                      /*SizedBox(height: Dimensions.PADDING_SIZE_SMALL),
                          Text(AppConstants.APP_NAME, style: sfMedium.copyWith(fontSize: 25)),*/
                    ],
                  ),
                )
              : NoInternetScreen(child: SplashScreen(orderID: widget.orderID));
        }),
      )
    ]);
  }
}
