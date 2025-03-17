import 'package:a1_kirim_mobile/main.dart';

class Kirim {
  final int goodsId;
  final String articul;
  final String unit;
  final int unitId;
  final double soni;
  final double summa;
  final String yaroqlilikMuddati; // date.toString()
  final int rekvizitId;
  final int waybillId;
  final String waybillNumber;
  final double ustamaFoiz;
  final String seriyaRaqam;
  final double sotuvSumma;

  Kirim({
    required this.goodsId,
    required this.articul,
    required this.unitId,
    required this.soni,
    required this.summa,
    required this.yaroqlilikMuddati,
    required this.rekvizitId,
    required this.waybillId,
    required this.ustamaFoiz,
    required this.seriyaRaqam,
    required this.sotuvSumma,
    required this.unit,
    required this.waybillNumber,
  });


  factory Kirim.fromJson(Map<String, dynamic> json){
    return Kirim(
        goodsId: json['goodsId'],
        articul: json['articul'],
        unitId: json['unitId'],
        soni: json['soni'],
        summa: json['summa'],
        yaroqlilikMuddati: json['yaroqlilikMuddati'],
        rekvizitId: json['rekvizitId'],
        waybillId: json['waybillId'],
        ustamaFoiz: json['ustamaFoiz'],
        seriyaRaqam: json['seriyaRaqam'],
        sotuvSumma: json['sotuvSumma'],
        unit: json['unit'],
        waybillNumber: json['waybillNumber']
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'goodsId': this.goodsId.toString(),
      'articul': this.articul,
      'unitId': this.unitId.toString(),
      'soni': this.soni.toString(),
      'summa': this.summa.toString(),
      'yaroqlilikMuddati': this.yaroqlilikMuddati,
      'rekvizitId': this.rekvizitId.toString(),
      'waybillId': this.waybillId.toString(),
      'ustamaFoiz': this.ustamaFoiz.toString(),
      'seriyaRaqam': this.seriyaRaqam.toString(),
      'sotuvSumma': this.sotuvSumma.toString(),
      'unit': this.unit.toString(),
      'waybillNumber': this.waybillNumber.toString()
    };
  }

}

class KirimResponse {
  final int kirimId;
  final int goodsId;
  final String name;
  final String orgName;
  final String unitType;
  final int rekvizitId;
  final String kelganSana;
  final double soni;
  final int status;
  final double summa;
  final int waybillId;
  final int unitTypeId;
  final double sotuvSumma;
  final double foiz;

  const KirimResponse({
    required this.kirimId,
    required this.goodsId,
    required this.name,
    required this.orgName,
    required this.unitType,
    required this.rekvizitId,
    required this.kelganSana,
    required this.soni,
    required this.status,
    required this.summa,
    required this.waybillId,
    required this.unitTypeId,
    required this.sotuvSumma,
    required this.foiz,
  });

  factory KirimResponse.fromSqlMap(Map<String, dynamic> json){
    return KirimResponse(
        kirimId: json['kirimId']??-1,
        goodsId: json['goodsId']??-1,
        name: json['name']??'name',
        orgName: json['orgName']??'orgname',
        unitType: json['unitType']??'unit type',
        rekvizitId: json['rekvizitId']??-1,
        kelganSana: json['kelganSana']??'kelganSana',
        soni: json['soni']??-1.0,
        status: json['status'],
        summa: json['summa']??-1.0,
        waybillId: json['waybillId']??'0',
        unitTypeId: json['unitTypeId'],
        sotuvSumma: json['sotuvSumma'],
        foiz: json['foiz']
    );
  }

  factory KirimResponse.fromJson(Map<String, dynamic> json){
    final warehousejson = json['map']['wareHouseGoods'];
    print(warehousejson);
    int? id = sharedPreferences!.getInt('kirimId')??0;
     final kirim  = KirimResponse(
        kirimId: warehousejson['wareHouseGoodsId'],
        goodsId: warehousejson['goodsId'],
        name: warehousejson['goods']['name'],
        orgName: warehousejson['rekvizit']['orgName'],
        unitType: warehousejson['uniteType'],
        rekvizitId: warehousejson['rekvizit']['rekvizitId'],
        kelganSana: warehousejson['kelganSana'],
        soni: warehousejson['soni'],
        status: 1,
        summa: warehousejson['kelganNarxi'],
        waybillId: warehousejson['waybillId'],
        unitTypeId: warehousejson['unitTypeId'],
        sotuvSumma: warehousejson['sotuvSumma'],
        foiz: warehousejson['ustamaFoiz']);

     print(kirim.toMap());
     sharedPreferences!.setInt('kirimId', id!+1);
     return kirim;
  }

  Map<String, dynamic> toMap(){
    return {
      'kirimId':this.kirimId,
      'goodsId': this.goodsId,
      'name': this.name,
      'orgName': this.orgName,
      'unitType': this.unitType,
      'rekvizitId': this.rekvizitId,
      'kelganSana': this.kelganSana,
      'soni': this.soni,
      'status': this.status,
      'summa': this.summa,
      'waybillId': this.waybillId,
      'unitTypeId': this.unitTypeId,
      'sotuvSumma': this.sotuvSumma,
      'foiz': this.foiz
    };
  }

}

