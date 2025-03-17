import 'package:a1_kirim_mobile/main.dart';
import 'package:a1_kirim_mobile/src/data/data_sources/api_service.dart';
import 'package:a1_kirim_mobile/src/domain/models/user.dart';

class LoginRepository{
  final ApiService apiService;
  LoginRepository(this.apiService);

  Future<String> login(String parol)async{
    String? result;
    print("in login repository. parol: ${parol}");
    try{
      final User user = await apiService.login(parol);
      sharedPreferences?.setInt("userId", int.parse(user.userId));
      sharedPreferences?.setString("language", user.language);
      sharedPreferences?.setString('phoneNumber', user.phoneNumber);
      sharedPreferences?.setString('name', user.name);
      print("in login repository userid: ${user.userId}");
      print("in login repository lang: ${user.language}");
      result = "200";
      return result;
    }catch(e){
      print("in login repository failed status: ${e.toString()}   type: ${e.runtimeType}");
      result = e.toString();
      return result;
    }
  }

}