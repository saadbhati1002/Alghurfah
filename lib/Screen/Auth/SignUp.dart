import 'dart:async';
import 'package:eshop_multivendor/AppScreen/app_tabbar_screen.dart';
import 'package:eshop_multivendor/Helper/Color.dart';
import 'package:eshop_multivendor/Provider/SettingProvider.dart';
import 'package:eshop_multivendor/Provider/UserProvider.dart';
import 'package:eshop_multivendor/Provider/authenticationProvider.dart';
import 'package:eshop_multivendor/Screen/NoInterNetWidget/NoInterNet.dart';
import 'package:eshop_multivendor/ServiceApp/model/user_data_model.dart';
import 'package:eshop_multivendor/ServiceApp/network/rest_apis.dart';
import 'package:eshop_multivendor/ServiceApp/utils/constant.dart' as service;
import 'package:eshop_multivendor/main.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import '../../Helper/Constant.dart';
import '../../Helper/String.dart';
import '../../Helper/routes.dart';
import '../../widgets/ButtonDesing.dart';
import '../../widgets/desing.dart';
import '../../widgets/snackbar.dart';
import '../../widgets/systemChromeSettings.dart';
import '../Language/languageSettings.dart';
import '../../widgets/networkAvailablity.dart';
import '../../widgets/validation.dart';

