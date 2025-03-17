import 'dart:convert';
import 'dart:io';

import 'package:a1_kirim_mobile/main.dart';
import 'package:a1_kirim_mobile/src/data/data_sources/group_service.dart';
import 'package:a1_kirim_mobile/src/data/data_sources/kirim_service.dart';
import 'package:a1_kirim_mobile/src/data/data_sources/market_service.dart';
import 'package:a1_kirim_mobile/src/data/data_sources/nakladnoy_service.dart';
import 'package:a1_kirim_mobile/src/domain/models/item.dart';
import 'package:a1_kirim_mobile/src/domain/models/kirim.dart';
import 'package:a1_kirim_mobile/src/domain/models/market.dart';
import 'package:a1_kirim_mobile/src/domain/models/nakladnoy.dart';
import 'package:a1_kirim_mobile/src/domain/models/test_model.dart';
import 'package:a1_kirim_mobile/src/domain/models/unit_type.dart';
import 'package:a1_kirim_mobile/src/domain/models/user.dart';
import 'package:a1_kirim_mobile/src/presentation/views/home_views/markets_view.dart';
import 'package:a1_kirim_mobile/src/utils/constants/server_data.dart';
import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;
import 'package:sqflite/sqflite.dart';

import '../../domain/models/group.dart';

class ApiService {
  final http.Client client;
  final dio = Dio();

  ApiService(this.client);

  Future<User> login(String parol) async {
    final String url = ServerData.baseUrl;
    print("tyring to login...");
    print("in api service parol: ${parol}");
    var respose = await http.post(Uri.parse(url),
        body: ({"mode": "m_user_by_code", "code": parol}));
    print("respose.statusCode: ${respose.statusCode}");
    print("respose.body: ${respose.body}");
    if (respose.statusCode == 200) {
      print("successful");
      print(respose.body);
      return User.fromJson(jsonDecode(respose.body));
    } else {
      print("failed! result: ${respose.statusCode}");
      throw Exception(respose.statusCode);
    }
  }

  // get users get http request
  Future<List<Market>> fetchMarkets() async {
    try {
      final result = await MarketService.fetchMarkets();
      return result;
    } catch (e) {
      throw Exception(e);
    }
  }

  // add kirim lar to server
  Future<bool> addKirimlar({required List<KirimToServer> kirimlar}) async {
    try {
      final result = await KirimService.addKirimlar(kirimlar: kirimlar);
      return result;
    } catch (e) {
      throw Exception(e);
    }
  }

  // fetch nakladnoylar
  Future<List<TestModel>?> fetchTodaysNakladnoylar(
      {required int rekvizitId}) async {
    try {
      final result = await NakladnoyService.fetchTodaysNakladnoylar(
          rekvizitId: rekvizitId);
      return result;
    } catch (e) {
      throw Exception(e);
    }
  }

  // fetch all nakladnoylar
  Future<List<TestModel>?> fetchAllNakladnoylar() async {
    try {
      final result = await NakladnoyService.fetchAllNakladnoylar();
      return result;
    } catch (e) {
      throw Exception(e);
    }
  }

  // fetch all nakladnoylar
  Future<List<MarketWithNakladnoy>?> fetchAllMarketsWithNakByDate({ required String beginDate, required String endDate}) async {
    try {
      final result = await NakladnoyService.fetchAllMarketsWithNakByDate( beginDate: beginDate, endDate: endDate);
      return result;
    } catch (e) {
      throw Exception(e);
    }
  }

  // fetch nakladnoylar
  Future<List<TestNakItems>?> fetchTodaysNakladnoylarsItems(
      {required int waybillId})
  async {
    try {
      final result = await NakladnoyService.fetchTodaysNakladnoylarsItems(waybillId: waybillId);
      return result;
    } catch (e) {
      throw Exception(e);
    }
  }

