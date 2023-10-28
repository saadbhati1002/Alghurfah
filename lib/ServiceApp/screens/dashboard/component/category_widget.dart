import 'package:eshop_multivendor/Helper/Color.dart';
import 'package:eshop_multivendor/Helper/Constant.dart';
import 'package:eshop_multivendor/main.dart';
import 'package:eshop_multivendor/ServiceApp/model/category_model.dart';
import 'package:eshop_multivendor/ServiceApp/utils/constant.dart';
import 'package:eshop_multivendor/widgets/desing.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:nb_utils/nb_utils.dart';

class CategoryWidget extends StatelessWidget {
  final CategoryData categoryData;
  final double? width;
  final bool? isFromCategory;

  CategoryWidget({required this.categoryData, this.width, this.isFromCategory});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width ?? context.width() / 4 - 24,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              categoryData.categoryImage.validate().endsWith('.svg')
                  ? Container(
                      width: CATEGORY_ICON_SIZE,
                      height: CATEGORY_ICON_SIZE,
                      padding: const EdgeInsets.all(8),
                      child: SvgPicture.network(
                        categoryData.categoryImage.validate(),
                        height: CATEGORY_ICON_SIZE,
                        width: CATEGORY_ICON_SIZE,
                        color: appStore.isDarkMode
                            ? Colors.white
                            : categoryData.color
                                .validate(value: '000')
                                .toColor(),
                        placeholderBuilder: (context) => PlaceHolderWidget(
                          height: CATEGORY_ICON_SIZE,
                          width: CATEGORY_ICON_SIZE,
                          color: transparentColor,
                        ),
                      ).paddingAll(10),
                    )
                  : ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: DesignConfiguration.getCacheNotworkImage(
                        boxFit: BoxFit.cover,
                        context: context,
                        heightvalue: 65.0,
                        widthvalue: 65.0,
                        placeHolderSize: 65,
                        imageurlString: categoryData.categoryImage.validate(),
                      ),
                    ),
              Padding(
                padding: const EdgeInsets.only(top: 0, left: 15),
                child: SizedBox(
                  child: Text(
                    categoryData.name ?? '',
                    style: Theme.of(context).textTheme.bodySmall!.copyWith(
                          fontFamily: 'ubuntu',
                          color: Theme.of(context).colorScheme.fontColor,
                          fontWeight: FontWeight.w600,
                          fontSize: textFontSize14,
                        ),
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ],
          ),
          const Icon(
            Icons.arrow_forward_ios,
            size: 18,
          )
        ],
      ),
    );
  }
}
