import 'package:a1_kirim_mobile/main.dart';
import 'package:a1_kirim_mobile/src/data/data_sources/api_service.dart';
import 'package:a1_kirim_mobile/src/data/data_sources/nakladnoy_service.dart';
import 'package:a1_kirim_mobile/src/domain/models/nakladnoy.dart';
import 'package:a1_kirim_mobile/src/domain/models/test_model.dart';
import 'package:a1_kirim_mobile/src/utils/constants/sql_constants.dart';
import 'package:flutter/rendering.dart';
import 'package:sqflite/sqflite.dart';

class NakladnoyRepository {
  final ApiService apiService;
  NakladnoyRepository(this.apiService);
  Future<Nakladnoy?> createNakladnoy(Nakladnoy nakladnoy)async{
    print("siz NakladnoyRepository ichidasiz createNakladnoy...");
    try{
      print("before requesting to create nakladnoy in nakladnoy repository...");
      final Nakladnoy? nakladnoyResult =  await apiService.createNakladnoy(nakladnoy);
      print("request result in nakladnoy repository: ${nakladnoyResult?.toMap()}");
      return nakladnoyResult;
    }catch(e){
      print("failed in NakladnoyRepository createNakladnoy    failed to create nakladnoy ___ exception:${e.toString()}");
      return null;
    }
  }

  static addNakladnoyToSql(Nakladnoy nakladnoy) async{
    print("in NakladnoyRepository addNakladnoyToSql starting...");
    print("in addNakladnoyToSql nakladnoy: ${nakladnoy.toMap()}");
    int? id = await database?.insert(SqlContants.nakladnoylarTable, nakladnoy.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
    print("id: $id from sql");
  }
  static updateNakladnoyInSql() {}

  static deleteNakladnoyFromSql() {}
/*
  // static Future<Nakladnoy?> getSpecificNakladnoy({required int rekvizitId,required int sanaInt,required String sanaString}) async {
  //   print("in NakladnoyRepository get specific nakladnoy...");
  //   print('''
  //   rekvizitId:  $rekvizitId,
  //   sanaInt:  $sanaInt,
  //   sanaString: $sanaString
  //   ''');
  //   final db = await openDatabase(SqlContants.kirimDb);
  //   int rekvizitIdAndSana = createRekvizitIdAndSana(rekvizitId: rekvizitId, sanaInt: sanaInt);
  //   List<Map?>? nakladnoylar = [];
  //   nakladnoylar = await db.query(SqlContants.nakladnoylarTable,where: 'rekvizitIdAndSana = ?',whereArgs: [rekvizitIdAndSana]);
  //   print('................');
  //   print("nakladnoy[0]:");
  //   print(nakladnoylar);
  //
  //   return nakladnoylar.length != 0 ? Nakladnoy(
  //       rekvizitIdAndSana: rekvizitIdAndSana,
  //       rekvizitId: rekvizitId,
  //       userId: nakladnoylar[0]!['userId'],
  //       sana: sanaString,
  //       status: nakladnoylar[0]!['status'],
  //       waybillId: nakladnoylar[0]!['waybillId'],
  //       waybillNumber: nakladnoylar[0]!['waybillNumber'],
  //       summa: nakladnoylar[0]!['summa'],
  //   ): null;
  // }
*/
  Future<List<TestModel>?> getTodaysNakladnoysFromServer({required int rekvizitId})async{
    print("in nakladnoy repository getTodaysNakladnoysFromServer starting...");
    try{
      print("in nakladnoy repository getTodaysNakladnoysFromServer in try statement");
      final listOfNakladnoylar = await apiService.fetchTodaysNakladnoylar(rekvizitId: rekvizitId);
      return listOfNakladnoylar;
    }catch(e){
      print("in nakladnoy repository getTodaysNakladnoysFromServer failed to fetch nakladnoylar exception: ${e.toString()}");
      return null;
    }
  }

  // fetch all nakladnoylar
  Future<List<TestModel>?> getAllNakladnoysFromServer()async{
    print("in nakladnoy repository get All NakladnoysFromServer starting...");
    try{
      print("in nakladnoy repository get All NakladnoysFromServer in try statement");
      final listOfNakladnoylar = await apiService.fetchAllNakladnoylar();
      return listOfNakladnoylar;
    }catch(e){
      print("in nakladnoy repository get All NakladnoysFromServer failed to fetch nakladnoylar exception: ${e.toString()}");
      return null;
    }
  }

  // all markets with nak by date
  Future<List<MarketWithNakladnoy>?> getAllMarketsWithNakByDateFromServer({required String beginDate, required String endDate})async{
    print("in nakladnoy repository get All Markets With Nak ByDate FromServer starting...");
    try{
      print("in nakladnoy repository get All Markets With Nak ByDate FromServer in try statement");
      final listOfNakladnoylar = await apiService.fetchAllMarketsWithNakByDate(beginDate: beginDate, endDate: endDate);
      return listOfNakladnoylar;
    }catch(e){
      print("in nakladnoy repository get All Markets With Nak ByDate FromServer failed to fetch nakladnoylar exception: ${e.toString()}");
      return null;
    }
  }


  Future<bool> closeNakladnoyInServer({required int waybillId})async{
    print("in nakladnoy repository closing nakladnoy ...");
    try{
      final result = await NakladnoyService.closeNakladnoy(waybillId: waybillId);
      return result;
    }catch(e){
      print("in nakladnoy repository failed closing nakladnoy exception:${e.toString()}");
      return false;
    }
  }

  Future<List<TestModel>?> getNakladnoysByDateFromServer({required int rekvizitId,required String beginDate, required String endDate})async{
    print("in nakladnoy repository get Nakladnoys by date FromServer starting...");
    try{
      print("in nakladnoy repository  get Nakladnoys by date  in try statement");
      final listOfNakladnoylar = await NakladnoyService.fetchNakladnoylarByDate(rekvizitId: rekvizitId, beginDate: beginDate, endDate: endDate);
      return listOfNakladnoylar;
    }catch(e){
      print("in nakladnoy repository  get Nakladnoys by date  failed to fetch nakladnoylar exception: ${e.toString()}");
      return null;
    }
  }

  Future<List<TestNakItems>?> getNakladnoyItemsFromServer({required int waybillId})async{
    print("in nakladnoy repository getNakladnoyItemsFromServer starting...");
    try{
      print("in nakladnoy repository getNakladnoyItemsFromServer in try statement");
      final listOfNakladnoylar = await apiService.fetchTodaysNakladnoylarsItems(waybillId: waybillId);
      return listOfNakladnoylar;
    }catch(e){
      print("in nakladnoy repository getNakladnoyItemsFromServer failed to fetch nakladnoy items exception: ${e.toString()}");
      return null;
    }
  }
}

int createRekvizitIdAndSana({required int rekvizitId,required int sanaInt}){
  print('creating rekvizitIdAndSana id ...');
  String id = rekvizitId.toString() + sanaInt.toString();
  print("rekvizitIdAndSana: $id");
  return int.parse(id);
}
