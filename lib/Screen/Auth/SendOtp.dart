import 'dart:async';
import 'package:eshop_multivendor/Provider/SettingProvider.dart';
import 'package:eshop_multivendor/Screen/Auth/Login.dart';
import 'package:eshop_multivendor/Screen/Auth/SignUp.dart';
import 'package:eshop_multivendor/Screen/PrivacyPolicy/Privacy_Policy.dart';
import 'package:eshop_multivendor/Screen/Auth/Verify_Otp.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl_phone_field/country_picker_dialog.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:provider/provider.dart';
import '../../Helper/Color.dart';
import '../../Helper/Constant.dart';
import '../../Helper/String.dart';
import '../../Provider/authenticationProvider.dart';
import '../../widgets/ButtonDesing.dart';
import '../../widgets/desing.dart';
import '../../widgets/snackbar.dart';
import '../../widgets/background_image.dart';
import '../../widgets/systemChromeSettings.dart';
import '../Language/languageSettings.dart';
import '../../widgets/networkAvailablity.dart';
import '../NoInterNetWidget/NoInterNet.dart';

class SendOtp extends StatefulWidget {
  String? title;

  SendOtp({Key? key, this.title}) : super(key: key);

  @override
  _SendOtpState createState() => _SendOtpState();
}

class _SendOtpState extends State<SendOtp> with TickerProviderStateMixin {
  bool visible = false;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final mobileController = TextEditingController();
  final ccodeController = TextEditingController();
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  String? mobile, id, countrycode, countryName, mobileno;
  Animation? buttonSqueezeanimation;
  AnimationController? buttonController;

  void validateAndSubmit() async {
    if (validateAndSave()) {
      _playAnimation();
      checkNetwork();
    }
  }

  Future<void> _playAnimation() async {
    try {
      await buttonController!.forward();
    } on TickerCanceled {}
  }

  Future<void> checkNetwork() async {
    isNetworkAvail = await isNetworkAvailable();
    if (isNetworkAvail) {
      Future.delayed(Duration.zero).then(
        (value) => context
            .read<AuthenticationProvider>()
            .getVerifyUser(mobileController.text)
            .then(
          (
            value,
          ) async {
            bool? error = value['error'];
            String? msg = value['message'];
            await buttonController!.reverse();
            SettingProvider settingsProvider =
                Provider.of<SettingProvider>(context, listen: false);
            if (widget.title == getTranslated(context, 'SEND_OTP_TITLE')) {
              if (!error!) {
                // setSnackbar(msg!, context);
                Future.delayed(const Duration(seconds: 1)).then(
                  (_) {
                    Navigator.pushReplacement(
                        context,
                        CupertinoPageRoute(
                            builder: (context) => SignUp(
                                  mobileNumber:
                                      mobileController.text.toString().trim(),
                                )));
                  },
                );
              } else {
                setSnackbar(msg!, context);
              }
            }
            if (widget.title == getTranslated(context, 'FORGOT_PASS_TITLE')) {
              if (error!) {
                settingsProvider.setPrefrence(MOBILE, mobileController.text);
                settingsProvider.setPrefrence(COUNTRY_CODE, countrycode!);
                Future.delayed(const Duration(seconds: 1)).then(
                  (_) {
                    Navigator.pushReplacement(
                      context,
                      CupertinoPageRoute(
                        builder: (context) => VerifyOtp(
                          mobileNumber: mobileController.text,
                          countryCode: countrycode,
                          title: getTranslated(context, 'FORGOT_PASS_TITLE'),
                        ),
                      ),
                    );
                  },
                );
              } else {
                setSnackbar(
                    getTranslated(context, 'FIRSTSIGNUP_MSG')!, context);
              }
            }
          },
        ),
      );
    } else {
      Future.delayed(const Duration(seconds: 2)).then(
        (_) async {
          if (mounted) {
            setState(
              () {
                isNetworkAvail = false;
              },
            );
          }
          await buttonController!.reverse();
        },
      );
    }
  }

  bool validateAndSave() {
    final form = _formkey.currentState!;
    form.save();
    if (form.validate()) {
      return true;
    }
    return false;
  }

  @override
  void dispose() {
    SystemChromeSettings.setSystemButtomNavigationBarithTopAndButtom();
    SystemChromeSettings.setSystemUIOverlayStyleWithNoSpecification();

    buttonController!.dispose();
    super.dispose();
  }

  setStateNoInternate() async {
    _playAnimation();

    Future.delayed(const Duration(seconds: 2)).then(
      (_) async {
        isNetworkAvail = await isNetworkAvailable();
        if (isNetworkAvail) {
          Navigator.pushReplacement(
            context,
            CupertinoPageRoute(builder: (BuildContext context) => super.widget),
          );
        } else {
          await buttonController!.reverse();
          if (mounted) {
            setState(
              () {},
            );
          }
        }
      },
    );
  }

