import 'package:efood_multivendor/data/model/response/product_model.dart';
import 'package:efood_multivendor/helper/responsive_helper.dart';
import 'package:efood_multivendor/helper/size_config.dart';
import 'package:efood_multivendor/util/styles.dart';
import 'package:efood_multivendor/view/base/quantity_button.dart';
import 'package:efood_multivendor/view/base/web_menu_bar.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../controller/product_controller.dart';
import '../../../controller/splash_controller.dart';
import '../../../data/model/response/cart_model.dart';
import '../../../helper/date_converter.dart';
import '../../../helper/price_converter.dart';
import '../../../util/dimensions.dart';
import '../../base/custom_image.dart';

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

class _ProductScreenState extends State<ProductScreen> {
  @override
  void initState() {
    super.initState();

    Get.find<ProductController>().initData(widget.product, widget.cart);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ResponsiveHelper.isDesktop(context) ? WebMenuBar() : null,
      backgroundColor: Theme.of(context).cardColor,
      body: GetBuilder<ProductController>(builder: (productController) {
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

        double _discount =
            (widget.isCampaign || widget.product.restaurantDiscount == 0)
                ? widget.product.discount
                : widget.product.restaurantDiscount;
        String _discountType =
            (widget.isCampaign || widget.product.restaurantDiscount == 0)
                ? widget.product.discountType
                : 'percent';
        double priceWithDiscount =
            PriceConverter.convertWithDiscount(price, _discount, _discountType);
        double priceWithQuantity =
            priceWithDiscount * productController.quantity;
        double addonsCost = 0;
        List<AddOn> _addOnIdList = [];
        List<AddOns> _addOnsList = [];
        for (int index = 0; index < widget.product.addOns.length; index++) {
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
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Stack(
                clipBehavior: Clip.none,
                children: [
                  ClipRRect(
                    borderRadius:
                        BorderRadius.vertical(bottom: Radius.circular(33)),
                    child: CustomImage(
                      image:
                          '${widget.isCampaign ? Get.find<SplashController>().configModel.baseUrls.campaignImageUrl : widget.product.image}',
                      height: ResponsiveHelper.isMobile(context) ? 40.h : 140,
                      width: ResponsiveHelper.isMobile(context) ? 100.w : 200,
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
                                  offset: Offset(
                                      0, 3), // changes position of shadow
                                ),
                              ],
                              color: Theme.of(context).cardColor,
                              borderRadius: BorderRadius.circular(3.h)),
                          width: 90.w,
                          height: 10.h,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                SizedBox(
                                  width: 65.w,
                                  child: Text(
                                    product.name,
                                    style: sfBold.copyWith(fontSize: 5.w),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                ShaderMask(
                                  shaderCallback: (Rect bounds) {
                                    return linearGradient.createShader(
                                        Offset.zero & bounds.size);
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
                  )
                ],
              ),
              SizedBox(height: 5.h),
              _hasVars
                  ? Padding(
                      padding: EdgeInsets.symmetric(horizontal: 5.w),
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: widget.product.choiceOptions.length,
                        physics: NeverScrollableScrollPhysics(),
                        itemBuilder: (context, index) {
                          return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(widget.product.choiceOptions[index].title,
                                    style: sfBold.copyWith(fontSize: 7.w)),
                                SizedBox(height: Dimensions.PADDING_SIZE_SMALL),
                                SizedBox(
                                  height: 4.5.h,
                                  child: ListView.builder(
                                    shrinkWrap: true,
                                    scrollDirection: Axis.horizontal,
                                    itemCount: widget.product
                                        .choiceOptions[index].options.length,
                                    itemBuilder: (context, i) {
                                      bool isSelected = productController
                                              .variationIndex[index] ==
                                          i;
                                      return InkWell(
                                        onTap: () {
                                          productController
                                              .setCartVariationIndex(index, i);
                                        },
                                        child: Container(
                                          height: 10.h,
                                          margin: EdgeInsets.symmetric(
                                              horizontal: Dimensions
                                                  .PADDING_SIZE_EXTRA_SMALL),
                                          // padding: EdgeInsets.only(
                                          //   left: index == 0
                                          //       ? Dimensions.PADDING_SIZE_LARGE
                                          //       : Dimensions.PADDING_SIZE_SMALL,
                                          //   right: index == restController.categoryList.length - 1
                                          //       ? Dimensions.PADDING_SIZE_LARGE
                                          //       : Dimensions.PADDING_SIZE_SMALL,
                                          //   top: Dimensions.PADDING_SIZE_SMALL,
                                          // ),
                                          padding: EdgeInsets.symmetric(
                                            horizontal:
                                                Dimensions.PADDING_SIZE_DEFAULT,
                                          ),
                                          decoration: BoxDecoration(
                                            border: isSelected
                                                ? Border.all(
                                                    color: Theme.of(context)
                                                        .primaryColor)
                                                : Border.all(
                                                    color: Colors.grey),
                                            borderRadius: BorderRadius.circular(
                                                Dimensions
                                                    .PADDING_SIZE_EXTRA_SMALL),
                                          ),
                                          child: Center(
                                            child: Text(
                                              product.choiceOptions[index]
                                                  .options[i]
                                                  .trim(),
                                              style: isSelected
                                                  ? sfBold.copyWith(
                                                      fontSize: Dimensions
                                                          .fontSizeDefault,
                                                      color: Theme.of(context)
                                                          .primaryColor)
                                                  : sfBold.copyWith(
                                                      fontSize: Dimensions
                                                          .fontSizeDefault,
                                                      color: Theme.of(context)
                                                          .disabledColor),
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                                SizedBox(
                                    height: index !=
                                            widget.product.choiceOptions
                                                    .length -
                                                1
                                        ? Dimensions.PADDING_SIZE_LARGE
                                        : 0),
                              ]);
                        },
                      ),
                    )
                  : SizedBox(),
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
                          fontSize: Dimensions.fontSizeExtraLarge * 1.4)),
                  Expanded(child: SizedBox()),
                  Row(children: [
                    QuantityButton(
                      onTap: () {
                        if (productController.quantity > 1) {
                          productController.setQuantity(false);
                        }
                      },
                      isIncrement: false,
                    ),
                    Text(productController.quantity.toString(),
                        style: sfMedium.copyWith(
                            fontSize: Dimensions.fontSizeExtraLarge)),
                    QuantityButton(
                      onTap: () => productController.setQuantity(true),
                      isIncrement: true,
                    ),
                  ]),
                ]),
              ),
              SizedBox(
                height: 12.h,
              )
            ]),
          ),
        );
      }),
    );
  }
}
