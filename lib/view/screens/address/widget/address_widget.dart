import 'package:efood_multivendor/data/model/response/address_model.dart';
import 'package:efood_multivendor/helper/responsive_helper.dart';
import 'package:efood_multivendor/helper/size_config.dart';
import 'package:efood_multivendor/util/dimensions.dart';
import 'package:efood_multivendor/util/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:get/get.dart';

class AddressWidget extends StatelessWidget {
  final AddressModel address;
  final bool fromAddress;
  final bool fromCheckout;
  final Function onRemovePressed;
  final Function onEditPressed;
  final Function onTap;
  AddressWidget(
      {@required this.address,
      @required this.fromAddress,
      this.onRemovePressed,
      this.onEditPressed,
      this.onTap,
      this.fromCheckout = false});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: Dimensions.PADDING_SIZE_SMALL),
      child: InkWell(
        onTap: onTap,
        child: Container(
          padding: EdgeInsets.all(ResponsiveHelper.isDesktop(context)
              ? Dimensions.PADDING_SIZE_DEFAULT
              : Dimensions.PADDING_SIZE_SMALL),
          decoration: BoxDecoration(
            color: fromCheckout ? null : Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(Dimensions.RADIUS_SMALL),
            border: fromCheckout
                ? Border.all(color: Theme.of(context).disabledColor, width: 1)
                : null,
            boxShadow: fromCheckout
                ? null
                : [
                    BoxShadow(
                        color: Colors.grey[Get.isDarkMode ? 800 : 200],
                        blurRadius: 5,
                        spreadRadius: 1)
                  ],
          ),
          child: Row(children: [
            ShaderMask(
              shaderCallback: (shade) {
                return LinearGradient(
                  colors: [Color(0xffff8022), Color(0xffff2222)],
                  tileMode: TileMode.mirror,
                ).createShader(shade);
              },
              child: Icon(
                address.addressType == 'home'
                    ? FeatherIcons.home
                    : address.addressType == 'office'
                        ? FeatherIcons.briefcase
                        : FeatherIcons.flag,
                size: ResponsiveHelper.isDesktop(context) ? 50 : 25,
                color: Colors.white,
              ),
            ),
            SizedBox(width: Dimensions.PADDING_SIZE_SMALL),
            Expanded(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      address.addressType.tr,
                      style: sfMedium.copyWith(
                          fontSize: Dimensions.fontSizeSmall * 0.35.w,
                          fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                    Text(
                      address.address,
                      style: sfRegular.copyWith(
                          fontSize: Dimensions.fontSizeExtraSmall * 0.4.w,
                          color: Theme.of(context).disabledColor),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ]),
            ),
            // fromAddress ? IconButton(
            //   icon: Icon(Icons.edit, color: Colors.blue, size: ResponsiveHelper.isDesktop(context) ? 35 : 25),
            //   onPressed: onEditPressed,
            // ) : SizedBox(),
            fromAddress
                ? IconButton(
                    icon: Icon(FeatherIcons.trash,
                        color: Color.fromARGB(255, 0, 0, 0),
                        size: ResponsiveHelper.isDesktop(context) ? 35 : 25),
                    onPressed: onRemovePressed,
                  )
                : SizedBox(),
          ]),
        ),
      ),
    );
  }
}
