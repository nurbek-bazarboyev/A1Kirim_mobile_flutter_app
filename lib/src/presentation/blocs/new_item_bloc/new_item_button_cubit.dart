import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:meta/meta.dart';

part 'new_item_button_state.dart';

class NewItemButtonCubit extends Cubit<int> {
  NewItemButtonCubit() : super(0);
  updateButtonState(List<TextEditingController> controllers){
    List<bool> hasText = List<bool>.filled(controllers.length,false,growable: true);
    for(int i =0; i<controllers.length; i++){
      controllers[i].addListener((){
        if(controllers[i].text.isNotEmpty){
          print('new item button bloc');
          print("controllers[$i].text = ${controllers[i].text}");
          hasText[i] = true;
          if(hasText.contains(false)){
            emit(0);
          }else{
            emit(1);
          }
          print(hasText);
        }else{
          print('new item button bloc');
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
  changeToUntappable(){
    print("new item button cubit    change button state to unTappable ...");
    emit(0);
  }
  changeTotappable(){
    print("new item button cubit    change button state to Tappable ...");
    emit(1);
  }
}
