import 'package:eshop_multivendor/Helper/Color.dart';
import 'package:eshop_multivendor/Helper/String.dart';
import 'package:eshop_multivendor/Helper/routes.dart';
import 'package:eshop_multivendor/Model/favorite_seller_model.dart';
import 'package:eshop_multivendor/Screen/Language/languageSettings.dart';
import 'package:eshop_multivendor/ServiceApp/component/empty_error_state_widget.dart';
import 'package:eshop_multivendor/ServiceApp/component/loader_widget.dart';
import 'package:eshop_multivendor/main.dart';
import 'package:eshop_multivendor/repository/sellerDetailRepositry.dart';
import 'package:eshop_multivendor/widgets/background_image.dart';
import 'package:eshop_multivendor/widgets/desing.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:nb_utils/nb_utils.dart';

class FavoriteSellersScreen extends StatefulWidget {
  const FavoriteSellersScreen({Key? key}) : super(key: key);

  @override
  State<FavoriteSellersScreen> createState() => _FavoriteSellersScreenState();
}

class _FavoriteSellersScreenState extends State<FavoriteSellersScreen> {
  List<Data> favoriteList = [];
  bool isLoading = false;
  @override
  void initState() {
    if (CUR_USERID != null) {
      getFavoriteList();
    }
    super.initState();
  }

  getFavoriteList() async {
    try {
      setState(() {
        isLoading = true;
      });
      Favorite response = await SellerDetailRepository.getFollowedSellers(
          parameter: {'user_id': CUR_USERID});
      setState(() {
        favoriteList = response.data!;
      });
    } catch (e) {
      debugPrint(e.toString());
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
      children: [
        const BackgroundImage(),
        isLoading == false
            ? favoriteList.isNotEmpty
                ? SizedBox(
                    child: SingleChildScrollView(
                      child: SizedBox(
                        // height: 100,
                        width: MediaQuery.of(context).size.width,
                        child: GridView.builder(
                          padding: const EdgeInsets.all(20),
                          physics: const NeverScrollableScrollPhysics(),
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  mainAxisSpacing: 8,
                                  childAspectRatio: .68,
                                  crossAxisSpacing: 8),
                          shrinkWrap: true,
                          itemCount: favoriteList.length,
                          itemBuilder: (context, index) {
                            return GestureDetector(
                              child: Column(
                                children: [
                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: ClipRRect(
                                        borderRadius: const BorderRadius.only(
                                            topRight: Radius.circular(25),
                                            bottomLeft: Radius.circular(25)),
                                        child: Container(
                                          width:
                                              MediaQuery.of(context).size.width,
                                          decoration: BoxDecoration(
                                            color: context.cardColor,
                                          ),
                                          child: DesignConfiguration
                                              .getCacheNotworkImage(
                                            boxFit: BoxFit.fill,
                                            context: context,
                                            heightvalue: null,
                                            widthvalue: null,
                                            placeHolderSize: 50,
                                            imageurlString:
                                                favoriteList[index].logo!,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Text(
                                    favoriteList[index].storeName!,
                                    textAlign: TextAlign.center,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodySmall!
                                        .copyWith(
                                          color: Colors.black,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                          fontFamily: 'ubuntu',
                                        ),
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(right: 15),
                                    child: Container(
                                      height: 28,
                                      width: MediaQuery.of(context).size.width,
                                      decoration: const BoxDecoration(
                                        color: colors.serviceColor,
                                        borderRadius: BorderRadius.only(
                                            topRight: Radius.circular(20),
                                            bottomLeft: Radius.circular(20)),
                                      ),
                                      alignment: Alignment.center,
                                      child: Text(
                                        getTranslated(context, 'View')!,
                                        style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 14,
                                            fontWeight: FontWeight.w500),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                ],
                              ),
                              onTap: () {
                                Routes.navigateToSellerProfileScreen(
                                    context,
                                    favoriteList[index].userId!,
                                    favoriteList[index].logo!,
                                    favoriteList[index].storeName!,
                                    favoriteList[index].rating!,
                                    favoriteList[index].storeName!,
                                    favoriteList[index].storeDescription!,
                                    '0', []);
                              },
                            );
                          },
                        ),
                      ),
                    ),
                  )
                : NoDataWidget(
                    title: language.noProviderFound,
                    subTitle: language.noProviderFoundMessage,
                    imageWidget: const EmptyStateWidget(),
                  )
            : Observer(
                builder: (BuildContext context) =>
                    LoaderWidget().visible(isLoading)),
      ],
    ));
  }
}
