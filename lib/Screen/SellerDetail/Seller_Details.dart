import 'dart:async';
import 'dart:math';
import 'package:eshop_multivendor/Helper/Color.dart';
import 'package:eshop_multivendor/Helper/Constant.dart';
import 'package:eshop_multivendor/Model/Section_Model.dart';
import 'package:eshop_multivendor/Model/favorite_seller_model.dart';
import 'package:eshop_multivendor/Provider/Theme.dart';
import 'package:eshop_multivendor/Provider/explore_provider.dart';
import 'package:eshop_multivendor/Screen/Auth/login.dart';
import 'package:eshop_multivendor/ServiceApp/component/loader_widget.dart';
import 'package:eshop_multivendor/repository/sellerDetailRepositry.dart';
import 'package:eshop_multivendor/widgets/app_drawer.dart';
import 'package:eshop_multivendor/widgets/background_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:nb_utils/nb_utils.dart' as visibility;
import 'package:provider/provider.dart';
import 'package:speech_to_text/speech_recognition_error.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';
import '../../Helper/String.dart';
import '../../Provider/productListProvider.dart';
import '../../Provider/sellerDetailProvider.dart';
import '../../widgets/ButtonDesing.dart';
import '../../widgets/appBar.dart';
import '../../widgets/desing.dart';
import '../Language/languageSettings.dart';
import '../../widgets/networkAvailablity.dart';
import '../../widgets/simmerEffect.dart';
import '../ExploreSection/Widgte/gridViewLayOut.dart';
import '../ExploreSection/Widgte/listViewLayOut.dart';
import '../NoInterNetWidget/NoInterNet.dart';
import 'Widget/listViewLayOut.dart';
import 'Widget/sellerProfileWidget.dart';
import 'package:eshop_multivendor/widgets/bottomNavigationSheet.dart';

class SellerProfile extends StatefulWidget {
  final String? sellerID,
      sellerName,
      sellerImage,
      sellerRating,
      totalProductsOfSeller,
      storeDesc,
      sellerStoreName,
      ratingType;
  final List<Product>? subList;
  const SellerProfile(
      {Key? key,
      this.sellerID,
      this.sellerName,
      this.sellerImage,
      this.sellerRating,
      required this.totalProductsOfSeller,
      this.storeDesc,
      this.sellerStoreName,
      this.ratingType,
      this.subList})
      : super(key: key);

  @override
  State<SellerProfile> createState() => _SellerProfileState();
}

List<String>? attributeNameList,
    attributeSubList,
    attributeIDList,
    selectedId = [];
RangeValues? currentRangeValues;
ScrollController? productsController;

