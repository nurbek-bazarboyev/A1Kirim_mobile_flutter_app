import 'package:a1_kirim_mobile/src/domain/models/unit_type.dart' show UnitType;
import 'package:a1_kirim_mobile/src/utils/constants/double_constants.dart' show DoubleConstants;
import 'package:flutter/material.dart';

import '../../views/home_views/markets_view.dart';
class SelectUnitTypeWidget extends StatefulWidget {
  final UnitType? oldUnitType;
  final void Function(UnitType?) onChange;
  final Size size;
  const SelectUnitTypeWidget({super.key, required this.size, required this.onChange, this.oldUnitType});

  @override
  State<SelectUnitTypeWidget> createState() => _SelectUnitTypeWidgetState();
}

class _SelectUnitTypeWidgetState extends State<SelectUnitTypeWidget> {
  int? selectedValue;
  @override
  void initState() {
    print(unitTypes);
    if(widget.oldUnitType!=null){
      widget.onChange(widget.oldUnitType);
    }else{
      print("oldUnitType: mavjud emas");
    }


    // TODO: implement initState
    if(widget.oldUnitType != null){
      selectedValue = widget.oldUnitType?.unitTypeId;
    }
    else{
      print("selectedValue: mavjud emas");
    }
    //print(selectedValue!.toJson());
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      padding: EdgeInsets.symmetric(horizontal: 10,),
      height: 56,
      width: double.infinity,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(DoubleConstants.textFieldBorderRadius),
          border: Border.all(color: Colors.black)
      ),
      child: DropdownButton<int?>(
        value: selectedValue??null,
        hint: Text('mahsulot o\'lchov birliki'),
        underline: SizedBox(width: 300,),
        borderRadius: BorderRadius.circular(DoubleConstants.textFieldBorderRadius),
        isExpanded: true,
        menuWidth: widget.size.width-40,
        //menuMaxHeight: 100,
        items: unitTypes.map((UnitType value) {
          return DropdownMenuItem<int>(
            value: value.unitTypeId,
            child: Text(value.unitType),
          );
        }).toList(),
        onChanged: (val) {
          setState(() {
            print(val);
            unitTypes.forEach((type){
              if(type.unitTypeId == val){
                selectedValue = type.unitTypeId;
                widget.onChange(type);
              }else{
                // shunchaki otib ketsin
              }
            });
          });
        },
      ),
    );
  }
}
