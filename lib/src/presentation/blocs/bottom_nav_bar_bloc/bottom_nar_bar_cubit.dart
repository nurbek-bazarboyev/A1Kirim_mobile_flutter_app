import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'bottom_nar_bar_state.dart';

class BottomNarBarCubit extends Cubit<int> {
  BottomNarBarCubit() : super(0);
  void changeTypeTo(int index){
    emit(index);
  }
}
