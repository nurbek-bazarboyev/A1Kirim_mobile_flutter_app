import 'dart:io';
import 'dart:typed_data';

import 'package:a1_kirim_mobile/src/core/utils/date_helper.dart';
import 'package:a1_kirim_mobile/src/core/utils/number_helper.dart';
import 'package:a1_kirim_mobile/src/data/data_sources/api_service.dart';
import 'package:a1_kirim_mobile/src/data/repositories/local_database_repositories/nakladnoy_repository.dart';
import 'package:a1_kirim_mobile/src/domain/models/market.dart';
import 'package:a1_kirim_mobile/src/domain/models/test_model.dart';
import 'package:a1_kirim_mobile/src/presentation/blocs/pdf_view_bloc/pdf_view_bloc.dart';
import 'package:a1_kirim_mobile/src/presentation/utils/dialog_helper.dart';
import 'package:a1_kirim_mobile/src/presentation/views/home_views/markets_view.dart';
import 'package:a1_kirim_mobile/src/presentation/widgets/market_widgets/kirim_of_today_tile_trailing_widget.dart';
import 'package:a1_kirim_mobile/src/presentation/widgets/my_app_bar.dart';
import 'package:a1_kirim_mobile/src/utils/constants/color_constants.dart';
import 'package:a1_kirim_mobile/src/utils/constants/style_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:share_plus/share_plus.dart';

class NakladnoyView extends StatefulWidget {
  final int waybillId;
  final Market? market;
  final TestModel? nakladnoy;
  final String pdfNameAndId;
  const NakladnoyView({super.key, required this.waybillId, required this.pdfNameAndId, required this.market, required this.nakladnoy,});

  @override
  State<NakladnoyView> createState() => _NakladnoyViewState();
}

