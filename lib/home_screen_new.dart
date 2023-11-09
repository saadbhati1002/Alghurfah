import 'package:eshop_multivendor/Helper/Color.dart';
import 'package:eshop_multivendor/Provider/homePageProvider.dart';
import 'package:eshop_multivendor/Screen/Dashboard/Dashboard.dart';
import 'package:eshop_multivendor/Screen/homePage/widgets/slider.dart';
import 'package:eshop_multivendor/ServiceApp/screens/dashboard/dashboard_screen.dart';
import 'package:eshop_multivendor/widgets/background_image.dart';
import 'package:eshop_multivendor/widgets/bottomNavigationSheet.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:eshop_multivendor/Screen/Language/languageSettings.dart';
import 'package:eshop_multivendor/widgets/appBar.dart';
import 'package:eshop_multivendor/widgets/app_drawer.dart';

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
    super.initState();
  }

  callApi() async {
    context.read<HomePageProvider>().getSliderImages();
    context.read<HomePageProvider>().getCategories(context);
  }

  setStateNow() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        top: true,
        child: Scaffold(
          bottomNavigationBar: allAppBottomSheet(context),
          endDrawer: const MyDrawer(),
          key: _key,
          appBar: getAppBar(_key,
              title: getTranslated(context, 'HOME_LBL')!,
              context: context,
              setState: setStateNow),
          backgroundColor: colors.backgroundColor,
          body: Stack(
            children: [
              const BackgroundImage(),
              SingleChildScrollView(
                child: Column(
                  children: [
                    const CustomSlider(),
                    SizedBox(
                      width: MediaQuery.of(context).size.width,
                      // height: MediaQuery.of(context).size.height,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 25),
                        child: Column(
                          children: [
                            const SizedBox(
                              height: 25,
                            ),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                SizedBox(
                                  width: MediaQuery.of(context).size.width * .4,
                                  height:
                                      MediaQuery.of(context).size.height * .24,
                                  child: Stack(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            top: 10, right: 10),
                                        child: Container(
                                          decoration: const BoxDecoration(
                                              borderRadius: BorderRadius.only(
                                                  topRight: Radius.circular(20),
                                                  bottomLeft:
                                                      Radius.circular(20))),
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              .4,
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              .24,
                                          child: ClipRRect(
                                            borderRadius:
                                                const BorderRadius.only(
                                              topRight: Radius.circular(20),
                                              bottomLeft: Radius.circular(20),
                                            ),
                                            child: Image.asset(
                                              'assets/images/png/background.png',
                                              color: Colors.black,
                                              fit: BoxFit.fill,
                                            ),
                                          ),
                                        ),
                                      ),
                                      Align(
                                        alignment: Alignment.topRight,
                                        child: GestureDetector(
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
                                              decoration: const BoxDecoration(
                                                  color: colors.eCommerceColor,
                                                  borderRadius:
                                                      BorderRadius.only(
                                                          topRight:
                                                              Radius.circular(
                                                                  20),
                                                          bottomLeft:
                                                              Radius.circular(
                                                                  20))),
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        vertical: 3,
                                                        horizontal: 12),
                                                child: Text(
                                                  getTranslated(
                                                      context, 'explore_more')!,
                                                ),
                                              )),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                                const SizedBox(
                                  width: 20,
                                ),
                                SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * .41,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      const SizedBox(
                                        height: 15,
                                      ),
                                      Text(
                                        getTranslated(context, 'Ecom')!,
                                        style: const TextStyle(
                                            fontWeight: FontWeight.w500,
                                            fontSize: 18,
                                            color: colors.eCommerceColor),
                                      ),
                                      const SizedBox(
                                        height: 5,
                                      ),
                                      const Text(
                                        "It is a long established fact that a reader will be distracted by the readable content of a page when looking at its layout. The point of using Lorem Ipsum is that it has a more-or-less normal distribution of letters, as opposed to using 'Content here, content here', making it look like readable English.",
                                        maxLines: 9,
                                        textAlign: TextAlign.left,
                                        style: TextStyle(
                                            fontWeight: FontWeight.w400,
                                            fontSize: 12,
                                            color: colors.eCommerceColor),
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            ),
                            const SizedBox(
                              height: 25,
                            ),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * .41,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      const SizedBox(
                                        height: 15,
                                      ),
                                      Text(
                                        getTranslated(context, 'service')!,
                                        style: const TextStyle(
                                            fontWeight: FontWeight.w500,
                                            fontSize: 18,
                                            color: colors.eCommerceColor),
                                      ),
                                      const SizedBox(
                                        height: 5,
                                      ),
                                      const Text(
                                        "It is a long established fact that a reader will be distracted by the readable content of a page when looking at its layout. The point of using Lorem Ipsum is that it has a more-or-less normal distribution of letters, as opposed to using 'Content here, content here', making it look like readable English.",
                                        maxLines: 9,
                                        textAlign: TextAlign.left,
                                        style: TextStyle(
                                            fontWeight: FontWeight.w400,
                                            fontSize: 12,
                                            color: colors.eCommerceColor),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(
                                  width: 20,
                                ),
                                SizedBox(
                                  width: MediaQuery.of(context).size.width * .4,
                                  height:
                                      MediaQuery.of(context).size.height * .24,
                                  child: Stack(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            top: 10, left: 10),
                                        child: Container(
                                          decoration: const BoxDecoration(
                                              borderRadius: BorderRadius.only(
                                                  topLeft: Radius.circular(20),
                                                  bottomRight:
                                                      Radius.circular(20))),
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              .4,
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              .24,
                                          child: ClipRRect(
                                            borderRadius:
                                                const BorderRadius.only(
                                              topLeft: Radius.circular(20),
                                              bottomRight: Radius.circular(20),
                                            ),
                                            child: Image.asset(
                                              'assets/images/png/background.png',
                                              color: Colors.black,
                                              fit: BoxFit.fill,
                                            ),
                                          ),
                                        ),
                                      ),
                                      Align(
                                        alignment: Alignment.topLeft,
                                        child: GestureDetector(
                                          onTap: () {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        DashboardScreen()));
                                          },
                                          child: Container(
                                              decoration: const BoxDecoration(
                                                  color: colors.serviceColor,
                                                  borderRadius:
                                                      BorderRadius.only(
                                                          topLeft:
                                                              Radius.circular(
                                                                  20),
                                                          bottomRight:
                                                              Radius.circular(
                                                                  20))),
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        vertical: 3,
                                                        horizontal: 12),
                                                child: Text(
                                                  getTranslated(
                                                      context, 'explore_more')!,
                                                ),
                                              )),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 40,
                            ),
                            Row(
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
                                              'assets/images/png/home_brand.png',
                                              color: colors.primary)),
                                      const SizedBox(
                                        height: 7,
                                      ),
                                      Text(
                                        getTranslated(context,
                                            'high_quality_emirate_brand')!,
                                        textAlign: TextAlign.center,
                                        style: const TextStyle(
                                            fontSize: 12, color: Colors.black),
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
                                            fontSize: 12, color: Colors.black),
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
                                            fontSize: 12, color: Colors.black),
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            ),
                            const SizedBox(
                              height: 40,
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ));
  }
}
