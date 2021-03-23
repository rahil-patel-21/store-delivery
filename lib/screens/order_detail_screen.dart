import 'package:delivery_boy_app/constants/api_constant.dart';
import 'package:delivery_boy_app/constants/string_constant.dart';
import 'package:delivery_boy_app/helpers/app_utils.dart';
import 'package:delivery_boy_app/helpers/helper_methods.dart';
import 'package:delivery_boy_app/helpers/k3webservice.dart';
import 'package:delivery_boy_app/model/common_response_model.dart';
import 'package:delivery_boy_app/model/login_model.dart';
import 'package:delivery_boy_app/model/order_detail_response_model.dart';
import 'package:delivery_boy_app/model/timeline_response_model.dart';
import 'package:delivery_boy_app/screens/timeline_screen.dart';
import 'package:delivery_boy_app/widgets/confirm_alert.dart';
import 'package:flutter/material.dart';
// import 'package:flutter_mapbox_navigation/flutter_mapbox_navigation.dart'
//     as fmn;
import 'package:flutter_mapbox_navigation/library.dart';
import 'package:url_launcher/url_launcher.dart';

import 'login_screen.dart';

WayPoint globalOrginLocation =
    WayPoint(name: "hamburg", latitude: 42.71589, longitude: -78.82948);

class OrderDetailScreen extends StatefulWidget {
  static const String routeName = "/orderDetailScreen";
  final int orderId;
  final bool isFromOrderHistory;
  const OrderDetailScreen({Key key, this.orderId, this.isFromOrderHistory})
      : super(key: key);
  @override
  _OrderDetailScreenState createState() => _OrderDetailScreenState();
}

class _OrderDetailScreenState extends State<OrderDetailScreen> {
  final _scaffoldkey = GlobalKey<ScaffoldState>();

  bool _isLoading = false;
  OrderDetail _orderDetail;
  TextStyle lableStyle = TextStyle(fontWeight: FontWeight.bold);
  TextStyle descStyle = TextStyle();
  int _radioValue = 0;
  bool _showNavigation = false;
  MapboxNavigation _directions;
  double _distanceRemaining, _durationRemaining;
  bool _arrived = false;
  TextEditingController _userVerificationController = TextEditingController();
  List<TimeLineData> _arrTimelineData = [];

