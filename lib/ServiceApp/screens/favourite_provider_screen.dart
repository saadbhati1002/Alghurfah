import 'package:eshop_multivendor/ServiceApp/component/back_widget.dart';
import 'package:eshop_multivendor/ServiceApp/component/loader_widget.dart';
import 'package:eshop_multivendor/main.dart';
import 'package:eshop_multivendor/ServiceApp/model/user_data_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:eshop_multivendor/Helper/Color.dart';
import 'package:eshop_multivendor/widgets/appBar.dart';
import 'package:eshop_multivendor/widgets/app_drawer.dart';

import '../component/empty_error_state_widget.dart';
import '../component/favourite_provider_component.dart';
import '../network/rest_apis.dart';
import 'shimmer/favourite_provider_shimmer.dart';

class FavouriteProviderScreen extends StatefulWidget {
  const FavouriteProviderScreen({Key? key}) : super(key: key);

  @override
  _FavouriteProviderScreenState createState() =>
      _FavouriteProviderScreenState();
}

class _FavouriteProviderScreenState extends State<FavouriteProviderScreen> {
  Future<List<UserData>>? future;
  final GlobalKey<ScaffoldState> _key = GlobalKey();

  List<UserData> providers = [];

  int page = 1;

  bool isLastPage = false;

  @override
  void initState() {
    super.initState();
    init();
  }

  Future<void> init() async {
    future =
        getProviderWishlist(page, providers: providers, lastPageCallBack: (p0) {
      isLastPage = p0;
    });
  }

  setStateNow() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      endDrawer: const MyDrawer(),
      key: _key,
      backgroundColor: colors.backgroundColor,
      appBar: getAppBar(_key,
          title: language.favouriteProvider,
          context: context,
          setState: setStateNow),
      body: Stack(
        children: [
          FutureBuilder<List<UserData>>(
            future: future,
            builder: (context, snap) {
              if (snap.hasData) {
                if (snap.data.validate().isEmpty)
                  return NoDataWidget(
                    title: language.noProviderFound,
                    subTitle: language.noProviderFoundMessage,
                    imageWidget: EmptyStateWidget(),
                  );
                return AnimatedScrollView(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 60),
                  listAnimationType: ListAnimationType.FadeIn,
                  fadeInConfiguration: FadeInConfiguration(duration: 2.seconds),
                  physics: const AlwaysScrollableScrollPhysics(),
                  onNextPage: () {
                    if (!isLastPage) {
                      page++;
                      appStore.setLoading(true);

                      init();
                      setState(() {});
                    }
                  },
                  onSwipeRefresh: () async {
                    page = 1;

                    init();
                    setState(() {});

                    return await 2.seconds.delay;
                  },
                  children: [
                    AnimatedWrap(
                      spacing: 16,
                      runSpacing: 16,
                      listAnimationType: ListAnimationType.FadeIn,
                      fadeInConfiguration:
                          FadeInConfiguration(duration: 2.seconds),
                      scaleConfiguration: ScaleConfiguration(
                          duration: 300.milliseconds, delay: 50.milliseconds),
                      itemCount: snap.data!.length,
                      itemBuilder: (_, index) {
                        return FavouriteProviderComponent(
                          data: snap.data![index],
                          width: context.width() * 0.5 - 26,
                          onUpdate: () {
                            page = 1;
                            init();
                            setState(() {});
                          },
                        );
                      },
                    ),
                  ],
                );
              }

              return snapWidgetHelper(
                snap,
                loadingWidget: FavouriteProviderShimmer(),
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
              );
            },
          ),
          Observer(
              builder: (context) => LoaderWidget().visible(appStore.isLoading)),
        ],
      ),
    );
  }
}
