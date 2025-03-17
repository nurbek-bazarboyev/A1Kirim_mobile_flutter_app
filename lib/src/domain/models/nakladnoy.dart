import 'dart:convert';

import 'package:a1_kirim_mobile/src/data/repositories/local_database_repositories/nakladnoy_repository.dart';
import 'package:a1_kirim_mobile/src/domain/models/nakladnoy_item.dart';

class Nakladnoy {
  final int rekvizitIdAndSana;
  final int rekvizitId;
  final int userId;
  final String sana;
  final int status;
  final int waybillId;
  final String waybillNumber;
  final double summa;
  final String? paymentType;
  final double chegirmaSumma;
  final double chegirmaBilan;

  Nakladnoy({
      required this.rekvizitIdAndSana,
      required this.rekvizitId,
      required this.userId,
      required this.sana,
      required this.status,
      required this.waybillId,
      required this.waybillNumber,
      required this.summa,
      this.paymentType,
      required this.chegirmaBilan,
      required this.chegirmaSumma
  });

  factory Nakladnoy.fromJson(String json) {
    final jsonData = jsonDecode(json);
    print("Nakladnoy.fromJson json: $jsonData");
    return Nakladnoy(
        rekvizitIdAndSana: createRekvizitIdAndSana(rekvizitId: jsonData['rekvizitId'], sanaInt: covertDateToInt(jsonData['waybillDate'])),
        rekvizitId: jsonData['rekvizitId'],
        userId: jsonData['userId'],
        sana: jsonData['waybillDate'].split(' ')[0],
        status: 1,
        waybillId: jsonData['waybillId'],
        waybillNumber: jsonData['waybillNumber'],
        summa: jsonData['summa'],
        chegirmaSumma: jsonData['chegirmaSumma'],
        chegirmaBilan: jsonData['summa']-jsonData['chegirmaSumma'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'rekvizitIdAndSana': this.rekvizitIdAndSana,
      'rekvizitId': this.rekvizitId,
      'userId': this.userId,
      'sana': this.sana,
      'status': this.status,
      'waybillId': this.waybillId,
      'waybillNumber': this.waybillNumber,
      'summa': this.summa,
      'paymentType': this.paymentType,
      'chegirmaSumma': this.chegirmaSumma,
      'chegirmaBilan': this.chegirmaBilan
    };
  }
}

List<NakladnoyItem> convertDataToNakladnoyItemList(List<Map<String,dynamic>> data){
  List<NakladnoyItem> listNakItems = [];
  data.forEach((nakladnoyItem){
    print("converting in convertDataToNakladnoyItemList forEach  nakladnoyItem: $nakladnoyItem");
    listNakItems.add(NakladnoyItem.fromJson(nakladnoyItem));
  });
  print(listNakItems);
  return listNakItems;
}

int covertDateToInt(String date) {
  String son = '';
  for (int i = 0; i < date.length; i++) {
    if (date[i] != '-'&& i<10) {
      son += date[i];
    } else {
      continue;
    }
  }
  return int.parse(son);
}