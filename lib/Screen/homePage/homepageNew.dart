import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:eshop_multivendor/Helper/ApiBaseHelper.dart';
import 'package:eshop_multivendor/Helper/Color.dart';
import 'package:eshop_multivendor/Helper/Constant.dart';
import 'package:eshop_multivendor/Provider/CategoryProvider.dart';
import 'package:eshop_multivendor/Screen/Notification/NotificationLIst.dart';
import 'package:eshop_multivendor/Screen/ProductList&SectionView/ProductList.dart';
import 'package:eshop_multivendor/Screen/SQLiteData/SqliteData.dart';
import 'package:eshop_multivendor/Model/Section_Model.dart';
import 'package:eshop_multivendor/Provider/CartProvider.dart';
import 'package:eshop_multivendor/Provider/Search/SearchProvider.dart';
import 'package:eshop_multivendor/Provider/SettingProvider.dart';
import 'package:eshop_multivendor/Provider/Theme.dart';
import 'package:eshop_multivendor/Provider/UserProvider.dart';
import 'package:eshop_multivendor/Provider/systemProvider.dart';
import 'package:eshop_multivendor/Screen/SubCategory/SubCategory.dart';
import 'package:eshop_multivendor/Screen/homePage/widgets/MostLikeSection.dart';
import 'package:eshop_multivendor/Screen/homePage/widgets/hideAppBarBottom.dart';
import 'package:eshop_multivendor/Screen/homePage/widgets/homePageDialog.dart';
import 'package:eshop_multivendor/Screen/homePage/widgets/horizontalCategoryList.dart';
import 'package:eshop_multivendor/Screen/homePage/widgets/section.dart';
import 'package:eshop_multivendor/Screen/homePage/widgets/slider.dart';
import 'package:eshop_multivendor/ServiceApp/model/category_model.dart';
import 'package:eshop_multivendor/ServiceApp/model/dashboard_model.dart';
import 'package:eshop_multivendor/ServiceApp/screens/dashboard/component/category_component.dart';
import 'package:eshop_multivendor/ServiceApp/screens/dashboard/dashboard_screen.dart';
import 'package:eshop_multivendor/ServiceApp/screens/service/view_all_service_screen.dart';
import 'package:eshop_multivendor/ServiceApp/utils/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:http/http.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:eshop_multivendor/main.dart';

import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:version/version.dart';
import '../../Helper/String.dart';
import '../../Helper/routes.dart';
import '../../Provider/Favourite/FavoriteProvider.dart';
import '../../Provider/homePageProvider.dart';
import '../../widgets/desing.dart';
import '../Language/languageSettings.dart';
import '../../widgets/networkAvailablity.dart';
import '../../widgets/security.dart';
import '../../widgets/snackbar.dart';
import '../NoInterNetWidget/NoInterNet.dart';
import 'package:eshop_multivendor/ServiceApp/network/rest_apis.dart';
import 'package:eshop_multivendor/ServiceApp/utils/constant.dart' as service;

