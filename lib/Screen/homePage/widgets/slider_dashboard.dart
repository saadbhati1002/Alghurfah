import 'package:eshop_multivendor/Helper/Color.dart';
import 'package:eshop_multivendor/Provider/homePageProvider.dart';
import 'package:eshop_multivendor/Screen/ProductList&SectionView/ProductList.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../Helper/Constant.dart';
import '../../../Model/Model.dart';
import '../../../Model/Section_Model.dart';
import '../../../widgets/desing.dart';
import '../../Product Detail/productDetail.dart';
import '../../SubCategory/SubCategory.dart';
import 'package:card_swiper/card_swiper.dart';

class CustomSliderDashBoard extends StatefulWidget {
  const CustomSliderDashBoard({
    Key? key,
  }) : super(key: key);

  @override
  State<CustomSliderDashBoard> createState() => _CustomSliderDashBoardState();
}

class _CustomSliderDashBoardState extends State<CustomSliderDashBoard> {
  final _controller = PageController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<HomePageProvider>(
      builder: (context, homeProvider, _) {
        List sliderData = [];

        for (int i = 0; i < homeProvider.homeSliderList.length; i++) {
          if (context.read<HomePageProvider>().homeSliderList[i].type ==
              'default') {
            sliderData.add(homeProvider.homeSliderList[i]);
          }
        }

        return homeProvider.sliderLoading
            ? sliderLoading(context)
            : homeProvider.homeSliderList.isEmpty
                ? Container()
                : SizedBox(
                    height: 200,
                    width: MediaQuery.of(context).size.width * 1,
                    child: Swiper(
                      // itemWidth: MediaQuery.of(context).size.width * 1,
                      itemBuilder: (context, index) {
                        final slider = sliderData[index];
                        return GestureDetector(
                          child: DesignConfiguration.getCacheNotworkImage(
                            imageurlString: slider.image!,
                            boxFit: BoxFit.fill,
                            context: context,
                            heightvalue: 200,
                            placeHolderSize: 50,
                            widthvalue: MediaQuery.of(context).size.width * 1,
                          ),
                        );
                      },
                      indicatorLayout: PageIndicatorLayout.COLOR,
                      autoplay: false,
                      itemCount: sliderData.length,

                      control:
                          const SwiperControl(color: colors.primary, size: 30),
                    ),
                  );
      },
    );
  }

  static Widget sliderLoading(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Theme.of(context).colorScheme.simmerBase,
      highlightColor: Theme.of(context).colorScheme.simmerHigh,
      child: Container(
        width: MediaQuery.of(context).size.width * 1,
        height: 200,
        color: Theme.of(context).colorScheme.white,
      ),
    );
  }

  Widget buildImagePageItem(Model slider) {
    double height = MediaQuery.of(context).size.width / 0.4;
    return GestureDetector(
      child: DesignConfiguration.getCacheNotworkImage(
          imageurlString: slider.image!,
          boxFit: BoxFit.fill,
          context: context,
          heightvalue: 200,
          placeHolderSize: 200,
          widthvalue: MediaQuery.of(context).size.width * 1),
      onTap: () async {
        int curSlider = context.read<HomePageProvider>().curSlider;

        if (context.read<HomePageProvider>().homeSliderList[curSlider].type ==
            'products') {
          Product? item =
              context.read<HomePageProvider>().homeSliderList[curSlider].list;

          Navigator.push(
            context,
            PageRouteBuilder(
              pageBuilder: (_, __, ___) => ProductDetail(
                model: item,
                secPos: 0,
                index: 0,
                list: true,
              ),
            ),
          );
        } else if (context
                .read<HomePageProvider>()
                .homeSliderList[curSlider]
                .type ==
            'categories') {
          Product item = context
              .read<HomePageProvider>()
              .homeSliderList[curSlider]
              .list as Product;
          if (item.subList == null || item.subList!.isEmpty) {
            Navigator.push(
              context,
              CupertinoPageRoute(
                builder: (context) => ProductList(
                  name: item.name,
                  id: item.id,
                  tag: false,
                  fromSeller: false,
                ),
              ),
            );
          } else {
            Navigator.push(
              context,
              CupertinoPageRoute(
                builder: (context) => SubCategory(
                  title: item.name!,
                  subList: item.subList,
                ),
              ),
            );
          }
        } else if (context
                .read<HomePageProvider>()
                .homeSliderList[curSlider]
                .type ==
            'slider_url') {
          String url = context
              .read<HomePageProvider>()
              .homeSliderList[curSlider]
              .urlLink
              .toString();
          try {
            if (await canLaunchUrl(Uri.parse(url))) {
              await launchUrl(Uri.parse(url),
                  mode: LaunchMode.externalApplication);
            } else {
              throw 'Could not launch $url';
            }
          } catch (e) {
            throw 'Something went wrong';
          }
        }
      },
    );
  }

  List<T> map<T>(List list, Function handler) {
    List<T> result = [];
    for (var i = 0; i < list.length; i++) {
      result.add(
        handler(i, list[i]),
      );
    }

    return result;
  }
}
