import 'package:a1_kirim_mobile/main.dart';
import 'package:a1_kirim_mobile/src/core/utils/nakladnoy_helper.dart';
import 'package:a1_kirim_mobile/src/core/utils/number_helper.dart';
import 'package:a1_kirim_mobile/src/data/repositories/local_database_repositories/kirim_repository.dart';
import 'package:a1_kirim_mobile/src/domain/models/kirim.dart';
import 'package:a1_kirim_mobile/src/domain/models/market.dart';
import 'package:a1_kirim_mobile/src/domain/models/nakladnoy.dart';
import 'package:a1_kirim_mobile/src/domain/models/test_model.dart';
import 'package:a1_kirim_mobile/src/presentation/blocs/ochiq_nak_dialog_bloc/ochiq_nak_dialog_bloc_cubit.dart';
import 'package:a1_kirim_mobile/src/presentation/blocs/pdf_view_bloc/pdf_view_bloc.dart' as pdfBloc;
import 'package:a1_kirim_mobile/src/presentation/utils/dialog_helper.dart';
import 'package:a1_kirim_mobile/src/presentation/views/home_views/nakladnoy_view.dart';
import 'package:a1_kirim_mobile/src/presentation/widgets/dialog_widgets/yangi_nak_dialog.dart';
import 'package:a1_kirim_mobile/src/presentation/widgets/market_widgets/select_begin_and_end_date_widget.dart';
import 'package:a1_kirim_mobile/src/utils/constants/color_constants.dart';
import 'package:a1_kirim_mobile/src/utils/constants/padding_constants.dart';
import 'package:a1_kirim_mobile/src/utils/constants/style_constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class OchiqNakladnoylarDialog extends StatefulWidget {
  final List<TestModel> nakladnoylar;
  final Market market;
  final String limitDate;
  final double nakladnoyTotalSumma;
  final BuildContext myContext;
  final Size size;
  final List<KirimModel> kirimlarList;

  OchiqNakladnoylarDialog(
      {super.key,
      required this.nakladnoylar,
      required this.market,
      required this.nakladnoyTotalSumma,
      required this.myContext,
      required this.size,
      required this.kirimlarList,
      required this.limitDate});

  @override
  State<OchiqNakladnoylarDialog> createState() =>
      _OchiqNakladnoylarDialogState();
}

