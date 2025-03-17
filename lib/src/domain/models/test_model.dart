class TestModel {
  final String date;
  final int wayBillId;
  final String wayBillNumber;
  final double summa;

  // final double jamiSumma;
  final double kirimSumma;
  final double chegirmaBilan;
  final double chegirmaSumma;
  final int waybillStatus;
  final String paymentType;

  TestModel({
    required this.date,
    required this.wayBillId,
    required this.wayBillNumber,
    required this.summa,
    required this.kirimSumma,
    required this.paymentType,
    // required this.jamiSumma,
    required this.waybillStatus,
    required this.chegirmaBilan,
    required this.chegirmaSumma,
  });

  static String getPaymentType(dynamic json) {
    if (json['naqt'] != 0.0) {
      return "naqt";
    } else if (json['plastik'] != 0.0) {
      return 'plastik';
    } else if (json['per'] != 0.0) {
      return 'bank hisobi orqali';
    } else {
      return "nomalum xatolik";
    }
  }

  factory TestModel.fromJson(dynamic json){
    return TestModel(
        date: json['waybillDate'].toString().substring(0, 10),
        wayBillId: json['waybillId'],
        //waybillId
        wayBillNumber: json['waybillNumber'],
        summa: json['summa'],
        kirimSumma: json['kirimQilinganMahsulotSumma'],
        //json['kirimQilinganMahsulotSumma']
        waybillStatus: json['waybillStatus'],
        chegirmaBilan: json['kirimQilinganMahsulotSumma'] - json['chegirmaSumma'],
        chegirmaSumma: json['chegirmaSumma'],
        paymentType: getPaymentType(json)
    );
  }


  Map<String, dynamic> toMap() {
    return {
      "date": this.date,
      "wayBillId": this.wayBillId,
      "waybillNumber": this.wayBillNumber,
      "summa": this.summa,
      "kirimSumma": this.kirimSumma,
      "waybillStatus": this.waybillStatus,
      "chegirmaSumma": this.chegirmaSumma,
      "chegirmaBilan": this.chegirmaBilan,
      "paymentType": this.paymentType
    };
  }

}

class TestNakItems {
  final String name;
  final String unitType;
  final double soni;
  final double summa;
  final double jamiSumma;

  TestNakItems({
    required this.name,
    required this.unitType,
    required this.soni,
    required this.summa,
    required this.jamiSumma
  });

  factory TestNakItems.fromJson(dynamic json){
    return TestNakItems(
      name: json['goods']['name'],
      unitType: json['uniteType'],
      soni: json['soni'],
      summa: json['kelganNarxi'],
      jamiSumma: json['jamiSumma'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "name": this.name,
      "unitType": this.unitType,
      "soni": this.soni,
      "summa": this.summa,
      "jamiSumma": this.jamiSumma
    };
  }

}

class MarketWithNakladnoy {
  final String name;
  final double summa;
  final double kirimSumma;
  final double chegirmaSumma;
  final double chegirmaBilan;
  final String waybillNum;
  final String paymentType;
  final String sana;
  final int rekvisitId;
  final int waybillStatus;
  final int waybillId;

  MarketWithNakladnoy({
    required this.name,
    required this.rekvisitId,
    required this.summa,
    required this.waybillNum,
    required this.sana,
    required this.waybillId,
    required this.kirimSumma,
    required this.chegirmaSumma,
    required this.chegirmaBilan,
    required this.paymentType,
    required this.waybillStatus
  });

  factory MarketWithNakladnoy.fromJson(dynamic json){
    return MarketWithNakladnoy(
      rekvisitId: json['rekvizitId'],
      name: json['rekvizit']['orgName'],
      summa: json['summa'],
      waybillNum: json['waybillNumber'],
      sana: json['waybillDate'].toString().split(' ')[0],
      waybillId: json['waybillId'],
      kirimSumma: json['kirimQilinganMahsulotSumma'],
      chegirmaBilan: json['kirimQilinganMahsulotSumma'] - json['chegirmaSumma'],
      chegirmaSumma: json['chegirmaSumma'],
      paymentType: TestModel.getPaymentType(json),
      waybillStatus: json['waybillStatus'],


    );
  }

  TestModel covertToNakladnoy() {
    return TestModel(
        date: this.sana,
        wayBillId: this.waybillId,
        wayBillNumber: this.waybillNum,
        summa: this.summa,
        kirimSumma: this.kirimSumma,
        paymentType: this.paymentType,
        waybillStatus: this.waybillStatus,
        chegirmaBilan: this.chegirmaBilan,
        chegirmaSumma: this.chegirmaSumma
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "name": name,
      "summa": summa,
      "kirimSumma": kirimSumma,
      "chegirmaSumma": chegirmaSumma,
      "chegirmaBilan": chegirmaBilan,
      "waybillNum": waybillNum,
      "paymentType": paymentType,
      "sana": sana,
      "rekvisitId": rekvisitId,
      "waybillStatus": waybillStatus,
      "waybillId": waybillId,
    };
  }

}

List<dynamic> list = [
  {
    "wareHouseGoodsId": 224,
    "kelganSana": "2025-02-28",
    "waybillId": 58,
    "rekvizitId": 0,
    "rekvizit": {
      "rekvizitId": 10,
      "klientAndPostavchikId": 0,
      "orgName": "Turk bozori",
      "bankId": 0,
      "inn": 0,
      "isGazna": false,
      "jamiSumma": 0,
      "olganSumma": 0,
      "berganSumma": 0,
      "olishimKerakBulganSumma": 0,
      "barishimKerakBulganSumma": 0,
      "mfo": 0,
      "HisobRaqamId": 0,
      "QarzdorId": 0,
      "tumanId": 0,
      "aptekaId": 0,
      "qarzdorningQarzQiymati": 0,
      "qarzdorningQanchaBergani": 0,
      "totalBalance": 0
    },
    "goodsId": 2232,
    "goods": {
      "goodsId": 2232,
      "goodsGroupId": 0,
      "articul": "111111",
      "name": "ro'mol",
      "unitTypeId": 0,
      "status": 0,
      "foiz": 0,
      "checkByUser": 0,
      "summa": 100000,
      "plastikSumma": 0,
      "AptekaId": 0,
      "pachkaSoni": 0,
      "qoldiq": 0,
      "temp": 0,
      "shb": 0,
      "countConvert": 0,
      "goodsUnitTypeList": []
    },
    "uniteType": "Pachka",
    "soni": 100,
    "pachkaSoni": 0,
    "sotilganSoni": 0,
    "yaroqsizMaxsulotSoni": 0,
    "yaroqlilikMuddati": "2025-02-28",
    "seriyaRaqam": "0",
    "ustamaFoiz": 0,
    "sotuvSumma": 100000,
    "pachkaSumma": 0,
    "jamiSumma": 10000000,
    "aptekaId": 1,
    "qolganSoni": 0,
    "kuni": 0,
    "kelganNarxi": 100000,
    "shb": 0,
    "unitTypeId": 7
  }
];