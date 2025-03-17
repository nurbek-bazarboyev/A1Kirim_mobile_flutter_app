import 'dart:io';

import 'package:a1_kirim_mobile/src/data/data_sources/api_service.dart';
import 'package:a1_kirim_mobile/src/data/repositories/item_repository.dart';
import 'package:a1_kirim_mobile/src/domain/models/group.dart' show Group;
import 'package:a1_kirim_mobile/src/domain/models/item.dart';
import 'package:a1_kirim_mobile/src/domain/models/market.dart';
import 'package:a1_kirim_mobile/src/domain/models/unit_type.dart' show UnitType;
import 'package:a1_kirim_mobile/src/presentation/blocs/item_types_bloc/item_types_bloc_cubit.dart';
import 'package:a1_kirim_mobile/src/presentation/blocs/kirim_button_bloc/kirim_button_bloc_cubit.dart';
import 'package:a1_kirim_mobile/src/presentation/blocs/new_item_bloc/new_item_button_cubit.dart';
import 'package:a1_kirim_mobile/src/presentation/blocs/umumiy_summa_bloc/umumiy_summa_cubit.dart';
import 'package:a1_kirim_mobile/src/presentation/utils/dialog_helper.dart';
import 'package:a1_kirim_mobile/src/presentation/utils/internet_helper.dart';
import 'package:a1_kirim_mobile/src/presentation/views/home_views/add_exist_item_view.dart';
import 'package:a1_kirim_mobile/src/presentation/widgets/market_widgets/check_box_widget.dart';
import 'package:a1_kirim_mobile/src/presentation/widgets/market_widgets/select_unit_type_widget.dart'
    show SelectUnitTypeWidget;
import 'package:a1_kirim_mobile/src/presentation/widgets/my_app_bar.dart';
import 'package:a1_kirim_mobile/src/presentation/widgets/my_button.dart';
import 'package:a1_kirim_mobile/src/presentation/widgets/my_text_field.dart';
import 'package:a1_kirim_mobile/src/presentation/widgets/show_and_take_image_widget.dart';
import 'package:a1_kirim_mobile/src/utils/constants/color_constants.dart';
import 'package:a1_kirim_mobile/src/utils/constants/double_constants.dart';
import 'package:a1_kirim_mobile/src/utils/constants/style_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart';

class AddNewItemView extends StatefulWidget {
  final Group group;
  final Market market;
  final List<Group> groupList;
  final int index;

  const AddNewItemView(
      {super.key,
      required this.group,
      required this.groupList,
      required this.index,
      required this.market});

  @override
  State<AddNewItemView> createState() => _AddNewItemViewState();
}

class _AddNewItemViewState extends State<AddNewItemView> {
  TextEditingController nameController = TextEditingController();
  TextEditingController groupIdController = TextEditingController();
  TextEditingController barCodeController = TextEditingController();
  TextEditingController olchovBirlikController = TextEditingController();
  TextEditingController birlikController = TextEditingController();
  TextEditingController birlikNameController = TextEditingController();
  TextEditingController checkBoxController = TextEditingController();
  String initialUnitType = 'birlik turi';
  File? image;
  
  void onUnitTypeChange(UnitType? selectedUnitType) {
    print("onUnitTypeChange id: ${selectedUnitType!.unitTypeId}");
    print("onUnitTypeChange name: ${selectedUnitType.unitType}");
    birlikController.text = selectedUnitType.unitTypeId.toString();
    birlikNameController.text = selectedUnitType.unitType;
    print(birlikController.text);
    print(birlikNameController.text);
  }

