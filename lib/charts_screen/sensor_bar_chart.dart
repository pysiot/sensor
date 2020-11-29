import 'dart:math';
// EXCLUDE_FROM_GALLERY_DOCS_END
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
class ConsumoAnual {
  final String anio;
  final double consumo;

  ConsumoAnual(this.anio, this.consumo);
}


String _urlAWS = 'http://23.20.233.116/api';

final String title = "Gráfico Consumo Anual ";


class SensorBarChart extends StatefulWidget {
  List<charts.Series> seriesList;
  bool animate;

  SensorBarChart(this.seriesList, {this.animate});

  @override
  _SensorBarChartState createState() => _SensorBarChartState();

  factory SensorBarChart.withLoadData() {
    
    return new SensorBarChart(
      _SensorBarChartState()._dataConsumoAnual(),
      animate: false,);
    
  }  
}

class _SensorBarChartState extends State<SensorBarChart> {

List<ConsumoAnual> data1 = [];
  List <ConsumoAnual> listaAnual;

  Future<List<ConsumoAnual>> _obtenerValor() async {
   List<ConsumoAnual> _data = new List<ConsumoAnual>();
    var date = new DateTime.now().toString();
    var dateParse = DateTime.parse(date);
    final url = '$_urlAWS/consumo/listConsumoMensualPorAnio/'+dateParse.year.toString();
    final resp = await http.get(url);
    List<dynamic> decodedData = json.decode(resp.body);// as List;
    if(decodedData.length > 0){      
      for(var i = 0; i < decodedData.length; i++){
        if(decodedData[i] != null){
          Map<String, dynamic> map = decodedData[i];
          _data.add(new ConsumoAnual(map['mes_calc'], map['total'] ));
          //print('Total : ${map['total']}');
        }
      }
    }
    setState(() {
      data1 = _data;      
      print('Setenado el valor de los valores para los graficos ---> '+data1.toString());
    });    
    //return _data;
  }

  List<charts.Series<ConsumoAnual, String>> _dataConsumoAnual() {
    
    print('get data de los valores para los graficos' +data1[0].anio);

    return [
      new charts.Series<ConsumoAnual, String>(
        id: 'Sales',
        colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
        domainFn: (ConsumoAnual consumo, _) => consumo.anio,
        measureFn: (ConsumoAnual consumo, _) => consumo.consumo,
        data: data1,
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

