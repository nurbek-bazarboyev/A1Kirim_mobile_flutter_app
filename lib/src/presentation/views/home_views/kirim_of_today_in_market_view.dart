import 'package:a1_kirim_mobile/src/data/repositories/local_database_repositories/kirim_repository.dart';
import 'package:a1_kirim_mobile/src/domain/models/kirim.dart';
import 'package:a1_kirim_mobile/src/domain/models/market.dart';
import 'package:a1_kirim_mobile/src/domain/models/test_model.dart';
import 'package:a1_kirim_mobile/src/presentation/blocs/kirimlar_list_badge_bloc/kirimlar_list_badge_cubit.dart';
import 'package:a1_kirim_mobile/src/presentation/blocs/ochiq_nak_dialog_bloc/ochiq_nak_dialog_bloc_cubit.dart';
import 'package:a1_kirim_mobile/src/presentation/utils/dialog_helper.dart';
import 'package:a1_kirim_mobile/src/presentation/utils/ui_nakladnoy_helper.dart';
import 'package:a1_kirim_mobile/src/presentation/widgets/dialog_widgets/calendar_dialog.dart';
import 'package:a1_kirim_mobile/src/presentation/widgets/dialog_widgets/ochiq_nakladnoylar_dialog.dart';
import 'package:a1_kirim_mobile/src/presentation/widgets/dialog_widgets/yangi_nak_dialog.dart';
import 'package:a1_kirim_mobile/src/presentation/widgets/kirim_of_today_vidgets/kirimlar_list_widget.dart';
import 'package:a1_kirim_mobile/src/presentation/widgets/kirim_of_today_vidgets/org_name_and_jami_summa_widget.dart';
import 'package:a1_kirim_mobile/src/presentation/widgets/my_app_bar.dart';
import 'package:a1_kirim_mobile/src/presentation/widgets/my_button.dart';
import 'package:a1_kirim_mobile/src/utils/constants/color_constants.dart';
import 'package:a1_kirim_mobile/src/utils/constants/style_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

List<KirimModel> kirimlarList = [];

class KirimOfTodayInMarketView extends StatefulWidget {
  //final String orgName;
  final Market market;

  const KirimOfTodayInMarketView({super.key, required this.market});

  @override
  State<KirimOfTodayInMarketView> createState() =>
      _KirimOfTodayInMarketViewState();
}

class _KirimOfTodayInMarketViewState extends State<KirimOfTodayInMarketView> {
  TextEditingController wayBillNumberController = TextEditingController();
  TextEditingController izohController = TextEditingController();
  TextEditingController nakladnoySummaController = TextEditingController();
  double nakladnoyTotalSumma = 0.0;
  List<TestModel>? _nakladnoylar;
  TestModel? currentNak;
  String bugungiSana = DateTime.now().toString().substring(0, 10);
  String? _date = DateTime.now().toString().split(' ')[0];

  @override
  void initState() {
    context.read<KirimlarListBadgeCubit>().setCountToNull(
        rekvisitId: widget.market.rekvizitId!);
    // TODO: implement initState
    kirimlarList = [];
    getKirimlar(sana: bugungiSana);
    print(" in kirimlar listi page market: ${widget.market.toJson()}");
    super.initState();
  }

  void getKirimlar({required String sana}) async {
    print("getKirimlar starting ...");

    print(sana);
    final List<KirimModel> list = await KirimRepository.getKirimsFromSql(
        rekvizitId: widget.market.rekvizitId!, kelganSana: sana);
    print("Kirimlar in today kirim page: ${list}");
    setState(() {
      kirimlarList = list;
      calculateTotalSumma();
    });
  }

  void updateKirimlarList(List<KirimModel> newKirimlarList) {
    kirimlarList = newKirimlarList;
    calculateTotalSumma();
  }

  void calculateTotalSumma() {
    nakladnoyTotalSumma = 0.0;
    print("starting to calculate total summa ...");
    kirimlarList.forEach((kirim) {
      print(
          "${kirim.name} summa: ${kirim.summa}    jami: ${kirim.summa *
              kirim.soni}");
      nakladnoyTotalSumma += kirim.summa * kirim.soni;
    });
    setState(() {
      print("nakladnoyTotalSumma: ${nakladnoyTotalSumma}");
    });
  }

