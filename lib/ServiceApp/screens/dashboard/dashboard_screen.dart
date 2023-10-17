import 'dart:ui';

import 'package:eshop_multivendor/Screen/Dashboard/Dashboard.dart';
import 'package:eshop_multivendor/main.dart';
import 'package:eshop_multivendor/ServiceApp/screens/auth/sign_in_screen.dart';
import 'package:eshop_multivendor/ServiceApp/screens/booking/booking_detail_screen.dart';
import 'package:eshop_multivendor/ServiceApp/screens/category/category_screen.dart';
import 'package:eshop_multivendor/ServiceApp/screens/chat/chat_list_screen.dart';
import 'package:eshop_multivendor/ServiceApp/screens/dashboard/fragment/booking_fragment.dart';
import 'package:eshop_multivendor/ServiceApp/screens/dashboard/fragment/dashboard_fragment.dart';
import 'package:eshop_multivendor/ServiceApp/screens/dashboard/fragment/profile_fragment.dart';
import 'package:eshop_multivendor/ServiceApp/screens/service/service_detail_screen.dart';
import 'package:eshop_multivendor/ServiceApp/utils/colors.dart';
import 'package:eshop_multivendor/ServiceApp/utils/common.dart';
import 'package:eshop_multivendor/ServiceApp/utils/constant.dart';
import 'package:eshop_multivendor/ServiceApp/utils/images.dart';
import 'package:eshop_multivendor/ServiceApp/utils/string_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';

class DashboardScreen extends StatefulWidget {
  final bool? redirectToBooking;

  DashboardScreen({this.redirectToBooking});

  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int currentIndex = 0;

  @override
  void initState() {
    super.initState();
    if (widget.redirectToBooking.validate(value: false)) {
      currentIndex = 1;
    }

    afterBuildCreated(() async {
      /// Changes System theme when changed
      if (getIntAsync(THEME_MODE_INDEX) == THEME_MODE_SYSTEM) {
        appStore.setDarkMode(context.platformBrightness() == Brightness.dark);
      }

      window.onPlatformBrightnessChanged = () async {
        if (getIntAsync(THEME_MODE_INDEX) == THEME_MODE_SYSTEM) {
          appStore.setDarkMode(
              MediaQuery.of(context).platformBrightness == Brightness.light);
        }
      };
    });

    init();
  }

  void init() async {
    if (isMobile) {
      /// Handle Notification click and redirect to that Service & BookDetail screen
      // OneSignal.shared.setNotificationOpenedHandler(
      //     (OSNotificationOpenedResult notification) async {
      //   if (notification.notification.additionalData!.containsKey('id')) {
      //     String? notId =
      //         notification.notification.additionalData!["id"].toString();
      //     if (notId.validate().isNotEmpty) {
      //       BookingDetailScreen(bookingId: notId.toString().toInt())
      //           .launch(context);
      //     }
      //   } else if (notification.notification.additionalData!
      //       .containsKey('service_id')) {
      //     String? notId =
      //         notification.notification.additionalData!["service_id"];
      //     if (notId.validate().isNotEmpty) {
      //       ServiceDetailScreen(serviceId: notId.toInt()).launch(context);
      //     }
      //   }
      // });
    }

    await 3.seconds.delay;
    showForceUpdateDialog(context);
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        body: [
          DashboardFragment(),
          CategoryScreen(),

          Observer(
              builder: (context) => appStore.isLoggedIn
                  ? BookingFragment()
                  : SignInScreen(isFromDashboard: true)),
          // Observer(
          //     builder: (context) => appStore.isLoggedIn
          //         ? ChatListScreen()
          //         : SignInScreen(isFromDashboard: true)),
          ProfileFragment(),
        ][currentIndex],
        bottomNavigationBar: Blur(
          blur: 30,
          borderRadius: radius(0),
          child: NavigationBarTheme(
            data: NavigationBarThemeData(
              backgroundColor: context.primaryColor.withOpacity(0.02),
              indicatorColor: const Color(0xffa48c69),
              labelTextStyle:
                  MaterialStateProperty.all(primaryTextStyle(size: 12)),
              surfaceTintColor: Colors.transparent,
              shadowColor: Colors.transparent,
            ),
            child: NavigationBar(
              selectedIndex: currentIndex,
              destinations: [
                NavigationDestination(
                  icon: ic_home.iconImage(color: appTextSecondaryColor),
                  selectedIcon: ic_home.iconImage(color: context.primaryColor),
                  label: language.home,
                ),
                NavigationDestination(
                  icon: ic_category.iconImage(color: appTextSecondaryColor),
                  selectedIcon:
                      ic_category.iconImage(color: context.primaryColor),
                  label: language.category,
                ),
                NavigationDestination(
                  icon: ic_ticket.iconImage(color: appTextSecondaryColor),
                  selectedIcon:
                      ic_ticket.iconImage(color: context.primaryColor),
                  label: language.booking,
                ),

                // NavigationDestination(
                //   icon: ic_chat.iconImage(color: appTextSecondaryColor),
                //   selectedIcon: ic_chat.iconImage(color: context.primaryColor),
                //   label: language.lblChat,
                // ),
                NavigationDestination(
                  icon: ic_profile2.iconImage(color: appTextSecondaryColor),
                  selectedIcon:
                      ic_profile2.iconImage(color: context.primaryColor),
                  label: language.profile,
                ),
              ],
              onDestinationSelected: (index) {
                currentIndex = index;
                setState(() {});
              },
            ),
          ),
        ),
      ),
    );
  }

  Future<bool> _onWillPop() async {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => const Dashboard()));
    return false;
  }
}