  void onImageChange(File? pickedImage) {
    setState(() {
      image = pickedImage;
      print("add item pape image path: ${image?.path ?? "no path"}");
    });
  }
  @override
  void initState() {
    // TODO: implement initState
    context.read<NewItemButtonCubit>().updateButtonState(
        [nameController, barCodeController, birlikController]);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    print("object; ${checkBoxController.text}");
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
        centerTitle: true,
        title: Text(
          "Yangi mahsulot qo'shish",
          style: TextStyleConstants.appBarTitleStyle,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 20,),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,

                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text("Guruh: "),
                    Text(
                      widget.group.groupName,
                      style: TextStyleConstants.listTileTitleStyle,
                    )
                  ],
                ),
              ),
              Divider(
                height: 20,
              ),
              SizedBox(
                height: 20,
              ),
              ShowAndTakeImageWidget(
                size: size,
                onImageChange: onImageChange, widget: null,
              ),SizedBox(
                height: 30,
              ),
              MyTextField(
                key: Key('6'),
                label: "Mahsulot nomi",
                controller: nameController,
                maxLines: 3,
              ),
              SizedBox(
                height: 10,
              ),
              MyTextField(
                key: Key('7'),
                label: "barCode",
                controller: barCodeController,
                keyboardType: TextInputType.number,
              ),
              SizedBox(
                height: 10,
              ),
              SelectUnitTypeWidget(
                size: size,
                onChange: onUnitTypeChange,
              ),
              SizedBox(
                height: 10,
              ),
              CheckBoxWidget(onChange: (bool val) {
                print("widget val: $val");
                checkBoxController.text = val ? "1" : "0";
              }),
              SizedBox(
                height: 30,
              ),

              BlocBuilder<NewItemButtonCubit, int>(
                builder: (context, state) {
                  return MyButton(
                    name: state == 0 ? "Maydonlarni to'ldiring" : "Saqlash",
                    backgroudColor: state == 0
                        ? WidgetStateProperty.all(Colors.grey)
                        : null,
                    onPressed: state == 0
                        ? () {
                            print(checkBoxController.text);
                          }
                        : () async {
                            context.read<NewItemButtonCubit>().changeToUntappable();
                            FocusManager.instance.primaryFocus?.unfocus();
                            await Future.delayed(Duration(milliseconds: 360));

                            Item item = Item(
                              name: nameController.text,
                              goodsGroupId: widget.group.goodsGroupId,
                              articul: barCodeController.text,
                              unitTypeId: birlikController.text.isNotEmpty
                                  ? int.parse(birlikController.text)
                                  : null,
                            );
                            print("siz shu itemni yaratyapsiz...");
                            print(item.toMap());
                            final res = await InternetHelper.checkInternet(context);
                            if(res){
                              DialogHelper.progressIndicatorDialog(context, "Qo'shilmoqda...");
                              try {
                                final newItem = await ItemRepository(ApiService(Client())).addNewItem(item);

                                setState(() {
                                  widget.groupList[widget.index].goodsList!.add(newItem);
                                });
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      "Muvaffaqiyatli qo'shildi",
                                      style: TextStyleConstants.successTextStyle,
                                    ),
                                    backgroundColor: ColorConstants.successColor,
                                  ),
                                );
                                print("object; ${checkBoxController.text}");
                                Navigator.pop(context);
                                await Future.delayed(Duration(seconds: 1));
                                if (checkBoxController.text == '1') {
                                  Navigator.pushReplacement(context,
                                      MaterialPageRoute(builder: (context) {
                                        return MultiBlocProvider(
                                          providers: [
                                            BlocProvider(
                                              create: (context) =>
                                                  KirimButtonBlocCubit(),
                                            ),
                                            BlocProvider(
                                              create: (context) =>
                                                  UmumiySummaCubit(),
                                            ),
                                            BlocProvider(
                                              create: (context) =>
                                                  ItemTypesBlocCubit(),
                                            ),
                                          ],
                                          child: AddExistItemView(
                                            item: newItem,
                                            market: widget.market,
                                            sahifagaKirishGuruhlardanmi: false,
                                          ),
                                        );
                                      }));
                                } else {
                                  Navigator.pop(context, newItem);
                                }
                              } catch (e) {
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(SnackBar(
                                  content: Text(
                                    "Iltimos yana urinib ko'ring? exception: ${e.toString()}",
                                    style: TextStyleConstants.errorTextStyle,
                                  ),
                                  backgroundColor: ColorConstants.errorColor,
                                ));
                                Navigator.pop(context);
                              }
                            }else{
                              context.read<NewItemButtonCubit>().changeTotappable();
                              print("Internet yo'q");
                            }

                          },
                  );
                },
              ),
              SizedBox(
                height: DoubleConstants.buttonUnderMargin,
              )
            ],
          ),
        ),
      ),
    );
  }
}
