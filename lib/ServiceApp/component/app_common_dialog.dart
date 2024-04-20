import 'package:eshop_multivendor/Helper/Color.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';

class AppCommonDialog extends StatelessWidget {
  final String title;
  final Widget child;

  AppCommonDialog({required this.title, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: colors.backgroundColor,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.fromLTRB(16, 12, 8, 12),
            width: context.width(),
            decoration: boxDecorationDefault(
              color: colors.backgroundColor,
              borderRadius:
                  radiusOnly(topRight: defaultRadius, topLeft: defaultRadius),
            ),
            child: Row(
              children: [
                Text(title, style: boldTextStyle(color: Colors.black)).expand(),
                const CloseButton(color: Colors.black),
              ],
            ),
          ),
          child,
        ],
      ),
    );
  }
}
