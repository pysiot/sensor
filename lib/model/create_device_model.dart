import 'dart:convert';

CreateDeviceModel createDeviceModelFromJson(String str) => CreateDeviceModel.fromJson(json.decode(str));

String createDeviceModelToJson(CreateDeviceModel data) => json.encode(data.toJson());

class CreateDeviceModel {
    String device;
    String servicio;
    String locacion;
    String fecRegistro;

    CreateDeviceModel({
        this.device = '',
        this.servicio = '',
        this.locacion = '',
        this.fecRegistro = '',
    });

    factory CreateDeviceModel.fromJson(Map<String, dynamic> json) => CreateDeviceModel(
        device: json["device"],
        servicio: json["servicio"],
        locacion: json["locacion"],
        fecRegistro: json["fec_registro"],
    );

    Map<String, dynamic> toJson() => {
        "device": device,
        "servicio": servicio,
        "locacion": locacion,
        "fec_registro": fecRegistro,
    };
}