class _NakladnoyViewState extends State<NakladnoyView> {
  final pdf = pw.Document();
  PDFViewController? pdfViewController;
  File? file;
  String nakJamiSumma = '';
  bool isWaiting = true;
  bool isSuccess = false;
  bool isEmpty = false;
  bool isError = false;
  List<TestNakItems>? listOfNakItems = [];
  Future<String> nakJamiSummaFun()async{
    double _totalSumma = 0.0;

    listOfNakItems?.forEach((item){
      _totalSumma += item.jamiSumma;
    });
    return NumberHelper.printSumma(summaAsDouble: _totalSumma);
  }
  Future<void> writeOnPdf() async{

    nakJamiSumma = await nakJamiSummaFun();
    pdf.addPage(pw.MultiPage(
      pageFormat: PdfPageFormat.a4,
      margin: const pw.EdgeInsets.all(20),
      build: (pw.Context context) {
        return <pw.Widget>[

          pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
            children: [
              pw.Text(
                'Nakladnoy raqami: ${widget.nakladnoy?.wayBillNumber}',
                style: pw.TextStyle(
                  fontSize: 18, // Adjust font size if needed
                  fontWeight: pw.FontWeight.bold, // Optional: Make text bold
                ),
              ),
              pw.Header(level: 1, text: '${DateHelper.formatDate(widget.nakladnoy!.date)}'),
            ]
          ),
          pw.Text(
            'Yetkazib beruvchi: ${widget.market?.orgName}',
            style: pw.TextStyle(
              fontSize: 18, // Adjust font size if needed
              fontWeight: pw.FontWeight.bold, // Optional: Make text bold
            ),
          ),pw.SizedBox(height: 20),
          // pw.Text(
          //   'Direktor: ${widget.market?.direktor}',
          //   style: pw.TextStyle(
          //     fontSize: 18, // Adjust font size if needed
          //     fontWeight: pw.FontWeight.bold, // Optional: Make text bold
          //   ),
          // ),
          // pw.SizedBox(height: 20),
          // pw.Text(
          //   'Tel: ${widget.market?.telefonMain}',
          //   style: pw.TextStyle(
          //     fontSize: 18, // Adjust font size if needed
          //     fontWeight: pw.FontWeight.bold, // Optional: Make text bold
          //   ),
          // ),


          pw.Paragraph(
              text: '''
'''),
          pw.Padding(padding: const pw.EdgeInsets.all(10)),
          if(listOfNakItems?.length != 0)pw.TableHelper.fromTextArray(context: context, data:  <List<String>>[
            <String>['N', 'Mahsulot nomi', 'Soni', "O'lchov birliki", 'Olingan narxi',"Jami summa so'mda"],
            for(int i =0; i<listOfNakItems!.length; i++)<String>["${i+1}", "${listOfNakItems![i].name}", "${NumberHelper.removeLastZero(doubleSon: listOfNakItems![i].soni.toDouble())}"," ${listOfNakItems![i].unitType}", "${NumberHelper.printSumma(summaAsDouble: listOfNakItems![i].summa)}", "${NumberHelper.printSumma(summaAsDouble: listOfNakItems![i].jamiSumma)}" ],
          ]),
          pw.SizedBox(height: 30),
          pw.Header(level: 1, text: "Jami summa: ${nakJamiSumma} so'm"),
          pw.Header(level: 1, text: "Jami summa chegirma bilan: ${NumberHelper.printSumma(summaAsDouble: widget.nakladnoy!.chegirmaBilan)} so'm"),
          pw.Header(level: 1, text: "Chegirma: ${NumberHelper.printSumma(summaAsDouble: widget.nakladnoy!.chegirmaSumma)} so'm"),
          // pw.Header(level: 1, text: 'Nakladnoy sanasi: ${widget.nakladnoy?.date}'),
          // pw.Header(level: 1, text: 'Nakladnoy raqami: ${widget.nakladnoy?.wayBillNumber}')
          // user ning malumotlarini qoysa boladi lekin bu xato bolishi mumkin chunki agar Ahmad kirimni amalga oshirsa lekin
          // Sobirning  profilidan kirib pdf ni olsa unda xodim : Sobir boladi aslida esa Ahmad bolishi kerak edi
          // shu sababdan hodim qismi xozir qoshilmadi agar api da kelsa chiqarish mumkin
          
          
        ];
      },
    ));

  }
  String? fullPath;
  Future<void> savePdf() async
  {
    Directory documentDirectory = await getApplicationDocumentsDirectory();
    String documentPath = documentDirectory.path;
    file = File("$documentPath/${widget.pdfNameAndId}.pdf");

    Uint8List pdfData = await pdf.save();

    await file?.writeAsBytes(pdfData);
  }

  saveAndGetPdf()async{

    await writeOnPdf();
    //await Future.delayed(Duration(seconds: 3));
    await savePdf();

    Directory documentDirectory =
      await getApplicationDocumentsDirectory();

      String documentPath = documentDirectory.path;

      setState(() {
        fullPath = "$documentPath/${widget.pdfNameAndId}.pdf";
        print(fullPath);
        isWaiting = false;
        isSuccess = true;
        print("success boldi");
      });



  }

  shareFile()async{
    if(file == null){
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Sizda pdf mavjud emas iltimos oldin nakladnoyni to'liq holatga keltiring"),backgroundColor: ColorConstants.errorColor,),);
    }else{
      await Share.shareXFiles([XFile(file!.path)], text: "Nakladnoy: ''${widget.market?.orgName}'' uchun\nId: ${widget.nakladnoy?.wayBillId}");
    }

  }

  @override
  void initState() {
    print("market info in pdf view(nakladnoy_view): ${widget.market?.toJson()}");
    print("market info in pdf view(nakladnoy_view): ${widget.market?.toJson()}");
    print("market info in pdf view(nakladnoy_view): ${widget.market?.toJson()}");
    print("market info in pdf view(nakladnoy_view): ${widget.market?.toJson()}");
    print("market info in pdf view(nakladnoy_view): ${widget.market?.toJson()}");
    WidgetsBinding.instance.addPostFrameCallback((_){
      fetchNakladnoyItems();
    });
    super.initState();

  }


  fetchNakladnoyItems()async{
    print("in nakladnoy view fetchNakladnoyItems ...");

    try{

       listOfNakItems = await NakladnoyRepository(ApiService(Client())).getNakladnoyItemsFromServer(waybillId: widget.waybillId);
      print(listOfNakItems);
      // ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("${listOfNakItems?[0].toMap()}"),backgroundColor: ColorConstants.successColor,),);
      setState(() {
        if(listOfNakItems == null||listOfNakItems?.length==0){
          setState(() {
            print("empty boldi");
            isEmpty = true;
            isWaiting = false;
          });
        }else{
          print("saving");
          saveAndGetPdf();
        }

      });
    }catch(e){
      setState(() {
        print("error boldi");
        isWaiting = false;
        isEmpty = false;
        isError = true;
      });
      print("in nakladnoy view fetchNakladnoyItems failed to fetch nakladnoy items exception: ${e.toString()}");
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Iltimos bu oynaga qayta kirib ko'ring!"),backgroundColor: ColorConstants.errorColor,),);
    }


  }
  Future<String> getLocalFilePath() async {
    final directory = await getApplicationDocumentsDirectory();

    return "${directory.path}/${widget.pdfNameAndId}.pdf";
  }
  void myFun(){
    if (file!.existsSync()) {
      print("✅ PDF File Exists: ${file?.path}");
    } else {
      print("❌ PDF File NOT Found!");
    }
  }
  @override
  Widget build(BuildContext context) {

    //
    return Scaffold(
      appBar: MyAppBar(
        leading: IconButton(onPressed: (){Navigator.pop(context,'back');}, icon: Icon(CupertinoIcons.back,color: ColorConstants.appBarWidgetsColor,)),
        title: Text("Nakladnoy PDF",style: TextStyleConstants.appBarTitleStyle,),
        actions: [
          IconButton(onPressed: shareFile, icon: Icon(Icons.share,color: ColorConstants.appBarWidgetsColor,))
        ],
      ),
      body: isWaiting ? Center(child: CircularProgressIndicator())
          : (isEmpty ? Center(child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text("Mahsulot qo'shilmagan",style: TextStyleConstants.errorTextStyle,),
          Text( "Oldin nakladnoyga mahsulot qo'shing",style: TextStyleConstants.listTileSubTitleStyle,)
        ],
      ),) : (isError ? Center(child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text("Server bilan xatolik sodir bo'ldi",style: TextStyleConstants.errorTextStyle,),
          Text( "Iltimos boshqattan kirib ko'ring",style: TextStyleConstants.listTileSubTitleStyle,)
        ],
      ),) : (isSuccess ? PDFView(
        filePath: fullPath,
        enableSwipe: true,
        swipeHorizontal: false,
        autoSpacing: true,
        pageFling: true,
        onError: (error) {
          print("❌ PDF View Error: $error");
        },
        onPageError: (page, error) {
          print("❌ Page Load Error on Page $page: $error");
        },
      ) : Center(child: Text("Nomalum xatolik yuz berdi",style: TextStyleConstants.listTileSubTitleStyle,),) ) ) )


    );
  }
}
