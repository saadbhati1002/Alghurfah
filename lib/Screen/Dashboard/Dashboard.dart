import 'dart:async';
import 'dart:convert';
import 'package:eshop_multivendor/Provider/homePageProvider.dart';
import 'package:eshop_multivendor/Screen/Product%20Detail/productDetail.dart';
import 'package:eshop_multivendor/Helper/Color.dart';
import 'package:eshop_multivendor/Helper/Constant.dart';
import 'package:eshop_multivendor/Model/Section_Model.dart';
import 'package:eshop_multivendor/Provider/Theme.dart';
import 'package:eshop_multivendor/Screen/Profile/MyProfile.dart';
import 'package:eshop_multivendor/Screen/ExploreSection/explore.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:http/http.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import '../../Helper/String.dart';
import '../../widgets/security.dart';
import '../../widgets/systemChromeSettings.dart';
import '../PushNotification/PushNotificationService.dart';
import '../SQLiteData/SqliteData.dart';
import '../../Helper/routes.dart';
import '../../widgets/desing.dart';
import '../Language/languageSettings.dart';
import '../../widgets/networkAvailablity.dart';
import '../../widgets/snackbar.dart';
import '../AllCategory/All_Category.dart';
import '../Cart/Cart.dart';
import '../Cart/Widget/clearTotalCart.dart';
import '../Notification/NotificationLIst.dart';
import '../homePage/homepageNew.dart';

class Dashboard extends StatefulWidget {
  final int? pageIndex;
  const Dashboard({Key? key, this.pageIndex}) : super(key: key);

  @override
  _DashboardPageState createState() => _DashboardPageState();
}

var db = DatabaseHelper();

class _DashboardPageState extends State<Dashboard> {
  int screenId = 0;
  int _currentIndex = 0;
  int locationIndex = 0;

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: true,
      child: Scaffold(
        backgroundColor: colors.backgroundColor,
        resizeToAvoidBottomInset: false,
        bottomNavigationBar: ClipRRect(
          borderRadius: const BorderRadius.only(topLeft: Radius.circular(45)),
          child: Theme(
            data: ThemeData(canvasColor: Colors.transparent),
            child: BottomNavigationBar(
              type: BottomNavigationBarType.fixed,
              currentIndex: _currentIndex,
              backgroundColor: colors.primary,
              selectedItemColor: colors.eCommerceColor,
              unselectedItemColor: Colors.white,
              unselectedFontSize: 0,
              selectedFontSize: 0,
              iconSize: 25,
              onTap: (index) {
                _currentIndex = index;
                locationIndex = 0;
                setState(() {});
              },
              items: const [
                BottomNavigationBarItem(
                  label: '',
                  icon: ImageIcon(AssetImage('assets/images/png/1.png')),
                  tooltip: '',
                ),
                BottomNavigationBarItem(
                  label: '',
                  tooltip: '',
                  icon: ImageIcon(AssetImage('assets/images/png/2.png')),
                ),
                BottomNavigationBarItem(
                    label: '',
                    tooltip: '',
                    icon: ImageIcon(AssetImage('assets/images/png/3.png'))),
                BottomNavigationBarItem(
                    label: '',
                    icon: ImageIcon(AssetImage('assets/images/png/4.png')),
                    tooltip: '')
              ],
            ),
          ),
        ),
        body: screens().elementAt(_currentIndex),
      ),
    );
  }

  List<Widget> screens() => [
        const AllCategory(),
        const AllCategory(),
        const AllCategory(),
        const AllCategory(),
      ];
}