  // fetch groups list
  Future<List<Group>> fetchGroups() async {
    try {
      final result = await GroupService.fetchGroups();
      return result;
    } catch (e) {
      throw Exception(e);
    }
  }

  // fetch items list
  Future<List<Item>> fetchItems() async {
    print("fetching items...");
    final String url = ServerData.baseUrl +
        "?mode=m_goods_group_list_json&rekvizitId=0&userId=${sharedPreferences
            ?.getInt("userId")}";
    final response = await client.get(Uri.parse(url));
    print("in api service fetchItems response.body: ${response.statusCode}");

    if (response.statusCode == 200) {
      print("in api service fetchItems  status: successfully");
      return parseItems(response.body);
    } else {
      print(
          "failed to load items    respose.statusCode: ${response.statusCode}");
      throw Exception(response.statusCode);
    }
  }

  // update and add picture
  Future<bool> uploadPicture({required File image,
    required int goodsGroupId,
    required int goodsId}) async {
    print("in api service upload picture...");
    final String url = ServerData.baseUrl +
        "?mode=image_add&goodsId=$goodsId&goodsGroupId=$goodsGroupId";
    // &goodsGroupId=?&goodsId&attachment
    final request = await http.MultipartRequest('POST', Uri.parse(url));
    // request.fields.addAll({
    //   "goodsId":goodsId.toString(),
    //   "goodsGroupId":goodsGroupId.toString()
    // });
    // request.headers.addAll({
    // "Accept": "application/json",
    //   "Content-Type": "multipart/form-data"
    // });

    // request.files.add(http.MultipartFile(
    //     'attachment',
    //     image.readAsBytes().asStream(),
    //     image.lengthSync(),
    //   filename: image.path.split('/').last
    // ));

    // request.files.add(await http.MultipartFile.fromPath(
    //   "attachment", // Ensure this matches the backend field name
    //   image.path,
    // ));
    //
    //
    // print("in api service upload image request: ${request.toString()}");
    //
    // var response = await request.send();
    // print(response.statusCode);
    // // print("all request: ${response.request.toString()}");
    // // response.stream.transform(utf8.decoder).listen((value) {
    // //   print(value);
    // // });
    // // http.Response result = await http.Response.fromStream(response);
    //
    // if(response.statusCode == 200){
    //   print("in api service uploadImage request status : successfully${response.request}");
    //   return true;
    // }
    // else{
    //   return false;
    // }
// Prepare the multipart data
    FormData formData = FormData.fromMap({
      // 'mode': 'image_add',  // The mode parameter as per your API
      // 'goodsGroupId': goodsGroupId,
      // 'goodsId': goodsId,
      'attachment': await MultipartFile.fromFile(image.path)
    });

    // Initialize Dio instance
    Dio dio = Dio();

    try {
      // Send the request
      Response response = await dio.post(url, data: formData);
      print('Response: ${response.data}');
      return true;
    } catch (e) {
      print('Error: $e');
      return false;
      print('Error: $e');
    }
  }

  // fetch image
  Future<bool> fetchImage(String imageUrl) async {
    print("in api service fetch picture...");
    final String url = ServerData.baseUrl + "mode=get_image";
    final response =
    await client.post(Uri.parse(url), body: {"imageName": imageUrl});
    print("in api service fetch image response.body: ${response.statusCode}");
    if (response.statusCode == 200) {
      print("in api service fetch image status: successfully");
      return true;
    } else {
      print(
          "failed to fetch image   respose.statusCode: ${response
              .statusCode} result: ${response.body}");
      return false;
    }
  }

  // edit group
  // xatolik bolsa shu yerni va group repository ni  tekshirish kerak
  Future<Group> editGroup(Group group) async {
    print("in apiService edit group fun...");
    final String url = ServerData.baseUrl + "?mode=update_goods_group_Json";
    final response = await client.put(Uri.parse(url), body: {
      "name": group.groupName,
      "code": group.code,
      "goodsGroupId": group.goodsGroupId
    });

    print("in api service edit group respose.body: ${response.body}");
    if (response.statusCode == 200) {
      print("in api service edit group  status: successfully");
      return parseEditedGroup(response.body);
    } else {
      print("in api service edit group  status: ${response.statusCode}");
      throw Exception(response.statusCode);
    }
  }

  // fetch unit types
  // agar xatolik bolsa shu joyni va unittypes repositoryni tekshirish kerak va server bilan ham tekshirish kerak
  Future<List<UnitType>> fetchUnitTypes() async {
    print("in api service___  fetch unit types...");
    final String url = ServerData.baseUrl + "?mode=m_units_json";
    final response = await client.get(
      Uri.parse(url),
    );
    print(
        "in api service fetchUnitTypes response.body: ${response.statusCode}");
    if (response.statusCode == 200) {
      print("in api service unit types status: successfully");
      return parseUnitTypes(response.body);
    } else {
      print(
          "failed to load unitTypes    respose.statusCode: ${response
              .statusCode}");
      throw Exception(response.statusCode);
    }
  }

  // create nakladnoy
  Future<Nakladnoy?> createNakladnoy(Nakladnoy nakladnoy) async {

    String pay1 = '';
    String pay2 = '';
    String payMain = '';
    if(nakladnoy.paymentType == "naqt"){
      payMain = "naqt";
      pay2 = 'per';
      pay1 = 'plastik';
    }else if(nakladnoy.paymentType == "plastik"){
      pay1 = "naqt";
      pay2 = 'per';
      payMain = 'plastik';
    }else if(nakladnoy.paymentType == "per"){
      pay2 = "naqt";
      payMain = 'per';
      pay1 = 'plastik';
    }
    else{
      // just skip here
    }
    print("in api service create nakladnoy...");
    final url = "http://90.156.199.148:8082/magazinTest/main.api" + "?mode=m_create_waybill";
    final response = await client.post(Uri.parse(url), body: {
      "rekvizitId": nakladnoy.rekvizitId.toString(),
      "userId": sharedPreferences!.getInt('userId').toString(),
      "waybill_number": nakladnoy.waybillNumber,
      "summa": nakladnoy.summa.toString(),
      "naqt":'0.0',
      "plastik":'0.0',
      "per":'0.0',
      // "${payMain}": nakladnoy.chegirmaBilan.toString(),
      // "${pay1}": "0.0",
      // "${pay2}": "0.0",
      "chegirmasumma":nakladnoy.chegirmaSumma.toString()
    });
    print("body:${{
      "rekvizitId": nakladnoy.rekvizitId.toString(),
      "userId": sharedPreferences!.getInt('userId').toString(),
      "waybill_number": nakladnoy.waybillNumber,
      "summa": nakladnoy.summa.toString(),
      "naqt":'0.0',
      "plastik":'0.0',
      "per":'0.0',
      // "${payMain}": nakladnoy.chegirmaBilan.toString(),
      // "${pay1}": "0.0",
      // "${pay2}": "0.0",
      "chegirmaSumma":nakladnoy.chegirmaSumma.toString()
    }}");
    print("in api service body: ${response.request?.url.toString()}");
    print("in api service body: ${response.request?.headers.toString()}");
    print("in api service body: ${response.request?.method.toString()}");
    print("in api service body: ${response.request.toString()}");
    if (response.statusCode == 200) {
      print("in api service nakladnoy created successfully");
      return Nakladnoy.fromJson(response.body);
    } else {
      print("in api service failed to create nakladnoy!!!");
      return null;
    }
  }

  // add new item
  // bu api new item yaratish uchun item qaytaramiz

  Future<Item> addNewItem(Item item) async {
    print("in api service to addNewItem...");
    final url = ServerData.baseUrl + "?mode=add_goods_product";
    final response = await client.post(Uri.parse(url), body: {
      'name': item.name,
      'goodGroupId': item.goodsGroupId.toString(),
      'unitTypeId': item.unitTypeId.toString(),
      'articul': item.articul
    });
    print(
        "in ApiService add add new item    status code: ${response
            .statusCode}");
    print("in ApiService add add new item    respose body: ${response.body}");
    if (response.statusCode == 200) {
      print("in ApiService add add new item   added successfully");
      return parseAddedItem(response.body);
    } else {
      print(
          "in ApiService add add new item  failed to add new item exception: ${response
              .statusCode}");
      throw Exception(response.statusCode);
    }
  }

  // add item bu kirim qilish uchun bu yerda ham item qaytarib oshani saqlab qoyamiz
  // oldingi item orniga yangidan fetch qilmaymiz
  Future<KirimResponse> KirimQilish(Kirim kirim) async {
    print("in api service to addItem...");
    print(
        ">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> item <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<");
    print("you are adding this item: ${kirim.toMap()}");

    // final url = ServerData.baseUrl + "?mode=add_goods";
    final url = "http://90.156.199.148:8082/magazinTest/main.do" +
        "?mode=m_addWarehouse";
    final response = await client.post(Uri.parse(url),
        body: kirim
            .toMap() // mobodo xato bolsa shu yerni birinchi qolganlarini keyin tekshirish kerak
    );
    print("in ApiService add add item    status code: ${response.statusCode}");
    print("in ApiService add add item    respose body: ${response.body}");
    if (response.statusCode == 200) {
      print("in ApiService add add item   added successfully ");
      return parseKirimResponse(response.body);
    } else {
      print(
          "in ApiService add add item  failed to add item exception: ${response
              .statusCode}");
      throw Exception(response.statusCode);
    }
  }

  // update kirim
  Future<bool> updateKirim(KirimModel kirim) async {
    print("in api service update kirim ...");
    final String url = ServerData.baseUrl + "?mode=prixod_excel_file_update";
    // =?&=?&=?&foiz=?&=?&=?&=?
    final respose = await client.post(Uri.parse(url), body: {
      "warehouseGoodsId": kirim.kirimId.toString(),
      "waybillId": kirim.waybillId.toString(),
      "goodId": kirim.goodsId.toString(),
      "kelganSumma": kirim.summa.toString(),
      "foiz": kirim.ustamaFoiz.toString(),
      "sotuvSumma": kirim.sotuvSumma.toString(),
      "soni": kirim.soni.toString(),
      "unitTypeId": kirim.unitId.toString()
    });
    print("update respose body : ${respose.body}");
    print("update status code: ${respose.statusCode}");
    if (respose.statusCode == 200) {
      //final updatedKirim =  parseKirimResponse(respose.body);
      print('update kirim parsed...');
      return true;
    } else {
      print("failed to update kirim...");
      throw Exception(respose.statusCode);
    }
  }

  // delete kirim
  Future<bool> deleteKirim({required int kirimId}) async {
    print("in api service delete kirim ...");
    final String url = ServerData.baseUrl +
        "?mode=delete_warehouse_goods"; // delete_warehouse_goods&warehouseGoodsId=?
    final respose = await client
        .post(Uri.parse(url), body: {"warehouseGoodsId": kirimId.toString()});

    print("in api service delete kirim response body : ${respose.body}");
    print(
        "in api service delete kirim response status code : ${respose
            .statusCode}");

    if (respose.statusCode == 200) {
      print("siz delete datani parse qilishingiz kerak");
      return true;
    } else {
      print('failed to delete kirim');
      throw Exception(respose.statusCode);
    }
  }

  // add market
  // agar xato bolsa shu yerni va repositoryni tekshirish kerak bular hali test qilinmadi
  // serverga yuklanmagan
  Future<Market> addMarket(Market market) async {
    print("in ApiService addMarket ___ we are trying to add new market");
    final String url = ServerData.baseUrl + "?mode=m_rekvizit_add_Json";
    final response = await client.post(Uri.parse(url),
        body: ({
          'org_name': market.orgName ?? '',
          'address': market.address ?? '',
          'telefon_main': market.telefonMain ?? '',
          'direktor': market.direktor ?? ''
        }));
    print(response.request.toString());
    if (response.statusCode == 200) {
      print("in apiService addmarket status: successful");
      return parseAddedMarket(response.body);
    } else {
      print("in apiService addmarket respose.status: ${response.statusCode}");
      throw Exception(response.statusCode);
    }
  }

  // add new group
  Future<Group> addGroup(Group group) async {
    print("in ApiService addGroup ___ we are trying to add new group");
    final String url = ServerData.baseUrl + "?mode=add_goods_group_Json";
    final response = await client.post(Uri.parse(url),
        body: ({
          'name': group.groupName ?? '-',
          'code': group.code.toString() ?? '0'
        }));
    print(response.request.toString());
    if (response.statusCode == 200) {
      print("in apiService add group status: successful ${response.body}");
      final addedGroup = parseAddedGroup(response.body);
      print("in apiService add group addedGroup: ${addedGroup}");
      return addedGroup;
    } else {
      print("in apiService add group respose.status: ${response.statusCode}");
      throw Exception(response.statusCode);
    }
  }
}

