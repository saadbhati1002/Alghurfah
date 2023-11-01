import 'package:eshop_multivendor/Model/Section_Model.dart';
import 'package:eshop_multivendor/Screen/Language/languageSettings.dart';
import 'package:eshop_multivendor/widgets/background_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:eshop_multivendor/Helper/Color.dart';
import '../../Helper/Constant.dart';
import '../../widgets/appBar.dart';
import '../../widgets/desing.dart';
import '../ProductList&SectionView/ProductList.dart';
import 'package:eshop_multivendor/widgets/app_drawer.dart';

class SubCategory extends StatefulWidget {
  final List<Product>? subList;
  final String title;
  const SubCategory({Key? key, this.subList, required this.title})
      : super(key: key);

  @override
  State<SubCategory> createState() => _SubCategoryState();
}

class _SubCategoryState extends State<SubCategory> {
  setStateNow() {}

  @override
  Widget build(BuildContext context) {
    final GlobalKey<ScaffoldState> _key = GlobalKey();
    setStateNow() {
      setState(() {});
    }

    return Scaffold(
      endDrawer: const MyDrawer(),
      key: _key,
      backgroundColor: colors.backgroundColor,
      appBar: getAppBar(_key,
          title: widget.title, context: context, setState: setStateNow),
      // appBar: getAppBar(title: title, context: context, setState: setStateNow),
      body: Stack(
        children: [
          const BackgroundImage(),
          GridView.count(
            padding: const EdgeInsets.all(20),
            crossAxisCount: 2,
            shrinkWrap: true,
            childAspectRatio: .68,
            children: List.generate(
              widget.subList!.length,
              (index) {
                return subCatItem(index, context);
              },
            ),
          ),
        ],
      ),
    );
  }

  subCatItem(int index, BuildContext context) {
    return GestureDetector(
      child: Column(
        children: <Widget>[
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
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
                    widthvalue: null,
                    placeHolderSize: 50,
                    imageurlString: widget.subList![index].image!,
                  ),
                ),
              ),
            ),
          ),
          Text(
            widget.subList![index].name!,
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
      onTap: () {
        if (widget.subList![index].subList == null ||
            widget.subList![index].subList!.isEmpty) {
          Navigator.push(
            context,
            CupertinoPageRoute(
              builder: (context) => ProductList(
                name: widget.subList![index].name,
                id: widget.subList![index].id,
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
                subList: widget.subList![index].subList,
                title: widget.subList![index].name ?? '',
              ),
            ),
          );
        }
      },
    );
  }
}
