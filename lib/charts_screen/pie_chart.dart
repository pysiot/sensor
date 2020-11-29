import 'package:bubble_tab_indicator/bubble_tab_indicator.dart';
import 'package:flutter/material.dart';
import 'package:sensor/charts_widgets/simple_pie_chart.dart';
//import 'package:flutter_charts_deep/colored_container.dart';
import 'package:sensor/weather_details_header.dart';

Widget getPieChart(double statusBarHeight, String formattedDateTime){

  return new Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: <Widget>[
      new AspectRatio(
        aspectRatio: 100 / 70,
        child: WeatherDetailsHeader(statusBarHeight, formattedDateTime),
      ),
      new Expanded(child: TabBarControllerHome()),
    ],
  );
}

TabBarControllerHome() {
  return new DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: new PreferredSize(
          preferredSize: Size.fromHeight(kToolbarHeight),
          child: new TabBar(
            tabs: [
              Tab(
                text: "Día",
              ),
              Tab(
                text: "Semana",
              ),
              Tab(
                text: "Mes",
              ),
              Tab(
                text: "Año",
              )
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
              child: new SimplePieChart.withRandomData(),
            ),
          ),
          new Padding(
            padding: const EdgeInsets.all(8.0),
            child: new SizedBox(
              height: 250.0,
              child: new SimplePieChart.withRandomData(),
            ),
          ),
          new Padding(
            padding: const EdgeInsets.all(8.0),
            child: new SizedBox(
              height: 250.0,
              child: new SimplePieChart.withRandomData(),
            ),
          ),
          new Padding(
            padding: const EdgeInsets.all(8.0),
            child: new SizedBox(
              height: 250.0,
              child: new SimplePieChart.withRandomData(),
            ),
          ),
        ]),
      ));
}
