import 'package:flutter/material.dart';

/// Font family enum matching the main app's Pretendard font variants.
enum FontFamily {
  thin('Pretendard-Thin'),
  extraLight('Pretendard-ExtraLight'),
  light('Pretendard-Light'),
  regular('Pretendard-Regular'),
  medium('Pretendard-Medium'),
  semiBold('Pretendard-SemiBold'),
  bold('Pretendard-Bold'),
  extraBold('Pretendard-ExtraBold'),
  black('Pretendard-Black');

  final String name;
  const FontFamily(this.name);
}

/// Lightweight subset of the main app's Styles class.
/// Only includes helpers used by report chart painters.
class Styles {
  static final Styles _instance = Styles._();
  factory Styles() => _instance;
  Styles._();

  TextStyle pretendard({
    Color? color,
    double? fontSize,
    double? letterSpacing,
    double? height,
    FontStyle fontStyle = FontStyle.normal,
    TextDecoration? decoration,
    Color? decorationColor,
    FontFamily fontFamily = FontFamily.regular,
    List<FontFeature>? fontFeatures,
  }) {
    return TextStyle(
      color: color,
      height: height,
      fontSize: fontSize,
      fontStyle: fontStyle,
      letterSpacing: letterSpacing,
      decoration: decoration,
      decorationColor: decorationColor,
      fontFamily: fontFamily.name,
      fontFeatures: fontFeatures,
    );
  }
}
