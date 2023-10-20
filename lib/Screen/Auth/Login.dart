import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:eshop_multivendor/AppScreen/app_tabbar_screen.dart';
import 'package:eshop_multivendor/Provider/Favourite/FavoriteProvider.dart';
import 'package:eshop_multivendor/Provider/SettingProvider.dart';
import 'package:eshop_multivendor/Provider/UserProvider.dart';
import 'package:eshop_multivendor/Screen/Auth/SendOtp.dart';
import 'package:eshop_multivendor/ServiceApp/network/rest_apis.dart';
import 'package:eshop_multivendor/ServiceApp/utils/constant.dart'
    as service_app;
import 'package:eshop_multivendor/main.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart';
import 'package:nb_utils/nb_utils.dart' as nb_utils;
import 'package:provider/provider.dart';
import '../../Helper/ApiBaseHelper.dart';
import '../../Helper/Color.dart';
import '../../Helper/Constant.dart';
import '../../Helper/String.dart';
import '../../Helper/routes.dart';
import '../../Provider/authenticationProvider.dart';
import '../../Provider/productDetailProvider.dart';
import '../../repository/systemRepository.dart';
import '../../widgets/ButtonDesing.dart';
import '../../widgets/desing.dart';
import '../../widgets/snackbar.dart';
import '../../widgets/systemChromeSettings.dart';
import '../Language/languageSettings.dart';
import '../../widgets/networkAvailablity.dart';
import '../../widgets/security.dart';
import '../../widgets/validation.dart';
import '../../widgets/background_image.dart';
import '../Dashboard/Dashboard.dart';
import '../NoInterNetWidget/NoInterNet.dart';
import '../PrivacyPolicy/Privacy_Policy.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<Login> with TickerProviderStateMixin {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final mobileController = TextEditingController();
  final passwordController = TextEditingController();
  String? countryName;
  FocusNode? passFocus, monoFocus = FocusNode();
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  Animation? buttonSqueezeanimation;
  AnimationController? buttonController;
  bool isShowPass = true;
  bool acceptTnC = false;
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  bool socialLoginLoading = false;
  bool? googleLogin, appleLogin;

  @override
  void initState() {
    SystemChromeSettings.setSystemButtomNavigationBarithTopAndButtom();
    SystemChromeSettings.setSystemUIOverlayStyleWithNoSpecification();
    getSystemSettings();

    super.initState();
    buttonController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );

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
  void dispose() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
        overlays: SystemUiOverlay.values);
    SystemChromeSettings.setSystemUIOverlayStyleWithNoSpecification();
    buttonController!.dispose();
    super.dispose();
  }

  Future<void> _playAnimation() async {
    try {
      await buttonController!.forward();
    } on TickerCanceled {}
  }

  void validateAndSubmit() async {
    if (validateAndSave()) {
      _playAnimation();
      checkNetwork();
    }
  }

  Future<void> getSystemSettings() async {
    try {
      setState(() {
        socialLoginLoading = true;
      });
      var getData = await SystemRepository.fetchSystemSetting(parameter: {});
      if (!getData['error']) {
        var data = getData['systemSetting']['system_settings'][0];

        print(
            "data****${getData["systemSetting"]["system_settings"][0].toString()}");
        setState(() {
          googleLogin = data[GOOGLE_LOGIN] == '1' ? true : false;
          appleLogin = data[APPLE_LOGIN] == '1' ? true : false;
        });
      } else {
        setSnackbar(getData['message'], context);
      }
      setState(() {
        socialLoginLoading = false;
      });
    } catch (e) {
      throw ApiException(e.toString());
    }
  }

  Future<void> checkNetwork() async {
    isNetworkAvail = await isNetworkAvailable();
    if (isNetworkAvail) {
      Future.delayed(Duration.zero).then(
        (value) => context.read<AuthenticationProvider>().getLoginData().then(
          (
            value,
          ) async {
            bool error = value['error'];
            String? errorMessage = value['message'];
            login();
            await buttonController!.reverse();
            if (!error) {
              var getdata = value['data'][0];
              UserProvider userProvider =
                  Provider.of<UserProvider>(context, listen: false);
              userProvider.setName(getdata[USERNAME] ?? '');
              userProvider.setEmail(getdata[EMAIL] ?? '');
              userProvider.setProfilePic(getdata[IMAGE] ?? '');
              userProvider.setLoginType(getdata[TYPE] ?? '');

              SettingProvider settingProvider =
                  Provider.of<SettingProvider>(context, listen: false);
              settingProvider.saveUserDetail(
                getdata[ID],
                getdata[USERNAME],
                getdata[EMAIL],
                getdata[MOBILE],
                getdata[CITY],
                getdata[AREA],
                getdata[ADDRESS],
                getdata[PINCODE],
                getdata[LATITUDE],
                getdata[LONGITUDE],
                getdata[IMAGE],
                getdata[TYPE],
                context,
              );
              offFavAdd().then(
                (value) async {
                  db.clearFav();
                  context.read<FavoriteProvider>().setFavlist([]);
                  List cartOffList = await db.getOffCart();
                  if (singleSellerOrderSystem && cartOffList.isNotEmpty) {
                    forLoginPageSingleSellerSystem = true;
                    offSaveAdd().then(
                      (value) {
                        clearYouCartDialog();
                      },
                    );
                  } else {}
                },
              );
            } else {
              setSnackbar(errorMessage!, context);
            }
          },
        ),
      );
    } else {
      Future.delayed(const Duration(seconds: 2)).then(
        (_) async {
          await buttonController!.reverse();
          if (mounted) {
            setState(
              () {
                isNetworkAvail = false;
              },
            );
          }
        },
      );
    }
  }

  void login() async {
    var request = {
      'email': mobileController.text.toString().trim() + "@gmail.com",
      'password': passwordController.text.toString().trim(),
      'player_id': nb_utils.getStringAsync(service_app.PLAYERID),
    };

    appStore.setLoading(true);

    await loginUser(request).then((loginResponse) async {
      if (true) {
        nb_utils.setValue(service_app.USER_EMAIL,
            mobileController.text.toString().trim() + "@gmail.com");
        nb_utils.setValue(service_app.USER_PASSWORD,
            passwordController.text.toString().trim());
        await nb_utils.setValue(service_app.IS_REMEMBERED, true);
      }
      if (loginResponse.userData != null) {
        await saveUserData(loginResponse.userData!);
        offCartAdd().then(
          (value) {
            db.clearCart();
            offSaveAdd().then(
              (value) {
                db.clearSaveForLater();
                Navigator.pushNamedAndRemoveUntil(
                    context, '/home', (r) => false);
              },
            );
          },
        );
        loginResponse.userData!.password =
            passwordController.text.toString().trim();

        await authService
            .signInWithEmailPassword(
                email: loginResponse.userData!.email.validate())
            .then((value) async {})
            .catchError((e) {});
      }
    }).catchError((e) {});

    appStore.setLoading(false);
  }

  clearYouCartDialog() async {
    await DesignConfiguration.dialogAnimate(
      context,
      StatefulBuilder(
        builder: (BuildContext context, StateSetter setStater) {
          return WillPopScope(
            onWillPop: () async {
              return false;
            },
            child: AlertDialog(
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(
                    circularBorderRadius5,
                  ),
                ),
              ),
              title: Text(
                getTranslated(context,
                    'Your cart already has an items of another seller would you like to remove it ?')!,
                softWrap: true,
                overflow: TextOverflow.ellipsis,
                maxLines: 3,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.fontColor,
                  fontWeight: FontWeight.normal,
                  fontSize: textFontSize16,
                  fontFamily: 'ubuntu',
                ),
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Center(
                      child: SvgPicture.asset(
                        DesignConfiguration.setSvgPath('appbarCart'),
                        colorFilter: const ColorFilter.mode(
                            colors.primary, BlendMode.srcIn),
                        height: 50,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 25,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        child: Text(
                          getTranslated(context, 'CANCEL')!,
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.lightBlack,
                            fontSize: textFontSize15,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'ubuntu',
                          ),
                        ),
                        onPressed: () {
                          Routes.pop(context);
                          db.clearSaveForLater();
                          Navigator.pushNamedAndRemoveUntil(
                              context, '/home', (r) => false);
                        },
                      ),
                      TextButton(
                        child: Text(
                          getTranslated(context, 'Clear Cart')!,
                          style: const TextStyle(
                            color: colors.primary,
                            fontSize: textFontSize15,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'ubuntu',
                          ),
                        ),
                        onPressed: () {
                          if (CUR_USERID != null) {
                            context.read<UserProvider>().setCartCount('0');
                            context
                                .read<ProductDetailProvider>()
                                .clearCartNow()
                                .then(
                              (value) async {
                                if (context
                                        .read<ProductDetailProvider>()
                                        .error ==
                                    false) {
                                  if (context
                                          .read<ProductDetailProvider>()
                                          .snackbarmessage ==
                                      'Data deleted successfully') {
                                  } else {
                                    setSnackbar(
                                        context
                                            .read<ProductDetailProvider>()
                                            .snackbarmessage,
                                        context);
                                  }
                                } else {
                                  setSnackbar(
                                      context
                                          .read<ProductDetailProvider>()
                                          .snackbarmessage,
                                      context);
                                }
                                Routes.pop(context);
                                await offCartAdd();
                                db.clearSaveForLater();
                                Navigator.pushNamedAndRemoveUntil(
                                  context,
                                  '/home',
                                  (r) => false,
                                );
                              },
                            );
                          } else {
                            Routes.pop(context);
                            db.clearSaveForLater();
                            Navigator.pushNamedAndRemoveUntil(
                              context,
                              '/home',
                              (r) => false,
                            );
                          }
                        },
                      )
                    ],
                  )
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  bool validateAndSave() {
    final form = _formkey.currentState!;
    form.save();
    if (form.validate()) {
      return true;
    }
    return false;
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
          if (mounted) {
            setState(
              () {},
            );
          }
        }
      },
    );
  }

  Future<void> offFavAdd() async {
    List favOffList = await db.getOffFav();
    if (favOffList.isNotEmpty) {
      for (int i = 0; i < favOffList.length; i++) {
        _setFav(favOffList[i]['PID']);
      }
    }
  }

  _setFav(String pid) async {
    isNetworkAvail = await isNetworkAvailable();
    if (isNetworkAvail) {
      try {
        var parameter = {USER_ID: CUR_USERID, PRODUCT_ID: pid};
        Response response =
            await post(setFavoriteApi, body: parameter, headers: headers)
                .timeout(const Duration(seconds: timeOut));

        var getdata = json.decode(response.body);

        bool error = getdata['error'];
        String? msg = getdata['message'];
        if (!error) {
          setSnackbar(msg!, context);
        } else {
          setSnackbar(msg!, context);
        }
      } on TimeoutException catch (_) {
        setSnackbar(getTranslated(context, 'somethingMSg')!, context);
      }
    } else {
      if (mounted) {
        setState(
          () {
            isNetworkAvail = false;
          },
        );
      }
    }
  }

  Future<void> offCartAdd() async {
    List cartOffList = await db.getOffCart();
    if (cartOffList.isNotEmpty) {
      for (int i = 0; i < cartOffList.length; i++) {
        addToCartCheckout(cartOffList[i]['VID'], cartOffList[i]['QTY']);
      }
    }
  }

  Future<void> addToCartCheckout(String varId, String qty) async {
    isNetworkAvail = await isNetworkAvailable();
    if (isNetworkAvail) {
      try {
        var parameter = {
          PRODUCT_VARIENT_ID: varId,
          USER_ID: CUR_USERID,
          QTY: qty,
        };

        Response response =
            await post(manageCartApi, body: parameter, headers: headers)
                .timeout(const Duration(seconds: timeOut));
        if (response.statusCode == 200) {
          var getdata = json.decode(response.body);
          if (getdata['message'] == 'One of the product is out of stock.') {
            homePageSingleSellerMessage = true;
          }
        }
      } on TimeoutException catch (_) {
        setSnackbar(getTranslated(context, 'somethingMSg')!, context);
      }
    } else {
      if (mounted) isNetworkAvail = false;

      setState(() {});
    }
  }

  Future<void> offSaveAdd() async {
    List saveOffList = await db.getOffSaveLater();

    if (saveOffList.isNotEmpty) {
      for (int i = 0; i < saveOffList.length; i++) {
        saveForLater(saveOffList[i]['VID'], saveOffList[i]['QTY']);
      }
    }
  }

  saveForLater(String vid, String qty) async {
    isNetworkAvail = await isNetworkAvailable();
    if (isNetworkAvail) {
      try {
        var parameter = {
          PRODUCT_VARIENT_ID: vid,
          USER_ID: CUR_USERID,
          QTY: qty,
          SAVE_LATER: '1'
        };
        Response response =
            await post(manageCartApi, body: parameter, headers: headers)
                .timeout(const Duration(seconds: timeOut));
        var getdata = json.decode(response.body);
        bool error = getdata['error'];
        String? msg = getdata['message'];
        if (!error) {
        } else {
          setSnackbar(msg!, context);
        }
      } on TimeoutException catch (_) {
        setSnackbar(getTranslated(context, 'somethingMSg')!, context);
      }
    } else {
      if (mounted) {
        setState(
          () {
            isNetworkAvail = false;
          },
        );
      }
    }
  }

  signInTxt() {
    return Padding(
      padding: const EdgeInsetsDirectional.only(top: 30.0, bottom: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            getTranslated(context, 'SIGNIN_LBL')!,
            style: Theme.of(context).textTheme.titleLarge!.copyWith(
                  color: colors.primary,
                  fontWeight: FontWeight.bold,
                  fontSize: textFontSize23,
                  letterSpacing: 0.8,
                  fontFamily: 'ubuntu',
                ),
          ),
        ],
      ),
    );
  }

  setMobileNo() {
    return Padding(
      padding: const EdgeInsets.only(top: 30),
      child: Container(
        height: 53,
        width: double.maxFinite,
        decoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(circularBorderRadius10),
        ),
        alignment: Alignment.center,
        child: TextFormField(
          onFieldSubmitted: (v) {
            FocusScope.of(context).requestFocus(passFocus);
          },
          style: const TextStyle(
              color: colors.primary,
              fontWeight: FontWeight.bold,
              fontSize: textFontSize16),
          keyboardType: TextInputType.number,
          controller: mobileController,
          focusNode: monoFocus,
          textInputAction: TextInputAction.next,
          maxLength: 15,
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          decoration: InputDecoration(
            counter: const SizedBox(),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 0,
              vertical: 5,
            ),
            hintText: getTranslated(
              context,
              'MOBILEHINT_LBL',
            )!,
            hintStyle: const TextStyle(
                color: colors.black54,
                fontWeight: FontWeight.bold,
                fontSize: textFontSize16),
            fillColor: Colors.transparent,
            enabledBorder: const UnderlineInputBorder(
              borderSide: BorderSide(color: colors.primary),
            ),
            focusedBorder: const UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.black),
            ),
          ),
          validator: (val) => StringValidation.validateMob(
              val!,
              getTranslated(context, 'MOB_REQUIRED'),
              getTranslated(context, 'VALID_MOB')),
          onSaved: (String? value) {
            context.read<AuthenticationProvider>().setMobileNumber(value);
          },
        ),
      ),
    );
  }

  setPass() {
    return Padding(
      padding: const EdgeInsets.only(top: 18, bottom: 0),
      child: Container(
        height: 53,
        width: double.maxFinite,
        decoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(circularBorderRadius10),
        ),
        alignment: Alignment.center,
        child: TextFormField(
          style: const TextStyle(
              color: colors.primary,
              fontWeight: FontWeight.bold,
              fontSize: textFontSize16),
          onFieldSubmitted: (v) {
            passFocus!.unfocus();
          },
          keyboardType: TextInputType.text,
          obscureText: isShowPass,
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
            context.read<AuthenticationProvider>().setPassword(value);
          },
          decoration: InputDecoration(
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 0,
                vertical: 5,
              ),
              suffixIcon: InkWell(
                onTap: () {
                  setState(
                    () {
                      isShowPass = !isShowPass;
                    },
                  );
                },
                child: Padding(
                  padding: const EdgeInsetsDirectional.only(end: 10.0),
                  child: Icon(
                    !isShowPass ? Icons.visibility : Icons.visibility_off,
                    color: colors.primary,
                    size: 22,
                  ),
                ),
              ),
              suffixIconConstraints:
                  const BoxConstraints(minWidth: 40, maxHeight: 20),
              hintText: getTranslated(context, 'PASSHINT_LBL')!,
              hintStyle: const TextStyle(
                  color: colors.black54,
                  fontWeight: FontWeight.bold,
                  fontSize: textFontSize16),
              fillColor: Colors.transparent,
              enabledBorder: const UnderlineInputBorder(
                borderSide: BorderSide(color: colors.primary),
              ),
              focusedBorder: const UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.black),
              ),
              errorMaxLines: 2),
        ),
      ),
    );
  }

  forgetPass() {
    return Padding(
      padding: const EdgeInsetsDirectional.only(top: 20.0, bottom: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          InkWell(
            onTap: () {
              Navigator.push(
                context,
                CupertinoPageRoute(
                  builder: (context) => SendOtp(
                    title: getTranslated(context, 'FORGOT_PASS_TITLE'),
                  ),
                ),
              );
            },
            child: Text(
              getTranslated(context, 'FORGOT_PASSWORD_LBL')!,
              style: Theme.of(context).textTheme.titleSmall!.copyWith(
                    color: Theme.of(context).colorScheme.primary,
                    fontWeight: FontWeight.bold,
                    fontSize: textFontSize15,
                    fontFamily: 'ubuntu',
                  ),
            ),
          ),
        ],
      ),
    );
  }

  signInUser({
    required String type,
  }) async {
    try {
      final result = await context
          .read<AuthenticationProvider>()
          .socialSignInUser(type: type, context: context);
      final user = result['user'] as User;

      Map<String, dynamic> userDataTest = await context
          .read<AuthenticationProvider>()
          .loginAuth(
              mobile: user.phoneNumber ?? '',
              email: user.email ?? '',
              firebaseId: user.uid,
              name:
                  user.displayName ?? (type == APPLE_TYPE ? 'Apple User' : ''),
              type: type);
      print('userdataTest****$userDataTest');
      bool error = userDataTest['error'];
      String? msg = userDataTest['message'];

      setState(() {
        socialLoginLoading = false;
      });
      if (!error) {
        setSnackbar(msg!, context);

        var userdata = userDataTest['data'];
        UserProvider userProvider =
            Provider.of<UserProvider>(context, listen: false);
        userProvider.setName(userdata[USERNAME] ?? '');
        userProvider.setEmail(userdata[EMAIL] ?? '');
        userProvider.setProfilePic(userdata[IMAGE] ?? '');
        userProvider.setLoginType(userdata[TYPE] ?? '');

        SettingProvider settingProvider =
            Provider.of<SettingProvider>(context, listen: false);
        settingProvider.saveUserDetail(
          userdata[ID],
          userdata[USERNAME],
          userdata[EMAIL],
          userdata[MOBILE],
          userdata[CITY],
          userdata[AREA],
          userdata[ADDRESS],
          userdata[PINCODE],
          userdata[LATITUDE],
          userdata[LONGITUDE],
          userdata[IMAGE],
          userdata[TYPE],
          context,
        );

        CUR_USERID = userdata[ID];

        setPrefrenceBool(ISFIRSTTIME, true);

        offFavAdd().then((value) {
          db.clearFav();
          context.read<FavoriteProvider>().setFavlist([]);
          offCartAdd().then((value) {
            db.clearCart();
            offSaveAdd().then((value) {
              db.clearSaveForLater();
              Navigator.pushNamedAndRemoveUntil(context, '/home', (r) => false);
            });
          });
        });
      } else {
        setSnackbar(msg!, context);
      }
    } catch (e) {
      print('login error*****${e.toString()}');
      signOut(type);
      setSnackbar(e.toString(), context);
    }
  }

  Future<void> signOut(String type) async {
    _firebaseAuth.signOut();
    if (type == GOOGLE_TYPE) {
      _googleSignIn.signOut();
    } else {
      _firebaseAuth.signOut();
    }
  }

  Widget orDivider() {
    if (googleLogin == true || (Platform.isIOS ? appleLogin == true : false)) {
      return Padding(
        padding: const EdgeInsets.only(top: 20),
        child: Row(
          children: [
            Flexible(
              child: Divider(
                indent: 30,
                endIndent: 15,
                color: Theme.of(context).colorScheme.fontColor.withOpacity(0.6),
              ),
            ),
            Text(
              getTranslated(context, 'OR_LOGIN_WITH_LBL')!,
              style: Theme.of(context).textTheme.bodySmall!.copyWith(
                  color:
                      Theme.of(context).colorScheme.fontColor.withOpacity(0.8)),
            ),
            Flexible(
                child: Divider(
              indent: 15,
              endIndent: 30,
              color: Theme.of(context).colorScheme.fontColor.withOpacity(0.6),
            )),
          ],
        ),
      );
    } else {
      return const SizedBox.shrink();
    }
  }

  Widget termAndPolicyTxt() {
    if (googleLogin == true || (Platform.isIOS ? appleLogin == true : false)) {
      return Padding(
        padding: const EdgeInsets.only(bottom: 0.0, left: 25.0, right: 25.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Checkbox(
                    activeColor: colors.primary,
                    value: acceptTnC,
                    onChanged: (newValue) {
                      setState(() => acceptTnC = newValue!);
                    }),
                Text(getTranslated(context, 'CONTINUE_AGREE_LBL')!,
                    style: Theme.of(context).textTheme.bodySmall!.copyWith(
                        color: Theme.of(context).colorScheme.fontColor,
                        fontWeight: FontWeight.normal)),
              ],
            ),
            Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              InkWell(
                  onTap: () {
                    Navigator.push(
                        context,
                        CupertinoPageRoute(
                            builder: (context) => PrivacyPolicy(
                                  title: getTranslated(context, 'TERM'),
                                )));
                  },
                  child: Text(
                    getTranslated(context, 'TERMS_SERVICE_LBL')!,
                    style: Theme.of(context).textTheme.bodySmall!.copyWith(
                        color: Theme.of(context).colorScheme.fontColor,
                        decoration: TextDecoration.underline,
                        fontWeight: FontWeight.normal),
                  )),
              const SizedBox(
                width: 5.0,
              ),
              Text(getTranslated(context, 'AND_LBL')!,
                  style: Theme.of(context).textTheme.bodySmall!.copyWith(
                      color: Theme.of(context).colorScheme.fontColor,
                      fontWeight: FontWeight.normal)),
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
                                )));
                  },
                  child: Text(
                    getTranslated(context, 'PRIVACY')!,
                    style: Theme.of(context).textTheme.bodySmall!.copyWith(
                        color: Theme.of(context).colorScheme.fontColor,
                        decoration: TextDecoration.underline,
                        fontWeight: FontWeight.normal),
                  )),
            ]),
          ],
        ),
      );
    } else {
      return const SizedBox.shrink();
    }
  }

  Widget socialLoginBtn() {
    return Padding(
        padding: const EdgeInsets.only(top: 25, bottom: 10),
        child: Center(
          child: Column(
            //crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              if (googleLogin == true)
                InkWell(
                  child: Container(
                    height: 50,
                    alignment: Alignment.center,
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                          color: Colors
                              .white), /* color: Theme.of(context).colorScheme.lightWhite*/
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsetsDirectional.only(
                              start: 0, end: 15),
                          child: Text(
                              getTranslated(context, 'CONTINUE_WITH_GOOGLE')!,
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium!
                                  .copyWith(
                                      fontSize: 18,
                                      color: colors.primary,
                                      fontWeight: FontWeight.bold)),
                        ),
                        SvgPicture.asset(
                          DesignConfiguration.setSvgPath('google_button'),
                          height: 22,
                          width: 22,
                        ),
                      ],
                    ),
                  ),
                  onTap: () async {
                    if (acceptTnC) {
                      isNetworkAvail = await isNetworkAvailable();
                      if (isNetworkAvail) {
                        setState(() {
                          socialLoginLoading = true;
                        });
                        signInUser(type: GOOGLE_TYPE);
                      } else {
                        Future.delayed(const Duration(seconds: 2))
                            .then((_) async {
                          await buttonController!.reverse();
                          if (mounted) {
                            setState(() {
                              isNetworkAvail = false;
                            });
                          }
                        });
                      }
                    } else {
                      setSnackbar(
                          getTranslated(context, 'agreeTCFirst')!, context);
                    }
                  },
                ),
              if (appleLogin == true)
                if (Platform.isIOS)
                  Padding(
                    padding: const EdgeInsets.only(top: 25),
                    child: InkWell(
                      child: Container(
                        height: 45,
                        alignment: Alignment.center,
                        width: deviceWidth! * 0.7,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: colors.primary)),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SvgPicture.asset(
                              DesignConfiguration.setSvgPath('apple_logo'),
                              height: 22,
                              width: 22,
                            ),
                            Padding(
                              padding:
                                  const EdgeInsetsDirectional.only(start: 15),
                              child: Text(
                                  getTranslated(
                                      context, 'CONTINUE_WITH_APPLE')!,
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleMedium!
                                      .copyWith(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .fontColor,
                                          fontWeight: FontWeight.normal)),
                            )
                          ],
                        ),
                      ),
                      onTap: () async {
                        if (acceptTnC) {
                          isNetworkAvail = await isNetworkAvailable();
                          if (isNetworkAvail) {
                            setState(() {
                              socialLoginLoading = true;
                            });
                            signInUser(type: APPLE_TYPE);
                          } else {
                            Future.delayed(const Duration(seconds: 2))
                                .then((_) async {
                              await buttonController!.reverse();
                              if (mounted) {
                                setState(() {
                                  isNetworkAvail = false;
                                });
                              }
                            });
                          }
                        } else {
                          setSnackbar(
                              getTranslated(context, 'agreeTCFirst')!, context);
                        }
                      },
                    ),
                  )
            ],
          ),
        ));
  }

  setDontHaveAcc() {
    return Padding(
      padding: const EdgeInsetsDirectional.only(top: 10.0, bottom: 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          InkWell(
            onTap: () {
              Navigator.of(context).push(
                CupertinoPageRoute(
                  builder: (BuildContext context) => SendOtp(
                    title: getTranslated(context, 'SEND_OTP_TITLE'),
                  ),
                ),
              );
            },
            child: Text(
              getTranslated(context, 'or_sign_up')!,
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

  loginBtn() {
    return Padding(
      padding: const EdgeInsets.only(top: 0.0),
      child: Center(
        child: Consumer<AuthenticationProvider>(
          builder: (context, value, child) {
            return AppBtn(
              title: getTranslated(context, 'SIGNIN_LBL'),
              btnAnim: buttonSqueezeanimation,
              btnCntrl: buttonController,
              onBtnSelected: () async {
                if (passFocus != null) {
                  passFocus!.unfocus();
                }
                if (monoFocus != null) {
                  monoFocus!.unfocus();
                }
                validateAndSubmit();
              },
            );
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        backgroundColor: Theme.of(context).colorScheme.white,
        key: _scaffoldKey,
        body: isNetworkAvail
            ? Stack(
                children: [
                  const BackgroundImage(),
                  SingleChildScrollView(
                    padding: EdgeInsets.only(
                      top: 20,
                      left: 30,
                      right: 30,
                      bottom: MediaQuery.of(context).viewInsets.bottom,
                    ),
                    child: Form(
                      key: _formkey,
                      child: Stack(
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              getLogo(),
                              signInTxt(),
                              Container(
                                decoration: const BoxDecoration(
                                    borderRadius: BorderRadius.only(
                                      topRight: Radius.circular(25),
                                      bottomLeft: Radius.circular(25),
                                    ),
                                    color: colors.whiteTemp),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 15),
                                  child: Column(
                                    children: [
                                      setMobileNo(),
                                      setPass(),
                                      forgetPass(),
                                    ],
                                  ),
                                ),
                              ),
                              loginBtn(),
                              socialLoginBtn(),
                              setDontHaveAcc(),
                            ],
                          ),
                          if (socialLoginLoading)
                            Positioned.fill(
                              child: Center(
                                  child:
                                      DesignConfiguration.showCircularProgress(
                                          socialLoginLoading, colors.primary)),
                            ),
                        ],
                      ),
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.only(top: 15, left: 15),
                    child: Icon(
                      Icons.arrow_back_ios_new_outlined,
                      color: colors.primary,
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

  Widget bottomDivider() {
    if (googleLogin == true || (Platform.isIOS ? appleLogin == true : false)) {
      return Padding(
        padding: const EdgeInsets.only(top: 20.0),
        child: Divider(
          indent: 20,
          endIndent: 20,
          color: Theme.of(context).colorScheme.fontColor.withOpacity(0.6),
        ),
      );
    } else {
      return const SizedBox.shrink();
    }
  }

  Widget getLogo() {
    return Container(
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
}
