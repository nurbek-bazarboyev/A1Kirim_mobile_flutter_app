import 'dart:async';
import 'dart:io';
import 'package:a1_kirim_mobile/src/presentation/views/home_views/add_exist_item_view.dart';
import 'package:a1_kirim_mobile/src/utils/constants/double_constants.dart';
import 'package:a1_kirim_mobile/src/utils/constants/style_constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../utils/constants/color_constants.dart';

class ShowAndTakeImageWidget extends StatefulWidget {
  void Function(File? image) onImageChange;
  ShowAndTakeImageWidget({
    super.key,
    required this.onImageChange,
    required this.size,
    this.widget,
  });

  final Size size;
  final AddExistItemView? widget;

  @override
  State<ShowAndTakeImageWidget> createState() => _ShowAndTakeImageWidgetState();
}

class _ShowAndTakeImageWidgetState extends State<ShowAndTakeImageWidget> {
  PageController pageController = PageController();
  StreamController<int> pageStream = StreamController<int>();
  XFile? image;
  final ImagePicker picker = ImagePicker();

  Future<XFile?> takePhoto()async{
    image = await picker.pickImage(source: ImageSource.camera);
    return image;
    //photo = await picker.pickImage(source: ImageSource.camera);
  }


  @override
  void initState() {
    // TODO: implement initState
    pageStream.sink.add(0);
    pageController.addListener((){
      pageStream.sink.add(pageController.page!.toInt());
    });
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(14),
      child: Stack(
        children: [
          Container(
            height: widget.size.width * .6,
            //width: size.width-40,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(
                    DoubleConstants.primaryBorderRadius),
                color: Colors.grey
            ),
            child: image != null ? Container(
                height: widget.size.width * .6,
                width: widget.size.width - 40,
                decoration: BoxDecoration(
                  // borderRadius: BorderRadius.circular(
                  //     DoubleConstants.primaryBorderRadius),
                    color: Colors.grey.shade700//ColorConstants.scaffoldBackgroundColor
                ),
                child: Image.file(File(image!.path),fit: BoxFit.cover,)) :
            (clothingImageUrls.isNotEmpty ? PageView.builder(
                controller: pageController,
                itemCount: clothingImageUrls.length,
                itemBuilder: (context, index) {
                  return Container(
                      height: widget.size.width * .6,
                      width: widget.size.width - 40,
                      decoration: BoxDecoration(
                        // borderRadius: BorderRadius.circular(
                        //     DoubleConstants.primaryBorderRadius),
                          color: Colors.grey.shade700//ColorConstants.scaffoldBackgroundColor
                      ), child:
                  Image.network(clothingImageUrls[index],fit: BoxFit.cover,)
                    // widget.widget.item.image != null ? Image.network(
                    //     widget.widget.item.image![index]) : null

                  );
                }):Container(
                height: widget.size.width * .6,
                width: widget.size.width - 40,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(
                      DoubleConstants.primaryBorderRadius),
                    color: Colors.grey.shade300,//ColorConstants.scaffoldBackgroundColor,
                  border: Border.all(color: Colors.grey)
                ), child:
            Center(
              child: Text("Rasm mavjud emas",style: TextStyleConstants.takePictureTextStyle,),
            )
            )),
          ),

          Positioned(
              bottom: 5,
              right: 15,
              child: Row(
                children: [
                  IconButton(onPressed: ()async{
                    print("taking image from camera... ... ...");
                    image = await takePhoto();
                    widget.onImageChange(File(image!.path));
                    print(".......................................");
                    print("image path: ${image?.path??"no path"}");
                    setState(() {
                      // call back should be called here to update parent widget (mahsulot qoshish oynasini)
                    });
                    print("image picker");
                  }, icon: Icon(CupertinoIcons.camera,color: Color(0xFF140CFF),size: 35,)),
                  if(image == null && clothingImageUrls.isNotEmpty)SizedBox(width: 10,),
                  StreamBuilder<int>(
                      stream: pageStream.stream,
                      builder: (context, snapshot) {
                        print(image == null);
                        return image == null && clothingImageUrls.isNotEmpty ? Text("${snapshot.data!+1}/${clothingImageUrls.length}",style: TextStyleConstants.pictureNumberTextStyle,):
                        SizedBox();
                      }
                  )
                ],
              )),
          if(image!=null)
            Positioned(
                top: 0,
                right: 0,
                child: IconButton(onPressed: (){
                  setState(() {
                    print("canceling image...");
                    image = null;
                    print("image path: ${image?.path??"no path"}");
                    if(image != null){
                      widget.onImageChange(File(image!.path));
                    }else{
                      widget.onImageChange(null);
                    }
                  });
                }, icon: Icon(CupertinoIcons.xmark))),

        ],
      ),
    );
  }
}