import 'package:eshop_multivendor/Helper/Color.dart';
import 'package:eshop_multivendor/Screen/Language/languageSettings.dart';
import 'package:eshop_multivendor/Screen/favourite_sellers/favourite_sellers_screen.dart';
import 'package:eshop_multivendor/ServiceApp/screens/favourite_provider_screen.dart';
import 'package:eshop_multivendor/widgets/appBar.dart';
import 'package:eshop_multivendor/widgets/app_drawer.dart';
import 'package:flutter/material.dart';

class FavoriteSellerScreen extends StatefulWidget {
  const FavoriteSellerScreen({Key? key}) : super(key: key);

  @override
  State<FavoriteSellerScreen> createState() => _FavoriteSellerScreenState();
}

class _FavoriteSellerScreenState extends State<FavoriteSellerScreen> {
  final GlobalKey<ScaffoldState> _key = GlobalKey();
  setStateNow() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        endDrawer: const MyDrawer(),
        key: _key,
        backgroundColor: colors.backgroundColor,
        appBar: getAppBar(_key,
            title: getTranslated(context, 'Stores')!,
            context: context,
            setState: setStateNow),
        body: DefaultTabController(
            length: 2,
            child: Column(
              children: [
                TabBar(
                  labelColor: colors.primary,
                  unselectedLabelColor: Colors.white,
                  indicatorColor: colors.primary,
                  labelStyle: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.w600),
                  tabs: [
                    Tab(
                      text: getTranslated(context, 'Stores')!,
                    ),
                    Tab(
                      text: getTranslated(context, 'service')!,
                    ),
                  ],
                ),
                const Expanded(
                  child: TabBarView(
                    children: [
                      FavoriteSellersScreen(),
                      FavoriteProviderScreen(),
                    ],
                  ),
                ),
              ],
            )),
      ),
    );
  }
}
