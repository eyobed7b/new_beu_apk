import 'package:efood_multivendor/controller/auth_controller.dart';
import 'package:efood_multivendor/controller/restaurant_controller.dart';
import 'package:efood_multivendor/controller/splash_controller.dart';
import 'package:efood_multivendor/controller/wishlist_controller.dart';
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
import 'package:efood_multivendor/view/base/rating_bar.dart';
import 'package:efood_multivendor/view/screens/restaurant/restaurant_screen.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:get/get.dart';

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
    }

    return InkWell(
      onTap: () {
        if (isRestaurant) {
          Get.toNamed(RouteHelper.getRestaurantRoute(restaurant.id),
              arguments: RestaurantScreen(restaurant: restaurant));
        } else {
          ResponsiveHelper.isMobile(context)
              ? Get.bottomSheet(
                  ProductBottomSheet(
                      product: product,
                      inRestaurantPage: inRestaurant,
                      isCampaign: isCampaign),
                  backgroundColor: Colors.transparent,
                  isScrollControlled: true,
                )
              : Get.dialog(
                  Dialog(
                      child: ProductBottomSheet(
                          product: product,
                          inRestaurantPage: inRestaurant,
                          isCampaign: isCampaign)),
                );
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
                    height: _desktop ? 120 : 15.h,
                    width: _desktop ? 120 : 15.h,
                    fit: BoxFit.cover,
                  ),
                  RatingTag(rating: restaurant.avgRating),
                  _isAvailable
                      ? SizedBox()
                      : NotAvailableWidget(isRestaurant: isRestaurant),
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
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        isRestaurant ? restaurant.name : product.name,
                        style: sfBold.copyWith(
                            fontSize: Dimensions.fontSizeDefault),
                        maxLines: _desktop ? 2 : 1,
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
                                  "Avg $_avgPrice Br.",
                                  style: sfRegular.copyWith(
                                    fontSize: Dimensions.fontSizeExtraSmall,
                                    color: Colors.black,
                                  ),
                                  maxLines: _desktop ? 2 : 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            )
                          : Text(
                              product.restaurantName ?? '',
                              style: sfRegular.copyWith(
                                fontSize: Dimensions.fontSizeExtraSmall,
                                color: Theme.of(context).disabledColor,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                      SizedBox(height: (_desktop || isRestaurant) ? 5 : 0),
                      !isRestaurant
                          ? RatingBar(
                              rating: isRestaurant
                                  ? restaurant.avgRating
                                  : product.avgRating,
                              size: _desktop ? 15 : 12,
                              ratingCount: isRestaurant
                                  ? restaurant.ratingCount
                                  : product.ratingCount,
                            )
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
                                    fontSize: Dimensions.fontSizeExtraSmall,
                                    color: Colors.black,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                      SizedBox(height: Dimensions.PADDING_SIZE_EXTRA_SMALL),
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
                                  "$distance m",
                                  style: sfRegular.copyWith(
                                    fontSize: Dimensions.fontSizeExtraSmall,
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
                                    fontSize: Dimensions.fontSizeExtraSmall),
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
                    ]),
              ),
              Column(
                  mainAxisAlignment: isRestaurant
                      ? MainAxisAlignment.center
                      : MainAxisAlignment.spaceBetween,
                  children: [
                    !isRestaurant
                        ? Padding(
                            padding: EdgeInsets.symmetric(
                                vertical: _desktop
                                    ? Dimensions.PADDING_SIZE_SMALL
                                    : 0),
                            child: Icon(Icons.add, size: _desktop ? 30 : 25),
                          )
                        : SizedBox(),
                    // GetBuilder<WishListController>(builder: (wishController) {
                    //   bool _isWished = isRestaurant
                    //       ? wishController.wishRestIdList
                    //           .contains(restaurant.id)
                    //       : wishController.wishProductIdList
                    //           .contains(product.id);
                    //   return InkWell(
                    //     onTap: () {
                    //       if (Get.find<AuthController>().isLoggedIn()) {
                    //         _isWished
                    //             ? wishController.removeFromWishList(
                    //                 isRestaurant ? restaurant.id : product.id,
                    //                 isRestaurant)
                    //             : wishController.addToWishList(
                    //                 product, restaurant, isRestaurant);
                    //       } else {
                    //         showCustomSnackBar('you_are_not_logged_in'.tr);
                    //       }
                    //     },
                    //     child: Padding(
                    //       padding: EdgeInsets.symmetric(
                    //           vertical:
                    //               _desktop ? Dimensions.PADDING_SIZE_SMALL : 0),
                    //       child: Icon(
                    //         _isWished ? Icons.favorite : Icons.favorite_border,
                    //         size: _desktop ? 30 : 25,
                    //         color: _isWished
                    //             ? Theme.of(context).primaryColor
                    //             : Theme.of(context).disabledColor,
                    //       ),
                    //     ),
                    //   );
                    // }),
                  ]),
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