  @override
  void initState() {
    super.initState();

    _directions = MapboxNavigation(onRouteProgress: (arrived) async {
      _distanceRemaining = await _directions.distanceRemaining;
      _durationRemaining = await _directions.durationRemaining;

      setState(() {
        _arrived = arrived;
      });
      if (arrived) {
        await Future.delayed(Duration(seconds: 3));
        await _directions.finishNavigation();
      }
    });
    callOrderDetailApi();
    callTimelineApi();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldkey,
      appBar: AppBar(title: Text('Order Detail')),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : _orderDetail == null
              ? Container()
              : SingleChildScrollView(
                  child: Container(
                      child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: <Widget>[
                          SizedBox(
                            height: 10,
                          ),
                          Row(
                            children: <Widget>[
                              Text('Order ID: ', style: lableStyle),
                              Expanded(
                                child: Text(
                                  _orderDetail.orderId.toString() ?? '',
                                  style: descStyle,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Row(
                            children: <Widget>[
                              Text(
                                'Restaurant Name: ',
                                style: lableStyle,
                              ),
                              Expanded(
                                child: Text(
                                  _orderDetail.name.toString() ?? '',
                                  style: descStyle,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Row(
                            children: <Widget>[
                              Text(
                                'Restaurant Address: ',
                                style: lableStyle,
                              ),
                              Expanded(
                                child: Text(
                                  ((_orderDetail.rAddress.toString() ?? '') +
                                          ', ${_orderDetail.resCity.toString() ?? ''}') ??
                                      '',
                                  style: descStyle,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Row(
                            children: <Widget>[
                              Text(
                                'Restaurant Phone: ',
                                style: lableStyle,
                              ),
                              Expanded(
                                child: Text(
                                  _orderDetail.resContact.toString() ?? '',
                                  style: descStyle,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Row(
                            children: <Widget>[
                              Text(
                                'Customer Name: ',
                                style: lableStyle,
                              ),
                              Expanded(
                                child: Text(
                                  ((_orderDetail.uFirstname.toString() ?? '') +
                                          ' ' +
                                          (_orderDetail.uLastname.toString() ??
                                              '')) ??
                                      '',
                                  style: descStyle,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Row(
                            children: <Widget>[
                              Text(
                                'Customer Address: ',
                                style: lableStyle,
                              ),
                              Expanded(
                                child: Text(
                                  ((_orderDetail.formattedAddress ?? '') +
                                          ', ${_orderDetail.uCity.toString() ?? ''}') ??
                                      '',
                                  style: descStyle,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Row(
                            children: <Widget>[
                              Text(
                                'Customer Phone: ',
                                style: lableStyle,
                              ),
                              Expanded(
                                child: Text(
                                  _orderDetail.uPhone.toString() ?? '',
                                  style: descStyle,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Row(
                            children: <Widget>[
                              Text(
                                'Payment Mode: ',
                                style: lableStyle,
                              ),
                              Expanded(
                                child: Text(
                                  _orderDetail.paymentMode != 2
                                      ? 'Online'
                                      : 'Cash On Delivery',
                                  style: descStyle,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Row(
                            children: <Widget>[
                              Text(
                                'Amount: ',
                                style: lableStyle,
                              ),
                              Expanded(
                                child: Text(
                                  '\$${_orderDetail.total.toString()}',
                                  style: descStyle,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: <Widget>[
                              RaisedButton(
                                  shape: StadiumBorder(),
                                  onPressed: () {
                                    launch(
                                        'tel://${_orderDetail.resContact.toString() ?? ''}');
                                  },
                                  child: Row(
                                    children: <Widget>[
                                      Icon(Icons.phone),
                                      Text('Call Restaurant')
                                    ],
                                  )),
                              RaisedButton(
                                  shape: StadiumBorder(),
                                  onPressed: () {
                                    launch(
                                        'tel://${_orderDetail.uPhone.toString() ?? ''}');
                                  },
                                  child: Row(
                                    children: <Widget>[
                                      Icon(Icons.phone),
                                      Text('Call Customer')
                                    ],
                                  )),
                            ],
                          ),
                          // SizedBox(
                          //   height: 10,
                          // ),
                          // Row(
                          //   children: <Widget>[
                          //     Text(
                          //       'Pin: ',
                          //       style: lableStyle,
                          //     ),
                          //     Container(
                          //       decoration: BoxDecoration(border: Border.all()),
                          //       child: Padding(
                          //         padding: const EdgeInsets.all(8.0),
                          //         child: Text(
                          //           _orderDetail.resVerificationCode
                          //                   .toString() ??
                          //               '',
                          //           style: lableStyle,
                          //         ),
                          //       ),
                          //     ),
                          //   ],
                          // ),
                          SizedBox(
                            height: 10,
                          ),
                          SizedBox(height: widget.isFromOrderHistory ? 0 : 20),
                          widget.isFromOrderHistory
                              ? Container()
                              : Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: <Widget>[
                                    RaisedButton(
                                        shape: StadiumBorder(),
                                        onPressed: () {
                                          _directions.startNavigation(
                                              origin: globalOrginLocation,
                                              destination: WayPoint(
                                                  name: "Restaurant",
                                                  latitude: double.parse(
                                                      _orderDetail.resLat ==
                                                              null
                                                          ? '0.0'
                                                          : _orderDetail.resLat
                                                              .toString()),
                                                  longitude: double.parse(
                                                      _orderDetail.resLng ==
                                                              null
                                                          ? '0.0'
                                                          : _orderDetail.resLng
                                                              .toString())),
                                              simulateRoute: false,
                                              mode: MapBoxNavigationMode
                                                  .drivingWithTraffic,
                                              language: "Spanish",
                                              units: VoiceUnits.metric);
                                        },
                                        child: Row(
                                          children: <Widget>[
                                            Icon(Icons.location_on),
                                            Text('Restaurant')
                                          ],
                                        )),
                                    RaisedButton(
                                        shape: StadiumBorder(),
                                        onPressed: () {
                                          _directions.startNavigation(
                                              origin: globalOrginLocation,
                                              destination: WayPoint(
                                                  name: "Customer",
                                                  latitude: double.parse(
                                                      _orderDetail.uLat == null
                                                          ? '0.0'
                                                          : _orderDetail.uLat
                                                              .toString()),
                                                  longitude: double.parse(
                                                      _orderDetail.uLng == null
                                                          ? '0.0'
                                                          : _orderDetail.uLng
                                                              .toString())),
                                              simulateRoute: false,
                                              mode: MapBoxNavigationMode
                                                  .drivingWithTraffic,
                                              language: "Spanish",
                                              units: VoiceUnits.metric);
                                        },
                                        child: Row(
                                          children: <Widget>[
                                            Icon(Icons.location_on),
                                            Text('Customer')
                                          ],
                                        )),
                                  ],
                                ),
                          SizedBox(
                            height: 20,
                          ),
                          widget.isFromOrderHistory
                              ? Container()
                              : Column(
                                children: [
                                  Text(
                                      'Order Status: ${_orderDetail.orderStatus.toLowerCase()}',
                                      style: lableStyle,
                                    ),
                                    if (_orderDetail.orderStatus.toLowerCase() == 'preparing' && _arrTimelineData.isNotEmpty) Text('Ready in ${_arrTimelineData.first.cookingTime} minutes') else Container()
                                ],
                              ),
                                FlatButton(onPressed: (){
                                  Navigator.push(context, MaterialPageRoute(builder: (context) => Example6(
                                    orderId: _orderDetail.orderId,
                                  )));
                                },child: Text('See full timeline'),),
                          widget.isFromOrderHistory
                              ? Container()
                              : Column(
                                  children: <Widget>[
                                    (_orderDetail.orderStatus.toLowerCase() ==
                                                OrderStatus.delivered ||
                                            _orderDetail.orderStatus
                                                    .toLowerCase() ==
                                                OrderStatus.cancelled)
                                        ? Container()
                                        : _orderDetail.orderStatus
                                                    .toLowerCase() ==
                                                OrderStatus.pickup
                                            ? buildDeliveredRaisedButton(
                                                context)
                                            : buildPickupRaisedButton(context),
                                    (_orderDetail.orderStatus.toLowerCase() ==
                                                OrderStatus.delivered ||
                                            _orderDetail.orderStatus
                                                    .toLowerCase() ==
                                                OrderStatus.cancelled)
                                        ? Container()
                                        : Container(), //buildCancelOrderButton(),
                                  ],
                                ),
                        ],
                      ),
                    ),
                  )),
                ),
    );
  }

  RaisedButton buildDeliveredRaisedButton(BuildContext context) {
    return RaisedButton(
        onPressed: () {
          if (_orderDetail.paymentStatus == 0) {
            showDialog(
                context: context,
                builder: (context) => BaseAlertDialog(
                    title: 'Payment Received?',
                    content: 'Did you received the payment from customer?',
                    yesOnPressed: () {
                      Navigator.pop(context);
                      callUpdatePayementStatusApi();
                    },
                    noOnPressed: () {
                      Navigator.pop(context);
                    }));
            return;
          }
          callChangeOrderStatusApi('delivered');
          //_showDialog();
        },
        color: Colors.green[300],
        child: Text('Press this button when order is Delivered'));
  }

  Future<void> callTimelineApi() async {
    dynamic token = await AppUtils.getToken();
    User user = await AppUtils.getUser();
    ApiResponse<TimeLineRepsonseModel> apiResponse =
        await K3Webservice.getMethod(
            'https://zaboreats.com/backend/api/getOrderStages' +
                '?user_id=${user == null ? -1 : user.id}&order_id=${widget.orderId}',
            {
          "Authorization": "Bearer $token",
          "Content-Type": "application/json"
        });
    
    if (apiResponse.error) {
      return;
    } else {
      setState(() {
        _arrTimelineData = apiResponse.data.data;
      });
    }
  }

  Row buildCancelOrderButton() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        RaisedButton(
            color: Colors.red,
            onPressed: () {
              showDialog(
                  context: context,
                  builder: (context) => BaseAlertDialog(
                      title: 'Confirm',
                      content:
                          'Sure you want to change order status to Cancelled?',
                      yesOnPressed: () {
                        Navigator.pop(context);
                        callChangeOrderStatusApi('cancelled');
                      },
                      noOnPressed: () {
                        Navigator.pop(context);
                      }));
            },
            child: Row(
              children: <Widget>[
                Icon(Icons.cancel),
                SizedBox(width: 5),
                Text('Cancel Order')
              ],
            ))
        // new Radio(
        //   value: 0,
        //   groupValue: _radioValue,
        //   onChanged: _handleRadioValueChange,
        // ),
        // new Text('pickup'),
        // new Radio(
        //   value: 1,
        //   groupValue: _radioValue,
        //   onChanged: _handleRadioValueChange,
        // ),
        // new Text('delivered'),
        // new Radio(
        //   value: 2,
        //   groupValue: _radioValue,
        //   onChanged: _handleRadioValueChange,
        // ),
        // new Text('cancelled'),
      ],
    );
  }

  RaisedButton buildPickupRaisedButton(BuildContext context) {
    return RaisedButton(
        onPressed: () {
          showDialog(
              context: context,
              builder: (context) => BaseAlertDialog(
                  title: 'Confirm',
                  content: 'Sure you want to change order status to pick up?',
                  yesOnPressed: () {
                    Navigator.pop(context);
                    callChangeOrderStatusApi('pickup');
                  },
                  noOnPressed: () {
                    Navigator.pop(context);
                  }));
        },
        color: Colors.orange,
        child: Text('Press this button when order is Picked up'));
  }

  String getSwitchStringAccToStatus() {
    if (_orderDetail.orderStatus.toLowerCase() ==
            OrderStatus.recieved.toLowerCase() ||
        _orderDetail.orderStatus.toLowerCase() == "received") {
      return 'Picked Up? :';
    } else {
      return '';
    }
  }

  Future<void> callOrderDetailApi() async {
    setState(() {
      _isLoading = true;
    });
    User user = await AppUtils.getUser();
    String token = await AppUtils.getToken();
    if (user == null) {
      HelperMethods.showSnackBar(
          context,
          StringConstant.sessionExpiredText,
          _scaffoldkey,
          SnackBarAction(
            onPressed: () {
              Navigator.pushReplacementNamed(context, LoginScreen.routeName);
            },
            label: 'Login',
          ));
      return false;
    }

    ApiResponse<OrderDetailResponseModel> apiResponse =
        await K3Webservice.postMethod(
            Apis.orderDetail,
            {'user_id': user.id, 'order_id': widget.orderId},
            {'Authorization': "Bearer $token"});

    setState(() {
      _isLoading = false;
    });

    if (apiResponse.error) {
      HelperMethods.showSnackBar(
          context,
          apiResponse.error ? apiResponse.message : apiResponse.data.msg,
          _scaffoldkey,
          null);
      return;
    }
    _orderDetail =
        apiResponse.data.data.isEmpty ? null : apiResponse.data.data.first;

    if (_orderDetail.orderStatus == "delivered") {
      setState(() {
        _radioValue = 1;
      });
    } else if (_orderDetail.orderStatus == "cancelled") {
      setState(() {
        _radioValue = 2;
      });
    } else if (_orderDetail.orderStatus == "pickup") {
      setState(() {
        _radioValue = 0;
      });
    } else {
      setState(() {
        _radioValue = -1;
      });
    }
  }

  Future<void> callChangeOrderStatusApi(String orderStatus) async {
    setState(() {
      _isLoading = true;
    });
    User user = await AppUtils.getUser();
    String token = await AppUtils.getToken();
    if (user == null) {
      HelperMethods.showSnackBar(
          context,
          StringConstant.sessionExpiredText,
          _scaffoldkey,
          SnackBarAction(
            onPressed: () {
              Navigator.pushReplacementNamed(context, LoginScreen.routeName);
            },
            label: 'Login',
          ));
      return false;
    }

    ApiResponse<CommonResponseModel> apiResponse =
        await K3Webservice.postMethod(Apis.changeOrderStatus, {
      'user_id': user.id,
      'order_id': widget.orderId,
      'orderstatus': orderStatus
    }, {
      'Authorization': "Bearer $token"
    });

    setState(() {
      _isLoading = false;
    });

    if (apiResponse.error) {
      HelperMethods.showSnackBar(
          context,
          apiResponse.error ? apiResponse.message : apiResponse.data.msg,
          _scaffoldkey,
          null);
      return;
    }
    callOrderDetailApi();
  }

  Future<void> callUserVerificationApi(String code) async {
    setState(() {
      _isLoading = true;
    });
    User user = await AppUtils.getUser();
    String token = await AppUtils.getToken();
    if (user == null) {
      HelperMethods.showSnackBar(
          context,
          StringConstant.sessionExpiredText,
          _scaffoldkey,
          SnackBarAction(
            onPressed: () {
              Navigator.pushReplacementNamed(context, LoginScreen.routeName);
            },
            label: 'Login',
          ));
      return false;
    }

    ApiResponse<CommonResponseModel> apiResponse =
        await K3Webservice.postMethod(
            Apis.userVerificationApi,
            {'user_id': user.id, 'orderid': widget.orderId, 'code': code},
            {'Authorization': "Bearer $token"});

    setState(() {
      _isLoading = false;
    });

    if (apiResponse.error) {
      HelperMethods.showSnackBar(
          context,
          apiResponse.error ? apiResponse.message : apiResponse.data.msg,
          _scaffoldkey,
          null);
      return;
    }
    callChangeOrderStatusApi('delivered');
  }

  Future<void> callUpdatePayementStatusApi() async {
    setState(() {
      _isLoading = true;
    });
    User user = await AppUtils.getUser();
    String token = await AppUtils.getToken();
    if (user == null) {
      HelperMethods.showSnackBar(
          context,
          StringConstant.sessionExpiredText,
          _scaffoldkey,
          SnackBarAction(
            onPressed: () {
              Navigator.pushReplacementNamed(context, LoginScreen.routeName);
            },
            label: 'Login',
          ));
      return false;
    }

    ApiResponse<CommonResponseModel> apiResponse =
        await K3Webservice.postMethod(Apis.updatePaymentStatus, {
      'user_id': user.id,
      'orderid': widget.orderId,
    }, {
      'Authorization': "Bearer $token"
    });

    setState(() {
      _isLoading = false;
    });

    if (apiResponse.error) {
      HelperMethods.showSnackBar(
          context,
          apiResponse.error ? apiResponse.message : apiResponse.data.msg,
          _scaffoldkey,
          null);
      return;
    }
    //_showDialog();
    callChangeOrderStatusApi('delivered');
  }

  void _handleRadioValueChange(int value) {
    setState(() {
      _radioValue = value;

      switch (_radioValue) {
        case 0:
          callChangeOrderStatusApi('pickup');
          break;
        case 1:
          callChangeOrderStatusApi('delivered');
          break;
        case 2:
          callChangeOrderStatusApi('cancelled');
          break;
      }
    });
  }

  _showDialog() async {
    await showDialog<String>(
      context: context,
      child: new _SystemPadding(
        child: new AlertDialog(
          contentPadding: const EdgeInsets.all(16.0),
          content: new Row(
            children: <Widget>[
              new Expanded(
                child: new TextField(
                  controller: _userVerificationController,
                  autofocus: true,
                  keyboardType: TextInputType.number,
                  decoration: new InputDecoration(
                      labelText: 'Verification Code', hintText: ''),
                ),
              )
            ],
          ),
          actions: <Widget>[
            new FlatButton(
                child: const Text('CANCEL'),
                onPressed: () {
                  Navigator.pop(context);
                }),
            new FlatButton(
                child: const Text('VERIFY'),
                onPressed: () {
                  Navigator.pop(context);
                  callUserVerificationApi(_userVerificationController.text);
                })
          ],
        ),
      ),
    );
  }
}

class OrderDetailScreenArguments {
  int orderId;
  bool isFromOrderHistory;
  OrderDetailScreenArguments({this.orderId, this.isFromOrderHistory});
}

class OrderStatus {
  static String recieved = "recieved";
  static String pickup = "pickup";
  static String delivered = "delivered";
  static String cancelled = "cancelled";
}

class _SystemPadding extends StatelessWidget {
  final Widget child;

  _SystemPadding({Key key, this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var mediaQuery = MediaQuery.of(context);
    return new AnimatedContainer(
        padding: mediaQuery.viewInsets,
        duration: const Duration(milliseconds: 300),
        child: child);
  }
}
