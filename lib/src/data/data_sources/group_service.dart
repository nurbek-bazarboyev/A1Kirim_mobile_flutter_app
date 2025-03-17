import 'package:a1_kirim_mobile/src/data/data_sources/api_service.dart';
import 'package:a1_kirim_mobile/src/domain/models/group.dart';
import 'package:a1_kirim_mobile/src/utils/constants/server_data.dart';
import 'package:http/http.dart';

class GroupService{
  // this class contains only group_related services e.g add group, edit group, delete group

  static Future<List<Group>> fetchGroups() async {
    print("starting to fetch groups list");
    final url = ServerData.baseUrl + "?mode=m_product_groups_json";
    final response = await Client().get(Uri.parse(url));
    print("in api service fetchGrouops respose.body: ${response.body}");

    if (response.statusCode == 200) {
      print("in api service fetchGroups  status: successfully");
      return parseGroups(response.body);
    } else {
      print("in api service fetchGroups  status: ${response.statusCode}");
      throw Exception(response.statusCode);
    }
  }
}