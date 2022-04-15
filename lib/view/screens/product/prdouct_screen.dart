import 'dart:ui';

import 'package:efood_multivendor/controller/coupon_controller.dart';
import 'package:efood_multivendor/data/model/response/product_model.dart';
import 'package:efood_multivendor/helper/responsive_helper.dart';
import 'package:efood_multivendor/helper/route_helper.dart';
import 'package:efood_multivendor/helper/size_config.dart';
import 'package:efood_multivendor/util/styles.dart';
import 'package:efood_multivendor/view/base/custom_snackbar.dart';
import 'package:efood_multivendor/view/base/quantity_button.dart';
import 'package:efood_multivendor/view/base/web_menu_bar.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../controller/cart_controller.dart';
import '../../../controller/product_controller.dart';
import '../../../controller/splash_controller.dart';
import '../../../data/model/response/cart_model.dart';
import '../../../helper/date_converter.dart';
import '../../../helper/price_converter.dart';
import '../../../util/dimensions.dart';
import '../../../util/images.dart';
import '../../base/confirmation_dialog.dart';
import '../../base/custom_image.dart';
import '../cart/widget/cart_widget.dart';

const _cardColor = LinearGradient(colors: [
  Color(0xffff2222),
  Color(0xffff8022),
]);
const _cardColor2 = LinearGradient(colors: [
  Color.fromARGB(255, 201, 201, 201),
  Color.fromARGB(255, 194, 194, 194),
]);
const _maxHeight = 350.0;
const _minHeight = 62.0;

class ProductScreen extends StatefulWidget {
  final Product product;
  final bool isCampaign;
  final CartModel cart;
  final int cartIndex;
  final bool inRestaurantPage;
  ProductScreen(
      {Key key,
      @required this.product,
      this.isCampaign = false,
      this.cart,
      this.cartIndex,
      this.inRestaurantPage = false})
      : super(key: key);

