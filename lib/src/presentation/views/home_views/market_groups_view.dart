import 'package:a1_kirim_mobile/main.dart';
import 'package:a1_kirim_mobile/src/domain/models/group.dart';
import 'package:a1_kirim_mobile/src/domain/models/market.dart';
import 'package:a1_kirim_mobile/src/presentation/blocs/groups_list_bloc/groups_list_bloc.dart';
import 'package:a1_kirim_mobile/src/presentation/blocs/kirimlar_list_badge_bloc/kirimlar_list_badge_cubit.dart';
import 'package:a1_kirim_mobile/src/presentation/blocs/new_group_button_bloc/new_group_button_cubit.dart';
import 'package:a1_kirim_mobile/src/presentation/views/home_views/add_new_group_view.dart';
import 'package:a1_kirim_mobile/src/presentation/views/home_views/kirim_of_today_in_market_view.dart';
import 'package:a1_kirim_mobile/src/presentation/views/home_views/market_items_view.dart';
import 'package:a1_kirim_mobile/src/presentation/views/home_views/markets_view.dart';
import 'package:a1_kirim_mobile/src/presentation/widgets/my_app_bar.dart';
import 'package:a1_kirim_mobile/src/presentation/widgets/my_button.dart';
import 'package:a1_kirim_mobile/src/utils/constants/color_constants.dart';
import 'package:a1_kirim_mobile/src/utils/constants/double_constants.dart';
import 'package:a1_kirim_mobile/src/utils/constants/padding_constants.dart';
import 'package:a1_kirim_mobile/src/utils/constants/style_constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MarketGroupsView extends StatefulWidget {
  final Market market;
  final List<Group> itemsGroup;
  final String title;

  const MarketGroupsView(
      {super.key,
      required this.itemsGroup,
      required this.title,
      required this.market});

  @override
  State<MarketGroupsView> createState() => _MarketGroupsViewState();
}

class _MarketGroupsViewState extends State<MarketGroupsView> {
  TextEditingController _searchController = TextEditingController();
  String searchQuery = "Search query";

