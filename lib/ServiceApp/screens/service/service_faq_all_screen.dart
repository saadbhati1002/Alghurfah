import 'package:eshop_multivendor/main.dart';
import 'package:eshop_multivendor/ServiceApp/model/service_detail_response.dart';
import 'package:eshop_multivendor/ServiceApp/screens/service/component/service_faq_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nb_utils/nb_utils.dart';

class ServiceFaqAllScreen extends StatelessWidget {
  final List<ServiceFaq> data;

  ServiceFaqAllScreen({required this.data});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarWidget(language.lblServiceFaq,
          color: context.scaffoldBackgroundColor,
          systemUiOverlayStyle:
              SystemUiOverlayStyle(statusBarIconBrightness: Brightness.dark)),
      body: AnimatedListView(
        padding: EdgeInsets.all(16),
        shrinkWrap: true,
        listAnimationType: ListAnimationType.FadeIn,
        fadeInConfiguration: FadeInConfiguration(duration: 2.seconds),
        itemCount: data.length,
        itemBuilder: (_, index) => ServiceFaqWidget(serviceFaq: data[index]),
      ),
    );
  }
}
