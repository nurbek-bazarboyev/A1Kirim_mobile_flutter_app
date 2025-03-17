import 'dart:convert';

import 'package:a1_kirim_mobile/src/data/data_sources/api_service.dart';
import 'package:a1_kirim_mobile/src/domain/models/test_model.dart';
import 'package:http/http.dart';

class NakladnoyService{

  static Future<List<TestModel>?> fetchTodaysNakladnoylar(
      {required int rekvizitId,})
  async {
    print("in api service fetchTodaysNakladnoylar ...");
    final url = "http://90.156.199.148:8082/magazinTest/main.api" +
        "?mode=nakladnoyByRekvizitList"; //  /main.api&=
    final response = await Client().post(Uri.parse(url), body: {"rekvizitId": rekvizitId.toString()});
    print("in apiservice fetchTodaysNakladnoylar     respose status: ${response.statusCode}");
    print("in apiservice fetchTodaysNakladnoylar     respose body: ${response.body}");

    if (response.statusCode == 200) {
      print("in apiservice fetchTodaysNakladnoylar start parsing respose...");
      final nakladnoylar = parseNakladnoylar(response.body);
      return nakladnoylar; //parese list of nakladnoy
    } else {
      print(
          "in apiservice fetchTodaysNakladnoylar failed to fetch nakladnoylar");
      throw Exception(response.statusCode);
    }
  }

  static Future<List<TestModel>?> fetchAllNakladnoylar()
  async {
    print("in api service fetch all Nakladnoylar ...");
    final url = "http://90.156.199.148:8082/magazinTest/main.api" +
        "?mode=nakladnoyByRekvizitList"; //  /main.api&=
    final response = await Client().post(Uri.parse(url));
    print("in apiservice fetch all Nakladnoylar     respose status: ${response.statusCode}");
    print("in apiservice fetch all Nakladnoylar     respose body: ${response.body}");

    if (response.statusCode == 200) {
      print("in apiservice fetchTodaysNakladnoylar start parsing respose...");
      final nakladnoylar = parseNakladnoylar(response.body);
      return nakladnoylar; //parese list of nakladnoy
    } else {
      print(
          "in apiservice fetch all Nakladnoylar failed to fetch nakladnoylar");
      throw Exception(response.statusCode);
    }
  }

  static Future<List<MarketWithNakladnoy>?> fetchAllMarketsWithNakByDate({required String beginDate, required String endDate})
  async {
    print("in api service fetch all  MarketsWithNakByDate ...");
    final url = "http://90.156.199.148:8082/magazinTest/main.api" +
        "?mode=nakladnoyByRekvizitList"; //  /main.api&=
    final response = await Client().post(
        Uri.parse(url),
      body: {
          "beginDate":beginDate,
          "endDate":endDate
      }
    );
    print("in apiservice fetch all MarketsWithNakByDate      respose body: ${{
      "beginDate":beginDate,
      "endDate":endDate
    }}");
    print("in apiservice fetch all MarketsWithNakByDate      respose status: ${response.statusCode}");
    print("in apiservice fetch all  MarketsWithNakByDate     respose body: ${response.body}");

    if (response.statusCode == 200) {
      print("in apiservice fetchAll Markets WithNakByDate start parsing respose...");
      final nakladnoylar = parseMarketWithNak(response.body);
      return nakladnoylar; //parese list of nakladnoy
    } else {
      print(
          "in apiservice fetch all  Markets WithNakByDate failed to fetch nakladnoylar");
      throw Exception(response.statusCode);
    }
  }

  static Future<List<TestModel>?> fetchNakladnoylarByDate(
      {required int rekvizitId,required String beginDate,required String endDate})
  async {
    print("in api service fetchNakladnoylar by date ...");
    final url = "http://90.156.199.148:8082/magazinTest/main.api" +
        "?mode=nakladnoyByRekvizitList"; //  beginDate=2025-02-20   &endDate=2025-02-21
    final response = await Client().post(Uri.parse(url), body: {
      "rekvizitId": rekvizitId.toString(),
      "beginDate": beginDate,
      "endDate":endDate
    });
    print("""in apiservice fetchNakladnoylar by date     respose status: body: ${{
    "rekvizitId": rekvizitId.toString(),
    "beginDate": beginDate,
    "endDate":endDate
  }}""");
    print("in apiservice fetchNakladnoylar by date     respose status: ${response.statusCode}");
    print("in apiservice fetchNakladnoylar by date     respose body: ${response.body}");

    if (response.statusCode == 200) {
      print("in apiservice fetchNakladnoylar by date start parsing respose...");
      final nakladnoylar = parseNakladnoylar(response.body);
      return nakladnoylar; //parese list of nakladnoy
    } else {
      print(
          "in apiservice fetchNakladnoylar by date failed to fetch nakladnoylar");
      throw Exception(response.statusCode);
    }
  }

  static Future<bool> closeNakladnoy(
      {required int waybillId})
  async {
    print("in nakladnoy service close nakladnoy by date ...");
    final url = "http://90.156.199.148:8082/magazinTest/main.do" +
        "?mode=waybill_close"; //
    final response = await Client().post(Uri.parse(url), body: {
      "waybillId": waybillId.toString(),
      "waybillStatus": '0'
    });
    print("body: ${{
      "waybillId": waybillId.toString(),
      "waybillStatus": '0'
    }}");
    print("in apiservice close nakladnoy respose status: ${response.statusCode}");
    print("in apiservice close nakladnoy   respose body: ${response.body}");

    if (response.statusCode == 200) {
      print("in apiservice close nakladnoy start parsing respose...");
      final json = jsonDecode(response.body);
      print("api service json:${json}");
      return true; //parese list of nakladnoy
    } else {
      print(
          "in apiservice close nakladnoy failed to fetch nakladnoylar");
      throw Exception(response.statusCode);
    }
  }

  static Future<List<TestNakItems>?> fetchTodaysNakladnoylarsItems(
      {required int waybillId})
  async {
    print("in api service  fetchTodaysNakladnoylarsitems...");
    final url = "http://90.156.199.148:8082/magazinTest/main.api" +
        "?mode=nakladnoyBywarehouseList"; //  /main.api&=
    final response = await Client()
        .post(Uri.parse(url), body: {"waybillId": waybillId.toString()});
    print(
        "in apiservice fetchTodaysNakladnoylarsitems     respose status: ${response.statusCode}");
    print(
        "in apiservice fetchTodaysNakladnoylarsitems     respose body: ${response.body}");
    if (response.statusCode == 200) {
      print(
          "in apiservice fetchTodaysNakladnoylarsitems start parsing respose...");
      final nakladnoylar = parseNakItems(response.body);
      return nakladnoylar; //parese list of nakladnoy
    } else {
      print(
          "in apiservice fetchTodaysNakladnoylarsitems failed to fetch nakladnoylar");
      throw Exception(response.statusCode);
    }
  }
}