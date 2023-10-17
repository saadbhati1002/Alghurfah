import 'package:eshop_multivendor/Helper/Color.dart';
import 'package:eshop_multivendor/Provider/homePageProvider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../Helper/Constant.dart';
import '../../../Helper/routes.dart';
import '../../../Model/Section_Model.dart';
import '../../../widgets/desing.dart';
import '../../Language/languageSettings.dart';
import '../../../widgets/star_rating.dart';
import '../explore.dart';

class ShowContentOfSellers extends StatelessWidget {
  List<Product> sellerList;
  ShowContentOfSellers({Key? key, required this.sellerList}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return sellerList.isNotEmpty
        ? SizedBox(
            // height: 100,
            width: MediaQuery.of(context).size.width,
            child: GridView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              physics: const AlwaysScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  mainAxisSpacing: 8,
                  childAspectRatio: 1.03,
                  crossAxisSpacing: 8),
              shrinkWrap: true,
              controller: sellerListController,
              itemCount: sellerList.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.only(top: 0),
                  child: Card(
                    elevation: 0,
                    color: Theme.of(context).colorScheme.white,
                    child: ListTile(
                      title: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ClipRRect(
                            borderRadius:
                                BorderRadius.circular(circularBorderRadius7),
                            child: sellerList[index].seller_profile == ''
                                ? Image.asset(
                                    DesignConfiguration.setPngPath(
                                        'placeholder'),
                                    width: 65,
                                    height: 65,
                                    fit: BoxFit.cover,
                                  )
                                : DesignConfiguration.getCacheNotworkImage(
                                    context: context,
                                    boxFit: BoxFit.cover,
                                    heightvalue: 60,
                                    widthvalue: 60,
                                    placeHolderSize: 65,
                                    imageurlString:
                                        sellerList[index].seller_profile!,
                                  ),
                          ),
                          const SizedBox(
                            height: 6,
                          ),
                          Text(
                            sellerList[index].store_name!,
                            textAlign: TextAlign.center,
                            style: Theme.of(context)
                                .textTheme
                                .titleSmall!
                                .copyWith(
                                  color:
                                      Theme.of(context).colorScheme.lightBlack,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'ubuntu',
                                ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                      onTap: () async {
                        Routes.navigateToSellerProfileScreen(
                          context,
                          sellerList[index].seller_id!,
                          sellerList[index].seller_profile!,
                          sellerList[index].seller_name!,
                          sellerList[index].seller_rating!,
                          sellerList[index].store_name!,
                          sellerList[index].store_description!,
                          sellerList[index].totalProductsOfSeller,
                        );
                      },
                    ),
                  ),
                );
              },
            ),
          )
        : Selector<HomePageProvider, bool>(
            builder: (context, data, child) {
              return !data
                  ? Center(
                      child: Text(
                        getTranslated(context, 'No Seller/Store Found')!,
                        style: const TextStyle(
                          fontFamily: 'ubuntu',
                        ),
                      ),
                    )
                  : Container();
            },
            selector: (_, provider) => provider.sellerLoading,
          );
  }
}
