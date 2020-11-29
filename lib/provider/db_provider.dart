import 'dart:convert';
import 'dart:io';

import 'package:path/path.dart';
import 'package:sensor/model/create_device_model.dart';

import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';

class DBProvider {

  static Database _database;
  //_ () :Significa que se hace referencia a un constructor privado
  static final DBProvider db = DBProvider._();
  DBProvider._();

  Future<Database> get database async {
    print(':::::: 1.1.2 :::::: CREACION DE BD Sensor.db, VALIDACIÒN DE EXISTENCIA.....');    
    if ( _database != null ) return _database;
    _database = await initDB();
    //print(':::::: 1.1.2.val :::::: >>>>>'+_database.toString());
    return _database;
  }

  Future<Database> initDB() async {
    //path donde se almacenará la BD
    Directory documentDirectory = await getApplicationDocumentsDirectory();
    final path = join(documentDirectory.path, 'SensorDB.db' );
   // print('PATH BD : '+ path);
    return await openDatabase(
      path,
      version: 1,
      onOpen: (db) { },
      onCreate: (Database db, int version) async {
        //print(':::::: 1.1.2.1 :::::: Creaciòn de tablas sensor_measures');
        await db.execute('''
          CREATE TABLE device (
          id INTEGER PRIMARY KEY AUTOINCREMENT, device TEXT, locacion TEXT, servicio TEXT, fec_registro)
        ''');
        /*await db.execute('''
          CREATE TABLE sensor_measures (
          id INTEGER PRIMARY KEY autoincrement, device TEXT, datos TEXT, pulsos INTEGER, bateria INTEGER, debug TEXT, tiempo INTEGER )
        ''');  
        await db.execute('''
          CREATE TABLE sensor_measure_calcs (
          id INTEGER PRIMARY KEY, device TEXT, datos TEXT, pulsos INTEGER, bateria INTEGER, debug TEXT, fecha TEXT, kwh REAL, mes TEXT, anio INTEGER )
        ''');*/
      },
        
    );
    
  }

  insertarDevice(CreateDeviceModel nuevo) async {

    final db  = await database;
    int count = Sqflite
        .firstIntValue(await db.rawQuery('SELECT COUNT(*) FROM device'));
    if(count > 0){ 
      await db.delete('device');   
      final res = await db.insert('device', nuevo.toJson());
     // final ssss = await db.rawQuery('SELECT * FROM device;');
      print('Eliminó registro anterior y almacenó Exitosamente en SQLLite => ID: ' + res.toString());
      return res;      
    } else{
      final res = await db.insert('device', nuevo.toJson());
      print('Sensor registrado Exitosamente en SQLLite => ID: ' + res.toString());
      return res;
    }   
  }

  Future<String> buscarDevice() async {

    String result = 'S/D';
    final db  = await database;

    int count = Sqflite.firstIntValue(await db.rawQuery('SELECT COUNT(*) FROM device'));
    if(count > 0){
      final res = await db.rawQuery('SELECT device FROM device;');
      result = res[0]['device'];
    }     
    print('***** SQLLITE ****');
    print(result);
    print('***** SQLLITE ****');   
    return result;
  }

  /* Insertando items de registros Api Rest JSON *//*
  insertarSensorMeasure(SensorMesasureModel nuevoMeasure) async {

    final db  = await database;
    final res = await db.insert('sensor_measures', nuevoMeasure.toJson());
    return res;
  }


  /* Insertando de la tabla sensor_measures co ls datos calculados */
  insertarSensorMeasureCal(int id, String dvc, String dts, int pls, 
  int btr, String dbg, String fec, double kwh, String mes, int anio) async {

    print('id: '+id.toString() +' Device: '+dvc+' pls: '+pls.toString()+' btr: '+btr.toString()+' Fecha: '+fec +' KWH: '+kwh.toString()+' Mes: '+mes+' ANIO: '+anio.toString());
    SensorMesasureCalcModel smc = new SensorMesasureCalcModel();
    smc.id = id;
    smc.device = dvc;
    smc.datos = dts;
    smc.pulsos = pls;
    smc.bateria = btr;
    smc.debug = dbg;
    smc.fecha = fec;
    smc.kwh = kwh;
    smc.mes = mes;
    smc.anio = anio;

    final db  = await database;
    final res = await db.insert('sensor_measure_calcs', smc.toJson());

    print('Pintando resultados de los registros de Medidad de sensor: '+res.toString());

    return res;
  }
 
  /* Lista de consumo por año */
  Future<List<SensorMesasureModel>> listaMedidaSensores(String nameDevice) async {

    final db  = await database;

    //final res = await db.query('year_measures'); 
    final res = await db.rawQuery('SELECT * FROM sensor_measures WHERE device = ? ORDER BY tiempo ASC ;');

    print('>>>>>>>>>>>>>>>  DELETEMEEEEEEE'+res.length.toString());
    List<SensorMesasureModel> list = res.isNotEmpty 
                                  ? res.map((m) => SensorMesasureModel.fromJson(m)).toList()
                                  : [];

    return list;
  
  }

  Future<List<SensorMesasureCalcModel>> listaMedidaSensoresCalc() async {

    final db  = await database;
    final res = await db.rawQuery('SELECT * FROM sensor_measure_calcs ORDER BY id DESC ');
    List<SensorMesasureCalcModel> list = res.isNotEmpty 
                                  ? res.map((m) => SensorMesasureCalcModel.fromJson(m)).toList()
                                  : [];
    return list; 
  }

  Future<List<ConsumoAnualModel>> promedioPorAnio() async{

    final db  = await database;
    final res = await db.rawQuery(''' 
          SELECT anio, kwh FROM sensor_measure_calcs DESC 
      ''');
    //SELECT anio, SUM(kwh) FROM sensor_measure_calcs GROUP BY anio ORDER BY SUM(kwh) DESC 
    print('Data de BD  PROMEDIO POR AÑO'+res.length.toString());

    List<ConsumoAnualModel> list = res.isNotEmpty 
                                  ? res.map((m) => ConsumoAnualModel.fromJson(m)).toList()
                                  : [];
    return list;
  }

  Future<List<ConsumoMensualModel>> promedioPorMesAnio(int anio) async {

    final db  = await database;
    final res = await db.rawQuery(
      ''' SELECT mes, SUM(kwh) 
          FROM sensor_measure_calcs
          WHERE anio = ?
          GROUP BY mes ORDER BY SUM(kwh) DESC 
      '''); 

    List<ConsumoMensualModel> list = res.isNotEmpty 
                                  ? res.map((m) => ConsumoMensualModel.fromJson(m)).toList()
                                  : [];
    //print(list[0].) 
    return list;
  }

  // DELETE ALL  
  Future<int> deleteAllSensorMeasures() async {
    final db  = await database;
    final res = await db.rawDelete('DELETE FROM sensor_measures');
    return res;
  }
*/


}