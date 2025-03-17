import 'package:a1_kirim_mobile/src/data/data_sources/api_service.dart';
import 'package:a1_kirim_mobile/src/domain/models/unit_type.dart';

class UnitTypesRepository{
  final ApiService apiService;
  UnitTypesRepository(this.apiService);

  Future<List<UnitType>> getUnitTypes()async{
    try{
      print('in UnitTypesRepository trying to get unit types...');
      var unitTypesList = await apiService.fetchUnitTypes();
      print("in UnitTypesRepository  unitTypesList: ${unitTypesList}");
      return unitTypesList;
    }catch(e){
      print("in UnitTypesRepository failed to load unit types   exception: ${e.toString()}");
      throw "${e.toString()}";
    }
  }

}