import 'package:eshop_multivendor/Helper/Constant.dart';
import 'package:eshop_multivendor/ServiceApp/component/view_all_label_component.dart';
import 'package:eshop_multivendor/ServiceApp/utils/common.dart';
import 'package:eshop_multivendor/main.dart';
import 'package:eshop_multivendor/ServiceApp/model/package_data_model.dart';
import 'package:eshop_multivendor/ServiceApp/model/service_data_model.dart';
import 'package:eshop_multivendor/ServiceApp/model/service_detail_response.dart';
import 'package:eshop_multivendor/ServiceApp/model/slot_data.dart';
import 'package:eshop_multivendor/ServiceApp/model/user_data_model.dart';
import 'package:eshop_multivendor/ServiceApp/network/rest_apis.dart';
import 'package:eshop_multivendor/ServiceApp/screens/auth/sign_in_screen.dart';
import 'package:eshop_multivendor/ServiceApp/screens/booking/book_service_screen.dart';
import 'package:eshop_multivendor/ServiceApp/screens/booking/component/booking_detail_provider_widget.dart';
import 'package:eshop_multivendor/ServiceApp/screens/booking/provider_info_screen.dart';
import 'package:eshop_multivendor/ServiceApp/screens/review/components/review_widget.dart';
import 'package:eshop_multivendor/ServiceApp/screens/review/rating_view_all_screen.dart';
import 'package:eshop_multivendor/ServiceApp/screens/service/component/service_component.dart';
import 'package:eshop_multivendor/ServiceApp/screens/service/component/service_detail_header_component.dart';
import 'package:eshop_multivendor/ServiceApp/screens/service/component/service_faq_widget.dart';
import 'package:eshop_multivendor/ServiceApp/screens/service/package/package_component.dart';
import 'package:eshop_multivendor/ServiceApp/screens/service/shimmer/service_detail_shimmer.dart';
import 'package:eshop_multivendor/ServiceApp/utils/colors.dart';
import 'package:eshop_multivendor/ServiceApp/utils/constant.dart';
import 'package:eshop_multivendor/widgets/appBar.dart';
import 'package:eshop_multivendor/widgets/desing.dart';
import 'package:eshop_multivendor/widgets/snackbar.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:eshop_multivendor/widgets/bottomNavigationSheet.dart';
import 'package:eshop_multivendor/widgets/app_drawer.dart';
import 'package:eshop_multivendor/Helper/Color.dart';
import 'package:eshop_multivendor/Screen/Product Detail/Widget/ProductHighLight.dart';
import 'package:eshop_multivendor/Screen/Product Detail/Widget/allQuestionButton.dart';
import 'package:eshop_multivendor/Screen/Product Detail/Widget/brandNameWidget.dart';
import 'package:eshop_multivendor/Screen/Product Detail/Widget/commanFiledsofProduct.dart';
import 'package:eshop_multivendor/Screen/Product Detail/Widget/productItemList.dart';
import 'package:eshop_multivendor/Screen/Product Detail/Widget/productExtraDetail.dart';
import 'package:eshop_multivendor/Screen/Product Detail/Widget/commanFiledsofProduct.dart';
import 'package:eshop_multivendor/Screen/Language/languageSettings.dart';

class ServiceDetailScreen extends StatefulWidget {
  final int serviceId;
  final String? serviceName;
  final ServiceData? service;

  ServiceDetailScreen(
      {required this.serviceId, this.service, this.serviceName});

  @override
  _ServiceDetailScreenState createState() => _ServiceDetailScreenState();
}

