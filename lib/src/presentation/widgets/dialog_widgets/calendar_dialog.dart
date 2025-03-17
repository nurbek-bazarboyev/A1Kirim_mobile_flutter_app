import 'package:flutter/material.dart';
class CalendarDialog extends StatefulWidget {
  final void Function(String)? onDateChange;
  final Color? color;
  final String today;
  const CalendarDialog({super.key,  this.onDateChange, this.color, required this.today});

  @override
  State<CalendarDialog> createState() => _CalendarDialogState();
}

class _CalendarDialogState extends State<CalendarDialog> {
  @override
  void initState() {
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    print("date in calendar: ${DateTime.parse(widget.today)}");
    print("date in calendar: ${DateTime.parse(widget.today).toString()}");
    return SizedBox(
      height: 50,
      width: 50,
      child: IconButton(onPressed: ()async{
        final selectedDate = await showDatePicker(context: context, firstDate: DateTime(1990), lastDate: DateTime.parse(widget.today));
        if(selectedDate != null){
            final date = selectedDate.toString().split(' ')[0];
            widget.onDateChange!(date);
        }
      }, icon: Icon(Icons.calendar_month,color: widget.color,)),
    );
  }
}