  @override
  void initState() {
    context.read<KirimlarListBadgeCubit>().setInitialCountFromSharedPref(
        unWatched: sharedPreferences
                ?.getInt("badgeCount${widget.market.rekvizitId}") ??
            0,
        rekvisitId: widget.market.rekvizitId!);
    context.read<GroupsListBloc>().add(JustUpdateEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext my) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      resizeToAvoidBottomInset: false,
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
          title: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Text(
              widget.title + " guruhlari",
              style: TextStyleConstants.appBarTitleStyle,
            ),
          ),
          centerTitle: true,
          actions: [
            BlocBuilder<KirimlarListBadgeCubit, int>(
              builder: (context, state) {
                return SizedBox(
                  height: 50,
                  width: 50,
                  child: Stack(
                    children: [
                      SizedBox(
                        height: 50,
                        width: 50,
                      ),
                      IconButton(
                          onPressed: () {
                            Navigator.push(context,
                                MaterialPageRoute(builder: (context) {
                              return BlocProvider.value(
                                value: BlocProvider. of<KirimlarListBadgeCubit>(my),
                                child: KirimOfTodayInMarketView(
                                  market: widget.market,
                                ),
                              );
                            }));
                          },
                          icon: Icon(
                            Icons.table_rows_sharp,
                            color: ColorConstants.appBarWidgetsColor,
                          )),
                      if (state != 0)
                        Positioned(
                            top: 0,
                            right: 5,
                            child: Container(
                              alignment: Alignment.center,
                              constraints:
                                  BoxConstraints(minWidth: 20, minHeight: 16),
                              padding: EdgeInsets.all(2),
                              decoration: BoxDecoration(
                                  color: Colors.red,
                                  borderRadius: BorderRadius.circular(14)),
                              child: Text(
                                "${state}",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w900,
                                    fontSize: 11),
                              ),
                            ))
                    ],
                  ),
                );
              },
            ),
          ]),
      body: BlocBuilder<GroupsListBloc, GroupsListState>(
          builder: (context, state) {
        if (state is GroupsListLoading) {
          return Center(
            child: CircularProgressIndicator(),
          );
        } else if (state is GroupsListEmpty) {
          return Center(
            child: Text(
              state.message,
              style: TextStyleConstants.listTileSubTitleStyle
                  ?.copyWith(fontSize: 20),
            ),
          );
        } else if (state is UpdatedGroupsList) {
          final data = state.groupsList;
          return Stack(
            children: [
              Column(
                children: [
                  Padding(
                    padding: PaddingConstants.listTileExternalPadding,
                    child: _buildSearchField(),
                  ),
                  Expanded(
                    child: ListView.builder(
                        itemCount: data.length,
                        itemBuilder: (context, index) {
                          return Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Padding(
                                padding:
                                    PaddingConstants.listTileExternalPadding,
                                child: BlocProvider.value(
                                  value:
                                      BlocProvider.of<KirimlarListBadgeCubit>(
                                          context),
                                  child: ListTile(
                                    onTap: () async {
                                      print(
                                          "...............................---------........................");
                                      print(
                                          "market items page    title: ${data[index].groupName}  items: ${items}");
                                      //print("Item.convertToItemList: ${Item.convertToItemList(itemsByCategory[data[index]], data[index]) }");
                                      await Navigator.of(context).push(
                                          MaterialPageRoute(builder: (context) {
                                        return MarketItemsView(
                                          title: data[index].groupName,
                                          items: data[index].goodsList,
                                          market: widget.market,
                                          group: data[index],
                                          index: index,
                                          groupList: widget.itemsGroup,
                                        );
                                      }));
                                      context
                                          .read<KirimlarListBadgeCubit>()
                                          .justUpdate(
                                              rekvisitId:
                                                  widget.market.rekvizitId!);
                                    },
                                    contentPadding:
                                        EdgeInsets.only(left: 15, right: 10),
                                    title: Text(data[index].groupName,
                                        style: TextStyleConstants
                                            .listTileTitleStyle),
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(
                                            DoubleConstants
                                                .listTileBorderRadius)),
                                    tileColor: Colors.white,
                                    trailing: Icon(
                                      CupertinoIcons.right_chevron,
                                      size: DoubleConstants.trailingHeight,
                                    ),
                                  ),
                                ),
                              ),
                              if (index == data.length - 1)
                                SizedBox(
                                  height: 130,
                                )
                            ],
                          );
                        }),
                  ),
                ],
              ),
              Positioned(
                left: 20,
                bottom: DoubleConstants.buttonUnderMargin,
                child: SizedBox(
                  width: size.width - 40,
                  child: MyButton(
                    name: "Yangi Guruh Qo'shish",
                    onPressed: () async {
                      print("siz guruh yaratyapsiz...");
                      final newMarket = await Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                        return BlocProvider(
                          create: (context) => NewGroupButtonCubit(),
                          child: AddNewGroupView(),
                        );
                      }));
                      setState(() {
                        groups.add(newMarket);
                      });
                    },
                  ),
                ),
              )
            ],
          );
        } else {
          return Center(
            child: Text(
              "Nomalum state",
              style: TextStyleConstants.listTileSubTitleStyle
                  ?.copyWith(fontSize: 20),
            ),
          );
        }
      }),
    );
  }

  Widget _buildSearchField() {
    return TextField(
      controller: _searchController,
      //autofocus: true,
      decoration: InputDecoration(
          fillColor: Colors.white,
          filled: true,
          hintText: "Guruh qidirish...",
          border: InputBorder.none,
          prefixIcon: Icon(CupertinoIcons.search),
          focusedBorder: OutlineInputBorder(
            borderRadius:
                BorderRadius.circular(DoubleConstants.listTileBorderRadius),
          ),
          disabledBorder: OutlineInputBorder(
            borderRadius:
                BorderRadius.circular(DoubleConstants.listTileBorderRadius),
          ),
          enabledBorder: OutlineInputBorder(
              borderRadius:
                  BorderRadius.circular(DoubleConstants.listTileBorderRadius),
              borderSide: BorderSide(color: Colors.grey.shade500))),
      onChanged: (query) => () {
        context.read<GroupsListBloc>().add(UpdateGroupsListEvent(query: query));
      },
    );
  }
}
