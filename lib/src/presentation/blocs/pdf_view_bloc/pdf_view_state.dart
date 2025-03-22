part of 'pdf_view_bloc.dart';

@immutable
sealed class PdfViewState {}

final class PdfViewInitial extends PdfViewState {}
final class PdfLoading extends PdfViewState {}
final class ItemLoading extends PdfViewState {}

final class ErrorState extends PdfViewState {
  final String error;
  final String errorMessage;
  ErrorState({required this.error,required this.errorMessage});
}

final class SuccessState extends PdfViewState {}

