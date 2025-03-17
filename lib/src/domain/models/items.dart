import 'dart:isolate';
import 'package:a1_kirim_mobile/src/domain/models/item.dart' show Item;

class Items{
  final List<Item> itemsList;
  final int goodsGroupId;
  Items({
    required this.itemsList,
    required this.goodsGroupId
});

  static Future<List<Item>> sortByGroupId(List<Item> allItems, int groupId)async{
    return await Isolate.run<List<Item>>((){
      List<Item> sortedItems = [];
      allItems.forEach((item){
        if(item.goodsGroupId == groupId){
          sortedItems.add(item);
        }else{
          // shunchaki tashlab ketish kerak
        }
      });
      return sortedItems;
    });
  }
}