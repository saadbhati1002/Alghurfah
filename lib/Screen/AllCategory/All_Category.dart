import 'package:eshop_multivendor/Helper/Color.dart';
import 'package:eshop_multivendor/Provider/CategoryProvider.dart';
import 'package:eshop_multivendor/Provider/homePageProvider.dart';
import 'package:eshop_multivendor/Screen/ExploreSection/explore.dart';
import 'package:eshop_multivendor/Screen/Language/languageSettings.dart';
import 'package:eshop_multivendor/Screen/NoInterNetWidget/NoInterNet.dart';
import 'package:eshop_multivendor/Screen/SubCategory/SubCategory.dart';
import 'package:eshop_multivendor/Screen/homePage/widgets/slider.dart';
import 'package:eshop_multivendor/widgets/appBar.dart';
import 'package:eshop_multivendor/widgets/networkAvailablity.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../Helper/String.dart';
import '../ProductList&SectionView/ProductList.dart';
import 'package:eshop_multivendor/widgets/app_drawer.dart';

class AllCategory extends StatefulWidget {
  const AllCategory({Key? key}) : super(key: key);

  @override
  State<AllCategory> createState() => _AllCategoryState();
}

class _AllCategoryState extends State<AllCategory>
    with TickerProviderStateMixin {
  late AnimationController buttonController;
  late Animation buttonSqueezeanimation;
  final GlobalKey<ScaffoldState> _key = GlobalKey();

  @override
  void initState() {
    super.initState();
    buttonController = AnimationController(
        duration: const Duration(milliseconds: 2000), vsync: this);
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
          await buttonController.reverse();
          if (mounted) setState(() {});
        }
      },
    );
  }

  Future<void> _playAnimation() async {
    try {
      await buttonController.forward();
    } on TickerCanceled {}
  }

  @override
  void dispose() {
    buttonController.dispose();
    super.dispose();
  }

  setStateNow() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: true,
      bottom: true,
      child: Scaffold(
          endDrawer: const MyDrawer(),
          key: _key,
          backgroundColor: colors.backgroundColor,
          appBar: getAppBar(_key,
              title: getTranslated(context, 'Stores')!,
              context: context,
              setState: setStateNow),
          body: Stack(children: [
            !isNetworkAvail
                ? NoInterNet(
                    buttonController: buttonController,
                    buttonSqueezeanimation: buttonSqueezeanimation,
                    setStateNoInternate: setStateNoInternate,
                  )
                : SingleChildScrollView(
                    child: Column(
                      children: [
                        const CustomSlider(),
                        Consumer<HomePageProvider>(
                          builder: (context, homePageProvider, _) {
                            if (homePageProvider.catLoading) {
                              return const Center(
                                child: CircularProgressIndicator(),
                              );
                            }
                            return ListView.builder(
                                shrinkWrap: true,
                                scrollDirection: Axis.vertical,
                                padding:
                                    const EdgeInsetsDirectional.only(top: 10.0),
                                itemCount: context
                                    .read<HomePageProvider>()
                                    .catList
                                    .length,
                                itemBuilder: (context, index) {
                                  return Padding(
                                    padding: const EdgeInsets.only(
                                        top: 5, left: 25, right: 25),
                                    child: GestureDetector(
                                      onTap: () async {
                                        await Navigator.push(
                                          context,
                                          CupertinoPageRoute(
                                            builder: (context) => Explore(
                                              title: context
                                                  .read<HomePageProvider>()
                                                  .catList[index]
                                                  .name!,
                                              subList: context
                                                  .read<HomePageProvider>()
                                                  .catList[index]
                                                  .subList,
                                              categoryID: context
                                                  .read<HomePageProvider>()
                                                  .catList[index]
                                                  .id
                                                  .toString(),
                                            ),
                                          ),
                                        );
                                        // if (context
                                        //             .read<HomePageProvider>()
                                        //             .catList[index]
                                        //             .subList ==
                                        //         null ||
                                        //     context
                                        //         .read<HomePageProvider>()
                                        //         .catList[index]
                                        //         .subList!
                                        //         .isEmpty) {
                                        //   await Navigator.push(
                                        //     context,
                                        //     CupertinoPageRoute(
                                        //       builder: (context) => ProductList(
                                        //         name: context
                                        //             .read<HomePageProvider>()
                                        //             .catList[index]
                                        //             .name,
                                        //         id: context
                                        //             .read<HomePageProvider>()
                                        //             .catList[index]
                                        //             .id,
                                        //         tag: false,
                                        //         fromSeller: false,
                                        //       ),
                                        //     ),
                                        //   );
                                        // } else {
                                        //   // await Navigator.push(
                                        //   //   context,
                                        //   //   CupertinoPageRoute(
                                        //   //     builder: (context) => SubCategory(
                                        //   //       title: context
                                        //   //           .read<HomePageProvider>()
                                        //   //           .catList[index]
                                        //   //           .name!,
                                        //   //       subList: context
                                        //   //           .read<HomePageProvider>()
                                        //   //           .catList[index]
                                        //   //           .subList,
                                        //   //     ),
                                        //   //   ),
                                        //   // );
                                        // }
                                      },
                                      child: SizedBox(
                                        height: 130,
                                        width:
                                            MediaQuery.of(context).size.width,
                                        child: Stack(
                                          children: [
                                            SizedBox(
                                              height: 130,
                                              width: MediaQuery.of(context)
                                                  .size
                                                  .width,
                                              child: ClipRRect(
                                                borderRadius:
                                                    const BorderRadius.only(
                                                        topRight:
                                                            Radius.circular(30),
                                                        bottomLeft:
                                                            Radius.circular(
                                                                30)),
                                                child: Image.asset(
                                                  'assets/images/png/ecom_cat.png',
                                                  fit: BoxFit.contain,
                                                ),
                                              ),
                                            ),
                                            Container(
                                              height: 130,
                                              width: MediaQuery.of(context)
                                                  .size
                                                  .width,
                                              decoration: const BoxDecoration(),
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(10.0),
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                      borderRadius:
                                                          const BorderRadius
                                                                  .only(
                                                              topRight: Radius
                                                                  .circular(30),
                                                              bottomLeft: Radius
                                                                  .circular(
                                                                      30)),
                                                      border: Border.all(
                                                          width: 2,
                                                          color: colors
                                                              .eCommerceColor)),
                                                  child: Container(
                                                    decoration: BoxDecoration(
                                                        borderRadius:
                                                            const BorderRadius
                                                                    .only(
                                                                topRight: Radius
                                                                    .circular(
                                                                        30),
                                                                bottomLeft: Radius
                                                                    .circular(
                                                                        30)),
                                                        border: Border.all(
                                                            width: 1,
                                                            color: colors
                                                                .eCommerceColor)),
                                                    margin:
                                                        const EdgeInsets.all(
                                                            3.0),
                                                    child: Row(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .center,
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: <Widget>[
                                                        // Padding(
                                                        //   padding: const EdgeInsets
                                                        //           .symmetric(
                                                        //       horizontal: 15),
                                                        //   child: Container(
                                                        //     height: 65,
                                                        //     width: 65,
                                                        //     decoration: BoxDecoration(
                                                        //         shape:
                                                        //             BoxShape.circle,
                                                        //         color: Colors.white,
                                                        //         image: DecorationImage(
                                                        //             image: NetworkImage(
                                                        //                 context
                                                        //                     .read<
                                                        //                         HomePageProvider>()
                                                        //                     .catList[
                                                        //                         index]
                                                        //                     .image!))),
                                                        //   ),
                                                        // ),
                                                        SizedBox(
                                                          width: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .width *
                                                              .52,
                                                          child: Text(
                                                            '${context.read<HomePageProvider>().catList[index].name!}',
                                                            textAlign: TextAlign
                                                                .center,
                                                            maxLines: 2,
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                            style: Theme.of(
                                                                    context)
                                                                .textTheme
                                                                .headlineSmall!
                                                                .copyWith(
                                                                    fontFamily:
                                                                        'ubuntu',
                                                                    color: colors
                                                                        .eCommerceColor,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w600),
                                                          ),
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  );
                                });
                          },
                        ),
                      ],
                    ),
                  ),
          ])),
    );
  }
}
