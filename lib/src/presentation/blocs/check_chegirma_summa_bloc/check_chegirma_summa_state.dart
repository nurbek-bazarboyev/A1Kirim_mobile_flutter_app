part of 'check_chegirma_summa_bloc.dart';

@immutable
sealed class CheckChegirmaSummaState {}

final class CheckChegirmaSummaInitial extends CheckChegirmaSummaState {}

final class ErrorState extends CheckChegirmaSummaState {
  final String error;
  final String summa;
  ErrorState({
    required this.error,
    required this.summa
  });
}

final class UpdateDataState extends CheckChegirmaSummaState {
  final String summa;
  UpdateDataState({required this.summa});
}