bool isSearch = false;

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with AutomaticKeepAliveClientMixin<HomePage>, TickerProviderStateMixin {
  late Animation buttonSqueezeanimation;
  late AnimationController buttonController;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();
  var db = DatabaseHelper();
  final ScrollController _scrollBottomBarController = ScrollController();
  DateTime? currentBackPressTime;
  ApiBaseHelper apiBaseHelper = ApiBaseHelper();
  int? showingCatgery;
  int count = 1;
  Future<DashboardResponse>? future;
  @override
  bool get wantKeepAlive => true;

  setStateNow() {
    setState(() {});
  }

  void init() async {
    future = userDashboard(
        isCurrentLocation: appStore.isCurrentLocation,
        lat: getDoubleAsync(LATITUDE),
        long: getDoubleAsync(LONGITUDE));
  }

  setSnackBarFunctionForCartMessage() {
    Future.delayed(const Duration(seconds: 6)).then(
      (value) {
        if (homePageSingleSellerMessage) {
          homePageSingleSellerMessage = false;
          showOverlay(
            getTranslated(context,
                'One of the product is out of stock, We are not able To Add In Cart')!,
            context,
          );
        }
      },
    );
  }

  @override
  void initState() {
    init();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      UserProvider user = Provider.of<UserProvider>(context, listen: false);

      SettingProvider setting =
          Provider.of<SettingProvider>(context, listen: false);
      user.setMobile(setting.mobile);
      user.setName(setting.userName);
      user.setEmail(setting.email);
      user.setProfilePic(setting.profileUrl);
      //setUserData();
      Future.delayed(Duration.zero).then(
        (value) {
          callApi();
        },
      );

      buttonController = AnimationController(
        duration: const Duration(milliseconds: 2000),
        vsync: this,
      );

      buttonSqueezeanimation = Tween(
        begin: deviceWidth! * 0.7,
        end: 50.0,
      ).animate(
        CurvedAnimation(
          parent: buttonController,
          curve: const Interval(
            0.0,
            0.150,
          ),
        ),
      );
      setSnackBarFunctionForCartMessage();
      Future.delayed(Duration.zero).then(
        (value) {
          hideAppbarAndBottomBarOnScroll(
            _scrollBottomBarController,
            context,
          );
        },
      );
    });
    setStatusBarColor(transparentColor, delayInMilliSeconds: 800);

    LiveStream().on(service.LIVESTREAM_UPDATE_DASHBOARD, (p0) {
      setState(() {});
    });
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _scrollBottomBarController.removeListener(() {});
    LiveStream().dispose(service.LIVESTREAM_UPDATE_DASHBOARD);
  }

  _getAppBar() {
    final appBar = AppBar(
      elevation: 0,
      centerTitle: false,
      automaticallyImplyLeading: false,
      backgroundColor: Theme.of(context).colorScheme.lightWhite,
      title: SizedBox(
        width: MediaQuery.of(context).size.width * .8,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsetsDirectional.only(
                  end: 10.0, bottom: 10.0, top: 25.0),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(circularBorderRadius10),
                  color: Theme.of(context).colorScheme.white,
                ),
                width: 40,
                height: 40,
                child: IconButton(
                  icon: SvgPicture.asset(
                    DesignConfiguration.setSvgPath('search'),
                    colorFilter: ColorFilter.mode(
                        Theme.of(context).colorScheme.black, BlendMode.srcIn),
                  ),
                  onPressed: () {
                    setState(() {
                      isSearch = !isSearch;
                    });
                  },
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 35),
              child: Image.asset(
                DesignConfiguration.setPngPath('sliderph'),
                height: 90,
                // width: MediaQuery.of(context).size.width * .3,
              ),
            ),
          ],
        ),
      ),
      actions: <Widget>[
        Padding(
          padding: const EdgeInsetsDirectional.only(
              end: 10.0, bottom: 10.0, top: 10.0),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(circularBorderRadius10),
              color: Theme.of(context).colorScheme.white,
            ),
            width: 40,
            height: 40,
            child: IconButton(
              icon: SvgPicture.asset(
                DesignConfiguration.setSvgPath('cart'),
                colorFilter:
                    const ColorFilter.mode(Colors.white, BlendMode.srcIn),
                height: 20,
              ),
              onPressed: () {
                Routes.navigateToCartScreen(context, false);
              },
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsetsDirectional.only(
            end: 10.0,
            bottom: 10.0,
            top: 10.0,
          ),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(circularBorderRadius10),
              color: Theme.of(context).colorScheme.white,
            ),
            width: 40,
            child: IconButton(
              icon: SvgPicture.asset(
                DesignConfiguration.setSvgPath('notification_black'),
                colorFilter: ColorFilter.mode(
                    Theme.of(context).colorScheme.black, BlendMode.srcIn),
              ),
              onPressed: () {
                CUR_USERID != null
                    ? Navigator.push(
                        context,
                        CupertinoPageRoute(
                          builder: (context) => const NotificationList(),
                        ),
                      ).then(
                        (value) {
                          if (value != null && value) {}
                        },
                      )
                    : Routes.navigateToLoginScreen(context);
              },
            ),
          ),
        ),
      ],
    );

    return PreferredSize(
      preferredSize: appBar.preferredSize,
      child: SlideTransition(
        position: context.watch<HomePageProvider>().animationAppBarBarOffset,
        child: SizedBox(
          height: context.watch<HomePageProvider>().getBars ? 100 : 0,
          child: appBar,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _getAppBar(),
      key: _scaffoldKey,
      body: WillPopScope(
        onWillPop: onWillPopScope,
        child: SafeArea(
          child: isNetworkAvail
              ? RefreshIndicator(
                  color: colors.primary,
                  key: _refreshIndicatorKey,
                  onRefresh: _refresh,
                  child: CustomScrollView(
                    physics: const BouncingScrollPhysics(),
                    controller: _scrollBottomBarController,
                    slivers: [
                      SliverToBoxAdapter(
                        child: Column(
                          children: [
                            isSearch
                                ? Padding(
                                    padding: const EdgeInsets.only(
                                        left: 10,
                                        right: 10,
                                        bottom: 15,
                                        top: 20),
                                    child: TextField(
                                      style: TextStyle(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .fontColor,
                                        fontWeight: FontWeight.normal,
                                      ),
                                      enabled: false,
                                      textAlign: TextAlign.left,
                                      decoration: InputDecoration(
                                        focusedBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .lightWhite,
                                          ),
                                          borderRadius: const BorderRadius.all(
                                            Radius.circular(
                                                circularBorderRadius10),
                                          ),
                                        ),
                                        enabledBorder: const OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Colors.transparent),
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(
                                                circularBorderRadius10),
                                          ),
                                        ),
                                        contentPadding:
                                            const EdgeInsets.fromLTRB(
                                                15.0, 5.0, 0, 5.0),
                                        border: const OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Colors.transparent),
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(
                                                circularBorderRadius10),
                                          ),
                                        ),
                                        isDense: true,
                                        hintText: getTranslated(
                                            context, 'searchHint'),
                                        hintStyle: Theme.of(context)
                                            .textTheme
                                            .bodyMedium!
                                            .copyWith(
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .fontColor,
                                              fontSize: textFontSize12,
                                              fontWeight: FontWeight.w400,
                                              fontStyle: FontStyle.normal,
                                            ),
                                        prefixIcon: Padding(
                                          padding: const EdgeInsets.all(15.0),
                                          child: SvgPicture.asset(
                                            DesignConfiguration.setSvgPath(
                                                'homepage_search'),
                                            height: 15,
                                            width: 15,
                                          ),
                                        ),
                                        suffixIcon:
                                            Selector<ThemeNotifier, ThemeMode>(
                                          selector: (_, themeProvider) =>
                                              themeProvider.getThemeMode(),
                                          builder: (context, data, child) {
                                            return Padding(
                                              padding:
                                                  const EdgeInsets.all(10.0),
                                              child: (data ==
                                                              ThemeMode
                                                                  .system &&
                                                          MediaQuery.of(context)
                                                                  .platformBrightness ==
                                                              Brightness
                                                                  .light) ||
                                                      data == ThemeMode.light
                                                  ? SvgPicture.asset(
                                                      DesignConfiguration
                                                          .setSvgPath(
                                                              'voice_search'),
                                                      height: 15,
                                                      width: 15,
                                                    )
                                                  : SvgPicture.asset(
                                                      DesignConfiguration
                                                          .setSvgPath(
                                                              'voice_search_white'),
                                                      height: 15,
                                                      width: 15,
                                                    ),
                                            );
                                          },
                                        ),
                                        fillColor:
                                            Theme.of(context).colorScheme.white,
                                        filled: true,
                                      ),
                                    ),
                                  )
                                : const SizedBox(),
                            const CustomSlider(),
                            const SizedBox(
                              height: 20,
                            ),
                            // Row(
                            //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            //   children: [
                            //     Consumer<HomePageProvider>(
                            //         builder: (context, categoryData, child) {
                            //       return categoryData.catLoading
                            //           ? SizedBox(
                            //               width: double.infinity,
                            //               child: Shimmer.fromColors(
                            //                 baseColor: Theme.of(context)
                            //                     .colorScheme
                            //                     .simmerBase,
                            //                 highlightColor: Theme.of(context)
                            //                     .colorScheme
                            //                     .simmerHigh,
                            //                 child: const SizedBox(),
                            //               ),
                            //             )
                            //           : Container(
                            //               height: 40,
                            //               width: MediaQuery.of(context)
                            //                       .size
                            //                       .width *
                            //                   .45,
                            //               decoration: BoxDecoration(
                            //                   borderRadius:
                            //                       BorderRadius.circular(10),
                            //                   color: showingCatgery == 0
                            //                       ? primaryColor
                            //                       : Colors.grey[200]),
                            //               alignment: Alignment.center,
                            //               child: Padding(
                            //                 padding: const EdgeInsets.symmetric(
                            //                     horizontal: 15, vertical: 3),
                            //                 child: DropdownButtonHideUnderline(
                            //                     child: DropdownButton<Product>(
                            //                   dropdownColor: Colors.black,
                            //                   icon: const Icon(
                            //                     Icons.keyboard_arrow_down_sharp,
                            //                     color: Colors.black,
                            //                   ),
                            //                   isExpanded: true,
                            //                   items: categoryData.catList
                            //                       .map((Product value) {
                            //                     return DropdownMenuItem<
                            //                         Product>(
                            //                       value: value,
                            //                       child: Text(
                            //                         value.name!,
                            //                       ),
                            //                     );
                            //                   }).toList(),
                            //                   style: const TextStyle(
                            //                     color: Colors.white,
                            //                     fontSize: 16,
                            //                     fontFamily: 'ntr',
                            //                     fontWeight: FontWeight.w500,
                            //                   ),
                            //                   hint: const Text(
                            //                     'E-Commerce',
                            //                     style: TextStyle(
                            //                       color: Colors.black,
                            //                       fontSize: 16,
                            //                       fontFamily: 'ntr',
                            //                       fontWeight: FontWeight.w500,
                            //                     ),
                            //                   ),
                            //                   onChanged: (value) async {
                            //                     if (value!.subList == null ||
                            //                         value.subList!.isEmpty) {
                            //                       await Navigator.push(
                            //                         context,
                            //                         CupertinoPageRoute(
                            //                           builder: (context) =>
                            //                               ProductList(
                            //                             name: value.name,
                            //                             id: value.id,
                            //                             tag: false,
                            //                             fromSeller: false,
                            //                           ),
                            //                         ),
                            //                       );
                            //                     } else {
                            //                       await Navigator.push(
                            //                         context,
                            //                         CupertinoPageRoute(
                            //                           builder: (context) =>
                            //                               SubCategory(
                            //                             title: value.name!,
                            //                             subList: value.subList,
                            //                           ),
                            //                         ),
                            //                       );
                            //                     }
                            //                   },
                            //                 )),
                            //               ),
                            //             );
                            //     }),
                            //     SnapHelperWidget<DashboardResponse>(
                            //       initialData: cachedDashboardResponse,
                            //       future: future,
                            //       onSuccess: (snap) {
                            //         return Container(
                            //           height: 40,
                            //           width: MediaQuery.of(context).size.width *
                            //               .45,
                            //           decoration: BoxDecoration(
                            //               borderRadius:
                            //                   BorderRadius.circular(10),
                            //               color: showingCatgery == 0
                            //                   ? primaryColor
                            //                   : Colors.grey[200]),
                            //           alignment: Alignment.center,
                            //           child: Padding(
                            //             padding: const EdgeInsets.symmetric(
                            //                 horizontal: 10, vertical: 3),
                            //             child: DropdownButtonHideUnderline(
                            //                 child: DropdownButton<CategoryData>(
                            //               dropdownColor: Colors.black,
                            //               icon: const Icon(
                            //                 Icons.keyboard_arrow_down_sharp,
                            //                 color: Colors.black,
                            //               ),
                            //               isExpanded: true,
                            //               items: snap.category!
                            //                   .map((CategoryData value) {
                            //                 return DropdownMenuItem<
                            //                     CategoryData>(
                            //                   value: value,
                            //                   child: Text(
                            //                     value.name!,
                            //                   ),
                            //                 );
                            //               }).toList(),
                            //               style: const TextStyle(
                            //                 color: Colors.white,
                            //                 fontSize: 16,
                            //                 fontFamily: 'ntr',
                            //                 fontWeight: FontWeight.w500,
                            //               ),
                            //               hint: const Text(
                            //                 'Service',
                            //                 style: TextStyle(
                            //                   color: Colors.black,
                            //                   fontSize: 16,
                            //                   fontFamily: 'ntr',
                            //                   fontWeight: FontWeight.w500,
                            //                 ),
                            //               ),
                            //               onChanged: (value) async {
                            //                 ViewAllServiceScreen(
                            //                         categoryId:
                            //                             value!.id.validate(),
                            //                         categoryName: value.name,
                            //                         isFromCategory: true)
                            //                     .launch(context);
                            //               },
                            //             )),
                            //           ),
                            //         );
                            //       },
                            //     ),
                            //   ],
                            // ),

                            const Section(),
                            // MostLikeSection(),
                          ],
                        ),
                      )
                    ],
                  ),
                )
              : NoInterNet(
                  buttonController: buttonController,
                  buttonSqueezeanimation: buttonSqueezeanimation,
                  setStateNoInternate: setStateNoInternate,
                ),
        ),
      ),
    );
  }

  Future<void> _refresh() {
    context.read<HomePageProvider>().catLoading = true;
    context.read<HomePageProvider>().secLoading = true;
    context.read<HomePageProvider>().sliderLoading = true;
    context.read<HomePageProvider>().mostLikeLoading = true;
    context.read<HomePageProvider>().offerLoading = true;
    context.read<HomePageProvider>().proIds.clear();
    context.read<HomePageProvider>().sliderList.clear();
    context.read<HomePageProvider>().offerImagesList.clear();
    context.read<CategoryProvider>().setCurSelected(0);
    context.read<HomePageProvider>().sectionList.clear();
    return callApi();
  }

  Future<void> callApi() async {
    UserProvider user = Provider.of<UserProvider>(context, listen: false);
    SettingProvider setting =
        Provider.of<SettingProvider>(context, listen: false);

    user.setUserId(setting.userId);

    getSetting();
    context.read<HomePageProvider>().getSliderImages();
    context.read<HomePageProvider>().getCategories(context);
    context.read<HomePageProvider>().getOfferImages();
    context.read<HomePageProvider>().getSections();
    context.read<HomePageProvider>().getMostLikeProducts();
    context.read<HomePageProvider>().getMostFavouriteProducts();

    return;
  }

  void getSetting() {
    CUR_USERID = context.read<SettingProvider>().userId;
    context.read<SystemProvider>().getSystemSettings(userID: CUR_USERID).then(
      (systemConfigData) async {
        if (!systemConfigData['error']) {
          //
          //Tag list from system API
          if (systemConfigData['tagList'] != null) {
            context.read<SearchProvider>().tagList =
                systemConfigData['tagList'];
          }
          //check whether app is under maintenance
          if (systemConfigData['isAppUnderMaintenance'] == '1') {
            HomePageDialog.showUnderMaintenanceDialog(context);
          }

          if (CUR_USERID != null) {
            context
                .read<UserProvider>()
                .setCartCount(systemConfigData['cartCount']);
            context
                .read<UserProvider>()
                .setBalance(systemConfigData['userBalance']);
            context
                .read<UserProvider>()
                .setPincode(systemConfigData['pinCode']);

            if (systemConfigData['referCode'] == null ||
                systemConfigData['referCode'] == '' ||
                systemConfigData['referCode']!.isEmpty) {
              generateReferral();
            }

            context.read<HomePageProvider>().getFav(context, setStateNow);
            context.read<CartProvider>().getUserCart(save: '0');
            _getOffFav();
            context.read<CartProvider>().getUserOfflineCart();
          }
          if (systemConfigData['isVersionSystemOn'] == '1') {
            String? androidVersion = systemConfigData['androidVersion'];
            String? iOSVersion = systemConfigData['iOSVersion'];

            PackageInfo packageInfo = await PackageInfo.fromPlatform();

            String version = packageInfo.version;

            final Version currentVersion = Version.parse(version);
            final Version latestVersionAnd = Version.parse(androidVersion!);
            final Version latestVersionIos = Version.parse(iOSVersion!);

            if ((Platform.isAndroid && latestVersionAnd > currentVersion) ||
                (Platform.isIOS && latestVersionIos > currentVersion)) {
              HomePageDialog.showAppUpdateDialog(context);
            }
          }
          setState(() {});
        } else {
          setSnackbar(systemConfigData['message']!, context);
        }
      },
    ).onError(
      (error, stackTrace) {
        setSnackbar(error.toString(), context);
      },
    );
  }

