part of 'low_amount_item_bloc.dart';

@immutable
sealed class LowAmountItemState {}

final class LowAmountItemInitial extends LowAmountItemState {}

final class UpdatedDataState extends LowAmountItemState {
  final List<dynamic> lowItems;
  UpdatedDataState({required this.lowItems});
}

final class yourstate extends LowAmountItemState {}