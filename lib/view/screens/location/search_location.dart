import 'package:efood_multivendor/controller/location_controller.dart';
import 'package:efood_multivendor/controller/splash_controller.dart';
import 'package:efood_multivendor/data/model/response/address_model.dart';
import 'package:efood_multivendor/helper/responsive_helper.dart';
import 'package:efood_multivendor/util/dimensions.dart';
import 'package:efood_multivendor/util/images.dart';
import 'package:efood_multivendor/util/styles.dart';
import 'package:efood_multivendor/view/base/custom_button.dart';
import 'package:efood_multivendor/view/base/custom_snackbar.dart';
import 'package:efood_multivendor/view/base/web_menu_bar.dart';
import 'package:efood_multivendor/view/screens/location/widget/location_search_dialog.dart';
import 'package:efood_multivendor/view/screens/location/widget/permission_dialog.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class SearchLocationScreen extends StatefulWidget {
  final bool fromSignUp;
  final bool fromAddAddress;
  final bool canRoute;
  final String route;
  final GoogleMapController googleMapController;
  SearchLocationScreen({
    @required this.fromSignUp,
    @required this.fromAddAddress,
    @required this.canRoute,
    @required this.route,
    this.googleMapController,
  });

  @override
  State<SearchLocationScreen> createState() => _SearchLocationScreenState();
}

class _SearchLocationScreenState extends State<SearchLocationScreen> {
  GoogleMapController _mapController;
  CameraPosition _cameraPosition;
  LatLng _initialPosition;

  @override
  void initState() {
    super.initState();

    if (widget.fromAddAddress) {
      Get.find<LocationController>().setPickData();
    }
    _initialPosition = LatLng(
      double.parse(
          Get.find<SplashController>().configModel.defaultLocation.lat ?? '0'),
      double.parse(
          Get.find<SplashController>().configModel.defaultLocation.lng ?? '0'),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ResponsiveHelper.isDesktop(context) ? WebMenuBar() : null,
      body: SafeArea(
          child: Center(
              child: SizedBox(
        width: Dimensions.WEB_MAX_WIDTH,
        child: GetBuilder<LocationController>(builder: (locationController) {
          return Stack(children: [
            Positioned(
              top: Dimensions.PADDING_SIZE_LARGE,
              left: Dimensions.PADDING_SIZE_SMALL,
              right: Dimensions.PADDING_SIZE_SMALL,
              child: LocationSearchDialog(mapController: _mapController),
              //    InkWell(
              //     onTap: () => Get.dialog(
              //         LocationSearchDialog(mapController: _mapController),
              //         barrierDismissible: false,
              //         barrierColor: Colors.transparent),
              //     child: Container(
              //       height: 50,
              //       padding: EdgeInsets.symmetric(
              //           horizontal: Dimensions.PADDING_SIZE_SMALL),
              //       decoration: BoxDecoration(
              //           color: Theme.of(context).cardColor,
              //           borderRadius:
              //               BorderRadius.circular(Dimensions.RADIUS_SMALL)),
              //       child: Row(children: [
              //         Icon(Icons.location_on,
              //             size: 25, color: Theme.of(context).primaryColor),
              //         SizedBox(width: Dimensions.PADDING_SIZE_EXTRA_SMALL),
              //         Expanded(
              //           child: Text(
              //             locationController.pickAddress,
              //             style: sfRegular.copyWith(
              //                 fontSize: Dimensions.fontSizeLarge),
              //             maxLines: 1,
              //             overflow: TextOverflow.ellipsis,
              //           ),
              //         ),
              //         SizedBox(width: Dimensions.PADDING_SIZE_SMALL),
              //         Icon(Icons.search,
              //             size: 25,
              //             color: Theme.of(context).textTheme.bodyText1.color),
              //       ]),
              //     ),
              //   ),
            ),
            Positioned(
              bottom: Dimensions.PADDING_SIZE_LARGE,
              left: Dimensions.PADDING_SIZE_SMALL,
              right: Dimensions.PADDING_SIZE_SMALL,
              child: !locationController.isLoading
                  ? CustomButton(
                      buttonText:

                          ///if the user is in the location zone
                          ///then check the user is from address screen
                          ///show pick address txt
                          ///else show pick location txt
                          /// if the user is not in the provieded location zone
                          /// then show service not available txt
                          locationController.inZone
                              ? widget.fromAddAddress
                                  ? 'pick_address'.tr
                                  : 'pick_location'.tr
                              : 'service_not_available_in_this_area'.tr,

                      /// if the button is disabled or loading  then make it null
                      /// else make it clickable and
                      onPressed: (locationController.buttonDisabled ||
                              locationController.loading)
                          ? null
                          : () {
                              if (locationController.pickPosition.latitude !=
                                      0 &&
                                  locationController.pickAddress.isNotEmpty) {
                                if (widget.fromAddAddress) {
                                  if (widget.googleMapController != null) {
                                    widget.googleMapController.moveCamera(
                                        CameraUpdate.newCameraPosition(
                                            CameraPosition(
                                                target: LatLng(
                                                  locationController
                                                      .pickPosition.latitude,
                                                  locationController
                                                      .pickPosition.longitude,
                                                ),
                                                zoom: 17)));
                                    locationController.setAddAddressData();
                                  }
                                  Get.back();
                                } else {
                                  AddressModel _address = AddressModel(
                                    latitude: locationController
                                        .pickPosition.latitude
                                        .toString(),
                                    longitude: locationController
                                        .pickPosition.longitude
                                        .toString(),
                                    addressType: 'others',
                                    address: locationController.pickAddress,
                                  );
                                  locationController.saveAddressAndNavigate(
                                      _address,
                                      widget.fromSignUp,
                                      widget.route,
                                      widget.canRoute);
                                }
                              } else {
                                showCustomSnackBar('pick_an_address'.tr);
                              }
                            },
                    )
                  : Center(child: CircularProgressIndicator()),
            ),
          ]);
        }),
      ))),
    );
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
