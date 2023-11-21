import 'package:eshop_multivendor/ServiceApp/app_theme.dart';
import 'package:eshop_multivendor/ServiceApp/component/loader_widget.dart';
import 'package:eshop_multivendor/main.dart';
import 'package:eshop_multivendor/ServiceApp/model/booking_data_model.dart';
import 'package:eshop_multivendor/ServiceApp/network/rest_apis.dart';
import 'package:eshop_multivendor/ServiceApp/utils/colors.dart';
import 'package:eshop_multivendor/ServiceApp/utils/common.dart';
import 'package:eshop_multivendor/ServiceApp/utils/constant.dart';
import 'package:eshop_multivendor/ServiceApp/utils/images.dart';
import 'package:eshop_multivendor/ServiceApp/utils/model_keys.dart';
import 'package:eshop_multivendor/ServiceApp/utils/string_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:nb_utils/nb_utils.dart';

class EditBookingServiceDialog extends StatefulWidget {
  final BookingData data;

  EditBookingServiceDialog({required this.data});

  @override
  State<EditBookingServiceDialog> createState() =>
      _EditBookingServiceDialogState();
}

class _EditBookingServiceDialogState extends State<EditBookingServiceDialog> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  TextEditingController dateTimeCont = TextEditingController();
  TextEditingController prevDateTimeCont = TextEditingController();

  DateTime? selectedDate;
  DateTime? finalDate;
  TimeOfDay? pickedTime;

  @override
  void initState() {
    super.initState();
    init();
  }

  void init() async {
    if (widget.data.date != null) {
      dateTimeCont.text =
          formatDate(widget.data.date.validate(), format: DATE_FORMAT_1);
      prevDateTimeCont.text =
          formatDate(widget.data.date.validate(), format: DATE_FORMAT_1);
      selectedDate = DateTime.parse(widget.data.date.validate());
      pickedTime = TimeOfDay.fromDateTime(selectedDate!);
    }
  }

  void selectDateAndTime(BuildContext context) async {
    await showDatePicker(
      context: context,
      initialDate: selectedDate ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(3000),
      locale: Locale(appStore.selectedLanguageCode),
      builder: (_, child) {
        return Theme(
          data: appStore.isDarkMode ? ThemeData.dark() : AppTheme.lightTheme(),
          child: child!,
        );
      },
    ).then((date) async {
      if (date != null) {
        await showTimePicker(
          context: context,
          initialTime: pickedTime ?? TimeOfDay.now(),
          builder: (_, child) {
            return Theme(
              data: appStore.isDarkMode
                  ? ThemeData.dark()
                  : AppTheme.lightTheme(),
              child: child!,
            );
          },
        ).then((time) {
          if (time != null) {
            selectedDate = date;
            pickedTime = time;

            dateTimeCont.text =
                "${formatDate(selectedDate.toString(), format: DATE_FORMAT_3)} ${pickedTime!.format(context).toString()}";
          }
        }).catchError((e) {
          toast(e.toString());
        });
      }
    });
  }

  void _handleSubmitClick() async {
    if (prevDateTimeCont.text != dateTimeCont.text) {
      appStore.setLoading(true);
      finalDate = DateTime(selectedDate!.year, selectedDate!.month,
          selectedDate!.day, pickedTime!.hour, pickedTime!.minute);
      Map request = {
        CommonKeys.id: widget.data.id.validate(),
        CommonKeys.date: finalDate.toString(),
        CommonKeys.status: widget.data.status.validate(),
        BookingUpdateKeys.paymentStatus: widget.data.isAdvancePaymentDone
            ? SERVICE_PAYMENT_STATUS_ADVANCE_PAID
            : widget.data.paymentStatus.validate(),
      };

      log(request);

      await updateBooking(request).then((value) {
        widget.data.date = finalDate.toString();
        toast(language.lblDateTimeUpdated);
        finish(context);
      }).catchError((e) {
        log(e.toString());
      });

      appStore.setLoading(false);
    } else {
      toast(language.lblSelectDate);
    }
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text('#${widget.data.id.validate()}',
                      style: boldTextStyle(color: primaryColor)),
                  16.width,
                  Text('${widget.data.serviceName.validate()}',
                          style: boldTextStyle())
                      .flexible(),
                ],
              ),
              16.height,
              Container(
                decoration: boxDecorationDefault(color: Colors.white),
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('${language.lblDateAndTime} ',
                        style: secondaryTextStyle()),
                    16.height,
                    AppTextField(
                      textFieldType: TextFieldType.OTHER,
                      controller: dateTimeCont,
                      isValidationRequired: true,
                      textStyle:
                          const TextStyle(fontSize: 16, color: Colors.white),
                      validator: (value) {
                        if (value!.isEmpty) return language.requiredText;
                        return null;
                      },
                      readOnly: true,
                      onTap: () {
                        selectDateAndTime(context);
                      },
                      decoration: inputDecoration(context,
                              prefixIcon: ic_calendar
                                  .iconImage(size: 10, color: Colors.white)
                                  .paddingAll(14))
                          .copyWith(
                        fillColor: context.cardColor,
                        filled: true,
                        hintText: language.lblEnterDateAndTime,
                        hintStyle: secondaryTextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
              16.height,
              Row(
                children: [
                  AppButton(
                    shapeBorder: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                            topRight: Radius.circular(20),
                            bottomLeft: Radius.circular(20))),
                    onTap: () {
                      finish(context);
                    },
                    textColor: Colors.white,
                    color: context.scaffoldBackgroundColor,
                    text: language.lblCancel,
                  ).expand(),
                  16.width,
                  AppButton(
                    shapeBorder: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                            topRight: Radius.circular(20),
                            bottomLeft: Radius.circular(20))),
                    onTap: _handleSubmitClick,
                    color: primaryColor,
                    text: language.confirm,
                    textColor: Colors.white,
                  ).expand(),
                ],
              )
            ],
          ),
          Observer(
              builder: (context) => LoaderWidget().visible(appStore.isLoading))
        ],
      ),
    );
  }
}
