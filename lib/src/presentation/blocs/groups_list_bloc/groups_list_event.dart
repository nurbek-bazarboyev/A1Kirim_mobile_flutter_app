part of 'groups_list_bloc.dart';

@immutable
sealed class GroupsListEvent {}

final class SetInitialGroupsListEvent extends GroupsListEvent{}

final class LoadingGroupsListEvent extends GroupsListEvent{}

final class JustUpdateEvent extends GroupsListEvent{}

final class UpdateGroupsListEvent extends GroupsListEvent{
  final String query;
  UpdateGroupsListEvent({
    required this.query
  });
}