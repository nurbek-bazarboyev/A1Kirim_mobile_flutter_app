import 'package:a1_kirim_mobile/src/core/utils/date_helper.dart';
import 'package:a1_kirim_mobile/src/domain/models/test_model.dart';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'nak_for_markets_state.dart';

class NakForMarketsCubit extends Cubit<NakForMarketsState> {
  NakForMarketsCubit() : super(LoadingState());

  changeToLoading(){
    emit(LoadingState());
  }
  updateList({required List<MarketWithNakladnoy>? marWithNakList,required String beginDate,required String endDate}){
    if(DateHelper.compareDates(beginDate: beginDate, endDate: endDate)==1){
      if(marWithNakList?.length != 0){
        print("bloc ichida length: ${marWithNakList?.length}");
        emit(UpdateMarkWithNakListState(marWithNakList: marWithNakList!));
      }else{
        print("bloc ichida length: 0");
        final String data;
        if(beginDate != endDate){
          data = "${beginDate} va ${endDate} oraliqda nakladnoy mavjud emas";
        }else{
          data = "${beginDate} sanada nakladnoy mavjud emas";
        }

        emit(EmptyListState(data: data));
      }
    }else{
      emit(ErrorDateState(error: "Sana tanlashda xatolik!", errorMessage: "'dan' yani chap tarafdagi sana  'gacha' yani o'ng tarafdagi sandan keyingi sana bo'lishi mumkin emas"));
    }


  }

}
