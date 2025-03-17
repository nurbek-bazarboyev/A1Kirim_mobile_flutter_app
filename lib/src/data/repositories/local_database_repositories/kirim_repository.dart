import 'package:a1_kirim_mobile/main.dart';
import 'package:a1_kirim_mobile/src/data/data_sources/api_service.dart';
import 'package:a1_kirim_mobile/src/domain/models/kirim.dart';
import 'package:a1_kirim_mobile/src/utils/constants/sql_constants.dart';
import 'package:sqflite/sqflite.dart';

class KirimRepository {

  final ApiService apiService;
  KirimRepository(this.apiService);

  Future<bool> updateKirimInServer(KirimModel kirim)async{
    print("in KirimRepository updateKirimInServer ...");
    try{
      await apiService.updateKirim(kirim);
      print("in KirimRepository updateKirimInServer updated successfully");
      updateKirimInSql(kirim);
      return true;
    }catch(e){
      print("in KirimRepository updateKirimInServer failed to update kirim exception: ${e.toString()}");
      return false;
    }

  }

  Future<bool> sendKirimlarListToServer({required List<KirimToServer> kirimlar})async{
    print("in kirim repository updateKirimInServer ...");
    try{
      final isSent = await apiService.addKirimlar(kirimlar: kirimlar);
      return isSent;
    }catch(e){
      print("in kirim repository updateKirimInServer  failed to send kirimlarList exception: ${e.toString()}");
      return false;
    }
  }
  Future<bool> deleteKirimFromServer({required int kirimId})async{
    print("in deleteKirimFromServer deleteKirim ...");
    try{
      final result = await apiService.deleteKirim(kirimId: kirimId);
      print("in KirimRepository deleteKirimFromServer deleted successfully");
      deleteKirimFromSql(kirimId: kirimId);
      return result;
    }catch(e){
      print("in KirimRepository deleteKirimFromServer failed to delete kirim");
      return false;
    }
  }

  static addKirimToSql(KirimModel kirim) {
    print("adding kirim to sql...");
    database?.insert(SqlContants.kirimlarTable, kirim.toJson(),
        conflictAlgorithm: ConflictAlgorithm.replace);
    print("id = ${kirim.goodsId} added");
    print("status = ${kirim.status}");
  }

  static Future<bool> updateKirimInSql(KirimModel kirim) async{
    print("updatign kirim in sql...");
    await database?.update(SqlContants.kirimlarTable,kirim.toJson(),
        where: 'kirimId = ?', whereArgs: [kirim.kirimId]);
    print("id = ${kirim.goodsId} updated ");
    return true;
  }

  static deleteKirimFromSql({required int kirimId}) {
    print("deleting kirim from sql...");
    database?.delete(SqlContants.kirimlarTable, where: 'kirimId = ?',
        whereArgs: [kirimId]);
    print("kirimResponse id = ${kirimId}   deleted");
  }

  static deleteListOfKirimlar(List<KirimModel> myKirimlarList) {
    print("deleting kirimlar in kirim of today in market view...  ${myKirimlarList[0].toJson()}");
    for (int i = 0; i < myKirimlarList.length; i++) {
      KirimRepository.deleteKirimFromSql(kirimId: myKirimlarList[i].kirimId);
    }
    print('deleted all kirimlar');
  }

  static Future<List<KirimModel>>getKirimsFromSql({required int rekvizitId, required String kelganSana}) async{
    print("getting kirimlar from sql...");
    final db = await openDatabase('kirim.db');
    List<Map<String, dynamic>> kirimMaps = await db.query(
      SqlContants.kirimlarTable,
      where: "rekvizitId = ? and kelganSana = ?",
      whereArgs: [rekvizitId, kelganSana]
    );
    List<KirimModel> kirimlar = [];
    for(var kirim in kirimMaps){
      print(".............");
      print(kirim);
      kirimlar.add(KirimModel.fromSqlMap(kirim));
    }
    print("kirimlar final result after for loop: ${kirimlar}");
    return kirimlar;
  }
// quyidagi fun kerak emas
  static Future<List<KirimModel>>getStatus_0_FromSql() async{
    print("getting status=0 kirimlar from sql...");
    final db = await openDatabase('kirim.db');
    List<Map<String, dynamic>> kirimMaps = await db.query(
      SqlContants.kirimlarTable,
      where: 'status = ?',
      whereArgs: [0]

    );
    List<KirimModel> kirimlar = [];
    for(var kirim in kirimMaps){
      print("status.............");
      print(kirim);
      kirimlar.add(KirimModel.fromSqlMap(kirim));
    }
    print("kirimlar status = 0 final result after for loop: ${kirimlar}");
    return kirimlar;
  }
}
