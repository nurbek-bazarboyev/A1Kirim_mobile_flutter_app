// import 'dart:async';
//
// import 'package:a1_kirim_mobile/src/domain/models/item.dart';
// import 'package:a1_kirim_mobile/src/domain/models/market.dart';
// import 'package:a1_kirim_mobile/src/presentation/views/markets_view.dart';
// import 'package:a1_kirim_mobile/src/presentation/widgets/my_app_bar.dart';
// import 'package:a1_kirim_mobile/src/presentation/widgets/my_button.dart';
// import 'package:a1_kirim_mobile/src/utils/constants/color_constants.dart';
// import 'package:a1_kirim_mobile/src/utils/constants/double_constants.dart';
// import 'package:a1_kirim_mobile/src/utils/constants/padding_constants.dart';
// import 'package:a1_kirim_mobile/src/utils/constants/style_constants.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/cupertino.dart';
// class TestView extends StatefulWidget {
//   const TestView({super.key});
//
//   @override
//   State<TestView> createState() => _TestViewState();
// }
//
// class _TestViewState extends State<TestView> {
//   late StreamController<List<Market>> _streamController = StreamController<List<Market>>();
//   int currentIndex = 0;
//   TextEditingController _searchController = TextEditingController();
//   bool _isSearching = false;
//   List<Market> _filteredData = [];
//   String searchQuery = "Search query";
//   @override
//   void initState() {
//     super.initState();
//     _streamController.sink.add(markets);
//     //_filteredData = markets;
//     //  _searchController.addListener(_performSearch);
//   }
//
//   // Future<void> _performSearch() async {
//   //  setState(() {
//   //     _filteredData = markets
//   //         .where((element) => element.name
//   //         .toLowerCase()
//   //         .contains(_searchController.text.toLowerCase()))
//   //         .toList();
//   //   });
//   //   }
//
//   @override
//   void dispose() {
//     _searchController.dispose();
//     super.dispose();
//   }
//   @override
//   Widget build(BuildContext context) {
//     Size size = MediaQuery.of(context).size;
//     return Scaffold(
//       resizeToAvoidBottomInset: false,
//       backgroundColor: ColorConstants.scaffoldBackgroundColor,
//       appBar: MyAppBar(
//         title: _buildSearchField() ,//_isSearching ? _buildSearchField() : Text("Do'konlar", style: TextStyleConstants.appBarTitleStyle,),
//         centerTitle: true,
//         // actions: _buildActions()
//       ),
//       bottomNavigationBar: SizedBox(
//         height: 70,
//         child: BottomNavigationBar(
//           currentIndex: currentIndex,
//
//           backgroundColor: ColorConstants.primaryWidgetBackgroundColor,
//           selectedItemColor: ColorConstants.selectedIconColor,
//           unselectedItemColor: ColorConstants.unselectedIconColor,
//           onTap: (int index){
//             setState(() {
//               currentIndex = index;
//             });
//           },
//           selectedLabelStyle: TextStyle(color: ColorConstants.selectedIconColor, fontWeight: FontWeight.bold),
//           unselectedLabelStyle: TextStyle(color: ColorConstants.unselectedIconColor, fontWeight: FontWeight.normal),
//           type: BottomNavigationBarType.fixed,
//           elevation: 0,
//           items: const [
//             BottomNavigationBarItem(
//                 label: "Do'konlar",
//                 icon: Icon(Icons.home_outlined),
//                 activeIcon: Icon(Icons.home)
//             ),
//             BottomNavigationBarItem(
//                 label: 'Kam qolganlar',
//                 icon: Icon(Icons.insert_chart_outlined_rounded),
//                 activeIcon: Icon(Icons.insert_chart)
//             ),
//             BottomNavigationBarItem(
//                 label: 'Kirimlar',
//                 icon: Icon(Icons.notifications_on_outlined),
//                 activeIcon: Icon(Icons.notifications_active)
//             ),
//           ],
//         ),
//       ),
//       body: Stack(
//         alignment: Alignment.center,
//         children: [
//           SizedBox(
//             height: size.height,
//             child: SingleChildScrollView(
//               child: StreamBuilder<List<Market>>(
//                   stream: _streamController.stream,
//                   builder: (context, snapshot) {
//                     final data = snapshot.data;
//                     return Column(
//                       children: [
//                         for (int i = 0; i<data!.length; i++)Column(
//                           mainAxisSize: MainAxisSize.min,
//                           children: [
//                             Padding(
//                               padding: PaddingConstants.listTileExternalPadding,
//                               child: ListTile(
//                                 onTap: (){},
//                                 title: Text(data[i].name,style: TextStyleConstants.listTileTitleStyle,),
//                                 subtitle: Text(data[i].location,style: TextStyleConstants.listTileSubTitleStyle,),
//                                 shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(DoubleConstants.listTileBorderRadius)),
//                                 tileColor: Colors.white,
//                               ),
//                             ),
//                             if(i == markets.length-1)SizedBox(height: 120,)
//                           ],
//                         )
//                       ],
//                     );
//
//                   }
//               ),
//             ),
//           ),
//           Positioned(bottom: 10,
//               child: SizedBox(
//                   width: size.width-20,
//                   child: MyButton(name: "Yangi Do'kon")))
//         ],
//       ),
//     );
//   }
//   Widget _buildSearchField() {
//     return TextField(
//       controller: _searchController,
//       autofocus: true,
//       decoration: InputDecoration(
//         hintText: "Search Data...",
//         border: InputBorder.none,
//         hintStyle: TextStyle(color: Colors.white30),
//       ),
//       style: TextStyle(color: Colors.white, fontSize: 16.0),
//       onChanged: (query) => updateSearchQuery(query),
//     );
//   }
//
//   List<Widget> _buildActions() {
//     if (_isSearching) {
//       return <Widget>[
//         IconButton(
//           icon: const Icon(Icons.clear),
//           onPressed: () {
//             if (_searchController == null ||
//                 _searchController.text.isEmpty) {
//               Navigator.pop(context);
//               return;
//             }
//             _clearSearchQuery();
//           },
//         ),
//       ];
//     }
//
//     return <Widget>[
//       IconButton(
//         icon: const Icon(Icons.search),
//         onPressed: _startSearch,
//       ),
//     ];
//   }
//
//   void _startSearch() {
//     ModalRoute.of(context)!
//         .addLocalHistoryEntry(LocalHistoryEntry(onRemove: _stopSearching));
//
//     setState(() {
//       _isSearching = true;
//     });
//   }
//
//   void updateSearchQuery(String newQuery) {
//     _filteredData = markets
//         .where((element) => element.name
//         .toLowerCase()
//         .contains(newQuery))
//         .toList();
//     print("_filteredData: $_filteredData");
//     // setState(() {
//     _streamController.sink.add(_filteredData);
//     searchQuery = newQuery;
//     // });
//   }
//
//   void _stopSearching() {
//     _clearSearchQuery();
//
//     setState(() {
//       _isSearching = false;
//     });
//   }
//
//   void _clearSearchQuery() {
//     setState(() {
//       _searchController.clear();
//       updateSearchQuery("");
//     });
//   }
// }
//
