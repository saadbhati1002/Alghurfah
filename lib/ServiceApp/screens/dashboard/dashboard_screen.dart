import 'package:eshop_multivendor/ServiceApp/screens/category/category_screen.dart';
import 'package:eshop_multivendor/ServiceApp/screens/filter/filter_screen.dart';
import 'package:eshop_multivendor/ServiceApp/screens/notification/notification_screen.dart';
import 'package:eshop_multivendor/ServiceApp/screens/service/favourite_service_screen.dart';
import 'package:eshop_multivendor/ServiceApp/screens/service/search_list_screen.dart';
import 'package:flutter/material.dart';
import 'package:eshop_multivendor/Helper/Color.dart';

class DashboardScreen extends StatefulWidget {
  final bool? redirectToBooking;

  DashboardScreen({this.redirectToBooking});

  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
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
              selectedItemColor: colors.categoryNewIn,
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
                    label: '', tooltip: '', icon: Icon(Icons.notifications)),
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
        CategoryScreen(),
        SearchListScreen(),
        NotificationScreen(),
        const FavouriteServiceScreen(),
      ];
}
