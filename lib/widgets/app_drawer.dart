import 'package:eshop_multivendor/Helper/Color.dart';
import 'package:eshop_multivendor/Provider/homePageProvider.dart';
import 'package:eshop_multivendor/Screen/Language/languageSettings.dart';
import 'package:eshop_multivendor/Screen/MyOrder/MyOrder.dart';
import 'package:eshop_multivendor/ServiceApp/model/dashboard_model.dart';
import 'package:eshop_multivendor/ServiceApp/network/rest_apis.dart';
import 'package:eshop_multivendor/main.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:nb_utils/nb_utils.dart';
import '../../Helper/String.dart';

Widget drawerWidget(BuildContext context) {
  return Drawer();
}

class MyDrawer extends StatefulWidget {
  const MyDrawer({Key? key}) : super(key: key);

  @override
  State<MyDrawer> createState() => _MyDrawerState();
}

class _MyDrawerState extends State<MyDrawer> {
  Future<DashboardResponse>? future;
  bool profileVisibility = false;
  bool eCommerceVisibility = false;
  bool serviceVisibility = false;
  void init() async {
    future = userDashboard(
        isCurrentLocation: appStore.isCurrentLocation,
        lat: getDoubleAsync(LATITUDE),
        long: getDoubleAsync(LONGITUDE));
  }

