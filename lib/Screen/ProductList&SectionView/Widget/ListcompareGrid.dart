import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../Helper/Color.dart';
import '../../../Helper/Constant.dart';
import '../../../Helper/String.dart';
import '../../../Model/Section_Model.dart';
import '../../../Provider/CartProvider.dart';
import '../../../Provider/Favourite/FavoriteProvider.dart';
import '../../../Provider/UserProvider.dart';
import '../../../widgets/desing.dart';
import '../../Language/languageSettings.dart';
import '../../../widgets/networkAvailablity.dart';
import '../../../widgets/snackbar.dart';
import '../../../widgets/star_rating.dart';
import '../../Dashboard/Dashboard.dart';
import '../../Product Detail/productDetail.dart';
import '../ProductList.dart';
import 'package:collection/src/iterable_extensions.dart';

class GridViewProductListWidget extends StatefulWidget {
  List<Product>? productList;
  final int? index;
  bool pad;

  Function setState;

  GridViewProductListWidget({
    Key? key,
    this.productList,
    this.index,
    required this.pad,
    required this.setState,
  }) : super(key: key);

  @override
  State<GridViewProductListWidget> createState() =>
      _GridViewProductListWidgetState();
}

class _GridViewProductListWidgetState extends State<GridViewProductListWidget> {
  _removeFav(int index, Product model) async {
    isNetworkAvail = await isNetworkAvailable();
    if (isNetworkAvail) {
      try {
        if (mounted) {
          index == -1
              ? model.isFavLoading = true
              : widget.productList![index].isFavLoading = true;
          widget.setState();
        }

        var parameter = {USER_ID: CUR_USERID, PRODUCT_ID: model.id};
        apiBaseHelper.postAPICall(removeFavApi, parameter).then((getdata) {
          bool error = getdata['error'];
          String? msg = getdata['message'];
          if (!error) {
            index == -1
                ? model.isFav = '0'
                : widget.productList![index].isFav = '0';
            context
                .read<FavoriteProvider>()
                .removeFavItem(model.prVarientList![0].id!);
            setSnackbar(msg!, context);
          } else {
            setSnackbar(msg!, context);
          }

          if (mounted) {
            index == -1
                ? model.isFavLoading = false
                : widget.productList![index].isFavLoading = false;
            widget.setState();
          }
        }, onError: (error) {
          setSnackbar(error.toString(), context);
        });
      } on TimeoutException catch (_) {
        setSnackbar(getTranslated(context, 'somethingMSg')!, context);
      }
    } else {
      if (mounted) {
        isNetworkAvail = false;
        widget.setState();
      }
    }
  }

  _setFav(int index, Product model) async {
    isNetworkAvail = await isNetworkAvailable();
    if (isNetworkAvail) {
      try {
        if (mounted) {
          index == -1
              ? model.isFavLoading = true
              : widget.productList![index].isFavLoading = true;
          widget.setState();
        }

        var parameter = {USER_ID: CUR_USERID, PRODUCT_ID: model.id};
        apiBaseHelper.postAPICall(setFavoriteApi, parameter).then((getdata) {
          bool error = getdata['error'];
          String? msg = getdata['message'];
          if (!error) {
            index == -1
                ? model.isFav = '1'
                : widget.productList![index].isFav = '1';

            context.read<FavoriteProvider>().addFavItem(model);
            setSnackbar(msg!, context);
          } else {
            setSnackbar(msg!, context);
          }

          if (mounted) {
            index == -1
                ? model.isFavLoading = false
                : widget.productList![index].isFavLoading = false;
            widget.setState();
          }
        }, onError: (error) {
          setSnackbar(error.toString(), context);
        });
      } on TimeoutException catch (_) {
        setSnackbar(getTranslated(context, 'somethingMSg')!, context);
      }
    } else {
      if (mounted) {
        isNetworkAvail = false;
        widget.setState();
      }
    }
  }

