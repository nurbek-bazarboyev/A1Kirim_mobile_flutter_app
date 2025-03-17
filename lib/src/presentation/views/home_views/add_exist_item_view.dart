import 'dart:io';
import 'package:a1_kirim_mobile/main.dart';
import 'package:a1_kirim_mobile/src/core/utils/number_helper.dart';
import 'package:a1_kirim_mobile/src/data/data_sources/api_service.dart';
import 'package:a1_kirim_mobile/src/data/repositories/image_repository.dart';
import 'package:a1_kirim_mobile/src/data/repositories/item_repository.dart';
import 'package:a1_kirim_mobile/src/data/repositories/local_database_repositories/kirim_repository.dart'
    show KirimRepository;
import 'package:a1_kirim_mobile/src/data/repositories/local_database_repositories/nakladnoy_repository.dart';
import 'package:a1_kirim_mobile/src/domain/models/item.dart';
import 'package:a1_kirim_mobile/src/domain/models/kirim.dart';
import 'package:a1_kirim_mobile/src/domain/models/market.dart';
import 'package:a1_kirim_mobile/src/domain/models/nakladnoy.dart';
import 'package:a1_kirim_mobile/src/domain/models/unit_type.dart';
import 'package:a1_kirim_mobile/src/presentation/blocs/item_types_bloc/item_types_bloc_cubit.dart';
import 'package:a1_kirim_mobile/src/presentation/blocs/kirim_button_bloc/kirim_button_bloc_cubit.dart';
import 'package:a1_kirim_mobile/src/presentation/blocs/kirimlar_list_badge_bloc/kirimlar_list_badge_cubit.dart';
import 'package:a1_kirim_mobile/src/presentation/blocs/umumiy_summa_bloc/umumiy_summa_cubit.dart';
import 'package:a1_kirim_mobile/src/presentation/utils/dialog_helper.dart';
import 'package:a1_kirim_mobile/src/presentation/views/home_views/markets_view.dart';
import 'package:a1_kirim_mobile/src/presentation/widgets/market_widgets/select_unit_type_widget.dart';
import 'package:a1_kirim_mobile/src/presentation/widgets/my_app_bar.dart';
import 'package:a1_kirim_mobile/src/presentation/widgets/my_button.dart';
import 'package:a1_kirim_mobile/src/presentation/widgets/my_text_field.dart';
import 'package:a1_kirim_mobile/src/presentation/widgets/select_color_widget.dart';
import 'package:a1_kirim_mobile/src/utils/constants/color_constants.dart';
import 'package:a1_kirim_mobile/src/utils/constants/double_constants.dart'
    show DoubleConstants;
import 'package:a1_kirim_mobile/src/utils/constants/style_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart';
import '../../widgets/show_and_take_image_widget.dart';

class AddExistItemView extends StatefulWidget {
  final Item item;
  final Market market;
  final bool sahifagaKirishGuruhlardanmi;

  const AddExistItemView(
      {super.key, required this.item, required this.market, this.sahifagaKirishGuruhlardanmi = true});

  @override
  State<AddExistItemView> createState() => _AddExistItemViewState();
}

class _AddExistItemViewState extends State<AddExistItemView> {
  TextEditingController birlikController = TextEditingController();
  TextEditingController birlikNameController = TextEditingController();
  TextEditingController sotuvSummaController = TextEditingController();
  TextEditingController sonController = TextEditingController();
  TextEditingController yMuddatController = TextEditingController();
  TextEditingController summaController = TextEditingController();
  TextEditingController waybillIdController = TextEditingController();
  TextEditingController ustamaFoizController = TextEditingController();
  TextEditingController seriyaController = TextEditingController();
  TextEditingController waybillNumberController = TextEditingController();
  TextEditingController chegirmaSummaController = TextEditingController();
  String today = DateTime.now().toString(); //.split(' ')[0];
  List<dynamic>? pickedColor; //
  File? image;

  void onImageChange(File? pickedImage) {
    setState(() {
      image = pickedImage;
      print("add item pape image path: ${image?.path ?? "no path"}");
    });
  }

  void onColorChange(List<dynamic>? color) {
    setState(() {
      pickedColor = color;
      print("picked color: ${pickedColor}");
    });
  }

  int? selectedColorIndex;

