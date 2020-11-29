import 'package:flutter/cupertino.dart';
import 'package:charts_flutter/flutter.dart' as charts;

class SimpleBarChartMes extends StatelessWidget {  
 final List<charts.Series> seriesList;  
 final bool animate;  
   
 SimpleBarChartMes(this.seriesList, {this.animate});  
   
 /// Creates a [BarChart] with sample data and no transition.  
 factory SimpleBarChartMes.withSampleData() {  
   return new SimpleBarChartMes(  
     _createSampleData(), 
     // Disable animations for image tests.  
     animate: false,  
   );  
 }  
   
 @override  
 Widget build(BuildContext context) {  
   return new charts.BarChart(  
     seriesList,  
     animate: animate,  
   );  
 }  
   
 /// Create one series with sample hard coded data.  
 static List<charts.Series<OrdinalSales, String>> 
 _createSampleData() {
   final data = [  
     new OrdinalSales('JUL', 10),  
     new OrdinalSales('AGO', 20),  
     new OrdinalSales('SET', 50),  
     new OrdinalSales('OCT', 10),  
     new OrdinalSales('NOV', 50),  
     new OrdinalSales('DIC', 0),  
     
   ];  
   
   return [  
     new charts.Series<OrdinalSales, String>(  
       id: 'Sales',  
       colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,  
       domainFn: (OrdinalSales sales, _) => sales.year,  
       measureFn: (OrdinalSales sales, _) => sales.sales,  
       data: data,  
     )  
   ];  
 }
   
}

/// Sample ordinal data type.
class OrdinalSales {
  final String year;
  final int sales;

  OrdinalSales(this.year, this.sales);
}