import 'package:eshop_multivendor/Helper/Color.dart';
import 'package:eshop_multivendor/ServiceApp/component/custom_stepper.dart';
import 'package:eshop_multivendor/ServiceApp/component/loader_widget.dart';
import 'package:eshop_multivendor/main.dart';
import 'package:eshop_multivendor/ServiceApp/model/booking_data_model.dart';
import 'package:eshop_multivendor/ServiceApp/model/service_detail_response.dart';
import 'package:eshop_multivendor/ServiceApp/model/slot_data.dart';
import 'package:eshop_multivendor/ServiceApp/network/rest_apis.dart';
import 'package:eshop_multivendor/ServiceApp/screens/booking/component/available_slots_component.dart';
import 'package:eshop_multivendor/ServiceApp/utils/colors.dart';
import 'package:eshop_multivendor/ServiceApp/utils/common.dart';
import 'package:eshop_multivendor/ServiceApp/utils/constant.dart';
import 'package:eshop_multivendor/ServiceApp/utils/extensions/int_extension.dart';
import 'package:eshop_multivendor/ServiceApp/utils/model_keys.dart';
import 'package:eshop_multivendor/ServiceApp/utils/widgets/horizontal_calender/date_item.dart';
import 'package:eshop_multivendor/ServiceApp/utils/widgets/horizontal_calender/date_picker_controller.dart';
import 'package:eshop_multivendor/ServiceApp/utils/widgets/horizontal_calender/horizontal_date_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:nb_utils/nb_utils.dart';

class BookingServiceStep1 extends StatefulWidget {
  final ServiceDetailResponse? data;
  final BookingData? bookingData;
  final bool showAppbar;

  BookingServiceStep1({this.data, this.showAppbar = false, this.bookingData});

  @override
  _BookingServiceStep1State createState() => _BookingServiceStep1State();
}

