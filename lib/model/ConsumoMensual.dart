class ConsumoMensual {

  double saleVal;
  String saleYear;

  ConsumoMensual({this.saleVal,
                 this.saleYear});

  ConsumoMensual.fromMap(Map<String, dynamic> map)
      : assert(map['total'] != null),
        assert(map['mes_calc'] != null),
        saleVal = map['total'],
        saleYear=map['mes_calc'];

  @override
  String toString() => "Record<$saleVal:$saleYear>";

  factory ConsumoMensual.fromJson(Map<String, dynamic> json){
    return ConsumoMensual(
      saleVal:json["total"].toDouble(), 
      saleYear:json["mes_calc"]);
  }
}

