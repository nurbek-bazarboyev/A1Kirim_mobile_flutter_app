import 'dart:convert';

import 'package:a1_kirim_mobile/src/domain/models/kirim.dart';
import 'package:http/http.dart' as http;

class KirimService{
  // this class contains only kirim-related services e.g add kirim,edit kirim

  static Future<bool> addKirimlar({required List<KirimToServer> kirimlar}) async {
    print("in api service addKirimlar ...");
    final String url = "http://90.156.199.148:8082/magazinTest/main.api" +
        "?mode=m_offline_print_order";
    print('//////////////////////');
    print(jsonEncode({'wareHouseGoodsList': kirimlar}));
    final respose = await http.post(Uri.parse(url),
        body: jsonEncode({'wareHouseGoodsList': (kirimlar)}));
    print("request: ${respose.request} ${respose.headers} ${respose.body}");
    if (respose.statusCode == 200) {
      print(
          "in api service addKirimlar send successfully  status: ${respose.statusCode} body: ${respose.body}");
      print(" respose; ${utf8.decode(respose.bodyBytes)}");
      return true;
    } else {
      print(
          "in api service addKirimlar failed to send data   status: ${respose.statusCode}  body: ${respose.body}");
      throw Exception(respose.statusCode);
    }

  }
}