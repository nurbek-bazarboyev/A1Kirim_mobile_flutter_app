import 'package:a1_kirim_mobile/src/data/data_sources/api_service.dart';
import 'package:a1_kirim_mobile/src/data/repositories/local_database_repositories/nakladnoy_repository.dart';
import 'package:a1_kirim_mobile/src/domain/models/test_model.dart';
import 'package:http/http.dart';

class UiNakladnoyHelper {
  static getOchiqNakladnoylar({required int rekvizitId, required String beginDate, required String endDate}) async {

      final nakladnoylar = await NakladnoyRepository(ApiService(Client()))
          .getNakladnoysByDateFromServer(
              rekvizitId: rekvizitId, beginDate: beginDate, endDate: endDate);
      List<TestModel> ochiqNakladnoylar = [];
      nakladnoylar?.forEach((nak) {
        if (nak.waybillStatus == 1) {
          ochiqNakladnoylar.add(nak);
          print(ochiqNakladnoylar);
        } else {
          // just skip there
        }
      });
      return ochiqNakladnoylar;
  }
}
