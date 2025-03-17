import 'dart:convert';

import 'package:a1_kirim_mobile/src/data/data_sources/api_service.dart';
import 'package:a1_kirim_mobile/src/data/repositories/local_database_repositories/kirim_repository.dart';
import 'package:a1_kirim_mobile/src/domain/models/kirim.dart';
import 'package:a1_kirim_mobile/src/domain/models/nakladnoy.dart';
import 'package:http/http.dart';

class NakladnoyHelper{

  static List<KirimToServer> converToKirimToServer(List<KirimModel> kirimlarlist) {
    List<KirimToServer> convertedList = [];
    kirimlarlist.forEach((kirim) {
      final newKirim = KirimToServer(
          goodsId: kirim.goodsId,
          name: kirim.name,
          articul: kirim.articul,
          orgName: kirim.orgName,
          unit: kirim.unit,
          rekvizitId: kirim.rekvizitId,
          kelganSana: kirim.kelganSana,
          yaroqlilikMuddati: kirim.yaroqlilikMuddati,
          seriyaRaqam: kirim.seriyaRaqam,
          soni: kirim.soni,
          status: kirim.status,
          summa: kirim.summa,
          waybillId: kirim.waybillId,
          waybillNumber: kirim.waybillNumber,
          unitId: kirim.unitId,
          sotuvSumma: kirim.sotuvSumma,
          ustamaFoiz: kirim.ustamaFoiz);
      convertedList.add(newKirim);
    });
    return convertedList;
  }

  static Future<bool> addWayBillIdAndNumberThenSendToServer({required Nakladnoy nak,required List<KirimModel> kirimlarList}) async {
    print("adding wayBill Id and Number ...");
    for (int i = 0; i < kirimlarList.length; i++) {
      final kirm = kirimlarList[i];
      final newKirim = KirimModel(
          kirimId: kirm.kirimId,
          goodsId: kirm.goodsId,
          name: kirm.name,
          articul: kirm.articul,
          orgName: kirm.orgName,
          unit: kirm.unit,
          rekvizitId: kirm.rekvizitId,
          kelganSana: kirm.kelganSana,
          yaroqlilikMuddati: kirm.kelganSana,
          seriyaRaqam: kirm.seriyaRaqam,
          soni: kirm.soni,
          status: kirm.status,
          summa: kirm.summa,
          waybillId: nak.waybillId,
          waybillNumber: nak.waybillNumber,
          unitId: kirm.unitId,
          sotuvSumma: kirm.sotuvSumma,
          ustamaFoiz: kirm.ustamaFoiz);
      kirimlarList[i] = newKirim;
      print(
          "${i + 1}) kirim with waybill Id and Number newKirim: ${newKirim.toJson()}");
      print(
          "${i + 1}) kirim with waybill Id and Number  In list: ${kirimlarList[i].toJson()}");
    }
    print("jsonEncode before send to api : ${jsonEncode(kirimlarList)}");
    // parse kirimModel to kirimToServer
    final converted = converToKirimToServer(kirimlarList);
    print('.........................');
    print(jsonEncode(converted));
    final result = await KirimRepository(ApiService(Client()))
        .sendKirimlarListToServer(kirimlar: converted);
    return result;
  }
}