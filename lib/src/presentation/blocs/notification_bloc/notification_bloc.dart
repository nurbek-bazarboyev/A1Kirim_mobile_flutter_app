import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'notification_event.dart';
part 'notification_state.dart';

class NotificationBloc extends Bloc<NotificationEvent, NotificationState> {
  NotificationBloc() : super(NotificationInitial()) {
    on<UpdateNotificationDataEvent>((event, emit) {
      // TODO: implement event handler
      emit(NotificationDataState(newNotifsList: ['Tez orada...']));
    });
  }
}
