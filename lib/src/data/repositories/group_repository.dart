import 'package:a1_kirim_mobile/src/data/data_sources/api_service.dart';
import 'package:a1_kirim_mobile/src/domain/models/group.dart';

class GroupRepository{
  final ApiService apiService;
  GroupRepository(this.apiService);

  Future<List<Group>> getGroups()async{
    try{
      print("in groupRepository we are getting groups list... ");
      var myGroup = await apiService.fetchGroups();
      print("in groupRepository myGroup: ${myGroup}");
      return myGroup;
    }catch(e){
      print("in groupRepository failed to load groups exception: ${e.toString()}");
      return [];
    }
  }

  Future<Group?> createGroups(Group group)async{
    try{
      print("in groupRepository createGroup starting... ");
      var myGroup = await apiService.addGroup(group);
      print("in groupRepository myNewGroup: ${myGroup}");
      return myGroup;
    }catch(e){
      print("in groupRepository failed to add new group exception: ${e.toString()}");
      return null;
    }
  }

  Future<Group> editGroup(Group group)async{
    try{
      print("in groupRepository editing group... ");
      var editedGroup = await apiService.editGroup(group);
      print("in groupRepository edited group: ${editedGroup}");
      return editedGroup;
    }catch(e){
      print("in groupRepository failed to edit group:${e.toString()}");
     throw "${e.toString()}";
    }
  }
}