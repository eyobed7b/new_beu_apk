import 'package:efood_multivendor/controller/category_controller.dart';
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
import 'package:efood_multivendor/view/base/product_view.dart';
import 'package:efood_multivendor/view/base/web_menu_bar.dart';
import 'package:efood_multivendor/view/screens/restaurant/widget/category_list.dart';
import 'package:efood_multivendor/view/screens/restaurant/widget/restaurant_description_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:get/get.dart';

class RestaurantScreen extends StatefulWidget {
  final Restaurant restaurant;
  RestaurantScreen({@required this.restaurant});

  @override
  State<RestaurantScreen> createState() => _RestaurantScreenState();
}

class _RestaurantScreenState extends State<RestaurantScreen> {
  final ScrollController scrollController = ScrollController();

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
  }

  @override
  void dispose() {
    super.dispose();

    scrollController?.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ResponsiveHelper.isDesktop(context) ? WebMenuBar() : null,
      backgroundColor: Theme.of(context).cardColor,
      body: GetBuilder<RestaurantController>(builder: (restController) {
        return GetBuilder<CategoryController>(builder: (categoryController) {
          Restaurant _restaurant;
          if (restController.restaurant != null &&
              restController.restaurant.name != null &&
              categoryController.categoryList != null) {
            _restaurant = restController.restaurant;
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
                              padding:
                                  EdgeInsets.all(Dimensions.PADDING_SIZE_LARGE),
                              alignment: Alignment.center,
                              child: Center(
                                  child: SizedBox(
                                      width: Dimensions.WEB_MAX_WIDTH,
                                      child: Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal:
                                                Dimensions.PADDING_SIZE_SMALL),
                                        child: Row(children: [
                                          Expanded(
                                            child: ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(
                                                      Dimensions.RADIUS_SMALL),
                                              child: CustomImage(
                                                fit: BoxFit.cover,
                                                placeholder:
                                                    Images.restaurant_cover,
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
                                              child: RestaurantDescriptionView(
                                                  restaurant: _restaurant)),
                                        ]),
                                      ))),
                            ),
                          )
                        : SliverAppBar(
                            expandedHeight: 230,
                            toolbarHeight: 50,
                            pinned: true,
                            floating: false,
                            backgroundColor: Theme.of(context).primaryColor,
                            leading: IconButton(
                              icon: Container(
                                height: 50,
                                width: 50,
                                decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Theme.of(context).primaryColor),
                                alignment: Alignment.center,
                                child: Icon(Icons.chevron_left,
                                    color: Theme.of(context).cardColor),
                              ),
                              onPressed: () => Get.back(),
                            ),
                            flexibleSpace: FlexibleSpaceBar(
                              background: Stack(children: [
                                Container(
                                  decoration:
                                      BoxDecoration(color: Colors.white),
                                  child: ClipRRect(
                                      borderRadius: BorderRadius.vertical(
                                          bottom: Radius.circular(10)),
                                      clipBehavior: Clip.antiAlias,
                                      child: CustomImage(
                                        height: 35.h,
                                        fit: BoxFit.cover,
                                        placeholder: Images.restaurant_cover,
                                        image: '${_restaurant.coverPhoto}',
                                      )),
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
                                          Colors.transparent,
                                          Colors.black.withOpacity(0.5),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                Positioned(
                                  bottom: 5,
                                  child: Padding(
                                    padding:
                                        EdgeInsets.only(left: 5.w, bottom: 1.h),
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(2.h),
                                          clipBehavior: Clip.hardEdge,
                                          child: CustomImage(
                                              image: _restaurant.logo,
                                              height: 8.h,
                                              width: 8.h),
                                        ),
                                        SizedBox(width: 5),
                                        Padding(
                                          padding: EdgeInsets.only(top: 0.7.h),
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                _restaurant.name,
                                                style: sfBlack.copyWith(
                                                    color: Colors.white,
                                                    fontSize: 18),
                                              ),
                                              SizedBox(
                                                height: 0.6.h,
                                              ),
                                              Row(
                                                children: [
                                                  Icon(
                                                    FeatherIcons.mapPin,
                                                    color: Colors.white,
                                                    size: 2.h,
                                                  ),
                                                  SizedBox(
                                                    width: 10,
                                                  ),
                                                  Text(
                                                    _restaurant.address ??
                                                        "No address set",
                                                    style: sfRegular.copyWith(
                                                        color: Colors.white),
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
                            actions: [
                              IconButton(
                                onPressed: () =>
                                    Get.toNamed(RouteHelper.getCartRoute()),
                                icon: Container(
                                  height: 50,
                                  width: 50,
                                  decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Theme.of(context).primaryColor),
                                  alignment: Alignment.center,
                                  child: CartWidget(
                                      color: Theme.of(context).cardColor,
                                      size: 15,
                                      fromRestaurant: true),
                                ),
                              )
                            ],
                          ),
                    SliverToBoxAdapter(
                        child: Center(
                            child: Container(
                      width: Dimensions.WEB_MAX_WIDTH,
                      padding: EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
                      color: Theme.of(context).cardColor,
                      child: Column(children: [
                        ResponsiveHelper.isDesktop(context)
                            ? SizedBox()
                            // : SizedBox(),
                            : RestaurantDescriptionView(
                                restaurant: _restaurant),
                        _restaurant.discount != null
                            ? Container(
                                width: context.width,
                                margin: EdgeInsets.symmetric(
                                    vertical: Dimensions.PADDING_SIZE_SMALL),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(
                                        Dimensions.RADIUS_SMALL),
                                    color: Theme.of(context).primaryColor),
                                padding: EdgeInsets.all(
                                    Dimensions.PADDING_SIZE_SMALL),
                                child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        _restaurant.discount.discountType ==
                                                'percent'
                                            ? '${_restaurant.discount.discount}% OFF'
                                            : '${PriceConverter.convertPrice(_restaurant.discount.discount)} OFF',
                                        style: sfMedium.copyWith(
                                            fontSize: Dimensions.fontSizeLarge,
                                            color: Theme.of(context).cardColor),
                                      ),
                                      Text(
                                        _restaurant.discount.discountType ==
                                                'percent'
                                            ? '${'enjoy'.tr} ${_restaurant.discount.discount}% ${'off_on_all_categories'.tr}'
                                            : '${'enjoy'.tr} ${PriceConverter.convertPrice(_restaurant.discount.discount)}'
                                                ' ${'off_on_all_categories'.tr}',
                                        style: sfMedium.copyWith(
                                            fontSize: Dimensions.fontSizeSmall,
                                            color: Theme.of(context).cardColor),
                                      ),
                                      SizedBox(
                                          height: (_restaurant.discount
                                                          .minPurchase !=
                                                      0 ||
                                                  _restaurant.discount
                                                          .maxDiscount !=
                                                      0)
                                              ? 5
                                              : 0),
                                      _restaurant.discount.minPurchase != 0
                                          ? Text(
                                              '[ ${'minimum_purchase'.tr}: ${PriceConverter.convertPrice(_restaurant.discount.minPurchase)} ]',
                                              style: sfRegular.copyWith(
                                                  fontSize: Dimensions
                                                      .fontSizeExtraSmall,
                                                  color: Theme.of(context)
                                                      .cardColor),
                                            )
                                          : SizedBox(),
                                      _restaurant.discount.maxDiscount != 0
                                          ? Text(
                                              '[ ${'maximum_discount'.tr}: ${PriceConverter.convertPrice(_restaurant.discount.maxDiscount)} ]',
                                              style: sfRegular.copyWith(
                                                  fontSize: Dimensions
                                                      .fontSizeExtraSmall,
                                                  color: Theme.of(context)
                                                      .cardColor),
                                            )
                                          : SizedBox(),
                                      Text(
                                        '[ ${'daily_time'.tr}: ${DateConverter.convertTimeToTime(_restaurant.discount.startTime)} '
                                        '- ${DateConverter.convertTimeToTime(_restaurant.discount.endTime)} ]',
                                        style: sfRegular.copyWith(
                                            fontSize:
                                                Dimensions.fontSizeExtraSmall,
                                            color: Theme.of(context).cardColor),
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
                                  vertical:
                                      Dimensions.PADDING_SIZE_EXTRA_SMALL),
                              child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount: restController.categoryList.length,
                                padding: EdgeInsets.only(
                                    left: Dimensions.PADDING_SIZE_SMALL),
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
                          products: restController.categoryList.length > 0
                              ? restController.restaurantProducts
                              : null,
                          inRestaurantPage: true,
                          type: restController.type,
                          onVegFilterTap: (String type) {
                            restController.getRestaurantProductList(
                                restController.restaurant.id, 1, type, true);
                          },
                          padding: EdgeInsets.symmetric(
                            horizontal: Dimensions.PADDING_SIZE_SMALL,
                            vertical: ResponsiveHelper.isDesktop(context)
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
    );
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
