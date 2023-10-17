import 'package:eshop_multivendor/Screen/Dashboard/Dashboard.dart';
import 'package:eshop_multivendor/ServiceApp/utils/colors.dart';
import 'package:eshop_multivendor/widgets/desing.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

Widget allAppBottomSheet(BuildContext context) {
  return BottomNavigationBar(
    selectedItemColor: Colors.grey,
    unselectedItemColor: Colors.grey,
    showUnselectedLabels: true,
    selectedFontSize: 12,
    unselectedFontSize: 12,
    currentIndex: 0,
    type: BottomNavigationBarType.fixed,
    items: [
      BottomNavigationBarItem(
        icon: Padding(
          padding: const EdgeInsets.only(bottom: 5),
          child: SvgPicture.asset(
            DesignConfiguration.setSvgPath('brands'),
            colorFilter: const ColorFilter.mode(Colors.grey, BlendMode.srcIn),
            height: 20,
          ),
        ),
        label: 'EXPLORE',
      ),
      BottomNavigationBarItem(
        icon: Padding(
          padding: const EdgeInsets.only(bottom: 5),
          child: SvgPicture.asset(
            DesignConfiguration.setSvgPath('category'),
            colorFilter: const ColorFilter.mode(Colors.grey, BlendMode.srcIn),
            height: 20,
          ),
        ),
        label: 'CATEGORY',
      ),
      BottomNavigationBarItem(
        icon: Padding(
          padding: const EdgeInsets.only(bottom: 5),
          child: SvgPicture.asset(
            DesignConfiguration.setSvgPath('home'),
            colorFilter: const ColorFilter.mode(Colors.grey, BlendMode.srcIn),
            height: 20,
          ),
        ),
        label: 'HOME',
      ),
      BottomNavigationBarItem(
        icon: Padding(
          padding: const EdgeInsets.only(bottom: 5),
          child: SvgPicture.asset(
            DesignConfiguration.setSvgPath('home'),
            colorFilter: const ColorFilter.mode(Colors.grey, BlendMode.srcIn),
            height: 20,
          ),
        ),
        label: 'CART',
      ),
      BottomNavigationBarItem(
        icon: Padding(
          padding: const EdgeInsets.only(bottom: 5),
          child: SvgPicture.asset(
            DesignConfiguration.setSvgPath('profile'),
            colorFilter: const ColorFilter.mode(Colors.grey, BlendMode.srcIn),
            height: 20,
          ),
        ),
        label: 'PROFILE',
      ),
    ],
    onTap: (int index) {
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => Dashboard(
                  pageIndex: index,
                )),
      );
    },
  );
}
