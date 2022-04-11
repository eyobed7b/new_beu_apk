import 'package:efood_multivendor/controller/search_controller.dart';
import 'package:efood_multivendor/controller/splash_controller.dart';
import 'package:efood_multivendor/helper/responsive_helper.dart';
import 'package:efood_multivendor/helper/size_config.dart';
import 'package:efood_multivendor/util/dimensions.dart';
import 'package:efood_multivendor/util/images.dart';
import 'package:efood_multivendor/util/styles.dart';
import 'package:efood_multivendor/view/base/custom_button.dart';
import 'package:efood_multivendor/view/screens/search/widget/custom_check_box.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:range_slider_flutter/range_slider_flutter.dart';

class FilterWidget extends StatelessWidget {
  final double maxValue;
  final bool isRestaurant;
  FilterWidget({@required this.maxValue, @required this.isRestaurant});

  @override
  Widget build(BuildContext context) {
    final LinearGradient linearGradient = LinearGradient(
      colors: <Color>[
        Theme.of(context).primaryColor,
        Theme.of(context).colorScheme.secondary
      ],
    );

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.vertical(top: Radius.circular(8.0)),
        color: Theme.of(context).cardColor,
      ),

      padding: EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
      child: GetBuilder<SearchController>(builder: (searchController) {
        double _lowerValue = 50;
        double _upperValue = 400;
        var _lowerValueDist = 0.1;
        var _upperValueDist = 5.5;
        return SingleChildScrollView(
          child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      InkWell(
                        onTap: () => Navigator.of(context).pop(),
                        child: Padding(
                          padding: EdgeInsets.all(
                              Dimensions.PADDING_SIZE_EXTRA_SMALL),
                          child: Icon(Icons.close,
                              color: Theme.of(context).disabledColor),
                        ),
                      ),
                      Text('sort_and_filter'.tr,
                          style: sfMedium.copyWith(
                              fontSize: Dimensions.fontSizeLarge * 1.2)),
                      CustomButton(
                        onPressed: () {
                          searchController.resetFilter();
                        },
                        buttonText: 'clear_all'.tr,
                        transparent: true,
                        width: 65,
                      ),
                    ]),
                SizedBox(height: Dimensions.PADDING_SIZE_LARGE),
                Text(
                  "price_range".tr,
                  style: sfMedium.copyWith(
                      fontSize: Dimensions.fontSizeLarge * 1.3),
                ),
                SizedBox(
                  height: 4.h,
                ),
                RangeSliderFlutter(
                  // key: Key('3343'),

                  values: [_lowerValue, _upperValue],
                  rangeSlider: true,

                  tooltip: RangeSliderFlutterTooltip(
                    boxStyle: RangeSliderFlutterTooltipBox(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(17),
                            gradient: linearGradient)),
                    alwaysShowTooltip: true,
                    leftSuffix: Text(' Br',
                        style: TextStyle(
                          fontSize: 15,
                          color: Colors.white,
                        )),
                    rightSuffix: Text(' Br',
                        style: TextStyle(
                          fontSize: 15,
                          color: Colors.white,
                        )),
                  ),

                  max: 1000,
                  textPositionTop: -70,
                  handlerHeight: 25,

                  trackBar: RangeSliderFlutterTrackBar(
                    activeTrackBarHeight: 10,
                    inactiveTrackBarHeight: 10,
                    activeTrackBar: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      gradient: linearGradient,
                    ),
                    inactiveTrackBar: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Theme.of(context).primaryColor.withOpacity(0.3),
                    ),
                  ),

                  min: 0,
                  fontSize: 15,
                  textColor: Colors.white,
                  textBackgroundColor: Colors.red,
                  // onDragging:
                  //     (handlerIndex, lowerValue, upperValue) {
                  //   _lowerValue = lowerValue;
                  //   _upperValue = upperValue;
                  //   context
                  //       .read<FilterProvider>()
                  //       .setCurrentRangeValues(
                  //           lowerValue, upperValue);

                  // },
                ),
                Text(
                  "distance_range".tr,
                  style: sfMedium.copyWith(
                      fontSize: Dimensions.fontSizeLarge * 1.3),
                ),
                SizedBox(
                  height: 4.h,
                ),
                RangeSliderFlutter(
                  // key: Key('3343'),

                  values: [_lowerValueDist, _upperValueDist],
                  rangeSlider: true,
                  tooltip: RangeSliderFlutterTooltip(
                    boxStyle: RangeSliderFlutterTooltipBox(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(17),
                            gradient: linearGradient)),
                    alwaysShowTooltip: true,
                    leftSuffix: Text(' Km',
                        style: TextStyle(
                          fontSize: 15,
                          color: Colors.white,
                        )),
                    rightSuffix: Text(' Km',
                        style: TextStyle(
                          fontSize: 15,
                          color: Colors.white,
                        )),
                  ),

                  max: 11,
                  textPositionTop: -70,
                  handlerHeight: 25,

                  trackBar: RangeSliderFlutterTrackBar(
                    activeTrackBarHeight: 10,
                    inactiveTrackBarHeight: 10,
                    activeTrackBar: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      gradient: linearGradient,
                    ),
                    inactiveTrackBar: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Theme.of(context).primaryColor.withOpacity(0.3),
                    ),
                  ),

                  min: 0,

                  fontSize: 15,
                  textColor: Colors.white,
                  textBackgroundColor: Colors.red,
                  // onDragging:
                  //     (handlerIndex, lowerValue, upperValue) {
                  //   _lowerValue = lowerValue;
                  //   _upperValue = upperValue;
                  //   context
                  //       .read<FilterProvider>()
                  //       .setCurrentRangeValues(
                  //           lowerValue, upperValue);

                  // },
                ),
                Text('sort'.tr,
                    style: sfMedium.copyWith(
                        fontSize: Dimensions.fontSizeLarge * 1.3)),
                SizedBox(height: Dimensions.PADDING_SIZE_SMALL),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 5.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "cost_high_to_low".tr,
                            style: sfMedium.copyWith(
                                fontSize: Dimensions.fontSizeDefault * 1.2),
                          ),
                          GestureDetector(
                            onTap: () {
                              searchController.setSelectedIndex(0);
                            },
                            child: Image.asset(
                                searchController.selectedIndex == 0
                                    ? Images.checkboxTicked
                                    : Images.checkboxOutlined),
                          )
                        ],
                      ),
                      SizedBox(
                        height: 3.h,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "cost_low_to_high".tr,
                            style: sfMedium.copyWith(
                                fontSize: Dimensions.fontSizeDefault * 1.2),
                          ),
                          GestureDetector(
                              onTap: () {
                                searchController.setSelectedIndex(1);
                              },
                              child: Image.asset(
                                  searchController.selectedIndex == 1
                                      ? Images.checkboxTicked
                                      : Images.checkboxOutlined))
                        ],
                      ),
                      SizedBox(
                        height: 3.h,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "rating".tr,
                            style: sfMedium.copyWith(
                                fontSize: Dimensions.fontSizeDefault * 1.2),
                          ),
                          GestureDetector(
                              onTap: () {
                                searchController.setSelectedIndex(2);
                              },
                              child: Image.asset(
                                  searchController.selectedIndex == 2
                                      ? Images.checkboxTicked
                                      : Images.checkboxOutlined))
                        ],
                      ),
                      SizedBox(
                        height: 4.h,
                      ),
                      Text(
                        "from_beu".tr,
                        style: sfMedium.copyWith(
                            fontSize: Dimensions.fontSizeDefault * 1.3),
                      ),
                      SizedBox(
                        height: 0.7.h,
                      ),
                      ListView.builder(
                          shrinkWrap: true,
                          itemCount: searchController.filters.length,
                          itemBuilder: ((context, index) {
                            return Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  searchController.filters[index],
                                  style: sfMedium.copyWith(
                                      fontSize:
                                          Dimensions.fontSizeDefault * 1.1),
                                ),
                                CupertinoSwitch(
                                  value: searchController.activeFilters[index],
                                  onChanged: (value) =>
                                      searchController.setFilter(index, value),
                                )
                              ],
                            );
                          }))
                    ],
                  ),
                ),

                // GridView.builder(
                //   itemCount: searchController.sortList.length,
                //   physics: NeverScrollableScrollPhysics(),
                //   shrinkWrap: true,
                //   gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                //     crossAxisCount: ResponsiveHelper.isDesktop(context)
                //         ? 4
                //         : ResponsiveHelper.isTab(context)
                //             ? 3
                //             : 2,
                //     childAspectRatio: 3,
                //     crossAxisSpacing: 10,
                //     mainAxisSpacing: 10,
                //   ),
                //   itemBuilder: (context, index) {
                //     bool isSelected = searchController.sortIndex == index;
                //     return InkWell(
                //       onTap: () {
                //         searchController.setSortIndex(index);
                //       },
                //       child: Container(
                //         alignment: Alignment.center,
                //         decoration: BoxDecoration(
                //           border: Border.all(
                //               color: isSelected
                //                   ? Colors.transparent
                //                   : Theme.of(context).disabledColor),
                //           borderRadius:
                //               BorderRadius.circular(Dimensions.RADIUS_SMALL),
                //           color: searchController.sortIndex == index
                //               ? Theme.of(context).primaryColor
                //               : Theme.of(context)
                //                   .disabledColor
                //                   .withOpacity(0.1),
                //         ),
                //         child: Text(
                //           searchController.sortList[index],
                //           textAlign: TextAlign.center,
                //           style: sfMedium.copyWith(
                //             color: searchController.sortIndex == index
                //                 ? Colors.white
                //                 : Theme.of(context).hintColor,
                //           ),
                //           maxLines: 1,
                //           overflow: TextOverflow.ellipsis,
                //         ),
                //       ),
                //     );
                //   },
                // ),
                // ,
                // SizedBox(height: Dimensions.PADDING_SIZE_LARGE),
                // Text('filter_by'.tr,
                //     style:
                //         sfMedium.copyWith(fontSize: Dimensions.fontSizeLarge)),
                // SizedBox(height: Dimensions.PADDING_SIZE_SMALL),
                // Get.find<SplashController>().configModel.toggleVegNonVeg
                //     ? CustomCheckBox(
                //         title: 'veg'.tr,
                //         value: searchController.veg,
                //         onClick: () => searchController.toggleVeg(),
                //       )
                //     : SizedBox(),
                // Get.find<SplashController>().configModel.toggleVegNonVeg
                //     ? CustomCheckBox(
                //         title: 'non_veg'.tr,
                //         value: searchController.nonVeg,
                //         onClick: () => searchController.toggleNonVeg(),
                //       )
                //     : SizedBox(),
                // CustomCheckBox(
                //   title: isRestaurant
                //       ? 'currently_opened_restaurants'.tr
                //       : 'currently_available_foods'.tr,
                //   value: searchController.isAvailableFoods,
                //   onClick: () {
                //     searchController.toggleAvailableFoods();
                //   },
                // ),
                // CustomCheckBox(
                //   title: isRestaurant
                //       ? 'discounted_restaurants'.tr
                //       : 'discounted_foods'.tr,
                //   value: searchController.isDiscountedFoods,
                //   onClick: () {
                //     searchController.toggleDiscountedFoods();
                //   },
                // ),
                // SizedBox(height: Dimensions.PADDING_SIZE_LARGE),
                // isRestaurant
                //     ? SizedBox()
                //     : Column(children: [
                //         Text('price'.tr,
                //             style: sfMedium.copyWith(
                //                 fontSize: Dimensions.fontSizeLarge)),
                //         RangeSlider(
                //           values: RangeValues(searchController.lowerValue,
                //               searchController.upperValue),
                //           max: maxValue.toInt().toDouble(),
                //           min: 0,
                //           divisions: maxValue.toInt(),
                //           activeColor: Theme.of(context).primaryColor,
                //           inactiveColor:
                //               Theme.of(context).primaryColor.withOpacity(0.3),
                //           labels: RangeLabels(
                //               searchController.lowerValue.toString(),
                //               searchController.upperValue.toString()),
                //           onChanged: (RangeValues rangeValues) {
                //             searchController.setLowerAndUpperValue(
                //                 rangeValues.start, rangeValues.end);
                //           },
                //         ),
                //         SizedBox(height: Dimensions.PADDING_SIZE_LARGE),
                //       ]),
                // Text('rating'.tr,
                //     style:
                //         sfMedium.copyWith(fontSize: Dimensions.fontSizeLarge)),
                // Container(
                //   height: 30,
                //   alignment: Alignment.center,
                //   child: ListView.builder(
                //     itemCount: 5,
                //     shrinkWrap: true,
                //     scrollDirection: Axis.horizontal,
                //     itemBuilder: (context, index) {
                //       return InkWell(
                //         onTap: () => searchController.setRating(index + 1),
                //         child: Icon(
                //           searchController.rating < (index + 1)
                //               ? Icons.star_border
                //               : Icons.star,
                //           size: 30,
                //           color: searchController.rating < (index + 1)
                //               ? Theme.of(context).disabledColor
                //               : Theme.of(context).primaryColor,
                //         ),
                //       );
                //     },
                //   ),
                // ),

                SizedBox(height: 30),
                CustomButton(
                  buttonText: 'apply'.tr,
                  radius: 15,
                  onPressed: () {
                    // if (isRestaurant) {
                    //   searchController.sortRestSearchList();
                    // } else {
                    //   searchController.sortFoodSearchList();
                    // }
                    Get.back();
                  },
                ),
              ]),
        );
      }),
      // ),
    );
  }
}
