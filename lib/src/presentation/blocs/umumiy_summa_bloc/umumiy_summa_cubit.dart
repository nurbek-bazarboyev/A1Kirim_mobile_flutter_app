import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'umumiy_summa_state.dart';

class UmumiySummaCubit extends Cubit<double> {
  UmumiySummaCubit() : super(0.0);
  changeUmumiySumma(double summa){
    print("umumiy summa bloc: $summa");
    emit(summa);
  }

}
