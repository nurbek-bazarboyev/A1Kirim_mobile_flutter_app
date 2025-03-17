import 'package:a1_kirim_mobile/src/data/data_sources/api_service.dart';
import 'package:a1_kirim_mobile/src/data/repositories/group_repository.dart';
import 'package:a1_kirim_mobile/src/data/repositories/market_repository.dart';
import 'package:a1_kirim_mobile/src/domain/models/group.dart';
import 'package:a1_kirim_mobile/src/domain/models/market.dart';
import 'package:a1_kirim_mobile/src/presentation/views/home_views/markets_view.dart';
import 'package:bloc/bloc.dart';
import 'package:http/http.dart';
import 'package:meta/meta.dart';

part 'markets_list_event.dart';
part 'markets_list_state.dart';

class MarketsListBloc extends Bloc<MarketsListEvent, MarketsListState> {
  MarketsListBloc() : super(MarketsListInitial()) {
    on<UpdateMarketsListEvent>((event, emit) async{
      if(event.query == ''){
        print("in bloc: query is empty");
        emit(UpdatedMarketsList(marketsList: markets));
      }
      else{
        print("in bloc: query is ${event.query}");
        emit(MarketsListInitial());
        print("qidirish boshlandi in bloc...");
        List<Market> marketsList = await markets.where((element) {
          return element.orgName!.toLowerCase().contains(event.query);
        }).toList();
        print("malumot topildi in bloc...");
        emit(UpdatedMarketsList(marketsList: marketsList));
      }

    });
    on<SetInitialMarketsListEvent>((event, emit)async{
      emit(MarketsListLoading());
      markets = await MarketRepository(ApiService(Client())).getMarkets();
      emit(UpdatedMarketsList(marketsList: markets));
    });

  }
}
