import 'package:a1_kirim_mobile/src/utils/constants/style_constants.dart';
import 'package:flutter/material.dart';
class CircularProgressDialog extends StatelessWidget {
  final String text;
  const CircularProgressDialog({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: EdgeInsets.all(20),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircularProgressIndicator(),
            SizedBox(width: 20,),
            Text(text,style: TextStyleConstants.listTileTitleStyle)
          ],
        ),
      ),
    );
  }
}
