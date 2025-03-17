import 'dart:io';

import 'package:a1_kirim_mobile/src/data/data_sources/api_service.dart';

class ImageRepository{
  final ApiService apiService;
  ImageRepository(this.apiService);

  Future<String> uploadImage({required File image,required int goodsGroupId,required int goodsId})async{
    print("in ImageRepository uploadImage starting...");
    try{
      print("in ImageRepository uploadImage try___");
      final result = await apiService.uploadPicture(
          image: image,
          goodsGroupId: goodsGroupId,
          goodsId: goodsId
      );
      if(result){
        print('in ImageRepository uploadImage status: successful');
        return "Rasm muvaffaqiyatli yuklandi";
      }else{
        print('in ImageRepository uploadImage status: image not uploaded');
        return "Iltimos yana urinib koring";
      }
    }catch(e){
      print("in ImageRepository uploadImage exception");
      return "Iltimos yana urinib koring nomalum xatolik yuz berdi!!!";
    }
  }

  Future<String> fetchImage(String imageUrl)async{
    print("in ImageRepository  fetch Image starting...");
    try{
      print("in ImageRepository fetch Image try___");
      final result = await apiService.fetchImage(imageUrl);
      if(result){
        print('in ImageRepository fetchImage status: successful');
        return "Rasm muvaffaqiyatli qabul qilib olindi";
      }else{
        print('in ImageRepository fetch Image status: image not fetched');
        return "Iltimos yana urinib koring";
      }
    }catch(e){
      print("in ImageRepository fetchImage exception");
      return "Iltimos yana urinib koring nomalum xatolik yuz berdi!!!";
    }
  }

}