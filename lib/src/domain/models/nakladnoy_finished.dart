import 'dart:convert';

import 'package:a1_kirim_mobile/src/data/repositories/local_database_repositories/nakladnoy_repository.dart';
import 'package:a1_kirim_mobile/src/domain/models/nakladnoy.dart';
import 'package:a1_kirim_mobile/src/domain/models/nakladnoy_item.dart';

class NakladnoyFinished {
  final int rekvizitIdAndSana;
  final int rekvizitId;
  final int userId;
  final String sana;
  final int status;
  final int waybillId;
  final String waybillNumber;
  final double summa;
  final String hodimName;
  final double jamiSumma;
  final List<NakladnoyItem> items;

  NakladnoyFinished({
    required this.hodimName,
    required this.jamiSumma,
    required this.items,
    required this.rekvizitIdAndSana,
    required this.rekvizitId,
    required this.userId,
    required this.sana,
    required this.status,
    required this.waybillId,
    required this.waybillNumber,
    required this.summa
  });

  factory NakladnoyFinished.fromJson(String json) {
    final jsonData = jsonDecode(json);
    print("Nakladnoy.fromJson json: $jsonData");
    List<NakladnoyItem> items = convertDataToNakladnoyItemList(jsonData['map']['waybill']['myArrayList']);
    return NakladnoyFinished(
      rekvizitIdAndSana: createRekvizitIdAndSana(rekvizitId: jsonData['rekvizitId'], sanaInt: covertDateToInt(jsonData['waybillDate'])),
      rekvizitId: jsonData['rekvizitId'],
      userId: jsonData['userId'],
      sana: jsonData['waybillDate'].split(' ')[0],
      status: 1,
      waybillId: jsonData['waybillId'],
      waybillNumber: jsonData['waybillNumber'],
      summa: jsonData['summa'],
      hodimName: jsonData['hodimName'],
      jamiSumma: jsonData['jamiSumma'],
      items: items,

    );
  }

}