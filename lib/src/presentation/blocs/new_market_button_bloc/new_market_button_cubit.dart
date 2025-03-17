import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:meta/meta.dart';

part 'new_market_button_state.dart';

class NewMarketButtonCubit extends Cubit<int> {
  NewMarketButtonCubit() : super(0);
  updateButton(List<TextEditingController> controllers){
    List<bool> hasText = List<bool>.filled(controllers.length,false,growable: true);
    for(int i =0; i<controllers.length; i++){
      controllers[i].addListener((){
        print('new item button bloc');
        if(controllers[i].text.isNotEmpty){
          print("controllers[$i].text = ${controllers[i].text}");
          hasText[i] = true;
          if(hasText.contains(false)){
            emit(0);
          }else{
            emit(1);
          }
          print(hasText);
        }else{
          print("controllers[$i].text = ${controllers[i].text}");
          hasText[i] = false;
          if(hasText.contains(false)){
            emit(0);
          }else{
            emit(1);
          }
          print(hasText);
        }
      });
    }
  }
  changeToUnTappable(){
    emit(0);
  }
  changeToTappable(){
    emit(1);
  }
}