class KirimModel {
  final int kirimId;
  final int goodsId;
  final String name;
  final String articul;
  final String orgName;
  final String unit;
  final int rekvizitId;
  final String kelganSana;
  final String yaroqlilikMuddati;
  final String seriyaRaqam;
  final double soni;
  final int status;
  final double summa;
  final int waybillId;
  final String waybillNumber;
  final int unitId;
  final double sotuvSumma;
  final double ustamaFoiz;

  const KirimModel({
    required this.kirimId,
    required this.goodsId,
    required this.name,
    required this.articul,
    required this.orgName,
    required this.unit,
    required this.rekvizitId,
    required this.kelganSana,
    required this.yaroqlilikMuddati,
    required this.seriyaRaqam,
    required this.soni,
    required this.status,
    required this.summa,
    required this.waybillId,
    required this.waybillNumber,
    required this.unitId,
    required this.sotuvSumma,
    required this.ustamaFoiz,
  });

  factory KirimModel.fromSqlMap(Map<String, dynamic> json) {
    return KirimModel(
      kirimId: json['kirimId'] ?? -1,
      goodsId: json['goodsId'] ?? -1,
      name: json['name'] ?? 'name',
      articul: json['articul'] ?? 'articul',
      orgName: json['orgName'] ?? 'orgName',
      unit: json['unit'] ?? 'unit',
      rekvizitId: json['rekvizitId'] ?? -1,
      kelganSana: json['kelganSana'] ?? 'kelganSana',
      yaroqlilikMuddati: json['yaroqlilikMuddati'] ?? 'yaroqlilikMuddati',
      seriyaRaqam: json['seriyaRaqam'] ?? 'seriyaRaqam',
      soni: (json['soni'] ?? -1.0).toDouble(),
      status: json['status'] ?? -1,
      summa: (json['summa'] ?? -1.0).toDouble(),
      waybillId: json['waybillId'] ?? -1,
      waybillNumber: json['waybillNumber'] ?? 'waybillNumber',
      unitId: json['unitId'] ?? -1,
      sotuvSumma: (json['sotuvSumma'] ?? -1.0).toDouble(),
      ustamaFoiz: (json['ustamaFoiz'] ?? -1.0).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'kirimId': kirimId,
      'goodsId': goodsId,
      'name': name,
      'articul': articul,
      'orgName': orgName,
      'unit': unit,
      'rekvizitId': rekvizitId,
      'kelganSana': kelganSana,
      'yaroqlilikMuddati': yaroqlilikMuddati,
      'seriyaRaqam': seriyaRaqam,
      'soni': soni,
      'status': status,
      'summa': summa,
      'waybillId': waybillId,
      'waybillNumber': waybillNumber,
      'unitId': unitId,
      'sotuvSumma': sotuvSumma,
      'ustamaFoiz': ustamaFoiz,
    };
  }
}

class KirimToServer {
  final int goodsId;
  final String name;
  final String articul;
  final String orgName;
  final String unit;
  final int rekvizitId;
  final String kelganSana;
  final String yaroqlilikMuddati;
  final String seriyaRaqam;
  final double soni;
  final int status;
  final double summa;
  final int waybillId;
  final String waybillNumber;
  final int unitId;
  final double sotuvSumma;
  final double ustamaFoiz;

  KirimToServer({
    required this.goodsId,
    required this.name,
    required this.articul,
    required this.orgName,
    required this.unit,
    required this.rekvizitId,
    required this.kelganSana,
    required this.yaroqlilikMuddati,
    required this.seriyaRaqam,
    required this.soni,
    required this.status,
    required this.summa,
    required this.waybillId,
    required this.waybillNumber,
    required this.unitId,
    required this.sotuvSumma,
    required this.ustamaFoiz,
  });

  factory KirimToServer.fromJson(Map<String, dynamic> json) {
    return KirimToServer(
      goodsId: json['goodsId'],
      name: json['name'],
      articul: json['articul'],
      orgName: json['orgName'],
      unit: json['unit'],
      rekvizitId: json['rekvizitId'],
      kelganSana: json['kelganSana'],
      yaroqlilikMuddati: json['yaroqlilikMuddati'],
      seriyaRaqam: json['seriyaRaqam'],
      soni: json['soni'].toDouble(),
      status: json['status'],
      summa: json['summa'].toDouble(),
      waybillId: json['waybillId'],
      waybillNumber: json['waybillNumber'],
      unitId: json['unitId'],
      sotuvSumma: json['sotuvSumma'].toDouble(),
      ustamaFoiz: json['ustamaFoiz'].toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'goodsId': goodsId,
      'name': name,
      'articul': articul,
      'orgName': orgName,
      'unit': unit,
      'rekvizitId': rekvizitId,
      'kelganSana': kelganSana,
      'yaroqlilikMuddati': yaroqlilikMuddati,
      'seriyaRaqam': seriyaRaqam,
      'soni': soni,
      'status': status,
      'summa': summa,
      'waybillId': waybillId,
      'waybillNumber': waybillNumber,
      'unitId': unitId,
      'sotuvSumma': sotuvSumma,
      'ustamaFoiz': ustamaFoiz,
    };
  }
}
