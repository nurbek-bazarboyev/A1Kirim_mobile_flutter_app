import 'package:a1_kirim_mobile/src/domain/models/market.dart';
import 'package:a1_kirim_mobile/src/presentation/views/home_views/markets_view.dart';

class MarketHelper{
  static Market getMarket({required int rekvisitId}) {
    Market? _market = null;
    markets.forEach((mar) {
      if (mar.rekvizitId == rekvisitId) {
        _market = mar;
      } else {
        // shunchaki tashlab ketish kerak
      }
    });
    return _market!;
  }
}