// todo functions
List<TestModel> parseNakladnoylar(String source) {
  if (jsonDecode(source)['map']['status'] == 200) {
    final json = jsonDecode(source)['map']['waybill']['myArrayList'];
    print("in api service todo fun   parseNakladnoylar json: ${json}");
    List<dynamic> nakladnoylarMap = json;
    List<TestModel> nakladnoylar = [];
    nakladnoylarMap.forEach((nakladnoy) {
      nakladnoylar.add(TestModel.fromJson(nakladnoy));
    });
    print(
        "in api service todo fun   parseNakladnoylar nakladnoylar: ${nakladnoylar}");
    return nakladnoylar;
  } else {
    return [];
  }
}

List<MarketWithNakladnoy> parseMarketWithNak(String source) {
  if (jsonDecode(source)['map']['status'] == 200) {
    final json = jsonDecode(source)['map']['waybill']['myArrayList'];
    print("in api service todo fun   parseMarket WithNak json: ${json}");
    List<dynamic> nakladnoylarMap = json;
    List<MarketWithNakladnoy> nakladnoylar = [];
    nakladnoylarMap.forEach((nakladnoy) {
      nakladnoylar.add(MarketWithNakladnoy.fromJson(nakladnoy));
    });
    print(
        "in api service todo fun   parseMarket WithNak: ${nakladnoylar}");
    return nakladnoylar;
  } else {
    return [];
  }
}

