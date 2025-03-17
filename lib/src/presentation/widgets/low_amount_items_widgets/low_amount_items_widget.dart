import 'package:a1_kirim_mobile/src/presentation/blocs/low_amount_item_bloc/low_amount_item_bloc.dart';
import 'package:a1_kirim_mobile/src/presentation/blocs/low_amount_item_bloc/low_amount_item_bloc.dart';
import 'package:a1_kirim_mobile/src/utils/constants/style_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LowAmountItemsWidget extends StatefulWidget {
  const LowAmountItemsWidget({super.key});

  @override
  State<LowAmountItemsWidget> createState() => _LowAmountItemsWidgetState();
}

class _LowAmountItemsWidgetState extends State<LowAmountItemsWidget> {
  @override
  void initState() {
    context.read<LowAmountItemBloc>().add(UpdateLowItemsEvent(newLowItems: ['bu default malumot ilova ishga tushgandan keyin bu yerga backenddan keladigan malumotni yuborish kerak']));
    // TODO: implement initState
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LowAmountItemBloc, LowAmountItemState>(
      builder: (context, state) {
        if(state is LowAmountItemInitial){
          return Center(
            child: CircularProgressIndicator(),
          );
        }else{
          final data = (state as UpdatedDataState).lowItems;
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Center(
                child: Text(data[0],style: TextStyleConstants.listTileTitleStyle,),
              )
            ],
          );
        }

      },
    );
  }
}
