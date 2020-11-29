// To parse this JSON data, do
//
//     final consumoModel = consumoModelFromJson(jsonString);

import 'dart:convert';

ConsumoModel consumoModelFromJson(String str) => ConsumoModel.fromJson(json.decode(str));

String consumoModelToJson(ConsumoModel data) => json.encode(data.toJson());

class ConsumoModel {
    ConsumoModel({
        this.id = 0,
        this.device = '',
        this.datos = '',
        this.pulsos = 0,
        this.bateria = 0,
        this.debug = '',
        this.tiempo = 0,
        this.consumoCalc  = 0,
        this.kwhCalc = 0.0,
        this.fechaCalc = '',
        this.anioCalc = '',
        this.mesCalc = '',
        this.diaCalc = 0,
    });

    int id;
    String device;
    String datos;
    int pulsos;
    int bateria;
    String debug;
    int tiempo;
    int consumoCalc;
    double kwhCalc;
    String fechaCalc;
    String anioCalc;
    String mesCalc;
    int diaCalc;

    factory ConsumoModel.fromJson(Map<String, dynamic> json) => ConsumoModel(
        id: json["id"],
        device: json["device"],
        datos: json["datos"],
        pulsos: json["pulsos"],
        bateria: json["bateria"],
        debug: json["debug"],
        tiempo: json["tiempo"],
        consumoCalc: json["consumo_calc"],
        kwhCalc: json["kwh_calc"].toDouble(),
        fechaCalc: json["fecha_calc"],
        anioCalc: json["anio_calc"],
        mesCalc: json["mes_calc"],
        diaCalc: json["dia_calc"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "device": device,
        "datos": datos,
        "pulsos": pulsos,
        "bateria": bateria,
        "debug": debug,
        "tiempo": tiempo,
        "consumo_calc": consumoCalc,
        "kwh_calc": kwhCalc,
        "fecha_calc": fechaCalc,
        "anio_calc": anioCalc,
        "mes_calc": mesCalc,
        "dia_calc": diaCalc,
    };
}
