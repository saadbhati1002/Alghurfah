import 'package:eshop_multivendor/Helper/Color.dart';
import 'package:eshop_multivendor/Screen/Dashboard/Dashboard.dart';
import 'package:eshop_multivendor/ServiceApp/screens/dashboard/dashboard_screen.dart';
import 'package:eshop_multivendor/ServiceApp/utils/colors.dart';
import 'package:eshop_multivendor/home_screen_new.dart';
import 'package:eshop_multivendor/widgets/desing.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

Widget serviceAppBottomNavigation(BuildContext context) {
  return ClipRRect(
    borderRadius: const BorderRadius.only(topLeft: Radius.circular(45)),
    child: BottomNavigationBar(
      backgroundColor: colors.primary,
      selectedItemColor: Colors.white,
      unselectedItemColor: Colors.white,
      showUnselectedLabels: true,
      selectedFontSize: 0,
      unselectedFontSize: 0,
      currentIndex: 0,
      type: BottomNavigationBarType.fixed,
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
      onTap: (int index) {
        if (index == 0) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const HomeScreenNew(),
            ),
          );
        } else {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => DashboardScreen(pageIndex: index),
            ),
          );
        }
      },
    ),
  );
}
