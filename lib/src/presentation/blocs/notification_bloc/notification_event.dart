part of 'notification_bloc.dart';

@immutable
sealed class NotificationEvent {}

final class UpdateNotificationDataEvent extends NotificationEvent{
  final List<dynamic> notifs; // listning turi keyin ozgarishi mumkin
  UpdateNotificationDataEvent({required this.notifs});
}