class _ServiceDetailScreenState extends State<ServiceDetailScreen>
    with TickerProviderStateMixin {
  PageController pageController = PageController();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  Future<ServiceDetailResponse>? future;

  int selectedAddressId = 0;
  int selectedBookingAddressId = -1;
  BookingPackage? selectedPackage;

  @override
  void initState() {
    super.initState();
    init();
  }

  void init() async {
    setStatusBarColor(transparentColor);

    future = getServiceDetails(
        serviceId: widget.serviceId.validate(), customerId: appStore.userId);
  }

  //region Widgets
  Widget availableWidget({required ServiceData data}) {
    if (data.serviceAddressMapping.validate().isEmpty) return Offstage();

    return Container(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(language.lblAvailableAt,
              style: boldTextStyle(size: LABEL_TEXT_SIZE)),
          16.height,
          Wrap(
            spacing: 16,
            runSpacing: 16,
            children: List.generate(
              data.serviceAddressMapping!.length,
              (index) {
                ServiceAddressMapping value =
                    data.serviceAddressMapping![index];
                if (value.providerAddressMapping == null) return Offstage();

                bool isSelected = selectedAddressId == index;
                if (selectedBookingAddressId == -1) {
                  selectedBookingAddressId = data
                      .serviceAddressMapping!.first.providerAddressId
                      .validate();
                }
                return GestureDetector(
                  onTap: () {
                    selectedAddressId = index;
                    selectedBookingAddressId =
                        value.providerAddressId.validate();
                    setState(() {});
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                    decoration: boxDecorationDefault(
                        color: isSelected
                            ? colors.serviceColor
                            : context.cardColor),
                    child: Text(
                      '${value.providerAddressMapping!.address.validate()}',
                      style: boldTextStyle(
                          color: isSelected ? Colors.white : Colors.grey),
                    ),
                  ),
                );
              },
            ),
          )
        ],
      ),
    );
  }

  Widget providerWidget({required UserData data}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(language.lblAboutProvider,
            style: boldTextStyle(size: LABEL_TEXT_SIZE, color: Colors.black)),
        16.height,
        BookingDetailProviderWidget(providerData: data).onTap(() async {
          await ProviderInfoScreen(providerId: data.id).launch(context);
          setStatusBarColor(Colors.transparent);
        }),
      ],
    ).paddingAll(16);
  }

  Widget serviceFaqWidget({required List<ServiceFaq> data}) {
    if (data.isEmpty) return Offstage();

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          16.height,
          ViewAllLabel(label: language.lblFaq, list: data),
          8.height,
          ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: data.length,
            padding: EdgeInsets.all(0),
            itemBuilder: (_, index) =>
                ServiceFaqWidget(serviceFaq: data[index]),
          ),
          8.height,
        ],
      ),
    );
  }

  Widget slotsAvailable(
      {required List<SlotData> data, required bool isSlotAvailable}) {
    if (!isSlotAvailable ||
        data.where((element) => element.slot.validate().isNotEmpty).isEmpty)
      return Offstage();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ViewAllLabel(label: language.lblAvailableOnTheseDays, list: []),
        16.height,
        Wrap(
          spacing: 16,
          runSpacing: 8,
          children: List.generate(
              data
                  .where((element) => element.slot.validate().isNotEmpty)
                  .length, (index) {
            SlotData value = data
                .where((element) => element.slot.validate().isNotEmpty)
                .toList()[index];
            return Container(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: boxDecorationDefault(color: context.cardColor),
              child: Text('${value.day.capitalizeFirstLetter()}',
                  style: secondaryTextStyle(size: 18, color: primaryColor)),
            );
          }),
        ),
      ],
    ).paddingAll(16);
  }

  Widget reviewWidget(
      {required List<RatingData> data,
      required ServiceDetailResponse serviceDetailResponse}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ViewAllLabel(
          //label: language.review,
          label:
              '${language.review} (${serviceDetailResponse.serviceDetail!.totalReview})',
          list: data,
          onTap: () {
            RatingViewAllScreen(serviceId: widget.serviceId).launch(context);
          },
        ),
        data.isNotEmpty
            ? Wrap(
                children: List.generate(
                  data.length,
                  (index) => ReviewWidget(data: data[index]),
                ),
              ).paddingTop(8)
            : Text(language.lblNoReviews, style: secondaryTextStyle()),
      ],
    ).paddingSymmetric(horizontal: 16);
  }

  Widget relatedServiceWidget(
      {required List<ServiceData> serviceList, required int serviceId}) {
    if (serviceList.isEmpty) return Offstage();

    serviceList.removeWhere((element) => element.id == serviceId);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        8.height,
        Text(language.lblRelatedServices,
                style: boldTextStyle(size: LABEL_TEXT_SIZE))
            .paddingSymmetric(horizontal: 16),
        HorizontalList(
          itemCount: serviceList.length,
          padding: EdgeInsets.all(16),
          spacing: 8,
          runSpacing: 16,
          itemBuilder: (_, index) => ServiceComponent(
                  serviceData: serviceList[index],
                  width: context.width() / 2 - 26)
              .paddingOnly(right: 8),
        ),
        16.height,
      ],
    );
  }

  //endregion

  void bookNow(ServiceDetailResponse serviceDetailResponse) {
    if (appStore.isLoggedIn) {
      serviceDetailResponse.serviceDetail!.bookingAddressId =
          selectedBookingAddressId;
      BookServiceScreen(
              data: serviceDetailResponse, selectedPackage: selectedPackage)
          .launch(context)
          .then((value) {
        setStatusBarColor(transparentColor);
      });
    } else {
      SignInScreen(isFromServiceBooking: true).launch(context).then((value) {
        if (appStore.isLoggedIn) {
          serviceDetailResponse.serviceDetail!.bookingAddressId =
              selectedBookingAddressId;
          BookServiceScreen(
                  data: serviceDetailResponse, selectedPackage: selectedPackage)
              .launch(context)
              .then((value) {
            setStatusBarColor(transparentColor);
          });
        }
      });
    }
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  Future<void> onTapFavorites(serviceDetail) async {
    if (serviceDetail.isFavourite == 1) {
      serviceDetail.isFavourite = 0;
      setState(() {});

      await removeToWishList(serviceId: serviceDetail.id).then((value) {
        if (!value) {
          serviceDetail.isFavourite = 1;
          setSnackbar(
              getTranslated(context, 'Removed from favorite')!, context);
        }
      });
    } else {
      serviceDetail.isFavourite = 1;
      setState(() {});

      await addToWishList(serviceId: serviceDetail.id).then((value) {
        if (!value) {
          serviceDetail.isFavourite = 0;
          setSnackbar(getTranslated(context, 'Added to favorite')!, context);

          setState(() {});
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget buildBodyWidget(AsyncSnapshot<ServiceDetailResponse> snap) {
      if (snap.hasError) {
        return Text(snap.error.toString()).center();
      } else if (snap.hasData) {
        return Stack(
          children: [
            AnimatedScrollView(
              padding: const EdgeInsets.only(bottom: 40),
              listAnimationType: ListAnimationType.FadeIn,
              fadeInConfiguration: FadeInConfiguration(duration: 2.seconds),
              children: [
                ServiceDetailHeaderComponent(
                    serviceDetail: snap.data!.serviceDetail!),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    snap.data!.serviceDetail!.name != '' &&
                            snap.data!.serviceDetail!.name != null
                        ? GetTitleWidget(
                            title: snap.data!.serviceDetail!.name!,
                          )
                        : Container(),
                    Padding(
                      padding: const EdgeInsets.only(left: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            '${DesignConfiguration.getPriceFormat(context, double.parse(snap.data!.serviceDetail!.price!.toString()))!} AED',
                            style: Theme.of(context)
                                .textTheme
                                .titleLarge!
                                .copyWith(
                                  color: Theme.of(context).colorScheme.blue,
                                  fontWeight: FontWeight.w700,
                                  fontStyle: FontStyle.normal,
                                  fontSize: textFontSize20,
                                ),
                          ),
                          const SizedBox(width: 10),
                        ],
                      ),
                    ),
                    GetRatttingWidget(
                      ratting:
                          snap.data!.serviceDetail!.totalRating!.toString(),
                      noOfRatting: '',
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          GestureDetector(
                            onTap: () {
                              bookNow(snap.data!);
                            },
                            child: Container(
                              alignment: Alignment.center,
                              height: 45,
                              width: MediaQuery.of(context).size.width * .7,
                              decoration: const BoxDecoration(
                                  borderRadius: BorderRadius.only(
                                    topRight: Radius.circular(25),
                                    bottomLeft: Radius.circular(25),
                                  ),
                                  color: colors.serviceColor),
                              child: Text(
                                getTranslated(context, 'Book Now')!,
                                textAlign: TextAlign.center,
                                style: Theme.of(context)
                                    .textTheme
                                    .titleMedium!
                                    .copyWith(
                                      color:
                                          Theme.of(context).colorScheme.black,
                                      fontSize: textFontSize16,
                                      fontWeight: FontWeight.normal,
                                      fontFamily: 'ubuntu',
                                    ),
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              onTapFavorites(snap.data!.serviceDetail!);
                            },
                            child: Container(
                              height: 45,
                              width: 55,
                              decoration: const BoxDecoration(
                                  borderRadius: BorderRadius.only(
                                    topRight: Radius.circular(20),
                                    bottomLeft: Radius.circular(20),
                                  ),
                                  color: colors.serviceColor),
                              child: const Icon(
                                Icons.favorite,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    8.height,
                  ],
                ).paddingAll(16),
                const SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topRight: Radius.circular(25),
                        bottomLeft: Radius.circular(25),
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(
                            height: 20,
                          ),
                          Text(
                            getTranslated(context, 'Product Highlights')!,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontStyle: FontStyle.normal,
                              fontSize: textFontSize16,
                              color: Theme.of(context).colorScheme.white,
                            ),
                          ),
                          const SizedBox(
                            height: 7,
                          ),
                          snap.data!.serviceDetail!.description
                                  .validate()
                                  .isNotEmpty
                              ? ReadMoreText(
                                  snap.data!.serviceDetail!.description
                                      .validate(),
                                  style: secondaryTextStyle(),
                                  textAlign: TextAlign.justify,
                                )
                              : Text(language.lblNotDescription,
                                  style: secondaryTextStyle()),
                          const SizedBox(
                            height: 10,
                          ),
                          availableWidget(data: snap.data!.serviceDetail!),
                        ],
                      ),
                    ),
                  ),
                ),
                // slotsAvailable(
                //     data: snap.data!.serviceDetail!.bookingSlots.validate(),
                //     isSlotAvailable: snap.data!.serviceDetail!.isSlotAvailable),
                providerWidget(data: snap.data!.provider!),
                // PackageComponent(
                //   servicePackage:
                //       snap.data!.serviceDetail!.servicePackage.validate(),
                //   callBack: (v) {
                //     if (v != null) {
                //       selectedPackage = v;
                //     } else {
                //       selectedPackage = null;
                //     }
                //     bookNow(snap.data!);
                //   },
                // ),
                // serviceFaqWidget(data: snap.data!.serviceFaq.validate()),
                // reviewWidget(
                //     data: snap.data!.ratingData!,
                //     serviceDetailResponse: snap.data!),
                // 24.height,
                // relatedServiceWidget(
                //     serviceList: snap.data!.relatedService.validate(),
                //     serviceId: snap.data!.serviceDetail!.id.validate()),
              ],
            ),
          ],
        );
      }
      return ServiceDetailShimmer();
    }

    return FutureBuilder<ServiceDetailResponse>(
      future: future,
      builder: (context, snap) {
        return Scaffold(
          bottomNavigationBar: allAppBottomSheet(context),
          endDrawer: const MyDrawer(),
          key: _scaffoldKey,
          backgroundColor: colors.backgroundColor,
          appBar: getAppBar(_scaffoldKey,
              title: widget.serviceName ?? '',
              context: context,
              setState: setStateNow),
          body: buildBodyWidget(snap),
        );
      },
    );
  }

  setStateNow() {
    setState(() {});
  }
}
