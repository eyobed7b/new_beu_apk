import 'package:efood_multivendor/data/model/response/product_model.dart';
import 'package:efood_multivendor/helper/responsive_helper.dart';
import 'package:efood_multivendor/helper/size_config.dart';
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

        return SingleChildScrollView(
          child: Column(children: [
            Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(Dimensions.RADIUS_SMALL),
                  child: CustomImage(
                    image:
                        '${widget.isCampaign ? Get.find<SplashController>().configModel.baseUrls.campaignImageUrl : widget.product.image}',
                    width: ResponsiveHelper.isMobile(context) ? 100 : 140,
                    height: ResponsiveHelper.isMobile(context) ? 40.h : 140,
                    fit: BoxFit.cover,
                  ),
                ),
              ],
            )
          ]),
        );
      }),
    );
  }
}
