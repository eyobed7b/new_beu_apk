import 'dart:ui';

import 'package:efood_multivendor/controller/cart_controller.dart';
import 'package:efood_multivendor/controller/category_controller.dart';
import 'package:efood_multivendor/controller/coupon_controller.dart';
import 'package:efood_multivendor/controller/localization_controller.dart';
import 'package:efood_multivendor/controller/restaurant_controller.dart';
import 'package:efood_multivendor/controller/splash_controller.dart';
import 'package:efood_multivendor/data/model/response/category_model.dart';
import 'package:efood_multivendor/data/model/response/product_model.dart';
import 'package:efood_multivendor/data/model/response/restaurant_model.dart';
import 'package:efood_multivendor/helper/date_converter.dart';
import 'package:efood_multivendor/helper/price_converter.dart';
import 'package:efood_multivendor/helper/responsive_helper.dart';
import 'package:efood_multivendor/helper/route_helper.dart';
import 'package:efood_multivendor/helper/size_config.dart';
import 'package:efood_multivendor/util/dimensions.dart';
import 'package:efood_multivendor/util/images.dart';
import 'package:efood_multivendor/util/styles.dart';
import 'package:efood_multivendor/view/base/cart_widget.dart';
import 'package:efood_multivendor/view/base/custom_image.dart';
import 'package:efood_multivendor/view/base/custom_snackbar.dart';
import 'package:efood_multivendor/view/base/product_view.dart';
import 'package:efood_multivendor/view/base/web_menu_bar.dart';
import 'package:efood_multivendor/view/screens/cart/widget/cart_widget.dart';
import 'package:efood_multivendor/view/screens/restaurant/widget/category_list.dart';
import 'package:efood_multivendor/view/screens/restaurant/widget/restaurant_description_view.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:get/get.dart';

const _cardColor = LinearGradient(colors: [
  Color(0xffff8022),
  Color(0xffff2222),
]);
const _cardColor2 = LinearGradient(colors: [
  Color.fromARGB(255, 201, 201, 201),
  Color.fromARGB(255, 194, 194, 194),
]);
const _maxHeight = 350.0;
const _minHeight = 62.0;

class RestaurantScreen extends StatefulWidget {
  final Restaurant restaurant;
  RestaurantScreen({@required this.restaurant});

  @override
  State<RestaurantScreen> createState() => _RestaurantScreenState();
}

