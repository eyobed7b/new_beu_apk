import 'package:efood_multivendor/controller/category_controller.dart';
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
  bool isSub;
  CategoryController catController;
  RestaurantController restController;
  String categoryID;
  CategoryTabItem(
      {Key key,
      @required this.index,
      this.restController,
      this.catController,
      this.categoryID,
      this.isSub = false})
      : super(key: key);

  @override
  State<CategoryTabItem> createState() => _CategoryTabItemState();
}

class _CategoryTabItemState extends State<CategoryTabItem> {
  @override
  Widget build(BuildContext context) {
    final bool _ltr = Get.find<LocalizationController>().isLtr;

    int index = widget.index;
    bool isSelected;

    if (!widget.isSub) {
      isSelected = index == widget.restController.categoryIndex;
    } else {
      isSelected = index == widget.catController.subCategoryIndex;
    }

    return InkWell(
      onTap: () => !widget.isSub
          ? widget.restController.setCategoryIndex(index)
          : widget.catController.setSubCategoryIndex(index, widget.categoryID),
      child: ShaderMask(
        shaderCallback: isSelected
            ? (shade) {
                return LinearGradient(
                  colors: [Color(0xffff8022), Color(0xffff2222)],
                  tileMode: TileMode.mirror,
                ).createShader(shade);
              }
            : (shade) {
                return LinearGradient(
                  colors: [Colors.grey, Colors.grey],
                  tileMode: TileMode.mirror,
                ).createShader(shade);
              },
        child: Container(
          height: 0.5.h,
          margin: EdgeInsets.symmetric(
              horizontal: Dimensions.PADDING_SIZE_EXTRA_SMALL),
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
              !widget.isSub
                  ? widget.restController.categoryList[index].name
                  : widget.catController.subCategoryList[index].name,
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
      ),
    );
  }
}
