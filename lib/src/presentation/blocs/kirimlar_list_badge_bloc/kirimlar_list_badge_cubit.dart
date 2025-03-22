import 'package:a1_kirim_mobile/main.dart';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'kirimlar_list_badge_state.dart';

class KirimlarListBadgeCubit extends Cubit<int> {
  KirimlarListBadgeCubit() : super(0);
  int count=0;
  addToKirimlarListCount({required int rekvisitId}){
    print("add kirim list count in bloc");
    emit(count+1);
    count += 1;
    print("add kirim list coun in bloc count:${count}");
    sharedPreferences?.setInt("badgeCount$rekvisitId", count);
  }

  setInitialCountFromSharedPref({required int unWatched,required int rekvisitId}){
    print("set initial count from shared pref in bloc");
    count = unWatched;
    sharedPreferences?.setInt("badgeCount$rekvisitId", count);
    print("set initial count from shared pref in bloc count:${count}");
    emit(count);
  }

  justUpdate({required int rekvisitId}){
    print("just updating in bloc");
    count = sharedPreferences?.getInt("badgeCount$rekvisitId")??0;
    print("just updating in bloc count:${count}");
    emit(count);
  }

  setCountToNull({required int rekvisitId}){
    print("just set to null in bloc");
    count = 0;
    sharedPreferences?.setInt("badgeCount$rekvisitId", count);
    print("just set to null in bloc count:${count}");
    emit(0);
  }
}
