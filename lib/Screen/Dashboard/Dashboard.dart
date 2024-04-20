import 'package:eshop_multivendor/Helper/Color.dart';
import 'package:eshop_multivendor/Screen/Cart/Cart.dart';
import 'package:eshop_multivendor/Screen/ExploreSection/all_serach.dart';
import 'package:eshop_multivendor/Screen/Favourite/Favorite.dart';
import 'package:eshop_multivendor/common_screen/home_screen_new.dart';

import 'package:flutter/material.dart';
import '../SQLiteData/SqliteData.dart';
import '../AllCategory/All_Category.dart';

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
    if (widget.pageIndex != null) {
      setState(() {
        _currentIndex = widget.pageIndex!;
        locationIndex = widget.pageIndex!;
      });
    }
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
                if (index == 0) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const HomeScreenNew(),
                    ),
                  );
                } else {
                  _currentIndex = index;
                  locationIndex = 0;
                  setState(() {});
                }
              },
              items: const [
                BottomNavigationBarItem(
                  label: '',
                  icon: ImageIcon(
                    AssetImage('assets/images/png/1.png'),
                  ),
                  tooltip: '',
                ),
                BottomNavigationBarItem(
                  label: '',
                  tooltip: '',
                  icon: ImageIcon(
                    AssetImage('assets/images/png/2.png'),
                  ),
                ),
                BottomNavigationBarItem(
                    label: '',
                    icon: ImageIcon(
                      AssetImage('assets/images/png/4.png'),
                    ),
                    tooltip: ''),
                BottomNavigationBarItem(
                  label: '',
                  tooltip: '',
                  icon: Icon(Icons.favorite_outline_outlined),
                ),
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
        const AllSearchScreen(),
        const Cart(fromBottom: true),
        const Favorite(),
      ];
}
