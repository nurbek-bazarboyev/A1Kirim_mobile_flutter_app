import 'package:a1_kirim_mobile/src/presentation/views/home_views/login_view.dart';
import 'package:a1_kirim_mobile/src/presentation/views/home_views/markets_view.dart';
import 'package:a1_kirim_mobile/src/presentation/views/home_views/nakladnoy_view.dart';
import 'package:a1_kirim_mobile/src/presentation/views/test_views/test_view.dart';
import 'package:a1_kirim_mobile/src/utils/constants/sql_constants.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';
SharedPreferences? sharedPreferences;
Database? database;
void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  var databasesPath = await getDatabasesPath();
  String path = join(databasesPath, SqlContants.kirimDb);
  database = await openDatabase(path, version: 1,
      onCreate: (Database db, int version) async {
        // When creating the db, create the table
        await db.execute('''
            CREATE TABLE ${SqlContants.itemsTable} (
              goodsId INTEGER PRIMARY KEY,
              goodsGroupId INTEGER,
              articul TEXT,
              name TEXT,
              nameChek TEXT,
              unitType TEXT,
              unitTypeId INTEGER,
              status INTEGER,
              foiz INTEGER,
              checkByUser INTEGER,
              summa REAL,
              plastikSumma REAL,
              AptekaId INTEGER,
              pachkaSoni REAL,
              qoldiq REAL,
              temp REAL,
              shb REAL,
              countConvert INTEGER
            )
            ''');
        await db.execute('''
            CREATE TABLE ${SqlContants.kirimlarTable} (
              kirimId INTEGER PRIMARY KEY,
              goodsId INTEGER,
              name TEXT,
              articul TEXT,
              orgName TEXT,
              unit TEXT,
              rekvizitId INTEGER,
              kelganSana TEXT,
              yaroqlilikMuddati TEXT,
              seriyaRaqam TEXT,
              soni REAL,
              status INTEGER,
              summa REAL,
              waybillId INTEGER,
              waybillNumber TEXT,
              unitId INTEGER,
              sotuvSumma REAL,
              ustamaFoiz REAL
            )
            ''');
        await db.execute('''
            CREATE TABLE ${SqlContants.nakladnoylarTable} (
              rekvizitIdAndSana INTEGER PRIMARY KEY,
              rekvizitId INTEGER,
              userId INTEGER,
              sana TEXT,
              status INTEGER,
              waybillId INTEGER,
              waybillNumber TEXT,
              summa REAL
            )
            ''');
        await db.execute('''
            CREATE TABLE ${SqlContants.dukonlarTable} (
              rekvizitId INTEGER PRIMARY KEY,
              klientAndPostavchikId INTEGER,
              orgName TEXT,
              address TEXT,
              telefonMain TEXT,
              bankId INTEGER,
              inn INTEGER,
              isGazna INTEGER,
              direktor TEXT,
              jamiSumma REAL,
              olganSumma REAL,
              berganSumma REAL,
              olishimKerakBulganSumma REAL,
              barishimKerakBulganSumma REAL,
              mfo INTEGER,
              hisobRaqamId INTEGER,
              qarzdorId INTEGER,
              tumanId INTEGER,
              aptekaId INTEGER,
              qarzdorningQarzQiymati REAL,
              qarzdorningQanchaBergani REAL,
              totalBalance REAL
            )
            ''');
        await db.execute('''
            CREATE TABLE ${SqlContants.guruhlarTable} (
              goodsGroupId INTEGER PRIMARY KEY,
              groupName TEXT,
              code INTEGER,
              id INTEGER
            )
            ''');
      });


  sharedPreferences = await SharedPreferences.getInstance();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(

        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: LoginView(),
    );
  }
}