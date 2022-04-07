import 'package:efood_multivendor/controller/auth_controller.dart';
import 'package:efood_multivendor/controller/location_controller.dart';
import 'package:efood_multivendor/data/model/response/address_model.dart';
import 'package:efood_multivendor/data/model/response/response_model.dart';
import 'package:efood_multivendor/helper/route_helper.dart';
import 'package:efood_multivendor/util/dimensions.dart';
import 'package:efood_multivendor/util/images.dart';
import 'package:efood_multivendor/util/styles.dart';
import 'package:efood_multivendor/view/base/custom_app_bar.dart';
import 'package:efood_multivendor/view/base/custom_button.dart';
import 'package:efood_multivendor/view/base/custom_loader.dart';
import 'package:efood_multivendor/view/base/custom_snackbar.dart';
import 'package:efood_multivendor/view/base/no_data_screen.dart';
import 'package:efood_multivendor/view/screens/address/widget/address_widget.dart';
import 'package:efood_multivendor/view/screens/location/widget/permission_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';

import '../../../helper/size_config.dart';

class AccessLocationScreen extends StatefulWidget {
  final bool fromSignUp;
  final bool fromHome;
  final String route;
  AccessLocationScreen(
      {@required this.fromSignUp,
      @required this.fromHome,
      @required this.route});

  @override
  State<AccessLocationScreen> createState() => _AccessLocationScreenState();
}

