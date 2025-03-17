import 'package:a1_kirim_mobile/src/utils/constants/style_constants.dart';
import 'package:flutter/material.dart';
class CheckBoxWidget extends StatefulWidget {
  final void Function(bool) onChange;
  const CheckBoxWidget({super.key, required this.onChange});

  @override
  State<CheckBoxWidget> createState() => _CheckBoxWidgetState();
}

class _CheckBoxWidgetState extends State<CheckBoxWidget> {
  bool isMarked = true;
  @override
  void initState() {
    widget.onChange(isMarked);
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text("Kirim ham qilasizmi",style: TextStyleConstants.listTileTitleStyle?.copyWith(color: isMarked ? Colors.blue:Colors.grey),),
        Checkbox(
            activeColor: Colors.blue,
            value: isMarked,
            onChanged: (val){
          setState(() {
            widget.onChange(val!);
            print("val : $val");
            isMarked = val;
          });
        })
      ],
    );
  }
}
