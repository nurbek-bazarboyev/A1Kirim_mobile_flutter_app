import 'dart:convert';

class UnitType{
  final String unitType;
  final int unitTypeId;
  UnitType({
    required this.unitType,
    required this.unitTypeId
});

  Map<String, dynamic>toJson(){
    return {
      "unitType": unitType,
      "unitTypeId":unitTypeId
    };
  }

  factory UnitType.fromJson(Map jsonData){
    return UnitType(
        unitType: jsonData['unitType'],
        unitTypeId: jsonData['unitTypeId']
    );
  }

}