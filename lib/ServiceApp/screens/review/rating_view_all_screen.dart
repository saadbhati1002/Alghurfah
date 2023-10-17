import 'package:eshop_multivendor/ServiceApp/component/back_widget.dart';
import 'package:eshop_multivendor/main.dart';
import 'package:eshop_multivendor/ServiceApp/model/service_detail_response.dart';
import 'package:eshop_multivendor/ServiceApp/network/rest_apis.dart';
import 'package:eshop_multivendor/ServiceApp/screens/review/components/review_widget.dart';
import 'package:eshop_multivendor/ServiceApp/screens/review/shimmer/review_shimmer.dart';
import 'package:eshop_multivendor/ServiceApp/utils/constant.dart';
import 'package:eshop_multivendor/ServiceApp/utils/model_keys.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../component/empty_error_state_widget.dart';

class RatingViewAllScreen extends StatelessWidget {
  final List<RatingData>? ratingData;
  final int? serviceId;
  final int? handymanId;

  RatingViewAllScreen({this.ratingData, this.serviceId, this.handymanId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarWidget(language.review,
          color: context.primaryColor,
          textColor: Colors.white,
          backWidget: BackWidget()),
      body: SnapHelperWidget<List<RatingData>>(
        future: serviceId != null
            ? serviceReviews({CommonKeys.serviceId: serviceId})
            : handymanReviews({CommonKeys.handymanId: handymanId}),
        loadingWidget: ReviewShimmer(),
        onSuccess: (data) {
          if (data.isNotEmpty) {
            return AnimatedListView(
              slideConfiguration: sliderConfigurationGlobal,
              shrinkWrap: true,
              listAnimationType: ListAnimationType.FadeIn,
              fadeInConfiguration: FadeInConfiguration(duration: 2.seconds),
              padding: EdgeInsets.all(16),
              itemCount: data.length,
              itemBuilder: (context, index) => ReviewWidget(
                  data: data[index], isCustomer: serviceId == null),
            );
          } else {
            return NoDataWidget(
              title: language.lblNoServiceRatings,
              imageWidget: EmptyStateWidget(),
            );
          }
        },
      ),
    );
  }
}
