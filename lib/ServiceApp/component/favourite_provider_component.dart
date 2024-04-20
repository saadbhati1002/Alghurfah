import 'package:eshop_multivendor/Helper/Color.dart';
import 'package:eshop_multivendor/Screen/Language/languageSettings.dart';
import 'package:eshop_multivendor/ServiceApp/screens/booking/provider_info_screen.dart';
import 'package:eshop_multivendor/ServiceApp/utils/constant.dart';
import 'package:eshop_multivendor/main.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import '../model/user_data_model.dart';
import '../network/rest_apis.dart';
import 'cached_image_widget.dart';

class FavoriteProviderComponent extends StatefulWidget {
  final double width;
  final UserData? data;
  final Function? onUpdate;
  final bool isFavoriteProvider;

  const FavoriteProviderComponent(
      {required this.width,
      this.data,
      this.onUpdate,
      this.isFavoriteProvider = true});

  @override
  State<FavoriteProviderComponent> createState() =>
      _FavoriteProviderComponentState();
}

class _FavoriteProviderComponentState extends State<FavoriteProviderComponent> {
  //Favourite provider
  Future<bool> addProviderToWishList({required int providerId}) async {
    Map req = {"id": "", "provider_id": providerId, "user_id": appStore.userId};
    return await addProviderWishList(req).then((res) {
      toast(res.message!);
      //toast('Added favourite Provider');
      return true;
    }).catchError((error) {
      toast(error.toString());
      return false;
    });
  }

  Future<bool> removeProviderToWishList({required int providerId}) async {
    Map req = {"user_id": appStore.userId, 'provider_id': providerId};

    return await removeProviderWishList(req).then((res) {
      toast(res.message!);
      //toast('Remove favourite Provider');
      return true;
    }).catchError((error) {
      toast(error.toString());
      return false;
    });
  }

  @override
  void initState() {
    super.initState();
    init();
  }

  void init() async {}

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: SizedBox(
        height: MediaQuery.of(context).size.height * .35,
        width: 100,
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
                      url: widget.data!.profileImage.validate(),
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
              widget.data!.displayName ?? '',
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.bodySmall!.copyWith(
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
      ),
      onTap: () async {
        await ProviderInfoScreen(
          providerId: widget.data!.providerId,
          sellerName: widget.data!.displayName,
        ).launch(context);
        setStatusBarColor(Colors.transparent);
      },
    );
  }
}
