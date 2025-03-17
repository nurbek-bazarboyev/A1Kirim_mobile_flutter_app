import 'package:a1_kirim_mobile/src/domain/models/market.dart';
import 'package:a1_kirim_mobile/src/utils/constants/color_constants.dart';
import 'package:a1_kirim_mobile/src/utils/constants/style_constants.dart';
import 'package:flutter/material.dart';

import '../my_app_bar.dart';

class LowAmountItemsAppBarWidget extends StatefulWidget
    implements PreferredSizeWidget {
  LowAmountItemsAppBarWidget({
    Key? key,
  })
      : preferredSize = Size.fromHeight(kToolbarHeight),
        super(key: key);


  @override
  final Size preferredSize; // default is 56.0

  @override
  State<LowAmountItemsAppBarWidget> createState() =>
      _LowAmountItemsAppBarWidgetState();
}

class _LowAmountItemsAppBarWidgetState extends State<LowAmountItemsAppBarWidget> {
  TextEditingController _searchController = TextEditingController();


  List<Market> _filteredData = [];
  String searchQuery = "Search query";
  bool _isSearching = false;

  @override
  PreferredSizeWidget build(BuildContext context) {
    return MyAppBar(
        leading: IconButton(
          icon:  Icon(Icons.menu,color: ColorConstants.appBarWidgetsColor,),
          onPressed: () {
            Scaffold.of(context).openDrawer();
          },
        ),
        title: _isSearching ? _buildSearchField() : Text(
          "Kam Qolgan Mahsulotlar", style: TextStyleConstants.appBarTitleStyle,),
        centerTitle: true,
        actions: _buildActions()
    );
  }
  Widget _buildSearchField() {
    return TextField(
        controller: _searchController,
        autofocus: true,
        decoration: InputDecoration(
          hintText: "Search Data...",
          border: InputBorder.none,
          hintStyle: TextStyle(color: Colors.white30),
        ),
        style: TextStyle(color: Colors.white, fontSize: 16.0),
        onChanged: (query) {
          updateSearchQuery(query);
        }
    );
  }
  void _startSearch() {
    ModalRoute.of(context)!
        .addLocalHistoryEntry(LocalHistoryEntry(onRemove: _stopSearching));

    setState(() {
      _isSearching = true;
    });
  }

  void updateSearchQuery(String newQuery) async{
    /*
    // List<Market> list = [];
    // int count = 0;
    // _filteredData =markets
    //     .where((element) {
    //   bool isExist = false;
    //   if(element.name.toLowerCase().contains(newQuery)){
    //     isExist = true;
    //     list.add(element);
    //   }else{
    //     isExist = false;
    //   }
    //
    //   if(count%100 == 0){
    //     streamController.sink.add(_filteredData);
    //   }else{
    //     // shunchaki hech nima qilmaslik  kerak bu yerda
    //   }
    //   count++;
    //   return isExist;})
    //     .toList();
    //
    // print("_filteredData: $_filteredData");
    // // setState(() {
    // streamController.sink.add(_filteredData);
    // searchQuery = newQuery;
    // });

     */
    print("siz yangi malumot qidiryapsiz...");
    // write your bloc here
    // context.read<MarketsListBloc>().add(UpdateMarketsListEvent(query: newQuery));
  }

  void _stopSearching() {
    _clearSearchQuery();

    setState(() {
      _isSearching = false;
    });
  }

  void _clearSearchQuery() {
    setState(() {
      _searchController.clear();
      updateSearchQuery("");
    });
  }
  List<Widget> _buildActions() {
    if (_isSearching) {
      return <Widget>[
        IconButton(
          icon: const Icon(Icons.clear),
          onPressed: () {
            if (_searchController == null ||
                _searchController.text.isEmpty) {
              Navigator.pop(context);
              return;
            }
            _clearSearchQuery();
          },
        ),
      ];
    }

    return <Widget>[
      IconButton(
        icon: Icon(Icons.search, color: ColorConstants.appBarWidgetsColor,),
        onPressed: _startSearch,
      ),
    ];
  }
}
