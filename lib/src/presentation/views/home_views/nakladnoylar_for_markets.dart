import 'package:a1_kirim_mobile/src/core/utils/market_helper.dart';
import 'package:a1_kirim_mobile/src/core/utils/number_helper.dart';
import 'package:a1_kirim_mobile/src/data/data_sources/api_service.dart';
import 'package:a1_kirim_mobile/src/data/repositories/local_database_repositories/nakladnoy_repository.dart';
import 'package:a1_kirim_mobile/src/domain/models/market.dart';
import 'package:a1_kirim_mobile/src/domain/models/test_model.dart';
import 'package:a1_kirim_mobile/src/presentation/blocs/nak_for_markets_bloc/nak_for_markets_cubit.dart';
import 'package:a1_kirim_mobile/src/presentation/blocs/pdf_view_bloc/pdf_view_bloc.dart';
import 'package:a1_kirim_mobile/src/presentation/views/home_views/markets_view.dart';
import 'package:a1_kirim_mobile/src/presentation/views/home_views/nakladnoy_view.dart';
import 'package:a1_kirim_mobile/src/presentation/views/home_views/nakladnoylar_view.dart';
import 'package:a1_kirim_mobile/src/presentation/widgets/market_widgets/select_begin_and_end_date_widget.dart';
import 'package:a1_kirim_mobile/src/presentation/widgets/my_app_bar.dart';
import 'package:a1_kirim_mobile/src/utils/constants/color_constants.dart';
import 'package:a1_kirim_mobile/src/utils/constants/style_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart';

class NakladnoylarForMarkets extends StatefulWidget {
  const NakladnoylarForMarkets({super.key});

  @override
  State<NakladnoylarForMarkets> createState() => _NakladnoylarForMarketsState();
}

class _NakladnoylarForMarketsState extends State<NakladnoylarForMarkets> {
  TextEditingController beginDateController = TextEditingController();
  TextEditingController endDateController = TextEditingController();
  Set<int> marketsWithNak = {};
  List<MarketWithNakladnoy> marWithNakList = [];
  String _beginDate = DateTime.now().toString().split(' ')[0];
  String _endDate = DateTime.now().toString().split(' ')[0];
  List<TestModel>? nakladnoylar;

  Future<void> getMarketsWithNak(
      {required String beginDate, required String endDate}) async {
    try {
      context.read<NakForMarketsCubit>().changeToLoading();
      marWithNakList = [];
      marketsWithNak = {};
      final allNakladnoylar = await NakladnoyRepository(ApiService(Client()))
          .getAllMarketsWithNakByDateFromServer(
              beginDate: beginDate, endDate: endDate);
      print("allNakladnoylar length: ${allNakladnoylar?.length}");
      // allNakladnoylar?.forEach((nak){
      //   final isExist = marketsWithNak.add(nak.rekvisitId);
      //   if(isExist){
      //     marWithNakList.add(nak);
      //   }
      //  print("nakladnoy to market name: ${nak.toMap()}");
      // });
      marWithNakList = allNakladnoylar!;
      context.read<NakForMarketsCubit>().updateList(
          marWithNakList: allNakladnoylar,
          beginDate: beginDate,
          endDate: endDate);
      print("marketsWithNak length: ${marketsWithNak.length}");
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Iltimos yana urinib koring")));
    }
  }

  @override
  void initState() {
    getMarketsWithNak(beginDate: _beginDate, endDate: _endDate);
    // TODO: implement initState
    updateUi();
    super.initState();
  }

  void updateUi() {
    beginDateController.addListener(() {
      _beginDate = beginDateController.text;
      getMarketsWithNak(beginDate: _beginDate, endDate: _endDate);
      print("beginDateController: ${beginDateController.text}");
      print("endDateController: ${_endDate}");
    });
    endDateController.addListener(() {
      _endDate = endDateController.text;
      getMarketsWithNak(beginDate: _beginDate, endDate: _endDate);
      print("endDateController: ${endDateController.text}");
      print("beginDateController: ${_beginDate}");
    });
  }

