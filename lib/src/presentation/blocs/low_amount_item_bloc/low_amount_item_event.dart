part of 'low_amount_item_bloc.dart';

@immutable
sealed class LowAmountItemEvent {}
final class UpdateLowItemsEvent extends LowAmountItemEvent{
  final List<dynamic> newLowItems;
  UpdateLowItemsEvent({required this.newLowItems});

}