class OnGoingResponseModel {
    OnGoingResponseModel({
        this.status,
        this.msg,
        this.data,
    });

    bool status;
    String msg;
    List<OngoingData> data;

    factory OnGoingResponseModel.fromJson(Map<String, dynamic> json) => OnGoingResponseModel(
        status: json["status"] == null ? null : json["status"],
        msg: json["msg"] == null ? null : json["msg"],
        data: json["data"] == null ? null : List<OngoingData>.from(json["data"].map((x) => OngoingData.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "status": status == null ? null : status,
        "msg": msg == null ? null : msg,
        "data": data == null ? null : List<dynamic>.from(data.map((x) => x.toJson())),
    };
}

class OngoingData {
    OngoingData({
        this.orderId,
        this.resId,
        this.resName,
        this.restaurantpic,
        this.orderDelivered,
        this.orderStatus,
        this.orderDate,
    });

    int orderId;
    int resId;
    String resName;
    String restaurantpic;
    int orderDelivered;
    String orderStatus;
    DateTime orderDate;

    factory OngoingData.fromJson(Map<String, dynamic> json) => OngoingData(
        orderId: json["order_id"] == null ? null : json["order_id"],
        resId: json["res_id"] == null ? null : json["res_id"],
        resName: json["res_name"] == null ? null : json["res_name"],
        restaurantpic: json["restaurantpic"] == null ? null : json["restaurantpic"],
        orderDelivered: json["order_delivered"] == null ? null : json["order_delivered"],
        orderStatus: json["order_status"] == null ? null : json["order_status"],
        orderDate: json["order_date"] == null ? null : DateTime.parse(json["order_date"]),
    );

    Map<String, dynamic> toJson() => {
        "order_id": orderId == null ? null : orderId,
        "res_id": resId == null ? null : resId,
        "res_name": resName == null ? null : resName,
        "restaurantpic": restaurantpic == null ? null : restaurantpic,
        "order_delivered": orderDelivered == null ? null : orderDelivered,
        "order_status": orderStatus == null ? null : orderStatus,
        "order_date": orderDate == null ? null : "${orderDate.year.toString().padLeft(4, '0')}-${orderDate.month.toString().padLeft(2, '0')}-${orderDate.day.toString().padLeft(2, '0')}",
    };
}
