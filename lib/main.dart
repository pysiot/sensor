import 'package:flutter/material.dart';
import 'package:sensor/Constant/Constant.dart';
import 'package:sensor/Screens/SplashScreen.dart';
import 'package:sensor/home_widget.dart';
import 'package:sensor/pages/sensores_page.dart';
import 'package:sensor/pages/sensores_page2.dart';

main() {

  runApp(new MaterialApp(
    debugShowCheckedModeBanner: false,
    theme: new ThemeData(
      accentColor: Colors.black,
      primaryColor: Colors.black,
      primaryColorDark: Colors.black

    ),
    home: new SplashScreen(),
    routes: <String, WidgetBuilder>{
      //HOME: (BuildContext context) => new Home(),
      SENSORES : (BuildContext context) => new SensoresPage(),
      SENSORES_CACHE : (BuildContext context) => new SensoresPageDos(),
      // ANIMATED_SPLASH: (BuildContext context) => new SplashScreen(),
    },
  ));
}