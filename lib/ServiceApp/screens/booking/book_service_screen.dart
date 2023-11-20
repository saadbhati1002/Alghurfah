import 'package:eshop_multivendor/Helper/Color.dart';
import 'package:eshop_multivendor/ServiceApp/component/back_widget.dart';
import 'package:eshop_multivendor/ServiceApp/component/custom_stepper.dart';
import 'package:eshop_multivendor/main.dart';
import 'package:eshop_multivendor/ServiceApp/model/package_data_model.dart';
import 'package:eshop_multivendor/ServiceApp/model/service_detail_response.dart';
import 'package:eshop_multivendor/ServiceApp/screens/booking/component/booking_service_step1.dart';
import 'package:eshop_multivendor/ServiceApp/screens/booking/component/booking_service_step2.dart';
import 'package:eshop_multivendor/ServiceApp/screens/booking/component/booking_service_step3.dart';
import 'package:eshop_multivendor/widgets/appBar.dart';
import 'package:eshop_multivendor/widgets/app_drawer.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:eshop_multivendor/widgets/bottom_navigation_service_app.dart';

class CustomStep {
  final String title;
  final Widget page;

  CustomStep({required this.title, required this.page});
}

class BookServiceScreen extends StatefulWidget {
  final ServiceDetailResponse data;
  final int bookingAddressId;
  final BookingPackage? selectedPackage;

  BookServiceScreen(
      {required this.data, this.bookingAddressId = 0, this.selectedPackage});

  @override
  _BookServiceScreenState createState() => _BookServiceScreenState();
}

class _BookServiceScreenState extends State<BookServiceScreen> {
  List<CustomStep>? stepsList;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    init();
  }

  init() async {
    stepsList = [
      CustomStep(
        title: widget.data.serviceDetail!.isSlotAvailable
            ? language.lblStep2
            : language.lblStep1,
        page: BookingServiceStep2(
          data: widget.data,
          isSlotAvailable: !widget.data.serviceDetail!.isSlotAvailable,
        ),
      ),
      CustomStep(
        title: widget.data.serviceDetail!.isSlotAvailable
            ? language.lblStep3
            : language.lblStep2,
        page: BookingServiceStep3(
            data: widget.data,
            selectedPackage:
                widget.selectedPackage != null ? widget.selectedPackage : null),
      ),
    ];

    if (widget.data.serviceDetail!.isSlotAvailable) {
      stepsList!.insert(
          0,
          CustomStep(
              title: language.lblStep1,
              page: BookingServiceStep1(data: widget.data)));
    }
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
      bottomNavigationBar: serviceAppBottomNavigation(context),
      endDrawer: const MyDrawer(),
      key: _scaffoldKey,
      backgroundColor: colors.backgroundColor,
      appBar: getAppBar(_scaffoldKey,
          title: language.bookTheService,
          context: context,
          setState: setStateNow),
      body: SizedBox(
        child: Column(
          children: [
            CustomStepper(stepsList: stepsList.validate()).expand(),
          ],
        ),
      ),
    );
  }
}
