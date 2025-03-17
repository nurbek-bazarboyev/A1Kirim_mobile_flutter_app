import 'package:a1_kirim_mobile/src/core/utils/number_helper.dart';
import 'package:a1_kirim_mobile/src/utils/constants/style_constants.dart';
import 'package:flutter/material.dart';
class OrgNameAndJamiSummaWidget extends StatelessWidget {
  final double nakladnoyTotalSumma;
  final String orgName;
  final String date;
  const OrgNameAndJamiSummaWidget({super.key, required this.nakladnoyTotalSumma, required this.orgName, required this.date});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 20,
        ),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              SizedBox(
                width: 20,
              ),
              Text("Sana: "),
              Text(
                date,
                style: TextStyleConstants.listTileTitleStyle,
              ),
            ],
          ),
        ),
        Divider(
          height: 20,
        ),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              SizedBox(
                width: 20,
              ),
              Text("Tashkilot: "),
              Text(
                orgName,
                style: TextStyleConstants.listTileTitleStyle,
              ),
            ],
          ),
        ),
        Divider(
          height: 20,
        ),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(
                width: 20,
              ),
              Text("Jami summa: "),
              Text(
                NumberHelper.printSumma(
                    summaAsDouble: nakladnoyTotalSumma) +
                    " so'm",
                style: TextStyleConstants.listTileTitleStyle,
              ),
            ],
          ),
        ),
        Divider(
          height: 20,
        ),
      ],
    );
  }
}
