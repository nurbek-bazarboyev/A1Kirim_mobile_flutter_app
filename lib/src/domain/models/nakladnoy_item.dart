class NakladnoyItem {
  final String itemName;
  final double soni;
  final double narxi;
  final String unitType;
  final double jamiSumma;

  NakladnoyItem({
    required this.itemName,
    required this.soni,
    required this.narxi,
    required this.unitType,
    required this.jamiSumma,
  });

  Map toMap() {
    return {
      "itemName": this.itemName,
      "soni": this.soni,
      "narxi": this.narxi,
      "unitType": this.unitType,
      "jamiSumma": this.jamiSumma,
    };
  }

  factory NakladnoyItem.fromJson(Map<String, dynamic> json) {
    //final json = json['map']['waybill']['myArrayList'][0]
    return NakladnoyItem(// todo bularni api togrilangandan keyin yozish kerak
        itemName: json['itemName'],
        soni: json['soni'],
        narxi: json['summa'],
        unitType: json['unitType'],
        jamiSumma: json['jamiSumma']
    );
  }
}
