class NumberHelper{
  // bu helper class raqamlar ustida nima amalga oshirilsa shularni oz ichiga oladi
  static String printSumma({required double summaAsDouble}){
    final son = removeLastZero(doubleSon: summaAsDouble);
    return separateSumma(son);
  }
  static String removeLastZero({required  double doubleSon}){
    String NumWithoutZero='';
    String toDot='';
    String fromDot='';
    String sonString = doubleSon.toString();
    print(sonString);
    bool nuqta = false;
    for(int i = 0; i<doubleSon.toString().length; i++){
      if(sonString[i]=='.'){
        nuqta = true;
        continue;
      }else{
        // shunchaki tashlab ketish kerak
      }

      if(nuqta){
        fromDot += sonString[i];
      }else{
        toDot += sonString[i];
      }


    }
    if(int.parse(fromDot)==0) {
      return toDot;
    }else{
      return sonString;
    }

  }

  static String separateSumma(String stringOfDoubleSon){
    if(stringOfDoubleSon.contains('.')){
      String fromDot=stringOfDoubleSon.split('.')[1];
      String toDot=stringOfDoubleSon.split('.')[0];
      print("toDot: ${toDot}");
      print("fromDot: ${fromDot}");
      String newSonToDot = '';
      String newSonFromDot = '';
      int toCount =0;
      int fromCount =0;
      print("stringOfDoubleSon: ${stringOfDoubleSon}");

      //sort todot number
      for(int i = toDot.length-1; i>=0; i--){
        toCount++;
        if(toCount%3 == 0 && i!=0 && toCount!=0){
          newSonToDot = toDot[i]+newSonToDot;
          newSonToDot = ' '+newSonToDot;
        }else{
          newSonToDot = toDot[i]+newSonToDot;
        }

      }

      return newSonToDot+'.'+fromDot;
    }
    else{
      String newSon = '';
      int count =0;
      print("stringOfDoubleSon: ${stringOfDoubleSon}");
      for(int i = stringOfDoubleSon.length-1; i>=0; i--){
        count++;
        if(count%3 == 0 && i!=0 && count!=0){
          newSon = stringOfDoubleSon[i]+newSon;
          newSon = ' '+newSon;
        }else{
          newSon = stringOfDoubleSon[i]+newSon;
        }

      }
      return newSon;

    }
  }

}