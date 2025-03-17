import 'package:a1_kirim_mobile/src/core/utils/number_helper.dart';
import 'package:a1_kirim_mobile/src/domain/models/kirim.dart';
import 'package:a1_kirim_mobile/src/presentation/widgets/market_widgets/kirim_of_today_tile_trailing_widget.dart';
import 'package:a1_kirim_mobile/src/utils/constants/style_constants.dart';
import 'package:flutter/material.dart';
class KirimlarListWidget extends StatefulWidget {
  List<KirimModel> kirimlarList;
  final void Function() calculateTotalSumma;
  final void Function(List<KirimModel>) updateKirimlarList;

   KirimlarListWidget({super.key, required this.kirimlarList, required this.calculateTotalSumma, required this.updateKirimlarList});

  @override
  State<KirimlarListWidget> createState() => _KirimlarListWidgetState();
}

class _KirimlarListWidgetState extends State<KirimlarListWidget> {
  List<KirimModel> kirimlarList = [];

  @override
  void initState() {
    kirimlarList = widget.kirimlarList;
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: kirimlarList.length,
        itemBuilder: (context, index) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                contentPadding: EdgeInsets.only(left: 15),
                title: Text(
                  "${index + 1}) ${kirimlarList[index].name.toString()}",
                  style:
                  TextStyleConstants.listTileTitleStyle,
                  overflow: TextOverflow.ellipsis,
                ),
                subtitle: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Text(
                      "${NumberHelper.removeLastZero(doubleSon: kirimlarList[index].soni)} ${kirimlarList[index].unit} x ${NumberHelper.removeLastZero(doubleSon: kirimlarList[index].summa)} so'm = ${NumberHelper.printSumma(summaAsDouble: (kirimlarList[index].soni*kirimlarList[index].summa))} so'm"),
                ),
                trailing: KirimOfTodayTileTrailingWidget(
                  kirim: kirimlarList[index],
                  onDelete: (isDeleted){
                    if(isDeleted){
                      kirimlarList.removeAt(index);
                      if(kirimlarList.length == 0){
                        Navigator.pop(context);
                      }
                    }
                    widget.updateKirimlarList(kirimlarList);
                  },
                  onKirimChange: (KirimModel kirim) {
                    setState(() {
                      kirimlarList[index] = kirim;
                      widget.calculateTotalSumma;
                      widget.updateKirimlarList(kirimlarList);
                    });
                  },
                ),
              ),
              Divider(
                height: 1,
              ),
              if(index == kirimlarList.length-1)SizedBox(height: 100,)
            ],
          );
        });
  }
}