class _SellerProfileState extends State<SellerProfile>
    with TickerProviderStateMixin {
  final TextEditingController _controller = TextEditingController();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  int pos = 0, total = 0;
  final bool _isProgress = false;
  bool isSaveToFavorite = false;
  bool isLoading = false;
  Animation? buttonSqueezeanimation;
  AnimationController? buttonController;
  String query = '';
  int notificationoffset = 0;

  bool notificationisloadmore = true,
      notificationisgettingdata = false,
      notificationisnodata = false;
  late AnimationController _animationController;
  Timer? _debounce;
  bool _hasSpeech = false;
  double level = 0.0;
  double minSoundLevel = 50000;
  double maxSoundLevel = -50000;
  String lastStatus = '';
  String _currentLocaleId = '';
  String lastWords = '';
  final SpeechToText speech = SpeechToText();
  late StateSetter setStater;
  ChoiceChip? tagChip;
  FocusNode searchFocusNode = FocusNode();
  int totalSellerCount = 0;
  late AnimationController listViewIconController;
  var filterList;
  String minPrice = '0', maxPrice = '0';

  bool initializingFilterDialogFirstTime = true;
  ChoiceChip? choiceChip;
  String selId = '';
  String sortBy = 'p.date_added', orderBy = 'DESC';

  setStateNow() {
    setState(() {});
  }

  setStateListViewLayOut(int index, bool selected, int i) {
    attributeIDList = filterList[index]['attribute_values_id'].split(',');

    if (mounted) {
      setState(() {
        if (selected == true) {
          selectedId!.add(attributeIDList![i]);
        } else {
          selectedId!.remove(attributeIDList![i]);
        }
      });
    }
    setState(() {});
  }

  @override
  void initState() {
    if (CUR_USERID != null) {
      checkSellerFollowing();
    }
    getSellerDetails();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<SellerDetailProvider>().setOffsetvalue(0);

      notificationoffset = 0;
      context.read<ExploreProvider>().productList.clear();
      productsController = ScrollController(keepScrollOffset: true);
      productsController!.addListener(_productsListScrollListener);
      listViewIconController = AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 200),
      );

      _controller.addListener(
        () {
          if (_controller.text.isEmpty) {
            if (mounted) {
              setState(
                () {
                  query = '';
                  notificationoffset = 0;
                },
              );
            }
            getProduct('0');
          } else {
            query = _controller.text;
            notificationoffset = 0;
            notificationisnodata = false;
            if (query.trim().isNotEmpty) {
              if (_debounce?.isActive ?? false) _debounce!.cancel();
              _debounce = Timer(
                const Duration(milliseconds: 500),
                () {
                  if (query.trim().isNotEmpty) {
                    notificationisloadmore = true;
                    notificationoffset = 0;
                    getProduct('0');
                  }
                },
              );
            }
          }
          ScaffoldMessenger.of(context).clearSnackBars();
        },
      );
      getProduct('0');
    });

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 250),
    );

    buttonController = AnimationController(
        duration: const Duration(milliseconds: 2000), vsync: this);

    buttonSqueezeanimation = Tween(
      begin: deviceWidth! * 0.7,
      end: 50.0,
    ).animate(
      CurvedAnimation(
        parent: buttonController!,
        curve: const Interval(
          0.0,
          0.150,
        ),
      ),
    );

    super.initState();
  }

  getSellerDetails() async {
    context.read<SellerDetailProvider>().getSeller(
          widget.sellerID!,
          '',
        );
  }

  checkSellerFollowing() async {
    try {
      Favorite response = await SellerDetailRepository.getFollowedSellers(
          parameter: {'user_id': CUR_USERID});

      var idChecker =
          response.data!.where((element) => element.userId == widget.sellerID);
      if (idChecker.isNotEmpty) {
        setState(() {
          isSaveToFavorite = true;
        });
      } else {}
    } catch (e) {
      debugPrint(e.toString());
    } finally {}
  }

  _productsListScrollListener() {
    if (productsController!.offset >=
            productsController!.position.maxScrollExtent &&
        !productsController!.position.outOfRange) {
      if (mounted) {
        setState(
          () {
            getProduct('0');
          },
        );
      }
    }
  }

  @override
  void dispose() {
    buttonController!.dispose();
    productsController!.dispose();
    _controller.dispose();
    listViewIconController.dispose();
    searchFocusNode.dispose();

    _animationController.dispose();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        ScaffoldMessenger.of(context).clearSnackBars();
      }
    });
    super.dispose();
  }

  Future<void> _playAnimation() async {
    try {
      await buttonController!.forward();
    } on TickerCanceled {}
  }

  setStateNoInternate() async {
    _playAnimation();
    Future.delayed(const Duration(seconds: 2)).then(
      (_) async {
        isNetworkAvail = await isNetworkAvailable();
        if (isNetworkAvail) {
          Navigator.pushReplacement(
            context,
            CupertinoPageRoute(builder: (BuildContext context) => super.widget),
          );
        } else {
          await buttonController!.reverse();
          if (mounted) {
            setState(
              () {},
            );
          }
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: allAppBottomSheet(context),
      endDrawer: const MyDrawer(),
      key: _scaffoldKey,
      backgroundColor: colors.backgroundColor,
      appBar: getAppBar(_scaffoldKey,
          title: widget.sellerStoreName,
          context: context,
          setState: setStateNow),
      body: isNetworkAvail
          ? Consumer<SellerDetailProvider>(
              builder: (context, value, child) {
                print(value.getCurrentStatus);
                if (value.getCurrentStatus ==
                    SellerDetailProviderStatus.isSuccsess) {
                  return Stack(
                    children: [
                      const BackgroundImage(),
                      SingleChildScrollView(
                        controller: productsController,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(
                              height: 30,
                            ),
                            Container(
                              alignment: Alignment.topLeft,
                              color: colors.categoryDiscretion,
                              width: MediaQuery.of(context).size.width * .69,
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 10),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const SizedBox(
                                      height: 15,
                                    ),
                                    Text(
                                      getTranslated(context, 'story')!,
                                      style: const TextStyle(
                                          fontSize: 14,
                                          color: colors.eCommerceColor,
                                          fontWeight: FontWeight.w700),
                                    ),
                                    const SizedBox(
                                      height: 5,
                                    ),
                                    Text(
                                      widget.storeDesc.toString(),
                                      textAlign: TextAlign.justify,
                                      style: const TextStyle(
                                          fontSize: 12,
                                          color: colors.eCommerceColor,
                                          fontWeight: FontWeight.w500),
                                    ),
                                    const SizedBox(
                                      height: 15,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 25),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      sortBy = 'p.date_added';
                                      orderBy = 'DESC';
                                      if (mounted) {
                                        setState(
                                          () {
                                            notificationoffset = 0;
                                            context
                                                .read<ExploreProvider>()
                                                .productList
                                                .clear();
                                          },
                                        );
                                      }
                                      getProduct('0');
                                      // Navigator.pop(context, 'option 1');
                                    },
                                    child: Container(
                                      alignment: Alignment.center,
                                      height:
                                          MediaQuery.of(context).size.height *
                                              .15,
                                      width: MediaQuery.of(context).size.width *
                                          .27,
                                      decoration: const BoxDecoration(
                                          color: colors.categoryNewIn,
                                          borderRadius: BorderRadius.only(
                                              topRight: Radius.circular(20),
                                              bottomLeft: Radius.circular(20))),
                                      child: SingleChildScrollView(
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            textWidget(getTranslated(
                                                context, 'new_in')!),
                                            textWidget(getTranslated(
                                                context, 'new_in')!),
                                            Text(
                                              getTranslated(context, 'new_in')!,
                                              style: const TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.white),
                                            ),
                                            textWidget(getTranslated(
                                                context, 'new_in')!),
                                            textWidget(getTranslated(
                                                context, 'new_in')!),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      sortBy = '';
                                      orderBy = 'DESC';
                                      if (mounted) {
                                        setState(() {
                                          notificationoffset = 0;
                                          context
                                              .read<ExploreProvider>()
                                              .productList
                                              .clear();
                                        });
                                      }
                                      getProduct('1');
                                    },
                                    child: Container(
                                      alignment: Alignment.center,
                                      height:
                                          MediaQuery.of(context).size.height *
                                              .15,
                                      width: MediaQuery.of(context).size.width *
                                          .27,
                                      decoration: const BoxDecoration(
                                        color: colors.serviceColor,
                                        borderRadius: BorderRadius.only(
                                          topRight: Radius.circular(20),
                                          bottomLeft: Radius.circular(20),
                                        ),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 10, vertical: 10),
                                        child: Container(
                                          alignment: Alignment.center,
                                          decoration: BoxDecoration(
                                            border: Border.all(
                                                width: 1, color: Colors.white),
                                            borderRadius:
                                                const BorderRadius.only(
                                              topRight: Radius.circular(20),
                                              bottomLeft: Radius.circular(20),
                                            ),
                                          ),
                                          child: Text(
                                            getTranslated(
                                                context, 'best_seller')!,
                                            textAlign: TextAlign.center,
                                            style: const TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.white),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      sortBy = 'pv.price';
                                      orderBy = 'ASC';
                                      if (mounted) {
                                        setState(
                                          () {
                                            notificationoffset = 0;
                                            context
                                                .read<ExploreProvider>()
                                                .productList
                                                .clear();
                                          },
                                        );
                                      }
                                      getProduct('0');
                                    },
                                    child: Container(
                                      alignment: Alignment.center,
                                      height:
                                          MediaQuery.of(context).size.height *
                                              .15,
                                      width: MediaQuery.of(context).size.width *
                                          .27,
                                      decoration: const BoxDecoration(
                                        color: colors.eCommerceColor,
                                        borderRadius: BorderRadius.only(
                                          topRight: Radius.circular(20),
                                          bottomLeft: Radius.circular(20),
                                        ),
                                      ),
                                      child: SingleChildScrollView(
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            textWidget(getTranslated(
                                                context, 'sale')!),
                                            textWidget(getTranslated(
                                                context, 'sale')!),
                                            Text(
                                              getTranslated(context, 'sale')!,
                                              style: const TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.white),
                                            ),
                                            textWidget(getTranslated(
                                                context, 'sale')!),
                                            textWidget(getTranslated(
                                                context, 'sale')!),
                                          ],
                                        ),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                            widget.subList == null
                                ? const SizedBox()
                                : SizedBox(
                                    child: GridView.builder(
                                        padding: const EdgeInsets.only(
                                            top: 20, left: 20, right: 10),
                                        itemCount: widget.subList!.length,
                                        physics:
                                            const NeverScrollableScrollPhysics(),
                                        shrinkWrap: true,
                                        gridDelegate:
                                            const SliverGridDelegateWithFixedCrossAxisCount(
                                          childAspectRatio: 3,
                                          crossAxisCount: 3,
                                          mainAxisSpacing: 10,
                                          crossAxisSpacing: 10,
                                        ),
                                        itemBuilder: (context, index) {
                                          return Container(
                                            alignment: Alignment.center,
                                            width: MediaQuery.of(context)
                                                .size
                                                .width,
                                            decoration: const BoxDecoration(
                                                color: Colors.white,
                                                borderRadius: BorderRadius.only(
                                                    topRight:
                                                        Radius.circular(15),
                                                    bottomLeft:
                                                        Radius.circular(15))),
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 5),
                                              child: Text(
                                                widget.subList![index].name!,
                                                textAlign: TextAlign.center,
                                                style: const TextStyle(
                                                    fontSize: 14,
                                                    color: Colors.black),
                                              ),
                                            ),
                                          );
                                        }),
                                  ),
                            Stack(
                              children: <Widget>[
                                _showContentOfProducts(),
                                Center(
                                  child:
                                      DesignConfiguration.showCircularProgress(
                                    _isProgress,
                                    colors.primary,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Align(
                        alignment: Alignment.topRight,
                        child: Padding(
                          padding: const EdgeInsets.only(top: 15, right: 15),
                          child: SizedBox(
                            height: 140,
                            width: 100,
                            child: Column(
                              children: [
                                SizedBox(
                                  height: 100,
                                  width: 100,
                                  child: ClipRRect(
                                    borderRadius: const BorderRadius.only(
                                        topRight: Radius.circular(25),
                                        bottomLeft: Radius.circular(25)),
                                    child: Container(
                                      color: Colors.white,
                                      child: DesignConfiguration
                                          .getCacheNotworkImage(
                                        boxFit: BoxFit.fill,
                                        context: context,
                                        heightvalue: null,
                                        widthvalue: null,
                                        placeHolderSize: 100,
                                        imageurlString: widget.sellerImage!,
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  height: 5,
                                ),
                                GestureDetector(
                                  onTap: () async {
                                    if (CUR_USERID != null) {
                                      if (isSaveToFavorite == false) {
                                        sellerAddToFavorite();
                                      } else {
                                        sellerRemoveToFavorite();
                                      }
                                    } else {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => const Login(),
                                        ),
                                      );
                                    }
                                  },
                                  child: Container(
                                    height: 25,
                                    width: MediaQuery.of(context).size.width,
                                    decoration: const BoxDecoration(
                                      color: colors.serviceColor,
                                      borderRadius: BorderRadius.only(
                                        topRight: Radius.circular(25),
                                        bottomLeft: Radius.circular(25),
                                      ),
                                    ),
                                    alignment: Alignment.center,
                                    child: Text(
                                      isSaveToFavorite == true
                                          ? getTranslated(context, 'Unfollow')!
                                          : getTranslated(context, 'Follow')!,
                                      maxLines: 1,
                                      style: const TextStyle(
                                          fontSize: 16,
                                          color: Colors.white,
                                          fontWeight: FontWeight.w600),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 10, right: 10),
                        child: Align(
                          alignment: Alignment.topRight,
                          child: Container(
                            height: 25,
                            width: 25,
                            decoration: BoxDecoration(
                                color: widget.ratingType == null
                                    ? const Color.fromRGBO(179, 127, 70, 1)
                                    : widget.ratingType == 'Silver'
                                        ? const Color.fromRGBO(192, 192, 192, 1)
                                        : widget.ratingType == 'Gold'
                                            ? Colors.yellow[700]
                                            : colors.eCommerceColor,
                                shape: BoxShape.circle),
                            child: Padding(
                              padding: const EdgeInsets.all(2),
                              child: Container(
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border:
                                      Border.all(width: 1, color: Colors.white),
                                ),
                                child: const Icon(
                                  Icons.star_border_outlined,
                                  color: Colors.white,
                                  size: 18,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      isLoading == true
                          ? SizedBox(
                              height: MediaQuery.of(context).size.width * .85,
                              width: MediaQuery.of(context).size.width * 1,
                              child: Center(
                                child: LoaderWidget().visible(isLoading),
                              ),
                            )
                          : const SizedBox()
                    ],
                  );
                } else if (value.getCurrentStatus ==
                    SellerDetailProviderStatus.isFailure) {
                  return Center(
                    child: Text(
                      value.geterrormessage,
                      style: const TextStyle(
                        fontFamily: 'ubuntu',
                      ),
                    ),
                  );
                }
                return const ShimmerEffect();
              },
            )
          : NoInterNet(
              setStateNoInternate: setStateNoInternate,
              buttonSqueezeanimation: buttonSqueezeanimation,
              buttonController: buttonController),
    );
  }

  sellerAddToFavorite() async {
    try {
      setState(() {
        isLoading = true;
      });
      var response = await SellerDetailRepository.addSellerToFavorite(
          parameter: {"seller_id": widget.sellerID, "user_id": CUR_USERID});
      if (response["error"] == false) {
        setState(() {
          isSaveToFavorite = true;
        });
      } else {
        setState(() {
          isSaveToFavorite = false;
        });
      }
    } catch (e) {
      debugPrint(e.toString());
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  sellerRemoveToFavorite() async {
    try {
      setState(() {
        isLoading = true;
      });
      var response = await SellerDetailRepository.removeSellerToFavorite(
          parameter: {"seller_id": widget.sellerID, "user_id": CUR_USERID});
      if (response["error"] == false) {
        setState(() {
          isSaveToFavorite = false;
        });
      } else {
        setState(() {
          isSaveToFavorite = true;
        });
      }
    } catch (e) {
      debugPrint(e.toString());
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Widget textWidget(String text) {
    return Text(
      text,
      style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: Colors.white.withOpacity(0.6)),
    );
  }

  void getAvailVarient(List<Product> tempList) {
    for (int j = 0; j < tempList.length; j++) {
      if (tempList[j].stockType == '2') {
        for (int i = 0; i < tempList[j].prVarientList!.length; i++) {
          if (tempList[j].prVarientList![i].availability == '1') {
            tempList[j].selVarient = i;

            break;
          }
        }
      }
    }
    if (notificationoffset == 0) {
      context.read<ExploreProvider>().productList = [];
    }
    context.read<ExploreProvider>().productList.addAll(tempList);
    notificationisloadmore = true;
    notificationoffset = notificationoffset + perPage;
  }

  Future getProduct(String? showTopRated) async {
    isNetworkAvail = await isNetworkAvailable();
    if (isNetworkAvail) {
      if (notificationisloadmore) {
        if (mounted) {
          setState(
            () {
              notificationisloadmore = false;
              notificationisgettingdata = true;
            },
          );
        }
        var parameter = {
          LIMIT: perPage.toString(),
          OFFSET: notificationoffset.toString(),
          SORT: sortBy,
          ORDER: orderBy,
          TOP_RETAED: showTopRated,
          SELLER_ID: widget.sellerID
        };

        if (selId != '') {
          parameter[ATTRIBUTE_VALUE_ID] = selId;
        }

        if (query.trim() != '') {
          parameter[SEARCH] = query.trim();
        }

        if (currentRangeValues != null &&
            currentRangeValues!.start.round().toString() != '0') {
          parameter[MINPRICE] = currentRangeValues!.start.round().toString();
        }

        if (currentRangeValues != null &&
            currentRangeValues!.end.round().toString() != '0') {
          parameter[MAXPRICE] = currentRangeValues!.end.round().toString();
        }

        if (CUR_USERID != null) parameter[USER_ID] = CUR_USERID!;
        context.read<ProductListProvider>().setProductListParameter(parameter);

        Future.delayed(Duration.zero).then(
          (value) => context.read<ProductListProvider>().getProductList().then(
            (
              value,
            ) async {
              bool error = value['error'];
              String? search = value['search'];
              context.read<ExploreProvider>().setProductTotal(value['total'] ??
                  context.read<ExploreProvider>().totalProducts);
              notificationisgettingdata = false;
              if (notificationoffset == 0) notificationisnodata = error;

              if (!error && search!.trim() == query.trim()) {
                if (mounted) {
                  if (initializingFilterDialogFirstTime) {
                    filterList = value['filters'];

                    minPrice = value[MINPRICE].toString();
                    maxPrice = value[MAXPRICE].toString();
                    currentRangeValues = RangeValues(
                        double.parse(minPrice), double.parse(maxPrice));
                    initializingFilterDialogFirstTime = false;
                  }

                  Future.delayed(
                    Duration.zero,
                    () => setState(
                      () {
                        List mainlist = value['data'];
                        if (mainlist.isNotEmpty) {
                          List<Product> items = [];
                          List<Product> allitems = [];

                          items.addAll(mainlist
                              .map((data) => Product.fromJson(data))
                              .toList());

                          allitems.addAll(items);

                          getAvailVarient(allitems);
                        } else {
                          notificationisloadmore = false;
                        }
                      },
                    ),
                  );
                }
              } else {
                notificationisloadmore = false;
                if (mounted) setState(() {});
              }
            },
          ),
        );
      }
    } else {
      if (mounted) {
        setState(
          () {
            isNetworkAvail = false;
          },
        );
      }
    }
  }

  clearAll() {
    setState(
      () {
        query = _controller.text;
        notificationoffset = 0;
        notificationisloadmore = true;
        context.read<ExploreProvider>().productList.clear();
      },
    );
  }

  _showContentOfProducts() {
    return Container(
      child: notificationisnodata
          ? DesignConfiguration.getNoItem(context)
          : Stack(
              children: [
                context.watch<ExploreProvider>().getCurrentView != 'GridView'
                    ? ListViewLayOut(
                        fromExplore: false,
                        update: setStateNow,
                      )
                    : getGridviewLayoutOfProducts(),
                notificationisgettingdata
                    ? const Center(
                        child: CircularProgressIndicator(),
                      )
                    : Container(),
              ],
            ),
    );
  }

  Future<void> initSpeechState() async {
    var hasSpeech = await speech.initialize(
        onError: errorListener,
        onStatus: statusListener,
        debugLogging: false,
        finalTimeout: const Duration(milliseconds: 0));
    if (hasSpeech) {
      var systemLocale = await speech.systemLocale();
      _currentLocaleId = systemLocale?.localeId ?? '';
    }

    if (!mounted) return;

    setState(() {
      _hasSpeech = hasSpeech;
    });
    if (hasSpeech) showSpeechDialog();
  }

  void errorListener(SpeechRecognitionError error) {}

  void statusListener(String status) {
    setStater(() {
      lastStatus = status;
    });
  }

  void startListening() {
    lastWords = '';
    speech.listen(
        onResult: resultListener,
        listenFor: const Duration(seconds: 30),
        pauseFor: const Duration(seconds: 5),
        partialResults: true,
        localeId: _currentLocaleId,
        onSoundLevelChange: soundLevelListener,
        cancelOnError: true,
        listenMode: ListenMode.confirmation);
    setStater(() {});
  }

  void soundLevelListener(double level) {
    minSoundLevel = min(minSoundLevel, level);
    maxSoundLevel = max(maxSoundLevel, level);

    setStater(() {
      this.level = level;
    });
  }

  void stopListening() {
    speech.stop();
    setStater(() {
      level = 0.0;
    });
  }

  void cancelListening() {
    speech.cancel();
    setStater(() {
      level = 0.0;
    });
  }

  void resultListener(SpeechRecognitionResult result) {
    setStater(() {
      lastWords = result.recognizedWords;
      query = lastWords;
    });

    if (result.finalResult) {
      Future.delayed(const Duration(seconds: 1)).then(
        (_) async {
          clearAll();

          _controller.text = lastWords;
          _controller.selection = TextSelection.fromPosition(
              TextPosition(offset: _controller.text.length));

          setState(() {});
          Navigator.of(context).pop();
        },
      );
    }
  }

  showSpeechDialog() {
    return DesignConfiguration.dialogAnimate(
      context,
      StatefulBuilder(
        builder: (BuildContext context, StateSetter setStater1) {
          setStater = setStater1;
          return AlertDialog(
            backgroundColor: Theme.of(context).colorScheme.lightWhite,
            title: Text(
              getTranslated(context, 'SEarchHint')!,
              style: TextStyle(
                color: Theme.of(context).colorScheme.fontColor,
                fontWeight: FontWeight.bold,
                fontSize: textFontSize16,
                fontFamily: 'ubuntu',
              ),
              textAlign: TextAlign.center,
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Container(
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                          blurRadius: .26,
                          spreadRadius: level * 1.5,
                          color: Theme.of(context)
                              .colorScheme
                              .black
                              .withOpacity(.05))
                    ],
                    color: Theme.of(context).colorScheme.white,
                    borderRadius: const BorderRadius.all(
                        Radius.circular(circularBorderRadius50)),
                  ),
                  child: IconButton(
                      icon: const Icon(
                        Icons.mic,
                        color: colors.primary,
                      ),
                      onPressed: () {
                        if (!_hasSpeech) {
                          initSpeechState();
                        } else {
                          !_hasSpeech || speech.isListening
                              ? null
                              : startListening();
                        }
                      }),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    lastWords,
                    style: const TextStyle(
                      fontFamily: 'ubuntu',
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  color:
                      Theme.of(context).colorScheme.fontColor.withOpacity(0.1),
                  child: Center(
                    child: speech.isListening
                        ? Text(
                            getTranslated(context, "I'm listening...")!,
                            style: Theme.of(context)
                                .textTheme
                                .titleSmall!
                                .copyWith(
                                  color:
                                      Theme.of(context).colorScheme.fontColor,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'ubuntu',
                                ),
                          )
                        : Text(
                            getTranslated(context, 'Not listening')!,
                            style: Theme.of(context)
                                .textTheme
                                .titleSmall!
                                .copyWith(
                                  color:
                                      Theme.of(context).colorScheme.fontColor,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'ubuntu',
                                ),
                          ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  void sortDialog() {
    showModalBottomSheet(
      backgroundColor: Theme.of(context).colorScheme.white,
      context: context,
      enableDrag: false,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(circularBorderRadius25),
          topRight: Radius.circular(circularBorderRadius25),
        ),
      ),
      builder: (builder) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Padding(
                      padding: const EdgeInsetsDirectional.only(
                          top: 19.0, bottom: 16.0),
                      child: Text(
                        getTranslated(context, 'SORT_BY')!,
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.fontColor,
                          fontSize: textFontSize18,
                          fontFamily: 'ubuntu',
                        ),
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      sortBy = '';
                      orderBy = 'DESC';
                      if (mounted) {
                        setState(() {
                          notificationoffset = 0;
                          context.read<ExploreProvider>().productList.clear();
                        });
                      }
                      getProduct('1');
                      Navigator.pop(context, 'option 1');
                    },
                    child: Container(
                      width: deviceWidth,
                      color: sortBy == ''
                          ? colors.primary
                          : Theme.of(context).colorScheme.white,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 15),
                      child: Text(
                        getTranslated(context, 'TOP_RATED')!,
                        style: TextStyle(
                          color: sortBy == ''
                              ? Theme.of(context).colorScheme.white
                              : Theme.of(context).colorScheme.fontColor,
                          fontFamily: 'ubuntu',
                          fontSize: textFontSize16,
                        ),
                      ),
                    ),
                  ),
                  InkWell(
                    child: Container(
                      width: deviceWidth,
                      color: sortBy == 'p.date_added' && orderBy == 'DESC'
                          ? colors.primary
                          : Theme.of(context).colorScheme.white,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 15),
                      child: Text(
                        getTranslated(context, 'F_NEWEST')!,
                        style: TextStyle(
                          color: sortBy == 'p.date_added' && orderBy == 'DESC'
                              ? Theme.of(context).colorScheme.white
                              : Theme.of(context).colorScheme.fontColor,
                          fontFamily: 'ubuntu',
                          fontSize: textFontSize16,
                        ),
                      ),
                    ),
                    onTap: () {
                      sortBy = 'p.date_added';
                      orderBy = 'DESC';
                      if (mounted) {
                        setState(
                          () {
                            notificationoffset = 0;
                            context.read<ExploreProvider>().productList.clear();
                          },
                        );
                      }
                      getProduct('0');
                      Navigator.pop(context, 'option 1');
                    },
                  ),
                  InkWell(
                    child: Container(
                      width: deviceWidth,
                      color: sortBy == 'p.date_added' && orderBy == 'ASC'
                          ? colors.primary
                          : Theme.of(context).colorScheme.white,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 15),
                      child: Text(
                        getTranslated(context, 'F_OLDEST')!,
                        style: TextStyle(
                          color: sortBy == 'p.date_added' && orderBy == 'ASC'
                              ? Theme.of(context).colorScheme.white
                              : Theme.of(context).colorScheme.fontColor,
                          fontFamily: 'ubuntu',
                          fontSize: textFontSize16,
                        ),
                      ),
                    ),
                    onTap: () {
                      sortBy = 'p.date_added';
                      orderBy = 'ASC';
                      if (mounted) {
                        setState(
                          () {
                            notificationoffset = 0;
                            context.read<ExploreProvider>().productList.clear();
                          },
                        );
                      }
                      getProduct('0');
                      Navigator.pop(context, 'option 2');
                    },
                  ),
                  InkWell(
                    child: Container(
                      width: deviceWidth,
                      color: sortBy == 'pv.price' && orderBy == 'ASC'
                          ? colors.primary
                          : Theme.of(context).colorScheme.white,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 15),
                      child: Text(
                        getTranslated(context, 'F_LOW')!,
                        style: TextStyle(
                          color: sortBy == 'pv.price' && orderBy == 'ASC'
                              ? Theme.of(context).colorScheme.white
                              : Theme.of(context).colorScheme.fontColor,
                          fontFamily: 'ubuntu',
                          fontSize: textFontSize16,
                        ),
                      ),
                    ),
                    onTap: () {
                      sortBy = 'pv.price';
                      orderBy = 'ASC';
                      if (mounted) {
                        setState(
                          () {
                            notificationoffset = 0;
                            context.read<ExploreProvider>().productList.clear();
                          },
                        );
                      }
                      getProduct('0');
                      Navigator.pop(context, 'option 3');
                    },
                  ),
                  InkWell(
                    child: Container(
                      width: deviceWidth,
                      color: sortBy == 'pv.price' && orderBy == 'DESC'
                          ? colors.primary
                          : Theme.of(context).colorScheme.white,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 15),
                      child: Text(
                        getTranslated(context, 'F_HIGH')!,
                        style: TextStyle(
                          color: sortBy == 'pv.price' && orderBy == 'DESC'
                              ? Theme.of(context).colorScheme.white
                              : Theme.of(context).colorScheme.fontColor,
                          fontFamily: 'ubuntu',
                          fontSize: textFontSize16,
                        ),
                      ),
                    ),
                    onTap: () {
                      sortBy = 'pv.price';
                      orderBy = 'DESC';
                      if (mounted) {
                        setState(
                          () {
                            notificationoffset = 0;
                            context.read<ExploreProvider>().productList.clear();
                          },
                        );
                      }
                      getProduct('0');
                      Navigator.pop(context, 'option 4');
                    },
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  sortAndFilterOption() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: Container(
        color: Theme.of(context).colorScheme.white,
        height: 45,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Expanded(
              flex: 7,
              child: Padding(
                padding: const EdgeInsetsDirectional.only(start: 20),
                child: GestureDetector(
                  onTap: sortDialog,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        getTranslated(context, 'SORT_BY')!,
                        style: const TextStyle(
                          color: colors.primary,
                          fontWeight: FontWeight.w500,
                          fontFamily: 'ubuntu',
                          fontStyle: FontStyle.normal,
                          fontSize: textFontSize12,
                        ),
                        textAlign: TextAlign.start,
                      ),
                      const Icon(
                        Icons.keyboard_arrow_down_sharp,
                        size: 16,
                      )
                    ],
                  ),
                ),
              ),
            ),
            const Spacer(),
            Padding(
              padding: const EdgeInsetsDirectional.only(end: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  InkWell(
                    child: AnimatedIcon(
                      textDirection: TextDirection.ltr,
                      icon: AnimatedIcons.list_view,
                      progress: listViewIconController,
                    ),
                    onTap: () {
                      if (context
                          .read<ExploreProvider>()
                          .productList
                          .isNotEmpty) {
                        if (context.read<ExploreProvider>().view ==
                            'ListView') {
                          context
                              .read<ExploreProvider>()
                              .changeViewTo('GridView');
                        } else {
                          context
                              .read<ExploreProvider>()
                              .changeViewTo('ListView');
                        }
                      }
                      context.read<ExploreProvider>().view == 'ListView'
                          ? listViewIconController.reverse()
                          : listViewIconController.forward();
                    },
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  const Text(
                    ' | ',
                    style: TextStyle(
                      fontFamily: 'ubuntu',
                    ),
                  ),
                  GestureDetector(
                    onTap: filterDialog,
                    child: Row(
                      children: [
                        const Icon(
                          Icons.filter_alt_outlined,
                        ),
                        Text(
                          getTranslated(context, 'FILTER')!,
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.fontColor,
                            fontFamily: 'ubuntu',
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void filterDialog() {
    showModalBottomSheet(
      context: context,
      enableDrag: false,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(circularBorderRadius10),
      ),
      builder: (builder) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsetsDirectional.only(top: 30.0),
                  child: AppBar(
                    title: Text(
                      getTranslated(context, 'FILTER')!,
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.fontColor,
                        fontFamily: 'ubuntu',
                      ),
                    ),
                    centerTitle: true,
                    elevation: 5,
                    backgroundColor: Theme.of(context).colorScheme.white,
                    leading: Builder(
                      builder: (BuildContext context) {
                        return Container(
                          margin: const EdgeInsets.all(10),
                          child: InkWell(
                            borderRadius:
                                BorderRadius.circular(circularBorderRadius4),
                            onTap: () => Navigator.of(context).pop(),
                            child: const Padding(
                              padding: EdgeInsetsDirectional.only(end: 4.0),
                              child: Icon(
                                Icons.arrow_back_ios_rounded,
                                color: colors.primary,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
                ListViewLayOutWidget(
                  filterList: filterList,
                  maxPrice: maxPrice,
                  minPrice: minPrice,
                  setStateNow: setStateNow,
                  setListViewOnTap: setStateListViewLayOut,
                ),
                Container(
                  color: Theme.of(context).colorScheme.white,
                  child: Row(
                    children: <Widget>[
                      Container(
                        margin: const EdgeInsetsDirectional.only(start: 20),
                        width: deviceWidth! * 0.4,
                        child: OutlinedButton(
                          onPressed: () {
                            if (mounted) {
                              setState(
                                () {
                                  selectedId!.clear();
                                },
                              );
                            }
                          },
                          child: Text(
                            getTranslated(context, 'DISCARD')!,
                            style: const TextStyle(
                              fontFamily: 'ubuntu',
                            ),
                          ),
                        ),
                      ),
                      const Spacer(),
                      SimBtn(
                        borderRadius: circularBorderRadius5,
                        size: 0.4,
                        title: getTranslated(context, 'APPLY'),
                        onBtnSelected: () {
                          if (selectedId != null) {
                            selId = selectedId!.join(',');
                          }
                          if (mounted) {
                            setState(
                              () {
                                notificationoffset = 0;
                                context
                                    .read<ExploreProvider>()
                                    .productList
                                    .clear();
                              },
                            );
                          }
                          getProduct('0');
                          Navigator.pop(context, 'Product Filter');
                        },
                      ),
                    ],
                  ),
                )
              ],
            );
          },
        );
      },
    );
  }

  getGridviewLayoutOfProducts() {
    return Padding(
      padding: const EdgeInsets.only(right: 10, left: 10, top: 5),
      child: GridView.count(
        padding: const EdgeInsetsDirectional.only(top: 5),
        crossAxisCount: 2,
        shrinkWrap: true,
        childAspectRatio: 0.55,
        mainAxisSpacing: 5,
        crossAxisSpacing: 5,
        physics: const NeverScrollableScrollPhysics(),
        children: List.generate(
          context.read<ExploreProvider>().productList.length,
          (index) {
            return GridViewLayOut(
              index: index,
              update: setStateNow,
            );
          },
        ),
      ),
    );
  }
}