class _BookingServiceStep1State extends State<BookingServiceStep1> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  List<SlotData> slotsList = [];

  DatePickerController _datePickerController = DatePickerController();

  DateTime selectedHorizontalDate = DateTime.now();

  bool isSlotSelected = false;
  bool isTodaySlotSelected = false;
  bool isUpdate = false;

  UniqueKey keyForTimeSlotWidget = UniqueKey();

  String? selectedDate;

  @override
  void initState() {
    super.initState();
    init();
  }

  void init() async {
    slotsList = widget.data!.serviceDetail!.bookingSlots.validate();
    isUpdate = widget.bookingData != null;

    if (widget.data!.serviceDetail!.bookingDate != null) {
      selectedHorizontalDate = DateTime.parse(
          widget.data!.serviceDetail!.bookingDate.validate().toString());
    }

    if (isUpdate) {
      selectedHorizontalDate =
          DateTime.parse(widget.bookingData!.date.validate().toString());

      SlotData tempSlot = slotsList.firstWhere((element) =>
          element.day.validate().toLowerCase() ==
          selectedHorizontalDate.weekday.weekDayName.validate().toLowerCase());

      if (!tempSlot.slot
          .validate()
          .contains(widget.bookingData!.bookingSlot.validate())) {
        slotsList
            .firstWhere((element) =>
                element.day.validate().toLowerCase() ==
                selectedHorizontalDate.weekday.weekDayName
                    .validate()
                    .toLowerCase())
            .slot!
            .add(widget.bookingData!.bookingSlot.validate());
      }
    }
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  void _handleNextButtonClick() {
    if (isUpdate) {
      if (widget.data!.serviceDetail!.bookingSlot.validate() ==
          widget.bookingData!.bookingSlot.validate())
        return toast(language.pleaseSelectDifferentSlotThenPrevious);

      showConfirmDialogCustom(
        context,
        dialogType: DialogType.UPDATE,
        positiveText: language.lblUpdate,
        negativeText: language.lblCancel,
        onAccept: (p0) {
          updateDetails();
        },
      );
    } else {
      if (widget.data!.serviceDetail!.bookingSlot.validate().isNotEmpty) {
        Fluttertoast.cancel();
        widget.data!.serviceDetail!.bookingDate = formatDate(
            selectedHorizontalDate.toString(),
            format: DATE_FORMAT_7);
        widget.data!.serviceDetail!.bookingDay =
            selectedHorizontalDate.weekday.weekDayName.toLowerCase();
        widget.data!.serviceDetail!.dateTimeVal = formatDate(
            selectedHorizontalDate.toString(),
            format: DATE_FORMAT_3);
        log(selectedHorizontalDate.toString());
        customStepperController.nextPage(
            duration: 200.milliseconds, curve: Curves.linearToEaseOut);
      } else {
        toast(language.pleaseSelectTheSlotsFirst, length: Toast.LENGTH_LONG);
      }
    }
  }

  void updateDetails() async {
    Map request = {
      CommonKeys.id: widget.bookingData!.id.validate(),
      "date":
          formatDate(selectedHorizontalDate.toString(), format: DATE_FORMAT_7),
      "booking_date":
          formatDate(selectedHorizontalDate.toString(), format: DATE_FORMAT_7),
      "booking_slot": widget.data!.serviceDetail!.bookingSlot,
      "booking_day": selectedHorizontalDate.weekday.weekDayName.toLowerCase(),
      CommonKeys.status: widget.bookingData!.status.validate(),
    };

    log(request);
    appStore.setLoading(true);
    await updateBooking(request).then((value) {
      widget.bookingData!.date =
          formatDate(selectedHorizontalDate.toString(), format: DATE_FORMAT_7);
      widget.bookingData!.bookingSlot = widget.data!.serviceDetail!.bookingSlot;

      toast(language.lblDateTimeUpdated);
      LiveStream().emit(LIVESTREAM_UPDATE_BOOKING_LIST);
      finish(context);
    }).catchError((e) {
      log(e.toString());
    });

    appStore.setLoading(false);
  }

  @override
  Widget build(BuildContext context) {
    List<String> temp = slotsList.validate().isNotEmpty
        ? slotsList
            .validate()
            .firstWhere(
                (element) =>
                    element.day!.toLowerCase() ==
                    selectedHorizontalDate.weekday.weekDayName.toLowerCase(),
                orElse: () => SlotData(slot: [], day: ''))
            .slot
            .validate()
        : [];
    return Scaffold(
      appBar: widget.showAppbar
          ? appBarWidget(language.editTimeSlotsBooking,
              color: context.primaryColor, textColor: Colors.white)
          : null,
      body: Container(
        color: colors.backgroundColor,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Stack(
          fit: StackFit.expand,
          children: [
            SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(0, 16, 0, 60),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(language.lblSelectDate,
                      style: boldTextStyle(size: LABEL_TEXT_SIZE)),
                  16.height,
                  HorizontalDatePickerWidget(
                    height: 90,
                    startDate: DateTime.now(),
                    endDate:
                        DateTime(DateTime.now().year, DateTime.now().month + 2),
                    selectedDate: selectedHorizontalDate,
                    widgetWidth: context.width(),
                    selectedColor: primaryColor,
                    dateItemComponentList: const [
                      DateItem.Month,
                      DateItem.Day,
                      DateItem.WeekDay
                    ],
                    dayFontSize: 20,
                    weekDayFontSize: 16,
                    datePickerController: _datePickerController,
                    onValueSelected: (date) {
                      selectedHorizontalDate = date;
                      widget.data!.serviceDetail!.bookingSlot = null;
                      isSlotSelected = false;
                      keyForTimeSlotWidget = UniqueKey();

                      setState(() {});
                    },
                  ),
                  32.height,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        language.use24HourFormat,
                        style: const TextStyle(color: Colors.black),
                      ),
                      16.width,
                      Observer(builder: (context) {
                        return Transform.scale(
                          scale: 0.8,
                          child: Switch.adaptive(
                            inactiveTrackColor: Colors.black,
                            value: appStore.is24HourFormat,
                            onChanged: (value) {
                              appStore.set24HourFormat(value);
                            },
                          ),
                        );
                      })
                    ],
                  ).paddingOnly(right: 16, top: 16),
                  Text(language.availableSlots,
                          style: boldTextStyle(size: LABEL_TEXT_SIZE))
                      .paddingOnly(left: 16),
                  10.height,
                  temp.isNotEmpty
                      ? AvailableSlotsComponent(
                          key: keyForTimeSlotWidget,
                          selectedSlots: widget.data!.serviceDetail!.bookingSlot
                                  .validate()
                                  .isNotEmpty
                              ? [
                                  widget.data!.serviceDetail!.bookingSlot
                                      .validate()
                                ]
                              : isUpdate
                                  ? [widget.bookingData!.bookingSlot.validate()]
                                  : [],
                          isProvider: false,
                          availableSlots: temp,
                          selectedDate: selectedHorizontalDate,
                          onChanged: (List<String> selectedSlots) {
                            isSlotSelected = selectedSlots.isNotEmpty;

                            if (isSlotSelected) {
                              widget.data!.serviceDetail!.bookingSlot =
                                  selectedSlots.first.validate();
                            } else {
                              widget.data!.serviceDetail!.bookingSlot = "";
                            }

                            setState(() {});
                          },
                        )
                      : appStore.isLoading
                          ? LoaderWidget()
                          : NoDataWidget(title: language.noTimeSlots),
                  32.height,
                ],
              ),
            ),
            Positioned(
              bottom: 16,
              right: 0,
              left: 0,
              child: AppButton(
                onTap: _handleNextButtonClick,
                width: context.width(),
                color: colors.primary,
                textColor: Colors.white,
                shapeBorder: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                        topRight: Radius.circular(25),
                        bottomLeft: Radius.circular(25))),
                text: isUpdate ? language.lblUpdate : language.btnNext,
              ),
            ),
            Observer(
                builder: (_) =>
                    LoaderWidget().center().visible(appStore.isLoading)),
          ],
        ),
      ),
    );
  }
}
