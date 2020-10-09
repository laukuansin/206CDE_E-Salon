
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gps_tracking_system/color.dart';

class TextStyleFactory{

  static final primaryFontBuilder = GoogleFonts.openSans;

  static TextStyle p({
    Color color = secondaryTextColor
    ,FontWeight fontWeight = FontWeight.normal
    ,FontStyle fontStyle = FontStyle.normal
    ,double fontSize = 14
    ,})=>primaryFontBuilder(
    fontWeight: fontWeight,
    fontStyle: fontStyle,
    fontSize: fontSize,
    color: color
  );

  static TextStyle heading6({
    Color color = primaryTextColor
    ,FontWeight fontWeight = FontWeight.bold
    ,FontStyle fontStyle = FontStyle.normal
    ,double fontSize = 14
    ,})=>primaryFontBuilder(
      fontWeight: fontWeight,
      fontStyle: fontStyle,
      fontSize: fontSize,
      color: color
  );

  static TextStyle heading5({
    Color color = primaryTextColor
    ,FontWeight fontWeight = FontWeight.bold
    ,FontStyle fontStyle = FontStyle.normal
    ,double fontSize = 16
    ,})=>primaryFontBuilder(
      fontWeight: fontWeight,
      fontStyle: fontStyle,
      fontSize: fontSize,
      color: color
  );

  static TextStyle heading4({
    Color color = primaryTextColor
    ,FontWeight fontWeight = FontWeight.bold
    ,FontStyle fontStyle = FontStyle.normal
    ,double fontSize = 18
    ,})=>primaryFontBuilder(
      fontWeight: fontWeight,
      fontStyle: fontStyle,
      fontSize: fontSize,
      color: color
  );

  static TextStyle heading3({
    Color color = primaryTextColor
    ,FontWeight fontWeight = FontWeight.bold
    ,FontStyle fontStyle = FontStyle.normal
    ,double fontSize = 20
    ,})=>primaryFontBuilder(
      fontWeight: fontWeight,
      fontStyle: fontStyle,
      fontSize: fontSize,
      color: color
  );

  static TextStyle heading2({
    Color color = primaryTextColor
    ,FontWeight fontWeight = FontWeight.bold
    ,FontStyle fontStyle = FontStyle.normal
    ,double fontSize = 22
    ,})=>primaryFontBuilder(
      fontWeight: fontWeight,
      fontStyle: fontStyle,
      fontSize: fontSize,
      color: color
  );

  static TextStyle heading1({
    Color color = primaryTextColor
    ,FontWeight fontWeight = FontWeight.bold
    ,FontStyle fontStyle = FontStyle.normal
    ,double fontSize = 24
    ,})=>primaryFontBuilder(
      fontWeight: fontWeight,
      fontStyle: fontStyle,
      fontSize: fontSize,
      color: color
  );

}

