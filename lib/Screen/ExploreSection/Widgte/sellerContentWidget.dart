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

class ShowContentOfSellers extends StatefulWidget {
  List<Product> sellerList;
  List? sellerCategory;
  final List<Product>? subList;
  ShowContentOfSellers(
      {Key? key, required this.sellerList, this.sellerCategory, this.subList})
      : super(key: key);

  @override
  State<ShowContentOfSellers> createState() => _ShowContentOfSellersState();
}

class _ShowContentOfSellersState extends State<ShowContentOfSellers> {
  List<Product> newList = [];
  @override
  void initState() {
    if (widget.sellerCategory != null) {
      checkData();
    } else {
      newList.addAll(widget.sellerList);
      setState(() {});
    }
    super.initState();
  }

  checkData() {
    newList = widget.sellerList;
    // for (int i = 0; i < widget.sellerList.length; i++) {
    //   if (widget.sellerCategory![i] == 1) {
    //     newList.add(widget.sellerList[i]);
    //   }
    // }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    print(widget.sellerList);

    return newList.isNotEmpty
        ? SizedBox(
            // height: 100,
            width: MediaQuery.of(context).size.width,
            child: GridView.builder(
              padding: const EdgeInsets.all(20),
              physics: const AlwaysScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 8,
                  childAspectRatio: .68,
                  crossAxisSpacing: 8),
              shrinkWrap: true,
              controller: sellerListController,
              itemCount: newList.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(
                              top: 8, bottom: 8, right: 15, left: 15),
                          child: ClipRRect(
                            borderRadius: const BorderRadius.only(
                                topRight: Radius.circular(25),
                                bottomLeft: Radius.circular(25)),
                            child: Container(
                              color: Colors.white,
                              child: DesignConfiguration.getCacheNotworkImage(
                                boxFit: BoxFit.fill,
                                context: context,
                                heightvalue: null,
                                widthvalue: MediaQuery.of(context).size.width,
                                placeHolderSize:
                                    MediaQuery.of(context).size.height,
                                imageurlString: newList[index].seller_profile!,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 0),
                        child: Text(
                          newList[index].store_name!,
                          textAlign: TextAlign.center,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style:
                              Theme.of(context).textTheme.bodySmall!.copyWith(
                                    color: Colors.black,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    fontFamily: 'ubuntu',
                                  ),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        child: Container(
                          height: 25,
                          width: MediaQuery.of(context).size.width,
                          decoration: const BoxDecoration(
                            color: colors.eCommerceColor,
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
                  onTap: () async {
                    List<SellerSubCategory> subCatList = [];
                    if (newList[index].sellerCategory != null &&
                        newList[index].sellerCategory!.isNotEmpty) {
                      for (int i = 0;
                          i < newList[index].sellerCategory!.length;
                          i++) {
                        if (newList[index].sellerCategory![i].subCategory !=
                                null &&
                            newList[index]
                                .sellerCategory![i]
                                .subCategory!
                                .isNotEmpty) {
                          for (int j = 0;
                              j <
                                  newList[index]
                                      .sellerCategory![i]
                                      .subCategory!
                                      .length;
                              j++) {
                            subCatList.add(newList[index]
                                .sellerCategory![i]
                                .subCategory![j]);
                          }
                        }
                      }
                    }
                    print(subCatList.length);
                    Routes.navigateToSellerProfileScreen(
                        context,
                        newList[index].seller_id!,
                        newList[index].seller_profile!,
                        newList[index].seller_name!,
                        newList[index].seller_rating!,
                        newList[index].store_name!,
                        newList[index].store_description!,
                        newList[index].totalProductsOfSeller,
                        newList[index].sellerRatingType,
                        widget.subList,
                        subCatList);
                  },
                );
              },
            ),
          )
        : Center(
            child: Text(
              getTranslated(context, 'No Seller/Store Found')!,
              style: const TextStyle(
                  fontFamily: 'ubuntu',
                  color: Colors.black,
                  fontSize: 18,
                  fontWeight: FontWeight.w500),
            ),
          );
  }
}
