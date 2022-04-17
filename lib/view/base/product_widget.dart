import 'dart:io';

import 'package:efood_multivendor/controller/auth_controller.dart';
import 'package:efood_multivendor/controller/cart_controller.dart';
import 'package:efood_multivendor/controller/restaurant_controller.dart';
import 'package:efood_multivendor/controller/splash_controller.dart';
import 'package:efood_multivendor/controller/wishlist_controller.dart';
import 'package:efood_multivendor/data/model/response/cart_model.dart';
import 'package:efood_multivendor/data/model/response/config_model.dart';
import 'package:efood_multivendor/data/model/response/product_model.dart';
import 'package:efood_multivendor/data/model/response/restaurant_model.dart';
import 'package:efood_multivendor/helper/date_converter.dart';
import 'package:efood_multivendor/helper/price_converter.dart';
import 'package:efood_multivendor/helper/responsive_helper.dart';
import 'package:efood_multivendor/helper/route_helper.dart';
import 'package:efood_multivendor/helper/size_config.dart';
import 'package:efood_multivendor/util/dimensions.dart';
import 'package:efood_multivendor/util/functions.dart';
import 'package:efood_multivendor/util/styles.dart';
import 'package:efood_multivendor/view/base/custom_image.dart';
import 'package:efood_multivendor/view/base/custom_snackbar.dart';
import 'package:efood_multivendor/view/base/discount_tag.dart';
import 'package:efood_multivendor/view/base/not_available_widget.dart';
import 'package:efood_multivendor/view/base/product_bottom_sheet.dart';
import 'package:efood_multivendor/view/base/quantity_button.dart';
import 'package:efood_multivendor/view/base/rating_bar.dart';
import 'package:efood_multivendor/view/screens/product/prdouct_screen.dart';
import 'package:efood_multivendor/view/screens/restaurant/restaurant_screen.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:get/get.dart';

import '../../util/images.dart';
import 'confirmation_dialog.dart';

class ProductWidget extends StatelessWidget {
  final Product product;
  final Restaurant restaurant;
  final bool isRestaurant;
  final int index;
  final int length;
  final bool inRestaurant;
  final bool isCampaign;
  ProductWidget(
      {@required this.product,
      @required this.isRestaurant,
      @required this.restaurant,
      @required this.index,
      @required this.length,
      this.inRestaurant = false,
      this.isCampaign = false});

