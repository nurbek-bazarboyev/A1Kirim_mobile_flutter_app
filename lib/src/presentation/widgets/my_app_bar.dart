import 'package:a1_kirim_mobile/src/utils/constants/color_constants.dart';
import 'package:a1_kirim_mobile/src/utils/constants/style_constants.dart';
import 'package:flutter/material.dart';

class MyAppBar extends StatefulWidget implements PreferredSizeWidget {
  final IconButton? leading;
  final bool? centerTitle;
  final Widget? title;
  final List<Widget>? actions;
  final PreferredSizeWidget? bottom;
  MyAppBar({
    Key? key,
    this.leading, this.centerTitle=true, this.title, this.actions, this.bottom,

  }) : preferredSize = Size.fromHeight(kToolbarHeight), super(key: key);

  @override
  final Size preferredSize; // default is 56.0

  @override
  _MyAppBarState createState() => _MyAppBarState();
}

class _MyAppBarState extends State<MyAppBar>{

  @override
  Widget build(BuildContext context) {
    return Material(
      child: AppBar(
          leading: widget.leading,
          centerTitle: widget.centerTitle,
          backgroundColor: ColorConstants.primaryWidgetBackgroundColor,
          title: widget.title,
          actions: widget.actions,
          toolbarHeight: 100,
          bottom: widget.bottom??null,
      ),
    );
  }
}
