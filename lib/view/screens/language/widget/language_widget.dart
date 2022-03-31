import 'package:efood_multivendor/controller/localization_controller.dart';
import 'package:efood_multivendor/data/model/response/language_model.dart';
import 'package:efood_multivendor/helper/get_di.dart';
import 'package:efood_multivendor/helper/size_config.dart';
import 'package:efood_multivendor/util/app_constants.dart';
import 'package:efood_multivendor/util/dimensions.dart';
import 'package:efood_multivendor/util/images.dart';
import 'package:efood_multivendor/util/styles.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:efood_multivendor/helper/size_config.dart' as Size;

enum LanguageSelected {
  english,
  amharic,
}

class LanguageWidget extends StatelessWidget {
  final LanguageModel languageModel;
  final LocalizationController localizationController;
  final int index;
  LanguageWidget(
      {@required this.languageModel,
      @required this.localizationController,
      @required this.index});

  @override
  Widget build(BuildContext context) {
    Size.init(context);
    LanguageSelected selLanguage = LanguageSelected.english;
    var _value;
    var _onChanged;
    return InkWell(
      onTap: () {
        localizationController.setLanguage(Locale(
          AppConstants.languages[index].languageCode,
          AppConstants.languages[index].countryCode,
        ));
        localizationController.setSelectIndex(index);
      },
      child: Padding(
        padding: const EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
        child: Container(
            width: 90.w,
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(Dimensions.RADIUS_SMALL),
              boxShadow: [
                BoxShadow(
                    color: Colors.grey[Get.isDarkMode ? 800 : 200],
                    blurRadius: 5,
                    spreadRadius: 1)
              ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Radio<LanguageModel>(
                        fillColor: MaterialStateProperty.all(
                            Theme.of(context).primaryColor),
                        value: localizationController.languages[index],
                        groupValue: AppConstants
                            .languages[localizationController.selectedIndex],
                        onChanged: onChanged),
                    SizedBox(
                      width: 1.w,
                    ),
                    Text(
                      languageModel.languageName,
                      style: TextStyle(color: Colors.black),
                    ),
                  ],
                ),
                Spacer(),
                Image.asset(
                  languageModel.imageUrl,
                  fit: BoxFit.fitHeight,
                ),
              ],
            )

            // Stack(children: [

            //   Center(
            //     child: Column(mainAxisSize: MainAxisSize.min, children: [
            //       Container(
            //         height: 65, width: 65,
            //         decoration: BoxDecoration(
            //           borderRadius: BorderRadius.circular(Dimensions.RADIUS_SMALL),
            //           border: Border.all(color: Theme.of(context).textTheme.bodyText1.color, width: 1),
            //         ),
            //         alignment: Alignment.center,
            //         child: Image.asset(languageModel.imageUrl, width: 36, height: 36),
            //       ),
            //       SizedBox(height: Dimensions.PADDING_SIZE_LARGE),
            //       Text(languageModel.languageName, style: sfRegular),
            //     ]),
            //   ),

            //   localizationController.selectedIndex == index ? Positioned(
            //     top: 0, right: 0,
            //     child: Icon(Icons.check_circle, color: Theme.of(context).primaryColor, size: 25),
            //   ) : SizedBox(),

            // ])

            ),
      ),
    );
  }

  void onChanged(LanguageModel value) {
    localizationController.setSelectIndex(index);
  }
}
