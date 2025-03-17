import 'package:a1_kirim_mobile/src/utils/constants/double_constants.dart';
import 'package:a1_kirim_mobile/src/utils/constants/style_constants.dart';
import 'package:flutter/material.dart';
class MyButton extends StatefulWidget {
  final String name;
  final double? nameFontSize;
  final WidgetStateProperty<Color?>? backgroudColor;
  final ButtonStyle? style;
  final void Function()? onPressed;
  const MyButton({super.key, required this.name, this.onPressed, this.backgroudColor, this.style, this.nameFontSize});

  @override
  State<MyButton> createState() => _MyButtonState();
}

class _MyButtonState extends State<MyButton> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: DoubleConstants.loginButtonHeight,
      child: ElevatedButton(
          onPressed: widget.onPressed,
          style: widget.style??( ButtonStyleConstants.loginButtonStyle.copyWith(backgroundColor: widget.backgroudColor??null)),
          child: Text(widget.name,style: TextStyleConstants.buttonNameStyle?.copyWith(fontSize: widget.nameFontSize),)
      ),
    );
  }
}
