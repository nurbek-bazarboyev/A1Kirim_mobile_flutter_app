import 'package:a1_kirim_mobile/src/core/utils/number_helper.dart';
import 'package:a1_kirim_mobile/src/data/repositories/local_database_repositories/kirim_repository.dart';
import 'package:a1_kirim_mobile/src/domain/models/kirim.dart';
import 'package:a1_kirim_mobile/src/presentation/views/home_views/update_kirim_view.dart';
import 'package:a1_kirim_mobile/src/presentation/widgets/my_button.dart';
import 'package:a1_kirim_mobile/src/utils/constants/color_constants.dart';
import 'package:a1_kirim_mobile/src/utils/constants/style_constants.dart' show TextStyleConstants;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
class KirimOfTodayTileTrailingWidget extends StatefulWidget {
  final void Function(KirimModel) onKirimChange;
  final KirimModel kirim;
  final void Function(bool)? onDelete;
  const KirimOfTodayTileTrailingWidget({super.key, required this.kirim, required this.onKirimChange, this.onDelete});

  @override
  State<KirimOfTodayTileTrailingWidget> createState() => _KirimOfTodayTileTrailingWidgetState();
}

class _KirimOfTodayTileTrailingWidgetState extends State<KirimOfTodayTileTrailingWidget> {
  int initialValue = 0;
  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
        initialValue: initialValue,
        offset: Offset(0, 45),
        onSelected: (currentValue) {
          if(currentValue==1){
            showDialog(context: context, builder: (context){
              return Dialog(
                insetPadding: EdgeInsets.all(20),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                  children: [
                    Center(child: Text(widget.kirim.name,style: TextStyleConstants.listTileTitleStyle!.copyWith(fontSize: 20),textAlign: TextAlign.center,)),
                    SizedBox(height: 20,),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          Text("soni: ",style: TextStyle(fontSize: 16),),
                          Text("${NumberHelper.printSumma(summaAsDouble: widget.kirim.soni)} ${widget.kirim.unit}",style: TextStyleConstants.listTileTitleStyle,),
                        ],
                      ),
                    ),
                    SizedBox(height: 10,),
                    Divider(height: 1,),
                    SizedBox(height: 10,),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          Text("1 ${widget.kirim.unit} ning olingan narxi: ",style: TextStyle(fontSize: 16),),
                          Text("${NumberHelper.printSumma(summaAsDouble: widget.kirim.summa)} so'm",style: TextStyleConstants.listTileTitleStyle,),
                        ],
                      ),
                    ),
                    SizedBox(height: 10,),
                    Divider(height: 1,),
                    SizedBox(height: 10,),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          Text("jami Summa: ",style: TextStyle(fontSize: 16),),
                          Text("${NumberHelper.printSumma(summaAsDouble: widget.kirim.summa * widget.kirim.soni)} so'm",style: TextStyleConstants.listTileTitleStyle,),
                        ],
                      ),
                    ),
                    SizedBox(height: 10,),
                    Divider(height: 1,),
                    SizedBox(height: 10,),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          Text("tashkilot: ",style: TextStyle(fontSize: 16),),
                          Text("${widget.kirim.orgName}",style: TextStyleConstants.listTileTitleStyle,),
                        ],
                      ),
                    ),
                    SizedBox(height: 10,),
                    Divider(height: 1,),
                    SizedBox(height: 10,),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          Text("sana: ",style: TextStyle(fontSize: 16),),
                          Text("${widget.kirim.kelganSana}",style: TextStyleConstants.listTileTitleStyle,),
                        ],
                      ),
                    ),

                    SizedBox(height: 10,)
                  ],
                  ),
                ),
              );
            });
          }
          else if(currentValue == 2){
            SchedulerBinding.instance.addPostFrameCallback((_){
              Navigator.push(context, MaterialPageRoute(builder: (context){
                return UpdateKirimView(kirim: widget.kirim, onKirimChange: widget.onKirimChange,);
              }));
            });


          }
          else{
            showDialog(context: context, builder: (context){
              return Dialog(
                insetPadding: EdgeInsets.all(20),
                child: Padding(
                  padding: const EdgeInsets.only(left: 20,right: 20,top: 30,bottom: 20),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text("Bu kirimni o'chirmoqchimisiz?",style: TextStyleConstants.listTileTitleStyle!.copyWith(fontSize: 20),textAlign: TextAlign.center,),
                      SizedBox(height: 20,),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Expanded(child: MyButton(
                              onPressed: (){
                                Navigator.of(context).pop();
                              },
                              name: "Yo'q")),
                          SizedBox(width: 5,),
                          Expanded(child: MyButton(
                              onPressed: ()async{
                                widget.onDelete!(true);
                                print("in KirimOfTodayTileTrailingWidget button ichida siz delete qilish tugmasini bosdingiz...");
                                try{
                                  print("deleting kirim id = ${widget.kirim.kirimId}");
                                  await KirimRepository.deleteKirimFromSql(kirimId: widget.kirim.kirimId);
                                  if(true){
                                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Muvaffaqiyatli o'chirildi",style: TextStyleConstants.successTextStyle,),backgroundColor: ColorConstants.successColor,));
                                    //Navigator.of(context).pop();
                                  }else{
                                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Iltimos yana urinib ko'ring!",style: TextStyleConstants.errorTextStyle,),backgroundColor: ColorConstants.errorColor,));
                                  }
                                  Navigator.pop(context);
                                }catch(e){
                                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Iltimos yana urinib ko'ring! exception: ${e.toString()}")));
                                }

                              },
                              name: "Ha")),
                        ],
                      )
                    ],
                  ),
                )
              );
            });
          }

          setState(() {
            print(currentValue);
            initialValue = currentValue;
          });
        },
        itemBuilder: (context){
          return <PopupMenuEntry<int>>[
            PopupMenuItem(
                value: 1,
                child: Row(
              children: [
                Icon(CupertinoIcons.info),
                SizedBox(width: 10,),
                Text("batafsil",style: TextStyleConstants.successTextStyle!.copyWith(color: Colors.black)),
              ],
            )),
            PopupMenuItem(
                value: 2,
                child: Row(
              children: [
                Icon(Icons.edit,),
                SizedBox(width: 10,),
                Text("o'zgartirish",style: TextStyleConstants.errorTextStyle),
              ],
            )),
            PopupMenuItem(
              onTap: (){
                // todo delete kirim from server and local database
                // todo write your logic here
              },
                value: 3,
                child: Row(
              children: [
                Icon(CupertinoIcons.delete,color: Colors.red,),
                SizedBox(width: 10,),
                Text("o'chirish",style: TextStyleConstants.errorTextStyle!.copyWith(color: Colors.red),),
              ],
            ))
          ];
        });
  }
}


