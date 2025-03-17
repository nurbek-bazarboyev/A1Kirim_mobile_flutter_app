import 'package:a1_kirim_mobile/src/presentation/blocs/groups_list_bloc/groups_list_bloc.dart';
import 'package:a1_kirim_mobile/src/presentation/blocs/kirimlar_list_badge_bloc/kirimlar_list_badge_cubit.dart';
import 'package:a1_kirim_mobile/src/presentation/blocs/markets_list_bloc/markets_list_bloc.dart';
import 'package:a1_kirim_mobile/src/presentation/blocs/new_market_button_bloc/new_market_button_cubit.dart';
import 'package:a1_kirim_mobile/src/presentation/utils/dialog_helper.dart';
import 'package:a1_kirim_mobile/src/presentation/views/home_views/add_new_market_view.dart';
import 'package:a1_kirim_mobile/src/presentation/views/home_views/market_groups_view.dart';
import 'package:a1_kirim_mobile/src/presentation/views/home_views/markets_view.dart';
import 'package:a1_kirim_mobile/src/presentation/widgets/market_widgets/market_app_bar_widget.dart';
import 'package:a1_kirim_mobile/src/presentation/widgets/my_button.dart';
import 'package:a1_kirim_mobile/src/utils/constants/color_constants.dart';
import 'package:a1_kirim_mobile/src/utils/constants/double_constants.dart';
import 'package:a1_kirim_mobile/src/utils/constants/padding_constants.dart';
import 'package:a1_kirim_mobile/src/utils/constants/style_constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/models/market.dart';

class MarketsListWidget extends StatefulWidget {
  const MarketsListWidget({super.key});

  @override
  State<MarketsListWidget> createState() => _MarketsListWidgetState();
}

class _MarketsListWidgetState extends State<MarketsListWidget> {
  final _controller = ScrollController();
  TextEditingController _searchController = TextEditingController();
  bool _isSearching = false;

  @override
  void initState() {
    context.read<GroupsListBloc>().add(SetInitialGroupsListEvent());
    _controller.addListener(() {
      if (_controller.offset >= _controller.position.maxScrollExtent &&
          !_controller.position.outOfRange) {
        print("siz list oxiridasiz");
      }
    });
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Stack(
      alignment: Alignment.center,
      children: [
        Column(
          children: [
            BlocBuilder<MarketsListBloc, MarketsListState>(
                builder: (context, state) {
              if (state is MarketsListInitial) {
                return Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Center(
                        child: CircularProgressIndicator(),
                      ),
                    ],
                  ),
                );
              } else if (state is MarketsListLoading) {
                return Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Center(
                        child: CircularProgressIndicator(),
                      ),
                    ],
                  ),
                );
              } else if (state is UpdatedMarketsList) {
                final List<Market> data =
                    (state as UpdatedMarketsList).marketsList;
                return Expanded(
                  child: Column(
                    children: [
                      if (markets.length != 0)
                        Padding(
                          padding: PaddingConstants.listTileExternalPadding,
                          child: _buildSearchField(),
                        ),
                      if (data.length == 0)
                        Center(
                          child: Text(
                            "Do'konlar mavjud emas",
                            style: TextStyleConstants.listTileTitleStyle
                                ?.copyWith(fontSize: 20),
                          ),
                        ),
                      if (data.length != 0)
                        Expanded(
                          child: ListView.builder(
                              key: ValueKey("marketsList"),
                              itemCount: data.length,
                              itemBuilder: (context, index) {
                                return Column(
                                  key: ValueKey('col$index'),
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Padding(
                                      key: ValueKey('padding$index'),
                                      padding: PaddingConstants
                                          .listTileExternalPadding,
                                      child: ListTile(
                                        contentPadding:
                                            EdgeInsets.only(left: 15),
                                        key: ValueKey('listTile$index'),
                                        onTap: () {
                                          Navigator.of(context).push(
                                              MaterialPageRoute(
                                                  builder: (context) {
                                            return MultiBlocProvider(
                                              providers: [
                                                BlocProvider(
                                                  create: (context) =>
                                                      GroupsListBloc(),
                                                ),
                                                BlocProvider(
                                                  create: (context) =>
                                                      KirimlarListBadgeCubit(),
                                                ),
                                              ],
                                              child: MarketGroupsView(
                                                itemsGroup: groups,
                                                title: data[index].orgName!,
                                                market: data[index],
                                              ),
                                            );
                                          }));
                                        },
                                        title: Text(
                                          data[index].orgName!,
                                          style: TextStyleConstants
                                              .listTileTitleStyle,
                                        ),
                                        subtitle: Text(
                                          data[index].address!,
                                          style: TextStyleConstants
                                              .listTileSubTitleStyle,
                                        ),
                                        trailing: IconButton(
                                            onPressed: () {
                                              DialogHelper.marketInfoDialog(
                                                  context, data[index]);
                                            },
                                            icon:
                                                Icon(Icons.more_vert_rounded)),
                                        shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                                DoubleConstants
                                                    .listTileBorderRadius)),
                                        tileColor: Colors.white,
                                      ),
                                    ),
                                    if (index == markets.length - 1)
                                      SizedBox(
                                        height: 120,
                                      )
                                  ],
                                );
                              }),
                        )
                    ],
                  ),
                );
              } else {
                return Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Center(
                      child: Text(
                        "Nomalum xatolik",
                        style: TextStyleConstants.listTileSubTitleStyle
                            ?.copyWith(fontSize: 20),
                      ),
                    ),
                  ],
                );
              }
            }),
          ],
        ),
        Positioned(
            left: 20,
            bottom: DoubleConstants.buttonUnderMargin,
            child: SizedBox(
                width: size.width - 40,
                child: MyButton(
                  name: "Yangi Do'kon Qo'shish",
                  onPressed: () async {
                    print("yangi do'kon yaratish...");
                    final newMarket = await Navigator.of(context)
                        .push(MaterialPageRoute(builder: (context) {
                      return BlocProvider(
                        create: (context) => NewMarketButtonCubit(),
                        child: AddNewMarketView(),
                      );
                    }));
                    if (newMarket != null) {
                      setState(() {
                        markets.add(newMarket);
                      });
                    }
                  },
                )))
      ],
    );
  }

  Widget _buildSearchField() {
    return TextField(
      controller: _searchController,
      decoration: InputDecoration(
          fillColor: Colors.white,
          filled: true,
          hintText: "Do'kon qidirish...",
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
       onChanged: (query) => updateSearchQuery(query),
    );
  }

  void updateSearchQuery(String newQuery) async {
    print("siz yangi malumot qidiryapsiz...");
    context
        .read<MarketsListBloc>()
        .add(UpdateMarketsListEvent(query: newQuery));
  }
}
