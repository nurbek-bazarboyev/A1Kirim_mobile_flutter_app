import 'dart:async';
import 'package:a1_kirim_mobile/src/domain/models/group.dart' show Group;
import 'package:a1_kirim_mobile/src/domain/models/item.dart';
import 'package:a1_kirim_mobile/src/domain/models/market.dart';
import 'package:a1_kirim_mobile/src/presentation/blocs/item_types_bloc/item_types_bloc_cubit.dart';
import 'package:a1_kirim_mobile/src/presentation/blocs/kirim_button_bloc/kirim_button_bloc_cubit.dart';
import 'package:a1_kirim_mobile/src/presentation/blocs/new_item_bloc/new_item_button_cubit.dart';
import 'package:a1_kirim_mobile/src/presentation/blocs/umumiy_summa_bloc/umumiy_summa_cubit.dart';
import 'package:a1_kirim_mobile/src/presentation/views/home_views/add_exist_item_view.dart';
import 'package:a1_kirim_mobile/src/presentation/views/home_views/add_new_item_view.dart';
import 'package:a1_kirim_mobile/src/presentation/widgets/my_app_bar.dart';
import 'package:a1_kirim_mobile/src/presentation/widgets/my_button.dart';
import 'package:a1_kirim_mobile/src/utils/constants/color_constants.dart';
import 'package:a1_kirim_mobile/src/utils/constants/double_constants.dart';
import 'package:a1_kirim_mobile/src/utils/constants/padding_constants.dart';
import 'package:a1_kirim_mobile/src/utils/constants/style_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart' show BlocProvider, MultiBlocProvider;

class MarketItemsView extends StatefulWidget {
  final String title;
  final List<Item>? items;
  final Market market;
  final Group group;
  final int index;
  final List<Group> groupList;

  const MarketItemsView({super.key,
    required this.title,
    required this.items,
    required this.market,
    required this.group,
    required this.index,
    required this.groupList});

  @override
  State<MarketItemsView> createState() => _MarketItemsViewState();
}

class _MarketItemsViewState extends State<MarketItemsView> {
  TextEditingController _searchController = TextEditingController();
  late StreamController<List<Item>> _streamController =
  StreamController<List<Item>>();
  bool _isSearching = false;
  List<Item> _filteredData = [];
  String searchQuery = "Search query";

