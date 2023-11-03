import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../Helper/Color.dart';
import '../../../Helper/Constant.dart';
import '../../../Helper/String.dart';
import '../../SQLiteData/SqliteData.dart';
import '../../../Model/Section_Model.dart';
import '../../../Provider/CartProvider.dart';
import '../../../Provider/Favourite/FavoriteProvider.dart';
import '../../../Provider/Favourite/UpdateFavProvider.dart';
import '../../../Provider/UserProvider.dart';
import '../../../widgets/desing.dart';
import '../../Language/languageSettings.dart';
import '../../../widgets/networkAvailablity.dart';
import '../../../widgets/snackbar.dart';
import '../../../widgets/star_rating.dart';
import '../../Product Detail/productDetail.dart';
import 'package:collection/src/iterable_extensions.dart';

class FavProductData extends StatefulWidget {
  int? index;
  List<Product> favList = [];
  Function updateNow;

  FavProductData({
    Key? key,
    required this.index,
    required this.updateNow,
    required this.favList,
  }) : super(key: key);

  @override
  State<FavProductData> createState() => _FavProductDataState();
}

class _FavProductDataState extends State<FavProductData> {
  var db = DatabaseHelper();

  removeFromCart(
    int index,
    List<Product> favList,
    BuildContext context,
  ) async {
    isNetworkAvail = await isNetworkAvailable();
    if (isNetworkAvail) {
      if (CUR_USERID != null) {
        if (mounted) {
          context
              .read<UpdateFavProvider>()
              .changeStatus(UpdateFavStatus.inProgress);
        }
        int qty;
        qty = (int.parse(
                context.read<FavoriteProvider>().controllerText[index].text) -
            int.parse(favList[index].qtyStepSize!));

        if (qty < favList[index].minOrderQuntity!) {
          qty = 0;
        }

        var parameter = {
          PRODUCT_VARIENT_ID:
              favList[index].prVarientList![favList[index].selVarient!].id,
          USER_ID: CUR_USERID,
          QTY: qty.toString()
        };

        apiBaseHelper.postAPICall(manageCartApi, parameter).then(
          (getdata) {
            bool error = getdata['error'];
            String? msg = getdata['message'];
            if (!error) {
              var data = getdata['data'];

              String? qty = data['total_quantity'];

              context.read<UserProvider>().setCartCount(data['cart_count']);
              favList[index]
                  .prVarientList![favList[index].selVarient!]
                  .cartCount = qty.toString();

              var cart = getdata['cart'];
              List<SectionModel> cartList = (cart as List)
                  .map((cart) => SectionModel.fromCart(cart))
                  .toList();
              context.read<CartProvider>().setCartlist(cartList);
            } else {
              setSnackbar(msg!, context);
            }

            if (mounted) {
              context
                  .read<UpdateFavProvider>()
                  .changeStatus(UpdateFavStatus.isSuccsess);
              widget.updateNow();
            }
          },
          onError: (error) {
            setSnackbar(error.toString(), context);
            context
                .read<UpdateFavProvider>()
                .changeStatus(UpdateFavStatus.isSuccsess);
            widget.updateNow();
          },
        );
      } else {
        context
            .read<UpdateFavProvider>()
            .changeStatus(UpdateFavStatus.inProgress);
        int qty;

        qty = (int.parse(
                context.read<FavoriteProvider>().controllerText[index].text) -
            int.parse(favList[index].qtyStepSize!));

        if (qty < favList[index].minOrderQuntity!) {
          qty = 0;

          db.removeCart(
              favList[index].prVarientList![favList[index].selVarient!].id!,
              favList[index].id!,
              context);
        } else {
          db.updateCart(
            favList[index].id!,
            favList[index].prVarientList![favList[index].selVarient!].id!,
            qty.toString(),
          );
        }
        context
            .read<UpdateFavProvider>()
            .changeStatus(UpdateFavStatus.isSuccsess);
        widget.updateNow();
      }
    } else {
      if (mounted) {
        isNetworkAvail = false;
        widget.updateNow();
      }
    }
  }

