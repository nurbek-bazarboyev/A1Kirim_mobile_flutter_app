import 'package:a1_kirim_mobile/src/core/utils/number_helper.dart';
import 'package:a1_kirim_mobile/src/domain/models/market.dart';
import 'package:a1_kirim_mobile/src/presentation/widgets/market_widgets/kirim_of_today_tile_trailing_widget.dart';
import 'package:a1_kirim_mobile/src/utils/constants/style_constants.dart';
import 'package:flutter/material.dart';

class MarketInfoDialog extends StatelessWidget {
  final Market market;
  const MarketInfoDialog({super.key, required this.market});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: EdgeInsets.all(20),
      child: Padding(
        padding: const EdgeInsets
            .symmetric(
            horizontal: 20,
            vertical: 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    "Tashkilot: ",
                    style: TextStyleConstants
                        .listTileTitleStyle,
                  ),
                  Text(
                      "${market.orgName}",
                      style: TextStyleConstants
                          .simpleTextStyle),
                ],
              ),
            ),
            Divider(height: 20,),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    "Manzil: ",
                    style: TextStyleConstants
                        .listTileTitleStyle,
                  ),
                  Text(
                      "${market.address}",
                      style: TextStyleConstants
                          .simpleTextStyle),
                ],
              ),
            ),
            Divider(height: 20,),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    "Direktor: ",
                    style: TextStyleConstants
                        .listTileTitleStyle,
                  ),
                  Text(
                      "${market.direktor}",
                      style: TextStyleConstants
                          .simpleTextStyle)
                ],
              ),
            ),
            Divider(height: 20,),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    "Tel: ",
                    style: TextStyleConstants
                        .listTileTitleStyle,
                  ),
                  Text(
                      "${market.telefonMain}",
                      style: TextStyleConstants
                          .simpleTextStyle),
                ],
              ),
            ),
            Divider(height: 20,),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    "Qarzdorlik: ",
                    style: TextStyleConstants
                        .listTileTitleStyle,
                  ),
                  Text(
                      "${NumberHelper.printSumma(summaAsDouble: market.qarzdorningQarzQiymati!)} so'm",
                      style: TextStyleConstants
                          .simpleTextStyle)
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
