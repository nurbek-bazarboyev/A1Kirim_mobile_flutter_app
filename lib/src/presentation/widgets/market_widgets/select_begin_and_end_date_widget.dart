import 'package:a1_kirim_mobile/src/presentation/widgets/my_button.dart';
import 'package:a1_kirim_mobile/src/utils/constants/double_constants.dart';
import 'package:a1_kirim_mobile/src/utils/constants/style_constants.dart';
import 'package:flutter/material.dart';

class SelectBeginAndEndDateWidget extends StatefulWidget {
  final TextEditingController beginDateController;
  final TextEditingController endDateController;
  final double? fontSize;
  final double? iconSize;
  final String? limitDate;
  final Color? topTextColor;

  const SelectBeginAndEndDateWidget(
      {super.key,
      required this.beginDateController,
      required this.endDateController,
      this.fontSize,
      this.topTextColor,
      this.iconSize,
      this.limitDate});

  @override
  State<SelectBeginAndEndDateWidget> createState() =>
      _SelectBeginAndEndDateWidgetState();
}

class _SelectBeginAndEndDateWidgetState
    extends State<SelectBeginAndEndDateWidget> {
  @override
  void initState() {
    print("in select date buttons limit date: ${widget.limitDate}");
    final today = widget.limitDate ?? DateTime.now().toString().split(' ')[0];
    widget.beginDateController.text = today;
    widget.endDateController.text = today;
    print("in select begin and end date widget in init state...");
    print(widget.endDateController.text);
    print(widget.beginDateController.text);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: 10,
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 5.0),
                child: Text(
                  "dan",
                  style: TextStyleConstants.listTileTitleStyle
                      ?.copyWith(color: widget.topTextColor),
                ),
              ),
              MyDateWidget(
                limitDate: widget.limitDate,
                controller: widget.beginDateController,
                fontSize: widget.fontSize,
                iconSize: widget.iconSize,
                isEndDate: true,
              ),
            ],
          ),
        ),
        SizedBox(
          width: 10,
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 5.0),
                child: Text(
                  "gacha",
                  style: TextStyleConstants.listTileTitleStyle?.copyWith(color: widget.topTextColor),
                ),
              ),
              MyDateWidget(
                limitDate: widget.limitDate,
                controller: widget.endDateController,
                fontSize: widget.fontSize,
                iconSize: widget.iconSize,
                isEndDate: true,
              ),
            ],
          ),
        ),
        SizedBox(
          width: 10,
        )
      ],
    );
  }
}

class MyDateWidget extends StatefulWidget {
  final TextEditingController controller;
  final bool? isEndDate;
  final double? fontSize;
  final double? iconSize;
  final String? limitDate;

  const MyDateWidget(
      {super.key,
      this.isEndDate,
      required this.controller,
      this.fontSize,
      this.iconSize, this.limitDate});

  @override
  State<MyDateWidget> createState() => _MyDateWidgetState();
}

class _MyDateWidgetState extends State<MyDateWidget> {
  String date = "date";

  @override
  void initState() {
    if (widget.isEndDate == true) {
      date = widget.limitDate??DateTime.now().toString().split(' ')[0];
      widget.controller.text = date;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: InkWell(
        onTap: () {},
        child: Container(
          decoration: BoxDecoration(
              borderRadius:
                  BorderRadius.circular(DoubleConstants.primaryBorderRadius),
              color: Colors.blue),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () async {
                final selectedDate = await showDatePicker(
                    context: context,
                    firstDate: DateTime(1990),
                    lastDate: widget.limitDate != null ? DateTime.parse(widget.limitDate!) : DateTime.now());
                if (selectedDate != null) {
                  setState(() {
                    date = selectedDate.toString().split(' ')[0];
                    widget.controller.text = date;
                  });
                }
              },
              borderRadius:
                  BorderRadius.circular(DoubleConstants.primaryBorderRadius),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 10,
                  ),
                  Icon(
                    Icons.date_range,
                    color: Colors.grey.shade400,
                    size: widget.iconSize,
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Text(
                    date,
                    style: TextStyleConstants.appBarTitleStyle
                        ?.copyWith(fontSize: widget.fontSize ?? 14),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
