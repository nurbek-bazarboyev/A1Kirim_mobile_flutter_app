// import 'dart:async';
//
// import 'package:a1_kirim_mobile/src/domain/models/item.dart';
// import 'package:a1_kirim_mobile/src/presentation/blocs/item_types_bloc/item_types_bloc_cubit.dart';
// import 'package:a1_kirim_mobile/src/utils/constants/double_constants.dart';
// import 'package:a1_kirim_mobile/src/utils/constants/style_constants.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
//
// import '../../utils/constants/color_constants.dart';
//
// class ItemsTypeScrollableWidget extends StatefulWidget {
//   final Size size;
//   final List<String> itemTypes;
//
//   const ItemsTypeScrollableWidget(
//       {super.key, required this.size, required this.itemTypes});
//
//   @override
//   State<ItemsTypeScrollableWidget> createState() =>
//       _ItemsTypeScrollableWidgetState();
// }
//
// class _ItemsTypeScrollableWidgetState extends State<ItemsTypeScrollableWidget> {
//   StreamController<int> _streamController = StreamController<int>();
//
//   @override
//   void initState() {
//     _streamController.sink.add(0);
//     // TODO: implement initState
//     super.initState();
//   }
//
//   @override
//   void dispose() {
//     _streamController.close();
//     // TODO: implement dispose
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return SingleChildScrollView(
//       scrollDirection: Axis.horizontal,
//       child: Container(
//         height: DoubleConstants.itemsTypeWidgetHeight,
//         width: widget.size.width,
//         color: ColorConstants.scaffoldBackgroundColor,
//         child: SingleChildScrollView(
//             scrollDirection: Axis.horizontal,
//             child: ListView.builder(
//                 shrinkWrap: true,
//                 physics: NeverScrollableScrollPhysics(),
//                 scrollDirection: Axis.horizontal,
//                 itemCount: widget.itemTypes.length,
//                 itemBuilder: (context, index) {
//                   return BlocBuilder<ItemTypesBlocCubit, int>(
//                     builder: (context, state) {
//                       return InkWell(
//                         onTap: (){
//                           context.read<ItemTypesBlocCubit>().changeTypeTo(index);
//                         },
//                         child: Container(
//                           alignment: Alignment.center,
//                           margin: EdgeInsets.only(left: index == 0 ? 10: 5,bottom: 5,top: 5,right: index == widget.itemTypes.length-1 ? 10 : 0),
//                           padding:
//                               EdgeInsets.symmetric(horizontal: 15, vertical: 5),
//                           height: 50,
//                           decoration: BoxDecoration(
//                               borderRadius: BorderRadius.circular(6),
//                               color: state == index ? Colors.blue :Colors.white
//                           ),
//                           child: Text(widget.itemTypes[index],style: TextStyleConstants.listTileTitleStyle!.copyWith(color: state == index ? Colors.white : Colors.black,fontWeight: state == index ? FontWeight.w900:null,fontSize: state == index ? 16 : 14),),
//                         ),
//                       );
//                     },
//                   );
//                 })
//
//             ),
//       ),
//     );
//   }
// }
//
// Map<String, List<Map<String, dynamic>>> itemsByCategory = {
//   'All': [],
//   'Electronics': [],
//   'Clothing': [],
//   'Books': [],
//   'Furniture': [],
//   'Toys': [
//     {'id': 41, 'name': 'Action Figure', 'price': 25, 'imageUrl': 'assets/toys/actionfigure.png'},
//     {'id': 42, 'name': 'Doll', 'price': 30, 'imageUrl': 'assets/toys/doll.png'},
//     {'id': 43, 'name': 'Board Game', 'price': 40, 'imageUrl': 'assets/toys/boardgame.png'},
//     {'id': 44, 'name': 'Lego Set', 'price': 60, 'imageUrl': 'assets/toys/lego.png'},
//     {'id': 45, 'name': 'RC Car', 'price': 75, 'imageUrl': 'assets/toys/rccar.png'},
//     {'id': 46, 'name': 'Puzzle', 'price': 20, 'imageUrl': 'assets/toys/puzzle.png'},
//     {'id': 47, 'name': 'Stuffed Animal', 'price': 35, 'imageUrl': 'assets/toys/stuffed.png'},
//     {'id': 48, 'name': 'Yo-Yo', 'price': 10, 'imageUrl': 'assets/toys/yoyo.png'},
//     {'id': 49, 'name': 'Toy Train', 'price': 50, 'imageUrl': 'assets/toys/train.png'},
//     {'id': 50, 'name': 'Building Blocks', 'price': 55, 'imageUrl': 'assets/toys/blocks.png'},
//   ],
// };
//
