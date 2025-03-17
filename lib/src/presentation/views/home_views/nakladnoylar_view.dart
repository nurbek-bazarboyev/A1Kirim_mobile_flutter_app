import 'package:a1_kirim_mobile/src/data/data_sources/api_service.dart';
import 'package:a1_kirim_mobile/src/domain/models/market.dart';
import 'package:a1_kirim_mobile/src/domain/models/nakladnoy.dart';
import 'package:a1_kirim_mobile/src/domain/models/test_model.dart';
import 'package:a1_kirim_mobile/src/presentation/views/home_views/markets_view.dart';
import 'package:a1_kirim_mobile/src/presentation/views/home_views/nakladnoy_view.dart';
import 'package:a1_kirim_mobile/src/presentation/widgets/market_widgets/ochiq_nakladnoylar_widget.dart';
import 'package:a1_kirim_mobile/src/presentation/widgets/market_widgets/yopiq_nakladnoylar_widget.dart';
import 'package:a1_kirim_mobile/src/presentation/widgets/my_app_bar.dart';
import 'package:a1_kirim_mobile/src/utils/constants/color_constants.dart';
import 'package:a1_kirim_mobile/src/utils/constants/style_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart';

import '../../../data/repositories/local_database_repositories/nakladnoy_repository.dart';
List<TestModel>? ochiqNakladnoylar = [];
List<TestModel>? yopiqNakladnoylar = [];
class NakladnoylarView extends StatefulWidget {
  final String beginDate;
  final String endDate;
  final int rekvisitId;
  final String orgName;

  const NakladnoylarView({super.key, required this.rekvisitId, required this.orgName, required this.beginDate, required this.endDate, });

  @override
  State<NakladnoylarView> createState() => _NakladnoylarViewState();
}

class _NakladnoylarViewState extends State<NakladnoylarView> with SingleTickerProviderStateMixin{

  List<TestModel>? nakladnoylar = [];
  TabController? _tabController;
  bool isLoading = true;
  Market? _market;

  Market getMarket() {
    markets.forEach((mar) {
      if (mar.rekvizitId == widget.rekvisitId) {
        _market = mar;
      } else {
        // shunchaki tashlab ketish kerak
      }
    });
    return _market!;
  }

  @override
  void initState() {

    _tabController = TabController(length: 2, vsync: this);
    getNakladnoylar();
    super.initState();
  }

  getNakladnoylar()async{
    try{
      isLoading = true;
      print("rekvisitId: ${widget.rekvisitId}");
      nakladnoylar = await NakladnoyRepository(ApiService(Client())).getNakladnoysByDateFromServer(rekvizitId: widget.rekvisitId, beginDate: widget.beginDate, endDate: widget.endDate);
      //print("new todays nakladnoy: ${ochiqNakladnoylar?[0].toMap()}");
      ochiqNakladnoylar = [];
      yopiqNakladnoylar = [];
      nakladnoylar!.forEach((nak){
        if(nak.waybillStatus == 1){
          ochiqNakladnoylar?.add(nak);
          print(ochiqNakladnoylar);
        }else{
          yopiqNakladnoylar?.add(nak);
          print(yopiqNakladnoylar);
        }
      });
      setState(() {
        isLoading = false;
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("${ochiqNakladnoylar?[0].toMap()}")));

      });
    }
    catch(e){
      setState(() {
        isLoading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("failed in catch to fetch nakladnoylar exception: ${e.toString()}")));
    }
  }
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      initialIndex: _tabController!.index,
      length: 2,
      child: Scaffold(
        appBar:
        AppBar(
          leading: IconButton(onPressed: (){Navigator.pop(context);}, icon: Icon(CupertinoIcons.back,color: ColorConstants.appBarWidgetsColor,)),
          title: Text("Bugungi nakladnoylar",style: TextStyleConstants.appBarTitleStyle,),
          centerTitle: true,
          backgroundColor: ColorConstants.primaryWidgetBackgroundColor,
          bottom: TabBar(
            dividerColor: Colors.white,
            controller: _tabController,
              labelColor: Colors.white,
              tabs: [
                Tab(text: "Ochiqlar",),
                Tab(text: "Yopiqlar",)
          ]),
        ),
        body: isLoading ? Center(child: CircularProgressIndicator()) : TabBarView(
            controller: _tabController,
            children: [
              OchiqNakladnoylarWidget(orgName: widget.orgName,nakladnoylar: ochiqNakladnoylar, market: getMarket(),),
              YopiqNakladnoylarWidget(orgName: widget.orgName,nakladnoylar: yopiqNakladnoylar, market: getMarket(),)
            ])
      ),
    );
  }
}
/*
{
"map": {
  "waybill": {
    "myArrayList": [
      {
        "waybillId": 54,
        "waybillNumber": "M2025-02-27",
        "waybillDate": "2025-02-27 00:00:00.0",
        "muddat": "2025-02-27 00:00:00.0",
        "summa": 0,
        "rekvizitId": 10,
        "userId": 2,
        "agentId": 2,
        "chekNumber": 0,
        "naqt": 0,
        "plastik": 0,
        "per": 1,
        "soni": 0,
        "waybillType": 1,
        "aptekaId": 1,
        "hodimId": 0,
        "kirimQilinganMahsulotSumma": 0,
        "chegirmaFoiz": 0,
        "chegirmaSumma": 0,
        "soldGoodsList": []
      },
      {
        "waybillId": 55,
        "waybillNumber": "M2025-02-27",
        "waybillDate": "2025-02-27 00:00:00.0",
        "muddat": "2025-02-27 00:00:00.0",
        "summa": 0,
        "rekvizitId": 10,
        "userId": 2,
        "agentId": 2,
        "chekNumber": 0,
        "naqt": 0,
        "plastik": 0,
        "per": 1,
        "soni": 0,
        "waybillType": 1,
        "aptekaId": 1,
        "hodimId": 0,
        "kirimQilinganMahsulotSumma": 0,
        "chegirmaFoiz": 0,
        "chegirmaSumma": 0,
        "soldGoodsList": []
      }
    ]
  },
  "status": 200
  }
}

 */