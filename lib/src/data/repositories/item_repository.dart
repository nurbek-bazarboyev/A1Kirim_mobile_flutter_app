import 'package:a1_kirim_mobile/main.dart';
import 'package:a1_kirim_mobile/src/data/data_sources/api_service.dart';
import 'package:a1_kirim_mobile/src/data/repositories/local_database_repositories/kirim_repository.dart';
import 'package:a1_kirim_mobile/src/domain/models/item.dart';
import 'package:a1_kirim_mobile/src/domain/models/kirim.dart'
    show Kirim, KirimModel, KirimResponse;
import 'package:a1_kirim_mobile/src/utils/constants/sql_constants.dart';
import 'package:sqflite/sqflite.dart';

class ItemRepository {
  final ApiService apiService;

  ItemRepository(this.apiService);

  Future<List<Item>> getItems() async {
    try {
      print("in ItemRepository we are getting items list... ");
      var myItems = await apiService.fetchItems();
      print("in ItemRepository myItems: ${myItems}");
      return myItems;
    } catch (e) {
      print("in ItemRepository failed to load items   exception: ${e
          .toString()}");
      return [];
    }
  }

  Future<Item> addNewItem(Item item) async {
    print("in ItemRepository  ___   starting addNewItem...");
    try {
      print('in ItemRepository ___  trying  to addNewItem...');
      var addedNewItem = await apiService.addNewItem(item);
      print('in ItemRepository ___  addNewItem: ${addedNewItem}');
      addNewItemToSql(addedNewItem);
      return addedNewItem;

    } catch (e) {
      print("in ItemRepository ___  failed to add new item   exception: ${e
          .toString()}");
      throw "${e.toString()}";
    }
  }

  Future<void> addNewItemToSql(Item item) async{
    print("in ItemRepository  ___   starting addNewItem to sql...");
    try {
      print('in ItemRepository ___  trying  to addNewItem to sql...');
      await database?.insert(SqlContants.itemsTable,  item.toMap(),
          conflictAlgorithm: ConflictAlgorithm.replace);
    } catch (e) {
      print("in ItemRepository ___  failed to add new item to sql  exception: ${e
          .toString()}");
      throw "${e.toString()}";
    }
  }
  Future<KirimModel?> KirimQilish(KirimModel kirim) async {

    print("in ItemRepository  ___   starting KirimQilish...");
    try {
      print('in ItemRepository ___  trying  to KirimQilish...');
     // /* var addedKirim = await apiService.KirimQilish(kirim);*/
      //print('in ItemRepository ___  Kirim natijasi: ${addedKirim}');
      print("kirim telefonga saqlanmoqda...");
      KirimRepository.addKirimToSql(kirim);

      return kirim;
    } catch (e) {
      print("in ItemRepository ___  failed to KirimQilish  ___  exception: ${e
          .toString()}");
      return null;
    }
  }
}