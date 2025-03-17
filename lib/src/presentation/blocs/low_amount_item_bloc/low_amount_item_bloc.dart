import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'low_amount_item_event.dart';
part 'low_amount_item_state.dart';

class LowAmountItemBloc extends Bloc<LowAmountItemEvent, LowAmountItemState> {
  LowAmountItemBloc() : super(LowAmountItemInitial()) {
    on<UpdateLowItemsEvent>((event, emit) {
      // TODO: implement event handler
      emit(UpdatedDataState(lowItems: ['Tez orada...']));
    });
  }
}