  Widget verifyCodeTxt() {
    return Padding(
      padding: const EdgeInsets.only(top: 13.0),
      child: Text(
        widget.title == getTranslated(context, 'SEND_OTP_TITLE')
            ? "Check your mobile number with us"
            : getTranslated(context, 'SEND_VERIFY_CODE_LBL')!,
        style: Theme.of(context).textTheme.titleSmall!.copyWith(
              color: Theme.of(context).colorScheme.fontColor.withOpacity(0.4),
              fontWeight: FontWeight.bold,
              fontFamily: 'ubuntu',
            ),
        overflow: TextOverflow.ellipsis,
        softWrap: true,
        maxLines: 3,
      ),
    );
  }

  setCodeWithMono() {
    return Padding(
        padding: const EdgeInsets.only(top: 30),
        child: IntlPhoneField(
          style: Theme.of(context).textTheme.titleSmall!.copyWith(
              color: colors.primary, fontWeight: FontWeight.w600, fontSize: 16),
          controller: mobileController,
          decoration: InputDecoration(
            hintStyle: Theme.of(context).textTheme.titleSmall!.copyWith(
                color: colors.black54,
                fontWeight: FontWeight.w500,
                fontSize: 16),
            hintText: getTranslated(context, 'MOBILEHINT_LBL'),
            enabledBorder: OutlineInputBorder(
                borderSide: const BorderSide(
                  color: colors.primary,
                  width: 1,
                  style: BorderStyle.solid,
                ),
                borderRadius: BorderRadius.circular(circularBorderRadius7)),
            border: OutlineInputBorder(
                borderSide: const BorderSide(
                    color: colors.primary, width: 1, style: BorderStyle.solid),
                borderRadius: BorderRadius.circular(circularBorderRadius7)),
            fillColor: Colors.white,
            filled: true,
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
          ),
          initialCountryCode: defaultCountryCode,
          onTap: () {},
          onSaved: (phoneNumber) {
            setState(() {
              countrycode =
                  phoneNumber!.countryCode.toString().replaceFirst('+', '');

              mobile = phoneNumber.number;
            });
          },
          onCountryChanged: (country) {
            setState(() {
              countrycode = country.dialCode;
            });
          },
          onChanged: (phone) {},
          showDropdownIcon: false,
          invalidNumberMessage: getTranslated(context, 'VALID_MOB'),
          keyboardType: TextInputType.number,
          flagsButtonMargin: const EdgeInsets.only(left: 20, right: 0),
          pickerDialogStyle: PickerDialogStyle(
            padding: const EdgeInsets.only(left: 0, right: 0),
          ),
        ));
  }

  Widget verifyBtn() {
    return Padding(
      padding: const EdgeInsets.only(top: 20.0),
      child: Center(
        child: AppBtn(
          title: widget.title == getTranslated(context, 'SEND_OTP_TITLE')
              ? "Check"
              : getTranslated(context, 'GET_PASSWORD'),
          btnAnim: buttonSqueezeanimation,
          btnCntrl: buttonController,
          onBtnSelected: () async {
            validateAndSubmit();
          },
        ),
      ),
    );
  }