  @override
  Widget build(BuildContext context) {
    BaseUrls _baseUrls = Get.find<SplashController>().configModel.baseUrls;
    bool _desktop = ResponsiveHelper.isDesktop(context);
    double _discount;
    String _discountType;
    bool _isAvailable;
    int _avgPrice = 147;
    int distance = 500;
    String imageExecuted =
        '${isCampaign ? _baseUrls.campaignImageUrl : isRestaurant ? UtilFunctions.startsWitHTTP(restaurant.logo) ? "" : "${_baseUrls.restaurantImageUrl}/" : UtilFunctions.startsWitHTTP(product.image) ? "" : "${_baseUrls.productImageUrl}/"}'
        '${isRestaurant ? restaurant.logo : product.image}';
    if (kDebugMode) {
      print("Image Executed is: $imageExecuted");
      try {
        print("Restaurant address is: ${restaurant.address}");
      } catch (e) {}
    }
    CartModel _cartModel = null;
    if (isRestaurant) {
      bool _isClosedToday = Get.find<RestaurantController>()
          .isRestaurantClosed(true, restaurant.active, restaurant.offDay);
      _discount =
          restaurant.discount != null ? restaurant.discount.discount : 0;
      _discountType = restaurant.discount != null
          ? restaurant.discount.discountType
          : 'percent';
      _isAvailable = DateConverter.isAvailable(
              restaurant.openingTime, restaurant.closeingTime) &&
          restaurant.active &&
          !_isClosedToday;
    } else {
      _discount = (product.restaurantDiscount == 0 || isCampaign)
          ? product.discount
          : product.restaurantDiscount;
      _discountType = (product.restaurantDiscount == 0 || isCampaign)
          ? product.discountType
          : 'percent';
      _isAvailable = DateConverter.isAvailable(
              product.availableTimeStarts, product.availableTimeEnds) &&
          DateConverter.isAvailable(
              product.restaurantOpeningTime, product.restaurantClosingTime);
      _cartModel = CartModel(
        product.price,
        product.price - product.discount,
        [],
        product.discount,
        1,
        [],
        [],
        false,
        product,
      );
    }

    return InkWell(
      onTap: () {
        if (isRestaurant) {
          Get.toNamed(RouteHelper.getRestaurantRoute(restaurant.id),
              arguments: RestaurantScreen(restaurant: restaurant));
        } else {
          Get.toNamed(RouteHelper.getProductRoute(product.id),
              arguments: ProductScreen(
                product: product,
              ));
          // ResponsiveHelper.isMobile(context)
          //     ? Get.bottomSheet(
          //         ProductBottomSheet(
          //             product: product,
          //             inRestaurantPage: inRestaurant,
          //             isCampaign: isCampaign),
          //         backgroundColor: Colors.transparent,
          //         isScrollControlled: true,
          //       )
          //     : Get.dialog(
          //         Dialog(
          //             child: ProductBottomSheet(
          //                 product: product,
          //                 inRestaurantPage: inRestaurant,
          //                 isCampaign: isCampaign)),
          //       );
        }
      },
      child: Container(
        height: 20.h,
        padding: ResponsiveHelper.isDesktop(context)
            ? EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL)
            : null,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(Dimensions.RADIUS_SMALL),
          color: ResponsiveHelper.isDesktop(context)
              ? Theme.of(context).cardColor
              : null,
          boxShadow: ResponsiveHelper.isDesktop(context)
              ? [
                  BoxShadow(
                    color: Colors.grey[Get.isDarkMode ? 700 : 300],
                    spreadRadius: 1,
                    blurRadius: 5,
                  )
                ]
              : null,
        ),
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Expanded(
              child: Padding(
            padding: EdgeInsets.symmetric(
                vertical: _desktop ? 0 : Dimensions.PADDING_SIZE_EXTRA_SMALL),
            child: Row(children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(Dimensions.RADIUS_SMALL),
                child: Stack(children: [
                  CustomImage(
                    image:
                        '${isCampaign ? _baseUrls.campaignImageUrl : isRestaurant ? UtilFunctions.startsWitHTTP(restaurant.logo) ? "" : "${_baseUrls.restaurantImageUrl}/" : UtilFunctions.startsWitHTTP(product.image) ? "" : "${_baseUrls.productImageUrl}/"}'
                        '${isRestaurant ? restaurant.logo : product.image}',
                    height: _desktop ? 120 : 12.h,
                    width: _desktop ? 120 : 12.h,
                    fit: BoxFit.cover,
                  ),
                  isRestaurant
                      ? RatingTag(rating: restaurant.avgRating)
                      : SizedBox(),
                  _isAvailable
                      ? SizedBox()
                      : NotAvailableWidget(
                          isRestaurant: isRestaurant,
                          fontSize: Dimensions.fontSizeLarge * 0.8,
                        ),
                ]),
              ),

              // DiscountTag(
              //   discount: _discount,
              //   discountType: _discountType,
              //   freeDelivery: isRestaurant ? restaurant.freeDelivery : false,
              // ),

              SizedBox(width: Dimensions.PADDING_SIZE_SMALL),
              Expanded(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Spacer(),
                      Text(
                        isRestaurant ? restaurant.name : product.name,
                        style: sfBold.copyWith(
                            fontSize: isRestaurant
                                ? Dimensions.fontSizeLarge * 1.1
                                : Dimensions.fontSizeLarge),
                        maxLines: _desktop ? 3 : 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(
                          height: isRestaurant
                              ? Dimensions.PADDING_SIZE_EXTRA_SMALL
                              : 0),
                      isRestaurant
                          ? Row(
                              children: [
                                Icon(
                                  FeatherIcons.dollarSign,
                                  size: 1.5.h,
                                  color: Colors.deepOrange,
                                ),
                                SizedBox(
                                    width: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                                Text(
                                  "Avg ${restaurant.avgPrice} Br.",
                                  style: sfRegular.copyWith(
                                    fontSize: Dimensions.fontSizeDefault,
                                    color: Colors.black,
                                  ),
                                  maxLines: _desktop ? 2 : 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            )
                          : SizedBox(),
                      Spacer(),
                      !isRestaurant
                          ? SizedBox()
                          : Row(
                              children: [
                                Icon(
                                  FeatherIcons.clock,
                                  color: Colors.deepOrange,
                                  size: 1.5.h,
                                ),
                                SizedBox(
                                    width: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                                Text(
                                  "${restaurant.deliveryTime} Min",
                                  style: sfRegular.copyWith(
                                    fontSize: Dimensions.fontSizeDefault,
                                    color: Colors.black,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                      Spacer(),
                      isRestaurant
                          ?
                          // ? RatingBar(
                          //     rating: isRestaurant
                          //         ? restaurant.avgRating
                          //         : product.avgRating,
                          //     size: _desktop ? 15 : 12,
                          //     ratingCount: isRestaurant
                          //         ? restaurant.ratingCount
                          //         : product.ratingCount,
                          //   )
                          Row(
                              children: [
                                Icon(
                                  FeatherIcons.mapPin,
                                  color: Colors.deepOrange,
                                  size: 1.5.h,
                                ),
                                SizedBox(
                                    width: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                                Text(
                                  "${restaurant.distance}",
                                  style: sfRegular.copyWith(
                                    fontSize: Dimensions.fontSizeDefault,
                                    color: Colors.black,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            )
                          : Row(children: [
                              Text(
                                PriceConverter.convertPrice(product.price,
                                    discount: _discount,
                                    discountType: _discountType),
                                style: sfMedium.copyWith(
                                    fontSize: Dimensions.fontSizeLarge),
                              ),
                              SizedBox(
                                  width: _discount > 0
                                      ? Dimensions.PADDING_SIZE_EXTRA_SMALL
                                      : 0),
                              _discount > 0
                                  ? Text(
                                      PriceConverter.convertPrice(
                                          product.price),
                                      style: sfMedium.copyWith(
                                        fontSize: Dimensions.fontSizeExtraSmall,
                                        color: Theme.of(context).disabledColor,
                                        decoration: TextDecoration.lineThrough,
                                      ),
                                    )
                                  : SizedBox(),
                            ]),
                      Expanded(child: SizedBox())
                    ]),
              ),

              !isRestaurant
                  ?
                  // padding: EdgeInsets.symmetric(
                  //     vertical:
                  //         _desktop ? Dimensions.PADDING_SIZE_SMALL : 0,
                  //     horizontal: Dimensions.PADDING_SIZE_SMALL),
                  GetBuilder<CartController>(builder: (cartController) {
                      int qty = cartController.getQuantity(product);

                      return qty == 0
                          ? GestureDetector(
                              onTap: () {
                                if (!_isAvailable) {
                                  return;
                                }
                                if (Get.find<CartController>()
                                    .existAnotherRestaurantProduct(
                                        _cartModel.product.restaurantId)) {
                                  Get.dialog(
                                      ConfirmationDialog(
                                        icon: Images.warning,
                                        title: 'are_you_sure_to_reset'.tr,
                                        description: 'if_you_continue'.tr,
                                        onYesPressed: () {
                                          Get.back();
                                          Get.find<CartController>()
                                              .removeAllAndAddToCart(
                                                  _cartModel);
                                        },
                                      ),
                                      barrierDismissible: false);
                                } else {
                                  Get.find<CartController>()
                                      .addToCart(_cartModel);
                                }
                              },
                              child: ShaderMask(
                                shaderCallback: ((bounds) {
                                  return LinearGradient(
                                    colors: _isAvailable
                                        ? [Color(0xffff8022), Color(0xffff2222)]
                                        : [Colors.grey, Colors.grey],
                                    tileMode: TileMode.repeated,
                                  ).createShader(bounds);
                                }),
                                child: Container(
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(Dimensions
                                              .PADDING_SIZE_EXTRA_SMALL)),
                                      border: Border.all(color: Colors.white)),
                                  width: 18.w,
                                  height: 3.5.h,
                                  child: Align(
                                    alignment: Alignment.center,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Icons.add,
                                          size: _desktop ? 30 : 20,
                                          color: Colors.white,
                                        ),
                                        Text("add".tr,
                                            style: sfRegular.copyWith(
                                                color: Colors.white))
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            )
                          : Row(
                              children: [
                                QuantityButton(
                                    isIncrement: false,
                                    onTap: () => _isAvailable
                                        ? cartController.removeFromCart(product)
                                        : () {}),
                                Text(
                                    cartController
                                        .getQuantity(product)
                                        .toString(),
                                    style: sfMedium.copyWith(
                                        fontSize:
                                            Dimensions.fontSizeExtraLarge)),
                                QuantityButton(
                                    isIncrement: true,
                                    onTap: () {
                                      if (!_isAvailable) {
                                        return;
                                      }
                                      if (Get.find<CartController>()
                                          .existAnotherRestaurantProduct(
                                              _cartModel
                                                  .product.restaurantId)) {
                                        Get.dialog(
                                            ConfirmationDialog(
                                              icon: Images.warning,
                                              title: 'are_you_sure_to_reset'.tr,
                                              description: 'if_you_continue'.tr,
                                              onYesPressed: () {
                                                Get.back();
                                                Get.find<CartController>()
                                                    .removeAllAndAddToCart(
                                                        _cartModel);
                                              },
                                            ),
                                            barrierDismissible: false);
                                      } else {
                                        Get.find<CartController>()
                                            .addToCart(_cartModel);
                                      }
                                    }),
                              ],
                            );
                      // : SizedBox();
                    })
                  : SizedBox(),
            ]),
          )),
          _desktop
              ? SizedBox()
              : Padding(
                  padding: EdgeInsets.only(left: _desktop ? 130 : 90),
                  child: Divider(
                      color: index == length - 1
                          ? Colors.transparent
                          : Theme.of(context).disabledColor),
                ),
        ]),
      ),
    );
  }
}

class RatingTag extends StatefulWidget {
  final double rating;
  RatingTag({Key key, @required this.rating}) : super(key: key);

  @override
  State<RatingTag> createState() => _RatingTagState();
}

class _RatingTagState extends State<RatingTag> {
  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 0,
      left: 0,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 2, vertical: 0),
        decoration: BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: [
                Theme.of(context).primaryColor,
                Theme.of(context).colorScheme.secondary
              ]),
        ),
        child: Center(
          child: Row(
            children: [
              Icon(
                Icons.star,
                size: 1.6.h,
                color: Colors.yellow,
              ),
              SizedBox(
                width: 1.w,
              ),
              Text(
                widget.rating.toString(),
                style: sfRegular.copyWith(
                  color: Colors.white,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
