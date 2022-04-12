import 'package:efood_multivendor/controller/cart_controller.dart';
import 'package:efood_multivendor/data/model/response/cart_model.dart';
import 'package:efood_multivendor/helper/size_config.dart';
import 'package:efood_multivendor/util/styles.dart';
import 'package:efood_multivendor/view/base/quantity_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../helper/route_helper.dart';
import '../../../../util/dimensions.dart';
import '../../../../util/images.dart';
import '../../../base/confirmation_dialog.dart';
import '../../../base/custom_image.dart';
import '../../product/prdouct_screen.dart';

class CartListItem extends StatefulWidget {
  int index;

  CartListItem({Key key, @required this.index}) : super(key: key);

  @override
  State<CartListItem> createState() => _CartListItemState();
}

class _CartListItemState extends State<CartListItem> {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<CartController>(builder: (cartController) {
      CartModel me = cartController.cartList[widget.index];

      return Padding(
        padding: EdgeInsets.symmetric(vertical: 1.h),
        child: InkWell(
            onTap: () {
              Get.toNamed(RouteHelper.getProductRoute(me.product.id),
                  arguments: ProductScreen(
                    product: me.product,
                  ));
            },
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(Dimensions.RADIUS_SMALL),
                  child: CustomImage(
                    image: me.product.image,
                    height: 10.h,
                    width: 10.h,
                    fit: BoxFit.cover,
                  ),
                ),
                SizedBox(width: Dimensions.PADDING_SIZE_SMALL),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(
                      width: 30.w,
                      child: Text(
                        me.product.name,
                        style: sfRegular.copyWith(
                          fontSize: Dimensions.fontSizeLarge,
                        ),
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Text(
                      "${me.price.toString()} ${"birr".tr}",
                      style: sfBold.copyWith(
                          fontSize: Dimensions.fontSizeLarge * 1.1),
                    )
                  ],
                ),
                Spacer(),
                QuantityButton(
                  isIncrement: false,
                  onTap: () => cartController.removeFromCart(me.product),
                ),
                Text(cartController.getQuantity(me.product).toString(),
                    style: sfMedium.copyWith(
                        fontSize: Dimensions.fontSizeExtraLarge)),
                QuantityButton(
                    isIncrement: true,
                    onTap: () {
                      if (Get.find<CartController>()
                          .existAnotherRestaurantProduct(
                              me.product.restaurantId)) {
                        Get.dialog(
                            ConfirmationDialog(
                              icon: Images.warning,
                              title: 'are_you_sure_to_reset'.tr,
                              description: 'if_you_continue'.tr,
                              onYesPressed: () {
                                Get.back();
                                Get.find<CartController>()
                                    .removeAllAndAddToCart(me);
                              },
                            ),
                            barrierDismissible: false);
                      } else {
                        Get.find<CartController>().addToCart(me);
                      }
                    })
              ],
            )),
      );
    });
  }
}
