import 'package:eshop_multivendor/Screen/Language/languageSettings.dart';
import 'package:eshop_multivendor/ServiceApp/component/back_widget.dart';
import 'package:eshop_multivendor/ServiceApp/component/loader_widget.dart';
import 'package:eshop_multivendor/main.dart';
import 'package:eshop_multivendor/ServiceApp/model/category_model.dart';
import 'package:eshop_multivendor/ServiceApp/network/rest_apis.dart';
import 'package:eshop_multivendor/ServiceApp/screens/category/shimmer/category_shimmer.dart';
import 'package:eshop_multivendor/ServiceApp/screens/dashboard/component/category_widget.dart';
import 'package:eshop_multivendor/ServiceApp/utils/colors.dart';
import 'package:eshop_multivendor/widgets/appBar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:eshop_multivendor/Helper/Color.dart';
import '../../component/empty_error_state_widget.dart';
import '../service/view_all_service_screen.dart';

class CategoryScreen extends StatefulWidget {
  @override
  _CategoryScreenState createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  late Future<List<CategoryData>> future;
  List<CategoryData> categoryList = [];

  int page = 1;
  bool isLastPage = false;
  bool isApiCalled = false;

  UniqueKey key = UniqueKey();

  void initState() {
    super.initState();
    init();
  }

  void init() async {
    future = getCategoryListWithPagination(page, categoryList: categoryList,
        lastPageCallBack: (val) {
      isLastPage = val;
    });
    if (page == 1) {
      key = UniqueKey();
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  setStateNow() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colors.backgroundColor,
      appBar: getAppBar(
          title: getTranslated(context, 'Ecom')!,
          context: context,
          setState: setStateNow),
      body: Stack(
        children: [
          SnapHelperWidget<List<CategoryData>>(
            initialData: cachedCategoryList,
            future: future,
            loadingWidget: CategoryShimmer(),
            onSuccess: (snap) {
              if (snap.isEmpty) {
                return NoDataWidget(
                  title: language.noCategoryFound,
                  retryText: language.reload,
                  onRetry: () {
                    page = 1;
                    appStore.setLoading(true);

                    init();
                    setState(() {});
                  },
                );
              }
              return ListView.builder(
                  shrinkWrap: true,
                  scrollDirection: Axis.vertical,
                  padding:
                      const EdgeInsetsDirectional.only(top: 10.0, bottom: 15),
                  itemCount: snap.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding:
                          const EdgeInsets.only(top: 15, left: 25, right: 25),
                      child: GestureDetector(
                        onTap: () {
                          ViewAllServiceScreen(
                                  categoryId: snap[index].id.validate(),
                                  categoryName: snap[index].name,
                                  isFromCategory: true)
                              .launch(context);
                        },
                        child: SizedBox(
                          height: 130,
                          width: MediaQuery.of(context).size.width,
                          child: Stack(
                            children: [
                              SizedBox(
                                height: 130,
                                width: MediaQuery.of(context).size.width,
                                child: ClipRRect(
                                  borderRadius: const BorderRadius.only(
                                      topRight: Radius.circular(30),
                                      bottomLeft: Radius.circular(30)),
                                  child: Image.asset(
                                    'assets/images/png/service_cat.png',
                                    fit: BoxFit.fill,
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 130,
                                width: MediaQuery.of(context).size.width,
                                child: Container(
                                  margin: const EdgeInsets.all(10.0),
                                  child: Container(
                                    decoration: BoxDecoration(
                                        borderRadius: const BorderRadius.only(
                                            topRight: Radius.circular(30),
                                            bottomLeft: Radius.circular(30)),
                                        border: Border.all(
                                            width: 2,
                                            color: colors.serviceColor)),
                                    child: Container(
                                      decoration: BoxDecoration(
                                          borderRadius: const BorderRadius.only(
                                              topRight: Radius.circular(30),
                                              bottomLeft: Radius.circular(30)),
                                          border: Border.all(
                                              width: 1,
                                              color: colors.serviceColor)),
                                      margin: const EdgeInsets.all(3.0),
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 15),
                                            child: Container(
                                              height: 65,
                                              width: 65,
                                              decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                color: Colors.white,
                                                image: DecorationImage(
                                                  image: NetworkImage(
                                                      snap[index]
                                                          .categoryImage!),
                                                ),
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                .52,
                                            child: Text(
                                              '${snap[index].name}',
                                              textAlign: TextAlign.center,
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .headlineSmall!
                                                  .copyWith(
                                                      fontFamily: 'ubuntu',
                                                      color:
                                                          colors.serviceColor,
                                                      fontWeight:
                                                          FontWeight.w600),
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    );
                  });
              // return AnimatedScrollView(
              //   onSwipeRefresh: () async {
              //     page = 1;

              //     init();
              //     setState(() {});

              //     return await 2.seconds.delay;
              //   },
              //   physics: AlwaysScrollableScrollPhysics(),
              //   padding: EdgeInsets.all(16),
              //   listAnimationType: ListAnimationType.FadeIn,
              //   fadeInConfiguration: FadeInConfiguration(duration: 2.seconds),
              //   onNextPage: () {
              //     if (!isLastPage) {
              //       page++;
              //       appStore.setLoading(true);

              //       init();
              //       setState(() {});
              //     }
              //   },
              //   children: [
              //     AnimatedWrap(
              //       key: key,
              //       runSpacing: 16,
              //       spacing: 16,
              //       itemCount: snap.length,
              //       listAnimationType: ListAnimationType.FadeIn,
              //       fadeInConfiguration:
              //           FadeInConfiguration(duration: 2.seconds),
              //       scaleConfiguration: ScaleConfiguration(
              //           duration: 300.milliseconds, delay: 50.milliseconds),
              //       itemBuilder: (_, index) {
              //         CategoryData data = snap[index];

              //         return GestureDetector(
              //           onTap: () {
              //             ViewAllServiceScreen(
              //                     categoryId: data.id.validate(),
              //                     categoryName: data.name,
              //                     isFromCategory: true)
              //                 .launch(context);
              //           },
              //           child: CategoryWidget(
              //               categoryData: data,
              //               width: context.width() / 4 - 20),
              //         );
              //       },
              //     ),
              //   ],
              // );
            },
            errorBuilder: (error) {
              return NoDataWidget(
                title: error,
                imageWidget: const ErrorStateWidget(),
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
          Observer(
              builder: (BuildContext context) =>
                  LoaderWidget().visible(appStore.isLoading.validate())),
        ],
      ),
    );
  }
}