  Future<void> getNakladnoylar() async {
    print("you are in KirimOfTodayInMarketView getNakladnoylar");
    try {
      final nakladnoyResult = await UiNakladnoyHelper.getOchiqNakladnoylar(
          rekvizitId: widget.market.rekvizitId!,
          beginDate: bugungiSana,
          endDate: bugungiSana);
      print(_nakladnoylar);
      if (nakladnoyResult != null) {
        _nakladnoylar = [];
        nakladnoyResult.forEach((nak) {
          if (nak.waybillStatus == 1) {
            _nakladnoylar?.add(nak);
            print("kirimlar listi screen nakladnoy.map: ${(nak as TestModel)
                .toMap()}");
          } else {
            // shunchaki tashlab ketamiz chunki bizga yopilgan nakladnoylar kerak emas
            // izoh: waybillStatus = 1 degani nakladnoy hali yopilmagan degani agar 0 bolsa yopilganidir
          }
        });
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("nakladnoylar fetched successfully"),
          backgroundColor: ColorConstants.successColor,
        ));
      } else {
        _nakladnoylar = [];
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("failed to fetch nakladnoylar"),
          backgroundColor: ColorConstants.errorColor,
        ));
      }
    } catch (e) {
      print("in kirim of today view failed to fetch nakladnoylar");
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("failed to fetch nakladnoylar"),
        backgroundColor: ColorConstants.errorColor,
      ));
    }
  }

  void onDateChange(String date) {
    setState(() {
      bugungiSana = date;
      _date = date;
      getKirimlar(sana: _date!);
      print("tanlangan sana kirimlar listi uchun     Sana: ${_date}");
    });
  }

  @override
  Widget build(BuildContext myContext) {
    Size size = MediaQuery
        .of(context)
        .size;
    return Scaffold(
      appBar: MyAppBar(
        centerTitle: true,
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(
              CupertinoIcons.back,
              color: ColorConstants.appBarWidgetsColor,
            )),
        title: Text(
          "Bugungi kirimlar",
          style: TextStyleConstants.appBarTitleStyle,
        ),
        actions: [
          CalendarDialog(
            onDateChange: onDateChange,
            color: ColorConstants.appBarWidgetsColor,
            today: DateTime.now().toString().split(' ')[0],
          )
        ],
      ),
      body: kirimlarList.length == 0
          ? Center(
        child: SizedBox(
          width: size.width - 40,
          child: Text(
            "${_date} sanada kirimlar mavjud emas",
            textAlign: TextAlign.center,
            style: TextStyleConstants.listTileTitleStyle!
                .copyWith(color: Colors.grey, fontSize: 26),
          ),
        ),
      )
          : Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          OrgNameAndJamiSummaWidget(
              nakladnoyTotalSumma: nakladnoyTotalSumma,
              orgName: kirimlarList[0].orgName,
              date: _date!),
          Expanded(
            child: Stack(
              alignment: Alignment.center,
              children: [
                KirimlarListWidget(
                  kirimlarList: kirimlarList,
                  calculateTotalSumma: calculateTotalSumma,
                  updateKirimlarList: updateKirimlarList,
                ),
                Positioned(
                  bottom: 30,
                  child: SizedBox(
                    height: 60,
                    width: 340,
                    child: Row(
                      children: [
                        Expanded(
                            child: MyButton(
                              name: "O'chirish",
                              onPressed: () async {
                                DialogHelper.progressIndicatorDialog(
                                    myContext, "O'chirilmoqda");
                                KirimRepository.deleteListOfKirimlar(
                                    kirimlarList);
                                print(DateTime.now().toString());
                                await Future.delayed(Duration(seconds: 1));
                                Navigator.pop(myContext); // to close dialog
                                Navigator.pop(myContext); // to pop screen
                              },
                            )),
                        SizedBox(
                          width: 10,
                        ),
                        Expanded(
                          child: MyButton(
                            name: "Saqlash",
                            onPressed: () async {
                              await getNakladnoylar();
                              if (_nakladnoylar?.length != 0) {
                                print("in saqlash button");
                                await showDialog(
                                    context: context,
                                    builder: (context) {
                                      return MultiBlocProvider(
                                        providers: [
                                          BlocProvider(
                                            create: (context) =>
                                                OchiqNakDialogBlocCubit(),
                                          ),

                                        ],
                                        child: OchiqNakladnoylarDialog(
                                          market: widget.market,
                                          nakladnoyTotalSumma:
                                          nakladnoyTotalSumma,
                                          myContext: myContext,
                                          size: size,
                                          kirimlarList: kirimlarList,
                                          nakladnoylar: _nakladnoylar!,
                                          limitDate: bugungiSana,
                                        ),
                                      );
                                    });
                              } else {
                                print("saqlash button ichida");
                                showDialog(
                                    context: context,
                                    barrierDismissible: false,
                                    builder: (context) {
                                      return YangiNakDialog(
                                        nakladnoyTotalSumma:
                                        nakladnoyTotalSumma,
                                        market: widget.market,
                                        myContext: myContext,
                                        kirimlarList: kirimlarList,
                                      );
                                    });
                              }
                            },
                          ),
                        )
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}

