import 'package:a1_kirim_mobile/src/presentation/blocs/notification_bloc/notification_bloc.dart';
import 'package:a1_kirim_mobile/src/utils/constants/style_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class NotificationView extends StatefulWidget {
  const NotificationView({super.key});

  @override
  State<NotificationView> createState() => _NotificationViewState();
}

class _NotificationViewState extends State<NotificationView> {
  @override
  void initState() {
    context.read<NotificationBloc>().add(UpdateNotificationDataEvent(notifs: ['bu list ham shunchaki namuna uchun ilova ishga tushgandan keyin serverdan kelgan malumotlar bu yerga berilib keyin bloc qismi ham logikasi moslashtirish kerak']));
    // TODO: implement initState
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NotificationBloc, NotificationState>(
      builder: (context, state) {
        if(state is NotificationInitial){
          return Center(child: CircularProgressIndicator(),);
        }else if(state is NotificationDataState){
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Center(child: Text(state.newNotifsList[0],style: TextStyleConstants.listTileTitleStyle,))
            ],
          );
        }else{
          return Text("Nomalum xatolik ro'y berdi.",style: TextStyleConstants.listTileTitleStyle,);
        }

      },
    );
  }
}
