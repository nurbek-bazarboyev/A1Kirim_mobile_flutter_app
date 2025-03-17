import 'dart:convert';

import 'package:a1_kirim_mobile/src/core/utils/number_helper.dart';
import 'package:a1_kirim_mobile/src/data/data_sources/api_service.dart';
import 'package:a1_kirim_mobile/src/data/repositories/local_database_repositories/kirim_repository.dart';
import 'package:a1_kirim_mobile/src/domain/models/kirim.dart';
import 'package:a1_kirim_mobile/src/domain/models/unit_type.dart';
import 'package:a1_kirim_mobile/src/presentation/widgets/market_widgets/kirim_of_today_tile_trailing_widget.dart';
import 'package:a1_kirim_mobile/src/presentation/widgets/market_widgets/select_unit_type_widget.dart';
import 'package:a1_kirim_mobile/src/presentation/widgets/my_app_bar.dart';
import 'package:a1_kirim_mobile/src/presentation/widgets/my_button.dart';
import 'package:a1_kirim_mobile/src/presentation/widgets/my_text_field.dart';
import 'package:a1_kirim_mobile/src/utils/constants/color_constants.dart';
import 'package:a1_kirim_mobile/src/utils/constants/style_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/scheduler.dart';
import 'package:http/http.dart';

class UpdateKirimView extends StatefulWidget {
  final void Function(KirimModel) onKirimChange;
  final KirimModel kirim;

  const UpdateKirimView(
      {super.key, required this.kirim, required this.onKirimChange});

  @override
  State<UpdateKirimView> createState() => _UpdateKirimViewState();
}

class _UpdateKirimViewState extends State<UpdateKirimView> {
  TextEditingController sonController = TextEditingController();
  TextEditingController narxController = TextEditingController();
  TextEditingController birlikController = TextEditingController();
  TextEditingController birlikNameController = TextEditingController();

  void onUnitTypeChange(UnitType? selectedUnitType) {
    birlikController.text = selectedUnitType!.unitTypeId.toString();
    birlikNameController.text = selectedUnitType.unitType;
  }

  KirimModel? changableKirim;

  @override
  void initState() {
    // TODO: implement initState
    changableKirim = widget.kirim;
    narxController.text =
        NumberHelper.removeLastZero(doubleSon: widget.kirim.summa).toString();
    sonController.text =
        NumberHelper.removeLastZero(doubleSon: widget.kirim.soni).toString();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery
        .of(context)
        .size;
    return Scaffold(
      appBar: MyAppBar(
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(
              CupertinoIcons.back,
              color: ColorConstants.appBarWidgetsColor,
            )),
        title: Text(
          "Update kirim",
          style: TextStyleConstants.appBarTitleStyle,
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              //SizedBox(height: 20,),
              Text(
                "${changableKirim!.name} dan ${NumberHelper.printSumma(summaAsDouble: changableKirim!.soni)} ${changableKirim!
                    .unit} sotib olindi. \n\nTashkilot nomi: ${changableKirim!
                    .orgName}\nKirim sanasi: ${changableKirim!.kelganSana}",
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                    fontStyle: FontStyle.italic),
              ),
              SizedBox(
                height: 20,
              ),
              MyTextField(
                label: 'Soni',
                controller: sonController,
                key: Key('Soni1'),
                keyboardType: TextInputType.number,
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                "Mahsulot birliki",
                style: TextStyleConstants.listTileTitleStyle!
                    .copyWith(fontStyle: FontStyle.italic),
              ),
              SelectUnitTypeWidget(
                size: size,
                onChange: onUnitTypeChange,
                oldUnitType: UnitType(
                    unitType: changableKirim!.unit,
                    unitTypeId: changableKirim!.unitId),
              ),
              SizedBox(
                height: 10,
              ),
              MyTextField(
                label: 'Olingan narxi',
                controller: narxController,
                key: Key('OlinganNarx1'),
                keyboardType: TextInputType.number,
              ),
              SizedBox(
                height: 20,
              ),
              MyButton(
                  onPressed: () async {
                    FocusManager.instance.primaryFocus?.unfocus();
                    await Future.delayed(Duration(milliseconds: 360));
                    showDialog(
                        context: context,
                        builder: (context) {
                          return Dialog(
                            child: Row(
                              mainAxisAlignment:
                              MainAxisAlignment.center,
                              crossAxisAlignment:
                              CrossAxisAlignment.center,
                              children: [
                                CircularProgressIndicator(),
                                SizedBox(
                                  width: 10,
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20, vertical: 25),
                                  child: Text(
                                    "Yangilanmoqda...",
                                    style: TextStyleConstants
                                        .listTileTitleStyle,
                                  ),
                                )
                              ],
                            ),
                          );
                        });
                    KirimModel newKirim = KirimModel(
                        kirimId: changableKirim!.kirimId,
                        goodsId: changableKirim!.goodsId,
                        name: changableKirim!.name,
                        articul: changableKirim!.articul,
                        orgName: changableKirim!.orgName,
                        unit: birlikNameController.text,
                        rekvizitId: changableKirim!.rekvizitId,
                        kelganSana: changableKirim!.kelganSana,
                        yaroqlilikMuddati: changableKirim!.yaroqlilikMuddati,
                        seriyaRaqam: changableKirim!.seriyaRaqam,
                        soni: double.parse(sonController.text),
                        status: changableKirim!.status,
                        summa: double.parse(narxController.text),
                        waybillId: changableKirim!.waybillId,
                        waybillNumber: changableKirim!.waybillNumber,
                        unitId: int.parse(birlikController.text),
                        sotuvSumma: changableKirim!.sotuvSumma,
                        ustamaFoiz: changableKirim!.ustamaFoiz);
                    print("in UpdateKirimView page saqlash button...");
                    print("newkirim: ${newKirim.toJson()}");
                    try {
                      var result = await KirimRepository.updateKirimInSql(newKirim);
                      if (result) {
                        widget.onKirimChange(newKirim);
                        Navigator.of(context).pop();
                        await Future.delayed(Duration(milliseconds: 460));
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text(
                              "Updated successfully"),
                          backgroundColor: ColorConstants.successColor,));

                        SchedulerBinding.instance.addPostFrameCallback((_) {
                          Navigator.of(context, rootNavigator: true).pop(
                              newKirim);
                        });
                      } else {
                        print(
                            "in (else statement) update kirim page's button failed to update kirim");
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text("Iltimos yana urinib ko'ring!")));
                        Navigator.of(context).pop();
                        await Future.delayed(Duration(seconds: 1));
                      }
                    } catch (e) {
                      print(
                          "in catch update kirim page's button failed to update kirim");
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text(
                              "Iltimos yana urinib ko'ring exception: ${e
                                  .toString()}")));
                      Navigator.of(context).pop();
                      await Future.delayed(Duration(seconds: 1));
                    }
                  },
                  name: "Saqlash")
            ],
          ),
        ),
      ),
    );
  }
}
