import 'package:flutter/material.dart';
import '../Helper/Color.dart';
import '../Helper/Constant.dart';
import '../Helper/routes.dart';
import '../Screen/Language/languageSettings.dart';

getAppBar(
  key, {
  String? title,
  BuildContext? context,
  Function? setState,
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
        return Container(
          margin: const EdgeInsets.all(10),
          child: InkWell(
            borderRadius: BorderRadius.circular(circularBorderRadius4),
            onTap: () => Navigator.of(context).pop(),
            child: const Center(
              child: Icon(
                Icons.search,
                size: 30,
                color: colors.primary,
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
      title == getTranslated(context!, 'FAVORITE')
          ? Container()
          : IconButton(
              padding: const EdgeInsets.all(0),
              icon: const Icon(
                Icons.bookmark,
                size: 30,
                color: colors.primary,
              ),
              onPressed: () {
                Routes.navigateToFavoriteScreen(context);
              },
            ),
      IconButton(
          onPressed: () {
            key.currentState!.openEndDrawer();
          },
          icon: const Icon(
            Icons.menu,
            size: 35,
            color: colors.primary,
          ))
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
