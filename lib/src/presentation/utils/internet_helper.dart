
import 'dart:io';

import 'package:a1_kirim_mobile/src/utils/constants/color_constants.dart';
import 'package:a1_kirim_mobile/src/utils/constants/style_constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class InternetHelper{
  static Future<bool> checkInternet(BuildContext context)async{
    try {
      final result = await InternetAddress.lookup('example.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        print('connected');
        // ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Internetga ulangan",style: TextStyleConstants.successTextStyle,),backgroundColor: ColorConstants.successColor,));
        return true;
      }
      return true;
    } on SocketException catch (_) {
      print('not connected');
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Internet mavjud emas",style: TextStyleConstants.errorTextStyle,),backgroundColor: ColorConstants.errorColor,));
      return false;
    }
  }
}
