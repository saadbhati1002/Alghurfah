import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:provider/provider.dart';
import '../../../Helper/Color.dart';
import '../../../Helper/Constant.dart';
import '../../../Helper/String.dart';
import '../../../Model/Section_Model.dart';
import '../../../Provider/Favourite/FavoriteProvider.dart';
import '../../../Provider/explore_provider.dart';
import '../../../widgets/desing.dart';
import '../../Language/languageSettings.dart';
import '../../../widgets/snackbar.dart';
import '../../../widgets/star_rating.dart';
import '../../Dashboard/Dashboard.dart';
import '../../Product Detail/productDetail.dart';

class GridViewLayOut extends StatefulWidget {
  int index;
  Function update;

  GridViewLayOut({
    Key? key,
    required this.index,
    required this.update,
  }) : super(key: key);

  @override
  State<GridViewLayOut> createState() => _GridViewLayOutState();
}

class _GridViewLayOutState extends State<GridViewLayOut> {
  showSanckBarNowForAdd(
    Map<String, dynamic> response,
    Product model,
    int index,
  ) {
    //
    var getdata = response;

    bool error = getdata['error'];
    String? msg = getdata['message'];
    if (!error) {
      index == -1
          ? model.isFav = '1'
          : context.read<ExploreProvider>().productList[index].isFav = '1';
      context.read<FavoriteProvider>().addFavItem(model);
      setSnackbar(msg!, context);
    } else {
      setSnackbar(msg!, context);
    }
    index == -1
        ? model.isFavLoading = false
        : context.read<ExploreProvider>().productList[index].isFavLoading =
            false;
    widget.update();
    setState(() {});
  }

  showSanckBarNowForRemove(
    Response response,
    int index,
    Product model,
  ) {
    //
    var getdata = json.decode(response.body);
    bool error = getdata['error'];
    String? msg = getdata['message'];
    if (!error) {
      index == -1
          ? model.isFav = '0'
          : context.read<ExploreProvider>().productList[index].isFav = '0';
      context
          .read<FavoriteProvider>()
          .removeFavItem(model.prVarientList![0].id!);
      setSnackbar(msg!, context);
    } else {
      setSnackbar(msg!, context);
    }
    index == -1
        ? model.isFavLoading = false
        : context.read<ExploreProvider>().productList[index].isFavLoading =
            false;
    widget.update();
  }

  @override
  Widget build(BuildContext context) {
    int index = widget.index;
    if (context.read<ExploreProvider>().productList.length > index) {
      String? offPer;
      double price = double.parse(context
          .read<ExploreProvider>()
          .productList[index]
          .prVarientList![0]
          .disPrice!);
      if (price == 0) {
        price = double.parse(context
            .read<ExploreProvider>()
            .productList[index]
            .prVarientList![0]
            .price!);
      } else {
        double off = double.parse(context
                .read<ExploreProvider>()
                .productList[index]
                .prVarientList![0]
                .price!) -
            price;
        offPer = ((off * 100) /
                double.parse(context
                    .read<ExploreProvider>()
                    .productList[index]
                    .prVarientList![0]
                    .price!))
            .toStringAsFixed(2);
      }

      double width = deviceWidth! * 0.5;
      Product model = context.read<ExploreProvider>().productList[index];
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
                        tag: '$heroTagUniqueString${widget.index}${model.id}',
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
                              double.parse(model.prVarientList![0].disPrice!) !=
                                      0
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
                        index: widget.index,
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
                  index: widget.index,
                  secPos: 0,
                  list: true,
                ),
              ),
            );
          },
        ),
      );
      
    } else {
      return Container();
    }
  }
}
