part of 'check_chegirma_summa_bloc.dart';

@immutable
sealed class CheckChegirmaSummaEvent {}
final class ChangeChegirmaSummaEvent extends CheckChegirmaSummaEvent{
  final String chegirmaSumma;
  final String jamiSumma;
  ChangeChegirmaSummaEvent({
    required this.chegirmaSumma,
    required this.jamiSumma
});
}