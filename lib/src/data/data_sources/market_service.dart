import 'package:a1_kirim_mobile/src/data/data_sources/api_service.dart';
import 'package:a1_kirim_mobile/src/domain/models/market.dart';
import 'package:a1_kirim_mobile/src/utils/constants/server_data.dart';
import 'package:http/http.dart';

class MarketService{
  // this class contains only market-related services e.g add marker, edit market, delete market and so on
  static Future<List<Market>> fetchMarkets() async {
    final url = ServerData.baseUrl + "?mode=getAndroidListRekvizit";
    final response = await Client().get(Uri.parse(url));
    print("fetchMarkets http respose: ${response.body}");

    if (response.statusCode == 200) {

      print("in api service fetchmarkets respose: Succcessful");
      return parseMarkets(response.body);

    } else {

      print("failed to load markets  response: ${response.body}");
      throw Exception('Failed to load markets');

    }
  }
}