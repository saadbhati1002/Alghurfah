import 'dart:io';
import 'package:eshop_multivendor/Screen/homePage/widgets/slider_dashboard.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:eshop_multivendor/Helper/Color.dart';
import 'package:eshop_multivendor/Helper/String.dart';
import 'package:eshop_multivendor/Provider/CartProvider.dart';
import 'package:eshop_multivendor/Provider/Search/SearchProvider.dart';
import 'package:eshop_multivendor/Provider/SettingProvider.dart';
import 'package:eshop_multivendor/Provider/UserProvider.dart';
import 'package:eshop_multivendor/Provider/homePageProvider.dart';
import 'package:eshop_multivendor/Provider/systemProvider.dart';
import 'package:eshop_multivendor/Screen/Dashboard/Dashboard.dart';
import 'package:eshop_multivendor/Screen/homePage/widgets/homePageDialog.dart';
import 'package:eshop_multivendor/ServiceApp/screens/dashboard/dashboard_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:eshop_multivendor/Screen/Language/languageSettings.dart';
import 'package:eshop_multivendor/widgets/appBar.dart';
import 'package:eshop_multivendor/widgets/app_drawer.dart';
import 'package:version/version.dart';

class HomeScreenNew extends StatefulWidget {
  const HomeScreenNew({Key? key}) : super(key: key);

  @override
  State<HomeScreenNew> createState() => _HomeScreenNewState();
}

class _HomeScreenNewState extends State<HomeScreenNew> {
  final GlobalKey<ScaffoldState> _key = GlobalKey();

  @override
  void initState() {
    callApi();
    getSetting();
    super.initState();
  }

  callApi() async {
    context.read<HomePageProvider>().getSliderImages();
    context.read<HomePageProvider>().getCategories(context);
  }

  setStateNow() {
    setState(() {});
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
              // generateReferral();
            }

            context.read<HomePageProvider>().getFav(context, setStateNow);
            context.read<CartProvider>().getUserCart(save: '0');
            // _getOffFav();
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
          // setSnackbar(systemConfigData['message']!, context);
        }
      },
    ).onError(
      (error, stackTrace) {
        // setSnackbar(error.toString(), context);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        top: true,
        child: Scaffold(
          endDrawer: const MyDrawer(),
          key: _key,
          appBar: getAppBar(_key,
              title: getTranslated(context, 'HOME_LBL')!,
              context: context,
              setState: setStateNow,
              isHomePage: true),
          backgroundColor: colors.backgroundColor,
          body: SingleChildScrollView(
            child: Column(
              children: [
                const CustomSliderDashBoard(),
                SizedBox(
                    height: MediaQuery.of(context).size.height * .75,
                    width: MediaQuery.of(context).size.width * 1,
                    child: Stack(
                      children: [
                        SizedBox(
                          height: MediaQuery.of(context).size.height * .75,
                          width: MediaQuery.of(context).size.width * 1,
                          child: Image.asset(
                            'assets/images/png/newHome.png',
                            fit: BoxFit.fill,
                          ),
                        ),
                        Align(
                          alignment: Alignment.center,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    getTranslated(context, 'click here for')!,
                                    style: const TextStyle(
                                        color: Colors.black,
                                        fontSize: 12,
                                        fontWeight: FontWeight.w700),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  const Dashboard(
                                                    pageIndex: 0,
                                                  )));
                                    },
                                    child: Container(
                                        alignment: Alignment.center,
                                        width:
                                            MediaQuery.of(context).size.width *
                                                .33,
                                        decoration: const BoxDecoration(
                                            color: colors.eCommerceColor,
                                            borderRadius: BorderRadius.only(
                                                topRight: Radius.circular(20),
                                                bottomLeft:
                                                    Radius.circular(20))),
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 5, horizontal: 12),
                                          child: Text(
                                            getTranslated(context, 'Stores')!,
                                          ),
                                        )),
                                  ),
                                ],
                              ),
                              Padding(
                                padding: EdgeInsets.only(
                                    right: MediaQuery.of(context).size.width *
                                        .32),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      getTranslated(context, 'click here for')!,
                                      style: const TextStyle(
                                          color: Colors.black,
                                          fontSize: 12,
                                          fontWeight: FontWeight.w700),
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    const DashboardScreen()));
                                      },
                                      child: Container(
                                          alignment: Alignment.center,
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              .33,
                                          decoration: const BoxDecoration(
                                              color: colors.serviceColor,
                                              borderRadius: BorderRadius.only(
                                                  topRight: Radius.circular(20),
                                                  bottomLeft:
                                                      Radius.circular(20))),
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 5, horizontal: 12),
                                            child: Text(
                                              getTranslated(
                                                  context, 'service')!,
                                            ),
                                          )),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(
                                height: 60,
                              )
                            ],
                          ),
                        )
                      ],
                    )),
                // const CustomSlider(),
                SizedBox(
                  width: MediaQuery.of(context).size.width,
                  // height: MediaQuery.of(context).size.height,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 0),
                    child: Column(
                      children: [
                        Container(
                          width: MediaQuery.of(context).size.width,
                          color: colors.homeBackground,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 25, vertical: 25),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * .24,
                                  child: Column(
                                    children: [
                                      SizedBox(
                                          height: 60,
                                          child: Image.asset(
                                              'assets/images/png/uae.png',
                                              color: colors.primary)),
                                      const SizedBox(
                                        height: 7,
                                      ),
                                      Text(
                                        getTranslated(context,
                                            'high_quality_emirate_brand')!,
                                        textAlign: TextAlign.center,
                                        style: const TextStyle(
                                            fontSize: 13,
                                            fontWeight: FontWeight.w600,
                                            color: colors.primary),
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  color: colors.primary,
                                  width: 3,
                                  height: 100,
                                ),
                                SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * .24,
                                  child: Column(
                                    children: [
                                      SizedBox(
                                          height: 60,
                                          child: Image.asset(
                                              'assets/images/png/home_order.png',
                                              color: colors.primary)),
                                      const SizedBox(
                                        height: 7,
                                      ),
                                      Text(
                                        getTranslated(
                                            context, 'customized_order')!,
                                        textAlign: TextAlign.center,
                                        style: const TextStyle(
                                            fontSize: 13,
                                            fontWeight: FontWeight.w600,
                                            color: colors.primary),
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  color: colors.primary,
                                  width: 3,
                                  height: 100,
                                ),
                                SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * .24,
                                  child: Column(
                                    children: [
                                      SizedBox(
                                          height: 60,
                                          child: Image.asset(
                                            'assets/images/png/home_world.png',
                                            color: colors.primary,
                                          )),
                                      const SizedBox(
                                        height: 7,
                                      ),
                                      Text(
                                        getTranslated(
                                            context, 'fast_global_deliver')!,
                                        textAlign: TextAlign.center,
                                        style: const TextStyle(
                                            fontSize: 13,
                                            fontWeight: FontWeight.w600,
                                            color: colors.primary),
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}
