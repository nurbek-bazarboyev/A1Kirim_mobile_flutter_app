import 'dart:io';
import 'package:a1_kirim_mobile/src/data/data_sources/api_service.dart';
import 'package:a1_kirim_mobile/src/data/repositories/login_repository.dart';
import 'package:a1_kirim_mobile/src/presentation/blocs/groups_list_bloc/groups_list_bloc.dart';
import 'package:a1_kirim_mobile/src/presentation/blocs/markets_list_bloc/markets_list_bloc.dart';
import 'package:a1_kirim_mobile/src/presentation/utils/dialog_helper.dart';
import 'package:a1_kirim_mobile/src/presentation/views/home_views/markets_view.dart';
import 'package:a1_kirim_mobile/src/utils/constants/color_constants.dart';
import 'package:a1_kirim_mobile/src/utils/constants/style_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart';
import 'package:flutter/cupertino.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  GlobalKey<AnimatedListState> _listKey = GlobalKey();
  TextEditingController controller = TextEditingController();
  String? errorText;
  int length = 0;
  int? currentNum;
  bool isFaded = true;
  Future<bool> checkInternet()async{
    try {
      final result = await InternetAddress.lookup('example.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        print('connected');
        return true;
      }
      return false;
    } on SocketException catch (_) {
      print('not connected');
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Internet mavjud emas!",style: TextStyleConstants.errorTextStyle,),backgroundColor: ColorConstants.errorColor,));
      return false;
    }
  }
  login(BuildContext con) async {
    try {
      DialogHelper.progressIndicatorDialog(context, "Yuklanmoqda...");

      var result =
      await LoginRepository(ApiService(Client())).login(controller.text);
      if (result == "200") {
        Navigator.pushAndRemoveUntil(con,  MaterialPageRoute(builder: (con) {
          return MultiBlocProvider(
            providers: [
              BlocProvider(
                create: (context) => MarketsListBloc(),
              ),
              BlocProvider(
                create: (context) => GroupsListBloc(),
              ),

            ],
            child: MarketsView(),
          );
        }),(route)=>false);

      } else {
        if (result.contains("500")) {
          result = "Iltimos yana urinib ko'ring";
          Navigator.of(context).pop();
        } else if (result.contains("300")) {
          result = "Akkount mavjud emas";
          Navigator.of(context).pop();
        } else {
          Navigator.of(context).pop();
          result = "Kalit so'z xato";
        }
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(
            result,
            style: TextStyleConstants.errorTextStyle,
          ),
          backgroundColor: ColorConstants.errorColor,
        ));
      }
    } catch (e) {
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(
          e.toString(),
          style: TextStyleConstants.errorTextStyle,
        ),
        backgroundColor: ColorConstants.errorColor,
      ));
    }
  }

  @override
  Widget build(BuildContext myContext) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  "assets/logo/company_logo.png",
                  height: 60,
                  width: 60,
                ),
                Image.asset(
                  "assets/logo/login_logo.png",
                  height: 100,
                ),
              ],
            ),
            Center(
              child: SizedBox(
                  height: 50,
                  child: AnimatedList(
                      shrinkWrap: true,
                      key: _listKey,
                      initialItemCount: length,
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, index, animation) {
                        return AnimatedSwitcher(
                            duration: Duration(milliseconds: 360),
                            transitionBuilder: (child, animation) {
                              return FadeTransition(
                                opacity: animation,
                                child: child,
                              );
                            },
                            child: _buildDot(
                                isFaded: isFaded,
                                index: index,
                                length: length,
                                currentNum: currentNum!));
                      })),
            ),
            SizedBox(
              height: 30,
            ),
            Text(
              "Kalit so'z kiriting",
              style: TextStyleConstants.listTileTitleStyle,
            ),
            SizedBox(
              height: 30,
            ),
            Container(
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      NumberWidget(
                        number: "1",
                        onTap: () async {
                          setState(() {
                            controller.text += "1";
                            length++;
                            currentNum = 1;
                          });

                          _listKey.currentState!.insertItem(length - 1);
                          isFaded = false;
                          await Future.delayed(Duration(milliseconds: 360));
                          isFaded = true;
                          setState(() {});
                        },
                      ),
                      NumberWidget(
                        number: "2",
                        onTap: () async {
                          setState(() {
                            controller.text += "2";
                            length++;
                            currentNum = 2;
                          });

                          _listKey.currentState!.insertItem(length - 1);
                          isFaded = false;
                          await Future.delayed(Duration(milliseconds: 360));
                          isFaded = true;
                          setState(() {});
                        },
                      ),
                      NumberWidget(
                        number: "3",
                        onTap: () async {
                          setState(() {
                            controller.text += "3";
                            length++;
                            currentNum = 3;
                          });

                          _listKey.currentState!.insertItem(length - 1);
                          isFaded = false;
                          await Future.delayed(Duration(milliseconds: 360));
                          isFaded = true;
                          setState(() {});
                        },
                      )
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      NumberWidget(
                        number: "4",
                        onTap: () async {
                          setState(() {
                            controller.text += "4";
                            length++;
                            currentNum = 4;
                          });

                          _listKey.currentState!.insertItem(length - 1);
                          isFaded = false;
                          await Future.delayed(Duration(milliseconds: 360));
                          isFaded = true;
                          setState(() {});
                        },
                      ),
                      NumberWidget(
                        number: "5",
                        onTap: () async {
                          setState(() {
                            controller.text += "5";
                            length++;
                            currentNum = 5;
                          });

                          _listKey.currentState!.insertItem(length - 1);
                          isFaded = false;
                          await Future.delayed(Duration(milliseconds: 360));
                          isFaded = true;
                          setState(() {});
                        },
                      ),
                      NumberWidget(
                        number: "6",
                        onTap: () async {
                          setState(() {
                            controller.text += "6";
                            length++;
                            currentNum = 6;
                          });

                          _listKey.currentState!.insertItem(length - 1);
                          isFaded = false;
                          await Future.delayed(Duration(milliseconds: 360));
                          isFaded = true;
                          setState(() {});
                        },
                      )
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      NumberWidget(
                        number: "7",
                        onTap: () async {
                          setState(() {
                            controller.text += "7";
                            length++;
                            currentNum = 7;
                          });

                          _listKey.currentState!.insertItem(length - 1);
                          isFaded = false;
                          await Future.delayed(Duration(milliseconds: 360));
                          isFaded = true;
                          setState(() {});
                        },
                      ),
                      NumberWidget(
                        number: "8",
                        onTap: () async {
                          setState(() {
                            controller.text += "8";
                            length++;

                            currentNum = 8;
                          });
                          _listKey.currentState!.insertItem(length - 1);
                          isFaded = false;
                          await Future.delayed(Duration(milliseconds: 360));
                          isFaded = true;
                          setState(() {});
                        },
                      ),
                      NumberWidget(
                        number: "9",
                        onTap: () async {
                          setState(() {
                            controller.text += "9";
                            length++;
                            currentNum = 9;
                          });

                          _listKey.currentState!.insertItem(length - 1);
                          isFaded = false;
                          await Future.delayed(Duration(milliseconds: 360));
                          isFaded = true;
                          setState(() {});
                        },
                      )
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      IconButton(
                          onPressed: () {
                            setState(() {
                              if (length != 0) {
                                controller.text =
                                    controller.text.substring(0, length - 1);
                                length--;
                                _listKey.currentState!.removeItem(
                                    length,
                                        (context, animation) =>
                                        FadeTransition(
                                          opacity: animation,
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: CircleAvatar(
                                              backgroundColor: Colors.grey,
                                              radius: 10,
                                            ),
                                          ),
                                        ));
                              }
                              print("remove last: ${controller.text}");
                            });
                          },
                          icon: Container(
                              height: 40,
                              width: 40,
                              alignment: Alignment.center,
                              child: Icon(
                                CupertinoIcons.delete_left,
                              ))),
                      NumberWidget(
                        number: "0",
                        onTap: () async {
                          setState(() {
                            controller.text += "0";
                            length++;
                            currentNum = 0;
                          });

                          _listKey.currentState!.insertItem(length - 1);
                          isFaded = false;
                          await Future.delayed(Duration(milliseconds: 360));
                          isFaded = true;
                          setState(() {});
                        },
                      ),
                      NumberWidget(
                        number: "ok",
                        fontSize: 28,
                        color: Colors.grey,
                        onTap: () async {
                          final result = await checkInternet();
                          if(result){
                            await login(myContext);
                          }else{

                          }

                        },
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 40,
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

Widget _buildDot({required bool isFaded,
  required int index,
  required int length,
  required int currentNum}) {
  return !isFaded && index == length - 1
      ? Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(
        "${currentNum}",
        style: TextStyle(fontSize: 20),
      ))
      : Padding(
    padding: const EdgeInsets.all(8.0),
    child: CircleAvatar(
      backgroundColor: Colors.blueAccent,
      radius: 10,
    ),
  );
}

class NumberWidget extends StatelessWidget {
  final String number;
  final void Function() onTap;
  final Color? color;
  final double fontSize;

  const NumberWidget({super.key,
    required this.number,
    required this.onTap,
    this.color,
    this.fontSize = 30});

  @override
  Widget build(BuildContext context) {
    return IconButton(
        iconSize: 80,
        onPressed: onTap,
        icon: Container(
            height: 40,
            width: 40,
            alignment: Alignment.center,
            child: Text(
              number,
              style: TextStyle(
                  fontSize: fontSize,
                  fontWeight: FontWeight.w600,
                  color: color),
            )));
  }
}
