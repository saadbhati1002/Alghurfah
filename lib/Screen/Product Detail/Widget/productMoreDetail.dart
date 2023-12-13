import 'package:eshop_multivendor/Helper/Color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:provider/provider.dart';
import '../../../Helper/Constant.dart';
import '../../../Helper/String.dart';
import '../../../Model/Section_Model.dart';
import '../../../Provider/productDetailProvider.dart';
import '../../Language/languageSettings.dart';

class ProductMoreDetail extends StatelessWidget {
  Product? model;
  Function update;
  ProductMoreDetail({Key? key, this.model, required this.update})
      : super(key: key);

  _desc(Product? model) {
    return model!.shortDescription != '' && model.shortDescription != null
        ? Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10),
            child: HtmlWidget(
              model.desc ?? '',
              textStyle: const TextStyle(color: Colors.black),
            )
            //  Html(
            //   data: model.shortDescription,
            //   onLinkTap: (String? url, RenderContext context,
            //       Map<String, String> attributes, dom.Element? element) async {
            //     if (await canLaunchUrl(Uri.parse(url!))) {
            //       await launchUrl(
            //         Uri.parse(url),
            //         mode: LaunchMode.platformDefault,
            //       );
            //     } else {
            //       throw 'Could not launch $url';
            //     }
            //   },
            // ),
            )
        : Container();
  }

  _attr(Product? model) {
    return model!.attributeList!.isNotEmpty
        ? ListView.builder(
            padding: EdgeInsets.zero,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: model.attributeList!.length,
            itemBuilder: (context, i) {
              return Padding(
                padding: EdgeInsetsDirectional.only(
                    start: 10.0,
                    top: 0.0,
                    bottom: model.madein != '' && model.madein!.isNotEmpty
                        ? 0.0
                        : 0.0),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 1,
                      child: Text(
                        model.attributeList![i].name!,
                        style: const TextStyle(color: Colors.black),
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: Padding(
                        padding: const EdgeInsetsDirectional.only(start: 5.0),
                        child: Text(
                          model.attributeList![i].value!,
                          textAlign: TextAlign.start,
                          style: const TextStyle(color: Colors.black),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          )
        : Container();
  }

  _madeIn(Product? model, BuildContext context) {
    String? madeIn = model!.madein;

    return madeIn != '' && madeIn!.isNotEmpty
        ? Padding(
            padding: const EdgeInsets.symmetric(horizontal: 0),
            child: ListTile(
              trailing: Text(madeIn),
              focusColor: Colors.black,
              dense: true,
              title: Text(
                "${getTranslated(context, 'MADE_IN')!} $madeIn ",
                style: const TextStyle(color: Colors.black),
              ),
            ),
          )
        : Container();
  }

  indicator(Product? model, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 17),
      child: Text(
        "${getTranslated(context, 'Product Indicator')!}: ${getIndicator(context)} ",
        style: const TextStyle(color: Colors.black),
      ),
    );
  }

  getIndicator(BuildContext context) {
    String title = "";
    if (model!.indicator == '0') {
      title = getTranslated(context, 'Organic')!;
    } else if (model!.indicator == '1') {
      title = getTranslated(context, 'Non-Organic')!;
    } else if (model!.indicator == '2') {
      title = getTranslated(context, 'Vegan')!;
    } else if (model!.indicator == '3') {
      title = getTranslated(context, 'Non-Vegan')!;
    } else if (model!.indicator == '4') {
      title = getTranslated(context, 'Environment Friendly')!;
    } else if (model!.indicator == '5') {
      title = getTranslated(context, 'None')!;
    }
    return title;
  }

  @override
  Widget build(BuildContext context) {
    return model!.attributeList!.isNotEmpty ||
            (model!.desc != '' && model!.desc != null) ||
            model!.madein != '' && model!.madein!.isNotEmpty
        ? Container(
            padding: const EdgeInsets.only(top: 10.0),
            child: InkWell(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsetsDirectional.only(
                      start: 15.0,
                      end: 15.0,
                      bottom: 0,
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            getTranslated(context, 'Product Details')!,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Ubuntu',
                              fontStyle: FontStyle.normal,
                              fontSize: textFontSize16,
                              color: Theme.of(context).colorScheme.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  !context.read<ProductDetailProvider>().seeView
                      ? SizedBox(
                          height: 100,
                          width: deviceWidth! - 10,
                          child: SingleChildScrollView(
                            physics: const NeverScrollableScrollPhysics(),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _desc(model),
                                model!.desc != '' && model!.desc != null
                                    ? const Padding(
                                        padding: EdgeInsets.symmetric(
                                          horizontal: 10.0,
                                        ),
                                        child: Divider(
                                          height: 3.0,
                                        ),
                                      )
                                    : Container(),
                                _attr(model),
                                model!.madein != '' && model!.madein!.isNotEmpty
                                    ? const Divider()
                                    : Container(),
                                _madeIn(model, context),
                                indicator(model, context),
                              ],
                            ),
                          ),
                        )
                      : Padding(
                          padding: const EdgeInsets.only(left: 5.0, right: 5.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              _desc(model),
                              model!.desc != '' && model!.desc != null
                                  ? const Divider(
                                      height: 3.0,
                                    )
                                  : Container(),
                              _attr(model),
                              model!.madein != '' && model!.madein!.isNotEmpty
                                  ? const Divider()
                                  : Container(),
                              _madeIn(model, context),
                              indicator(model, context),
                            ],
                          ),
                        ),
                  Row(
                    children: [
                      InkWell(
                        child: Padding(
                          padding: const EdgeInsetsDirectional.only(
                              start: 15, top: 10, end: 2, bottom: 15),
                          child: Text(
                            !context.read<ProductDetailProvider>().seeView
                                ? getTranslated(context, 'See More')!
                                : getTranslated(context, 'See Less')!,
                            style:
                                Theme.of(context).textTheme.bodySmall!.copyWith(
                                      color: colors.primary,
                                      fontWeight: FontWeight.w400,
                                      fontFamily: 'Ubuntu',
                                      fontStyle: FontStyle.normal,
                                      fontSize: textFontSize14,
                                    ),
                          ),
                        ),
                        onTap: () {
                          context.read<ProductDetailProvider>().seeView =
                              !context.read<ProductDetailProvider>().seeView;

                          update();
                        },
                      ),
                      Icon(
                        Icons.keyboard_arrow_right,
                        size: 18,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          )
        : Container();
  }
}
