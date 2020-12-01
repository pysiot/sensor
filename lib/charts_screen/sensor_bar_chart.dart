import 'dart:math';
// EXCLUDE_FROM_GALLERY_DOCS_END
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

String _urlAWS = 'http://23.20.233.116/api';

final String title = "Gráfico Consumo Anual ";

class SensorBarChart extends StatefulWidget {
  List<charts.Series> seriesList;
  bool animate;

  SensorBarChart(this.seriesList, {this.animate});


  @override
  _SensorBarChartState createState() => _SensorBarChartState();

  // factory SensorBarChart.withLoadData() {
  //   return new SensorBarChart(
  //     _SensorBarChartState()._getConsumoMensual(), 
  //     animate: false);
  // }  
}

class _SensorBarChartState extends State<SensorBarChart> {

  List<DatosConsumoMensual> dataMensual = [];
  List<DatosConsumoAnual> dataAnual     = [];

  List <DatosConsumoAnual> listaAnual;

 @override
  void initState() {
    super.initState();
    _getConsumoMensual().then((value){
    });
    
  }


  Future<List<DatosConsumoAnual>> _obtenerValor() async {

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String cache = prefs.getString('device') ?? 'XX';

   List<DatosConsumoAnual> _data = new List<DatosConsumoAnual>();
    var date = new DateTime.now().toString();
    var dateParse = DateTime.parse(date);
    final url = '$_urlAWS/consumo/listConsumoMensualPorAnio/'+dateParse.year.toString();
    final resp = await http.get(url);
    List<dynamic> decodedData = json.decode(resp.body);// as List;
    if(decodedData.length > 0){      
      for(var i = 0; i < decodedData.length; i++){
        if(decodedData[i] != null){
          Map<String, dynamic> map = decodedData[i];
          _data.add(new DatosConsumoAnual(map['mes_calc'], map['total'] ));
          //print('Total : ${map['total']}');
        }
      }
    }
    setState(() {
      dataAnual = _data;      
      print('Setenado el valor de los valores para los graficos ---> '+dataAnual.toString());
    });    
    //return _data;
  }

  Future<List<DatosConsumoMensual>> _getConsumoMensual() async {

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String deviceInCache = prefs.getString('device') ?? 'XX';

    List<DatosConsumoMensual> _data = new List<DatosConsumoMensual>();
    var date = new DateTime.now().toString();
    var dateParse = DateTime.parse(date);

    //InputParamsMensual cm = new InputParamsMensual(deviceInCache, dateParse.year);
    
    //final url = '$_urlAWS/consumo/listConsumoMensualPorAnio_Device';
    //final resp = await http.get(url);
    final http.Response resp = await http.post(
      '$_urlAWS/consumo/listConsumoMensualPorAnio_Device',
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
    List<DatosConsumoMensual> lista = new List();

    if ( decodedData == null ) return [];
      decodedData.forEach((value) {
      final sensorTemp = DatosConsumoMensual.fromJson(value);
      lista.add(sensorTemp);      
    });
    /*if(decodedData.length > 0){      
      for(var i = 0; i < decodedData.length; i++){
        if(decodedData[i] != null){
          Map<String, dynamic> map = decodedData[i];
          _data.add(new ConsumoAnual(map['mes_calc'], map['total'] ));
          //print('Total : ${map['total']}');
        }
      }
    }*/
    print('SETSTATEtttttttttttt000000000000');
    setState(() {
      dataMensual = lista;      
      print('Setenado el valor de los valores para los graficos ---> '+dataMensual.toString());
    });
    print('Heloooooooo000000000000');
    return lista;
  }

  Future<List<DatosConsumoAnual>> _getConsumoAnual() async {

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String deviceInCache = prefs.getString('device') ?? 'XX';

    List<DatosConsumoAnual> _data = new List<DatosConsumoAnual>();
    var date = new DateTime.now().toString();
    var dateParse = DateTime.parse(date);

    InputParamsMensual cm = new InputParamsMensual(deviceInCache, dateParse.year);
    
    final url = '$_urlAWS/consumo/listConsumoMensualPorAnio_Device/'+dateParse.year.toString();
    
    final resp = await http.get(url);
    List<dynamic> decodedData = json.decode(resp.body);// as List;
    if(decodedData.length > 0){      
      for(var i = 0; i < decodedData.length; i++){
        if(decodedData[i] != null){
          Map<String, dynamic> map = decodedData[i];
          _data.add(new DatosConsumoAnual(map['mes_calc'], map['total'] ));
          //print('Total : ${map['total']}');
        }
      }
    }
    setState(() {
      dataAnual = _data;      
      print('Setenado el valor de los valores para los graficos ---> '+dataAnual.toString());
    });    
    //return _data;
  }

  List<charts.Series<DatosConsumoMensual, String>> _dataConsumoMensual() {

    print('........................INICIANDO llamada a la data de los graficos MENSUAL');    
    print('get data de los valores para los graficos' +dataMensual[0].mes);

    return [
      new charts.Series<DatosConsumoMensual, String>(
        id: 'Sales',
        colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
        domainFn: (DatosConsumoMensual consumo, _) => consumo.mes,
        measureFn: (DatosConsumoMensual consumo, _) => consumo.kwh,
        data: dataMensual,
      )
    ];
  }

  List<charts.Series<DatosConsumoAnual, String>> _dataConsumoAnual() {
    
    print('get data de los valores para los graficos' +dataAnual[0].anio);

    return [
      new charts.Series<DatosConsumoAnual, String>(
        id: 'Sales',
        colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
        domainFn: (DatosConsumoAnual consumo, _) => consumo.anio,
        measureFn: (DatosConsumoAnual consumo, _) => consumo.kwh,
        data: dataAnual,
      )
    ];
  }

  @override
  Widget build(BuildContext context) {
    return new charts.BarChart(
      widget.seriesList,
      animate: widget.animate,
    );
  }
}

class DatosConsumoMensual {
  String mes;
  double kwh;

  DatosConsumoMensual({this.mes = '', 
                       this.kwh = 0.0});
  
  factory DatosConsumoMensual.fromJson(Map<String, dynamic> json) => DatosConsumoMensual(
      mes: json["mes_calc"],
      kwh: json["total"],
  );
}

class DatosConsumoAnual {
  final String anio;
  final double kwh;

  DatosConsumoAnual(this.anio, this.kwh);
}

class InputParamsMensual {
  final String device;
  final int anio;

  InputParamsMensual(this.device, this.anio);
}
