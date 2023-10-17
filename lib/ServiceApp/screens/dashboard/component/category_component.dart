import 'package:eshop_multivendor/ServiceApp/component/view_all_label_component.dart';
import 'package:eshop_multivendor/main.dart';
import 'package:eshop_multivendor/ServiceApp/model/category_model.dart';
import 'package:eshop_multivendor/ServiceApp/screens/category/category_screen.dart';
import 'package:eshop_multivendor/ServiceApp/screens/dashboard/component/category_widget.dart';
import 'package:eshop_multivendor/ServiceApp/screens/service/view_all_service_screen.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';

class CategoryComponent extends StatefulWidget {
  final List<CategoryData>? categoryList;

  CategoryComponent({this.categoryList});

  @override
  CategoryComponentState createState() => CategoryComponentState();
}

class CategoryComponentState extends State<CategoryComponent> {
  @override
  void initState() {
    super.initState();
    init();
  }

  Future<void> init() async {
    //
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    if (widget.categoryList.validate().isEmpty) return Offstage();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: widget.categoryList.validate().length,
          padding: const EdgeInsets.only(left: 10, right: 10, top: 15),
          itemBuilder: (_, i) {
            CategoryData data = widget.categoryList![i];
            return GestureDetector(
              onTap: () {
                ViewAllServiceScreen(
                        categoryId: data.id.validate(),
                        categoryName: data.name,
                        isFromCategory: true)
                    .launch(context);
              },
              child: CategoryWidget(categoryData: data),
            );
          },
        ),
      ],
    );
  }
}