  Future<void> addToCart(
    String qty,
    int from,
    List<Product> favList,
  ) async {
    isNetworkAvail = await isNetworkAvailable();
    if (isNetworkAvail) {
      if (CUR_USERID != null) {
        try {
          if (mounted) {
            context
                .read<UpdateFavProvider>()
                .changeStatus(UpdateFavStatus.inProgress);
          }

          String qty =
              (int.parse(favList[widget.index!].prVarientList![0].cartCount!) +
                      int.parse(favList[widget.index!].qtyStepSize!))
                  .toString();

          if (int.parse(qty) < favList[widget.index!].minOrderQuntity!) {
            qty = favList[widget.index!].minOrderQuntity.toString();
            setSnackbar("${getTranslated(context, 'MIN_MSG')}$qty", context);
          }

          var parameter = {
            PRODUCT_VARIENT_ID: favList[widget.index!]
                .prVarientList![favList[widget.index!].selVarient!]
                .id,
            USER_ID: CUR_USERID,
            QTY: qty,
          };
          apiBaseHelper.postAPICall(manageCartApi, parameter).then(
            (getdata) {
              bool error = getdata['error'];
              String? msg = getdata['message'];
              if (!error) {
                var data = getdata['data'];

                String? qty = data['total_quantity'];
                context.read<UserProvider>().setCartCount(data['cart_count']);

                favList[widget.index!]
                    .prVarientList![favList[widget.index!].selVarient!]
                    .cartCount = qty.toString();

                favList[widget.index!].prVarientList![0].cartCount =
                    qty.toString();
                context
                    .read<FavoriteProvider>()
                    .controllerText[widget.index!]
                    .text = qty.toString();
                var cart = getdata['cart'];
                List<SectionModel> cartList = (cart as List)
                    .map((cart) => SectionModel.fromCart(cart))
                    .toList();
                context.read<CartProvider>().setCartlist(cartList);
              } else {
                setSnackbar(msg!, context);
              }

              if (mounted) {
                context
                    .read<UpdateFavProvider>()
                    .changeStatus(UpdateFavStatus.isSuccsess);
              }
            },
            onError: (error) {
              setSnackbar(error.toString(), context);
            },
          );
        } on TimeoutException catch (_) {
          setSnackbar(getTranslated(context, 'somethingMSg')!, context);
          context.read<FavoriteProvider>().changeStatus(FavStatus.isSuccsess);
          widget.updateNow();
        }
      } else {
        if (singleSellerOrderSystem) {
          if (CurrentSellerID == '' ||
              CurrentSellerID == widget.favList[widget.index!].seller_id!) {
            CurrentSellerID = widget.favList[widget.index!].seller_id!;

            context
                .read<UpdateFavProvider>()
                .changeStatus(UpdateFavStatus.inProgress);
            if (from == 1) {
              db.insertCart(
                widget.favList[widget.index!].id!,
                widget
                    .favList[widget.index!]
                    .prVarientList![widget.favList[widget.index!].selVarient!]
                    .id!,
                qty,
                context,
              );
              context
                  .read<FavoriteProvider>()
                  .controllerText[widget.index!]
                  .text = qty.toString();
              widget.updateNow();
              setSnackbar(getTranslated(context, 'Product Added Successfully')!,
                  context);
            } else {
              if (int.parse(qty) >
                  widget.favList[widget.index!].itemsCounter!.length) {
                setSnackbar(
                    '${getTranslated(context, "Max Quantity is")!}-${int.parse(qty) - 1}',
                    context);
              } else {
                db.updateCart(
                  widget.favList[widget.index!].id!,
                  widget
                      .favList[widget.index!]
                      .prVarientList![widget.favList[widget.index!].selVarient!]
                      .id!,
                  qty,
                );
              }
              context
                  .read<FavoriteProvider>()
                  .controllerText[widget.index!]
                  .text = qty.toString();
              setSnackbar(
                  getTranslated(context, 'Cart Update Successfully')!, context);
            }
          } else {
            setSnackbar(
                getTranslated(context, 'only Single Seller Product Allow')!,
                context);
          }
        } else {
          context
              .read<UpdateFavProvider>()
              .changeStatus(UpdateFavStatus.inProgress);
          if (from == 1) {
            db.insertCart(
              widget.favList[widget.index!].id!,
              widget
                  .favList[widget.index!]
                  .prVarientList![widget.favList[widget.index!].selVarient!]
                  .id!,
              qty,
              context,
            );
            context
                .read<FavoriteProvider>()
                .controllerText[widget.index!]
                .text = qty.toString();
            widget.updateNow();
            setSnackbar(
                getTranslated(context, 'Product Added Successfully')!, context);
          } else {
            if (int.parse(qty) >
                widget.favList[widget.index!].itemsCounter!.length) {
              setSnackbar(
                  '${getTranslated(context, "Max Quantity is")!}-${int.parse(qty) - 1}',
                  context);
            } else {
              db.updateCart(
                widget.favList[widget.index!].id!,
                widget
                    .favList[widget.index!]
                    .prVarientList![widget.favList[widget.index!].selVarient!]
                    .id!,
                qty,
              );
            }
            context
                .read<FavoriteProvider>()
                .controllerText[widget.index!]
                .text = qty.toString();
            setSnackbar(
                getTranslated(context, 'Cart Update Successfully')!, context);
          }
        }
        context
            .read<UpdateFavProvider>()
            .changeStatus(UpdateFavStatus.isSuccsess);
        widget.updateNow();
      }
    } else {
      isNetworkAvail = false;

      widget.updateNow();
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.index! < widget.favList.length && widget.favList.isNotEmpty) {
      if (context.read<FavoriteProvider>().controllerText.length <
          widget.index! + 1) {
        context
            .read<FavoriteProvider>()
            .controllerText
            .add(TextEditingController());
      }
      return Selector<CartProvider, List<SectionModel>>(
          builder: (context, data, child) {
            double price = double.parse(widget
                .favList[widget.index!]
                .prVarientList![widget.favList[widget.index!].selVarient!]
                .disPrice!);
            if (price == 0) {
              price = double.parse(widget
                  .favList[widget.index!]
                  .prVarientList![widget.favList[widget.index!].selVarient!]
                  .price!);
            }
            double off = 0;
            if (widget
                    .favList[widget.index!]
                    .prVarientList![widget.favList[widget.index!].selVarient!]
                    .disPrice !=
                '0') {
              off = (double.parse(widget
                          .favList[widget.index!]
                          .prVarientList![
                              widget.favList[widget.index!].selVarient!]
                          .price!) -
                      double.parse(
                        widget
                            .favList[widget.index!]
                            .prVarientList![
                                widget.favList[widget.index!].selVarient!]
                            .disPrice!,
                      ))
                  .toDouble();
              off = off *
                  100 /
                  double.parse(widget
                      .favList[widget.index!]
                      .prVarientList![widget.favList[widget.index!].selVarient!]
                      .price!);
            }

            SectionModel? tempId = data.firstWhereOrNull((cp) =>
                cp.id == widget.favList[widget.index!].id &&
                cp.varientId ==
                    widget
                        .favList[widget.index!]
                        .prVarientList![
                            widget.favList[widget.index!].selVarient!]
                        .id!);
            if (tempId != null) {
              context
                  .read<FavoriteProvider>()
                  .controllerText[widget.index!]
                  .text = tempId.qty!.toString();
            } else {
              if (CUR_USERID != null) {
                context
                        .read<FavoriteProvider>()
                        .controllerText[widget.index!]
                        .text =
                    widget
                        .favList[widget.index!]
                        .prVarientList![
                            widget.favList[widget.index!].selVarient!]
                        .cartCount!;
              } else {
                context
                    .read<FavoriteProvider>()
                    .controllerText[widget.index!]
                    .text = '0';
              }
            }
            double width = deviceWidth! * 0.5;
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
              child: Stack(
                children: [
                  InkWell(
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
                                  tag:
                                      '$heroTagUniqueString${widget.index}${widget.favList[widget.index!].id}',
                                  child:
                                      DesignConfiguration.getCacheNotworkImage(
                                    boxFit: BoxFit.fill,
                                    context: context,
                                    heightvalue: double.maxFinite,
                                    widthvalue: double.maxFinite,
                                    placeHolderSize: width,
                                    imageurlString:
                                        widget.favList[widget.index!].image!,
                                  ),
                                ),
                              ),
                              Positioned.fill(
                                child: widget.favList[widget.index!]
                                            .availability ==
                                        '0'
                                    ? Container(
                                        height: 55,
                                        color: colors.white70,
                                        padding: const EdgeInsets.all(2),
                                        child: Center(
                                          child: Text(
                                            getTranslated(
                                                context, 'OUT_OF_STOCK_LBL')!,
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
                            widget.favList[widget.index!].name!,
                            style:
                                Theme.of(context).textTheme.bodySmall!.copyWith(
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
                                        double.parse(widget
                                                    .favList[widget.index!]
                                                    .prVarientList![0]
                                                    .disPrice!) !=
                                                0
                                            ? '${DesignConfiguration.getPriceFormat(context, double.parse(widget.favList[widget.index!].prVarientList![0].price!))}'
                                            : '',
                                        style: Theme.of(context)
                                            .textTheme
                                            .labelSmall!
                                            .copyWith(
                                              fontFamily: 'ubuntu',
                                              color: Colors.black,
                                              decoration:
                                                  TextDecoration.lineThrough,
                                              decorationColor: Colors.black,
                                              decorationStyle:
                                                  TextDecorationStyle.solid,
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
                          onTap: () async {
                            await addToCart(
                              (int.parse(context
                                          .read<FavoriteProvider>()
                                          .controllerText[widget.index!]
                                          .text) +
                                      int.parse(widget
                                          .favList[widget.index!].qtyStepSize!))
                                  .toString(),
                              2,
                              widget.favList,
                            );
                          },
                          child: Container(
                            height: 25,
                            width: MediaQuery.of(context).size.width,
                            decoration: const BoxDecoration(
                              color: colors.serviceColor,
                              borderRadius: BorderRadius.only(
                                  topRight: Radius.circular(20),
                                  bottomLeft: Radius.circular(20)),
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              getTranslated(context, 'ADD_CART')!,
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
                      Product model = widget.favList[widget.index!];
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
                  Align(
                    alignment: Alignment.topRight,
                    child: GestureDetector(
                      onTap: () {
                        if (CUR_USERID != null) {
                          Future.delayed(Duration.zero).then(
                            (value) => context
                                .read<UpdateFavProvider>()
                                .removeFav(
                                    widget.favList[widget.index!].id!,
                                    widget.favList[widget.index!]
                                        .prVarientList![0].id!,
                                    context),
                          );
                        } else {
                          db.addAndRemoveFav(
                              widget.favList[widget.index!].id!, false);
                          context.read<FavoriteProvider>().removeFavItem(widget
                              .favList[widget.index!].prVarientList![0].id!);

                          setSnackbar(
                              getTranslated(context, 'Removed from favorite')!,
                              context);
                        }
                      },
                      child: const Icon(
                        Icons.cancel,
                        color: colors.primary,
                      ),
                    ),
                  )
                ],
              ),
            );
          },
          selector: (_, provider) => provider.cartList);
    } else {
      return Container();
    }
  }
}
