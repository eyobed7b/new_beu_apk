import 'package:efood_multivendor/controller/restaurant_controller.dart';
import 'package:efood_multivendor/data/model/response/restaurant_model.dart';
import 'package:efood_multivendor/helper/size_config.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../controller/localization_controller.dart';
import '../../../../util/dimensions.dart';
import '../../../../util/styles.dart';

class CategoryTabItem extends StatefulWidget {
  int index;
  RestaurantController restController;
  CategoryTabItem(
      {Key key, @required this.index, @required this.restController})
      : super(key: key);

  @override
  State<CategoryTabItem> createState() => _CategoryTabItemState();
}

class _CategoryTabItemState extends State<CategoryTabItem> {
  @override
  Widget build(BuildContext context) {
    final bool _ltr = Get.find<LocalizationController>().isLtr;

    int index = widget.index;
    RestaurantController restController = widget.restController;
    bool isSelected = index == restController.categoryIndex;

    return InkWell(
      onTap: () => restController.setCategoryIndex(index),
      child: Container(
        height: 0.5.h,
        margin: EdgeInsets.symmetric(
            horizontal: Dimensions.PADDING_SIZE_EXTRA_SMALL),
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
          horizontal: Dimensions.PADDING_SIZE_DEFAULT,
        ),
        decoration: BoxDecoration(
          border: isSelected
              ? Border.all(color: Theme.of(context).primaryColor)
              : Border.all(color: Colors.grey),
          borderRadius:
              BorderRadius.circular(Dimensions.PADDING_SIZE_EXTRA_SMALL),
        ),
        child: Center(
          child: Text(
            restController.categoryList[index].name,
            style: isSelected
                ? sfMedium.copyWith(
                    fontSize: Dimensions.fontSizeSmall,
                    color: Theme.of(context).primaryColor)
                : sfRegular.copyWith(
                    fontSize: Dimensions.fontSizeSmall,
                    color: Theme.of(context).disabledColor),
          ),
        ),
      ),
    );
  }
}
