import 'package:efood_multivendor/helper/size_config.dart';
import 'package:efood_multivendor/util/dimensions.dart';
import 'package:flutter/material.dart';

class QuantityButton extends StatelessWidget {
  final bool isIncrement;
  final Function onTap;
  QuantityButton({@required this.isIncrement, @required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: isIncrement
          ? Container(
              height: 5.h,
              width: 5.h,
              margin: EdgeInsets.symmetric(
                  horizontal: Dimensions.PADDING_SIZE_SMALL),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.topRight,
                    colors: [
                      Theme.of(context).primaryColor,
                      Theme.of(context).colorScheme.secondary
                    ]),
              ),
              alignment: Alignment.center,
              child: Icon(
                Icons.add,
                size: 15,
                color: Theme.of(context).cardColor,
              ),
            )
          : Container(
              height: 5.h,
              width: 5.h,
              margin: EdgeInsets.symmetric(
                  horizontal: Dimensions.PADDING_SIZE_SMALL),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border:
                    Border.all(width: 1, color: Theme.of(context).primaryColor),
                color: Theme.of(context).disabledColor.withOpacity(0.2),
              ),
              alignment: Alignment.center,
              child: Icon(
                Icons.remove,
                size: 15,
                color: Theme.of(context).primaryColor,
              ),
            ),
    );
  }
}