class _AccessLocationScreenState extends State<AccessLocationScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //  locationController = Get.find<LocationController>().getUserAddress();
  }

  void _checkPermission(Function onTap) async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }
    if (permission == LocationPermission.denied) {
      showCustomSnackBar('you_have_to_allow'.tr);
    } else if (permission == LocationPermission.deniedForever) {
      Get.dialog(PermissionDialog());
    } else {
      onTap();
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.fromHome &&
        Get.find<LocationController>().getUserAddress() != null) {
      Future.delayed(Duration(milliseconds: 500), () {
        Get.dialog(CustomLoader(), barrierDismissible: false);
        Get.find<LocationController>().autoNavigate(
          Get.find<LocationController>().getUserAddress(),
          widget.fromSignUp,
          widget.route,
          widget.route != null,
        );
      });
    }
    bool _isLoggedIn = Get.find<AuthController>().isLoggedIn();
    if (_isLoggedIn) {
      Get.find<LocationController>().getAddressList();
    }

    return Scaffold(
      body: Stack(children: [
        Image.asset(
          Images.setLocation,
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          fit: BoxFit.cover,
        ),
        widget.fromHome
            ? Positioned(
                top: 7.h,
                left: 3.w,
                child: GestureDetector(
                  onTap: () {},
                  // authController.waitForOTP(false),
                  child: Container(
                    width: 12.w,
                    height: 12.w,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(1.5.h),
                        color: Theme.of(context).primaryColor.withOpacity(0.3)),
                    child: Icon(
                      GetPlatform.isAndroid
                          ? Icons.arrow_back
                          : Icons.arrow_back_ios_new_rounded,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                ),
              )
            : Container(),
        SafeArea(
            child: Padding(
          padding: EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
          child: GetBuilder<LocationController>(builder: (locationController) {
            return SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              child:
                  GetBuilder<LocationController>(builder: (locationController) {
                return Padding(
                  padding: EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 100,
                      ),
                      Text(
                        'find_restaurants_and_foods'.tr,
                        textAlign: TextAlign.center,
                        style: sfMedium.copyWith(
                            fontWeight: FontWeight.bold,
                            fontSize: Dimensions.fontSizeExtraLarge * 1.8),
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width / 1.3,
                        child: Text(
                          'by_allowing_location_access'.tr,
                          textAlign: TextAlign.justify,
                          style: sfRegular.copyWith(
                              fontSize: Dimensions.fontSizeSmall * 1.1,
                              color: Theme.of(context).disabledColor),
                        ),
                      ),
                      SizedBox(
                        height: Dimensions.PADDING_SIZE_SMALL,
                      ),
                      Container(
                          height: Dimensions.PADDING_SIZE_EXTRA_LARGE * 2.3,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            color: Color(0xffCECDD2).withOpacity(0.25),
                            boxShadow: [
                              BoxShadow(
                                color: Color(0xff5A6CEA).withOpacity(0.07),
                                offset: Offset(12, 26),
                                blurRadius: 50,
                                spreadRadius: 0,
                              )
                            ],
                          ),
                          width: MediaQuery.of(context).size.width / 1.1,
                          child: Hero(
                            tag: "SearchLocation",
                            child: Center(
                              child: TextFormField(
                                onTap: () => Get.toNamed(
                                    RouteHelper.getSearchLoactionRoute(
                                  widget.route == null
                                      ? widget.fromSignUp
                                          ? RouteHelper.signUp
                                          : RouteHelper.accessLocation
                                      : widget.route,
                                  widget.route != null,
                                )),
                                decoration: InputDecoration(
                                  prefixIcon: Icon(
                                    FeatherIcons.search,
                                    color: Colors.black,
                                  ),
                                  hintText: 'search_address_here'.tr,
                                  hintStyle: sfRegular.copyWith(
                                      fontSize: Dimensions.fontSizeSmall * 1.5),
                                  border: InputBorder.none,
                                ),
                                onChanged: (value) {
                                  // locationController.setAddress(value);
                                },
                              ),
                            ),
                          )),
                      SizedBox(
                        height: Dimensions.PADDING_SIZE_SMALL * 1.8,
                      ),
                      Divider(
                        thickness: 1,
                        color: Color(0xff707070).withOpacity(0.1),
                      ),
                      ListTile(
                        onTap: () async {
                          _checkPermission(() async {
                            Get.dialog(CustomLoader(),
                                barrierDismissible: false);
                            AddressModel _address =
                                await Get.find<LocationController>()
                                    .getCurrentLocation(true);
                            ResponseModel _response =
                                await locationController.getZone(
                                    _address.latitude,
                                    _address.longitude,
                                    false);
                            if (_response.isSuccess) {
                              locationController.saveAddressAndNavigate(
                                  _address,
                                  widget.fromSignUp,
                                  widget.route,
                                  widget.route != null);
                            } else {
                              Get.back();
                              Get.toNamed(RouteHelper.getPickMapRoute(
                                  widget.route == null
                                      ? RouteHelper.accessLocation
                                      : widget.route,
                                  widget.route != null));
                              showCustomSnackBar(
                                  'service_not_available_in_current_location'
                                      .tr);
                            }
                          });
                        },
                        leading: ShaderMask(
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
                            child: SvgPicture.asset(
                              Images.location_gps,
                            )),
                        title: Text(
                          'Current Location'.tr,
                          style: sfRegular.copyWith(
                              fontWeight: FontWeight.bold,
                              fontSize: Dimensions.fontSizeSmall * 1.6),
                        ),
                        subtitle: Text(
                          locationController.address,
                          style: sfRegular.copyWith(
                              fontSize: Dimensions.fontSizeSmall * 1.4),
                        ),
                      ),
                      // _isLoggedIn
                      //         ?

                      Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            locationController.addressList != null
                                ? locationController.addressList.length > 0
                                    ? Column(
                                        children: [
                                          Text(
                                            'saved_address'.tr,
                                            textAlign: TextAlign.center,
                                            style: sfMedium.copyWith(
                                                fontWeight: FontWeight.bold,
                                                fontSize: Dimensions
                                                        .fontSizeExtraLarge *
                                                    1.8),
                                          ),
                                          // NoDataScreen(
                                          //     text: 'no_saved_address_found'.tr)
                                          ListView.builder(
                                            physics: BouncingScrollPhysics(),
                                            itemCount: locationController
                                                .addressList.length,
                                            itemBuilder: (context, index) {
                                              return Center(
                                                  child: SizedBox(
                                                      width: 700,
                                                      child: AddressWidget(
                                                        address:
                                                            locationController
                                                                    .addressList[
                                                                index],
                                                        fromAddress: false,
                                                        onTap: () {
                                                          Get.dialog(
                                                              CustomLoader(),
                                                              barrierDismissible:
                                                                  false);
                                                          AddressModel
                                                              _address =
                                                              locationController
                                                                      .addressList[
                                                                  index];
                                                          locationController
                                                              .saveAddressAndNavigate(
                                                                  _address,
                                                                  widget
                                                                      .fromSignUp,
                                                                  widget.route,
                                                                  widget.route !=
                                                                      null);
                                                        },
                                                      )));
                                            },
                                          )
                                        ],
                                      )
                                    : NoDataScreen(
                                        text: 'no_saved_address_found'.tr)
                                : !_isLoggedIn
                                    ? Container()
                                    : Center(
                                        child: CircularProgressIndicator()),
                            SizedBox(height: Dimensions.PADDING_SIZE_LARGE),
                            // BottomButton(
                            //     locationController: locationController,
                            //     fromSignUp: fromSignUp,
                            //     route: route),
                          ])
                    ],
                  ),
                );
              }),
            );
          }),
        ))
      ]),
      // appBar:
      //     CustomAppBar(title: 'set_location'.tr, isBackButtonExist: fromHome),
      // body: SafeArea(
      //     child: Padding(
      //   padding: EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
      //   child: GetBuilder<LocationController>(builder: (locationController) {
      //     return _isLoggedIn
      //         ? Column(mainAxisAlignment: MainAxisAlignment.center, children: [
      //             locationController.addressList != null
      //                 ? locationController.addressList.length > 0
      //                     ? Expanded(
      //                         child: ListView.builder(
      //                           physics: BouncingScrollPhysics(),
      //                           itemCount:
      //                               locationController.addressList.length,
      //                           itemBuilder: (context, index) {
      //                             return Center(
      //                                 child: SizedBox(
      //                                     width: 700,
      //                                     child: AddressWidget(
      //                                       address: locationController
      //                                           .addressList[index],
      //                                       fromAddress: false,
      //                                       onTap: () {
      //                                         Get.dialog(CustomLoader(),
      //                                             barrierDismissible: false);
      //                                         AddressModel _address =
      //                                             locationController
      //                                                 .addressList[index];
      //                                         locationController
      //                                             .saveAddressAndNavigate(
      //                                                 _address,
      //                                                 fromSignUp,
      //                                                 route,
      //                                                 route != null);
      //                                       },
      //                                     )));
      //                           },
      //                         ),
      //                       )
      //                     : NoDataScreen(text: 'no_saved_address_found'.tr)
      //                 : Expanded(
      //                     child: Center(child: CircularProgressIndicator())),
      //             SizedBox(height: Dimensions.PADDING_SIZE_LARGE),
      //             BottomButton(
      //                 locationController: locationController,
      //                 fromSignUp: fromSignUp,
      //                 route: route),
      //           ])
      //         : Center(
      //             child: SingleChildScrollView(
      //             physics: BouncingScrollPhysics(),
      //             child: Center(
      //                 child: SizedBox(
      //                     width: 700,
      //                     child: Column(children: [
      //                       Image.asset(Images.delivery_location, height: 220),
      //                       SizedBox(height: Dimensions.PADDING_SIZE_LARGE),
      //                       Text(
      //                         'find_restaurants_and_foods'.tr.toUpperCase(),
      //                         textAlign: TextAlign.center,
      //                         style: sfMedium.copyWith(
      //                             fontSize: Dimensions.fontSizeExtraLarge),
      //                       ),
      //                       Padding(
      //                         padding:
      //                             EdgeInsets.all(Dimensions.PADDING_SIZE_LARGE),
      //                         child: Text(
      //                           'by_allowing_location_access'.tr,
      //                           textAlign: TextAlign.center,
      //                           style: sfRegular.copyWith(
      //                               fontSize: Dimensions.fontSizeSmall,
      //                               color: Theme.of(context).disabledColor),
      //                         ),
      //                       ),
      //                       SizedBox(height: Dimensions.PADDING_SIZE_LARGE),
      //                       BottomButton(
      //                           locationController: locationController,
      //                           fromSignUp: fromSignUp,
      //                           route: route),
      //                     ]))),
      //           ));
      //   }),
      // )),
    );
  }
}

