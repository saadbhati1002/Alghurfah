import 'package:eshop_multivendor/Helper/Color.dart';
import 'package:eshop_multivendor/Helper/Constant.dart';
import 'package:eshop_multivendor/Helper/String.dart';
import 'package:eshop_multivendor/Screen/Language/languageSettings.dart';
import 'package:eshop_multivendor/ServiceApp/component/back_widget.dart';
import 'package:eshop_multivendor/ServiceApp/component/loader_widget.dart';
import 'package:eshop_multivendor/ServiceApp/component/user_info_widget.dart';
import 'package:eshop_multivendor/ServiceApp/component/view_all_label_component.dart';
import 'package:eshop_multivendor/ServiceApp/screens/service/service_detail_screen.dart';
import 'package:eshop_multivendor/main.dart';
import 'package:eshop_multivendor/ServiceApp/model/provider_info_response.dart';
import 'package:eshop_multivendor/ServiceApp/model/service_data_model.dart';
import 'package:eshop_multivendor/ServiceApp/network/rest_apis.dart';
import 'package:eshop_multivendor/ServiceApp/screens/service/component/service_component.dart';
import 'package:eshop_multivendor/widgets/appBar.dart';
import 'package:eshop_multivendor/widgets/app_drawer.dart';
import 'package:eshop_multivendor/widgets/background_image.dart';
import 'package:eshop_multivendor/widgets/desing.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../component/empty_error_state_widget.dart';
import '../../utils/colors.dart';
import '../../utils/common.dart';
import '../../utils/images.dart';
import '../service/view_all_service_screen.dart';

class ProviderInfoScreen extends StatefulWidget {
  final int? providerId;
  final String? sellerName;
  final bool canCustomerContact;
  final VoidCallback? onUpdate;

  ProviderInfoScreen(
      {this.providerId,
      this.canCustomerContact = false,
      this.onUpdate,
      this.sellerName});

  @override
  ProviderInfoScreenState createState() => ProviderInfoScreenState();
}

class ProviderInfoScreenState extends State<ProviderInfoScreen> {
  Future<ProviderInfoResponse>? future;
  int page = 1;

  @override
  void initState() {
    super.initState();
    init();
  }

