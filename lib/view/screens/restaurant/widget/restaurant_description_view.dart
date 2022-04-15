import 'package:efood_multivendor/controller/auth_controller.dart';
import 'package:efood_multivendor/controller/splash_controller.dart';
import 'package:efood_multivendor/controller/wishlist_controller.dart';
import 'package:efood_multivendor/data/model/response/address_model.dart';
import 'package:efood_multivendor/data/model/response/restaurant_model.dart';
import 'package:efood_multivendor/helper/date_converter.dart';
import 'package:efood_multivendor/helper/price_converter.dart';
import 'package:efood_multivendor/helper/responsive_helper.dart';
import 'package:efood_multivendor/helper/route_helper.dart';
import 'package:efood_multivendor/helper/size_config.dart';
import 'package:efood_multivendor/util/dimensions.dart';
import 'package:efood_multivendor/util/styles.dart';
import 'package:efood_multivendor/view/base/custom_image.dart';
import 'package:efood_multivendor/view/base/custom_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';

import 'package:intl/intl.dart';

import '../../../../util/functions.dart';

class RestaurantDescriptionView extends StatelessWidget {
  final Restaurant restaurant;
  RestaurantDescriptionView({@required this.restaurant});

  @override
  Widget build(BuildContext context) {
    Color _textColor =
        ResponsiveHelper.isDesktop(context) ? Colors.white : null;
    // String openingtime =
    //     DateFormat("hh:mm a").format(Time(restaurant.openingTime));
    // String closingtime =
    //     DateFormat("hh:mm a").format(Time.parse(restaurant.closeingTime));
    return Column(children: [
      SizedBox(
          height: ResponsiveHelper.isDesktop(context)
              ? 30
              : Dimensions.PADDING_SIZE_SMALL),
      Row(children: [
        Expanded(child: SizedBox()),
        InkWell(
          onTap: () =>
              Get.toNamed(RouteHelper.getRestaurantReviewRoute(restaurant.id)),
          child: Column(children: [
            Text(
              'rating'.tr,
              style: sfRegular.copyWith(
                  fontSize: Dimensions.fontSizeSmall, color: _textColor),
            ),
            SizedBox(width: Dimensions.PADDING_SIZE_EXTRA_SMALL),
            Row(children: [
              ShaderMask(
                  shaderCallback: (shade) {
                    return LinearGradient(
                      colors: [Color(0xffff8022), Color(0xffff2222)],
                      tileMode: TileMode.mirror,
                    ).createShader(shade);
                  },
                  child: Icon(FeatherIcons.star,
                      color: Theme.of(context).primaryColor, size: 20)),
              SizedBox(width: Dimensions.PADDING_SIZE_EXTRA_SMALL),
              Text(
                restaurant.avgRating.toStringAsFixed(1),
                style: sfMedium.copyWith(
                    fontSize: Dimensions.fontSizeSmall, color: _textColor),
              ),
            ]),
          ]),
        ),
        Container(
          color: Colors.black,
          width: 2.w,
        ),
        Expanded(child: SizedBox()),
        Column(children: [
          Text(
            'working_hours'.tr,
            style: sfRegular.copyWith(
                fontSize: Dimensions.fontSizeSmall, color: _textColor),
          ),
          SizedBox(width: Dimensions.PADDING_SIZE_EXTRA_SMALL),
          Row(children: [
            ShaderMask(
              shaderCallback: (shade) {
                return LinearGradient(
                  colors: [Color(0xffff8022), Color(0xffff2222)],
                  tileMode: TileMode.mirror,
                ).createShader(shade);
              },
              child: Icon(FeatherIcons.clock,
                  color: Theme.of(context).primaryColor, size: 20),
            ),
            SizedBox(width: Dimensions.PADDING_SIZE_EXTRA_SMALL),
            Text(
              "${restaurant.openingTime.toString()} - ${restaurant.closeingTime.toString()}",
              style: sfMedium.copyWith(
                  fontSize: Dimensions.fontSizeSmall, color: _textColor),
            ),
          ])
        ]),
        Container(
          color: Colors.black,
          width: 2.w,
        ),
        Expanded(child: SizedBox()),
        Column(children: [
          Text('delivery_time'.tr,
              style: sfRegular.copyWith(
                  fontSize: Dimensions.fontSizeSmall, color: Colors.grey)),
          SizedBox(width: Dimensions.PADDING_SIZE_EXTRA_SMALL),
          Row(children: [
            ShaderMask(
                shaderCallback: (shade) {
                  return LinearGradient(
                    colors: [Color(0xffff8022), Color(0xffff2222)],
                    tileMode: TileMode.mirror,
                  ).createShader(shade);
                },
                child: Icon(Icons.pedal_bike_outlined,
                    color: Theme.of(context).primaryColor, size: 20)),
            SizedBox(width: Dimensions.PADDING_SIZE_EXTRA_SMALL),
            Text(
              '${restaurant.deliveryTime} ${'min'.tr}',
              style: sfMedium.copyWith(
                  fontSize: Dimensions.fontSizeSmall, color: Colors.black),
            ),
          ]),
        ]),
        (restaurant.delivery && restaurant.freeDelivery)
            ? Expanded(child: SizedBox())
            : SizedBox(),
        (restaurant.delivery && restaurant.freeDelivery)
            ? Column(children: [
                Icon(Icons.money_off,
                    color: Theme.of(context).primaryColor, size: 20),
                SizedBox(width: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                Text('free_delivery'.tr,
                    style: sfRegular.copyWith(
                        fontSize: Dimensions.fontSizeSmall, color: _textColor)),
              ])
            : SizedBox(),
        Expanded(child: SizedBox()),
      ]),
    ]);
  }
}