List<TestNakItems> parseNakItems(String source) {
  final json = jsonDecode(source);
  print("in api service todo fun parseNakItems json: ${json}");

  List<TestNakItems> nakItems = [];
  List<dynamic> nakItemsmap = json;
  nakItemsmap.forEach((nakItemMap) {
    print("in api service todo fun parseNakItems nakItemMap: ${nakItemMap}");
    nakItems.add(TestNakItems.fromJson(nakItemMap));
  });
  return nakItems;
}

List<Market> parseMarkets(String source) {
  print("we are in parseMarkets fun in api_service.dart file");
  final jsonData = jsonDecode(source);
  List<Market> list = [];
  print("in parseMarkets market json:");
  print(jsonData);
  var json = jsonData['map']['rekvizitList']['myArrayList'];
  print("in parseMarkets market json: ${json}");
  for (var market in json) {
    Market myMarket = Market(
        rekvizitId: market['rekvizitId'],
        klientAndPostavchikId: market['klientAndPostavchikId'],
        orgName: market['orgName'],
        address: market['address'],
        telefonMain: market['telefonMain'],
        bankId: market['bankId'],
        inn: market['inn'],
        isGazna: market['isGazna'],
        direktor: market['direktor'],
        jamiSumma: market['jamiSumma'],
        olganSumma: market['olganSumma'],
        berganSumma: market['berganSumma'],
        olishimKerakBulganSumma: market['olishimKerakBulganSumma'],
        barishimKerakBulganSumma: market['barishimKerakBulganSumma'],
        mfo: market['mfo'],
        hisobRaqamId: market['hisobRaqamId'],
        qarzdorId: market['qarzdorId'],
        tumanId: market['tumanId'],
        aptekaId: market['aptekaId'],
        qarzdorningQarzQiymati: market['qarzdorningQarzQiymati'],
        qarzdorningQanchaBergani: market['qarzdorningQanchaBergani'],
        totalBalance: market['totalBalance']);
    print("in parseMarkets market: ${market}");
    list.add(myMarket);
  }
  return list;
}