class _OchiqNakladnoylarDialogState extends State<OchiqNakladnoylarDialog>
    with SingleTickerProviderStateMixin {
  late List<KirimModel> kirimlarList;

  TextEditingController beginDateController = TextEditingController();
  TextEditingController endDateController = TextEditingController();
  TestModel? currentNak;
  String? beginDate;
  String? endDate; // = DateTime.now().toString().split(' ')[0];
  bool isLoading = false;
  List<TestModel>? _nakladnoylar;
  List<TestModel>? _ochiqNakladnoylar;
  AnimationController? controller;
  Animation<double>? scaleAnimation;

  @override
  void initState() {
    beginDate = widget.limitDate;
    endDate = widget.limitDate;
    update();
    beginDateController.text = beginDate!;
    endDateController.text = endDate!;
    print(
        "in ochiq nakladnoylar page  beginDate: ${beginDate}   endDate: ${endDate}");
    context.read<OchiqNakDialogBlocCubit>().justUpdateUi(
        initialNaklardoylar: widget.nakladnoylar,
        beginDate: beginDate!,
        endDate: endDate!);

    kirimlarList = widget.kirimlarList;
    controller =
        AnimationController(vsync: this, duration: Duration(milliseconds: 360));
    scaleAnimation =
        CurvedAnimation(parent: controller!, curve: Curves.elasticInOut);

    controller?.addListener(() {
      setState(() {});
    });

    controller?.forward();
    super.initState();
  }

  update() {
    beginDateController.addListener(() {
      if (beginDate != beginDateController.text) {
        beginDate = beginDateController.text;
        context.read<OchiqNakDialogBlocCubit>().updateDateAndNakList(
            rekvizitId: widget.market.rekvizitId!,
            beginDate: beginDate!,
            endDate: endDate!);
        print("beginDate: ${beginDate}");
      } else {
        // just skip there
      }
    });
    endDateController.addListener(() {
      if (endDate != endDateController.text) {
        endDate = endDateController.text;
        context.read<OchiqNakDialogBlocCubit>().updateDateAndNakList(
            rekvizitId: widget.market.rekvizitId!,
            beginDate: beginDate!,
            endDate: endDate!);
        print("endDate: ${endDate}");
      } else {
        // just skip there
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      //scaleanimation
      //scale: scaleAnimation!,
      child: Dialog(
        insetPadding: PaddingConstants.dialogExternalPadding,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Stack(
            children: [
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "Ochiq nakladnoylar",
                    style: TextStyleConstants.listTileTitleStyle
                        ?.copyWith(fontStyle: FontStyle.italic, fontSize: 20),
                  ),
                  SizedBox(
                      height: 65,
                      //width: widget.size.width-40,
                      child: SelectBeginAndEndDateWidget(
                        beginDateController: beginDateController,
                        endDateController: endDateController,
                        topTextColor: Colors.grey,
                        limitDate: widget.limitDate,
                        fontSize: 13,
                        iconSize: 20,
                      )),
                  BlocBuilder<OchiqNakDialogBlocCubit, OchiqNakDialogBlocState>(
                      builder: (context, state) {
                    if (state is LoadingState) {
                      return SizedBox(
                          height: widget.size.height * .4,
                          child: Center(
                            child: DialogHelper.progressIndicatorDialog(
                                context, "Yuklanmoqda..."),
                          ));
                    } else if (state is OchiqNakladnoyDialogErrorState) {
                      return SizedBox(
                          height: widget.size.height * .4,
                          child: Center(
                            child: Text(
                              "Xatolik yuz berdi Iltimos yana urinib ko'ring\n\nError: ${state.error}",
                              style: TextStyleConstants.listTileSubTitleStyle,
                            ),
                          ));
                    } else if (state is OchiqNakLadnoyDataState) {
                      final naks = state.nakladnoylar;
                      return SizedBox(
                        height: widget.size.height * .4,
                        child: ListView.builder(
                            itemCount: naks.length,
                            itemBuilder: (context, index) {
                              return Column(
                                children: [
                                  ListTile(
                                    onTap: () async {
                                      print(
                                          "with show dialog choose nakladnoy: ${naks[index].toMap()}");
                                      showDialog(
                                          context: context,
                                          builder: (context) {
                                            return Dialog(
                                              insetPadding: PaddingConstants
                                                  .dialogExternalPadding,
                                              child: Padding(
                                                padding: PaddingConstants
                                                    .dialogInternalPadding,
                                                child: Row(
                                                  children: [
                                                    CircularProgressIndicator(),
                                                    SizedBox(
                                                      width: 10,
                                                    ),
                                                    Text("Yuklanmoqda...")
                                                  ],
                                                ),
                                              ),
                                            );
                                          });
                                      final selectedNak = naks[index];
                                      TestModel? testNak = selectedNak;
                                      testNak = TestModel(
                                          date: testNak.date,
                                          wayBillId: testNak.wayBillId,
                                          wayBillNumber: testNak.wayBillNumber,
                                          summa: testNak.summa,
                                          kirimSumma: testNak.kirimSumma +
                                              widget.nakladnoyTotalSumma,
                                          paymentType: testNak.paymentType,
                                          waybillStatus: testNak.waybillStatus,
                                          chegirmaBilan: testNak.chegirmaBilan +
                                              widget.nakladnoyTotalSumma,
                                          chegirmaSumma: testNak.chegirmaSumma);
                                      currentNak = testNak;
                                      final _nakladnoy = Nakladnoy(
                                        rekvizitIdAndSana: 1,
                                        rekvizitId: widget.market.rekvizitId!,
                                        userId: sharedPreferences!
                                            .getInt('userId')!,
                                        sana: DateTime.now()
                                            .toString()
                                            .substring(0, 10),
                                        status: 0,
                                        waybillId: selectedNak.wayBillId,
                                        waybillNumber:
                                            selectedNak.wayBillNumber,
                                        summa: widget.nakladnoyTotalSumma,
                                        chegirmaBilan:
                                            selectedNak.chegirmaBilan,
                                        chegirmaSumma:
                                            selectedNak.chegirmaSumma,
                                      );

                                      print(
                                          "siz tanlagan nakladnoy: ${_nakladnoy.toMap()}");
                                      try {
                                        print(
                                            'siz nakladnoyga mahsulotlarni qoshyapsiz...');
                                        await NakladnoyHelper
                                            .addWayBillIdAndNumberThenSendToServer(
                                                nak: _nakladnoy,
                                                kirimlarList:
                                                    widget.kirimlarList);
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(SnackBar(
                                          content: Text(
                                            "Mahsulotlar muvaffaqiyatli qo'shildi",
                                            style: TextStyleConstants
                                                .successTextStyle,
                                          ),
                                          backgroundColor:
                                              ColorConstants.successColor,
                                        ));
                                        KirimRepository.deleteListOfKirimlar(
                                            kirimlarList);
                                      } catch (e) {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(SnackBar(
                                          content: Text(
                                              "Xatolik yuz berdi Iltimos yana urinib ko'ring"),
                                          backgroundColor:
                                              ColorConstants.errorColor,
                                        ));
                                      }
                                      Navigator.pop(context);

                                      await Future.delayed(
                                          Duration(milliseconds: 360));
                                      await Navigator.pushReplacement(context,
                                          MaterialPageRoute(builder: (context) {
                                        return NakladnoyView(
                                          waybillId: _nakladnoy.waybillId,
                                          pdfNameAndId:
                                              _nakladnoy.sana.toString(),
                                          market: widget.market,
                                          nakladnoy: currentNak!,
                                        );
                                      }));
                                      print("salom");

                                      KirimRepository.deleteListOfKirimlar(
                                          kirimlarList);
                                      Navigator.pop(widget.myContext);
                                      Navigator.pop(context);
                                    },
                                    subtitle: Row(
                                      children: [
                                        SingleChildScrollView(
                                          scrollDirection: Axis.horizontal,
                                          child: Text(
                                            "Nakladnoy raqami: ",
                                            style: TextStyleConstants
                                                .listTileSubTitleStyle,
                                          ),
                                        ),
                                        Text(
                                          "${naks[index].wayBillNumber}",
                                          style: TextStyleConstants
                                              .listTileSubTitleStyle,
                                        ),
                                      ],
                                    ),
                                    title: Row(
                                      children: [
                                        Text(
                                          "${index + 1}) ${NumberHelper.printSumma(summaAsDouble: naks[index].kirimSumma)} so'm",
                                          style: TextStyleConstants
                                              .listTileTitleStyle,
                                        ),
                                      ],
                                    ),
                                  ),
                                  Divider(
                                    height: 1,
                                  ),
                                  if (index == naks.length - 1)
                                    SizedBox(
                                      height: 60,
                                    )
                                ],
                              );
                            }),
                      );
                    } else if (state is ErrorState) {
                      return SizedBox(
                          height: widget.size.height * .4,
                          child: Center(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  state.error,
                                  style: TextStyleConstants
                                      .listTileSubTitleStyle
                                      ?.copyWith(
                                          fontSize: 18, color: Colors.red),
                                  textAlign: TextAlign.center,
                                ),
                                Text(
                                  state.errorMessage,
                                  style: TextStyleConstants
                                      .listTileSubTitleStyle
                                      ?.copyWith(fontSize: 18),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ));
                    } else {
                      return SizedBox(
                          height: widget.size.height * .4,
                          child: Center(
                            child: CircularProgressIndicator(),
                          ));
                    }
                  })
                ],
              ),
              Positioned(
                  bottom: 0,
                  right: 0,
                  child: FloatingActionButton(
                      backgroundColor: Colors.blue,
                      child: Icon(
                        CupertinoIcons.plus,
                        color: Colors.white,
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                        showDialog(
                            context: context,
                            barrierDismissible: false,
                            builder: (context) {
                              return YangiNakDialog(
                                  nakladnoyTotalSumma:
                                      widget.nakladnoyTotalSumma,
                                  market: widget.market,
                                  myContext: widget.myContext,
                                  kirimlarList: widget.kirimlarList);
                            });
                      }))
            ],
          ),
        ),
      ),
    );
  }
}
