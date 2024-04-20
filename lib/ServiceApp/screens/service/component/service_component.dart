import 'package:eshop_multivendor/Helper/Color.dart';
import 'package:eshop_multivendor/Helper/Constant.dart';
import 'package:eshop_multivendor/Helper/String.dart';
import 'package:eshop_multivendor/Screen/Language/languageSettings.dart';
import 'package:eshop_multivendor/ServiceApp/component/cached_image_widget.dart';
import 'package:eshop_multivendor/ServiceApp/component/disabled_rating_bar_widget.dart';
import 'package:eshop_multivendor/ServiceApp/component/image_border_component.dart';
import 'package:eshop_multivendor/ServiceApp/component/price_widget.dart';
import 'package:eshop_multivendor/main.dart';
import 'package:eshop_multivendor/ServiceApp/model/package_data_model.dart';
import 'package:eshop_multivendor/ServiceApp/model/service_data_model.dart';
import 'package:eshop_multivendor/ServiceApp/screens/booking/provider_info_screen.dart';
import 'package:eshop_multivendor/ServiceApp/screens/service/service_detail_screen.dart';
import 'package:eshop_multivendor/ServiceApp/utils/colors.dart';
import 'package:eshop_multivendor/ServiceApp/utils/common.dart';
import 'package:eshop_multivendor/ServiceApp/utils/constant.dart';
import 'package:eshop_multivendor/ServiceApp/utils/images.dart';
import 'package:eshop_multivendor/ServiceApp/utils/string_extensions.dart';
import 'package:eshop_multivendor/widgets/desing.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';

class ServiceComponent extends StatefulWidget {
  final ServiceData? serviceData;
  final BookingPackage? selectedPackage;
  final double? width;
  final bool? isBorderEnabled;
  final VoidCallback? onUpdate;
  final bool isFavouriteService;

  ServiceComponent(
      {this.serviceData,
      this.width,
      this.isBorderEnabled,
      this.isFavouriteService = false,
      this.onUpdate,
      this.selectedPackage});

  @override
  ServiceComponentState createState() => ServiceComponentState();
}

class ServiceComponentState extends State<ServiceComponent> {
  @override
  void initState() {
    super.initState();
    init();
  }

  Future<void> init() async {
    //
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    double width = deviceWidth! * 0.5;
    return GestureDetector(
      onTap: () {
        hideKeyboard(context);
        ServiceDetailScreen(
                serviceId: widget.isFavouriteService
                    ? widget.serviceData!.serviceId.validate().toInt()
                    : widget.serviceData!.id.validate())
            .launch(context);
      },
      child: Container(
        height: MediaQuery.of(context).size.height * .35,
        decoration: boxDecorationWithRoundedCorners(
          backgroundColor: Colors.transparent,
          borderRadius: radius(),
          border: widget.isBorderEnabled.validate(value: false)
              ? appStore.isDarkMode
                  ? Border.all(color: context.dividerColor)
                  : null
              : null,
        ),
        width: widget.width,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Expanded(
              child: ClipRRect(
                borderRadius: const BorderRadius.only(
                  topRight: Radius.circular(20),
                  bottomLeft: Radius.circular(20),
                ),
                child: Hero(
                  tag: '$heroTagUniqueString',
                  child: DesignConfiguration.getCacheNotworkImage(
                    boxFit: BoxFit.fill,
                    context: context,
                    heightvalue: double.maxFinite,
                    widthvalue: double.maxFinite,
                    placeHolderSize: width,
                    imageurlString: widget.serviceData!.attachments != null
                        ? widget.serviceData!.attachments!.first
                        : '',
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsetsDirectional.only(
                start: 10.0,
                top: 10,
              ),
              child: Text(
                widget.serviceData!.name ?? '',
                style: Theme.of(context).textTheme.bodySmall!.copyWith(
                      color: Colors.black,
                      fontSize: textFontSize15,
                      fontWeight: FontWeight.w500,
                      fontStyle: FontStyle.normal,
                      // fontFamily: 'ubuntu',
                    ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                softWrap: true,
              ),
            ),
            Padding(
              padding: const EdgeInsetsDirectional.only(
                start: 8.0,
                top: 5,
              ),
              child: Row(
                children: [
                  Text(
                    ' ${DesignConfiguration.getPriceFormat(context, double.parse(widget.serviceData!.price.toString()))!} AED',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.blue,
                      fontSize: textFontSize14,
                      fontWeight: FontWeight.w700,
                      fontStyle: FontStyle.normal,
                      fontFamily: 'ubuntu',
                    ),
                  ),
                  // Expanded(
                  //   child: Padding(
                  //     padding: const EdgeInsetsDirectional.only(
                  //       start: 10.0,
                  //       top: 5,
                  //     ),
                  //     child: Row(
                  //       children: <Widget>[
                  //         Text(
                  //           double.parse(service.price.toString()).toString(),
                  //           style: Theme.of(context)
                  //               .textTheme
                  //               .labelSmall!
                  //               .copyWith(
                  //                 fontFamily: 'ubuntu',
                  //                 color: Colors.black,
                  //                 decoration: TextDecoration.lineThrough,
                  //                 decorationColor: Colors.black,
                  //                 decorationStyle: TextDecorationStyle.solid,
                  //                 decorationThickness: 2,
                  //                 letterSpacing: 0,
                  //                 fontSize: textFontSize10,
                  //                 fontWeight: FontWeight.w600,
                  //                 fontStyle: FontStyle.normal,
                  //               ),
                  //         ),
                  //       ],
                  //     ),
                  //   ),
                  // )
                ],
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            GestureDetector(
              onTap: () {
                hideKeyboard(context);
                ServiceDetailScreen(
                        serviceId: widget.isFavouriteService
                            ? widget.serviceData!.serviceId.validate().toInt()
                            : widget.serviceData!.id.validate())
                    .launch(context);
              },
              child: Container(
                height: 25,
                width: MediaQuery.of(context).size.width,
                decoration: const BoxDecoration(
                  color: colors.serviceColor,
                  borderRadius: BorderRadius.only(
                      topRight: Radius.circular(20),
                      bottomLeft: Radius.circular(20)),
                ),
                alignment: Alignment.center,
                child: Text(
                  getTranslated(context, 'Book Now')!,
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w500),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
