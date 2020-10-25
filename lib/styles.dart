import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Styles {
  static ThemeData themeData(bool isDarkTheme, BuildContext context) {
    return ThemeData(
      primarySwatch: Colors.deepPurple,
      primaryColor: isDarkTheme ? Colors.black : Colors.white,
      backgroundColor: isDarkTheme ? Colors.black : Color(0xffF1F5FB),
      indicatorColor: isDarkTheme ? Color(0xff0E1D36) : Color(0xffCBDCF8),
      buttonColor: isDarkTheme ? Color(0xff3B3B3B) : Color(0xffF1F5FB),
      hintColor: isDarkTheme ? Colors.white : Colors.black,
      hoverColor: isDarkTheme ? Color(0xff3A3A3B) : Color(0xff4285F4),
      textTheme: TextTheme(
        headline6: TextStyle(
          fontFamily: 'Poppins',
          color: isDarkTheme ? Colors.white : Colors.grey[900],
        ),

      ),
      focusColor: isDarkTheme ? Color(0xff0B2512) : Color(0xffA8DAB5),
      disabledColor: Colors.grey,
      textSelectionColor: isDarkTheme ? Colors.white : Colors.black,
      cardColor: isDarkTheme ? Color(0xFF151515) : Colors.white,
      iconTheme:
          IconThemeData(color: isDarkTheme ? Colors.white : Colors.black87),
      canvasColor:
          isDarkTheme ? Colors.grey[900] /*(0xFF151515)*/ : Colors.grey[50],
      brightness: isDarkTheme ? Brightness.dark : Brightness.light,
      buttonTheme: Theme.of(context).buttonTheme.copyWith(
          colorScheme: isDarkTheme ? ColorScheme.dark() : ColorScheme.light()),
      appBarTheme: AppBarTheme(
          color: isDarkTheme ? Color(0xFF101010) : Colors.white,
          brightness: Platform.isAndroid ? Brightness.dark : Brightness.light,
          iconTheme:
              IconThemeData(color: isDarkTheme ? Colors.white : Colors.black87),
          textTheme: TextTheme(
              headline6: TextStyle(
            fontFamily: 'Poppins',
            fontSize: 17,
            fontWeight: FontWeight.w500,
            color: isDarkTheme ? Colors.white : Colors.grey[900],
          ))),
    );
  }
}
