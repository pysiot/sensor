
import 'package:flutter/material.dart';
import 'package:sensor/model/create_device_model.dart';
import 'package:sensor/model/sensores_model.dart';
import 'package:sensor/pages/sensores_page.dart';
import 'package:sensor/provider/sensores_provider.dart';

import 'package:shared_preferences/shared_preferences.dart';

import 'consumo_report_page.dart';

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
  String _deviceInCache = '';
  final sensoresProvider = new SensoresProvider();
  final formKey = GlobalKey<FormState>();

  Future _getDeviceInCache() async{

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String cache = prefs.getString('device') ?? '';

    setState(() {
      _deviceInCache = cache;
    });
  }

 @override
  void initState() {
    _getDeviceInCache().then((value){
      print('Device in cache.');
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    //DBProvider.db.database;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Text('Consumo Diario'),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.redAccent,
        child: Icon(Icons.search),
        onPressed: (){ 
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => SensoresPage()));
          },
      ),
      body: Container(
        child: Column(
          children: [
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
      future: sensoresProvider.getSensorByDevice() ?? null, 
      builder: ( BuildContext context, AsyncSnapshot<List<ConsumoModel>> snapshot){
        
        if ( !snapshot.hasData) {
          return Center( child: CircularProgressIndicator());
        }else{
          final sensores = snapshot.data;          
          return ListView.builder(
            shrinkWrap: true,
            itemCount: sensores.length,
            itemBuilder: (context, i) => _crearItemSensor(context, sensores[i] )
          );
        }
       /* else if (snapshot.hasError)  {
          return Text("ERROR: ${snapshot.error}");
        }
         else {
          return ListView.builder(
            shrinkWrap: true,
            itemCount: 1,
            itemBuilder: (context, i) => _crearItemSensorSinData(context)
          );
         // return Text('None');
          //return Center( child: CircularProgressIndicator());
        }*/
        
      }
    );
  }

  Widget _crearItemSensor(BuildContext context, ConsumoModel sensor) {

    print(' ------------------------------------ QTY de SENSORES.....'+sensor.device);

      if(sensor.device != '' || sensor.device != null){
        return ListTile( 
          leading: Icon(Icons.info),
          title: new Text('${ sensor.device } : ${ sensor.kwhCalc }' + ' kw.h'),
          subtitle: Text('${ sensor.fechaCalc }'),
          trailing: Icon(Icons.launch),
          onTap: () => {
            Navigator.push(
                context,
                MaterialPageRoute(
                builder: (context) => new ConsumoMensualHomePage(), //ReportPage(),
            ),)
            },
        );
      }else{
        return ListTile( 
          //title: Text('Consumo Las Malvinas'+ Util().getMonth()), //('${ sensor.device } '),
          title: Text('No existe registros para el dispositivo ' +_deviceInCache),
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
  Widget _crearItemSensorSinData(BuildContext context) {

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
}