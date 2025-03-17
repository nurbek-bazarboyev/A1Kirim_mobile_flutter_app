part of 'ochiq_nak_dialog_bloc_cubit.dart';

@immutable
sealed class OchiqNakDialogBlocState {}

final class OchiqNakDialogBlocInitial extends OchiqNakDialogBlocState {}
final class LoadingState extends OchiqNakDialogBlocState{}

final class OchiqNakLadnoyDataState extends OchiqNakDialogBlocState{
  final List<TestModel> nakladnoylar;
  final String beginDate;
  final String endDate;
  OchiqNakLadnoyDataState({
    required this.nakladnoylar,
    required this.beginDate,
    required this.endDate,
  });
}

final class ErrorState extends OchiqNakDialogBlocState{
  final String errorMessage;
  final String error;
  ErrorState({
    required this.errorMessage,
    required this.error,
});
}

final class OchiqNakladnoyDialogErrorState extends OchiqNakDialogBlocState{
  final String error;
  OchiqNakladnoyDialogErrorState({required this.error});
}