import 'package:efood_multivendor/controller/category_controller.dart';
import 'package:efood_multivendor/controller/localization_controller.dart';
import 'package:efood_multivendor/data/model/response/product_model.dart';
import 'package:efood_multivendor/data/model/response/restaurant_model.dart';
import 'package:efood_multivendor/helper/responsive_helper.dart';
import 'package:efood_multivendor/helper/route_helper.dart';
import 'package:efood_multivendor/util/dimensions.dart';
import 'package:efood_multivendor/util/styles.dart';
import 'package:efood_multivendor/view/base/cart_widget.dart';
import 'package:efood_multivendor/view/base/product_view.dart';
import 'package:efood_multivendor/view/base/veg_filter_widget.dart';
import 'package:efood_multivendor/view/base/web_menu_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CategoryProductScreen extends StatefulWidget {
  final String categoryID;
  final String categoryName;
  CategoryProductScreen(
      {@required this.categoryID, @required this.categoryName});

  @override
  _CategoryProductScreenState createState() => _CategoryProductScreenState();
}

class _CategoryProductScreenState extends State<CategoryProductScreen>
    with TickerProviderStateMixin {
  final ScrollController scrollController = ScrollController();
  final ScrollController restaurantScrollController = ScrollController();
  final bool _ltr = Get.find<LocalizationController>().isLtr;
  TabController _tabController;

  @override
  void initState() {
    super.initState();

    _tabController = TabController(length: 2, initialIndex: 0, vsync: this);
    Get.find<CategoryController>().getSubCategoryList(widget.categoryID);
    scrollController?.addListener(() {
      if (scrollController.position.pixels ==
              scrollController.position.maxScrollExtent &&
          Get.find<CategoryController>().categoryProductList != null &&
          !Get.find<CategoryController>().isLoading) {
        int pageSize = (Get.find<CategoryController>().pageSize / 10).ceil();
        print('---------$pageSize/${Get.find<CategoryController>().offset}');
        if (Get.find<CategoryController>().offset < pageSize) {
          print('end of the page');
          Get.find<CategoryController>().showBottomLoader();
          Get.find<CategoryController>().getCategoryProductList(
            Get.find<CategoryController>().subCategoryIndex == 0
                ? widget.categoryID
                : Get.find<CategoryController>()
                    .subCategoryList[
                        Get.find<CategoryController>().subCategoryIndex]
                    .id,
            Get.find<CategoryController>().offset + 1,
            Get.find<CategoryController>().type,
            false,
          );
        }
      }
    });
    restaurantScrollController?.addListener(() {
      if (scrollController.position.pixels ==
              scrollController.position.maxScrollExtent &&
          Get.find<CategoryController>().categoryRestList != null &&
          !Get.find<CategoryController>().isLoading) {
        int pageSize =
            (Get.find<CategoryController>().restPageSize / 10).ceil();
        if (Get.find<CategoryController>().offset < pageSize) {
          print('end of the page');
          Get.find<CategoryController>().showBottomLoader();
          Get.find<CategoryController>().getCategoryRestaurantList(
            Get.find<CategoryController>().subCategoryIndex == 0
                ? widget.categoryID
                : Get.find<CategoryController>()
                    .subCategoryList[
                        Get.find<CategoryController>().subCategoryIndex]
                    .id,
            Get.find<CategoryController>().offset + 1,
            Get.find<CategoryController>().type,
            false,
          );
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CategoryController>(builder: (catController) {
      List<Product> _products;
      List<Restaurant> _restaurants;
      if (catController.categoryProductList != null &&
          catController.searchProductList != null) {
        _products = [];
        if (catController.isSearching) {
          _products.addAll(catController.searchProductList);
        } else {
          _products.addAll(catController.categoryProductList);
        }
      }
      if (catController.categoryRestList != null &&
          catController.searchRestList != null) {
        _restaurants = [];
        if (catController.isSearching) {
          _restaurants.addAll(catController.searchRestList);
        } else {
          _restaurants.addAll(catController.categoryRestList);
        }
      }

      return WillPopScope(
        onWillPop: () async {
          if (catController.isSearching) {
            catController.toggleSearch();
            return false;
          } else {
            return true;
          }
        },
        child: Scaffold(
          appBar: ResponsiveHelper.isDesktop(context)
              ? WebMenuBar()
              : AppBar(
                  title: catController.isSearching
                      ? TextField(
                          autofocus: true,
                          textInputAction: TextInputAction.search,
                          decoration: InputDecoration(
                            hintText: 'Search...',
                            border: InputBorder.none,
                          ),
                          style: sfRegular.copyWith(
                              fontSize: Dimensions.fontSizeLarge),
                          onSubmitted: (String query) =>
                              catController.searchData(
                            query,
                            catController.subCategoryIndex == 0
                                ? widget.categoryID
                                : catController
                                    .subCategoryList[
                                        catController.subCategoryIndex]
                                    .id,
                            catController.type,
                          ),
                        )
                      : Text(widget.categoryName,
                          style: sfRegular.copyWith(
                            fontSize: Dimensions.fontSizeLarge,
                            color: Theme.of(context).textTheme.bodyText1.color,
                          )),
                  centerTitle: true,
                  leading: IconButton(
                    icon: Icon(Icons.arrow_back_ios),
                    color: Theme.of(context).textTheme.bodyText1.color,
                    onPressed: () {
                      if (catController.isSearching) {
                        catController.toggleSearch();
                      } else {
                        Get.back();
                      }
                    },
                  ),
                  backgroundColor: Theme.of(context).cardColor,
                  elevation: 0,
                  actions: [
                    IconButton(
                      onPressed: () => catController.toggleSearch(),
                      icon: Icon(
                        catController.isSearching
                            ? Icons.close_sharp
                            : Icons.search,
                        color: Theme.of(context).textTheme.bodyText1.color,
                      ),
                    ),
                    IconButton(
                      onPressed: () => Get.toNamed(RouteHelper.getCartRoute()),
                      icon: CartWidget(
                          color: Theme.of(context).textTheme.bodyText1.color,
                          size: 25),
                    ),
                  ],
                ),
          body: Center(
              child: SizedBox(
            width: Dimensions.WEB_MAX_WIDTH,
            child: Column(children: [
              Center(
                  child: Container(
                width: Dimensions.WEB_MAX_WIDTH,
                color: Theme.of(context).cardColor,
                child: TabBar(
                  controller: _tabController,
                  indicatorColor: Theme.of(context).colorScheme.secondary,
                  indicatorWeight: 3,
                  indicator: UnderlineTabIndicator(
                    borderSide: BorderSide(
                        color: Theme.of(context).colorScheme.secondary,
                        width: 3.0),
                    insets: EdgeInsets.fromLTRB(50.0, 40.0, 50.0, 0.0),
                  ),
                  labelColor: Theme.of(context).colorScheme.secondary,
                  unselectedLabelColor: Theme.of(context).disabledColor,
                  unselectedLabelStyle: sfRegular.copyWith(
                      color: Theme.of(context).disabledColor,
                      fontSize: Dimensions.fontSizeSmall),
                  labelStyle: sfBold.copyWith(
                      fontSize: Dimensions.fontSizeSmall,
                      color: Theme.of(context).primaryColor),
                  tabs: [
                    Tab(text: 'food'.tr),
                    Tab(text: 'restaurants'.tr),
                  ],
                ),
              )),
              (catController.subCategoryList != null &&
                      !catController.isSearching)
                  ? Center(
                      child: Container(
                      height: 50,
                      width: Dimensions.WEB_MAX_WIDTH,
                      color: Theme.of(context).cardColor,
                      padding: EdgeInsets.symmetric(
                          vertical: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: catController.subCategoryList.length,
                        padding: EdgeInsets.only(
                            left: Dimensions.PADDING_SIZE_SMALL),
                        physics: BouncingScrollPhysics(),
                        itemBuilder: (context, index) {
                          return InkWell(
                            onTap: () => catController.setSubCategoryIndex(
                                index, widget.categoryID),
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10),
                              child: Center(
                                child: Container(
                                  //
                                  padding: EdgeInsets.symmetric(
                                      horizontal:
                                          Dimensions.PADDING_SIZE_SMALL * 4,
                                      vertical:
                                          Dimensions.PADDING_SIZE_SMALL * 1.2),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      border: Border.all(
                                          color: index ==
                                                  catController.subCategoryIndex
                                              ? Theme.of(context)
                                                  .colorScheme
                                                  .secondary
                                              : Theme.of(context).disabledColor,
                                          width: 1)),
                                  child: ShaderMask(
                                    shaderCallback: (rect) {
                                      return LinearGradient(
                                        colors: index ==
                                                catController.subCategoryIndex
                                            ? [
                                                Color(0xffff8022),
                                                Color(0xffff2222)
                                              ]
                                            : [
                                                Theme.of(context).disabledColor,
                                                Theme.of(context).disabledColor,
                                              ],
                                        tileMode: TileMode.mirror,
                                      ).createShader(rect);
                                    },
                                    child: Text(
                                      catController.subCategoryList[index].name,
                                      style: sfBold.copyWith(
                                          color: Colors.white,
                                          fontSize: Dimensions.fontSizeSmall),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ))
                  : SizedBox(),

              // VegFilterWidget(
              //     type: catController.type,
              //     onSelected: (String type) {
              //       if (catController.isSearching) {
              //         catController.searchData(
              //           catController.subCategoryIndex == 0
              //               ? widget.categoryID
              //               : catController
              //                   .subCategoryList[catController.subCategoryIndex]
              //                   .id
              //                   .toString(),
              //           '1',
              //           type,
              //         );
              //       } else {
              //         if (catController.isRestaurant) {
              //           catController.getCategoryRestaurantList(
              //             catController.subCategoryIndex == 0
              //                 ? widget.categoryID
              //                 : catController
              //                     .subCategoryList[
              //                         catController.subCategoryIndex]
              //                     .id
              //                     .toString(),
              //             1,
              //             type,
              //             true,
              //           );
              //         } else {
              //           catController.getCategoryProductList(
              //             catController.subCategoryIndex == 0
              //                 ? widget.categoryID
              //                 : catController
              //                     .subCategoryList[
              //                         catController.subCategoryIndex]
              //                     .id
              //                     .toString(),
              //             1,
              //             type,
              //             true,
              //           );
              //         }
              //       }
              //     }),
              Expanded(
                  child: NotificationListener(
                onNotification: (scrollNotification) {
                  if (scrollNotification is ScrollEndNotification) {
                    if ((_tabController.index == 1 &&
                            !catController.isRestaurant) ||
                        _tabController.index == 0 &&
                            catController.isRestaurant) {
                      catController.setRestaurant(_tabController.index == 1);
                      if (catController.isSearching) {
                        catController.searchData(
                          catController.searchText,
                          catController.subCategoryIndex == 0
                              ? widget.categoryID
                              : catController
                                  .subCategoryList[
                                      catController.subCategoryIndex]
                                  .id,
                          catController.type,
                        );
                      } else {
                        if (_tabController.index == 1) {
                          catController.getCategoryRestaurantList(
                            catController.subCategoryIndex == 0
                                ? widget.categoryID
                                : catController
                                    .subCategoryList[
                                        catController.subCategoryIndex]
                                    .id,
                            1,
                            catController.type,
                            false,
                          );
                        } else {
                          catController.getCategoryProductList(
                            catController.subCategoryIndex == 0
                                ? widget.categoryID
                                : catController
                                    .subCategoryList[
                                        catController.subCategoryIndex]
                                    .id,
                            1,
                            catController.type,
                            false,
                          );
                        }
                      }
                    }
                  }
                  return false;
                },
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    SingleChildScrollView(
                      controller: scrollController,
                      child: ProductView(
                        isRestaurant: false,
                        products: _products,
                        restaurants: null,
                        noDataText: 'no_category_food_found'.tr,
                      ),
                    ),
                    SingleChildScrollView(
                      controller: restaurantScrollController,
                      child: ProductView(
                        isRestaurant: true,
                        products: null,
                        restaurants: _restaurants,
                        noDataText: 'no_category_restaurant_found'.tr,
                      ),
                    ),
                  ],
                ),
              )),
              catController.isLoading
                  ? Center(
                      child: Padding(
                      padding: EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
                      child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(
                              Theme.of(context).primaryColor)),
                    ))
                  : SizedBox(),
            ]),
          )),
        ),
      );
    });
  }
}
