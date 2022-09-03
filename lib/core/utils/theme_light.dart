import 'package:flutter/material.dart';
import 'package:mysocial_app/core/utils/colors.dart';

ThemeData lightTheme = ThemeData(
  dividerColor: Colors.transparent,
  splashColor: Colors.transparent,
  highlightColor: Colors.transparent,
  brightness: Brightness.light,
  fontFamily: 'NotoSans',
  scaffoldBackgroundColor: Colors.white,
  appBarTheme: const AppBarTheme(
      titleTextStyle: TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    fontFamily: 'PoliteType',
  )),
  inputDecorationTheme: const InputDecorationTheme(
    // fillColor: Color.fromRGBO(71, 5, 175, 0.1),
    floatingLabelBehavior: FloatingLabelBehavior.auto,
    contentPadding: EdgeInsets.symmetric(horizontal: 18, vertical: 18),
    labelStyle: TextStyle(
        // fontSize: 13,
        fontWeight: FontWeight.w400,
        color: Colors.black),
    helperStyle: TextStyle(fontSize: 8),
    errorStyle: TextStyle(fontSize: 8),
    isDense: true,
    hintStyle: TextStyle(fontSize: 13),
    // filled: true,
    //   focusedErrorBorder: OutlineInputBorder(
    //       borderSide: BorderSide(color: Colors.transparent),
    //       borderRadius: BorderRadius.circular(8)),
    border: OutlineInputBorder(
      borderSide: BorderSide(width: 0.5),
      // borderRadius: BorderRadius.circular(8)
    ),
    //   enabledBorder: OutlineInputBorder(
    //       borderSide: BorderSide(color: Colors.transparent),
    //       borderRadius: BorderRadius.circular(8)),
    //   errorBorder: OutlineInputBorder(
    //       borderSide: BorderSide(color: Colors.transparent),
    //       borderRadius: BorderRadius.circular(8)),
    //   focusedBorder: OutlineInputBorder(
    //       borderSide: BorderSide(color: Colors.transparent),
    //       borderRadius: BorderRadius.circular(8)),
    //   hintStyle: TextStyle(color: Colors.black),
  ),
  primarySwatch: appColor,
  primaryColor: appColor,
  bottomSheetTheme:
      const BottomSheetThemeData(backgroundColor: Colors.transparent),
  visualDensity: VisualDensity.adaptivePlatformDensity,
  textTheme: TextTheme(
      headline1: TextStyle(
          fontSize: 22.0,
          fontFamily: 'NotoSans',
          fontWeight: FontWeight.w500,
          color: appColor),
      headline2: const TextStyle(
          fontSize: 20.0,
          fontFamily: 'NotoSans',
          fontWeight: FontWeight.w400,
          color: Colors.black),
      headline3: const TextStyle(
          fontSize: 18.0,
          fontFamily: 'NotoSans',
          fontWeight: FontWeight.w400,
          color: Colors.black),
      headline4: const TextStyle(
          fontSize: 14.0,
          fontFamily: 'NotoSans',
          fontWeight: FontWeight.w400,
          color: Colors.black),
      bodyText1: const TextStyle(
        fontSize: 13.0,
        fontFamily: 'NotoSans',
        color: Color.fromRGBO(75, 75, 75, 1),
        fontWeight: FontWeight.w400,
      ),
      subtitle1: const TextStyle(
        fontSize: 13.0,
        fontFamily: 'NotoSans',
        color: Color.fromRGBO(75, 75, 75, 1),
        fontWeight: FontWeight.w400,
      ),
      bodyText2: const TextStyle(
        fontSize: 13.0,
        fontFamily: 'NotoSans',
      )),
);
