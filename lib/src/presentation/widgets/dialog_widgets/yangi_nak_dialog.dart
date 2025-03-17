import 'package:a1_kirim_mobile/main.dart';
import 'package:a1_kirim_mobile/src/core/utils/nakladnoy_helper.dart';
import 'package:a1_kirim_mobile/src/core/utils/number_helper.dart';
import 'package:a1_kirim_mobile/src/data/data_sources/api_service.dart';
import 'package:a1_kirim_mobile/src/data/repositories/local_database_repositories/kirim_repository.dart';
import 'package:a1_kirim_mobile/src/data/repositories/local_database_repositories/nakladnoy_repository.dart';
import 'package:a1_kirim_mobile/src/domain/models/kirim.dart';
import 'package:a1_kirim_mobile/src/domain/models/market.dart';
import 'package:a1_kirim_mobile/src/domain/models/nakladnoy.dart';
import 'package:a1_kirim_mobile/src/domain/models/test_model.dart';
import 'package:a1_kirim_mobile/src/presentation/blocs/check_chegirma_summa_bloc/check_chegirma_summa_bloc.dart';
import 'package:a1_kirim_mobile/src/presentation/blocs/umumiy_summa_bloc/umumiy_summa_cubit.dart';
import 'package:a1_kirim_mobile/src/presentation/utils/dialog_helper.dart';
import 'package:a1_kirim_mobile/src/presentation/views/home_views/nakladnoy_view.dart';
import 'package:a1_kirim_mobile/src/presentation/widgets/my_button.dart';
import 'package:a1_kirim_mobile/src/presentation/widgets/my_text_field.dart';
import 'package:a1_kirim_mobile/src/utils/constants/color_constants.dart';
import 'package:a1_kirim_mobile/src/utils/constants/padding_constants.dart';
import 'package:a1_kirim_mobile/src/utils/constants/style_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart';

class YangiNakDialog extends StatefulWidget {
  final double nakladnoyTotalSumma;
  final Market market;
  final BuildContext myContext;
  final List<KirimModel> kirimlarList;

  const YangiNakDialog(
      {super.key,
      required this.nakladnoyTotalSumma,
      required this.market,
      required this.myContext,
      required this.kirimlarList});

  @override
  State<YangiNakDialog> createState() => _YangiNakDialogState();
}

class _YangiNakDialogState extends State<YangiNakDialog> {
  TextEditingController wayBillNumberController = TextEditingController();
  TextEditingController chegirmaSummaController = TextEditingController();
  TextEditingController chegirmaSummaFinalResultController =
      TextEditingController();
  TextEditingController chegirmaFoizController = TextEditingController();
  TextEditingController paymentController = TextEditingController();
  TestModel? currentNak;
  final String currentNakNum = "M" +
      DateTime.now().toString().substring(8, 10) +
      DateTime.now().toString().substring(4, 7);
  late List<KirimModel> kirimlarList;

  String checkWaybillNum(String wayBillNum) {
    if (!wayBillNum.contains("M")) {
      return "M" + wayBillNum;
    } else {
      return wayBillNum;
    }
  }

  void updateChegirmaliSumma(BuildContext contex) {
    String chegirma = '0';
    if (chegirmaSummaController.text.isNotEmpty) {
      chegirma = chegirmaSummaController.text;
    } else {
      chegirma = '0';
    }
    final result = widget.nakladnoyTotalSumma - double.parse(chegirma);
    if (0.0 > result) {
      chegirmaSummaFinalResultController.text = "0.0";
      contex
          .read<UmumiySummaCubit>()
          .changeUmumiySumma(widget.nakladnoyTotalSumma);
    } else {
      chegirmaSummaFinalResultController.text = result.toString();
      contex.read<UmumiySummaCubit>().changeUmumiySumma(result);
    }
  }

