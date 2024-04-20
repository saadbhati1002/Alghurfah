import 'package:eshop_multivendor/Helper/Color.dart';
import 'package:eshop_multivendor/Helper/Constant.dart';
import 'package:eshop_multivendor/Helper/String.dart';
import 'package:eshop_multivendor/Model/Section_Model.dart';
import 'package:eshop_multivendor/Screen/Language/languageSettings.dart';
import 'package:eshop_multivendor/Screen/Product%20Detail/productDetail.dart';
import 'package:eshop_multivendor/widgets/appBar.dart';
import 'package:eshop_multivendor/widgets/app_drawer.dart';
import 'package:eshop_multivendor/widgets/background_image.dart';
import 'package:eshop_multivendor/widgets/bottomNavigationSheet.dart';
import 'package:eshop_multivendor/widgets/desing.dart';
import 'package:flutter/material.dart';

class SellerProductScreen extends StatefulWidget {
  final List<Product>? subList;
  final String? categoryTitle;
  const SellerProductScreen({Key? key, this.subList, this.categoryTitle})
      : super(key: key);

  @override
  State<SellerProductScreen> createState() => _SellerProductScreenState();
}

class _SellerProductScreenState extends State<SellerProductScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  setStateNow() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: allAppBottomSheet(context),
      endDrawer: const MyDrawer(),
      key: _scaffoldKey,
      backgroundColor: colors.backgroundColor,
      appBar: getAppBar(_scaffoldKey,
          title: widget.categoryTitle, context: context, setState: setStateNow),
      body: Stack(
        children: [
          const BackgroundImage(),
          SizedBox(
            child: GridView.builder(
                padding: const EdgeInsetsDirectional.only(
                    top: 10, bottom: 10, start: 10, end: 10),
                itemCount: widget.subList!.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    childAspectRatio: 0.55,
                    mainAxisSpacing: 5,
                    crossAxisSpacing: 5,
                    crossAxisCount: 2),
                itemBuilder: (context, index) {
                  return productWidget(widget.subList![index]);
                }),
          )
        ],
      ),
    );
  }

  Widget productWidget(Product model) {
    double width = deviceWidth! * 0.5;

    String? offPer;
    double price = double.parse(model.prVarientList![0].disPrice!);
    if (price == 0) {
      price = double.parse(model.prVarientList![0].price!);
    } else {
      double off = double.parse(model.prVarientList![0].price!) - price;
      offPer = ((off * 100) / double.parse(model.prVarientList![0].price!))
          .toStringAsFixed(2);
    }
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
      child: InkWell(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Expanded(
              child: Stack(
                alignment: Alignment.bottomRight,
                clipBehavior: Clip.none,
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.only(
                      topRight: Radius.circular(20),
                      bottomLeft: Radius.circular(20),
                    ),
                    child: Hero(
                      tag: '$heroTagUniqueString${model.id}',
                      child: DesignConfiguration.getCacheNotworkImage(
                        boxFit: BoxFit.fill,
                        context: context,
                        heightvalue: double.maxFinite,
                        widthvalue: double.maxFinite,
                        placeHolderSize: width,
                        imageurlString: model.image!,
                      ),
                    ),
                  ),
                  Positioned.fill(
                    child: model.availability == '0'
                        ? Container(
                            height: 55,
                            color: colors.white70,
                            padding: const EdgeInsets.all(2),
                            child: Center(
                              child: Text(
                                getTranslated(context, 'OUT_OF_STOCK_LBL')!,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodySmall!
                                    .copyWith(
                                      color: colors.red,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: 'ubuntu',
                                    ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          )
                        : Container(),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsetsDirectional.only(
                start: 10.0,
                top: 10,
              ),
              child: Text(
                model.name!,
                style: Theme.of(context).textTheme.bodySmall!.copyWith(
                      color: Colors.black,
                      fontSize: textFontSize15,
                      fontWeight: FontWeight.w500,
                      fontStyle: FontStyle.normal,
                      // fontFamily: 'ubuntu',
                    ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                softWrap: true,
              ),
            ),
            Padding(
              padding: const EdgeInsetsDirectional.only(
                start: 8.0,
                top: 5,
              ),
              child: Row(
                children: [
                  Text(
                    ' ${DesignConfiguration.getPriceFormat(context, price)!}',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.blue,
                      fontSize: textFontSize14,
                      fontWeight: FontWeight.w700,
                      fontStyle: FontStyle.normal,
                      fontFamily: 'ubuntu',
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsetsDirectional.only(
                        start: 10.0,
                        top: 5,
                      ),
                      child: Row(
                        children: <Widget>[
                          Text(
                            double.parse(model.prVarientList![0].disPrice!) != 0
                                ? '${DesignConfiguration.getPriceFormat(context, double.parse(model.prVarientList![0].price!))}'
                                : '',
                            style: Theme.of(context)
                                .textTheme
                                .labelSmall!
                                .copyWith(
                                  fontFamily: 'ubuntu',
                                  color: Colors.black,
                                  decoration: TextDecoration.lineThrough,
                                  decorationColor: Colors.black,
                                  decorationStyle: TextDecorationStyle.solid,
                                  decorationThickness: 2,
                                  letterSpacing: 0,
                                  fontSize: textFontSize10,
                                  fontWeight: FontWeight.w600,
                                  fontStyle: FontStyle.normal,
                                ),
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  PageRouteBuilder(
                    pageBuilder: (_, __, ___) => ProductDetail(
                      model: model,
                      secPos: 0,
                      list: true,
                    ),
                  ),
                );
              },
              child: Container(
                height: 25,
                width: MediaQuery.of(context).size.width,
                decoration: const BoxDecoration(
                  color: colors.eCommerceColor,
                  borderRadius: BorderRadius.only(
                      topRight: Radius.circular(20),
                      bottomLeft: Radius.circular(20)),
                ),
                alignment: Alignment.center,
                child: Text(
                  getTranslated(context, 'VIEW')!,
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w500),
                ),
              ),
            ),
          ],
        ),
        onTap: () {
          Navigator.push(
            context,
            PageRouteBuilder(
              pageBuilder: (_, __, ___) => ProductDetail(
                model: model,
                secPos: 0,
                list: true,
              ),
            ),
          );
        },
      ),
    );
  }
}
