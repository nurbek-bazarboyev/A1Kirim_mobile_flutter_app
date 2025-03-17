import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:meta/meta.dart';

part 'kirim_button_bloc_state.dart';

class KirimButtonBlocCubit extends Cubit<int> {
  KirimButtonBlocCubit() : super(0);
  void changeButtonColor(TextEditingController soni,TextEditingController summa){
    soni.addListener((){
      print("blocda mahsulot soni ozgardi  soni: ${soni.text}  summa: ${summa.text}");
      if(soni.text.isNotEmpty && summa.text.isNotEmpty){
        emit(1);
      }else{
        emit(0);
      }
    });
    summa.addListener((){
      print("blocda mahsulot summa ozgardi  summa: ${summa.text}  soni: ${soni.text}");
      if(soni.text.isNotEmpty && summa.text.isNotEmpty){
        emit(1);
      }else{
        emit(0);
      }
    });
   // emit(index);
  }
  changeToUnTappable(){
    emit(0);
  }
}
