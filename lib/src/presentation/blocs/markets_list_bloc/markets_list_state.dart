part of 'markets_list_bloc.dart';

@immutable
sealed class MarketsListState {}

final class MarketsListInitial extends MarketsListState {}
final class MarketsListLoading extends MarketsListState {}
final class UpdatedMarketsList extends MarketsListState{
  final List<Market> marketsList;
  UpdatedMarketsList({
    required this.marketsList
});
}

