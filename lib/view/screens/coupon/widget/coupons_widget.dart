import 'package:efood_multivendor/helper/size_config.dart';
import 'package:efood_multivendor/util/images.dart';
import 'package:flutter/material.dart';

class CouponsWidget extends StatelessWidget {
  const CouponsWidget(
      {Key key, this.couponCode, this.coupponOff, this.couponImage})
      : super(key: key);
  final String couponCode;
  final String coupponOff;
  final String couponImage;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 1.5.h),
      child: Container(
        height: 20.h,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          gradient: LinearGradient(colors: [
            Color(
              0xffff8022,
            ),
            Color(0xffff2222)
          ]),
          image: DecorationImage(
            image: AssetImage(Images.patterncard),
            fit: BoxFit.cover,
          ),
        ),
        child: Row(children: [
          Image.asset(couponImage
              // Images.coup1,
              ),
          SizedBox(width: 5.w),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 5),
            child: Column(
              children: [
                RichText(
                    text: TextSpan(
                  text: 'First\n',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 1.8.h,
                      fontWeight: FontWeight.w300),
                  children: <TextSpan>[
                    TextSpan(
                        text: 'Order\n',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 2.3.h)),
                    TextSpan(
                      text: 'Promo Code :$couponCode\n',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 1.5.h,
                          fontWeight: FontWeight.w300),
                    ),
                    TextSpan(
                        text: '$coupponOff\n',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 3.7.h)),
                  ],
                )),
                Container(
                  width: 29.w,
                  height: 4.5.h,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    // color: Color(0xffff8022),
                    border: Border.all(
                      color: Colors.white,
                      width: 0.2.h,
                    ),
                  ),
                  child: Center(
                    child: Text(
                      "Click To Copy",
                      style: TextStyle(fontSize: 15, color: Colors.white),
                    ),
                  ),
                )
              ],
            ),
          )
        ]),
      ),
    );
  }
}