  @override
  void initState() {
    kirimlarList = widget.kirimlarList;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => UmumiySummaCubit(),
        ),
        BlocProvider(
          create: (context) => CheckChegirmaSummaBloc(),
        ),
      ],
      child: Builder(builder: (context) {
        chegirmaSummaController.addListener(() {
          context.read<CheckChegirmaSummaBloc>().add(ChangeChegirmaSummaEvent(
              chegirmaSumma: chegirmaSummaController.text,
              jamiSumma: widget.nakladnoyTotalSumma.toString()));
        });
        updateChegirmaliSumma(context);
        return Dialog(
            insetPadding: PaddingConstants.dialogExternalPadding,
            child: Padding(
              padding: PaddingConstants.dialogInternalPadding,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "Yangi nakladnoy yaratish",
                    style: TextStyleConstants.listTileTitleStyle
                        ?.copyWith(fontSize: 20, fontStyle: FontStyle.italic),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 5.0),
                        child: Text(
                          "Nakladnoy raqami",
                          style: TextStyleConstants.listTileTitleStyle,
                        ),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      MyTextField(
                        prefixText: "M",
                        key: Key("wayBillNumber1"),
                        label: currentNakNum,
                        controller: wayBillNumberController,
                        keyboardType: TextInputType.number,
                      ),
                    ],
                  ),

                  SizedBox(
                    height: 15,
                  ),
                  BlocBuilder<CheckChegirmaSummaBloc, CheckChegirmaSummaState>(
                    builder: (context, state) {
                      if (state is ErrorState) {
                        print(
                            "in bloc builder chegirma summa: ${chegirmaSummaController.text}");
                        return MyTextField(
                          key: Key("summa1"),
                          label: "chegirma summasi",
                          controller: chegirmaSummaController,
                          keyboardType: TextInputType.number,
                          errorText: state.error,
                          onChange: (val) {
                            updateChegirmaliSumma(context);
                          },
                        );
                      } else if (state is UpdateDataState) {
                        return MyTextField(
                          key: Key("summa1"),
                          label: "chegirma summasi",
                          controller: chegirmaSummaController,
                          keyboardType: TextInputType.number,
                          onChange: (val) {
                            updateChegirmaliSumma(context);
                          },
                        );
                      } else {
                        return MyTextField(
                          key: Key("summa1"),
                          label: "chegirma summasi",
                          controller: chegirmaSummaController,
                          keyboardType: TextInputType.number,
                          onChange: (val) {
                            updateChegirmaliSumma(context);
                          },
                        );
                      }
                    },
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text("Jami summa: "),
                          Text(
                            NumberHelper.printSumma(
                                    summaAsDouble: widget.nakladnoyTotalSumma) +
                                " so'm",
                            style: TextStyleConstants.listTileTitleStyle,
                          ),
                        ],
                      ),
                    ),
                  ),
                  Divider(
                    height: 20,
                  ),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text("Chegirma bilan: "),
                          BlocBuilder<UmumiySummaCubit, double>(
                            builder: (context, state) {
                              return Text(
                                NumberHelper.printSumma(summaAsDouble: state) +
                                    " so'm",
                                style: TextStyleConstants.listTileTitleStyle,
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                  Divider(
                    height: 20,
                  ),
                  // PaymentTypesWidget(
                  //   onChange: (String name) {
                  //     paymentController.text = name;
                  //     print(
                  //         "yangi nak dialog    payment type: ${paymentController.text}");
                  //   },
                  // ),
                  SizedBox(
                    height: 30,
                  ),
                  Row(
                    children: [
                      Expanded(
                          child: MyButton(
                        name: "Cancel",
                        onPressed: () {
                          chegirmaSummaController.clear();
                          wayBillNumberController.clear();
                          chegirmaFoizController.clear();
                          Navigator.pop(context);
                        },
                      )),
                      SizedBox(
                        width: 10,
                      ),
                      Expanded(
                          child: MyButton(
                        name: "Ok",
                        onPressed: () async {
                          FocusManager.instance.primaryFocus?.unfocus();
                          await Future.delayed(Duration(milliseconds: 360));
                          DialogHelper.progressIndicatorDialog(
                              context, "Yuklanmoqda...");
                          final waybillNumber = wayBillNumberController
                                  .text.isNotEmpty
                              ? checkWaybillNum(wayBillNumberController.text)
                              : currentNakNum;
                          print(DateTime.now().toString().substring(0, 16));
                          print(DateTime.now().toString().substring(0, 10));
                          print(waybillNumber);
                          final cheg = chegirmaSummaController.text.isNotEmpty
                              ? chegirmaSummaController.text
                              : '0.0';

                          double chegirma = widget.nakladnoyTotalSumma -
                              double.parse(
                                  chegirmaSummaFinalResultController.text);
                          final double chegirmaBilan =
                              widget.nakladnoyTotalSumma - chegirma;
                          final nakladnoy = Nakladnoy(
                              rekvizitIdAndSana: 1,
                              rekvizitId: widget.market.rekvizitId!,
                              userId: sharedPreferences!.getInt('userId')!,
                              sana: DateTime.now().toString().substring(0, 10),
                              status: 0,
                              waybillId: 0,
                              waybillNumber: waybillNumber,
                              summa: widget.nakladnoyTotalSumma,
                              paymentType: paymentController.text,
                              chegirmaBilan: chegirmaBilan,
                              chegirmaSumma: chegirma);

                          print(
                              "in kirim of today in market view page  new nakladnoy yaratish    nakladnoy: ${nakladnoy.toMap()}");

                          late Nakladnoy? newNakladnoy;
                          try {
                            newNakladnoy =
                                await NakladnoyRepository(ApiService(Client()))
                                    .createNakladnoy(nakladnoy);
                            print(
                                "in kirim of today in market view page  newNakladnoy: ${newNakladnoy?.toMap()}");
                            currentNak = TestModel(
                                date: newNakladnoy!.sana,
                                wayBillId: newNakladnoy.waybillId,
                                wayBillNumber: newNakladnoy.waybillNumber,
                                summa: newNakladnoy.summa,
                                kirimSumma: newNakladnoy.summa,
                                waybillStatus: 1,
                                chegirmaBilan:
                                    nakladnoy.summa - nakladnoy.chegirmaSumma,
                                chegirmaSumma: newNakladnoy.chegirmaSumma,
                                paymentType: paymentController.text);
                            final result = await NakladnoyHelper
                                .addWayBillIdAndNumberThenSendToServer(
                                    nak: newNakladnoy,
                                    kirimlarList: widget.kirimlarList);

                            if (nakladnoy != null && result) {
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(SnackBar(
                                content: Text(
                                  "successful",
                                  style: TextStyleConstants.successTextStyle,
                                ),
                                backgroundColor: ColorConstants.successColor,
                              ));
                              KirimRepository.deleteListOfKirimlar(
                                  kirimlarList);
                            } else {
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(SnackBar(
                                content: Text(
                                  "nakladnoy: ${nakladnoy.toMap()}\nis added to server: ${result}",
                                  style: TextStyleConstants.errorTextStyle,
                                ),
                                backgroundColor: ColorConstants.errorColor,
                              ));
                            }
                          } catch (e) {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text(
                                "yana urinib ko'ring, internetni tekshiring",
                                style: TextStyleConstants.errorTextStyle,
                              ),
                              backgroundColor: ColorConstants.errorColor,
                            ));
                            print(
                                "failed to make this operation exception: ${e.toString()}");
                          }

                          Navigator.pop(context);
                          print("............. ${currentNak?.chegirmaSumma}");
                          await Future.delayed(Duration(milliseconds: 360));
                          await Navigator.pushReplacement(context,
                              MaterialPageRoute(builder: (context) {
                            return NakladnoyView(
                              waybillId: newNakladnoy!.waybillId,
                              pdfNameAndId: newNakladnoy.sana.toString(),
                              market: widget.market,
                              nakladnoy: currentNak,
                            );
                          }));
                          print("salom");
                          KirimRepository.deleteListOfKirimlar(kirimlarList);
                          await Future.delayed(Duration(milliseconds: 360));
                          Navigator.pop(widget.myContext);
                        },
                      ))
                    ],
                  )
                ],
              ),
            ));
      }),
    );
  }
}