  @override
  Widget build(BuildContext context) {
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
          "Nakladnoylar",
          style: TextStyleConstants.appBarTitleStyle,
        ),
      ),
      body: Column(
        children: [
          SizedBox(
            height: 10,
          ),
          SizedBox(
              height: 70,
              child: SelectBeginAndEndDateWidget(
                  beginDateController: beginDateController,
                  endDateController: endDateController)),
          SizedBox(
            height: 10,
          ),
          BlocBuilder<NakForMarketsCubit, NakForMarketsState>(
            builder: (context, state) {
              if (state is LoadingState) {
                return Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Center(
                          child: CircularProgressIndicator(),
                        ),
                      ],
                    ),
                  ),
                );
              } else if (state is UpdateMarkWithNakListState) {
                return Expanded(
                  child: ListView.builder(
                      itemCount: marWithNakList.length,
                      itemBuilder: (context, index) {
                        print("nak:${marWithNakList[index].toMap()}");
                        return Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            ListTile(
                              onTap: () async {
                                Navigator.push(context,
                                    MaterialPageRoute(builder: (context) {
                                  return BlocProvider(
                                    create: (context) => PdfViewBloc(),
                                    child: Builder(
                                      builder: (context) {
                                        return NakladnoyView(
                                          waybillId:
                                              marWithNakList[index].waybillId,
                                          pdfNameAndId:
                                              "${marWithNakList[index].waybillId}) ${marWithNakList[index].name}",
                                          market: MarketHelper.getMarket(
                                              rekvisitId: marWithNakList[index]
                                                  .rekvisitId),
                                          nakladnoy: marWithNakList[index]
                                              .covertToNakladnoy(),
                                        );
                                      }
                                    ),
                                  );
                                }));
                              },
                              title: SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  child: Row(children: [
                                    Text(
                                      "${marWithNakList[index].waybillNum}  :  " +
                                          marWithNakList[index].name,
                                      style: TextStyleConstants
                                          .listTileTitleStyle,
                                    ),
                                  ])),
                              subtitle: SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  child: Row(children: [
                                    Text(
                                        "sana: ${marWithNakList[index].sana}",
                                        style: TextStyleConstants
                                            .listTileSubTitleStyle
                                            ?.copyWith(
                                                fontWeight:
                                                    FontWeight.w700)),
                                    Text(
                                      "     summa: " +
                                          NumberHelper.printSumma(
                                              summaAsDouble:
                                                  marWithNakList[index]
                                                      .kirimSumma) +
                                          " so'm",
                                      style: TextStyleConstants
                                          .listTileSubTitleStyle
                                          ?.copyWith(
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ])),
                            ),
                            Divider(
                              height: 1,
                            ),
                          ],
                        );
                      }),
                );
              } else if (state is EmptyListState) {
                return Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Center(
                          child: Text(
                            state.data,
                            textAlign: TextAlign.center,
                            style: TextStyleConstants.listTileSubTitleStyle
                                ?.copyWith(fontSize: 20),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              } else if (state is ErrorDateState) {
                return Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Center(
                          child: Column(
                            children: [
                              Text(
                                state.error,
                                style: TextStyleConstants
                                    .listTileSubTitleStyle
                                    ?.copyWith(
                                        fontSize: 20, color: Colors.red),
                                textAlign: TextAlign.center,
                              ),
                              Text(
                                state.errorMessage,
                                style: TextStyleConstants
                                    .listTileSubTitleStyle
                                    ?.copyWith(fontSize: 20),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              } else {
                return Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Center(
                          child: Text(
                            "Nomalum xatolik",
                            style: TextStyleConstants.listTileSubTitleStyle
                                ?.copyWith(fontSize: 20),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }
            },
          ),
        ],
      ),
    );
  }
}