Market parseAddedMarket(String source) {
  final json = jsonDecode(source);
  print("json:");
  print(json);
  final jsonData = json['map']['rekvizit'];
  Market addedMarket = Market(
      rekvizitId: jsonData['rekvizitId'],
      klientAndPostavchikId: jsonData['klientAndPostavchikId'],
      orgName: jsonData['orgName'],
      address: jsonData['address'],
      telefonMain: jsonData['telefonMain'],
      bankId: jsonData['bankId'],
      inn: jsonData['inn'],
      isGazna: jsonData['isGazna'],
      direktor: jsonData['direktor'],
      jamiSumma: jsonData['jamiSumma'],
      olganSumma: jsonData['olganSumma'],
      berganSumma: jsonData['berganSumma'],
      olishimKerakBulganSumma: jsonData['olishimKerakBulganSumma'],
      barishimKerakBulganSumma: jsonData['barishimKerakBulganSumma'],
      mfo: jsonData['mfo'],
      hisobRaqamId: jsonData['HisobRaqamId'],
      qarzdorId: jsonData['QarzdorId'],
      tumanId: jsonData['tumanId'],
      aptekaId: jsonData['aptekaId'],
      qarzdorningQarzQiymati: jsonData['qarzdorningQarzQiymati'],
      qarzdorningQanchaBergani: jsonData['qarzdorningQanchaBergani'],
      totalBalance: jsonData['totalBalance']);
  print("marker: ${jsonData}");

  return addedMarket;
}

