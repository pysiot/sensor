import 'dart:async';

import 'package:sensor/Constant/Constant.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sensor/provider/db_provider.dart';
import 'package:sensor/provider/sensores_provider.dart';

class SplashScreen extends StatefulWidget {
  @override
  SplashScreenState createState() => new SplashScreenState();
}

class SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  
  final sensoresProvider = new SensoresProvider();
  var _visible = true;

  AnimationController animationController;
  Animation<double> animation;

  startTime() async {
    var _duration = new Duration(seconds: 3);
    return new Timer(_duration, navigationPage);
  }

  var _existeEnCache = 'NO';
  Future<String> _getDatosCache() async {

    String cacheDevice = await DBProvider.db.buscarDevice();
    
    setState(() {
        _existeEnCache = cacheDevice;    
    });
    return 'Cache revisado.';  
  }
  
  void navigationPage() {    
    if(_existeEnCache == 'S/D'){ // NO EXISTE EN CACHE
      Navigator.of(context).pushReplacementNamed(SENSORES);
    }else{
      Navigator.of(context).pushReplacementNamed(SENSORES_CACHE);
    }    
  }

  @override
  void initState() {

    _getDatosCache().then((value){
      print(value);
    }); 

    super.initState();
    animationController = new AnimationController( vsync: this, duration: new Duration(seconds: 2));
    animation = new CurvedAnimation(parent: animationController, curve: Curves.easeOut);

    animation.addListener(() => this.setState(() {}));
    animationController.forward();

    setState(() {
      _visible = !_visible;
    });    
    startTime();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          new Column(
            mainAxisAlignment: MainAxisAlignment.end,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Padding(
                  padding: EdgeInsets.only(bottom: 30.0),
                  child: new Image.asset(
                    'assets/images/powered_by.png',
                    height: 25.0,
                    fit: BoxFit.scaleDown,
                  ))
            ],
          ),
          new Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              new Image.asset(
                'assets/images/logo.png',
                width: animation.value * 250,
                height: animation.value * 250,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
