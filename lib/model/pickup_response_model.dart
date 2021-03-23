class PickupResponseResponseModel {
  PickupResponseResponseModel({this.status, this.msg, this.data, this.orderId});

  bool status;
  String msg;
  int orderId;
  List<PickupRequest> data;

  factory PickupResponseResponseModel.fromJson(Map<String, dynamic> json) =>
      PickupResponseResponseModel(
        status: json["status"] == null ? null : json["status"],
        msg: json["msg"] == null ? null : json["msg"],
        data: json["data"] == null
            ? null
            : List<PickupRequest>.from(
                json["data"].map((x) => PickupRequest.fromJson(x))),
        orderId: json["order_id"] == null ? null : json["order_id"],
      );

  Map<String, dynamic> toJson() => {
        "status": status == null ? null : status,
        "msg": msg == null ? null : msg,
        "data": data == null
            ? null
            : List<dynamic>.from(data.map((x) => x.toJson())),
        "order_id": orderId == null ? null : orderId,
      };
}

class PickupRequest {
  PickupRequest({
    this.orderId,
    this.rName,
    this.rAddress,
    this.rCity,
    this.rContact,
    this.rLat,
    this.rLng,
    this.rPic,
    this.uFn,
    this.uLn,
    this.uPhone,
    this.uAdress,
    this.uCity,
    this.uPin,
    this.uHn,
  });

  int orderId;
  String rName;
  String rAddress;
  String rCity;
  String rContact;
  double rLat;
  double rLng;
  String rPic;
  String uFn;
  String uLn;
  String uPhone;
  String uAdress;
  String uCity;
  int uPin;
  String uHn;

  factory PickupRequest.fromJson(Map<String, dynamic> json) => PickupRequest(
        orderId: json["order_id"] == null ? null : json["order_id"],
        rName: json["r_name"] == null ? null : json["r_name"],
        rAddress: json["r_address"] == null ? null : json["r_address"],
        rCity: json["r_city"] == null ? null : json["r_city"],
        rContact: json["r_contact"] == null ? null : json["r_contact"],
        rLat: json["r_lat"] == null ? null : json["r_lat"].toDouble(),
        rLng: json["r_lng"] == null ? null : json["r_lng"].toDouble(),
        rPic: json["r_pic"] == null ? null : json["r_pic"],
        uFn: json["u_fn"] == null ? null : json["u_fn"],
        uLn: json["u_ln"] == null ? null : json["u_ln"],
        uPhone: json["u_phone"] == null ? null : json["u_phone"],
        uAdress: json["u_adress"] == null ? null : json["u_adress"],
        uCity: json["u_city"] == null ? null : json["u_city"],
        uPin: json["u_pin"] == null ? null : json["u_pin"],
        uHn: json["u_hn"] == null ? null : json["u_hn"],
      );

  Map<String, dynamic> toJson() => {
        "order_id": orderId == null ? null : orderId,
        "r_name": rName == null ? null : rName,
        "r_address": rAddress == null ? null : rAddress,
        "r_city": rCity == null ? null : rCity,
        "r_contact": rContact == null ? null : rContact,
        "r_lat": rLat == null ? null : rLat,
        "r_lng": rLng == null ? null : rLng,
        "r_pic": rPic == null ? null : rPic,
        "u_fn": uFn == null ? null : uFn,
        "u_ln": uLn == null ? null : uLn,
        "u_phone": uPhone == null ? null : uPhone,
        "u_adress": uAdress == null ? null : uAdress,
        "u_city": uCity == null ? null : uCity,
        "u_pin": uPin == null ? null : uPin,
        "u_hn": uHn == null ? null : uHn,
      };
}