List<Group> parseGroups(String source) {
  final jsonData = jsonDecode(source);
  List<Group> list = [];
  print("json groups:");
  print(jsonData);
  for (var group in jsonData) {
    Group myGroup = Group(
        goodsGroupId: group['goodsGroupId'],
        groupName: group['groupName'],
        code: group['code'],
        id: group['id'],
        goodsList: []);
    print("group: ${group}");
    list.add(myGroup);
  }
  return list;
}

Group parseEditedGroup(String source) {
  final jsonData = jsonDecode(source);
  print("edited group:");
  print(jsonData);
  Group editedGroup = Group(
      goodsGroupId: jsonData['goodsGroupId'],
      groupName: jsonData['groupName'],
      code: jsonData['code'],
      id: jsonData['id'],
      goodsList: []);
  print("edited group: ${editedGroup}");

  return editedGroup;
}

Group parseAddedGroup(String source) {
  final json = jsonDecode(source);
  print("in parseAddedGroup added group:");
  print(json);
  final jsonData = json['map']['goodGroup'];
  Group addedGroup = Group(
      goodsGroupId: jsonData['goodsGroupId'],
      groupName: jsonData['groupName'],
      code: jsonData['code'],
      id: jsonData['id'],
      goodsList: []);
  print("added group: ${addedGroup.toJson()}");

  return addedGroup;
}

