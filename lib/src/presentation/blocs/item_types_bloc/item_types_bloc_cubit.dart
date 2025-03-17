import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'item_types_bloc_state.dart';

class ItemTypesBlocCubit extends Cubit<String> {
  ItemTypesBlocCubit() : super("Tanlanmagan");

  void changeTypeTo(String type){
    print("bloc ichida unit type ozgaryapti!!!");
    emit(type);
  }
}
