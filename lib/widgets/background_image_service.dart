import 'package:flutter/material.dart';

class BackgroundImageService extends StatefulWidget {
  const BackgroundImageService({Key? key}) : super(key: key);

  @override
  State<BackgroundImageService> createState() => _BackgroundImageServiceState();
}

class _BackgroundImageServiceState extends State<BackgroundImageService> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 1,
      width: MediaQuery.of(context).size.width * 1,
      child: Image.asset(
        'assets/images/png/service_background.png',
        fit: BoxFit.fill,
      ),
    );
  }
}
