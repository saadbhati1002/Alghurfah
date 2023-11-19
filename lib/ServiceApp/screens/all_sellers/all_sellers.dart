import 'package:eshop_multivendor/Helper/Color.dart';
import 'package:eshop_multivendor/Screen/Language/languageSettings.dart';
import 'package:eshop_multivendor/ServiceApp/component/cached_image_widget.dart';
import 'package:eshop_multivendor/ServiceApp/component/loader_widget.dart';
import 'package:eshop_multivendor/ServiceApp/model/all_selllers/all_sellers_model.dart';
import 'package:eshop_multivendor/ServiceApp/screens/booking/provider_info_screen.dart';
import 'package:eshop_multivendor/ServiceApp/utils/constant.dart';
import 'package:eshop_multivendor/main.dart';
import 'package:eshop_multivendor/widgets/appBar.dart';
import 'package:eshop_multivendor/widgets/app_drawer.dart';
import 'package:eshop_multivendor/widgets/background_image.dart';
import 'package:eshop_multivendor/widgets/bottomNavigationSheet.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import '../../model/category_model.dart';
import '../../model/service_data_model.dart';
import '../../network/rest_apis.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

class AllSellersScreen extends StatefulWidget {
  final int? categoryId;
  final String? categoryName;
  final String isFeatured;
  final bool isFromProvider;
  final bool isFromCategory;
  final int? providerId;

  const AllSellersScreen({
    this.categoryId,
    this.categoryName = '',
    this.isFeatured = '',
    this.isFromProvider = true,
    this.isFromCategory = false,
    this.providerId,
    Key? key,
  });

  @override
  State<AllSellersScreen> createState() => _AllSellersScreenState();
}

class _AllSellersScreenState extends State<AllSellersScreen> {
  Future<List<CategoryData>>? futureCategory;
  List<CategoryData> categoryList = [];
  List<Data> allSellersData = [];
  CategoryData allValue = CategoryData(id: -1, name: language.lblAll);
  final GlobalKey<ScaffoldState> _key = GlobalKey();
  Future<List<ServiceData>>? futureService;
  List<ServiceData> serviceList = [];
  bool isLoading = false;
  FocusNode myFocusNode = FocusNode();
  TextEditingController searchCont = TextEditingController();

  int? subCategory;

  int page = 1;
  bool isLastPage = false;

  @override
  void initState() {
    init();

    _getSellers();
    super.initState();
  }

  _getSellers() async {
    try {
      setState(() {
        isLoading = true;
      });
      AllSellersRes response = await getAllSellers();
      print(response.data!.length);
      if (response.data!.isNotEmpty) {
        setState(() {
          allSellersData = response.data!;
        });
      }
    } catch (e) {
      debugPrint(e.toString());
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  setStateNow() {
    setState(() {});
  }

  void init() async {
    fetchAllServiceData();

    if (widget.categoryId != null) {
      fetchCategoryList();
    }
  }

  void fetchCategoryList() async {
    futureCategory = getSubCategoryListAPI(catId: widget.categoryId!);
  }

  void fetchAllServiceData() async {
    futureService = searchServiceAPI(
      page: page,
      list: serviceList,
      categoryId: widget.categoryId != null
          ? widget.categoryId.validate().toString()
          : '',
      subCategory: subCategory != null ? subCategory.validate().toString() : '',
      providerId: widget.providerId != null
          ? widget.providerId.toString()
          : filterStore.providerId.join(","),
      isPriceMin: filterStore.isPriceMin,
      isPriceMax: filterStore.isPriceMax,
      search: filterStore.search,
      latitude: filterStore.latitude,
      longitude: filterStore.longitude,
      lastPageCallBack: (p0) {
        isLastPage = p0;
      },
      isFeatured: widget.isFeatured,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colors.backgroundColor,
      endDrawer: const MyDrawer(),
      key: _key,
      appBar: getAppBar(_key,
          title: getTranslated(context, 'service')!,
          context: context,
          setState: setStateNow),
      bottomNavigationBar: allAppBottomSheet(context),
      body: Stack(
        children: [
          const BackgroundImage(),
          SizedBox(
            child: SingleChildScrollView(
              child: SizedBox(
                // height: 100,
                width: MediaQuery.of(context).size.width,
                child: GridView.builder(
                  padding: const EdgeInsets.all(20),
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: 8,
                      childAspectRatio: .68,
                      crossAxisSpacing: 8),
                  shrinkWrap: true,
                  itemCount: allSellersData.length,
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
                                    width: MediaQuery.of(context).size.width,
                                    decoration: BoxDecoration(
                                      color: context.cardColor,
                                    ),
                                    child: CachedImageWidget(
                                      radius: 0,
                                      url: allSellersData[index]
                                          .profileImage
                                          .validate(),
                                      fit: BoxFit.fitWidth,
                                      width: SUBCATEGORY_ICON_SIZE,
                                      height: SUBCATEGORY_ICON_SIZE,
                                      circle: true,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Text(
                              allSellersData[index].displayName!,
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
                          ProviderInfoScreen(
                            providerId: allSellersData[index].id,
                            sellerName: allSellersData[index].displayName,
                          ).launch(context);
                          setStatusBarColor(Colors.transparent);
                        });
                  },
                ),
              ),
            ),
          ),
          Observer(
              builder: (BuildContext context) =>
                  LoaderWidget().visible(isLoading)),
        ],
      ),
    );
  }
}
