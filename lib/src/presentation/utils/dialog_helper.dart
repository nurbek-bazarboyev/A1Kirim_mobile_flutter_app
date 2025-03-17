import 'package:a1_kirim_mobile/src/domain/models/market.dart';
import 'package:a1_kirim_mobile/src/presentation/widgets/dialog_widgets/circular_progress_dialog.dart';
import 'package:a1_kirim_mobile/src/presentation/widgets/dialog_widgets/market_info_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DialogHelper{
  // this class contains dialogs that can be used over app (marketInfoDialog,circularProgressDialog,errorDialog and so on)

  static marketInfoDialog(BuildContext context, Market market){
    showDialog(context: context, builder: (context){
      return MarketInfoDialog(market: market);
    });
  }
  static progressIndicatorDialog(BuildContext context, String text){
    //print("in dialog..");
    showDialog(context: context, builder: (context){
      return CircularProgressDialog(text: text);
    });
  }



}