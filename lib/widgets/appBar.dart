import 'package:eshop_multivendor/common_screen/favourite_seller_screen.dart';
import 'package:eshop_multivendor/common_screen/home_screen_new.dart';
import 'package:flutter/material.dart';
import '../Helper/Color.dart';
import '../Helper/Constant.dart';

getAppBar(
  key, {
  String? title,
  BuildContext? context,
  Function? setState,
  bool? isHomePage,
}) {
  return AppBar(
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.only(
        bottomRight: Radius.circular(30.0),
      ),
    ),
    titleSpacing: 0,
    backgroundColor: Colors.white,
    leading: Builder(
      builder: (BuildContext context) {
        return isHomePage == true
            ? const SizedBox()
            : Container(
                margin: const EdgeInsets.all(10),
                child: InkWell(
                  borderRadius: BorderRadius.circular(circularBorderRadius4),
                  onTap: () {
                    Navigator.pop(context);
                    // Navigator.push(
                    //   context,
                    //   MaterialPageRoute(
                    //     builder: (context) => const HomeScreenNew(),
                    //   ),
                    // );
                  },
                  child: const Center(
                    child: SizedBox(
                      height: 25,
                      width: 25,
                      child: Icon(
                        Icons.arrow_back_ios_new_rounded,
                        color: colors.primary,
                      ),
                    ),
                  ),
                ),
              );
      },
    ),
    title: Center(
      child: Text(
        title!,
        style: const TextStyle(
          color: colors.primary,
          fontWeight: FontWeight.w700,
          fontSize: 20,
          fontFamily: 'ubuntu',
        ),
      ),
    ),
    actions: <Widget>[
      GestureDetector(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Image.asset('assets/images/png/bookMark.png'),
        ),
        onTap: () {
          Navigator.push(
            context!,
            MaterialPageRoute(
              builder: (context) => const FavoriteSellerScreen(),
            ),
          );
        },
      ),
      GestureDetector(
        onTap: () {
          key.currentState!.openEndDrawer();
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 15),
          child: Image.asset('assets/images/png/drawer.png'),
        ),
      ),
    ],
  );
}

getSimpleAppBar(
  String title,
  BuildContext context,
) {
  return AppBar(
    titleSpacing: 0,
    backgroundColor: Theme.of(context).colorScheme.white,
    leading: Builder(
      builder: (BuildContext context) {
        return Container(
          margin: const EdgeInsets.all(10),
          child: InkWell(
            borderRadius: BorderRadius.circular(circularBorderRadius4),
            onTap: () => Navigator.of(context).pop(),
            child: const Center(
              child: Icon(
                Icons.arrow_back_ios_rounded,
                color: colors.primary,
              ),
            ),
          ),
        );
      },
    ),
    title: Text(
      title,
      style: const TextStyle(
        color: colors.primary,
        fontWeight: FontWeight.normal,
        fontFamily: 'ubuntu',
      ),
    ),
  );
}