  removeFromCart(int index) async {
    isNetworkAvail = await isNetworkAvailable();
    if (isNetworkAvail) {
      if (CUR_USERID != null) {
        if (mounted) {
          isProgress = true;
          widget.setState();
        }

        int qty;

        qty = (int.parse(controllerText[index].text) -
            int.parse(widget.productList![index].qtyStepSize!));

        if (qty < widget.productList![index].minOrderQuntity!) {
          qty = 0;
        }

        var parameter = {
          PRODUCT_VARIENT_ID: widget.productList![index]
              .prVarientList![widget.productList![index].selVarient!].id,
          USER_ID: CUR_USERID,
          QTY: qty.toString()
        };

        apiBaseHelper.postAPICall(manageCartApi, parameter).then((getdata) {
          bool error = getdata['error'];
          String? msg = getdata['message'];
          if (!error) {
            var data = getdata['data'];

            String? qty = data['total_quantity'];

            context.read<UserProvider>().setCartCount(data['cart_count']);
            widget
                .productList![index]
                .prVarientList![widget.productList![index].selVarient!]
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
            isProgress = false;
            widget.setState();
          }
        }, onError: (error) {
          setSnackbar(error.toString(), context);
          isProgress = false;
        });
        widget.setState();
      } else {
        isProgress = true;
        widget.setState();

        int qty;

        qty = (int.parse(controllerText[index].text) -
            int.parse(widget.productList![index].qtyStepSize!));

        if (qty < widget.productList![index].minOrderQuntity!) {
          qty = 0;
          db.removeCart(
              widget.productList![index]
                  .prVarientList![widget.productList![index].selVarient!].id!,
              widget.productList![index].id!,
              context);
          context.read<CartProvider>().removeCartItem(widget.productList![index]
              .prVarientList![widget.productList![index].selVarient!].id!);
        } else {
          context.read<CartProvider>().updateCartItem(
              widget.productList![index].id!,
              qty.toString(),
              widget.productList![index].selVarient!,
              widget.productList![index]
                  .prVarientList![widget.productList![index].selVarient!].id!);
          db.updateCart(
            widget.productList![index].id!,
            widget.productList![index]
                .prVarientList![widget.productList![index].selVarient!].id!,
            qty.toString(),
          );
        }
        isProgress = false;
        widget.setState();
      }
    } else {
      if (mounted) {
        isNetworkAvail = false;
        widget.setState();
      }
    }
  }

