import 'package:a1_kirim_mobile/src/utils/constants/double_constants.dart';
import 'package:a1_kirim_mobile/src/utils/constants/style_constants.dart';
import 'package:flutter/material.dart';

class MyTextField extends StatelessWidget {
  final Key key;
  final double borderRadius;
  final String label;
  final int? maxLines;
  final int? maxLength;
  final bool isVisible;
  final TextInputType? keyboardType;
  final TextEditingController controller;
  final String? errorText;
  final bool readOnly;
  final String? prefixText;
  final void Function()? onTap;
  final void Function(String)? onChange;
  
  const MyTextField(
      {
      required this.label,
      required this.controller,
      this.errorText,
      this.maxLength,
      this.keyboardType,
      this.isVisible = false,
      this.borderRadius = DoubleConstants.textFieldBorderRadius,
      this.maxLines=1,
      this.readOnly = false,
      this.onTap,
      required this.key,
      this.onChange,
      this.prefixText, });

  @override
  Widget build(BuildContext context) {
    return TextField(
      maxLength: maxLength,
      key: key,
      onTap: readOnly?(){}:null,
      onChanged: onChange,
      controller: controller,
      maxLines: maxLines,
      minLines: 1,
      readOnly: readOnly,
      keyboardType: keyboardType,
      obscureText: isVisible,
      decoration: InputDecoration(
        prefix: prefixText != null ?Text(prefixText!):null,
          label: Text(
            label,
            style: TextStyleConstants.textFieldLabelStyle,
          ),
          border: InputBorder.none,
          focusedBorder: OutlineInputBorder(
            borderRadius:
                BorderRadius.circular(borderRadius),
          ),
          enabledBorder: OutlineInputBorder(
              borderRadius:
                  BorderRadius.circular(borderRadius)),
          errorBorder: OutlineInputBorder(
              borderRadius:
                  BorderRadius.circular(borderRadius),
              borderSide: BorderSide(color: Colors.red)),
          focusedErrorBorder: OutlineInputBorder(
              borderRadius:
                  BorderRadius.circular(borderRadius),
              borderSide: BorderSide(color: Colors.red)),
          errorText: errorText),
    );
  }
}
