import 'dart:async';

import 'package:card_swiper/card_swiper.dart';
import 'package:eshop_multivendor/Helper/Color.dart';
import 'package:eshop_multivendor/ServiceApp/component/cached_image_widget.dart';
import 'package:eshop_multivendor/main.dart';
import 'package:eshop_multivendor/ServiceApp/model/dashboard_model.dart';
import 'package:eshop_multivendor/ServiceApp/screens/notification/notification_screen.dart';
import 'package:eshop_multivendor/ServiceApp/screens/service/service_detail_screen.dart';
import 'package:eshop_multivendor/ServiceApp/screens/service/view_all_service_screen.dart';
import 'package:eshop_multivendor/ServiceApp/utils/colors.dart';
import 'package:eshop_multivendor/ServiceApp/utils/configs.dart';
import 'package:eshop_multivendor/ServiceApp/utils/constant.dart';
import 'package:eshop_multivendor/ServiceApp/utils/images.dart';
import 'package:eshop_multivendor/ServiceApp/utils/string_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../../utils/common.dart';

class SliderLocationComponent extends StatefulWidget {
  final List<SliderModel> sliderList;
  final VoidCallback? callback;

  SliderLocationComponent({required this.sliderList, this.callback});

  @override
  State<SliderLocationComponent> createState() =>
      _SliderLocationComponentState();
}

class _SliderLocationComponentState extends State<SliderLocationComponent> {
  PageController sliderPageController = PageController(initialPage: 0);
  int _currentPage = 0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    if (getBoolAsync(AUTO_SLIDER_STATUS, defaultValue: true) &&
        widget.sliderList.length >= 2) {
      _timer = Timer.periodic(Duration(seconds: DASHBOARD_AUTO_SLIDER_SECOND),
          (Timer timer) {
        if (_currentPage < widget.sliderList.length - 1) {
          _currentPage++;
        } else {
          _currentPage = 0;
        }
        sliderPageController.animateToPage(_currentPage,
            duration: Duration(milliseconds: 950), curve: Curves.easeOutQuart);
      });

      sliderPageController.addListener(() {
        _currentPage = sliderPageController.page!.toInt();
      });
    }
  }

  @override
  void dispose() {
    super.dispose();
    _timer?.cancel();
    sliderPageController.dispose();
  }

  Widget getSliderWidget() {
    return SizedBox(
      height: 200,
      width: context.width(),
      child: widget.sliderList.isNotEmpty
          ? Swiper(
              itemCount: widget.sliderList.length,
              indicatorLayout: PageIndicatorLayout.COLOR,
              autoplay: false,
              pagination: const SwiperPagination(),
              control: const SwiperControl(color: colors.primary, size: 30),
              onTap: (v) {
                SliderModel data = widget.sliderList[v];
                ServiceDetailScreen(serviceId: data.typeId.validate().toInt())
                    .launch(context,
                        pageRouteAnimation: PageRouteAnimation.Fade);
              },
              itemBuilder: (context, index) {
                SliderModel data = widget.sliderList[index];
                return CachedImageWidget(
                    url: data.sliderImage.validate(),
                    height: 250,
                    width: context.width(),
                    fit: BoxFit.cover);
              })
          : CachedImageWidget(url: '', height: 250, width: context.width()),
      //  PageView(
      //     controller: sliderPageController,
      //     children: List.generate(
      //       widget.sliderList.length,
      //       (index) {
      //         SliderModel data = widget.sliderList[index];
      //         return CachedImageWidget(
      //                 url: data.sliderImage.validate(),
      //                 height: 250,
      //                 width: context.width(),
      //                 fit: BoxFit.cover)
      //             .onTap(() {
      //           if (data.type == SERVICE) {
      //             ServiceDetailScreen(
      //                     serviceId: data.typeId.validate().toInt())
      //                 .launch(context,
      //                     pageRouteAnimation: PageRouteAnimation.Fade);
      //           }
      //         });
      //       },
      //     ),
      //   )
      // : CachedImageWidget(url: '', height: 250, width: context.width()),
    );
  }

  Decoration get commonDecoration {
    return boxDecorationDefault(
      color: context.cardColor,
      boxShadow: [
        BoxShadow(color: shadowColorGlobal, offset: Offset(1, 0)),
        BoxShadow(color: shadowColorGlobal, offset: Offset(0, 1)),
        BoxShadow(color: shadowColorGlobal, offset: Offset(-1, 0)),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return getSliderWidget();
  }
}