class _RestaurantScreenState extends State<RestaurantScreen>
    with SingleTickerProviderStateMixin {
  final ScrollController scrollController = ScrollController();
  AnimationController _controller;
  double _currentHeight = _minHeight;

  @override
  void initState() {
    super.initState();

    Get.find<RestaurantController>()
        .getRestaurantDetails(Restaurant(id: widget.restaurant.id));
    if (Get.find<CategoryController>().categoryList == null) {
      Get.find<CategoryController>().getCategoryList(true);
    }
    Get.find<RestaurantController>()
        .getRestaurantProductList(widget.restaurant.id, 1, 'all', false);
    scrollController?.addListener(() {
      if (scrollController.position.pixels ==
              scrollController.position.maxScrollExtent &&
          Get.find<RestaurantController>().restaurantProducts != null &&
          !Get.find<RestaurantController>().foodPaginate) {
        int pageSize =
            (Get.find<RestaurantController>().foodPageSize / 10).ceil();
        if (Get.find<RestaurantController>().foodOffset < pageSize) {
          Get.find<RestaurantController>()
              .setFoodOffset(Get.find<RestaurantController>().foodOffset + 1);
          print('end of the page');
          Get.find<RestaurantController>().showFoodBottomLoader();
          Get.find<RestaurantController>().getRestaurantProductList(
            widget.restaurant.id,
            Get.find<RestaurantController>().foodOffset,
            Get.find<RestaurantController>().type,
            false,
          );
        }
      }
    });
    _controller = AnimationController(
      animationBehavior: AnimationBehavior.preserve,
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
  }

  @override
  void dispose() {
    super.dispose();

    scrollController?.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final menuWidth = size.width / 1.05;

    return GetBuilder<CartController>(builder: (cartController) {
      if (cartController.cartList.isEmpty) {
        cartController.closeCart();
        _controller.reverse(from: 0.5);
      }
      return Scaffold(
          appBar: ResponsiveHelper.isDesktop(context) ? WebMenuBar() : null,
          backgroundColor: Theme.of(context).cardColor,
          body: GestureDetector(
            onTap: cartController.isCartOpen
                ? () {
                    if (kDebugMode) {
                      print("BackDrop onTap called");
                    }

                    cartController.closeCart();

                    _controller.reverse(from: 0.5);
                  }
                : () {},
            child: Stack(
              children: [
                GetBuilder<RestaurantController>(builder: (restController) {
                  return GetBuilder<CategoryController>(
                      builder: (categoryController) {
                    Restaurant _restaurant;
                    if (restController.restaurant != null &&
                        restController.restaurant.name != null &&
                        categoryController.categoryList != null) {
                      _restaurant = restController.restaurant;

                      DateConverter.isAvailable(
                          _restaurant.openingTime, _restaurant.closeingTime);
                    }

                    restController.setCategoryList();

                    return (restController.restaurant != null &&
                            restController.restaurant.name != null &&
                            categoryController.categoryList != null)
                        ? CustomScrollView(
                            physics: AlwaysScrollableScrollPhysics(),
                            controller: scrollController,
                            slivers: [
                              ResponsiveHelper.isDesktop(context)
                                  ? SliverToBoxAdapter(
                                      child: Container(
                                        color: Color(0xFF171A29),
                                        padding: EdgeInsets.all(
                                            Dimensions.PADDING_SIZE_LARGE),
                                        alignment: Alignment.center,
                                        child: Center(
                                            child: SizedBox(
                                                width: Dimensions.WEB_MAX_WIDTH,
                                                child: Padding(
                                                  padding: EdgeInsets.symmetric(
                                                      horizontal: Dimensions
                                                          .PADDING_SIZE_SMALL),
                                                  child: Row(children: [
                                                    Expanded(
                                                      child: ClipRRect(
                                                        borderRadius: BorderRadius
                                                            .circular(Dimensions
                                                                .RADIUS_SMALL),
                                                        child: CustomImage(
                                                          fit: BoxFit.cover,
                                                          placeholder: Images
                                                              .restaurant_cover,
                                                          height: 220,
                                                          image:
                                                              '${Get.find<SplashController>().configModel.baseUrls.restaurantCoverPhotoUrl}/${_restaurant.coverPhoto}',
                                                        ),
                                                      ),
                                                    ),
                                                    SizedBox(
                                                        width: Dimensions
                                                            .PADDING_SIZE_LARGE),
                                                    Expanded(
                                                        child:
                                                            RestaurantDescriptionView(
                                                                restaurant:
                                                                    _restaurant)),
                                                  ]),
                                                ))),
                                      ),
                                    )
                                  : SliverAppBar(
                                      expandedHeight: 230,
                                      toolbarHeight: 50,
                                      pinned: true,
                                      floating: false,
                                      backgroundColor:
                                          Theme.of(context).primaryColor,
                                      leading: IconButton(
                                        icon: Icon(
                                          Icons.chevron_left,
                                          color: Theme.of(context).cardColor,
                                          size: 5.h,
                                        ),
                                        onPressed: () => Get.back(),
                                      ),
                                      flexibleSpace: FlexibleSpaceBar(
                                        background: Stack(children: [
                                          Container(
                                            decoration: BoxDecoration(
                                                color: Colors.white),
                                            child: ClipRRect(
                                                borderRadius:
                                                    BorderRadius.vertical(
                                                        bottom: Radius.circular(
                                                            10)),
                                                clipBehavior: Clip.antiAlias,
                                                child: CustomImage(
                                                  height: 35.h,
                                                  fit: BoxFit.cover,
                                                  placeholder:
                                                      Images.restaurant_cover,
                                                  image:
                                                      '${_restaurant.coverPhoto}',
                                                )),
                                          ),
                                          ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            clipBehavior: Clip.antiAlias,
                                            child: Container(
                                              height: 35.h,
                                              decoration: BoxDecoration(
                                                gradient: LinearGradient(
                                                  begin: Alignment.topCenter,
                                                  end: Alignment.bottomCenter,
                                                  colors: [
                                                    Colors.transparent,
                                                    Colors.black
                                                        .withOpacity(0.5),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                          Positioned(
                                            right: 2.w,
                                            top: 4.h,
                                            child: Container(
                                              padding: EdgeInsets.all(7),
                                              decoration: BoxDecoration(
                                                borderRadius: BorderRadius
                                                    .circular(Dimensions
                                                        .PADDING_SIZE_EXTRA_SMALL),
                                                gradient: LinearGradient(
                                                  begin: Alignment.topLeft,
                                                  end: Alignment.topRight,
                                                  colors: [
                                                    Theme.of(context)
                                                        .primaryColor,
                                                    Theme.of(context)
                                                        .colorScheme
                                                        .secondary,
                                                  ],
                                                ),
                                              ),
                                              // width: 10.w,
                                              // height: 3.w,
                                              child: Text(
                                                "Open now",
                                                style: sfBold.copyWith(
                                                    color: Colors.white),
                                              ),
                                            ),
                                          ),
                                          Positioned(
                                            bottom: 5,
                                            child: Padding(
                                              padding: EdgeInsets.only(
                                                  left: 5.w, bottom: 1.h),
                                              child: Row(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            2.h),
                                                    clipBehavior: Clip.hardEdge,
                                                    child: CustomImage(
                                                        image: _restaurant.logo,
                                                        height: 8.h,
                                                        width: 8.h),
                                                  ),
                                                  SizedBox(width: 5),
                                                  Padding(
                                                    padding: EdgeInsets.only(
                                                        top: 0.7.h),
                                                    child: Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .start,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text(
                                                          _restaurant.name,
                                                          style:
                                                              sfBlack.copyWith(
                                                                  color: Colors
                                                                      .white,
                                                                  fontSize: 18),
                                                        ),
                                                        SizedBox(
                                                          height: 0.6.h,
                                                        ),
                                                        Row(
                                                          children: [
                                                            Icon(
                                                              FeatherIcons
                                                                  .mapPin,
                                                              color:
                                                                  Colors.white,
                                                              size: 2.h,
                                                            ),
                                                            SizedBox(
                                                              width: 10,
                                                            ),
                                                            Text(
                                                              _restaurant
                                                                      .address ??
                                                                  "No address set",
                                                              style: sfRegular
                                                                  .copyWith(
                                                                      color: Colors
                                                                          .white),
                                                            ),
                                                          ],
                                                        ),
                                                      ],
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ),
                                          )
                                        ]),
                                      ),
                                      // actions: [
                                      //   IconButton(
                                      //     onPressed: () =>
                                      //         Get.toNamed(RouteHelper.getCartRoute()),
                                      //     icon: Container(
                                      //       height: 50,
                                      //       width: 50,
                                      //       decoration: BoxDecoration(
                                      //           shape: BoxShape.circle,
                                      //           color: Theme.of(context).primaryColor),
                                      //       alignment: Alignment.center,
                                      //       child: CartWidget(
                                      //           color: Theme.of(context).cardColor,
                                      //           size: 15,
                                      //           fromRestaurant: true),
                                      //     ),
                                      //   )
                                      // ],
                                    ),
                              SliverToBoxAdapter(
                                  child: Center(
                                      child: Container(
                                width: Dimensions.WEB_MAX_WIDTH,
                                padding: EdgeInsets.all(
                                    Dimensions.PADDING_SIZE_SMALL),
                                color: Theme.of(context).cardColor,
                                child: Column(children: [
                                  ResponsiveHelper.isDesktop(context)
                                      ? SizedBox()
                                      // : SizedBox(),
                                      : RestaurantDescriptionView(
                                          restaurant: _restaurant),
                                  // SliverToBoxAdapter(
                                  //   child: SizedBox(height: 5.h),
                                  // ),
                                  _restaurant.discount != null
                                      ? Container(
                                          width: context.width,
                                          margin: EdgeInsets.symmetric(
                                              vertical: Dimensions
                                                  .PADDING_SIZE_SMALL),
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(
                                                      Dimensions.RADIUS_SMALL),
                                              color: Theme.of(context)
                                                  .primaryColor),
                                          padding: EdgeInsets.all(
                                              Dimensions.PADDING_SIZE_SMALL),
                                          child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Text(
                                                  _restaurant.discount
                                                              .discountType ==
                                                          'percent'
                                                      ? '${_restaurant.discount.discount}% OFF'
                                                      : '${PriceConverter.convertPrice(_restaurant.discount.discount)} OFF',
                                                  style: sfMedium.copyWith(
                                                      fontSize: Dimensions
                                                          .fontSizeLarge,
                                                      color: Theme.of(context)
                                                          .cardColor),
                                                ),
                                                Text(
                                                  _restaurant.discount
                                                              .discountType ==
                                                          'percent'
                                                      ? '${'enjoy'.tr} ${_restaurant.discount.discount}% ${'off_on_all_categories'.tr}'
                                                      : '${'enjoy'.tr} ${PriceConverter.convertPrice(_restaurant.discount.discount)}'
                                                          ' ${'off_on_all_categories'.tr}',
                                                  style: sfMedium.copyWith(
                                                      fontSize: Dimensions
                                                          .fontSizeSmall,
                                                      color: Theme.of(context)
                                                          .cardColor),
                                                ),
                                                SizedBox(
                                                    height: (_restaurant
                                                                    .discount
                                                                    .minPurchase !=
                                                                0 ||
                                                            _restaurant.discount
                                                                    .maxDiscount !=
                                                                0)
                                                        ? 5
                                                        : 0),
                                                _restaurant.discount
                                                            .minPurchase !=
                                                        0
                                                    ? Text(
                                                        '[ ${'minimum_purchase'.tr}: ${PriceConverter.convertPrice(_restaurant.discount.minPurchase)} ]',
                                                        style: sfRegular.copyWith(
                                                            fontSize: Dimensions
                                                                .fontSizeExtraSmall,
                                                            color: Theme.of(
                                                                    context)
                                                                .cardColor),
                                                      )
                                                    : SizedBox(),
                                                _restaurant.discount
                                                            .maxDiscount !=
                                                        0
                                                    ? Text(
                                                        '[ ${'maximum_discount'.tr}: ${PriceConverter.convertPrice(_restaurant.discount.maxDiscount)} ]',
                                                        style: sfRegular.copyWith(
                                                            fontSize: Dimensions
                                                                .fontSizeExtraSmall,
                                                            color: Theme.of(
                                                                    context)
                                                                .cardColor),
                                                      )
                                                    : SizedBox(),
                                                Text(
                                                  '[ ${'daily_time'.tr}: ${DateConverter.convertTimeToTime(_restaurant.discount.startTime)} '
                                                  '- ${DateConverter.convertTimeToTime(_restaurant.discount.endTime)} ]',
                                                  style: sfRegular.copyWith(
                                                      fontSize: Dimensions
                                                          .fontSizeExtraSmall,
                                                      color: Theme.of(context)
                                                          .cardColor),
                                                ),
                                              ]),
                                        )
                                      : SizedBox(),
                                ]),
                              ))),
                              (restController.categoryList.length > 0)
                                  ? SliverPersistentHeader(
                                      pinned: true,
                                      delegate: SliverDelegate(
                                          child: Center(
                                              child: Container(
                                        height: 40,
                                        width: Dimensions.WEB_MAX_WIDTH,
                                        color: Theme.of(context).cardColor,
                                        padding: EdgeInsets.symmetric(
                                            vertical: Dimensions
                                                .PADDING_SIZE_EXTRA_SMALL),
                                        child: ListView.builder(
                                          scrollDirection: Axis.horizontal,
                                          itemCount: restController
                                              .categoryList.length,
                                          padding: EdgeInsets.only(
                                              left: Dimensions
                                                  .PADDING_SIZE_SMALL),
                                          physics: BouncingScrollPhysics(),
                                          itemBuilder: (context, index) {
                                            return CategoryTabItem(
                                                index: index,
                                                restController: restController);
                                          },
                                        ),
                                      ))),
                                    )
                                  : SliverToBoxAdapter(child: SizedBox()),
                              SliverToBoxAdapter(
                                  child: SizedBox(
                                height: 2.h,
                              )),
                              SliverToBoxAdapter(
                                  child: Center(
                                      child: Container(
                                width: Dimensions.WEB_MAX_WIDTH,
                                decoration: BoxDecoration(
                                  color: Theme.of(context).cardColor,
                                ),
                                child: Column(children: [
                                  ProductView(
                                    isRestaurant: false,
                                    restaurants: null,
                                    products:
                                        restController.categoryList.length > 0
                                            ? restController.restaurantProducts
                                            : null,
                                    inRestaurantPage: true,
                                    type: restController.type,
                                    onVegFilterTap: (String type) {
                                      restController.getRestaurantProductList(
                                          restController.restaurant.id,
                                          1,
                                          type,
                                          true);
                                    },
                                    padding: EdgeInsets.symmetric(
                                      horizontal: Dimensions.PADDING_SIZE_SMALL,
                                      vertical:
                                          ResponsiveHelper.isDesktop(context)
                                              ? Dimensions.PADDING_SIZE_SMALL
                                              : 0,
                                    ),
                                  ),
                                  restController.foodPaginate
                                      ? Center(
                                          child: Padding(
                                          padding: EdgeInsets.all(
                                              Dimensions.PADDING_SIZE_SMALL),
                                          child: CircularProgressIndicator(),
                                        ))
                                      : SizedBox(),
                                ]),
                              ))),
                            ],
                          )
                        : Center(child: CircularProgressIndicator());
                  });
                }),
                cartController.isCartOpen
                    ? Expanded(
                        child: BackdropFilter(
                          filter:
                              new ImageFilter.blur(sigmaX: 1.0, sigmaY: 1.0),
                          child: Expanded(
                            child: SizedBox(),
                          ),
                        ),
                      )
                    : SizedBox()
              ],
            ),
          ),
          extendBody: true,

          /// offstage is used to hide the body while the app is loading
          bottomNavigationBar: Offstage(
            offstage: cartController.cartList.isEmpty,
            child: GestureDetector(
              onVerticalDragUpdate: cartController.isCartOpen
                  ? (value) {
                      setState(() {
                        final newHeight = _currentHeight - value.delta.dy;
                        _controller.value = _currentHeight / _maxHeight;
                        _currentHeight =
                            newHeight.clamp(_minHeight, _maxHeight);
                      });
                    }
                  : null,
              onVerticalDragEnd: (value) {
                if (_currentHeight < _maxHeight / 2) {
                  _controller.reverse();
                  cartController.closeCart();
                } else {
                  cartController.openCart();
                  _controller.forward(from: _currentHeight / _maxHeight);
                  _currentHeight = _maxHeight;
                }
              },
              child: AnimatedBuilder(
                  animation: _controller,
                  builder: (context, snapshot) {
                    final value = const ElasticInOutCurve(0.7)
                        .transform(_controller.value);
                    return Stack(
                      children: [
                        Positioned(
                            height:
                                lerpDouble(_minHeight, _currentHeight, value),
                            // width: lerpDouble(menuWidth, menuWidth, value),
                            left: lerpDouble(size.width / 2 - menuWidth / 2,
                                (size.width - menuWidth) / 2, value),
                            right: lerpDouble(size.width / 2 - menuWidth / 2,
                                (size.width - menuWidth) / 2, value),
                            bottom: lerpDouble(20.0, 20.0, value),
                            child: Container(
                                decoration: BoxDecoration(
                                  gradient:
                                      _cardColor.lerpTo(_cardColor2, value),
                                  borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(lerpDouble(
                                          size.width * 1.0,
                                          size.width * 0.04,
                                          value)),
                                      topRight: Radius.circular(lerpDouble(
                                          size.width * 1.0,
                                          size.width * 0.04,
                                          value)),
                                      bottomLeft: Radius.circular(lerpDouble(
                                          size.width * 1.0,
                                          size.width * 0.08,
                                          value)),
                                      bottomRight: Radius.circular(lerpDouble(
                                          size.width * 1.0,
                                          size.width * 0.08,
                                          value))),
                                ),
                                child: cartController.isCartOpen
                                    ? Opacity(
                                        opacity: _controller.value,
                                        child: _buildExpandedContent(
                                            cartController))
                                    : Center(
                                        child: _buildMeanuContent(
                                            cartController)))),
                      ],
                    );
                  }),
            ),
          ));
    });
  }

  Widget _buildExpandedContent(CartController cartController) {
    final size = MediaQuery.of(context).size;

    return Container(
      decoration: BoxDecoration(boxShadow: [
        BoxShadow(
          spreadRadius: 5,
          blurRadius: 5,
          offset: Offset(0, 3),
          color: Theme.of(context).colorScheme.secondary.withOpacity(0.18),
        ),
      ], borderRadius: BorderRadius.circular(16), color: Colors.white),
      child: Stack(
        children: [
          ClipRect(
              child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 2.h),
            child: ListView.builder(
                itemCount: cartController.cartList.length + 1,
                shrinkWrap: true,
                itemBuilder: (ctx, index) {
                  return index != cartController.cartList.length
                      ? CartListItem(
                          index: index,
                        )
                      : SizedBox(
                          height: 8.h,
                        );
                }),
          )),
          Positioned(
            // alignment: Alignment.bottomCenter,
            bottom: 0,
            child: Container(
                height: _minHeight,
                width: size.width / 1.05,
                decoration: BoxDecoration(
                  gradient: _cardColor,
                  borderRadius: BorderRadius.circular(size.width * 1),
                ),
                child: _buildMeanuContent(cartController)),
          )
        ],
      ),
    );
  }

  Widget _buildMeanuContent(CartController cartController) {
    final size = MediaQuery.of(context).size;
    return GetBuilder<CartController>(builder: (cartController) {
      List<List<AddOns>> _addOnsList = [];
      List<bool> _availableList = [];
      double _itemPrice = 0;
      double _addOns = 0;
      cartController.cartList.forEach((cartModel) {
        List<AddOns> _addOnList = [];
        cartModel.addOnIds.forEach((addOnId) {
          for (AddOns addOns in cartModel.product.addOns) {
            if (addOns.id == addOnId.id) {
              _addOnList.add(addOns);
              break;
            }
          }
        });
        _addOnsList.add(_addOnList);

        _availableList.add(DateConverter.isAvailable(
            cartModel.product.availableTimeStarts,
            cartModel.product.availableTimeEnds));

        for (int index = 0; index < _addOnList.length; index++) {
          _addOns = _addOns +
              (_addOnList[index].price * cartModel.addOnIds[index].quantity);
        }
        _itemPrice = _itemPrice + (cartModel.price * cartModel.quantity);
      });
      double _subTotal = _itemPrice + _addOns;
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 7),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            GestureDetector(
              onTap: () {
                if (!cartController.isCartOpen) {
                  _currentHeight = _maxHeight;
                  _controller.forward(from: 0.0);
                  cartController.openCart();
                  // _controller.reverse();
                } else {
                  cartController.closeCart();
                  // _currentHeight = _maxHeight;
                  // _controller.forward(from: 0.0);
                  _controller.reverse(from: 0.5);
                }
              },
              child: SizedBox(
                height: size.width * 1,
                width: size.width * 0.2,
                child: Stack(
                  children: [
                    Container(
                      width: size.width * 0.13,
                      height: size.width * 0.13,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(100)),
                    ),
                    SizedBox(
                      width: size.width * 0.11,
                      height: size.width * 0.11,
                      child: Image.network(
                        "https://firebasestorage.googleapis.com/v0/b/pickme-551111.appspot.com/o/Vector.png?alt=media&token=2de07201-3680-4b63-b205-546f5a6df256",
                      ),
                    ),
                    Positioned(
                      top: 0,
                      left: 40,
                      child: Container(
                        width: size.width * 0.08,
                        height: size.width * 0.08,
                        decoration: BoxDecoration(
                            gradient: const LinearGradient(
                                begin: Alignment.centerLeft,
                                end: Alignment.centerRight,
                                colors: [Color(0xffff8022), Color(0xffff2222)]),
                            borderRadius: BorderRadius.circular(100)),
                        child: Center(
                          child: Text(
                            cartController.cartList.length.toString(),
                            style: TextStyle(color: Colors.white, fontSize: 20),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            FittedBox(
              fit: BoxFit.scaleDown,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// Put your child her
                  Text(
                    cartController.amount.toString() + "birr".tr,
                    style: TextStyle(
                        fontSize: 20,
                        color: Colors.white,
                        fontWeight: FontWeight.bold),
                  ),
                  Text(
                    "15 ${"birr".tr} ${"deliv_fee".tr}",
                    style: TextStyle(
                        fontSize: 15,
                        color: Colors.white,
                        fontWeight: FontWeight.w300),
                  ),
                ],
              ),
            ),
            const SizedBox(
              width: 25,
            ),
            GestureDetector(
              onTap: () {
                // Get.toNamed(RouteHelper.getCartRoute())

                if (!cartController.cartList.first.product.scheduleOrder &&
                    _availableList.contains(false)) {
                  showCustomSnackBar('one_or_more_product_unavailable'.tr);
                } else {
                  Get.find<CouponController>().removeCouponData(false);
                  Get.toNamed(RouteHelper.getCheckoutRoute('cart'));
                }
              },
              child: Container(
                width: size.width * 0.3,
                height: size.width * 0.12,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(100)),
                child: const Center(
                  child: Text(
                    "Buy Now",
                    style: TextStyle(
                        color: Colors.red,
                        fontSize: 18,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            )
          ],
        ),
      );
    });
  }
}

class SliverDelegate extends SliverPersistentHeaderDelegate {
  Widget child;

  SliverDelegate({@required this.child});

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return child;
  }

  @override
  double get maxExtent => 50;

  @override
  double get minExtent => 50;

  @override
  bool shouldRebuild(SliverDelegate oldDelegate) {
    return oldDelegate.maxExtent != 50 ||
        oldDelegate.minExtent != 50 ||
        child != oldDelegate.child;
  }
}

class CategoryProduct {
  CategoryModel category;
  List<Product> products;
  CategoryProduct(this.category, this.products);
}
