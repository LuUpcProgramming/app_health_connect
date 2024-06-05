import 'package:app_health_connect/utils/theme/widget_themes/appbar_theme.dart';
import 'package:app_health_connect/utils/theme/widget_themes/bottom_sheet_theme.dart';
import 'package:app_health_connect/utils/theme/widget_themes/checkbox_theme.dart';
import 'package:app_health_connect/utils/theme/widget_themes/chip_theme.dart';
import 'package:app_health_connect/utils/theme/widget_themes/elevated_button_theme.dart';
import 'package:app_health_connect/utils/theme/widget_themes/outlined_button_theme.dart';
import 'package:app_health_connect/utils/theme/widget_themes/text_field_theme.dart';
import 'package:app_health_connect/utils/theme/widget_themes/text_theme.dart';
import 'package:flutter/material.dart';

import '../constants/colors.dart';

class TAppTheme {
  TAppTheme._();

  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    //fontFamily: 'Poppins',
    fontFamily: 'Poppins',
    disabledColor: TColors.grey,
    brightness: Brightness.light,
    primaryColor: TColors.primary,
    textTheme: TTextTheme.lightTextTheme,
    chipTheme: TChipTheme.lightChipTheme,
    scaffoldBackgroundColor: TColors.white,
    appBarTheme: TAppBarTheme.lightAppBarTheme,
    checkboxTheme: TCheckboxTheme.lightCheckboxTheme,
    bottomSheetTheme: TBottomSheetTheme.lightBottomSheetTheme,
    elevatedButtonTheme: TElevatedButtonTheme.lightElevatedButtonTheme,
    outlinedButtonTheme: TOutlinedButtonTheme.lightOutlinedButtonTheme,
    inputDecorationTheme: TTextFormFieldTheme.lightInputDecorationTheme,
  );

  static ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    //fontFamily: 'Poppins',
    fontFamily: 'Poppins',
    disabledColor: TColors.grey,
    brightness: Brightness.dark,
    primaryColor: TColors.primary,
    textTheme: TTextTheme.darkTextTheme,
    chipTheme: TChipTheme.darkChipTheme,
    scaffoldBackgroundColor: TColors.black,
    appBarTheme: TAppBarTheme.darkAppBarTheme,
    checkboxTheme: TCheckboxTheme.darkCheckboxTheme,
    bottomSheetTheme: TBottomSheetTheme.darkBottomSheetTheme,
    elevatedButtonTheme: TElevatedButtonTheme.darkElevatedButtonTheme,
    outlinedButtonTheme: TOutlinedButtonTheme.darkOutlinedButtonTheme,
    inputDecorationTheme: TTextFormFieldTheme.darkInputDecorationTheme,
  );

  static TextStyle textThemeTitle = const TextStyle(
      fontSize: 24,
      fontFamily: 'Poppins',
      color: TColors.primary,
      fontWeight: FontWeight.w600,
  );

  static TextStyle textThemeSubTitleDark = const TextStyle(
      fontSize: 16,
      fontFamily: 'Poppins',
      fontStyle: FontStyle.italic,
      color: TColors.dark,
      fontWeight: FontWeight.w500,
  );

   static TextStyle textThemeSubTitlePrimary = const TextStyle(
      fontSize: 16,
      fontFamily: 'Poppins',
      fontStyle: FontStyle.italic,
      color: TColors.primary,
      fontWeight: FontWeight.w500,
  );

  static TextStyle textThemeCustom (double fontSize,
  String fontFamily,
  FontStyle fontStyle,
  Color color,
  FontWeight fontWeight){
    return   TextStyle(
      fontSize: fontSize ,
      fontFamily: fontFamily,
      fontStyle: fontStyle,
      color: color,
      fontWeight: fontWeight,
  );
  } 
  
}