/*  Future<void>? getDialogForClearCart() {
    HomePageDialog.clearYouCartDialog(context);
    return null;
  }*/

  Future<void> _getOffFav() async {
    if (CUR_USERID == null || CUR_USERID == '') {
      List<String>? proIds = (await db.getFav())!;
      if (proIds.isNotEmpty) {
        try {
          var parameter = {'product_ids': proIds.join(',')};

          Response response =
              await post(getProductApi, body: parameter, headers: headers)
                  .timeout(const Duration(seconds: timeOut));

          var getdata = json.decode(response.body);
          bool error = getdata['error'];
          if (!error) {
            var data = getdata['data'];

            List<Product> tempList =
                (data as List).map((data) => Product.fromJson(data)).toList();

            context.read<FavoriteProvider>().setFavlist(tempList);
          }
          if (mounted) {
            setState(() {
              context.read<FavoriteProvider>().setLoading(false);
            });
          }
        } on TimeoutException catch (_) {
          setSnackbar(getTranslated(context, 'somethingMSg')!, context);
          context.read<FavoriteProvider>().setLoading(false);
        }
      } else {
        context.read<FavoriteProvider>().setFavlist([]);
        setState(() {
          context.read<FavoriteProvider>().setLoading(false);
        });
      }
    }
  }

  final _chars =
      'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
  final Random _rnd = Random();

  String getRandomString(int length) => String.fromCharCodes(Iterable.generate(
      length, (_) => _chars.codeUnitAt(_rnd.nextInt(_chars.length))));

  Future<void> generateReferral() async {
    String refer = getRandomString(8);

    Map parameter = {
      REFERCODE: refer,
    };

    apiBaseHelper.postAPICall(validateReferalApi, parameter).then(
      (getdata) {
        bool error = getdata['error'];
        if (!error) {
          REFER_CODE = refer;

          Map parameter = {
            USER_ID: CUR_USERID,
            REFERCODE: refer,
          };

          apiBaseHelper.postAPICall(getUpdateUserApi, parameter);
        } else {
          if (count < 5) generateReferral();
          count++;
        }

        context.read<HomePageProvider>().secLoading = false;
      },
      onError: (error) {
        setSnackbar(error.toString(), context);
        context.read<HomePageProvider>().secLoading = false;
      },
    );
  }

  Widget homeShimmer() {
    return SizedBox(
      width: double.infinity,
      child: Shimmer.fromColors(
        baseColor: Theme.of(context).colorScheme.simmerBase,
        highlightColor: Theme.of(context).colorScheme.simmerHigh,
        child: SingleChildScrollView(
            child: Column(
          children: [
            HorizontalCategoryList.catLoading(context),
            sliderLoading(),
            Section.sectionLoadingShimmer(context),
          ],
        )),
      ),
    );
  }

  Widget sliderLoading() {
    double width = deviceWidth!;
    double height = width / 2;
    return Shimmer.fromColors(
      baseColor: Theme.of(context).colorScheme.simmerBase,
      highlightColor: Theme.of(context).colorScheme.simmerHigh,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 10),
        width: double.infinity,
        height: height,
        color: Theme.of(context).colorScheme.white,
      ),
    );
  }

  setStateNoInternate() async {
    context.read<HomePageProvider>().catLoading = true;
    context.read<HomePageProvider>().secLoading = true;
    context.read<HomePageProvider>().offerLoading = true;
    context.read<HomePageProvider>().mostLikeLoading = true;
    context.read<HomePageProvider>().sliderLoading = true;
    _playAnimation();

    Future.delayed(const Duration(seconds: 2)).then(
      (_) async {
        if (mounted) {
          setState(
            () {
              isNetworkAvail = true;
            },
          );
        }
        callApi();
      },
    );
  }

  Future<void> _playAnimation() async {
    try {
      await buttonController.forward();
    } on TickerCanceled {}
  }

  Future<bool> onWillPopScope() {
    DateTime now = DateTime.now();

    if (currentBackPressTime == null ||
        now.difference(currentBackPressTime!) > const Duration(seconds: 2)) {
      currentBackPressTime = now;
      setSnackbar(getTranslated(context, 'Press back again to Exit')!, context);
      return Future.value(false);
    }
    return Future.value(true);
  }
}