  Future<void> init() async {
    future = getProviderDetail(widget.providerId.validate(),
        userId: appStore.userId.validate());
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  Widget servicesWidget({required List<ServiceData> list, int? providerId}) {
    return Column(
      children: [
        // ViewAllLabel(
        //   label: language.service,
        //   list: list,
        //   onTap: () {
        //     ViewAllServiceScreen(providerId: providerId)
        //         .launch(context, pageRouteAnimation: PageRouteAnimation.Fade);
        //   },
        // ),
        // 8.height,
        if (list.isEmpty)
          NoDataWidget(
              title: language.lblNoServicesFound,
              imageWidget: const EmptyStateWidget()),
        if (list.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(right: 0, left: 0, top: 5),
            child: GridView.count(
              padding: const EdgeInsetsDirectional.only(top: 5),
              crossAxisCount: 2,
              shrinkWrap: true,
              childAspectRatio: 0.55,
              mainAxisSpacing: 5,
              crossAxisSpacing: 15,
              physics: const NeverScrollableScrollPhysics(),
              children: List.generate(
                list.length,
                (index) {
                  return serviceBox(
                    index,
                    list[index],
                  );
                },
              ),
            ),
          ),
        // AnimatedWrap(
        //   spacing: 16,
        //   runSpacing: 16,
        //   itemCount: list.length,
        //   listAnimationType: ListAnimationType.FadeIn,
        //   fadeInConfiguration: FadeInConfiguration(duration: 2.seconds),
        //   scaleConfiguration: ScaleConfiguration(
        //       duration: 300.milliseconds, delay: 50.milliseconds),
        //   itemBuilder: (_, index) => ServiceComponent(
        //       serviceData: list[index], width: context.width()),
        // )
      ],
    );
  }

  Widget serviceBox(index, ServiceData service) {
    double width = deviceWidth! * 0.5;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: InkWell(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Expanded(
              child: Stack(
                alignment: Alignment.bottomRight,
                clipBehavior: Clip.none,
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.only(
                      topRight: Radius.circular(20),
                      bottomLeft: Radius.circular(20),
                    ),
                    child: Hero(
                      tag: '$heroTagUniqueString$index${service.id}',
                      child: DesignConfiguration.getCacheNotworkImage(
                        boxFit: BoxFit.fill,
                        context: context,
                        heightvalue: double.maxFinite,
                        widthvalue: double.maxFinite,
                        placeHolderSize: width,
                        imageurlString: service.attachments != null
                            ? service.attachments!.first
                            : '',
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsetsDirectional.only(
                start: 10.0,
                top: 10,
              ),
              child: Text(
                service.name!,
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
                    ' ${DesignConfiguration.getPriceFormat(context, double.parse(service.price.toString()))!} AED',
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
                Navigator.push(
                  context,
                  PageRouteBuilder(
                    pageBuilder: (_, __, ___) => ServiceDetailScreen(
                      serviceId: service.id!,
                      service: service,
                      serviceName: service.name,
                    ),
                  ),
                );
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
        onTap: () {
          Navigator.push(
            context,
            PageRouteBuilder(
              pageBuilder: (_, __, ___) => ServiceDetailScreen(
                serviceId: service.id!,
                service: service,
              ),
            ),
          );
        },
      ),
    );
  }

  setStateNow() {
    setState(() {});
  }

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        finish(context);
        widget.onUpdate?.call();
        return Future.value(true);
      },
      child: Scaffold(
        endDrawer: const MyDrawer(),
        key: _scaffoldKey,
        backgroundColor: colors.backgroundColor,
        appBar: getAppBar(_scaffoldKey,
            title: widget.sellerName, context: context, setState: setStateNow),
        body: SnapHelperWidget<ProviderInfoResponse>(
          future: future,
          onSuccess: (data) {
            return Stack(
              children: [
                const BackgroundImage(),
                AnimatedScrollView(
                  listAnimationType: ListAnimationType.FadeIn,
                  physics: const AlwaysScrollableScrollPhysics(),
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                      height: 30,
                    ),
                    Container(
                      alignment: Alignment.topLeft,
                      color: colors.categoryDiscretion,
                      width: MediaQuery.of(context).size.width * .87,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(
                              height: 15,
                            ),
                            Text(
                              getTranslated(context, 'story')!,
                              style: const TextStyle(
                                  fontSize: 14,
                                  color: colors.eCommerceColor,
                                  fontWeight: FontWeight.w700),
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            Text(
                              data.userData!.description ?? '',
                              textAlign: TextAlign.justify,
                              style: const TextStyle(
                                  fontSize: 12,
                                  color: colors.eCommerceColor,
                                  fontWeight: FontWeight.w600),
                            ),
                            const SizedBox(
                              height: 15,
                            ),
                          ],
                        ),
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // if (data.userData!.knownLanguagesArray.isNotEmpty)
                        //   Column(
                        //     crossAxisAlignment: CrossAxisAlignment.start,
                        //     children: [
                        //       Text(language.knownLanguages,
                        //           style: boldTextStyle()),
                        //       8.height,
                        //       Wrap(
                        //         children:
                        //             data.userData!.knownLanguagesArray.map((e) {
                        //           return Container(
                        //             decoration: boxDecorationWithRoundedCorners(
                        //               borderRadius: const BorderRadius.all(
                        //                   Radius.circular(4)),
                        //               backgroundColor: appStore.isDarkMode
                        //                   ? cardDarkColor
                        //                   : primaryColor.withOpacity(0.1),
                        //             ),
                        //             padding: const EdgeInsets.symmetric(
                        //                 horizontal: 8, vertical: 4),
                        //             margin: EdgeInsets.all(4),
                        //             child: Text(e,
                        //                 style: secondaryTextStyle(
                        //                     size: 12, weight: FontWeight.bold)),
                        //           );
                        //         }).toList(),
                        //       ),
                        //       16.height,
                        //     ],
                        //   ),
                        // if (data.userData!.skillsArray.isNotEmpty)
                        //   Column(
                        //     crossAxisAlignment: CrossAxisAlignment.start,
                        //     children: [
                        //       Text(language.essentialSkills,
                        //           style: boldTextStyle()),
                        //       8.height,
                        //       Wrap(
                        //         children: data.userData!.skillsArray.map((e) {
                        //           return Container(
                        //             decoration: boxDecorationWithRoundedCorners(
                        //               borderRadius:
                        //                   BorderRadius.all(Radius.circular(4)),
                        //               backgroundColor: appStore.isDarkMode
                        //                   ? cardDarkColor
                        //                   : primaryColor.withOpacity(0.1),
                        //             ),
                        //             padding: EdgeInsets.symmetric(
                        //                 horizontal: 8, vertical: 4),
                        //             margin: EdgeInsets.all(4),
                        //             child: Text(e,
                        //                 style: secondaryTextStyle(
                        //                     size: 12, weight: FontWeight.bold)),
                        //           );
                        //         }).toList(),
                        //       ),
                        //       16.height,
                        //     ],
                        //   ),
                        // if (data.userData!.description != null)
                        //   Column(
                        //     crossAxisAlignment: CrossAxisAlignment.start,
                        //     children: [
                        //       Text(language.lblAboutProvider,
                        //           style: boldTextStyle()),
                        //       8.height,
                        //       Text(data.userData!.description.validate(),
                        //           style: secondaryTextStyle()),
                        //       16.height,
                        //     ],
                        //   ),
                        // if (widget.canCustomerContact)
                        //   Column(
                        //     crossAxisAlignment: CrossAxisAlignment.start,
                        //     children: [
                        //       Text(language.personalInfo,
                        //           style: boldTextStyle()),
                        //       8.height,
                        //       TextIcon(
                        //         spacing: 10,
                        //         onTap: () {
                        //           launchMail(
                        //               "${data.userData!.email.validate()}");
                        //         },
                        //         prefix: Image.asset(ic_message,
                        //             width: 16,
                        //             height: 16,
                        //             color: appStore.isDarkMode
                        //                 ? Colors.white
                        //                 : context.primaryColor),
                        //         text: data.userData!.email.validate(),
                        //         textStyle: secondaryTextStyle(size: 16),
                        //         expandedText: true,
                        //       ),
                        //       4.height,
                        //       TextIcon(
                        //         spacing: 10,
                        //         onTap: () {
                        //           launchCall(
                        //               "${data.userData!.contactNumber.validate()}");
                        //         },
                        //         prefix: Image.asset(ic_calling,
                        //             width: 16,
                        //             height: 16,
                        //             color: appStore.isDarkMode
                        //                 ? Colors.white
                        //                 : context.primaryColor),
                        //         text: data.userData!.contactNumber.validate(),
                        //         textStyle: secondaryTextStyle(size: 16),
                        //         expandedText: true,
                        //       ),
                        //       8.height,
                        //     ],
                        //   ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            GestureDetector(
                              onTap: () {
                                // Navigator.pop(context, 'option 1');
                              },
                              child: Container(
                                alignment: Alignment.center,
                                height:
                                    MediaQuery.of(context).size.height * .15,
                                width: MediaQuery.of(context).size.width * .27,
                                decoration: const BoxDecoration(
                                    color: colors.categoryNewIn,
                                    borderRadius: BorderRadius.only(
                                        topRight: Radius.circular(20),
                                        bottomLeft: Radius.circular(20))),
                                child: SingleChildScrollView(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      textWidget(
                                          getTranslated(context, 'new_in')!),
                                      textWidget(
                                          getTranslated(context, 'new_in')!),
                                      Text(
                                        getTranslated(context, 'new_in')!,
                                        style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white),
                                      ),
                                      textWidget(
                                          getTranslated(context, 'new_in')!),
                                      textWidget(
                                          getTranslated(context, 'new_in')!),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            GestureDetector(
                              onTap: () {},
                              child: Container(
                                alignment: Alignment.center,
                                height:
                                    MediaQuery.of(context).size.height * .15,
                                width: MediaQuery.of(context).size.width * .27,
                                decoration: const BoxDecoration(
                                  color: colors.serviceColor,
                                  borderRadius: BorderRadius.only(
                                    topRight: Radius.circular(20),
                                    bottomLeft: Radius.circular(20),
                                  ),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 10),
                                  child: Container(
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                          width: 1, color: Colors.white),
                                      borderRadius: const BorderRadius.only(
                                        topRight: Radius.circular(20),
                                        bottomLeft: Radius.circular(20),
                                      ),
                                    ),
                                    child: Text(
                                      getTranslated(context, 'best_seller')!,
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            GestureDetector(
                              onTap: () {},
                              child: Container(
                                alignment: Alignment.center,
                                height:
                                    MediaQuery.of(context).size.height * .15,
                                width: MediaQuery.of(context).size.width * .27,
                                decoration: const BoxDecoration(
                                  color: colors.eCommerceColor,
                                  borderRadius: BorderRadius.only(
                                    topRight: Radius.circular(20),
                                    bottomLeft: Radius.circular(20),
                                  ),
                                ),
                                child: SingleChildScrollView(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      textWidget(
                                          getTranslated(context, 'sale')!),
                                      textWidget(
                                          getTranslated(context, 'sale')!),
                                      Text(
                                        getTranslated(context, 'sale')!,
                                        style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white),
                                      ),
                                      textWidget(
                                          getTranslated(context, 'sale')!),
                                      textWidget(
                                          getTranslated(context, 'sale')!),
                                    ],
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                        servicesWidget(
                            list: data.serviceList!,
                            providerId: widget.providerId.validate()),
                      ],
                    ).paddingAll(16),
                  ],
                  onSwipeRefresh: () async {
                    page = 1;

                    init();
                    setState(() {});

                    return await 2.seconds.delay;
                  },
                ),
                Observer(
                    builder: (context) =>
                        LoaderWidget().visible(appStore.isLoading))
              ],
            );
          },
          loadingWidget: LoaderWidget(),
          errorBuilder: (error) {
            return NoDataWidget(
              title: error,
              imageWidget: ErrorStateWidget(),
              retryText: language.reload,
              onRetry: () {
                page = 1;
                appStore.setLoading(true);

                init();
                setState(() {});
              },
            );
          },
        ),
      ),
    );
  }

  Widget textWidget(String text) {
    return Text(
      text,
      style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: Colors.white.withOpacity(0.6)),
    );
  }
}
