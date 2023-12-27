import 'dart:async';
import 'package:eshop_multivendor/Provider/SettingProvider.dart';
import 'package:eshop_multivendor/Provider/Theme.dart';
import 'package:eshop_multivendor/Provider/homePageProvider.dart';
import 'package:eshop_multivendor/Screen/IntroSlider/Intro_Slider.dart';
import 'package:eshop_multivendor/Screen/Language/languageSettings.dart';
import 'package:eshop_multivendor/common_screen/home_screen_new.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../Helper/String.dart';
import '../../widgets/desing.dart';
import '../../widgets/systemChromeSettings.dart';
import '../../widgets/background_image.dart';

//splash screen of app
class Splash extends StatefulWidget {
  const Splash({Key? key}) : super(key: key);

  @override
  _SplashScreen createState() => _SplashScreen();
}

class _SplashScreen extends State<Splash> with TickerProviderStateMixin {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  bool from = false;
  late AnimationController navigationContainerAnimationController =
      AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 200),
  );
  @override
  void initState() {
    SystemChromeSettings.setSystemButtonNavigationBaritTopAndButton();
    SystemChromeSettings.setSystemUIOverlayStyleWithNoSpecification();
    initializeAnimationController();
    startTime();
    super.initState();
  }

  void initializeAnimationController() {
    Future.delayed(
      Duration.zero,
      () {
        context.read<HomePageProvider>()
          ..setAnimationController(navigationContainerAnimationController)
          ..setBottomBarOffsetToAnimateController(
              navigationContainerAnimationController)
          ..setAppBarOffsetToAnimateController(
              navigationContainerAnimationController);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    deviceHeight = MediaQuery.of(context).size.height;
    deviceWidth = MediaQuery.of(context).size.width;

    return SafeArea(
      top: true,
      child: Scaffold(
        key: _scaffoldKey,
        body: Stack(
          children: [
            const BackgroundImage(),
            SizedBox(
              height: MediaQuery.of(context).size.height * 1,
              width: MediaQuery.of(context).size.width * 1,
              child: Center(
                child: Image.asset(
                  DesignConfiguration.setPngPath('logo'),
                  fit: BoxFit.fill,
                  height: MediaQuery.of(context).size.height * .35,
                  width: MediaQuery.of(context).size.width * .5,
                  // height: 250,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  startTime() async {
    var duration = const Duration(seconds: 2);
    return Timer(duration, navigationPage);
  }

  Future<void> navigationPage() async {
    SettingProvider settingsProvider =
        Provider.of<SettingProvider>(context, listen: false);
    bool isFirstTime = await settingsProvider.getPrefrenceBool(ISFIRSTTIME);
    if (isFirstTime) {
      setState(
        () {
          from = true;
        },
      );
      Navigator.pushReplacement(
        context,
        CupertinoPageRoute(
          builder: (context) => const HomeScreenNew(),
        ),
      );
      // Navigator.pushReplacementNamed(context, '/home');
    } else {
      setState(
        () {
          from = false;
        },
      );
      Navigator.pushReplacement(
        context,
        CupertinoPageRoute(
          builder: (context) => const IntroSlider(),
        ),
      );
    }
  }

  @override
  void dispose() {
    if (from) {
      SystemChromeSettings.setSystemButtonNavigationBaritTopAndButton();
    }
    super.dispose();
  }
}
