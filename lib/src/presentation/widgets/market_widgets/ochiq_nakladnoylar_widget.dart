import 'package:a1_kirim_mobile/src/core/utils/number_helper.dart';
import 'package:a1_kirim_mobile/src/data/data_sources/api_service.dart';
import 'package:a1_kirim_mobile/src/data/repositories/local_database_repositories/nakladnoy_repository.dart';
import 'package:a1_kirim_mobile/src/domain/models/market.dart';
import 'package:a1_kirim_mobile/src/domain/models/test_model.dart';
import 'package:a1_kirim_mobile/src/presentation/views/home_views/markets_view.dart';
import 'package:a1_kirim_mobile/src/presentation/views/home_views/nakladnoy_view.dart';
import 'package:a1_kirim_mobile/src/presentation/views/home_views/nakladnoylar_view.dart';
import 'package:a1_kirim_mobile/src/presentation/widgets/market_widgets/kirim_of_today_tile_trailing_widget.dart';
import 'package:a1_kirim_mobile/src/presentation/widgets/my_button.dart';
import 'package:a1_kirim_mobile/src/utils/constants/color_constants.dart';
import 'package:a1_kirim_mobile/src/utils/constants/style_constants.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';

class OchiqNakladnoylarWidget extends StatefulWidget {
  final List<TestModel>? nakladnoylar;
  final String orgName;
  final Market market;

  const OchiqNakladnoylarWidget({
    super.key,
    this.nakladnoylar,
    required this.orgName,
    required this.market,
  });

  @override
  State<OchiqNakladnoylarWidget> createState() =>
      _OchiqNakladnoylarWidgetState();
}

class _OchiqNakladnoylarWidgetState extends State<OchiqNakladnoylarWidget> {

  @override
  Widget build(BuildContext context) {
    return widget.nakladnoylar?.length == 0
        ? Center(
            child: Text(
              "Ochiq nakladnoylar mavjud emas",
              textAlign: TextAlign.center,
              style: TextStyleConstants.noDataTextStyle,
            ),
          )
        : ListView.builder(
            itemCount: widget.nakladnoylar?.length,
            itemBuilder: (context, index) {
              return ListTile(
                onTap: () async {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return NakladnoyView(
                      waybillId: widget.nakladnoylar![index].wayBillId,
                      pdfNameAndId:
                          "${widget.nakladnoylar![index].wayBillId}) ${widget.orgName}",
                      market: widget.market,
                      nakladnoy: widget.nakladnoylar?[index],
                    );
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
                trailing: SizedBox(
                  width: 100,
                  height: 40,
                  child: MyButton(
                    name: "Yopish",
                    onPressed: () async{
                      print("in ochiq nakladnoylar view you are closing nakladnoy...");
                      try{
                       final result = await NakladnoyRepository(ApiService(Client())).closeNakladnoyInServer(waybillId: widget.nakladnoylar![index].wayBillId);
                       if(result){
                         yopiqNakladnoylar?.add(widget.nakladnoylar![index]);
                         widget.nakladnoylar?.removeWhere((nak){return nak.wayBillId == widget.nakladnoylar?[index].wayBillId;});
                         setState(() {
                           print("removed successfully");
                         });
                         ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Closed successfully",style: TextStyleConstants.successTextStyle,),backgroundColor: ColorConstants.successColor,));
                       }{
                         ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Iltimos yana urinib ko'ring")));
                       }
                      }catch(e){
                        print("Iltimos yana urinib ko'ring exception:${e.toString()}");
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Serverda xatolik exception:${e.toString()}")));
                      }
                    },
                    nameFontSize: 15,
                  ),
                ),
              );
            });
  }
}
