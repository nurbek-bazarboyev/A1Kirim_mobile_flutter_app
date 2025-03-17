import 'dart:io';
import 'dart:isolate';

import 'package:a1_kirim_mobile/main.dart';
import 'package:a1_kirim_mobile/src/data/data_sources/api_service.dart';
import 'package:a1_kirim_mobile/src/data/repositories/item_repository.dart';
import 'package:a1_kirim_mobile/src/data/repositories/unit_type_repository.dart';
import 'package:a1_kirim_mobile/src/domain/models/group.dart';
import 'package:a1_kirim_mobile/src/domain/models/items.dart';
import 'package:a1_kirim_mobile/src/domain/models/market.dart';
import 'package:a1_kirim_mobile/src/domain/models/unit_type.dart';
import 'package:a1_kirim_mobile/src/presentation/blocs/bottom_nav_bar_bloc/bottom_nar_bar_cubit.dart';
import 'package:a1_kirim_mobile/src/presentation/blocs/low_amount_item_bloc/low_amount_item_bloc.dart';
import 'package:a1_kirim_mobile/src/presentation/blocs/markets_list_bloc/markets_list_bloc.dart';
import 'package:a1_kirim_mobile/src/presentation/blocs/nak_for_markets_bloc/nak_for_markets_cubit.dart';
import 'package:a1_kirim_mobile/src/presentation/blocs/notification_bloc/notification_bloc.dart';
import 'package:a1_kirim_mobile/src/presentation/views/home_views/nakladnoylar_for_markets.dart';
import 'package:a1_kirim_mobile/src/presentation/views/notification_views/notification_view.dart';
import 'package:a1_kirim_mobile/src/presentation/widgets/low_amount_items_widgets/low_amount_items_app_bar_widget.dart';
import 'package:a1_kirim_mobile/src/presentation/widgets/low_amount_items_widgets/low_amount_items_widget.dart';
import 'package:a1_kirim_mobile/src/presentation/widgets/market_widgets/market_app_bar_widget.dart';
import 'package:a1_kirim_mobile/src/presentation/widgets/market_widgets/markets_list_widget.dart';
import 'package:a1_kirim_mobile/src/presentation/widgets/notifications_widgets/notification_app_bar_widget.dart';
import 'package:a1_kirim_mobile/src/utils/constants/color_constants.dart';
import 'package:a1_kirim_mobile/src/utils/constants/style_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart';

import '../../../domain/models/item.dart' show Item;

List<Item> getItemsWithIsolate(List<Map<String, dynamic>> itemsMap) {
  List<Item> items = [];
  print("isolate is running...");
  print("in isolate itemsmap.length: ${itemsMap.length}");
  for (var item in itemsMap) {
    print("........................");
    print(item);
    print("........................");
    items.add(Item.fromMap(item));
  }
  return items;
}

class MarketsView extends StatefulWidget {
  const MarketsView({super.key});

  @override
  State<MarketsView> createState() => _MarketsViewState();
}

class _MarketsViewState extends State<MarketsView> {
  int currentIndex = 0;

  List<PreferredSizeWidget> appBars = [
    MarketAppBarWidget(),
    LowAmountItemsAppBarWidget(),
    NotificationAppBarWidget()
    // notifications app bar
  ];
  List<Widget> body = [
    MarketsListWidget(),
    BlocProvider(
      create: (context) => LowAmountItemBloc(),
      child: LowAmountItemsWidget(),
    ),
    BlocProvider(
      create: (context) => NotificationBloc(),
      child: NotificationView(),
    ),
    // notifications app bar
  ];

  @override
  void initState() {
    // before building ui fetch markets and save it locally
    context.read<MarketsListBloc>().add(SetInitialMarketsListEvent());
    getItemsLocally();
    super.initState();
  }
  checkInternet(BuildContext context)async{
    try {
      final result = await InternetAddress.lookup('example.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        print('connected');
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Internetga ulangan",style: TextStyleConstants.successTextStyle,),backgroundColor: ColorConstants.successColor,));
      }
    } on SocketException catch (_) {
      print('not connected');
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Internet mavjud emas",style: TextStyleConstants.errorTextStyle,),backgroundColor: ColorConstants.errorColor,));
    }
  }

  sortByGroup() {
    groups.forEach((group) async {
      List<Item> sortedItems = [];
      sortedItems = await Items.sortByGroupId(items, group.goodsGroupId);
      group.goodsList = sortedItems;
      print("..............................");
      print("groupId: ${group.goodsGroupId}");
      print("goodsList.length: ${group.goodsList?.length}");
    });
  }

