import 'dart:io';

import 'package:eshop_multivendor/Helper/Color.dart';
import 'package:eshop_multivendor/ServiceApp/component/back_widget.dart';
import 'package:eshop_multivendor/ServiceApp/component/cached_image_widget.dart';
import 'package:eshop_multivendor/ServiceApp/component/price_widget.dart';
import 'package:eshop_multivendor/ServiceApp/screens/zoom_image_screen.dart';
import 'package:eshop_multivendor/main.dart';
import 'package:eshop_multivendor/ServiceApp/model/service_data_model.dart';
import 'package:eshop_multivendor/ServiceApp/screens/auth/sign_in_screen.dart';
import 'package:eshop_multivendor/ServiceApp/screens/gallery/gallery_component.dart';
import 'package:eshop_multivendor/ServiceApp/screens/gallery/gallery_screen.dart';
import 'package:eshop_multivendor/ServiceApp/utils/colors.dart';
import 'package:eshop_multivendor/ServiceApp/utils/common.dart';
import 'package:eshop_multivendor/ServiceApp/utils/constant.dart';
import 'package:eshop_multivendor/ServiceApp/utils/images.dart';
import 'package:eshop_multivendor/ServiceApp/utils/string_extensions.dart';
import 'package:eshop_multivendor/widgets/desing.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:share_plus/share_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'package:card_swiper/card_swiper.dart';

class ServiceDetailHeaderComponent extends StatefulWidget {
  final ServiceData serviceDetail;

  const ServiceDetailHeaderComponent({required this.serviceDetail, Key? key})
      : super(key: key);

  @override
  State<ServiceDetailHeaderComponent> createState() =>
      _ServiceDetailHeaderComponentState();
}

class _ServiceDetailHeaderComponentState
    extends State<ServiceDetailHeaderComponent> {
  late ShortDynamicLink shortenedLink;
  Future<void> createDynamicLink() async {
    String documentDirectory;

    if (Platform.isIOS) {
      documentDirectory = (await getApplicationDocumentsDirectory()).path;
    } else {
      documentDirectory = (await getExternalStorageDirectory())!.path;
    }

    final response1 =
        await get(Uri.parse(widget.serviceDetail.attachments!.first));
    final bytes1 = response1.bodyBytes;

    final File imageFile = File('$documentDirectory/temp.png');

    imageFile.writeAsBytesSync(bytes1);
    Share.shareXFiles(
      [XFile(imageFile.path)],
      text:
          'Download this amazing app with it buy products and book service that you need',
      sharePositionOrigin: Rect.largest,
    );
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 270,
      width: MediaQuery.of(context).size.width * 1,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          if (widget.serviceDetail.attachments.validate().isNotEmpty)
            SizedBox(
              height: 270,
              width: context.width(),
              child: Swiper(
                itemCount: widget.serviceDetail.attachments!.length,
                itemBuilder: (context, index) {
                  final slider = widget.serviceDetail.attachments![index];
                  return GestureDetector(
                    onTap: () {
                      ZoomImageScreen(
                              galleryImages: widget.serviceDetail.attachments!,
                              index: index)
                          .launch(context,
                              pageRouteAnimation: PageRouteAnimation.Fade,
                              duration: 200.milliseconds);
                    },
                    child: DesignConfiguration.getCacheNotworkImage(
                        imageurlString: slider,
                        boxFit: BoxFit.fill,
                        context: context,
                        heightvalue: 180,
                        placeHolderSize: 50,
                        widthvalue: double.maxFinite),
                  );
                },
                indicatorLayout: PageIndicatorLayout.COLOR,
                autoplay: false,
                pagination: const SwiperPagination(),
                // control: const SwiperControl(color: colors.primary, size: 30),
              ),
            ),
          Padding(
            padding: const EdgeInsets.only(top: 5, left: 0),
            child: Align(
              alignment: Alignment.topLeft,
              child: IconButton(
                onPressed: () => Navigator.of(context).pop(),
                icon: const Icon(
                  Icons.arrow_back_ios_rounded,
                  color: colors.primary,
                ),
              ),
            ),
          ),
          // Align(
          //   alignment: Alignment.bottomCenter,
          //   child: Row(
          //     children: [
          //       IconButton(
          //         icon: const Icon(
          //           Icons.share,
          //           size: 25.0,
          //           color: colors.primary,
          //         ),
          //         onPressed: createDynamicLink,
          //       ),
          //     ],
          //   ),
          // ),
        ],
      ),
    );
  }
}
