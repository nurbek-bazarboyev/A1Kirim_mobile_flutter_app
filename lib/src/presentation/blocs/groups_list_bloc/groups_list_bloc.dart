import 'package:a1_kirim_mobile/src/data/data_sources/api_service.dart';
import 'package:a1_kirim_mobile/src/data/repositories/group_repository.dart';
import 'package:a1_kirim_mobile/src/data/repositories/unit_type_repository.dart';
import 'package:a1_kirim_mobile/src/domain/models/group.dart';
import 'package:a1_kirim_mobile/src/presentation/views/home_views/markets_view.dart';
import 'package:bloc/bloc.dart';
import 'package:http/http.dart';
import 'package:meta/meta.dart';

part 'groups_list_event.dart';
part 'groups_list_state.dart';

class GroupsListBloc extends Bloc<GroupsListEvent, GroupsListState> {
  GroupsListBloc() : super(GroupsListInitial()) {

    on<UpdateGroupsListEvent>((event, emit) async{
      if(event.query == ''){
        print("in bloc for guruh: query is empty");
        if(groups.length == 0){
          emit(GroupsListEmpty(message: "Guruh mavjud emas"));
        }else{
          emit(UpdatedGroupsList(groupsList: groups));
        }

      }
      else{
        print("in bloc for guruh: query is ${event.query}");
        LoadingGroupsListEvent;
        print("guruh qidirish boshlandi in bloc...");

        List<Group> groupsList = await groups.where((element) {
          return element.groupName.toLowerCase().contains(event.query);
        }).toList();
        print("guruh malumoti topildi in bloc...");
        if(groups.length == 0){
          emit(GroupsListEmpty(message: "Guruh mavjud emas"));
        }else{
          emit(UpdatedGroupsList(groupsList: groups));
        }
        emit(UpdatedGroupsList(groupsList: groupsList));
      }

    });

    on<JustUpdateEvent> ((event, emit){
      emit(UpdatedGroupsList(groupsList: groups));
    });
    on<LoadingGroupsListEvent>((event, emit) async{
      print("in groups list loading in bloc");
      emit(GroupsListLoading());
    });

    on<SetInitialGroupsListEvent>((event, emit)async{
      print("in groups list bloc1");
      //LoadingGroupsListEvent;
      groups = await GroupRepository(ApiService(Client())).getGroups();
      if(groups.length == 0){
        emit(GroupsListEmpty(message: "Guruh mavjud emas"));
        print("in groups list bloc1 after emit update grouops list");
      }
      else{
        emit(UpdatedGroupsList(groupsList: groups));
      }
      print("in markets view page  get unit types...");
      unitTypes = await UnitTypesRepository(ApiService(Client())).getUnitTypes();
      print("in markets view  unit types: $unitTypes");
    });
  }
}
