import 'package:bubble_tab_indicator/bubble_tab_indicator.dart';
import 'package:flutter/material.dart';
import 'package:sensor/charts_screen/line_chart.dart';
import 'package:sensor/charts_screen/bar_chart.dart';
import 'package:intl/intl.dart';
import 'package:sensor/charts_screen/sensor_bar_chart.dart';
import 'package:sensor/charts_widgets/simple_bar_chart.dart';
import 'package:sensor/charts_widgets/simple_bar_chart_mses.dart';

import 'package:sensor/pages/sensores_page2.dart';
import 'package:sensor/provider/db_provider.dart';
import 'package:charts_flutter/flutter.dart' as charts;

import '../weather_details_header.dart';
//import 'charts/line_chart.dart';
//import 'charts/bar_chart.dart';
//import 'charts/pie_chart.dart';
//import 'colored_container.dart';

class ReportPage extends StatefulWidget {
  @override
  _ReportPageState createState() => _ReportPageState();
}

class _ReportPageState extends State<ReportPage> {
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
      getBarChart(statusBarHeight, _timeString),
      //getPieChart(statusBarHeight, _timeString)
    ];

    return new MaterialApp(
      debugShowCheckedModeBanner: false,
      //title: "Control Sensor",
      theme: new ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: new Scaffold(
        appBar: AppBar(
          title: const Text('Consumo Las Malvinas'),
          automaticallyImplyLeading: true,
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SensoresPageDos()),
              );
            },
          ),
        ),

//        appBar: new AppBar(title: new Text("Chart Demo with Timer")),
        body: _children[1], // _currentIndex
        bottomNavigationBar: new BottomNavigationBar(
            onTap: _onTapTab,
            currentIndex: _currentIndex,
            items: [
              BottomNavigationBarItem(
                
                  icon: new Image.asset(
                    "assets/images/bar.png",
                    height: 32.0,
                    width: 32.0,
                  ),
                  
                  title: new Text("Bar Chart")),              
              BottomNavigationBarItem(
                icon: new Image.asset(
                  "assets/images/bar.png",
                  height: 32.0,
                  width: 32.0,
                ),
                title: new Text("Bar Chart"),
              ),

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
    String date =
        new DateTime.fromMicrosecondsSinceEpoch(1605268006).toString();

    return date;
  }

  Widget getBarChart(double statusBarHeight, String formattedDateTime) {
    return new Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        new AspectRatio(
          aspectRatio: 100 / 40,
          child: WeatherDetailsHeader(statusBarHeight, formattedDateTime),
        ),
        new Expanded(child: TabBarControllerHome()),
      ],
    );
  }

  

  TabBarControllerHome() {
    return new DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: new PreferredSize(
            preferredSize: Size.fromHeight(kToolbarHeight),
            child: new TabBar(
              tabs: [
                // Tab(
                //   text: "Día",
                // ),
                // Tab(
                //   text: "Semana",
                // ),
                Tab(
                  text: "Meses",
                ),
                Tab(
                  text: "Años",
                ),
              ],
              labelColor: Colors.white,
              unselectedLabelColor: Colors.blue,
              indicatorSize: TabBarIndicatorSize.tab,
              indicator: BubbleTabIndicator(
                  indicatorColor: Colors.blue,
                  indicatorHeight: 25.0,
                  tabBarIndicatorSize: TabBarIndicatorSize.tab),
            ),
          ),
          body: new TabBarView(children: [
            new Padding(
              padding: const EdgeInsets.all(8.0),
              child: new SizedBox(
                height: 250.0,
                child: new  SimpleBarChartMes.withSampleData(), //SensorBarChart.withSampleDatawithLoadData(), // ESTA ES LA DATA QUE ESTOY MANIPULANDO
              ),
            ),
            new Padding(
              padding: const EdgeInsets.all(8.0),
              child: new SizedBox(
                height: 250.0,
                child: new SimpleBarChart.withSampleData(),
              ),
            ),
          ]),
        ));
  }
}

class ConsumoAnual {
  final int anio;
  final double consumo;

  ConsumoAnual(this.anio, this.consumo);
}
