import 'package:flutter/material.dart';
import 'package:music_palyer/styles/color_manager.dart';

TextStyle _getTextStyle(double fontSize, FontWeight fontWeight, Color color) {
  return TextStyle(fontSize: fontSize, fontWeight: fontWeight, color: color);
}

TextStyle getTitileStyle(
    {double fontSize = 19,
    FontWeight fontWeight = FontWeight.w600,
    Color color = AppColor.styleColor}) {
  return _getTextStyle(fontSize, fontWeight, color);
}

TextStyle getSubTitleStyle(
    {double fontSize = 16,
    FontWeight fontWeight = FontWeight.w400,
    Color color = AppColor.styleColor}) {
  return _getTextStyle(fontSize, fontWeight, color);
}