  @override
  void initState() {
    super.initState();
    _streamController.sink.add(widget.items!);
    //_filteredData = markets;
    //  _searchController.addListener(_performSearch);
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery
        .of(context)
        .size;
    return Scaffold(
      backgroundColor: ColorConstants.scaffoldBackgroundColor,
      appBar: MyAppBar(
          leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: Icon(
                CupertinoIcons.back,
                color: ColorConstants.appBarWidgetsColor,
              )),
          centerTitle: true,
          title: Text(
            widget.title,
            softWrap: true,
            textWidthBasis: TextWidthBasis.longestLine,
            style: TextStyleConstants.appBarTitleStyle!.copyWith(
              fontSize: 18,
            ),
          ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: StreamBuilder<List<Item>>(
                stream: _streamController.stream,
                builder: (context, snapshot) {
                  final data = snapshot.data;
                  return Stack(
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          if(widget.items?.length != 0)Padding(
                            padding: PaddingConstants.listTileExternalPadding,
                            child: _buildSearchField(),
                          ),
                          if(widget.items?.length != 0)Expanded(
                            child: data!.length == 0 ? Center(child: Text("Mahsulot mavjud emas",style: TextStyleConstants.listTileTitleStyle?.copyWith(fontSize: 20),),) : ListView.builder(
                                itemCount: data!.length,
                                itemBuilder: (context, index) {
                                  return Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Padding(
                                        padding:
                                        PaddingConstants.listTileExternalPadding,
                                        child: ListTile(
                                          onTap: () {
                                            Navigator.push(context,
                                                MaterialPageRoute(builder: (context) {
                                                  return MultiBlocProvider(
                                                    providers: [
                                                      BlocProvider(
                                                        create: (context) =>
                                                            KirimButtonBlocCubit(),
                                                      ),
                                                      BlocProvider(
                                                        create: (context) =>
                                                            UmumiySummaCubit(),
                                                      ),
                                                      BlocProvider(
                                                        create: (context) =>
                                                            ItemTypesBlocCubit(),
                                                      ),
                                                    ],
                                                    child: AddExistItemView(
                                                      item: data[index],
                                                      market: widget.market,
                                                    ),
                                                  );
                                                }));
                                          },
                                          title: Text(data[index].name!,
                                              style: TextStyleConstants
                                                  .listTileTitleStyle),
                                          subtitle: Text(
                                            data[index].goodsGroupId.toString(),
                                            style: TextStyleConstants
                                                .listTileSubTitleStyle,
                                          ),
                                          shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(
                                                  DoubleConstants
                                                      .listTileBorderRadius)),
                                          tileColor: Colors.white,
                                        ),
                                      ),
                                      if (index == data.length - 1)
                                        SizedBox(
                                          height: 150,
                                        )
                                    ],
                                  );
                                }),
                          ),
                          if(widget.items?.length == 0)Center(child: Center(child: Text("Mahsulot mavjud emas",style: TextStyleConstants.listTileTitleStyle?.copyWith(fontSize: 20),),),)
                        ],
                      ),
                      Positioned(
                          bottom: DoubleConstants.buttonUnderMargin,
                          left: 20,
                          child: SizedBox(
                              width: size.width - 40,
                              child: MyButton(
                                name: "Yangi Mahsulot Qo'shish",
                                onPressed: () async {
                                  final newItem = await Navigator.push(context,
                                      MaterialPageRoute(builder: (context) {
                                        return BlocProvider(
                                          create: (context) => NewItemButtonCubit(),
                                          child: AddNewItemView(
                                            group: widget.group,
                                            groupList: widget.groupList,
                                            index: widget.index,
                                            market: widget.market,
                                          ),
                                        );
                                      }));
                                  if (true) {
                                    setState(() {

                                      print(
                                          "siz itemlar page ini update qilyapsiz...");
                                    });
                                  }
                                },
                              )))
                    ],
                  );
                }),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchField() {
    return TextField(
      controller: _searchController,
      //autofocus: true,
      decoration: InputDecoration(
          fillColor: Colors.white,
          filled: true,
          hintText: "Mahsulot qidirish...",
          border: InputBorder.none,
          prefixIcon: Icon(CupertinoIcons.search),
          //hintStyle: TextStyle(color: Colors.white30),
          focusedBorder: OutlineInputBorder( borderRadius: BorderRadius.circular(DoubleConstants
              .listTileBorderRadius),),
          disabledBorder: OutlineInputBorder( borderRadius: BorderRadius.circular(DoubleConstants
              .listTileBorderRadius),),
          enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(DoubleConstants
                  .listTileBorderRadius),
              borderSide: BorderSide(color: Colors.grey.shade500)
          )

      ),
      //style: TextStyle(color: Colors.white, fontSize: 16.0),
      onChanged: (query) => updateSearchQuery(query),
    );
  }

  List<Widget> _buildActions() {
    if (_isSearching) {
      return <Widget>[
        IconButton(
          icon: const Icon(Icons.clear),
          onPressed: () {
            if (_searchController == null || _searchController.text.isEmpty) {
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
        icon: Icon(
          Icons.search,
          color: ColorConstants.appBarWidgetsColor,
        ),
        onPressed: _startSearch,
      ),
    ];
  }

  void _startSearch() {
    ModalRoute.of(context)!
        .addLocalHistoryEntry(LocalHistoryEntry(onRemove: _stopSearching));

    setState(() {
      _isSearching = true;
    });
  }

  void updateSearchQuery(String newQuery) {
    _filteredData = widget.items!
        .where((item) => item.name.toString().toLowerCase().contains(newQuery))
        .toList();

    _streamController.sink.add(_filteredData);
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
}