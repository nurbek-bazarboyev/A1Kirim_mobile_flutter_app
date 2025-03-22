import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'pdf_view_event.dart';
part 'pdf_view_state.dart';

class PdfViewBloc extends Bloc<PdfViewEvent, PdfViewState> {
  PdfViewBloc() : super(PdfViewInitial()) {
    on<PdfLoadingEvent>((event, emit) {
      emit(PdfLoading());
    });

    on<ItemLoadingEvent>((event, emit) {
      emit(ItemLoading());
    });

    on<SuccessEvent>((event, emit) {
      emit(SuccessState());
    });

    on<ErrorEvent>((event, emit) {
      if(event.statusCode == 200){
        emit(ErrorState(error: "Mahsulot qo'shilmagan", errorMessage: "Oldin nakladnoyga mahsulot qo'shing"));
      }else{
        emit(ErrorState(error: "Server bilan xatolik sodir bo'ldi", errorMessage: "Iltimos boshqattan kirib ko'ring"));
      }

    });

  }
}
