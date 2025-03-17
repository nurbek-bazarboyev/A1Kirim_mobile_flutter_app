import 'dart:convert';

import 'package:a1_kirim_mobile/src/domain/models/item.dart' show Item;

class Group {
  final int goodsGroupId;
  final String groupName;
  final int code;
  final int id;
  List<Item>? goodsList;

  Group({
    required this.goodsGroupId,
    required this.groupName,
    required this.code,
    required this.id,
    required this.goodsList
  });

  factory Group.fromJson(String body){
    final data = jsonDecode(body);
    return Group(
        goodsGroupId: data['goodsGroupId'],
        groupName: data['groupName'],
        code: data['code'],
        id: data['id'],
        goodsList: data['goodsList']);
  }

  Map<String,dynamic> toJson(){
    return {
      "goodsGroupId": goodsGroupId,
      "groupName": groupName,
      "code": code,
      "id":id,
      "goodsList":goodsList
    };
  }

}