List<Item> parseItems(String source) {
  final jsonData = jsonDecode(source);
  List<Item> list = [];
  print("json items:");
  print(jsonData);
  for (var itemGroup in jsonData) {
    final goodsList = itemGroup['goodsList'];
    print("goodsList: ${goodsList}");
    for (var item in goodsList) {
      print("parse Items fun    item: ${item}");
      Item myItem = Item.fromMap(item);
      print("item: ${myItem}");
      list.add(myItem);
    }
  }
  return list;
}

Item parseAddedItem(String source) {
  final jsonData = jsonDecode(source); // json parse atildi
  final json = jsonData['map']['goods'];
  print("json item:");
  print(json);
  Item AddedItem = Item.fromMap(json); // json Item ga o'tirildi
  print("item: ${AddedItem}");

  return AddedItem; // Item qaytarildi
}

Item parseItem(String source) {
  final jsonData = jsonDecode(source); // json parse atildi
  print("json item:");
  print(jsonData);
  Item AddedItem = Item.fromMap(jsonData); // json Item ga o'tirildi
  print("item: ${AddedItem}");

  return AddedItem; // Item qaytarildi
}

KirimResponse parseKirimResponse(String source) {
  final jsonData = jsonDecode(source); // json parse atildi
  print("json kirimResponse:");
  print(jsonData);
  KirimResponse kirimResponse =
  KirimResponse.fromJson(jsonData); // json Item ga o'tirildi
  print("kirimResponse: ${kirimResponse}");

  return kirimResponse; // Item qaytarildi
}

List<UnitType> parseUnitTypes(String source) {
  final jsonData = jsonDecode(source);
  List<UnitType> typesList = [];
  print("json unit types: ${jsonData}");
  for (var unit in jsonData) {
    print("parse unit type fun    item: ${unit}");
    UnitType unitType = UnitType.fromJson(unit);
    print("unit type: ${unitType}");
    typesList.add(unitType);
  }
  return typesList;
}

void saveItemsToDb() async {
  print("in saveItemsToDb which is in api service items: ${items}");
  var batch = database?.batch();
  int count = 0;
  for (var item in items) {
    count++;
    print("inserting data ${count}...");
    batch?.insert('items', item.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }
  await batch?.commit();
}

List<dynamic> ls = [
  {
    "goodsId": 2264,
    "name": "yosh qizlar uchun ayiqchalik zakolka",
    "articul": "1",
    "orgName": "Turk bozori",
    "unit": "Dona",
    "rekvizitId": 10,
    "kelganSana": "2025-03-05",
    "yaroqlilikMuddati": "2025-03-05",
    "seriyaRaqam": "0",
    "soni": 4.0,
    "status": 1,
    "summa": 1000.0,
    "waybillId": 105,
    "waybillNumber": "2025-03-05 12:49",
    "unitId": 6,
    "sotuvSumma": 1000.0,
    "ustamaFoiz": 0.0
  },
  {
    "goodsId": 2265,
    "name": "qizil zakolka",
    "articul": "12",
    "orgName": "Turk bozori",
    "unit": "Pachka",
    "rekvizitId": 10,
    "kelganSana": "2025-03-05",
    "yaroqlilikMuddati": "2025-03-05",
    "seriyaRaqam": "0",
    "soni": 2.0,
    "status": 1,
    "summa": 25000.0,
    "waybillId": 105,
    "waybillNumber": "2025-03-05 12:49",
    "unitId": 7,
    "sotuvSumma": 25000.0,
    "ustamaFoiz": 0.0
  },
  {
    "goodsId": 2266,
    "name": "qishki jemfer",
    "articul": "12",
    "orgName": "Turk bozori",
    "unit": "Dona",
    "rekvizitId": 10,
    "kelganSana": "2025-03-05",
    "yaroqlilikMuddati": "2025-03-05",
    "seriyaRaqam": "0",
    "soni": 5.0,
    "status": 1,
    "summa": 180000.0,
    "waybillId": 105,
    "waybillNumber": "2025-03-05 12:49",
    "unitId": 6,
    "sotuvSumma": 180000.0,
    "ustamaFoiz": 0.0
  }
];