  Future<void> addToCart(int index, String qty, int from) async {
    isNetworkAvail = await isNetworkAvailable();
    if (isNetworkAvail) {
      if (CUR_USERID != null) {
        if (mounted) {
          isProgress = true;
          widget.setState();
        }

        if (int.parse(qty) < widget.productList![index].minOrderQuntity!) {
          qty = widget.productList![index].minOrderQuntity.toString();

          setSnackbar("${getTranslated(context, 'MIN_MSG')}$qty", context);
        }

        var parameter = {
          USER_ID: CUR_USERID,
          PRODUCT_VARIENT_ID: widget.productList![index]
              .prVarientList![widget.productList![index].selVarient!].id,
          QTY: qty
        };

        apiBaseHelper.postAPICall(manageCartApi, parameter).then(
          (getdata) {
            bool error = getdata['error'];
            String? msg = getdata['message'];
            if (!error) {
              var data = getdata['data'];

              String? qty = data['total_quantity'];
              context.read<UserProvider>().setCartCount(data['cart_count']);
              widget
                  .productList![index]
                  .prVarientList![widget.productList![index].selVarient!]
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
              isProgress = false;
              widget.setState();
            }
          },
          onError: (error) {
            setSnackbar(error.toString(), context);
            if (mounted) {
              isProgress = false;
              widget.setState();
            }
          },
        );
      } else {
        isProgress = true;
        widget.setState();

        if (singleSellerOrderSystem) {
          if (CurrentSellerID == '' ||
              CurrentSellerID == widget.productList![index].seller_id) {
            CurrentSellerID = widget.productList![index].seller_id!;
            if (from == 1) {
              List<Product>? prList = [];
              prList.add(widget.productList![index]);
              context.read<CartProvider>().addCartItem(
                    SectionModel(
                      qty: qty,
                      productList: prList,
                      varientId: widget
                          .productList![index]
                          .prVarientList![
                              widget.productList![index].selVarient!]
                          .id!,
                      id: widget.productList![index].id,
                      sellerId: widget.productList![index].seller_id,
                    ),
                  );
              db.insertCart(
                widget.productList![index].id!,
                widget.productList![index]
                    .prVarientList![widget.productList![index].selVarient!].id!,
                qty,
                context,
              );
              setSnackbar(
                  "${getTranslated(context, 'MAXQTY')!} ${widget.productList![index].itemsCounter!.last}",
                  context);
            } else {
              if (int.parse(qty) >
                  int.parse(widget.productList![index].itemsCounter!.last)) {
                setSnackbar(
                    "${getTranslated(context, 'MAXQTY')!} ${widget.productList![index].itemsCounter!.last}",
                    context);
              } else {
                context.read<CartProvider>().updateCartItem(
                    widget.productList![index].id!,
                    qty,
                    widget.productList![index].selVarient!,
                    widget
                        .productList![index]
                        .prVarientList![widget.productList![index].selVarient!]
                        .id!);
                db.updateCart(
                  widget.productList![index].id!,
                  widget
                      .productList![index]
                      .prVarientList![widget.productList![index].selVarient!]
                      .id!,
                  qty,
                );
                setSnackbar(getTranslated(context, 'Cart Update Successfully')!,
                    context);
              }
            }
          } else {
            setSnackbar(
                getTranslated(context, 'only Single Seller Product Allow')!,
                context);
          }
        } else {
          if (from == 1) {
            List<Product>? prList = [];
            prList.add(widget.productList![index]);
            context.read<CartProvider>().addCartItem(
                  SectionModel(
                    qty: qty,
                    productList: prList,
                    varientId: widget
                        .productList![index]
                        .prVarientList![widget.productList![index].selVarient!]
                        .id!,
                    id: widget.productList![index].id,
                    sellerId: widget.productList![index].seller_id,
                  ),
                );
            db.insertCart(
              widget.productList![index].id!,
              widget.productList![index]
                  .prVarientList![widget.productList![index].selVarient!].id!,
              qty,
              context,
            );
            setSnackbar(
                "${getTranslated(context, 'MAXQTY')!} ${widget.productList![index].itemsCounter!.last}",
                context);
          } else {
            if (int.parse(qty) >
                int.parse(widget.productList![index].itemsCounter!.last)) {
              setSnackbar(
                  "${getTranslated(context, 'MAXQTY')!} ${widget.productList![index].itemsCounter!.last}",
                  context);
            } else {
              context.read<CartProvider>().updateCartItem(
                  widget.productList![index].id!,
                  qty,
                  widget.productList![index].selVarient!,
                  widget
                      .productList![index]
                      .prVarientList![widget.productList![index].selVarient!]
                      .id!);
              db.updateCart(
                widget.productList![index].id!,
                widget.productList![index]
                    .prVarientList![widget.productList![index].selVarient!].id!,
                qty,
              );
              setSnackbar(
                  getTranslated(context, 'Cart Update Successfully')!, context);
            }
          }
        }
        isProgress = false;
        widget.setState();
      }
    } else {
      if (mounted) {
        isNetworkAvail = false;
        widget.setState();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.index! < widget.productList!.length) {
      Product model = widget.productList![widget.index!];

      totalProduct = model.total;

      if (controllerText.length < widget.index! + 1) {
        controllerText.add(TextEditingController());
      }

      double price =
          double.parse(model.prVarientList![model.selVarient!].disPrice!);
      if (price == 0) {
        price = double.parse(model.prVarientList![model.selVarient!].price!);
      }

      double off = 0;
      if (model.prVarientList![model.selVarient!].disPrice! != '0') {
        off = (double.parse(model.prVarientList![model.selVarient!].price!) -
                double.parse(model.prVarientList![model.selVarient!].disPrice!))
            .toDouble();
        off = off *
            100 /
            double.parse(model.prVarientList![model.selVarient!].price!);
      }

      if (controllerText.length < widget.index! + 1) {
        controllerText.add(TextEditingController());
      }

      controllerText[widget.index!].text =
          model.prVarientList![model.selVarient!].cartCount!;

      List att = [], val = [];
      if (model.prVarientList![model.selVarient!].attr_name != null) {
        att = model.prVarientList![model.selVarient!].attr_name!.split(',');
        val = model.prVarientList![model.selVarient!].varient_value!.split(',');
      }
      double width = deviceWidth! * 0.5;

      return Selector<CartProvider, List<SectionModel>>(
          builder: (context, data, child) {
            SectionModel? tempId = data.firstWhereOrNull((cp) =>
                cp.id == model.id &&
                cp.varientId == model.prVarientList![model.selVarient!].id!);
            if (tempId != null) {
              controllerText[widget.index!].text = tempId.qty!.toString();
            } else {
              if (CUR_USERID != null) {
                controllerText[widget.index!].text =
                    model.prVarientList![model.selVarient!].cartCount!;
              } else {
                controllerText[widget.index!].text = '0';
              }
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
                              tag:
                                  '$heroTagUniqueString${widget.index}${model.id}',
                              child: DesignConfiguration.getCacheNotworkImage(
                                boxFit: BoxFit.contain,
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
                        widget.productList![widget.index!].name!,
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
                                    double.parse(widget
                                                .productList![widget.index!]
                                                .prVarientList![0]
                                                .disPrice!) !=
                                            0
                                        ? '${DesignConfiguration.getPriceFormat(context, double.parse(widget.productList![widget.index!].prVarientList![0].price!))}'
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
                      onTap: () {
                        addToCart(
                          widget.index!,
                          (1 +
                                  int.parse(
                                    model.qtyStepSize!,
                                  ))
                              .toString(),
                          1,
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
                  Product model = widget.productList![widget.index!];
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
          },
          selector: (_, provider) => provider.cartList);
    } else {
      return Container();
    }
  }
}
