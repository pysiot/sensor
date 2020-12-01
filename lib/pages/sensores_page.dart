
import 'package:flutter/material.dart';
import 'package:sensor/model/create_device_model.dart';
import 'package:sensor/pages/sensores_page2.dart';
import 'package:sensor/provider/sensores_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SensoresPage extends StatefulWidget {
  SensoresPage({Key key}) : super(key: key);
  @override
  _SensoresPageState createState() => _SensoresPageState();
}

class _SensoresPageState extends State<SensoresPage> {
  TextEditingController _deviceController = TextEditingController();
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  CreateDeviceModel sensorModel = CreateDeviceModel();
  final sensoresProvider = new SensoresProvider();
  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Text('Buscar Sensor'),
      ),
      /*floatingActionButton: FloatingActionButton(
        child: Icon(Icons.restore),
        onPressed: (){
          print('¿ Qué boton presionaste ?');
          setState(() {
            showListado = true;
          });
          //_guardarDevice('F3D1C0');
        },
      ),*/
      body: Container(
        child: Column(
          children: [
            Container(
              height: 130,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Form(
                  key: formKey,
                  child: Container(
                    child: Column(
                      children: [                                                 // _botonCrearReset(),  
                        _txtDevice(),
                        _botonCrearSensor(), 
                      ],
                    ),
                  )),
              ),
              
            ),
            /*Expanded(
              child: Container( 
                child: null //_listarSensores_porDevice()   AQUI LLAMA AL LISTADO
              ),
              flex: 12
            ),*/
          ],
        ),
      ) 
    );
  }

  Widget _txtDevice() {
    return TextFormField(
      autofocus: true,
      controller: _deviceController,
      decoration: InputDecoration(
        hintText: '...',
        labelText: 'Código:',
        suffixIcon: IconButton(
          onPressed: () => _deviceController.clear(),
          icon: Icon(Icons.clear),
        ),
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
      label: Text("REGISTRAR"),
      onPressed: () {
        print ('Valor caja texto>>>>'+_deviceController.text.toUpperCase());
        _guardarDevice(_deviceController.text.toUpperCase());
        sensorModel.device = _deviceController.text.toUpperCase();
        sensorModel.fecRegistro = "2025-11-28 01:25:56";
        sensorModel.locacion = "MMM";
        sensorModel.servicio = "NN";
        sensoresProvider.createSensor(sensorModel);
        _deviceController.clear();
        Navigator.push(context, MaterialPageRoute(builder: (context) => SensoresPageDos()));
      },
    );
  }
  
  _guardarDevice(String device) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('device', device);
  }

 /* Widget _crearItemSensor(BuildContext context, ConsumoModel sensor) {
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
  }*/
  /*Widget _botonCrearReset() {
    return RaisedButton.icon(
      icon: Icon(Icons.restore),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0)
      ),
      color: Colors.greenAccent,
      textColor: Colors.white,
      label: Text("RESET"),
      onPressed: () {

      },
    );
  }
  
  Widget _listarSensores_porDevice(){

    return FutureBuilder(
      future: sensoresProvider.getSensorByDevice(), //loadDataSensors(), // obtenerSensoresActivos(),
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
  */



}  

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


