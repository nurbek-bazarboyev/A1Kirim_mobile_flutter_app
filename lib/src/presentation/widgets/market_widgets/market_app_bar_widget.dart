import 'package:a1_kirim_mobile/src/data/data_sources/api_service.dart';
import 'package:a1_kirim_mobile/src/data/repositories/item_repository.dart';
import 'package:a1_kirim_mobile/src/domain/models/item.dart';
import 'package:a1_kirim_mobile/src/domain/models/items.dart';
import 'package:a1_kirim_mobile/src/domain/models/market.dart';
import 'package:a1_kirim_mobile/src/presentation/blocs/groups_list_bloc/groups_list_bloc.dart';
import 'package:a1_kirim_mobile/src/presentation/blocs/markets_list_bloc/markets_list_bloc.dart';
import 'package:a1_kirim_mobile/src/presentation/views/home_views/markets_view.dart';
import 'package:a1_kirim_mobile/src/utils/constants/color_constants.dart';
import 'package:a1_kirim_mobile/src/utils/constants/style_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart';

import '../my_app_bar.dart';
import 'package:flutter/cupertino.dart';

class MarketAppBarWidget extends StatefulWidget implements PreferredSizeWidget{
  MarketAppBarWidget({
    Key? key,

  }) : preferredSize = Size.fromHeight(kToolbarHeight), super(key: key);

  @override
  final Size preferredSize; // default is 56.0

  @override
  State<MarketAppBarWidget> createState() => _MarketAppBarWidgetState();
}

class _MarketAppBarWidgetState extends State<MarketAppBarWidget> {
  TextEditingController _searchController = TextEditingController();


  List<Market> _filteredData = [];
  String searchQuery = "Search query";
  bool _isSearching = false;
  sortByGroup(){

    groups.forEach((group)async{
      List<Item> sortedItems = [];
      sortedItems =  await Items.sortByGroupId(items, group.goodsGroupId);
      group.goodsList = sortedItems;
      print("..............................");
      print("groupId: ${group.goodsGroupId}");
      print("goodsList.length: ${group.goodsList?.length}");
    });
  }

  @override
  PreferredSizeWidget build(BuildContext context) {
    return MyAppBar(
      //leading: drawer
      leading: IconButton(
        icon:  Icon(Icons.menu,color: ColorConstants.appBarWidgetsColor,),
        onPressed: () {
          Scaffold.of(context).openDrawer();
        },
      ),
        title: Text(
          "Do'konlar", style: TextStyleConstants.appBarTitleStyle,),
        centerTitle: true,
      actions: [
        IconButton(onPressed: ()async{
          context.read<MarketsListBloc>().add(SetInitialMarketsListEvent());
          await Future.delayed(Duration(seconds: 5));
          context.read<GroupsListBloc>().add(SetInitialGroupsListEvent());
          print("saving...");
          print("starting getItems...");
          items = await ItemRepository(ApiService(Client())).getItems();
          print("items in marketsview initialState(): ${items}");
          sortByGroup();
          saveItemsToDb();
        }, icon: Icon(CupertinoIcons.refresh_thin,color: ColorConstants.appBarWidgetsColor,),),
      ],
    );
  }

}
