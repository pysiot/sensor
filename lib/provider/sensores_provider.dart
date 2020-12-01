import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:sensor/model/create_device_model.dart';

import 'package:sensor/model/sensores_model.dart';
import 'package:sensor/provider/db_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SensoresProvider {

  String _url    = 'https://energy-meter-teca.firebaseio.com';
  
  String _urlAWS = 'http://23.20.233.116/api';

  // http://23.20.233.116/api/device/create
/*
  Future<List<SensorModel>> getAllSensorMeasures() async {

    final url = '$_url/sensor.json';
    final resp = await http.get(url);
    
    final Map<String, dynamic> decodedData = json.decode(resp.body);
    final List<SensorModel> sensores = new List();

    if ( decodedData == null ) return [];

    int i = 0;
    decodedData.forEach((id, sensor) {
      //i = i + 1;
      final sensorTemp = SensorModel.fromJson(sensor);
      //sensores.add(sensorTemp);
      sensores.add(sensorTemp);
      
    });
    return sensores;
  }*/

  Future<bool> createSensor( CreateDeviceModel sensor) async {

    print('Registrando SqlLite Dispositivo: ' +sensor.device);    
    DBProvider.db.insertarDevice(sensor);   //Insertando a SQLLite
   
    /*final url = '$_urlAWS/device/create';
    final resp = await http.post(url, body: createDeviceModelToJson(sensor) );
    final decodedData = json.decode(resp.body);
    print('------------------------------');
    print(sensor.device);
    print(sensor.fec_registro);
    print(sensor.locacion);
    print(sensor.servicio);
    print('------------------------------');
    print(decodedData);*/
    return true;
  }

  Future<List<ConsumoModel>> getSensorByDevice() async {
    
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String cache = prefs.getString('device') ?? 'XX';

    print(' ********************** Datos en el Cache => '+cache);

    //String codDevice = await DBProvider.db.buscarDevice() ;
    
    //print('Resultado de busqueda de dispositivos enSQLLITE  => '+codDevice);
    final url = '$_urlAWS/consumo/list/' + cache;
    // if (codDevice == 'S/D' || codDevice == null || codDevice == '' ){
    //   url = '$_urlAWS/consumo/list/' + cache;
    // }else {
    //  url = '$_urlAWS/consumo/list/' + codDevice; 
    // }
    //'3FD1C0'; //idDevice;
    final resp = await http.get(url);
    
    final List<dynamic> decodedData = json.decode(resp.body);

    print('Cantidad de Registros encontrados para el dispositivo: '+decodedData.length.toString());

    List<ConsumoModel> sensores = new List();
    
    // if ( decodedData != null ) {
    //   decodedData.forEach((sensor) {
    //     final sensorTemp = ConsumoModel.fromJson(sensor);
    //     sensores.add(sensorTemp);      
    //   });
    //}
    if ( decodedData == null ) return [];
    decodedData.forEach((sensor) {
      final sensorTemp = ConsumoModel.fromJson(sensor);
      sensores.add(sensorTemp);      
    });
    print('Valores de Sensores: '+sensores.toString());
    return sensores;
  }

  
  // Este hace todo el proceso de carga
  /*Future<SensorModel> loadDataSensors() async {

    print(':::::: 1.1 :::::: LLamando funcion LISTA SENSORES ACTIVOS');

    final url = '$_url/sensor.json';
    final resp = await http.get(url);
    
    final Map<String, dynamic> decodedData = json.decode(resp.body);


    print('Cantidad de registros del json'+decodedData.toString());
    /* INSERTAR a la BD de SensorMeasureModel */
    decodedData.forEach((id, sensor) {
      final sensorTemp = SensorMesasureModel.fromJson(sensor);
      //sensorTemp.id = id;
      print(sensorTemp);
      DBProvider.db.insertarSensorMeasure(sensorTemp);
    });

    /* Cargando la nueva tabla con los calculos */
    List<SensorMesasureModel> listSensor = new List();
    listSensor = await DBProvider.db.listaMedidaSensores('3FD1C0');

    int cantPulsosINI = 0;
    int kwh = 1600;
    String fecha = '';
    for(int i=0; i < listSensor.length; i++ ){

      int calcPLS = 0;
      double calcKWH = 0.0;
      if(i==0){
        calcPLS = listSensor[i].pulsos - 0;        
      }else{
        calcPLS = listSensor[i].pulsos - cantPulsosINI;
      }
      calcKWH = calcPLS / kwh;      
      fecha = fechaRegistro(listSensor[i].tiempo);

      DBProvider.db.insertarSensorMeasureCal( listSensor[i].id,
                                              listSensor[i].device,
                                              listSensor[i].datos,
                                              calcPLS,
                                              listSensor[i].bateria,
                                              listSensor[i].debug,
                                              fecha,
                                              calcKWH,
                                              nombreMes(nroFecha(fecha, 'MES')),
                                              nroFecha(fecha, 'ANIO') );
      cantPulsosINI = calcPLS;

    }
    /* Limpiar las tablas SensorMeasureModel antes de cargar */
    DBProvider.db.deleteAllSensorMeasures();

    /* Cargando la nueva tabla con los calculos */
    List<SensorMesasureCalcModel> listSensorCalc = new List();
    listSensorCalc = await DBProvider.db.listaMedidaSensoresCalc();

    print('<<<<2>>>> Nro de Registros almacenados de sensor: '+ listSensorCalc.length.toString());
    print('<<<<2>>>> ID 1: '+ listSensorCalc[2].id.toString());
    print('<<<<2>>>> KWH 1: '+ listSensorCalc[2].kwh.toString());
    print('<<<<2>>>> Calc Pls 1: '+ listSensorCalc[2].pulsos.toString());
    print('<<<<2>>>>> FECHA 1: '+ listSensorCalc[2].fecha.toString());
    print('<<<<2>>>>> MES 1: '+ listSensorCalc[2].mes.toString());
    print('<<<<2>>>>> ANIO 1: '+ listSensorCalc[2].anio.toString());
    
  } 
