part of 'pdf_view_bloc.dart';

@immutable
sealed class PdfViewEvent {}
final class PdfLoadingEvent extends PdfViewEvent{}
final class ItemLoadingEvent extends PdfViewEvent{}
final class ErrorEvent extends PdfViewEvent{
  final int statusCode;
  ErrorEvent({required this.statusCode});
}
final class SuccessEvent extends PdfViewEvent{}