  @override
  void initState() {
    //ImageRepository(ApiService(Client())).fetchImage(imageUrl);
// todo avval url ni olish kerak itemga qoshilib kelishi kerak
    print(widget.item.unitTypeId);
    print(widget.item.unitType);
    context.read<ItemTypesBlocCubit>().changeTypeTo(widget.item.unitType!);
    context
        .read<KirimButtonBlocCubit>()
        .changeButtonColor(sonController, summaController);
    // TODO: implement initState
    sonController.addListener(umumiySumma);
    summaController.addListener(umumiySumma);
    //ustamaFoizController.addListener(umumiySumma);
    super.initState();
  }

  void onUnitTypeChange(UnitType? selectedUnitType) {
    birlikController.text = selectedUnitType!.unitTypeId.toString();
    birlikNameController.text = selectedUnitType.unitType;

    context.read<ItemTypesBlocCubit>().changeTypeTo(selectedUnitType.unitType);
  }

  void umumiySumma() {
    if (sonController.text.isNotEmpty && summaController.text.isNotEmpty) {
      var umumiySumma =
          double.parse(sonController.text) * double.parse(summaController.text);
      context.read<UmumiySummaCubit>().changeUmumiySumma(umumiySumma);
      print("umumiy summa :  $umumiySumma");
      sotuvSummaController.text = umumiySumma.toString();
    }
    else {
      context.read<UmumiySummaCubit>().changeUmumiySumma(0.0);
      print("umumiy summa : 0.0");
    }
  }