  @override
  State<ProductScreen> createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen>
    with SingleTickerProviderStateMixin {
  final ScrollController scrollController = ScrollController();
  AnimationController _controller;

  double _currentHeight = _minHeight;
  @override
  void initState() {
    super.initState();

    Get.find<ProductController>().initData(widget.product, widget.cart);
    _controller = AnimationController(
      animationBehavior: AnimationBehavior.preserve,
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
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
              GetBuilder<ProductController>(builder: (productController) {
                double _startingPrice;
                double _endingPrice;
                if (widget.product.choiceOptions.length != 0) {
                  List<double> _priceList = [];
                  widget.product.variations
                      .forEach((variation) => _priceList.add(variation.price));
                  _priceList.sort((a, b) => a.compareTo(b));
                  _startingPrice = _priceList[0];
                  if (_priceList[0] < _priceList[_priceList.length - 1]) {
                    _endingPrice = _priceList[_priceList.length - 1];
                  }
                } else {
                  _startingPrice = widget.product.price;
                }
                List<String> _variationList = [];
                for (int index = 0;
                    index < widget.product.choiceOptions.length;
                    index++) {
                  _variationList.add(widget.product.choiceOptions[index]
                      .options[productController.variationIndex[index]]
                      .replaceAll(' ', ''));
                }
                String variationType = '';
                bool isFirst = true;
                _variationList.forEach((variation) {
                  if (isFirst) {
                    variationType = '$variationType$variation';
                    isFirst = false;
                  } else {
                    variationType = '$variationType-$variation';
                  }
                });

                double price = widget.product.price;
                Variation _variation;
                for (Variation variation in widget.product.variations) {
                  if (variation.type == variationType) {
                    price = variation.price;
                    _variation = variation;
                    break;
                  }
                }

                double _discount = (widget.isCampaign ||
                        widget.product.restaurantDiscount == 0)
                    ? widget.product.discount
                    : widget.product.restaurantDiscount;
                String _discountType = (widget.isCampaign ||
                        widget.product.restaurantDiscount == 0)
                    ? widget.product.discountType
                    : 'percent';
                double priceWithDiscount = PriceConverter.convertWithDiscount(
                    price, _discount, _discountType);
                double priceWithQuantity =
                    priceWithDiscount * productController.quantity;
                double addonsCost = 0;
                List<AddOn> _addOnIdList = [];
                List<AddOns> _addOnsList = [];
                for (int index = 0;
                    index < widget.product.addOns.length;
                    index++) {
                  if (productController.addOnActiveList[index]) {
                    addonsCost = addonsCost +
                        (widget.product.addOns[index].price *
                            productController.addOnQtyList[index]);
                    _addOnIdList.add(AddOn(
                        id: widget.product.addOns[index].id,
                        quantity: productController.addOnQtyList[index]));
                    _addOnsList.add(widget.product.addOns[index]);
                  }
                }
                double priceWithAddons = priceWithQuantity + addonsCost;
                bool _isRestAvailable = DateConverter.isAvailable(
                    widget.product.restaurantOpeningTime,
                    widget.product.restaurantClosingTime);
                bool _isFoodAvailable = DateConverter.isAvailable(
                    widget.product.availableTimeStarts,
                    widget.product.availableTimeEnds);
                bool _isAvailable = _isRestAvailable && _isFoodAvailable;

                CartModel _cartModel = CartModel(
                  price,
                  priceWithDiscount,
                  _variation != null ? [_variation] : [],
                  (price -
                      PriceConverter.convertWithDiscount(
                          price, _discount, _discountType)),
                  productController.quantity,
                  _addOnIdList,
                  _addOnsList,
                  widget.isCampaign,
                  widget.product,
                );
                //bool isExistInCart = Get.find<CartController>().isExistInCart(_cartModel, fromCart, cartIndex);
                Product product = widget.product;
                bool _hasVars = (product.variations.length > 0);
                if (kDebugMode) {
                  print("HasVars: ${product.variations.length}");
                }
                bool _hasAddons = product.addOns.length > 0;
                final LinearGradient linearGradient = LinearGradient(
                  colors: <Color>[
                    Theme.of(context).primaryColor,
                    Theme.of(context).colorScheme.secondary
                  ],
                );
                return SingleChildScrollView(
                  child: SizedBox(
                    height: 100.h,
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Stack(
                            clipBehavior: Clip.none,
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.vertical(
                                    bottom: Radius.circular(33)),
                                child: CustomImage(
                                  image:
                                      '${widget.isCampaign ? Get.find<SplashController>().configModel.baseUrls.campaignImageUrl : widget.product.image}',
                                  height: ResponsiveHelper.isMobile(context)
                                      ? 40.h
                                      : 140,
                                  width: ResponsiveHelper.isMobile(context)
                                      ? 100.w
                                      : 200,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              Positioned(
                                bottom: -5.h,
                                left: 5.w,
                                child: Align(
                                  alignment: Alignment.bottomCenter,
                                  child: Container(
                                      decoration: BoxDecoration(
                                          boxShadow: [
                                            BoxShadow(
                                              color: Theme.of(context)
                                                  .primaryColor
                                                  .withOpacity(0.05),
                                              spreadRadius: 3,
                                              blurRadius: 5,
                                              offset: Offset(0,
                                                  3), // changes position of shadow
                                            ),
                                          ],
                                          color: Theme.of(context).cardColor,
                                          borderRadius:
                                              BorderRadius.circular(3.h)),
                                      width: 90.w,
                                      height: 10.h,
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            SizedBox(
                                              width: 65.w,
                                              child: Text(
                                                product.name,
                                                style: sfBold.copyWith(
                                                    fontSize: 5.w),
                                                maxLines: 2,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                            ShaderMask(
                                              shaderCallback: (Rect bounds) {
                                                return linearGradient
                                                    .createShader(Offset.zero &
                                                        bounds.size);
                                              },
                                              child: Text(
                                                "${product.price.toStringAsFixed(0)} ${"birr".tr}",
                                                style: sfBlack.copyWith(
                                                  color: Colors.white,
                                                  fontSize: 5.w,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      )),
                                ),
                              ),
                              ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                clipBehavior: Clip.antiAlias,
                                child: Container(
                                  height: 35.h,
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      begin: Alignment.topCenter,
                                      end: Alignment.bottomCenter,
                                      colors: [
                                        Colors.black.withOpacity(0.5),
                                        Colors.transparent,
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              Positioned(
                                top: 2.h,
                                left: 1.w,
                                child: IconButton(
                                  onPressed: () {
                                    Get.back();
                                  },
                                  icon: Icon(Icons.arrow_back_ios_rounded,
                                      color: Colors.white.withOpacity(0.8)),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 5.h),
                          // _hasVars
                          //     ? Padding(
                          //         padding: EdgeInsets.symmetric(horizontal: 5.w),
                          //         child: ListView.builder(
                          //           shrinkWrap: true,
                          //           itemCount:
                          //               widget.product.choiceOptions.length,
                          //           physics: NeverScrollableScrollPhysics(),
                          //           itemBuilder: (context, index) {
                          //             return Column(
                          //                 crossAxisAlignment:
                          //                     CrossAxisAlignment.start,
                          //                 children: [
                          //                   Text(
                          //                       widget.product
                          //                           .choiceOptions[index].title,
                          //                       style: sfBold.copyWith(
                          //                           fontSize: 7.w)),
                          //                   SizedBox(
                          //                       height: Dimensions
                          //                           .PADDING_SIZE_SMALL),
                          //                   SizedBox(
                          //                     height: 4.5.h,
                          //                     child: ListView.builder(
                          //                       shrinkWrap: true,
                          //                       scrollDirection: Axis.horizontal,
                          //                       itemCount: widget
                          //                           .product
                          //                           .choiceOptions[index]
                          //                           .options
                          //                           .length,
                          //                       itemBuilder: (context, i) {
                          //                         bool isSelected =
                          //                             productController
                          //                                         .variationIndex[
                          //                                     index] ==
                          //                                 i;
                          //                         return InkWell(
                          //                           onTap: () {
                          //                             productController
                          //                                 .setCartVariationIndex(
                          //                                     index, i);
                          //                           },
                          //                           child: Container(
                          //                             height: 10.h,
                          //                             margin: EdgeInsets.symmetric(
                          //                                 horizontal: Dimensions
                          //                                     .PADDING_SIZE_EXTRA_SMALL),
                          //                             // padding: EdgeInsets.only(
                          //                             //   left: index == 0
                          //                             //       ? Dimensions.PADDING_SIZE_LARGE
                          //                             //       : Dimensions.PADDING_SIZE_SMALL,
                          //                             //   right: index == restController.categoryList.length - 1
                          //                             //       ? Dimensions.PADDING_SIZE_LARGE
                          //                             //       : Dimensions.PADDING_SIZE_SMALL,
                          //                             //   top: Dimensions.PADDING_SIZE_SMALL,
                          //                             // ),
                          //                             padding:
                          //                                 EdgeInsets.symmetric(
                          //                               horizontal: Dimensions
                          //                                   .PADDING_SIZE_DEFAULT,
                          //                             ),
                          //                             decoration: BoxDecoration(
                          //                               border: isSelected
                          //                                   ? Border.all(
                          //                                       color: Theme.of(
                          //                                               context)
                          //                                           .primaryColor)
                          //                                   : Border.all(
                          //                                       color:
                          //                                           Colors.grey),
                          //                               borderRadius: BorderRadius
                          //                                   .circular(Dimensions
                          //                                       .PADDING_SIZE_EXTRA_SMALL),
                          //                             ),
                          //                             child: Center(
                          //                               child: Text(
                          //                                 product
                          //                                     .choiceOptions[
                          //                                         index]
                          //                                     .options[i]
                          //                                     .trim(),
                          //                                 style: isSelected
                          //                                     ? sfBold.copyWith(
                          //                                         fontSize: Dimensions
                          //                                             .fontSizeDefault,
                          //                                         color: Theme.of(
                          //                                                 context)
                          //                                             .primaryColor)
                          //                                     : sfBold.copyWith(
                          //                                         fontSize: Dimensions
                          //                                             .fontSizeDefault,
                          //                                         color: Theme.of(
                          //                                                 context)
                          //                                             .disabledColor),
                          //                               ),
                          //                             ),
                          //                           ),
                          //                         );
                          //                       },
                          //                     ),
                          //                   ),
                          //                   SizedBox(
                          //                       height: index !=
                          //                               widget
                          //                                       .product
                          //                                       .choiceOptions
                          //                                       .length -
                          //                                   1
                          //                           ? Dimensions
                          //                               .PADDING_SIZE_LARGE
                          //                           : 0),
                          //                 ]);
                          //           },
                          //         ),
                          //       )
                          //     : SizedBox(),
                          SizedBox(
                            height: 2.h,
                          ),
                          Padding(
                              padding: EdgeInsets.symmetric(horizontal: 5.w),
                              child: Text(
                                product.description ?? " ",
                                style: sfRegular,
                                maxLines: 3,
                              )),
                          Spacer(),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 5.w),
                            child: Row(children: [
                              Text('quantity'.tr,
                                  style: sfMedium.copyWith(
                                      fontSize:
                                          Dimensions.fontSizeExtraLarge * 1.4)),
                              Expanded(child: SizedBox()),
                              GetBuilder<CartController>(
                                  builder: (cartController) {
                                return Row(children: [
                                  QuantityButton(
                                    onTap: () =>
                                        cartController.removeFromCart(product),
                                    isIncrement: false,
                                  ),
                                  Text(
                                      cartController
                                          .getQuantity(product)
                                          .toString(),
                                      style: sfMedium.copyWith(
                                          fontSize:
                                              Dimensions.fontSizeExtraLarge)),
                                  QuantityButton(
                                    onTap: () {
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
                                    },
                                    isIncrement: true,
                                  ),
                                ]);
                              }),
                            ]),
                          ),
                          SizedBox(
                            height: 12.h,
                          )
                        ]),
                  ),
                );
              }),
              cartController.isCartOpen
                  ? Expanded(
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),
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
        bottomNavigationBar:
            GetBuilder<CartController>(builder: (cartController) {
          return Offstage(
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
          );
        }),
      );
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
                child: Center(
                  child: Text(
                    'buy_now'.tr,
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

  @override
  void dispose() {
    super.dispose();

    scrollController?.dispose();
    _controller.dispose();
  }
}
