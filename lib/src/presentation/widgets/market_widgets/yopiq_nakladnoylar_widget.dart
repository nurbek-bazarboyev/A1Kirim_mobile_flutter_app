import 'package:a1_kirim_mobile/src/core/utils/number_helper.dart';
import 'package:a1_kirim_mobile/src/domain/models/market.dart';
import 'package:a1_kirim_mobile/src/domain/models/test_model.dart';
import 'package:a1_kirim_mobile/src/presentation/views/home_views/nakladnoy_view.dart';
import 'package:a1_kirim_mobile/src/utils/constants/style_constants.dart';
import 'package:flutter/material.dart';
class YopiqNakladnoylarWidget extends StatefulWidget {
  final List<TestModel>? nakladnoylar;
  final String orgName;
  final Market market;
  const YopiqNakladnoylarWidget({super.key, this.nakladnoylar, required this.orgName, required this.market});

  @override
  State<YopiqNakladnoylarWidget> createState() => _YopiqNakladnoylarWidgetState();
}

class _YopiqNakladnoylarWidgetState extends State<YopiqNakladnoylarWidget> {
  @override
  Widget build(BuildContext context) {
    return widget.nakladnoylar?.length ==0 ? Center(
      child: Text("Yopilgan nakladnoylar mavjud emas",textAlign: TextAlign.center,style: TextStyleConstants.noDataTextStyle,),
    ) :
    ListView.builder(
        itemCount: widget.nakladnoylar?.length,
        itemBuilder: (context,index){
          return ListTile(
            onTap: ()async{
              Navigator.push(context, MaterialPageRoute(builder: (context){
                return NakladnoyView(waybillId: widget.nakladnoylar![index].wayBillId, pdfNameAndId: "${widget.nakladnoylar![index].wayBillId}) ${widget.orgName}", market: widget.market,nakladnoy: widget.nakladnoylar?[index],);
              }));
            },
            title: Text(
              NumberHelper.printSumma(
                  summaAsDouble:
                  widget.nakladnoylar![index].kirimSumma) +
                  " so'm",
              style: TextStyleConstants.listTileTitleStyle,
            ),
            subtitle: Text(
              widget.nakladnoylar![index].wayBillNumber.toString(),
              style: TextStyleConstants.listTileSubTitleStyle,
            ),
          );
        });
  }
}