class SignUp extends StatefulWidget {
  final String? mobileNumber;
  const SignUp({Key? key, this.mobileNumber}) : super(key: key);

  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUp> with TickerProviderStateMixin {
  bool? _showPassword = true;
  bool visible = false;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final fisrtNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final emailController = TextEditingController();
  final mobileController = TextEditingController();
  final ccodeController = TextEditingController();
  final passwordController = TextEditingController();
  final referController = TextEditingController();
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  String? name,
      email,
      password,
      mobile,
      id,
      countrycode,
      city,
      area,
      pincode,
      address,
      latitude,
      longitude,
      referCode,
      friendCode;
  FocusNode? nameFocus,
      lastNameFocus,
      emailFocus,
      passFocus = FocusNode(),
      referFocus = FocusNode();
  Animation? buttonSqueezeanimation;
  AnimationController? buttonController;

  void validateAndSubmit() async {
    if (validateAndSave()) {
      _playAnimation();
      checkNetwork();
    }
  }

  getUserDetails() async {
    SettingProvider settingsProvider =
        Provider.of<SettingProvider>(context, listen: false);

    context.read<AuthenticationProvider>().setMobileNumber(
        await settingsProvider.getPrefrence(widget.mobileNumber!));

    if (mounted) setState(() {});
  }

  setStateNow() {
    setState(() {});
  }

  Future<void> _playAnimation() async {
    try {
      await buttonController!.forward();
    } on TickerCanceled {}
  }

  serviceAppRegisteratin() async {
    appStore.setLoading(true);

    /// Create a temporary request to send
    UserData tempRegisterData = UserData()
      ..contactNumber = widget.mobileNumber
      ..firstName = fisrtNameController.text.toString().trim()
      ..lastName = lastNameController.text.toString().trim()
      ..userType = service.USER_TYPE_USER
      ..username = fisrtNameController.text.toString().trim() +
          lastNameController.text.toString().trim()
      ..email = widget.mobileNumber! + '@gmail.com'
      ..password = passwordController.text.toString().trim();

    await createUser(tempRegisterData.toJson()).then((registerResponse) async {
      registerResponse.userData!.password =
          passwordController.text.toString().trim();
      await saveUserData(registerResponse.userData!);

      Navigator.pushNamedAndRemoveUntil(context, '/home', (r) => false);
    });
  }

  Future<void> checkNetwork() async {
    isNetworkAvail = await isNetworkAvailable();
    if (isNetworkAvail) {
      Future.delayed(Duration.zero).then((value) {
        context
            .read<AuthenticationProvider>()
            .getSingUPData(mobileNumber: widget.mobileNumber)
            .then((
          value,
        ) async {
          print(value);
          bool? error = value['error'];
          String? msg = value['message'];
          await buttonController!.reverse();
          SettingProvider settingsProvider =
              Provider.of<SettingProvider>(context, listen: false);
          if (!error!) {
            setSnackbar(
                getTranslated(context, 'REGISTER_SUCCESS_MSG')!, context);
            serviceAppRegisteratin();
            var i = value['data'][0];

            id = i[ID];
            name = i[USERNAME];
            email = i[EMAIL];
            mobile = i[MOBILE];
            CUR_USERID = id;
            UserProvider userProvider = context.read<UserProvider>();
            userProvider.setName(name ?? '');
            SettingProvider settingProvider = context.read<SettingProvider>();
            settingProvider.saveUserDetail(id!, name, email, mobile, city, area,
                address, pincode, latitude, longitude, '', i[TYPE], context);
          } else {
            setSnackbar(msg!, context);
          }
        });
      });
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

  _fieldFocusChange(
      BuildContext context, FocusNode currentFocus, FocusNode? nextFocus) {
    currentFocus.unfocus();
    FocusScope.of(context).requestFocus(nextFocus);
  }

  setStateNoInternate() async {
    _playAnimation();
    Future.delayed(const Duration(seconds: 2)).then(
      (_) async {
        isNetworkAvail = await isNetworkAvailable();
        if (isNetworkAvail) {
          Navigator.pushReplacement(
            context,
            CupertinoPageRoute(
              builder: (BuildContext context) => super.widget,
            ),
          );
        } else {
          await buttonController!.reverse();
          if (mounted) setState(() {});
        }
      },
    );
  }

  Widget registerTxt() {
    return Padding(
      padding: const EdgeInsetsDirectional.only(top: 40.0),
      child: Align(
        alignment: Alignment.topLeft,
        child: Text(
          getTranslated(context, 'Create a new account')!,
          style: Theme.of(context).textTheme.titleLarge!.copyWith(
                color: Theme.of(context).colorScheme.fontColor,
                fontWeight: FontWeight.bold,
                fontSize: textFontSize23,
                fontFamily: 'ubuntu',
                letterSpacing: 0.8,
              ),
        ),
      ),
    );
  }

  signUpSubTxt() {
    return Padding(
      padding: const EdgeInsetsDirectional.only(
        top: 10.0,
      ),
      child: Text(
        getTranslated(context, 'INFO_FOR_NEW_ACCOUNT')!,
        style: Theme.of(context).textTheme.titleSmall!.copyWith(
              color: Theme.of(context).colorScheme.fontColor.withOpacity(0.38),
              fontWeight: FontWeight.bold,
              fontFamily: 'ubuntu',
            ),
      ),
    );
  }

  setFirstName() {
    return Padding(
      padding: const EdgeInsets.only(top: 25),
      child: Container(
        height: 53,
        width: double.maxFinite,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.lightWhite,
          borderRadius: BorderRadius.circular(circularBorderRadius10),
        ),
        alignment: Alignment.center,
        child: TextFormField(
          style: TextStyle(
              color: Theme.of(context).colorScheme.fontColor.withOpacity(0.7),
              fontWeight: FontWeight.bold,
              fontSize: textFontSize13),
          keyboardType: TextInputType.text,
          textCapitalization: TextCapitalization.words,
          controller: fisrtNameController,
          focusNode: nameFocus,
          textInputAction: TextInputAction.next,
          inputFormatters: [
            FilteringTextInputFormatter.deny(RegExp('[ ]')),
          ],
          decoration: InputDecoration(
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 13,
                vertical: 5,
              ),
              hintText: "First Name",
              hintStyle: TextStyle(
                  color:
                      Theme.of(context).colorScheme.fontColor.withOpacity(0.3),
                  fontWeight: FontWeight.bold,
                  fontSize: textFontSize13),
              fillColor: Theme.of(context).colorScheme.lightWhite,
              border: InputBorder.none),
          validator: (val) =>
              StringValidation.validateUserName(val!, "First Name is Required"),
          onSaved: (String? value) {},
          onFieldSubmitted: (v) {
            _fieldFocusChange(context, nameFocus!, lastNameFocus);
          },
        ),
      ),
    );
  }

  setLastName() {
    return Padding(
      padding: const EdgeInsets.only(top: 20),
      child: Container(
        height: 53,
        width: double.maxFinite,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.lightWhite,
          borderRadius: BorderRadius.circular(circularBorderRadius10),
        ),
        alignment: Alignment.center,
        child: TextFormField(
          style: TextStyle(
              color: Theme.of(context).colorScheme.fontColor.withOpacity(0.7),
              fontWeight: FontWeight.bold,
              fontSize: textFontSize13),
          keyboardType: TextInputType.text,
          textCapitalization: TextCapitalization.words,
          controller: lastNameController,
          focusNode: lastNameFocus,
          textInputAction: TextInputAction.next,
          inputFormatters: [
            FilteringTextInputFormatter.deny(RegExp('[ ]')),
          ],
          decoration: InputDecoration(
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 13,
                vertical: 5,
              ),
              hintText: "Last Name",
              hintStyle: TextStyle(
                  color:
                      Theme.of(context).colorScheme.fontColor.withOpacity(0.3),
                  fontWeight: FontWeight.bold,
                  fontSize: textFontSize13),
              fillColor: Theme.of(context).colorScheme.lightWhite,
              border: InputBorder.none),
          validator: (val) =>
              StringValidation.validateUserName(val!, "Last Name is Required"),
          onSaved: (String? value) {
            context.read<AuthenticationProvider>().setUserName(
                fisrtNameController.text.toString().trim() + " " + value!);
          },
          onFieldSubmitted: (v) {
            _fieldFocusChange(context, lastNameFocus!, emailFocus);
          },
        ),
      ),
    );
  }

  setEmail() {
    return Padding(
      padding: const EdgeInsets.only(top: 20),
      child: Container(
        height: 53,
        width: double.maxFinite,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.lightWhite,
          borderRadius: BorderRadius.circular(circularBorderRadius10),
        ),
        alignment: Alignment.center,
        child: TextFormField(
          style: TextStyle(
              color: Theme.of(context).colorScheme.fontColor.withOpacity(0.7),
              fontWeight: FontWeight.bold,
              fontSize: textFontSize13),
          keyboardType: TextInputType.emailAddress,
          focusNode: emailFocus,
          textInputAction: TextInputAction.next,
          inputFormatters: [
            FilteringTextInputFormatter.deny(RegExp('[ ]')),
          ],
          controller: emailController,
          decoration: InputDecoration(
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 13,
                vertical: 5,
              ),
              hintText: getTranslated(context, 'EMAILHINT_LBL'),
              hintStyle: TextStyle(
                  color:
                      Theme.of(context).colorScheme.fontColor.withOpacity(0.3),
                  fontWeight: FontWeight.bold,
                  fontSize: textFontSize13),
              fillColor: Theme.of(context).colorScheme.lightWhite,
              border: InputBorder.none),
          validator: (val) => StringValidation.validateEmail(
            val!,
            getTranslated(context, 'EMAIL_REQUIRED'),
            getTranslated(context, 'VALID_EMAIL'),
          ),
          onSaved: (String? value) {
            context.read<AuthenticationProvider>().setSingUp(value);
          },
          onFieldSubmitted: (v) {
            _fieldFocusChange(
              context,
              emailFocus!,
              passFocus,
            );
          },
        ),
      ),
    );
  }

  setRefer() {
    return Padding(
      padding: const EdgeInsets.only(top: 20),
      child: Container(
        height: 53,
        width: double.maxFinite,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.lightWhite,
          borderRadius: BorderRadius.circular(circularBorderRadius10),
        ),
        alignment: Alignment.center,
        child: TextFormField(
          style: TextStyle(
              color: Theme.of(context).colorScheme.fontColor.withOpacity(0.7),
              fontWeight: FontWeight.bold,
              fontSize: textFontSize13),
          keyboardType: TextInputType.text,
          focusNode: referFocus,
          controller: referController,
          textInputAction: TextInputAction.done,
          inputFormatters: [
            FilteringTextInputFormatter.deny(RegExp('[ ]')),
          ],
          onSaved: (String? value) {
            context.read<AuthenticationProvider>().setfriendCode(value);
          },
          onFieldSubmitted: (v) {
            referFocus!.unfocus();
          },
          decoration: InputDecoration(
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 13,
              vertical: 5,
            ),
            hintText: getTranslated(context, 'REFER'),
            hintStyle: TextStyle(
              color: Theme.of(context).colorScheme.fontColor.withOpacity(0.3),
              fontWeight: FontWeight.bold,
              fontSize: textFontSize13,
            ),
            fillColor: Theme.of(context).colorScheme.lightWhite,
            border: InputBorder.none,
          ),
        ),
      ),
    );
  }

  setPass() {
    return Padding(
      padding: const EdgeInsets.only(top: 20),
      child: Container(
        height: 53,
        width: double.maxFinite,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.lightWhite,
          borderRadius: BorderRadius.circular(circularBorderRadius10),
        ),
        alignment: Alignment.center,
        child: TextFormField(
          style: TextStyle(
              color: Theme.of(context).colorScheme.fontColor.withOpacity(0.7),
              fontWeight: FontWeight.bold,
              fontSize: textFontSize13),
          keyboardType: TextInputType.text,
          obscureText: _showPassword!,
          controller: passwordController,
          focusNode: passFocus,
          textInputAction: TextInputAction.next,
          inputFormatters: [
            FilteringTextInputFormatter.deny(RegExp('[ ]')),
          ],
          validator: (val) => StringValidation.validatePass(
              val!,
              getTranslated(context, 'PWD_REQUIRED'),
              getTranslated(context, 'PASSWORD_VALIDATION')),
          onSaved: (String? value) {
            context.read<AuthenticationProvider>().setsinUpPassword(value);
          },
          onFieldSubmitted: (v) {
            _fieldFocusChange(context, passFocus!, referFocus);
          },
          decoration: InputDecoration(
            errorMaxLines: 2,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 13,
              vertical: 5,
            ),
            suffixIcon: InkWell(
              onTap: () {
                setState(() {
                  _showPassword = !_showPassword!;
                });
              },
              child: Padding(
                padding: const EdgeInsetsDirectional.only(end: 10.0),
                child: Icon(
                  !_showPassword! ? Icons.visibility : Icons.visibility_off,
                  color:
                      Theme.of(context).colorScheme.fontColor.withOpacity(0.4),
                  size: 22,
                ),
              ),
            ),
            suffixIconConstraints:
                const BoxConstraints(minWidth: 40, maxHeight: 20),
            hintText: getTranslated(context, 'PASSHINT_LBL')!,
            hintStyle: TextStyle(
                color: Theme.of(context).colorScheme.fontColor.withOpacity(0.3),
                fontWeight: FontWeight.bold,
                fontSize: textFontSize13),
            fillColor: Theme.of(context).colorScheme.lightWhite,
            border: InputBorder.none,
          ),
        ),
      ),
    );
  }

  verifyBtn() {
    return Center(
      child: AppBtn(
        title: getTranslated(context, 'SAVE_LBL'),
        btnAnim: buttonSqueezeanimation,
        btnCntrl: buttonController,
        onBtnSelected: () async {
          validateAndSubmit();
        },
      ),
    );
  }

  loginTxt() {
    return Padding(
      padding: const EdgeInsetsDirectional.only(top: 20.0, bottom: 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            getTranslated(context, 'ALREADY_A_CUSTOMER')!,
            style: Theme.of(context).textTheme.titleSmall!.copyWith(
                  color: Theme.of(context).colorScheme.fontColor,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'ubuntu',
                ),
          ),
          InkWell(
            onTap: () {
              Routes.navigateToLoginScreen(context);
            },
            child: Text(
              getTranslated(context, 'LOG_IN_LBL')!,
              style: Theme.of(context).textTheme.titleSmall!.copyWith(
                    color: Theme.of(context).colorScheme.primary,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'ubuntu',
                  ),
            ),
          )
        ],
      ),
    );
  }

  @override
  void initState() {
    SystemChromeSettings.setSystemButtomNavigationBarithTopAndButtom();
    SystemChromeSettings.setSystemUIOverlayStyleWithNoSpecification();

    super.initState();
    getUserDetails();
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

    context.read<AuthenticationProvider>().generateReferral(
          context,
          setStateNow,
        );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Theme.of(context).colorScheme.white,
      key: _scaffoldKey,
      body: isNetworkAvail
          ? SingleChildScrollView(
              padding: EdgeInsets.only(
                  top: 23,
                  left: 23,
                  right: 23,
                  bottom: MediaQuery.of(context).viewInsets.bottom),
              child: Form(
                key: _formkey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    getLogo(),
                    registerTxt(),
                    signUpSubTxt(),
                    setFirstName(),
                    setLastName(),
                    setEmail(),
                    setPass(),
                    setRefer(),
                    verifyBtn(),
                    loginTxt(),
                  ],
                ),
              ),
            )
          : NoInterNet(
              setStateNoInternate: setStateNoInternate,
              buttonSqueezeanimation: buttonSqueezeanimation,
              buttonController: buttonController,
            ),
    );
  }

  Widget getLogo() {
    return Container(
      alignment: Alignment.center,
      padding: const EdgeInsets.only(top: 20),
      child: Image.asset(
        DesignConfiguration.setPngPath('logo'),
        alignment: Alignment.center,
        height: 140,
        width: 120,
        fit: BoxFit.contain,
      ),
    );
  }
}
