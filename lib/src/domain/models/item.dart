class Item {
  final int? goodsId;
  final int? goodsGroupId;
  final String? articul;
  final String? name;
  final String? nameChek;
  final String? unitType;
  final int? unitTypeId;
  final int? status;
  final int? foiz;
  final int? checkByUser;
  final double? summa;
  final double? plastikSumma;
  final int? AptekaId;
  final double? pachkaSoni;
  final double? qoldiq;
  final double? temp;
  final double? shb;
  final int? countConvert;

  const Item({
    this.goodsId,
    this.goodsGroupId,
    this.articul,
    this.name,
    this.nameChek,
    this.unitType,
    this.unitTypeId,
    this.status,
    this.foiz,
    this.checkByUser,
    this.summa,
    this.plastikSumma,
    this.AptekaId,
    this.pachkaSoni,
    this.qoldiq,
    this.temp,
    this.shb,
    this.countConvert,
  });

  Map<String,dynamic> toMap(){
    return {
      'goodsId':this.goodsId,
      'goodsGroupId':this.goodsGroupId,
      'articul':this.articul,
      'name':this.name,
      'nameChek':this.nameChek,
      'unitType':this.unitType,
      'unitTypeId':this.unitTypeId,
      'status':this.status,
      'foiz':this.foiz,
      'checkByUser':this.checkByUser,
      'summa':this.summa,
      'plastikSumma':this.plastikSumma,
      'AptekaId':this.AptekaId,
      'pachkaSoni':this.pachkaSoni,
      'qoldiq':this.qoldiq,
      'temp':this.temp,
      'shb':this.shb,
      'countConvert':this.countConvert,

    };
  }

  factory Item.fromMap(Map<String, dynamic> json) {
    return Item(
      goodsId: json['goodsId'],
      goodsGroupId: json['goodsGroupId'],
      articul: json['articul'],
      name: json['name'],
      nameChek: json['nameChek'],
      unitType: json['unitType'],
      unitTypeId: json['unitTypeId'],
      status: json['status'],
      foiz: json['foiz'],
      checkByUser: json['checkByUser'],
      summa: json['summa'],
      plastikSumma: json['plastikSumma'],
      AptekaId: json['AptekaId'],
      pachkaSoni: json['pachkaSoni'],
      qoldiq: json['qoldiq'],
      temp: json['temp'],
      shb: json['shb'],
      countConvert: json['countConvert'],
    );
  }

  static List<Item> convertToItemList(
      Map<String, List<Item>> itemsGroup, String group) {
    List<Item> myItems = [];
    itemsGroup.forEach((key, value) {
      if (key == group) {
        for (var item in value) {
          myItems.add(item);
        }
      } else {
        // agar teng bolmasa davom etamiz
      }
    });
    return myItems;
  }
}