class BottomButton extends StatelessWidget {
  final LocationController locationController;
  final bool fromSignUp;
  final String route;
  BottomButton(
      {@required this.locationController,
      @required this.fromSignUp,
      @required this.route});

  @override
  Widget build(BuildContext context) {
    return Center(
        child: SizedBox(
            width: 700,
            child: Column(children: [
              CustomButton(
                buttonText: 'user_current_location'.tr,
                onPressed: () async {
                  _checkPermission(() async {
                    Get.dialog(CustomLoader(), barrierDismissible: false);
                    AddressModel _address = await Get.find<LocationController>()
                        .getCurrentLocation(true);
                    ResponseModel _response = await locationController.getZone(
                        _address.latitude, _address.longitude, false);
                    if (_response.isSuccess) {
                      locationController.saveAddressAndNavigate(
                          _address, fromSignUp, route, route != null);
                    } else {
                      Get.back();
                      Get.toNamed(RouteHelper.getPickMapRoute(
                          route == null ? RouteHelper.accessLocation : route,
                          route != null));
                      showCustomSnackBar(
                          'service_not_available_in_current_location'.tr);
                    }
                  });
                },
                icon: Icons.my_location,
              ),
              SizedBox(height: Dimensions.PADDING_SIZE_SMALL),
              TextButton(
                style: TextButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    side: BorderSide(
                        width: 2, color: Theme.of(context).primaryColor),
                    borderRadius:
                        BorderRadius.circular(Dimensions.RADIUS_SMALL),
                  ),
                  minimumSize: Size(Dimensions.WEB_MAX_WIDTH, 50),
                  padding: EdgeInsets.zero,
                ),
                onPressed: () => Get.toNamed(RouteHelper.getPickMapRoute(
                  route == null
                      ? fromSignUp
                          ? RouteHelper.signUp
                          : RouteHelper.accessLocation
                      : route,
                  route != null,
                )),
                child:
                    Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  Padding(
                    padding: EdgeInsets.only(
                        right: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                    child:
                        Icon(Icons.map, color: Theme.of(context).primaryColor),
                  ),
                  Text('set_from_map'.tr,
                      textAlign: TextAlign.center,
                      style: sfBold.copyWith(
                        color: Theme.of(context).primaryColor,
                        fontSize: Dimensions.fontSizeLarge,
                      )),
                ]),
              ),
            ])));
  }

  void _checkPermission(Function onTap) async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }
    if (permission == LocationPermission.denied) {
      showCustomSnackBar('you_have_to_allow'.tr);
    } else if (permission == LocationPermission.deniedForever) {
      Get.dialog(PermissionDialog());
    } else {
      onTap();
    }
  }
}
