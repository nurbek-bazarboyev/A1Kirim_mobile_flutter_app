part of 'groups_list_bloc.dart';

@immutable
sealed class GroupsListState {}

final class GroupsListInitial extends GroupsListState {}

final class GroupsListEmpty extends GroupsListState {
  final String message;
  GroupsListEmpty({required this.message});
}

final class GroupsListLoading extends GroupsListState{}

final class UpdatedGroupsList extends GroupsListState{
  final List<Group> groupsList;
  UpdatedGroupsList({
    required this.groupsList
  });
}
