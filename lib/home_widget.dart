import 'package:charts_common/common.dart';
import 'package:flutter/material.dart';
import 'package:sensor/charts_screen/line_chart.dart';
import 'package:sensor/charts_screen/bar_chart.dart';
import 'package:sensor/charts_screen/pie_chart.dart';

import 'package:bubble_tab_indicator/bubble_tab_indicator.dart';
import 'package:sensor/charts_widgets/simple_line_chart.dart';
import 'package:sensor/colored_container.dart';
import 'package:intl/intl.dart';
//import 'charts/line_chart.dart';
//import 'charts/bar_chart.dart';
//import 'charts/pie_chart.dart';
//import 'colored_container.dart';


class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _currentIndex = 0;
  String _timeString = 'sd'; 

  @override
  Widget build(BuildContext context) {

   _timeString = _getTime();

   print(_getTime_device());

//    final double statusBarHeight = MediaQuery.of(context).padding.top;
    final double statusBarHeight = 24.00;

    List<Widget> _children = [
      getLineChart(statusBarHeight, _timeString),
      getBarChart(statusBarHeight, _timeString)
     // getPieChart(statusBarHeight, _timeString)
    ];

    return new MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Control Sensor",
      theme: new ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: new Scaffold(
//        appBar: new AppBar(title: new Text("Chart Demo with Timer")),
        body: _children[_currentIndex],
        bottomNavigationBar: new BottomNavigationBar(
            onTap: _onTapTab,
            currentIndex: _currentIndex,
            items: [
              BottomNavigationBarItem(
                icon: new Image.asset(
                  "assets/images/line.png",
                  height: 32.0,
                  width: 32.0,
                ),
                title: new Text("Line Chart"),
              ),
              BottomNavigationBarItem(
                  icon: new Image.asset(
                    "assets/images/bar.png",
                    height: 32.0,
                    width: 32.0,
                  ),
                  title: new Text("Bar Chart")),
              // BottomNavigationBarItem(
              //     icon: new Image.asset(
              //       "assets/images/pie.png",
              //       height: 32.0,
              //       width: 32.0,
              //     ),
              //     title: new Text("Pie Chart")),
            ]),
      ),
    );
  }

  void _onTapTab(int value) {
    setState(() {
      print(value);
      _currentIndex = value;
    });
  }


  String _getTime() {
    final String formattedDateTime =
        DateFormat('dd-MM-yyyy').format(DateTime.now()).toString();
        //DateFormat('yyyy-MM-dd \n kk:mm:ss').format(DateTime.now()).toString();
    setState(() {
      _timeString = formattedDateTime;
    });        
    return formattedDateTime;
  } 

  String _getTime_device() {

    String date = new DateTime.fromMicrosecondsSinceEpoch(1605268006).toString();
       
    return date;
  } 
  
}
