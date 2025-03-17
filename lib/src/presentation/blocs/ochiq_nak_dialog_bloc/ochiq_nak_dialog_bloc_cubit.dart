import 'package:a1_kirim_mobile/src/core/utils/date_helper.dart';
import 'package:a1_kirim_mobile/src/domain/models/test_model.dart';
import 'package:a1_kirim_mobile/src/presentation/utils/ui_nakladnoy_helper.dart';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'ochiq_nak_dialog_bloc_state.dart';

class OchiqNakDialogBlocCubit extends Cubit<OchiqNakDialogBlocState> {
  OchiqNakDialogBlocCubit() : super(OchiqNakDialogBlocInitial());
   Future updateDateAndNakList({required int rekvizitId, required String beginDate, required String endDate})async{

     if(DateHelper.compareDates(beginDate: beginDate, endDate: endDate) == 1){
       List<TestModel> nakladnoylar = [];
       try{
         nakladnoylar =   await UiNakladnoyHelper.getOchiqNakladnoylar(rekvizitId: rekvizitId, beginDate: beginDate, endDate: endDate);
         emit(OchiqNakLadnoyDataState(nakladnoylar: nakladnoylar, beginDate: beginDate, endDate: endDate));
       }
       catch(e){
         emit(OchiqNakladnoyDialogErrorState(error: e.toString()));
       }
     }
     else{
       emit(ErrorState(error:"Sana tanlashda xatolik!",errorMessage: "'Begin date'  'End date' dan oldingi sana bo'lishi kerak "));
     }

  }

  justUpdateUi({required List<TestModel> initialNaklardoylar, required String beginDate, required String endDate}){
     emit(OchiqNakLadnoyDataState(nakladnoylar: initialNaklardoylar, beginDate: beginDate, endDate: endDate));
  }

}