class SearchBarHeaderDelegate extends SliverPersistentHeaderDelegate {
  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return Align(
      alignment: Alignment.topCenter,
      child: Container(
        height: 0,
        color: Theme.of(context).colorScheme.lightWhite,
        padding: EdgeInsets.fromLTRB(
          10,
          isSearch
              ? context.watch<HomePageProvider>().getBars
                  ? 10
                  : 30
              : 0,
          10,
          0,
        ),
        child: isSearch
            ? GestureDetector(
                child: SizedBox(
                  height: 50,
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 0.0),
                    child: TextField(
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.fontColor,
                        fontWeight: FontWeight.normal,
                      ),
                      enabled: false,
                      textAlign: TextAlign.left,
                      decoration: InputDecoration(
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Theme.of(context).colorScheme.lightWhite,
                          ),
                          borderRadius: const BorderRadius.all(
                            Radius.circular(circularBorderRadius10),
                          ),
                        ),
                        enabledBorder: const OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.transparent),
                          borderRadius: BorderRadius.all(
                            Radius.circular(circularBorderRadius10),
                          ),
                        ),
                        contentPadding:
                            const EdgeInsets.fromLTRB(15.0, 5.0, 0, 5.0),
                        border: const OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.transparent),
                          borderRadius: BorderRadius.all(
                            Radius.circular(circularBorderRadius10),
                          ),
                        ),
                        isDense: true,
                        hintText: getTranslated(context, 'searchHint'),
                        hintStyle: Theme.of(context)
                            .textTheme
                            .bodyMedium!
                            .copyWith(
                              color: Theme.of(context).colorScheme.fontColor,
                              fontSize: textFontSize12,
                              fontWeight: FontWeight.w400,
                              fontStyle: FontStyle.normal,
                            ),
                        prefixIcon: Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: SvgPicture.asset(
                            DesignConfiguration.setSvgPath('homepage_search'),
                            height: 15,
                            width: 15,
                          ),
                        ),
                        suffixIcon: Selector<ThemeNotifier, ThemeMode>(
                          selector: (_, themeProvider) =>
                              themeProvider.getThemeMode(),
                          builder: (context, data, child) {
                            return Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: (data == ThemeMode.system &&
                                          MediaQuery.of(context)
                                                  .platformBrightness ==
                                              Brightness.light) ||
                                      data == ThemeMode.light
                                  ? SvgPicture.asset(
                                      DesignConfiguration.setSvgPath(
                                          'voice_search'),
                                      height: 15,
                                      width: 15,
                                    )
                                  : SvgPicture.asset(
                                      DesignConfiguration.setSvgPath(
                                          'voice_search_white'),
                                      height: 15,
                                      width: 15,
                                    ),
                            );
                          },
                        ),
                        fillColor: Theme.of(context).colorScheme.white,
                        filled: true,
                      ),
                    ),
                  ),
                ),
                onTap: () async {
                  Routes.navigateToSearchScreen(context);
                },
              )
            : const SizedBox(),
      ),
    );
  }

  @override
  double get maxExtent => 75;

  @override
  double get minExtent => 75;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
    return true;
  }
}
