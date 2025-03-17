import 'package:a1_kirim_mobile/src/data/data_sources/api_service.dart';
import 'package:a1_kirim_mobile/src/data/repositories/market_repository.dart';
import 'package:a1_kirim_mobile/src/domain/models/market.dart';
import 'package:a1_kirim_mobile/src/presentation/blocs/new_market_button_bloc/new_market_button_cubit.dart';
import 'package:a1_kirim_mobile/src/presentation/utils/dialog_helper.dart';
import 'package:a1_kirim_mobile/src/presentation/utils/internet_helper.dart';
import 'package:a1_kirim_mobile/src/presentation/views/home_views/markets_view.dart';
import 'package:a1_kirim_mobile/src/presentation/widgets/my_app_bar.dart';
import 'package:a1_kirim_mobile/src/presentation/widgets/my_button.dart';
import 'package:a1_kirim_mobile/src/presentation/widgets/my_text_field.dart';
import 'package:a1_kirim_mobile/src/utils/constants/color_constants.dart';
import 'package:a1_kirim_mobile/src/utils/constants/double_constants.dart';
import 'package:a1_kirim_mobile/src/utils/constants/style_constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart';

class AddNewMarketView extends StatefulWidget {
  const AddNewMarketView({super.key});

  @override
  State<AddNewMarketView> createState() => _AddNewMarketViewState();
}

class _AddNewMarketViewState extends State<AddNewMarketView> {
  TextEditingController nameController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController telNumController = TextEditingController();
  TextEditingController INNController = TextEditingController();
  TextEditingController directorNameController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    context.read<NewMarketButtonCubit>().updateButton([
      nameController,
      addressController,
      telNumController,
      directorNameController
    ]);
    super.initState();
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
          "Tashkilot(do'kon) qo'shish",
          style: TextStyleConstants.appBarTitleStyle,
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            SizedBox(
              height: 50,
            ),
            MyTextField(
                key: Key('8'),
                label: "Nomi", controller: nameController),
            SizedBox(
              height: DoubleConstants.spaceBetweenTextField,
            ),
            MyTextField(
                key: Key('9'),
                label: "Address", controller: addressController),
            SizedBox(
              height: DoubleConstants.spaceBetweenTextField,
            ),
            MyTextField(
              key: Key('10'),
              label: "Tel number",
              controller: telNumController,
              keyboardType: TextInputType.phone,
            ),
            SizedBox(
              height: DoubleConstants.spaceBetweenTextField,
            ),
            // MyTextField(
            //   key: Key('11'),
            //   label: "INN",
            //   controller: INNController,
            //   keyboardType: TextInputType.phone,
            // ),
            // SizedBox(
            //   height: DoubleConstants.spaceBetweenTextField,
            // ),
            MyTextField(
                key: Key('12'),
                label: "Direktor", controller: directorNameController),
            SizedBox(
              height: DoubleConstants.spaceBetweenTextField,
            ),
            Spacer(),
            BlocBuilder<NewMarketButtonCubit, int>(
              builder: (context, state) {
                return MyButton(
                  name: state == 0 ? "Maydonlarni to'ldiring" : "Saqlash",
                  backgroudColor: state == 0 ? WidgetStateProperty.all(Colors.grey):null,
                  onPressed: state == 0 ? null : () async {
                    context.read<NewMarketButtonCubit>().changeToUnTappable();
                    FocusManager.instance.primaryFocus?.unfocus();
                    await Future.delayed(Duration(milliseconds: 360));
                    final res = await InternetHelper.checkInternet(context);
                    if(res){
                      print("internet bor");
                      DialogHelper.progressIndicatorDialog(context, "Qo'shilmoqda");
                      print("Siz tashkilot qo'shyapsiz...");
                      Market market = Market(
                          orgName: nameController.text,
                          address: addressController.text,
                          telefonMain: telNumController.text,
                          direktor: directorNameController.text,
                          inn: int.parse(INNController.text.isEmpty
                              ? '0'
                              : INNController.text) ??
                              0);
                      print("market object in add new market button:");
                      print(market.toJson());

                      // bu yerda hozircha inn qoshilmaydi keyinchalik kerak bolib qolsa qoshiladi shu sababdan inn qismiga tegmang
                      // bu yerda inn berilgan bolsa ham api service qismida inn requestga qoshilmagan moboda kerak bolsa api service
                      // qismiga otib >>> "inn":market.inn.toString() <<<   shuni qo'shish kerak ish hal boladi shu bilan
                      final newMarket = await MarketRepository(ApiService(Client())).addMarket(market);
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text(
                          "Muvaffaqiyatli qo'shildi",
                          style: TextStyleConstants.successTextStyle,
                        ),
                        backgroundColor: ColorConstants.successColor,
                      ));
                      Navigator.pop(context);
                      //await Future.delayed(Duration(milliseconds: 360));
                      Navigator.pop(context, newMarket);
                    }else{
                      context.read<NewMarketButtonCubit>().changeToTappable();
                      print("internet mavjud emas");
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
    );
  }
}
