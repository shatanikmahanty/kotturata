import 'dart:io';

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
      cardTheme: isDarkTheme ? CardTheme(
        color: Color(0xFF151515).withOpacity(0.7)
      ) : CardTheme(color: Colors.white),
      textTheme: TextTheme(
        headline6: TextStyle(
          fontFamily: 'Poppins',
          color: isDarkTheme ? Colors.white : Colors.grey[900],
        ),

      ),
      disabledColor: Colors.grey,
      textSelectionColor: isDarkTheme ? Colors.white : Colors.black,
      iconTheme:
          IconThemeData(color: isDarkTheme ? Colors.white : Colors.black87),
      canvasColor:
          isDarkTheme ? Color(0xFF151515) : Colors.grey[100],
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