  @override
  Widget build(BuildContext myContext) {
    Size size = MediaQuery
        .of(context)
        .size;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: MyAppBar(
        leading: IconButton(
            onPressed: () {Navigator.pop(context);},
            icon: Icon(CupertinoIcons.back, color: ColorConstants.appBarWidgetsColor,)),
        title: Text("Mahsulot kirim qilish", style: TextStyleConstants.appBarTitleStyle,),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        physics: ClampingScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.only(left: 20, right: 20, top: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    Text("Mahsulot nomi: "),
                    Text(
                      widget.item.name!,
                      style: TextStyleConstants.listTileTitleStyle,
                    ),
                  ],
                ),
              ),
              Divider(height: 20,),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text("Tashkilot: "),
                    Text(
                      widget.market.orgName!,
                      style: TextStyleConstants.listTileTitleStyle,
                    ),
                  ],
                ),
              ),
              Divider(height: 20,),

              SizedBox(height: 20,),
              ShowAndTakeImageWidget(
                size: size,
                onImageChange: onImageChange,
              ),
              SizedBox(
                height: 20,
              ),
              // todo   pastdagi malumotlar kerak bo'lib qolsa kommentdan olish kerak

              //SelectColorWidget(pickedColor: pickedColor, onColorChange: onColorChange,),
              //SizedBox(height: 20,),
              // MyTextField(label: "Mahsulot nomi", controller: nameController),
              // SizedBox(height: 10,),

              SizedBox(
                height: 5,
              ),
              SizedBox(
                height: 20,
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Expanded(
                    child: SizedBox(
                      width: 180,
                      child: MyTextField(
                        key: Key('2'),
                        label: "soni",
                        controller: sonController,
                        keyboardType: TextInputType.number,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 5.0),
                            child: Text(
                              "mahsulot birliki",
                              style: TextStyleConstants.listTileTitleStyle,
                            ),
                          ),
                          SelectUnitTypeWidget(
                            size: size / 2,
                            onChange: onUnitTypeChange,
                            oldUnitType: UnitType(
                                unitType: widget.item.unitType!,
                                unitTypeId: widget.item.unitTypeId!),
                          ),
                        ],
                      )),
                ],
              ),
              SizedBox(
                height: 15,
              ),
              BlocBuilder<ItemTypesBlocCubit, String>(
                builder: (context, state) {
                  return MyTextField(
                    key: Key('3'),
                    label: "olingan narx(1 $state uchun)",
                    controller: summaController,
                    keyboardType: TextInputType.number,
                  );
                },
              ),
              SizedBox(
                height: 10,
              ),
              SizedBox(
                height: 20,
              ),
              BlocBuilder<UmumiySummaCubit, double>(
                builder: (context, state) {
                  return Text("jami: " + NumberHelper.printSumma(summaAsDouble: state) + " so'm",
                    style: TextStyleConstants.listTileTitleStyle,);
                },
              ),
              SizedBox(
                height: 60,
              ),

              BlocBuilder<KirimButtonBlocCubit, int>(
                builder: (context, state) {
                  return MyButton(
                    name: state == 0 ? "Maydonlarni to'ldiring" : "Saqlash",
                    backgroudColor: state == 0
                        ? WidgetStateProperty.all(Colors.grey)
                        : null,
                    onPressed: state == 0
                        ? () async {
                      if (image != null) {
                        print("rasm tanlangan");
                        final result =
                        await ImageRepository(ApiService(Client()))
                            .uploadImage(
                            image: image!,
                            goodsGroupId:
                            widget.item.goodsGroupId!,
                            goodsId: widget.item.goodsId!);
                        ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text(result)));
                      }
                    }
                        : () async {
                      DialogHelper.progressIndicatorDialog(context, "Saqlanmoqda...");
                      context.read<KirimButtonBlocCubit>().changeToUnTappable();
                      FocusManager.instance.primaryFocus?.unfocus();
                      Kirim kirim = Kirim(
                          goodsId: widget.item.goodsId!,
                          articul: widget.item.articul!,
                          unitId: int.parse(birlikController.text),
                          // todo kiritadigan qilish kerak
                          soni: double.parse(sonController.text),
                          summa: double.parse(summaController.text),
                          yaroqlilikMuddati:
                          DateTime.now().toString().split(' ')[0],
                          // buni date qilish  kerak
                          rekvizitId: widget.market.rekvizitId!,
                          waybillId: 0,
                          //nakladnoy!.waybillId,
                          //int.parse(waybillIdController.text),
                          ustamaFoiz: 0.0,
                          seriyaRaqam: '0',
                          sotuvSumma: double.parse(summaController.text),
                          waybillNumber: '0',
                          //nakladnoy.waybillNumber,
                          unit: birlikNameController
                              .text // todo kiritadigan qilish kerak
                      );
                      final now = DateTime.now().toString().substring(0,16);
                      print("now: $now");
                      final kirimToSql = KirimModel(
                          kirimId: covertDateWithSekundToInt(DateTime.now().toString().substring(0,19)),
                          goodsId: widget.item.goodsId!,
                          name: widget.item.name!,
                          articul: widget.item.articul!,
                          orgName: widget.market.orgName!,
                          unit: birlikNameController
                              .text,
                          rekvizitId: widget.market.rekvizitId!,
                          kelganSana: DateTime.now().toString().substring(0,10),
                          yaroqlilikMuddati: DateTime.now().toString().split(' ')[0],
                          seriyaRaqam: '0',
                          soni: double.parse(sonController.text),
                          status: 1,
                          summa: double.parse(summaController.text),
                          waybillId: 0,
                          waybillNumber: '0',
                          unitId: int.parse(birlikController.text),
                          sotuvSumma: double.parse(summaController.text),
                          ustamaFoiz: 0.0
                      );

                      print(DateTime.now().toString().split(' ')[0]);
                      print(kirim.toMap());
                      final resposnse =
                      await ItemRepository(ApiService(Client()))
                          .KirimQilish(kirimToSql);
                      print('.........................');
                      print("kirim button : ${resposnse!.toJson()}");
                      final c = sharedPreferences?.getInt("badgeCount${kirim.rekvizitId}")??1;

                      sharedPreferences?.setInt("badgeCount${kirim.rekvizitId}", c==0?1:c+1);
                      print("in add exist item page badge count: ${c}");
                      final c1 = sharedPreferences?.getInt("badgeCount${kirim.rekvizitId}")??-1;
                      print("in add exist item page badge count1: ${c}");
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text(
                          "Muvaffaqiyatli saqlandi",
                          style: TextStyleConstants.successTextStyle,
                        ),
                        backgroundColor: ColorConstants.successColor,
                      ));
                      Navigator.pop(context);
                      await Future.delayed(Duration(milliseconds: 360));
                      if (widget.sahifagaKirishGuruhlardanmi) {
                        print(
                            "siz kirim sahifasiga guruh mahsulotlari ichidan kirdingiz");
                        Navigator.pop(context);
                      } else {
                        print(
                            "siz kirim sahifasiga yangi mahsulot yaratib keyin kirdingiz");
                        Navigator.pop(context, widget.item);
                      }
                      Navigator.of(context,rootNavigator: true).pop;
                    },
                  );
                },
              ),
              SizedBox(
                height: 100,
              )
            ],
          ),
        ),
      ),
    );
  }
}

List<String> clothingImageUrls = [];

int covertDateToInt(String date) {
  String son = '';
  for (int i = 0; i < date.length; i++) {
    if (date[i] != '-') {
      son += date[i];
    } else {
      continue;
    }
  }
  return int.parse(son);
}
int covertDateWithSekundToInt(String date) {
  String son = '';
  for (int i = 0; i < date.length; i++) {
    if (date[i] != '-'&& date[i] != ':' && date[i] != ' ') {
      son += date[i];
    } else {
      continue;
    }
  }
  return int.parse(son);
}