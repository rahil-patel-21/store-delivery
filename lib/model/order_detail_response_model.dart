class OrderDetailResponseModel {
    OrderDetailResponseModel({
        this.status,
        this.msg,
        this.data,
    });

    bool status;
    String msg;
    List<OrderDetail> data;

    factory OrderDetailResponseModel.fromJson(Map<String, dynamic> json) => OrderDetailResponseModel(
        status: json["status"] == null ? null : json["status"],
        msg: json["msg"] == null ? null : json["msg"],
        data: json["data"] == null ? null : List<OrderDetail>.from(json["data"].map((x) => OrderDetail.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "status": status == null ? null : status,
        "msg": msg == null ? null : msg,
        "data": data == null ? null : List<dynamic>.from(data.map((x) => x.toJson())),
    };
}

class OrderDetail {
    OrderDetail({
        this.orderId,
        this.resId,
        this.cart,
        this.foodTax,
        this.drinkTax,
        this.subtotal,
        this.tax,
        this.total,
        this.paymentMode,
        this.paymentStatus,
        this.orderDate,
        this.orderStatus,
        this.name,
        this.restaurantpic,
        this.rAddress,
        this.resCity,
        this.resContact,
        this.resVerificationCode,
        this.resLat,
        this.resLng,
        this.uFirstname,
        this.uLastname,
        this.uPhone,
        this.uAddress,
        this.uCity,
        this.uPincode,
        this.uHouseno,
        this.uLat,
        this.uLng,
        this.formattedAddress,
        this.orderDelivered,
    });

    int orderId;
    int resId;
    String cart;
    double foodTax;
    double drinkTax;
    double subtotal;
    double tax;
    double total;
    int paymentMode;
    int paymentStatus;
    DateTime orderDate;
    String orderStatus;
    String name;
    String restaurantpic;
    String rAddress;
    String resCity;
    String resContact;
    int resVerificationCode;
    double resLat;
    double resLng;
    String uFirstname;
    String uLastname;
    String uPhone;
    dynamic uAddress;
    String uCity;
    int uPincode;
    String uHouseno;
    dynamic uLat;
    dynamic uLng;
    dynamic formattedAddress;
    int orderDelivered;

    factory OrderDetail.fromJson(Map<String, dynamic> json) => OrderDetail(
        orderId: json["order_id"] == null ? null : json["order_id"],
        resId: json["res_id"] == null ? null : json["res_id"],
        cart: json["cart"] == null ? null : json["cart"],
        foodTax: json["food_tax"] == null ? null : json["food_tax"].toDouble(),
        drinkTax: json["drink_tax"] == null ? null : json["drink_tax"].toDouble(),
        subtotal: json["subtotal"] == null ? null : json["subtotal"].toDouble(),
        tax: json["tax"] == null ? null : json["tax"].toDouble(),
        total: json["total"] == null ? null : json["total"].toDouble(),
        paymentMode: json["payment_mode"] == null ? null : json["payment_mode"],
        paymentStatus: json["payment_status"] == null ? null : json["payment_status"],
        orderDate: json["order_date"] == null ? null : DateTime.parse(json["order_date"]),
        orderStatus: json["order_status"] == null ? null : json["order_status"],
        name: json["name"] == null ? null : json["name"],
        restaurantpic: json["restaurantpic"] == null ? null : json["restaurantpic"],
        rAddress: json["r_address"] == null ? null : json["r_address"],
        resCity: json["res_city"] == null ? null : json["res_city"],
        resContact: json["res_contact"] == null ? null : json["res_contact"],
        resVerificationCode: json["res_verification_code"] == null ? null : json["res_verification_code"],
        resLat: json["res_lat"] == null ? null : json["res_lat"].toDouble(),
        resLng: json["res_lng"] == null ? null : json["res_lng"].toDouble(),
        uFirstname: json["u_firstname"] == null ? null : json["u_firstname"],
        uLastname: json["u_lastname"] == null ? null : json["u_lastname"],
        uPhone: json["u_phone"] == null ? null : json["u_phone"],
        uAddress: json["u_address"],
        uCity: json["u_city"] == null ? null : json["u_city"],
        uPincode: json["u_pincode"] == null ? null : json["u_pincode"],
        uHouseno: json["u_houseno"] == null ? null : json["u_houseno"],
        uLat: json["u_lat"],
        uLng: json["u_lng"],
        formattedAddress: json["formattedAddress"],
        orderDelivered: json["order_delivered"] == null ? null : json["order_delivered"],
    );

    Map<String, dynamic> toJson() => {
        "order_id": orderId == null ? null : orderId,
        "res_id": resId == null ? null : resId,
        "cart": cart == null ? null : cart,
        "food_tax": foodTax == null ? null : foodTax,
        "drink_tax": drinkTax == null ? null : drinkTax,
        "subtotal": subtotal == null ? null : subtotal,
        "tax": tax == null ? null : tax,
        "total": total == null ? null : total,
        "payment_mode": paymentMode == null ? null : paymentMode,
        "payment_status": paymentStatus == null ? null : paymentStatus,
        "order_date": orderDate == null ? null : "${orderDate.year.toString().padLeft(4, '0')}-${orderDate.month.toString().padLeft(2, '0')}-${orderDate.day.toString().padLeft(2, '0')}",
        "order_status": orderStatus == null ? null : orderStatus,
        "name": name == null ? null : name,
        "restaurantpic": restaurantpic == null ? null : restaurantpic,
        "r_address": rAddress == null ? null : rAddress,
        "res_city": resCity == null ? null : resCity,
        "res_contact": resContact == null ? null : resContact,
        "res_verification_code": resVerificationCode == null ? null : resVerificationCode,
        "res_lat": resLat == null ? null : resLat,
        "res_lng": resLng == null ? null : resLng,
        "u_firstname": uFirstname == null ? null : uFirstname,
        "u_lastname": uLastname == null ? null : uLastname,
        "u_phone": uPhone == null ? null : uPhone,
        "u_address": uAddress,
        "u_city": uCity == null ? null : uCity,
        "u_pincode": uPincode == null ? null : uPincode,
        "u_houseno": uHouseno == null ? null : uHouseno,
        "u_lat": uLat,
        "u_lng": uLng,
        "formattedAddress": formattedAddress,
        "order_delivered": orderDelivered == null ? null : orderDelivered,
    };
}
