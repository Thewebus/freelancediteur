import 'package:flutter/material.dart';
import 'package:freelancediteur/utils/config.dart';
import 'package:nb_utils/nb_utils.dart';

import 'Colors.dart';
import 'Strings.dart';

class AppThemeData {
  AppThemeData._();

  static final ThemeData lightTheme = ThemeData(
    scaffoldBackgroundColor: whiteColor,
    primaryColor: PRIMARY_COLOR,
    primaryColorDark: PRIMARY_COLOR,
    hoverColor: Colors.grey,
    dividerColor: viewLineColor,
    appBarTheme: AppBarTheme(
      color: appLayout_background,
      iconTheme: IconThemeData(color: textPrimaryColor),
    ),
    colorScheme: ColorScheme.light(
      primary: PRIMARY_COLOR,
    ),
    cardTheme: CardTheme(color: Colors.white),
    iconTheme: IconThemeData(color: textPrimaryColor),
    bottomSheetTheme: BottomSheetThemeData(backgroundColor: whiteColor),
    textTheme: TextTheme(
      labelLarge: TextStyle(color: PRIMARY_COLOR),
      //labelLarge: TextStyle(color: PRIMARY_COLOR),
      /*
      button: TextStyle(color: PRIMARY_COLOR),
      headline6: TextStyle(color: textPrimaryColor),
      subtitle2: TextStyle(color: textSecondaryColor),
    */
    ),
    fontFamily: font,
  );

  static final ThemeData darkTheme = ThemeData(
    scaffoldBackgroundColor: appBackgroundColorDark,
    highlightColor: appBackgroundColorDark,
    //errorColor: Color(0xFFCF6676),
    appBarTheme: AppBarTheme(
        color: appBackgroundColorDark,
        iconTheme: IconThemeData(color: whiteColor)),
    primaryColor: color_primary_black,
    dividerColor: Color(0xFFDADADA).withOpacity(0.3),
    primaryColorDark: color_primary_black,
    hoverColor: Colors.black,
    bottomSheetTheme:
        BottomSheetThemeData(backgroundColor: appBackgroundColorDark),
    primaryTextTheme: TextTheme(
      headline6: primaryTextStyle(color: Colors.white),
      overline: primaryTextStyle(color: Colors.white),
    ),
    colorScheme: ColorScheme.light(
      primary: appBackgroundColorDark,
      onPrimary: cardBackgroundBlackDark,
    ),
    cardTheme: CardTheme(color: cardBackgroundBlackDark),
    iconTheme: IconThemeData(color: whiteColor),
    textTheme: TextTheme(
      button: TextStyle(color: color_primary_black),
      headline6: TextStyle(color: whiteColor),
      subtitle2: TextStyle(color: Colors.white54),
    ),
    fontFamily: font,
  );
}
