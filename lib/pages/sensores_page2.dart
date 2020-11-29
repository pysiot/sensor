
import 'package:flutter/material.dart';
import 'package:sensor/model/create_device_model.dart';
import 'package:sensor/model/sensores_model.dart';
import 'package:sensor/pages/report_page.dart';
import 'package:sensor/pages/sensores_page.dart';
import 'package:sensor/provider/sensores_provider.dart';

import 'package:shared_preferences/shared_preferences.dart';

class SensoresPageDos extends StatefulWidget {
  SensoresPageDos({Key key}) : super(key: key);
  @override
  _SensoresPageDosState createState() => _SensoresPageDosState();
}

class _SensoresPageDosState extends State<SensoresPageDos> {
  TextEditingController _deviceController = TextEditingController();
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  Future<String> _valorShared;
  CreateDeviceModel sensorModel = CreateDeviceModel();
  //bool showListado = false;
  String device = 'x';
  final sensoresProvider = new SensoresProvider();
  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {

    //DBProvider.db.database;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Text('Actividad diaria'),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.restore),
        onPressed: (){ 
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => SensoresPage()));
          },
      ),
      body: Container(
        child: Column(
          children: [
           /* Container(
              height: 130,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Form(
                  key: formKey,
                  child: Container(
                    child: Column(
                      children: [
                        _botonCrearSensor(),                          // _botonCrearReset(),  
                        _txtDevice(),
                      ],
                    ),
                  )),
              ),
              
            ),*/
            Expanded(
              child: Container( 
                child: _listarSensores_porDevice() 
              ),
              flex: 12
            ),
          ],
        ),
      ) 
      // device != "x"  
      // ? 
        
      // :
      
    );
  }

  Widget _listarSensores_porDevice(){   

    return FutureBuilder(
      future: sensoresProvider.getSensorByDevice(), 
      builder: ( BuildContext context, AsyncSnapshot<List<ConsumoModel>> snapshot){
        if ( snapshot.hasData ) {
          final sensores = snapshot.data;          
          return ListView.builder(
            shrinkWrap: true,
            itemCount: sensores.length,
            itemBuilder: (context, i) => _crearItemSensor(context, sensores[i] )
          );
        } else {
          return Center( child: CircularProgressIndicator());
        }
      }
    );
  }

  Widget _crearItemSensor(BuildContext context, ConsumoModel sensor) {

    print('Cantiodad de sensores.....');
    //print(sensor.id);

    if(sensor != null){
      return ListTile( 
        //title: Text('Consumo Las Malvinas'+ Util().getMonth()), //('${ sensor.device } '),
        title: Text('${ sensor.device } : ${ sensor.kwhCalc }' + ' kw.h'),
        subtitle: Text('${ sensor.fechaCalc }'),
        onTap: () => {
          Navigator.push(
              context,
              MaterialPageRoute(
              builder: (context) => new ReportPage(),
          ),)
          },
      );
    }else{
      return ListTile( 
        //title: Text('Consumo Las Malvinas'+ Util().getMonth()), //('${ sensor.device } '),
        title: Text('No existe registros para el dispositivo.'),
        subtitle: Text('Intente registrar un dispositivo activo.'),
        onTap: () => {
          Navigator.push(
              context,
              MaterialPageRoute(
              builder: (context) => null,
          ),)
          },
      );
    }
  }

  Widget _botonCrearReset() {
    return RaisedButton.icon(
      icon: Icon(Icons.restore),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0)
      ),
      color: Colors.greenAccent,
      textColor: Colors.white,
      label: Text("Buscar"),
      onPressed: () {
        new SensoresPage();
      },
    );
  }

/*
  _guardarDevice(String device) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('device', device);

   // String valor = prefs.getString('device');
     print('.......INI.....VALOR DE LA VARIABLE CACHE DEVICE...............');
     print(prefs.getString('device'));
     print('.......FIN....VALOR DE LA VARIABLE CACHE DEVICE..................');
    if ( prefs.getString('device') == null ) {
      prefs.setString('device', device);
      // String valor = prefs.getString('device');
      setState(() {
        device = prefs.getString('device');      
      });
      print('.DASDASDASDASDASD..');
      print(device);
      print('.GGGGGGGGGGGGGGGGGGGGGGGG....');
    }
  }

  Widget _txtDevice() {
    return TextFormField(
      controller: _deviceController,
      decoration: InputDecoration(
        labelText: 'Device:'
      ),
    );
  }

  Widget _botonCrearSensor() {
    return RaisedButton.icon(
      icon: Icon(Icons.save),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0)
      ),
      color: Colors.redAccent,
      textColor: Colors.white,
      label: Text("GUARDAR SENSOR"),
      onPressed: () {
        print(_deviceController.text);
        _guardarDevice(_deviceController.text);
        // if (device != "X" ){
          /* setState(() {
             showListado = true;
           });*/
        // }
        sensorModel.device = "MOD0001";
        sensorModel.fec_registro = "2025-11-28 01:25:56";
        sensorModel.locacion = "MMM";
        sensorModel.servicio = "NN";
        sensoresProvider.createSensor(sensorModel);
      },
    );
  }*/

/*
  _crearListado() {
    return FutureBuilder(
      future: sensoresProvider.getAllSensorMeasures(), //loadDataSensors(), // obtenerSensoresActivos(),
      builder: ( BuildContext context, AsyncSnapshot<List<SensorModel>> snapshot){
        //if ( snapshot.hasData ) {
          final sensores = snapshot.data;
          return ListView.builder(
            itemCount: 1, //sensores.length,
            itemBuilder: (context, i) => _crearItem(context, sensores[i] )
          );
        /*} else {
          return Center( child: CircularProgressIndicator());
        }*/
      }
    );
  }

  Widget _crearItem(BuildContext context, SensorModel sensor) {

    return ListTile( 
      title: Text('Consumo Las Malvinas'+ Util().getMonth()), //('${ sensor.device } '),
      subtitle: Text('3FD1C0'),//'${ sensor.device }'),
      onTap: () => {
        Navigator.push(
            context,
            MaterialPageRoute(
            builder: (context) => new ReportPage(),
        ),)
        },
    );
  }*/

}