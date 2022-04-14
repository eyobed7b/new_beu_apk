import 'dart:async';
import 'dart:ui';

import 'package:efood_multivendor/helper/responsive_helper.dart';
import 'package:efood_multivendor/helper/size_config.dart';
import 'package:efood_multivendor/util/dimensions.dart';
import 'package:efood_multivendor/view/base/cart_widget.dart';
import 'package:efood_multivendor/view/screens/cart/cart_screen.dart';
import 'package:efood_multivendor/view/screens/dashboard/widget/bottom_nav_item.dart';
import 'package:efood_multivendor/view/screens/favourite/favourite_screen.dart';
import 'package:efood_multivendor/view/screens/home/home_screen.dart';
import 'package:efood_multivendor/view/screens/menu/menu_screen.dart';
import 'package:efood_multivendor/view/screens/order/order_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:dot_navigation_bar/dot_navigation_bar.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';

import '../profile/profile_screen.dart';

class DashboardScreen extends StatefulWidget {
  final int pageIndex;
  DashboardScreen({@required this.pageIndex});

  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  PageController _pageController;
  int _pageIndex = 0;
  List<Widget> _screens;
  GlobalKey<ScaffoldMessengerState> _scaffoldKey = GlobalKey();
  bool _canExit = GetPlatform.isWeb ? true : false;

  @override
  void initState() {
    super.initState();

    _pageIndex = widget.pageIndex;

    _pageController = PageController(initialPage: widget.pageIndex);

    _screens = [
      HomeScreen(),
      OrderScreen(),
      // FavouriteScreen(),
      // CartScreen(fromNav: true),
      // OrderScreen(),
      ProfileScreen(),
    ];

    Future.delayed(Duration(seconds: 1), () {
      setState(() {});
    });

    /*if(GetPlatform.isMobile) {
      NetworkInfo.checkConnectivity(_scaffoldKey.currentContext);
    }*/
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async {
          if (_pageIndex != 0) {
            _setPage(0);
            return false;
          } else {
            if (_canExit) {
              return true;
            } else {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text('back_press_again_to_exit'.tr,
                    style: TextStyle(color: Colors.white)),
                behavior: SnackBarBehavior.floating,
                backgroundColor: Colors.green,
                duration: Duration(seconds: 2),
                margin: EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
              ));
              _canExit = true;
              Timer(Duration(seconds: 2), () {
                _canExit = false;
              });
              return false;
            }
          }
        },
        child: Scaffold(
            key: _scaffoldKey,
            extendBody: true,
            body: _screens[_pageIndex],
            bottomNavigationBar: ResponsiveHelper.isDesktop(context)
                ? SizedBox()
                : DotNavigationBar(
                    enablePaddingAnimation: false,
                    // enableFloatingNavBar: false,
                    borderRadius: 22,
                    // itemPadding: EdgeInsets.only(
                    //     left: getProportionateScreenWidth(0),
                    //     right: getProportionateScreenWidth(10)),
                    margin: EdgeInsets.only(
                        // bottom: getProportionateScreenHeight(100),
                        left: 0,
                        right: 0),
                    dotIndicatorColor: Colors.transparent,
                    backgroundColor: Colors.white,
                    marginR: EdgeInsets.symmetric(horizontal: 18, vertical: 10),
                    paddingR: EdgeInsets.only(bottom: 10, top: 10, right: 10),

                    boxShadow: [
                      BoxShadow(
                        color: Color(0xFF5A6CEA).withOpacity(0.1),
                        spreadRadius: 5,
                        blurRadius: 5,

                        offset: Offset(-4, 2), // changes position of shadow
                      ),
                    ],
                    selectedItemColor: Colors.red,
                    currentIndex: _pageIndex,
                    unselectedItemColor: Colors.grey[300],
                    onTap: _setPage,
                    items: <DotNavigationBarItem>[
                      DotNavigationBarItem(
                        // selectedColor: Colors.green,
                        icon: Opacity(
                          opacity: _pageIndex == 0 ? 1 : 0.4,
                          child: ShaderMask(
                            shaderCallback: (Rect bounds) {
                              return LinearGradient(
                                // center: Alignment.topLeft,
                                // radius: 0.5,
                                colors: <Color>[
                                  Color(0xffff8022),
                                  Color(0xffff2222)
                                ],
                                tileMode: TileMode.repeated,
                              ).createShader(bounds);
                            },
                            child: SvgPicture.asset(
                              'assets/icons/home.svg',
                            ),
                          ),
                        ),
                      ),
                      DotNavigationBarItem(
                        // selectedColor: Colors.green,
                        icon: Opacity(
                          opacity: _pageIndex == 1 ? 1 : 0.4,
                          child: ShaderMask(
                            shaderCallback: (Rect bounds) {
                              return LinearGradient(
                                // center: Alignment.topLeft,
                                // radius: 0.5,
                                colors: <Color>[
                                  Color(0xffff8022),
                                  Color(0xffff2222)
                                ],
                                tileMode: TileMode.repeated,
                              ).createShader(bounds);
                            },
                            child: SvgPicture.asset(
                              'assets/icons/order.svg',
                            ),
                          ),
                        ),
                      ),
                      DotNavigationBarItem(
                        // selectedColor: Colors.green,
                        icon: Opacity(
                          opacity: _pageIndex == 2 ? 1 : 0.4,
                          child: ShaderMask(
                            shaderCallback: (Rect bounds) {
                              return LinearGradient(
                                // center: Alignment.topLeft,
                                // radius: 0.5,
                                colors: <Color>[
                                  Color(0xffff8022),
                                  Color(0xffff2222)
                                ],
                                tileMode: TileMode.repeated,
                              ).createShader(bounds);
                            },
                            child: SvgPicture.asset(
                              'assets/icons/profile.svg',
                            ),
                          ),
                        ),
                      ),
                    ],
                  )));
  }

  void _setPage(int pageIndex) {
    setState(() {
      // _pageController.jumpToPage(pageIndex);
      _pageIndex = pageIndex;
    });
  }
}
