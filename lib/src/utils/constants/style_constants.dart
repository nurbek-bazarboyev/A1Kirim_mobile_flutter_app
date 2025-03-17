import 'package:a1_kirim_mobile/src/utils/constants/color_constants.dart';
import 'package:a1_kirim_mobile/src/utils/constants/double_constants.dart';
import 'package:flutter/material.dart';

class TextStyleConstants{
  static TextStyle? textFieldLabelStyle = TextStyle(fontSize: 16,fontWeight: FontWeight.w500);
  static TextStyle? buttonNameStyle = TextStyle(color: Colors.white,fontSize: 18,fontWeight: FontWeight.w700);
  static TextStyle? appBarTitleStyle = TextStyle(color: ColorConstants.appBarWidgetsColor,fontSize: 20,fontWeight: FontWeight.w700);
  static TextStyle? listTileTitleStyle = TextStyle(fontSize: 16,fontWeight: FontWeight.w600);
  static TextStyle? listTileSubTitleStyle = TextStyle(color: Colors.grey,fontSize: 14,fontWeight: FontWeight.w500);
  static TextStyle? takePictureTextStyle = TextStyle(fontSize: 20,fontWeight: FontWeight.w600,color: Color(0xFF140CFF));
  static TextStyle? pictureNumberTextStyle = TextStyle(fontSize: 20,fontWeight: FontWeight.w600,color: Color(0xFF140CFF));
  static TextStyle? simpleTextStyle = TextStyle(fontSize: 16,fontWeight: FontWeight.w500,color: Colors.black);
  static TextStyle? errorTextStyle = TextStyle(fontSize: 16,fontWeight: FontWeight.w500,);
  static TextStyle? successTextStyle = TextStyle(fontSize: 16,fontWeight: FontWeight.w500,color: Colors.white);
  static TextStyle? noDataTextStyle = TextStyle(fontSize: 20,fontWeight: FontWeight.w700,color: Colors.grey);
}

class ButtonStyleConstants{

  static ButtonStyle loginButtonStyle = ButtonStyle(
    backgroundColor: WidgetStateProperty.all(ColorConstants.buttonBackgroundColor),
    shape: WidgetStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(DoubleConstants.loginButtonBorderRadius)))
  );
}