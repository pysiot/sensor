import 'package:flutter/material.dart';
import 'package:sensor/res/Res.dart';
 
Widget WeatherDetailsHeader(double statusBarHeight, String formattedDateTime) {

  var currDt  = DateTime.now();
 // String formattedDateTime =DateFormat('yyyy-MM-dd \n kk:mm:ss').format(DateTime.now()).toString(); 
  //String _currentDate = Util().getMonth() + ' ' + currDt.day.toString(); //"Noviembre 11, 06:25 AM" + dt;

  String _condition = formattedDateTime; //"Clear Sky";

  String _roundedTemperature = '17°';

  //String _city = "Consumo al";

  return new Container(
    color: Colors.blue,
    child: new Center(
      child: new Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          new Center(
            child: new Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                new Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    new Text(
                      _condition,
                      style: new TextStyle(
                        fontSize: 18.0,
                        color: $Colors.textColorWheatherHeader,
                      ),
                    ),
                    new Text(_roundedTemperature,
                        style: new TextStyle(
                            fontSize: 45.0,
                            color: $Colors.textColorWheatherHeader,
                            fontFamily: "Roboto")),
                  ],
                ),
                new Column(
                  children: <Widget>[
                    new Image.asset('assets/images/sunny.png', width: 80.0, height: 80.0,)
                  ],
                )
              ],
            ),
          )
        ],
      ),
    ),
    padding: new EdgeInsets.only(top: statusBarHeight),
  );
}