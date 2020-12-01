//import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:sensor/model/ConsumoMensual.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ConsumoMensualHomePage extends StatefulWidget {
  @override
  _ConsumoMensualHomePageState createState() {
    return _ConsumoMensualHomePageState();
  }
}

class _ConsumoMensualHomePageState extends State<ConsumoMensualHomePage> {
  List<charts.Series<ConsumoMensual, String>> _seriesBarData;
  List<ConsumoMensual> mydata;

  List<ConsumoMensual> dataMensual = [];
  
  _generateData(mydata) {
    _seriesBarData = List<charts.Series<ConsumoMensual, String>>();
    _seriesBarData.add(
      charts.Series(
        domainFn: (ConsumoMensual ConsumoMensual, _) => ConsumoMensual.saleYear.toString(),
        measureFn: (ConsumoMensual ConsumoMensual, _) => ConsumoMensual.saleVal,
        colorFn: (ConsumoMensual ConsumoMensual, _) =>
            charts.ColorUtil.fromDartColor(Color(0xff109618)),
        id: 'ConsumoMensual',
        data: mydata,
        labelAccessorFn: (ConsumoMensual row, _) => "${row.saleYear}",
      ),
    );
  }
  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Consumo Mensual'),
        backgroundColor: Colors.blue,
        ),
      body: _buildBody(context),
    );
  }

  Widget _buildBody(BuildContext context) {
    return FutureBuilder(
      future: _getConsumoMensual(), //Firestore.instance.collection('ConsumoMensual').snapshots(),
      builder: (context, AsyncSnapshot<List<ConsumoMensual>> snapshot){
      //builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return LinearProgressIndicator();
        } else {
          final cm = snapshot.data; 
          return _buildChart(context, cm);
        }
      },
    );
  }

  Widget _buildChart(BuildContext context, List<ConsumoMensual> saledata) {
    mydata = saledata;
    _generateData(mydata);
    return Padding(
      padding: EdgeInsets.all(8.0),
      child: Container(
        child: Center(
          child: Column(
            children: <Widget>[
              Text(
                'CONSUMO DE KW.H POR MES',
                style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold, color: Colors.purple,),
              ),
              SizedBox(
                height: 10.0,
              ),
              Expanded(
                child: charts.BarChart(_seriesBarData,
                    animate: true,
                    animationDuration: Duration(seconds:5),
                     behaviors: [
                      new charts.DatumLegend(
                        entryTextStyle: charts.TextStyleSpec(
                            color: charts.MaterialPalette.purple.shadeDefault,
                            //fontFamily: 'Georgia',
                            fontSize: 12),
                      )
                    ],
                  ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<List<ConsumoMensual>> _getConsumoMensual() async {

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String deviceInCache = prefs.getString('device') ?? 'XX';

    List<ConsumoMensual> _data = new List<ConsumoMensual>();
    var date = new DateTime.now().toString();
    var dateParse = DateTime.parse(date);

    final http.Response resp = await http.post(
      'http://23.20.233.116/api/consumo/listConsumoMensualPorAnio_Device',
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'device': deviceInCache,
        'anio': dateParse.year.toString()
      }),
    );
    
    List<dynamic> decodedData = json.decode(resp.body);// as List;
    print(' [CONSUMO_MENSUAL ] Cantidad de regisytros encontrados  '+decodedData.length.toString());
    List<ConsumoMensual> lista = new List();

    if ( decodedData == null ) return [];
      decodedData.forEach((value) {
      final sensorTemp = ConsumoMensual.fromJson(value);
      lista.add(sensorTemp);      
    });
    // print('SETSTATEtttttttttttt000000000000');
    // setState(() {
    //   dataMensual = lista;      
    //   print('Setenado el valor de los valores para los graficos ---> '+dataMensual.toString());
    // });
    print('<<<<<<<<<<<<<< Data cargada.......');
    return lista;
  }

  
}
/*
class DatosConsumoMensual {
  String mes;
  double kwh;
  String colorVal;

  DatosConsumoMensual({this.mes = '', 
                       this.kwh = 0.0,
                       this.colorVal = '0xff1109618'});
  
  factory DatosConsumoMensual.fromJson(Map<String, dynamic> json) => DatosConsumoMensual(
      mes: json["mes_calc"],
      colorVal : json["colorVal "],
      kwh: json["total"],
  );
}*/