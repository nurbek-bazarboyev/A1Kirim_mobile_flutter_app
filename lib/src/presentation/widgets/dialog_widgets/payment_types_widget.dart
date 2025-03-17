import 'package:a1_kirim_mobile/src/utils/constants/payment_type.dart';
import 'package:flutter/material.dart';
class PaymentTypesWidget extends StatefulWidget {
  final void Function(String) onChange;
  const PaymentTypesWidget({super.key, required this.onChange});

  @override
  State<PaymentTypesWidget> createState() => _PaymentTypesWidgetState();
}

class _PaymentTypesWidgetState extends State<PaymentTypesWidget> {
  String? selectedInfo = PaymentTypeData.types[0].shortName;
  @override
  void initState() {

    widget.onChange(selectedInfo!);
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 45,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Expanded(
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
                itemCount: PaymentTypeData.types.length,
                itemBuilder: (context,index){
                  final data = PaymentTypeData.types;
              return Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(data[index].name,style: TextStyle(color: selectedInfo == data[index].shortName? Colors.black:Colors.grey,fontWeight: FontWeight.w600),),
                  Radio(value: data[index].shortName, groupValue: selectedInfo, onChanged: (value){
                    widget.onChange(value!);
                    setState(() {
                      selectedInfo = value;
                    });
                  })
                ],
              );
            }),
          ),
          Divider(height: 1,)
        ],
      ),
    );
  }
}