*/
  // Future<List<SensorMesasureModel>> obtenerSensoresActivos() async {

  //   print('obtenerSensoresActivos');
  //   return DBProvider.db.listaMedidaSensores();
  //   //return []; //DBProvider.db.getAllSensors();
  // }  


  String fechaRegistro(int tmValue){

    String result = "";
    final DateFormat formatter = new DateFormat('yyyy-MM-dd hh:mm:ss');
    result = formatter.format(new DateTime.fromMillisecondsSinceEpoch(tmValue*1000));
    return result;
  } 

  double calculoConsumo(int valInicial, int valConsumo){
    /* 1600 pls => 1KW.H  */
    int conversionPulsos = 1600;

  }

  int nroFecha(String fecha, String dat){
    

    var date = DateTime.parse(fecha);
    int result = 0;

    if(dat =="MES"){
      result = date.month;
    }
    if(dat =="ANIO"){
      result = date.year;
    }
    return result;
  }

  String nombreMes(int mes){
    
    String nombreMes = "";

    switch (mes) {
      case 1:
        return nombreMes = "ENERO";
        break;
      case 2:
        return nombreMes = "FEBRERO";
        break;
      case 3:
        return nombreMes = "MARZO";
        break;
      case 4:
        return nombreMes = "ABRIL";
        break;
      case 5:
        return nombreMes = "MAYO";
        break;
      case 6:
        return nombreMes = "JUNIO";
        break;
      case 7:
        return nombreMes = "JULIO";
        break;
      case 8:
        return nombreMes = "AGOSTO";
        break;
      case 9:
        return nombreMes = "SETIEMBRE";
        break;
      case 10:
        return nombreMes = "OCTUBRE";
        break;
      case 11:
        return nombreMes = "NOVIEMBRE";
        break;
      case 12:
        return nombreMes = "DICIEMBRE";
        break;
  }

  }


}


    // double consumoMesAcumulado = 0.0;
    // int mes = 0;
    // for(int j=0; j < listSensorCalc.length; j++ ){

    //   // Logica para sumar los consumes del mes
      
    //   if(mes != nroFecha(listSensorCalc[j].fecha, 'MES') ){
    //     consumoMesAcumulado = consumoMesAcumulado + listSensorCalc[j].kwh;
    //   }else{
    //     MonthMeasureModel month = new MonthMeasureModel();
    //     month.id = listSensorCalc[j].id;
    //     month.anio = nroFecha(listSensorCalc[j].fecha, 'ANIO');
    //     month.mes = nombreMes(nroFecha(listSensorCalc[j].fecha, 'MES'));
    //     month.consumo = consumoMesAcumulado;

    //     DBProvider.db.insertarMonthMeasure(month);

    //     consumoMesAcumulado = 0.0;
    //   }

    //   mes = nroFecha(listSensorCalc[j].fecha, 'MES');

    // }