  @override
  void initState() {
    init();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: colors.drawerColor,
      child: Padding(
        padding: const EdgeInsets.only(top: 20),
        child: SingleChildScrollView(
          child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 30,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        profileVisibility = !profileVisibility;
                      });
                    },
                    child: Row(
                      children: [
                        SizedBox(
                          height: 30,
                          width: 30,
                          child: Image.asset(
                            'assets/images/png/3.png',
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(
                          width: 15,
                        ),
                        Text(
                          getTranslated(context, 'PROFILE')!,
                          style: const TextStyle(
                              fontSize: 18,
                              color: Colors.white,
                              fontWeight: FontWeight.w600),
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        const Icon(
                          Icons.arrow_drop_down_outlined,
                          color: Colors.white,
                          size: 25,
                        )
                      ],
                    ),
                  ),
                ),
                Visibility(
                    visible: profileVisibility,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 20),
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        decoration: const BoxDecoration(
                            color: colors.drawerColorVisibility,
                            borderRadius: BorderRadius.only(
                                topRight: Radius.circular(30),
                                bottomLeft: Radius.circular(30))),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 30),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(
                                height: 20,
                              ),
                              GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              const MyOrder()));
                                },
                                child: Text(
                                  getTranslated(context, 'Order')!,
                                  style: const TextStyle(
                                      fontSize: 16, color: Colors.white),
                                ),
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              const MyOrder()));
                                },
                                child: Text(
                                  getTranslated(context, 'serviceBooking')!,
                                  style: const TextStyle(
                                      fontSize: 15, color: Colors.white),
                                ),
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              const MyOrder()));
                                },
                                child: Text(
                                  getTranslated(context, 'Return')!,
                                  style: const TextStyle(
                                      fontSize: 15, color: Colors.white),
                                ),
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              const MyOrder()));
                                },
                                child: Text(
                                  getTranslated(context, 'WishList')!,
                                  style: const TextStyle(
                                      fontSize: 15, color: Colors.white),
                                ),
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              const MyOrder()));
                                },
                                child: Text(
                                  getTranslated(context, 'addressBook')!,
                                  style: const TextStyle(
                                      fontSize: 15, color: Colors.white),
                                ),
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                            ],
                          ),
                        ),
                      ),
                    )),
                Padding(
                  padding: const EdgeInsets.only(left: 20, right: 20, top: 20),
                  child: GestureDetector(
                    onTap: () {},
                    child: Row(
                      children: [
                        const Icon(
                          Icons.notifications,
                          color: Colors.white,
                          size: 30,
                        ),
                        const SizedBox(
                          width: 15,
                        ),
                        Text(
                          getTranslated(context, 'NOTIFICATION')!,
                          style: const TextStyle(
                              fontSize: 18,
                              color: Colors.white,
                              fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 25),
                  color: Colors.white,
                  height: 1,
                ),
                const SizedBox(
                  height: 30,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        eCommerceVisibility = !eCommerceVisibility;
                      });
                    },
                    child: Row(
                      children: [
                        SizedBox(
                          height: 30,
                          width: 30,
                          child: Image.asset(
                            'assets/images/png/ecom_drawer.png',
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(
                          width: 15,
                        ),
                        Text(
                          getTranslated(context, 'Ecom')!,
                          style: const TextStyle(
                              fontSize: 18,
                              color: Colors.white,
                              fontWeight: FontWeight.w600),
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        const Icon(
                          Icons.arrow_drop_down_outlined,
                          color: Colors.white,
                          size: 25,
                        )
                      ],
                    ),
                  ),
                ),
                Visibility(
                    visible: eCommerceVisibility,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 20),
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        decoration: const BoxDecoration(
                          color: colors.drawerColorVisibility,
                          borderRadius: BorderRadius.only(
                            topRight: Radius.circular(30),
                            bottomLeft: Radius.circular(30),
                          ),
                        ),
                        child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 30),
                            child: Consumer<HomePageProvider>(
                                builder: (context, categoryData, child) {
                              return categoryData.catLoading
                                  ? SizedBox(
                                      width: double.infinity,
                                      child: Shimmer.fromColors(
                                        baseColor: Theme.of(context)
                                            .colorScheme
                                            .simmerBase,
                                        highlightColor: Theme.of(context)
                                            .colorScheme
                                            .simmerHigh,
                                        child: const SizedBox(),
                                      ),
                                    )
                                  : ListView.builder(
                                      physics:
                                          const NeverScrollableScrollPhysics(),
                                      shrinkWrap: true,
                                      itemCount: categoryData.catList.length,
                                      padding:
                                          const EdgeInsets.only(bottom: 20),
                                      itemBuilder: (context, index) {
                                        return Padding(
                                          padding:
                                              const EdgeInsets.only(top: 20),
                                          child: Text(
                                            categoryData.catList[index].name!,
                                            style: const TextStyle(
                                                fontSize: 16,
                                                color: Colors.white),
                                          ),
                                        );
                                      });
                            })),
                      ),
                    )),
                const SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        serviceVisibility = !serviceVisibility;
                      });
                    },
                    child: Row(
                      children: [
                        SizedBox(
                          height: 30,
                          width: 30,
                          child: Image.asset(
                            'assets/images/png/3.png',
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(
                          width: 15,
                        ),
                        Text(
                          getTranslated(context, 'service')!,
                          style: const TextStyle(
                              fontSize: 18,
                              color: Colors.white,
                              fontWeight: FontWeight.w600),
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        const Icon(
                          Icons.arrow_drop_down_outlined,
                          color: Colors.white,
                          size: 25,
                        )
                      ],
                    ),
                  ),
                ),
                Visibility(
                    visible: serviceVisibility,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 20),
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        decoration: const BoxDecoration(
                          color: colors.drawerColorVisibility,
                          borderRadius: BorderRadius.only(
                            topRight: Radius.circular(30),
                            bottomLeft: Radius.circular(30),
                          ),
                        ),
                        child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 30),
                            child: SnapHelperWidget<DashboardResponse>(
                                initialData: cachedDashboardResponse,
                                future: future,
                                onSuccess: (snap) {
                                  return ListView.builder(
                                      physics:
                                          const NeverScrollableScrollPhysics(),
                                      shrinkWrap: true,
                                      itemCount: snap.category!.length,
                                      padding:
                                          const EdgeInsets.only(bottom: 20),
                                      itemBuilder: (context, index) {
                                        return Padding(
                                          padding:
                                              const EdgeInsets.only(top: 20),
                                          child: Text(
                                            snap.category![index].name!,
                                            style: const TextStyle(
                                                fontSize: 16,
                                                color: Colors.white),
                                          ),
                                        );
                                      });
                                })),
                      ),
                    )),
                const SizedBox(
                  height: 30,
                ),
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 25),
                  color: Colors.white,
                  height: 1,
                ),
                const SizedBox(
                  height: 30,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: GestureDetector(
                    onTap: () {},
                    child: Row(
                      children: [
                        const Icon(
                          Icons.logout,
                          color: Colors.white,
                          size: 30,
                        ),
                        const SizedBox(
                          width: 15,
                        ),
                        Text(
                          getTranslated(context, 'sign_out')!,
                          style: const TextStyle(
                              fontSize: 18,
                              color: Colors.white,
                              fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: GestureDetector(
                    onTap: () {},
                    child: Row(
                      children: [
                        const Icon(
                          Icons.messenger_sharp,
                          color: Colors.white,
                          size: 30,
                        ),
                        const SizedBox(
                          width: 15,
                        ),
                        Text(
                          getTranslated(context, 'ABOUT_LBL')!,
                          style: const TextStyle(
                              fontSize: 18,
                              color: Colors.white,
                              fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: GestureDetector(
                    onTap: () {},
                    child: Row(
                      children: [
                        SizedBox(
                          height: 30,
                          width: 35,
                          child: Image.asset(
                            'assets/images/png/contact_us.png',
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(
                          width: 15,
                        ),
                        Text(
                          getTranslated(context, 'CONTACT_LBL')!,
                          style: const TextStyle(
                              fontSize: 18,
                              color: Colors.white,
                              fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: GestureDetector(
                    onTap: () {},
                    child: Row(
                      children: [
                        SizedBox(
                          height: 30,
                          width: 30,
                          child: Image.asset(
                            'assets/images/png/setting.png',
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(
                          width: 15,
                        ),
                        Text(
                          getTranslated(context, 'SETTING')!,
                          style: const TextStyle(
                              fontSize: 18,
                              color: Colors.white,
                              fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: GestureDetector(
                    onTap: () {},
                    child: Row(
                      children: [
                        SizedBox(
                          height: 30,
                          width: 30,
                          child: Image.asset(
                            'assets/images/png/lang.png',
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(
                          width: 15,
                        ),
                        Text(
                          getTranslated(context, 'Language')!,
                          style: const TextStyle(
                              fontSize: 18,
                              color: Colors.white,
                              fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                  ),
                ),
              ]),
        ),
      ),
    );
  }
}
