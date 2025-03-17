import 'package:a1_kirim_mobile/src/data/data_sources/api_service.dart';
import 'package:a1_kirim_mobile/src/data/repositories/group_repository.dart';
import 'package:a1_kirim_mobile/src/data/repositories/market_repository.dart';
import 'package:a1_kirim_mobile/src/domain/models/group.dart';
import 'package:a1_kirim_mobile/src/domain/models/market.dart';
import 'package:a1_kirim_mobile/src/presentation/blocs/new_group_button_bloc/new_group_button_cubit.dart';
import 'package:a1_kirim_mobile/src/presentation/utils/dialog_helper.dart';
import 'package:a1_kirim_mobile/src/presentation/utils/internet_helper.dart';
import 'package:a1_kirim_mobile/src/presentation/views/home_views/markets_view.dart';
import 'package:a1_kirim_mobile/src/presentation/widgets/my_app_bar.dart';
import 'package:a1_kirim_mobile/src/presentation/widgets/my_button.dart';
import 'package:a1_kirim_mobile/src/presentation/widgets/my_text_field.dart';
import 'package:a1_kirim_mobile/src/utils/constants/color_constants.dart';
import 'package:a1_kirim_mobile/src/utils/constants/double_constants.dart';
import 'package:a1_kirim_mobile/src/utils/constants/style_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart';

class AddNewGroupView extends StatefulWidget {
  const AddNewGroupView({super.key});

  @override
  State<AddNewGroupView> createState() => _AddNewGroupViewState();
}

class _AddNewGroupViewState extends State<AddNewGroupView> {
  TextEditingController nameController = TextEditingController();
  TextEditingController codeController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    context.read<NewGroupButtonCubit>().updateButtonState([
      nameController,
      codeController
    ]);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(
        leading: IconButton(onPressed: () {
          Navigator.pop(context);
        },
            icon: Icon(
              CupertinoIcons.back, color: ColorConstants.appBarWidgetsColor,)),
        title: Text(
          "Guruh yaratish", style: TextStyleConstants.appBarTitleStyle,),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            SizedBox(height: 50,),
            MyTextField(
                key: Key('4'),
                maxLength: 50,
                //errorText: "Juda uzun bo'lib ketdi",
                label: 'Guruh nomi', controller: nameController),
            SizedBox(height: 10,),
            MyTextField(
              key: Key('5'),
              label: 'Guruh kodi', controller: codeController,keyboardType: TextInputType.number,),
            Spacer(),
            BlocBuilder<NewGroupButtonCubit, int>(
              builder: (context, state) {
                return MyButton(
                  name: state == 0 ? "Maydonlarni to'ldiring" : "Saqlash",
                  backgroudColor: state == 0 ? WidgetStateProperty.all(Colors.grey) : null,
                  onPressed: state == 0 ? null : () async {
                    context.read<NewGroupButtonCubit>().changeToUntappable();
                    FocusManager.instance.primaryFocus!.unfocus();
                    await Future.delayed(Duration(milliseconds: 360));
                    final res = await InternetHelper.checkInternet(context);
                    if(res){
                      DialogHelper.progressIndicatorDialog(context, "Qo'shilmoqda...");
                      try {
                        Group group = Group(
                            goodsGroupId: -1,
                            groupName: nameController.text,
                            code: int.parse(codeController.text),
                            id: -1,
                            goodsList: []);
                        final Group? newGroup = await GroupRepository(ApiService(
                            Client())).createGroups(group);
                        print("guruh yaratildi...");
                        print("new Group: ${newGroup?.toJson()}");
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text(
                            "Muvaffaqiyatli qo'shildi",
                            style: TextStyleConstants.successTextStyle,
                          ),
                          backgroundColor: ColorConstants.successColor,
                        ));
                        Navigator.pop(context);
                        await Future.delayed(Duration(milliseconds: 360));
                        Navigator.pop(context,newGroup);
                      } catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text(e.toString(),
                              style: TextStyleConstants.errorTextStyle,)));
                        Navigator.pop(context);
                      }
                    }else{
                      context.read<NewGroupButtonCubit>().changeTotappable();
                      print("Internet yo'q");

                    }

                },);
              },
            ),
            SizedBox(height: DoubleConstants.buttonUnderMargin,)
          ],
        ),
      ),
    );
  }
}
