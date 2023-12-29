import 'package:flutter/material.dart';
import 'package:freelancediteur/app_localizations.dart';
import 'package:freelancediteur/utils/Colors.dart';
import 'package:freelancediteur/utils/app_widget.dart';
import 'package:freelancediteur/utils/config.dart';
import 'package:freelancediteur/utils/images.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:splash_screen_view/SplashScreenView.dart';

import '../main.dart';
import 'dashboard_screen.dart';

class SplashScreen extends StatefulWidget {
  static String tag = '/SplashScreen';

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    setStatusBarColor(Colors.white);
    init();
  }

  Future<void> init() async {
    //
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appStore.scaffoldBackground,
      body: CustomTheme(
        child: SplashScreenView(
          navigateRoute: DashboardScreen(),
          duration: 1500,
          imageSize: 350,
          imageSrc: ic_logo,
          text: keyString(context, "app_name"),
          textType: TextType.ColorizeAnimationText,
          textStyle: TextStyle(fontSize: 30.0, fontWeight: FontWeight.bold),
          colors: [
            PRIMARY_COLOR,
            accentColor,
            PRIMARY_COLOR,
            accentColor,
            PRIMARY_COLOR,
            accentColor,
          ],
          backgroundColor: Colors.white,
        ),
      ),
    );
  }
}