  Widget termAndPolicyTxt() {
    return widget.title == getTranslated(context, 'SEND_OTP_TITLE')
        ? SizedBox(
            height: deviceHeight! * 0.18,
            width: double.maxFinite,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  getTranslated(context, 'CONTINUE_AGREE_LBL')!,
                  style: Theme.of(context).textTheme.bodySmall!.copyWith(
                        color: Theme.of(context).colorScheme.fontColor,
                        fontWeight: FontWeight.normal,
                        fontFamily: 'ubuntu',
                      ),
                ),
                const SizedBox(
                  height: 3.0,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          CupertinoPageRoute(
                            builder: (context) => PrivacyPolicy(
                              title: getTranslated(context, 'TERM'),
                            ),
                          ),
                        );
                      },
                      child: Text(
                        getTranslated(context, 'TERMS_SERVICE_LBL')!,
                        style: Theme.of(context).textTheme.bodySmall!.copyWith(
                              color: Theme.of(context).colorScheme.fontColor,
                              decoration: TextDecoration.underline,
                              fontWeight: FontWeight.normal,
                              fontFamily: 'ubuntu',
                            ),
                        overflow: TextOverflow.clip,
                        softWrap: true,
                        maxLines: 1,
                      ),
                    ),
                    const SizedBox(
                      width: 5.0,
                    ),
                    Text(
                      getTranslated(context, 'AND_LBL')!,
                      style: Theme.of(context).textTheme.bodySmall!.copyWith(
                            color: Theme.of(context).colorScheme.fontColor,
                            fontWeight: FontWeight.normal,
                            fontFamily: 'ubuntu',
                          ),
                    ),
                    const SizedBox(
                      width: 5.0,
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          CupertinoPageRoute(
                            builder: (context) => PrivacyPolicy(
                              title: getTranslated(context, 'PRIVACY'),
                            ),
                          ),
                        );
                      },
                      child: Text(
                        getTranslated(context, 'PRIVACY')!,
                        style: Theme.of(context).textTheme.bodySmall!.copyWith(
                              color: Theme.of(context).colorScheme.fontColor,
                              decoration: TextDecoration.underline,
                              fontWeight: FontWeight.normal,
                              fontFamily: 'ubuntu',
                            ),
                        overflow: TextOverflow.clip,
                        softWrap: true,
                        maxLines: 1,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          )
        : const SizedBox();
  }

  @override
  void initState() {
    SystemChromeSettings.setSystemButtomNavigationBarithTopAndButtom();
    SystemChromeSettings.setSystemUIOverlayStyleWithNoSpecification();

    super.initState();
    buttonController = AnimationController(
        duration: const Duration(milliseconds: 2000), vsync: this);

    buttonSqueezeanimation = Tween(
      begin: deviceWidth! * 0.7,
      end: 50.0,
    ).animate(
      CurvedAnimation(
        parent: buttonController!,
        curve: const Interval(
          0.0,
          0.150,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // deviceHeight = MediaQuery.of(context).size.height;
    // deviceWidth = MediaQuery.of(context).size.width;
    return SafeArea(
      top: true,
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        key: _scaffoldKey,
        body: isNetworkAvail
            ? Stack(
                children: [
                  const BackgroundImage(),
                  SingleChildScrollView(
                    padding: EdgeInsets.only(
                      top: 60,
                      left: 30,
                      right: 30,
                      bottom: MediaQuery.of(context).viewInsets.bottom,
                    ),
                    child: Form(
                      key: _formkey,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          getLogo(),
                          signUpTxt(),
                          Container(
                            decoration: const BoxDecoration(
                                borderRadius: BorderRadius.only(
                                  topRight: Radius.circular(25),
                                  bottomLeft: Radius.circular(25),
                                ),
                                color: colors.whiteTemp),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 15, vertical: 5),
                              child: setCodeWithMono(),
                            ),
                          ),
                          verifyBtn(),
                          alreadyHaveAccount(),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 15, left: 15),
                    child: GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: const Icon(
                        Icons.arrow_back_ios_new_outlined,
                        color: colors.primary,
                      ),
                    ),
                  )
                ],
              )
            : NoInterNet(
                setStateNoInternate: setStateNoInternate,
                buttonSqueezeanimation: buttonSqueezeanimation,
                buttonController: buttonController,
              ),
      ),
    );
  }

  Widget getLogo() {
    return Container(
      height: 180,
      alignment: Alignment.center,
      child: Image.asset(
        'assets/images/png/logo1.png',
        alignment: Alignment.center,
        height: 170,
        width: MediaQuery.of(context).size.width * .5,
        fit: BoxFit.contain,
      ),
    );
  }

  Widget signUpTxt() {
    return Padding(
      padding: const EdgeInsetsDirectional.only(top: 45.0, bottom: 20),
      child: Text(
        widget.title == getTranslated(context, 'SEND_OTP_TITLE')
            ? getTranslated(context, 'SIGN_UP_LBL')!
            : getTranslated(context, 'FORGOT_PASSWORDTITILE')!,
        style: Theme.of(context).textTheme.titleLarge!.copyWith(
              color: colors.primary,
              fontWeight: FontWeight.bold,
              fontSize: textFontSize23,
              fontFamily: 'ubuntu',
              letterSpacing: 0.8,
            ),
      ),
    );
  }

  alreadyHaveAccount() {
    return Padding(
      padding: const EdgeInsetsDirectional.only(top: 15.0, bottom: 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          InkWell(
            onTap: () {
              Navigator.of(context).push(
                CupertinoPageRoute(
                  builder: (BuildContext context) => const Login(),
                ),
              );
            },
            child: Text(
              getTranslated(context, 'or_login')!,
              style: Theme.of(context).textTheme.titleSmall!.copyWith(
                    color: Theme.of(context).colorScheme.primary,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'ubuntu',
                  ),
            ),
          )
        ],
      ),
    );
  }
}
