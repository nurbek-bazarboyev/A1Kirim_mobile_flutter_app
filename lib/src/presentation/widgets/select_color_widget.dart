import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

class SelectColorWidget extends StatefulWidget {
  List<dynamic>? pickedColor;
  final void Function(List<dynamic>? color) onColorChange;
  SelectColorWidget({super.key,required this.pickedColor, required this.onColorChange});

  @override
  State<SelectColorWidget> createState() => _SelectColorWidgetState();
}

class _SelectColorWidgetState extends State<SelectColorWidget> {
  int? selectedColorIndex ;
  Color? currentColor = null;
  Color pickerColor = Color(0xff443a49);
  void changeColor(Color color) {
    setState(() {
      pickerColor = color;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        GestureDetector(
          onTap: (){
            setState(() {
              selectedColorIndex = 0;
              currentColor = null;
              widget.pickedColor = [255, 255, 255, 1];
              widget.onColorChange(widget.pickedColor!);
              print(widget.pickedColor);
            });
          },
          child: Container(
            height: 35,
            width: 35,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(6),
                color: Color.fromRGBO(255, 255, 255,1),
                border: Border.all(color: Colors.black,width: .3)
            ),child: selectedColorIndex == 0 ? Icon(CupertinoIcons.checkmark) : null,
          ),
        ),
        SizedBox(width: 5,),
        GestureDetector(
          onTap: (){
            setState(() {
              selectedColorIndex = 1;
              currentColor = null;
              widget.pickedColor = [0, 0, 0, 1];
              widget.onColorChange(widget.pickedColor!);
              print(widget.pickedColor);
            });
          },
          child: Container(
            height: 35,
            width: 35,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(6),
                color: Colors.black,
                border: Border.all(color: Colors.black,width: .3)
            ),child: selectedColorIndex == 1 ? Icon(CupertinoIcons.checkmark,color: Colors.white,) : null,
          ),
        ),
        SizedBox(width: 5,),
        GestureDetector(
          onTap: (){
            setState(() {
              selectedColorIndex = 2;
              currentColor = null;
              widget.pickedColor = [255, 0, 0, 1.0];
              widget.onColorChange(widget.pickedColor!);
              print(widget.pickedColor);
            });
          },
          child: Container(
            height: 35,
            width: 35,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(6),
                color: Colors.red,
                border: Border.all(color: Colors.black,width: .3)
            ),child: selectedColorIndex == 2 ? Icon(CupertinoIcons.checkmark,color: Colors.white,) : null,
          ),
        ),
        SizedBox(width: 5,),
        GestureDetector(
          onTap: (){
            setState(() {
              selectedColorIndex = 3;
              currentColor = null;
              widget.pickedColor = [255, 255, 0, 1.0];
              widget.onColorChange(widget.pickedColor!);
              print(widget.pickedColor);
            });
          },
          child: Container(
            height: 35,
            width: 35,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(6),
                color: Colors.yellow,
                border: Border.all(color: Colors.black,width: .3)
            ),child: selectedColorIndex == 3 ? Icon(CupertinoIcons.checkmark) : null,
          ),
        ),
        SizedBox(width: 5,),
        GestureDetector(
          onTap: (){
            setState(() {
              selectedColorIndex = 4;
              currentColor = null;
              widget.pickedColor = [0, 255, 0, 1.0];
              widget.onColorChange(widget.pickedColor!);
              print(widget.pickedColor);
            });
          },
          child: Container(
            height: 35,
            width: 35,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(6),
                color: Colors.green,
                border: Border.all(color: Colors.black,width: .3)
            ),child: selectedColorIndex == 4 ? Icon(CupertinoIcons.checkmark) : null,
          ),
        ),
        SizedBox(width: 5,),
        GestureDetector(
          onTap: (){
            currentColor = null;
            showDialog(
                context: context,
                builder: (context){
                  return AlertDialog(
                    title: const Text('Pick a color!'),
                    content: SingleChildScrollView(
                      child: ColorPicker(
                        pickerColor: pickerColor,
                        onColorChanged: changeColor,
                      ),
                      // Use Material color picker:
                      //
                      // child: MaterialPicker(
                      //   pickerColor: pickerColor,
                      //   onColorChanged: changeColor,
                      //   //showLabel: true, // only on portrait mode
                      // ),
                      //
                      // Use Block color picker:
                      //
                      // child: BlockPicker(
                      //   pickerColor: currentColor,
                      //   onColorChanged: changeColor,
                      // ),

                      // child: MultipleChoiceBlockPicker(
                      //   pickerColors: currentColors,
                      //   onColorsChanged: changeColors,
                      // ),
                    ),
                    actions: <Widget>[
                      ElevatedButton(
                        child: const Text('Got it'),
                        onPressed: () {
                          setState(() {
                            currentColor = pickerColor;
                            widget.pickedColor = [pickerColor.red,pickerColor.green,pickerColor.blue,pickerColor.opacity];
                            print(widget.pickedColor);
                            widget.onColorChange(widget.pickedColor!);
                            print("got it: ${pickerColor.red} , ${pickerColor.green}, ${pickerColor.blue} , ${pickerColor.opacity}");
                            selectedColorIndex = 5;
                          } );
                          Navigator.of(context).pop();
                        },
                      ),
                    ],
                  );
                }
            );
            setState(() {
              if(currentColor != null){selectedColorIndex = 5;}
              else{ selectedColorIndex = null;}

            });
          },
          child: Container(
            height: 35,
            width: 100,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(6),
                gradient: currentColor==null?LinearGradient(colors: [
                  Colors.red,
                  Colors.yellow,
                  Colors.green,
                  Colors.grey,
                  Colors.blue,
                  Colors.purpleAccent,
                  Colors.deepPurple,
                  Colors.black
                ]):null,
                color: currentColor,
                border: Border.all(color: Colors.black,width: .3)
            ),
            child: selectedColorIndex == 5 ? Icon(CupertinoIcons.checkmark) : null,
          ),
        ),
      ],
    );
  }
}