  void getItemsLocally() async {
    print("starting getItemsLocally");
    List<Map<String, dynamic>>? itemsAsMap = await database?.query(
      "items",
    );
    // todo open database please
    print("before isolate items.length: ${items.length}");
    print("before isolate itemsmap.length: ${itemsAsMap}");
    items = await Isolate.run(() => getItemsWithIsolate(itemsAsMap!));
    await Future.delayed(Duration(seconds: 5));
    print("after isolate items.length: ${items.length}");
    print(items);
    if (items.length == 0) {
      print("invoke getItems");
      getItems();
    } else {
      sortByGroup();
      // shunchaki tashlab ketish kerak
    }
    print(itemsAsMap);
  }

  void getUnitTypes() async {
    print("in markets view page  get unit types...");
    unitTypes = await UnitTypesRepository(ApiService(Client())).getUnitTypes();
    print("in markets view  unit types: $unitTypes");
  }

  void getItems() async {
    print("starting getItems...");
    items = await ItemRepository(ApiService(Client())).getItems();
    print("items in marketsview initialState(): ${items}");
    sortByGroup();
    print("saving...");
    saveItemsToDb();
    //getItemsLocally();
  }

  @override
  Widget build(BuildContext context) {
    print('markets:');
    print(markets);
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => BottomNarBarCubit(),
        ),
      ],
      child: Builder(builder: (context) {
        return Scaffold(
          resizeToAvoidBottomInset: false,
          backgroundColor: ColorConstants.scaffoldBackgroundColor,
          appBar: appBars[context.watch<BottomNarBarCubit>().state],
          /// bottom nav barga tegilmasin chunki ertaga kerak bolsa kommentdan ochib ishlatib ketish uchun

          // bottomNavigationBar: SizedBox(
          //   height: 70,
          //   child: BlocBuilder<BottomNarBarCubit, int>(
          //     builder: (context, state) {
          //       return BottomNavigationBar(
          //         currentIndex: state.toInt(),
          //         backgroundColor: ColorConstants.primaryWidgetBackgroundColor,
          //         selectedItemColor: ColorConstants.selectedIconColor,
          //         unselectedItemColor: ColorConstants.unselectedIconColor,
          //         onTap: (int index) {
          //           context.read<BottomNarBarCubit>().changeTypeTo(index);
          //           // setState(() {
          //           //   currentIndex = index;
          //           //
          //           // });
          //         },
          //         selectedLabelStyle: TextStyle(
          //             color: ColorConstants.selectedIconColor,
          //             fontWeight: FontWeight.bold),
          //         unselectedLabelStyle: TextStyle(
          //             color: ColorConstants.unselectedIconColor,
          //             fontWeight: FontWeight.normal),
          //         type: BottomNavigationBarType.fixed,
          //         elevation: 0,
          //         items: const [
          //           BottomNavigationBarItem(
          //               label: "Do'konlar",
          //               icon: Icon(Icons.home_outlined),
          //               activeIcon: Icon(Icons.home)),
          //           BottomNavigationBarItem(
          //               label: 'Kam qolganlar',
          //               icon: Icon(Icons.insert_chart_outlined_rounded),
          //               activeIcon: Icon(Icons.insert_chart)),
          //           BottomNavigationBarItem(
          //               label: 'Kirimlar',
          //               icon: Icon(Icons.notifications_on_outlined),
          //               activeIcon: Icon(Icons.notifications_active)),
          //         ],
          //       );
          //     },
          //   ),
          // ),
          drawer: Drawer(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                DrawerHeader(
                    decoration: BoxDecoration(color: Colors.blue),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          sharedPreferences!.getString('name')!,
                          style: TextStyleConstants.appBarTitleStyle
                              ?.copyWith(fontSize: 20),
                        ),
                        Text(
                          "tel: " +
                              sharedPreferences!.getString('phoneNumber')!,
                          style: TextStyleConstants.appBarTitleStyle
                              ?.copyWith(fontSize: 16),
                        ),
                      ],
                    )),
                ListTile(
                  title: const Text('Nakladnoylar'),
                  onTap: () async {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                      return BlocProvider(
                        create: (context) => NakForMarketsCubit(),
                        child: NakladnoylarForMarkets(),
                      );
                    }));
                    // Update the state of the app.
                    // ...
                  },
                ),
              ],
            ),
          ),
          body: body[context.watch<BottomNarBarCubit>().state],
        );
      }),
    );
  }
}

List<Market> markets = [];
List<Group> groups = [];
List<Item> items = [];
List<UnitType> unitTypes = [];
