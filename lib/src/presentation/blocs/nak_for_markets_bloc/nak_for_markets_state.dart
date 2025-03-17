part of 'nak_for_markets_cubit.dart';

@immutable
sealed class NakForMarketsState {}

final class NakForMarketsInitial extends NakForMarketsState {}

final class LoadingState extends NakForMarketsState{}

final class EmptyListState extends NakForMarketsState{
  final String data;
  EmptyListState({required this.data});
}
final class ErrorDateState extends NakForMarketsState{
  final String error;
  final String errorMessage;
  ErrorDateState({
    required this.error,
    required this.errorMessage
});
}

final class UpdateMarkWithNakListState extends NakForMarketsState{
  List<MarketWithNakladnoy> marWithNakList;
  UpdateMarkWithNakListState({required this.marWithNakList});
}