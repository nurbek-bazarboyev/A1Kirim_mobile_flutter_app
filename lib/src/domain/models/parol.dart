import 'package:a1_kirim_mobile/src/utils/constants/server_data.dart';

class Parol{
  // you can add smth here

  static String? confirmPassword({required String parol}){
    if(ServerData.userParol == parol || ServerData.adminParol == parol){
      return null;
    }else{
      return "parol xato!";
    }
  }
}