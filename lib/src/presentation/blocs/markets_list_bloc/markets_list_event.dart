part of 'markets_list_bloc.dart';

@immutable
sealed class MarketsListEvent {}

final class UpdateMarketsListEvent extends MarketsListEvent{
  final String query;
  UpdateMarketsListEvent({
    required this.query
});
}

final class SetInitialMarketsListEvent extends MarketsListEvent{}
