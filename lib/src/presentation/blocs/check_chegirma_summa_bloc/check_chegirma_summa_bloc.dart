import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'check_chegirma_summa_event.dart';
part 'check_chegirma_summa_state.dart';

class CheckChegirmaSummaBloc extends Bloc<CheckChegirmaSummaEvent, CheckChegirmaSummaState> {
  CheckChegirmaSummaBloc() : super(UpdateDataState(summa: "0.0")) {
    String oldChegirma = '0.0';
    on<ChangeChegirmaSummaEvent>((event, emit){
      final double chegirma = double.parse(event.chegirmaSumma);
      final double jami = double.parse(event.jamiSumma);
      if(chegirma>jami){
        emit(ErrorState(error: "Jami summadan oshib ketti",summa: oldChegirma));
      }else{
        oldChegirma = event.chegirmaSumma;
        emit(UpdateDataState(summa: event.chegirmaSumma));
      }


    });
  }
}
