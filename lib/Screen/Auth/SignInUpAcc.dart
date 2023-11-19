import 'package:eshop_multivendor/Helper/Color.dart';
import 'package:eshop_multivendor/Screen/Auth/Login.dart';
import 'package:eshop_multivendor/widgets/background_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../Helper/Constant.dart';
import '../../Helper/String.dart';
import '../../Helper/routes.dart';
import '../../widgets/desing.dart';
import '../Language/languageSettings.dart';
import 'SendOtp.dart';

class SignInUpAcc extends StatefulWidget {
  const SignInUpAcc({Key? key}) : super(key: key);

  @override
  _SignInUpAccState createState() => _SignInUpAccState();
}

class _SignInUpAccState extends State<SignInUpAcc> {
  @override
  void initState() {
    super.initState();
  }

  _subLogo() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Padding(
          padding: EdgeInsetsDirectional.only(
              top: MediaQuery.of(context).size.height * .07),
          child: Image.asset(
            DesignConfiguration.setPngPath('logo'),
            height: 360,
            width: 220,
            fit: BoxFit.contain,
          ),
        ),
      ],
    );
  }

  signInBtn() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        GestureDetector(
          onTap: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => const Login()));
          },
          child: Container(
            alignment: FractionalOffset.center,
            decoration: const BoxDecoration(
              color: colors.primary,
              borderRadius: BorderRadius.only(
                  topRight: Radius.circular(10),
                  bottomLeft: Radius.circular(10)),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              child: Text(
                getTranslated(context, 'sign_in_with_phoneNumber')!,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.titleSmall!.copyWith(
                      color: colors.whiteTemp,
                      fontWeight: FontWeight.bold,
                      fontSize: textFontSize16,
                      fontFamily: 'ubuntu',
                    ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  createAccBtn() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        GestureDetector(
          onTap: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => const Login()));
          },
          child: Container(
            alignment: FractionalOffset.center,
            decoration: const BoxDecoration(
              color: colors.primary,
              borderRadius: BorderRadius.only(
                  topRight: Radius.circular(10),
                  bottomLeft: Radius.circular(10)),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              child: Text(
                getTranslated(context, 'sign_in_with_gmail')!,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.titleSmall!.copyWith(
                      color: colors.whiteTemp,
                      fontWeight: FontWeight.bold,
                      fontSize: textFontSize16,
                      fontFamily: 'ubuntu',
                    ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  bottomBtn() {
    return Padding(
      padding: EdgeInsets.only(top: deviceHeight! * 0.06),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          InkWell(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => SendOtp(
                            title: getTranslated(context, 'SEND_OTP_TITLE'),
                          )));
            },
            child: Text(
              getTranslated(context, 'CREATE_ACC_LBL')!,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleSmall!.copyWith(
                    color: colors.primary,
                    fontWeight: FontWeight.bold,
                    fontSize: textFontSize13,
                    fontFamily: 'ubuntu',
                  ),
            ),
          ),
          const SizedBox(
            height: 15,
          ),
          // createAccBtn(),
          // const SizedBox(
          //   height: 15,
          // ),
          signInBtn(),
          const SizedBox(
            height: 15,
          ),
          // Row(
          //   mainAxisAlignment: MainAxisAlignment.center,
          //   children: [
          //     Text(
          //       getTranslated(context, 'ALREADY_A_CUSTOMER')!,
          //       textAlign: TextAlign.center,
          //       style: Theme.of(context).textTheme.titleSmall!.copyWith(
          //             color: colors.primary,
          //             fontWeight: FontWeight.bold,
          //             fontSize: textFontSize13,
          //             fontFamily: 'ubuntu',
          //           ),
          //     ),
          //     const SizedBox(
          //       width: 5,
          //     ),
          //     GestureDetector(
          //       onTap: () {
          //         Navigator.push(context,
          //             MaterialPageRoute(builder: (context) => const Login()));
          //       },
          //       child: Text(
          //         getTranslated(context, 'SIGNIN_LBL')!,
          //         textAlign: TextAlign.center,
          //         style: Theme.of(context).textTheme.titleSmall!.copyWith(
          //               color: colors.primary,
          //               fontWeight: FontWeight.bold,
          //               fontSize: textFontSize13,
          //               fontFamily: 'ubuntu',
          //             ),
          //       ),
          //     ),
          //   ],
          // ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: true,
      child: Scaffold(
        body: Stack(
          children: [
            const BackgroundImage(),
            Container(
              padding: const EdgeInsetsDirectional.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [_subLogo(), bottomBtn()],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
