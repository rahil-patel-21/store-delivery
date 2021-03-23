import 'package:delivery_boy_app/constants/api_constant.dart';
import 'package:delivery_boy_app/helpers/app_utils.dart';
import 'package:delivery_boy_app/helpers/helper_methods.dart';
import 'package:delivery_boy_app/helpers/k3webservice.dart';
import 'package:delivery_boy_app/model/login_model.dart';
import 'package:delivery_boy_app/model/order_history_response_model.dart';
import 'package:delivery_boy_app/screens/order_detail_screen.dart';
import 'package:flutter/material.dart';

class OrderHistoryScreen extends StatefulWidget {
  static const String routeName = "/orderHistoryScreen";
  @override
  _OrderHistoryState createState() => _OrderHistoryState();
}

class _OrderHistoryState extends State<OrderHistoryScreen> {
  bool _isLoading = false;
  final _scaffoldkey = GlobalKey<ScaffoldState>();
  List<OrderHistory> _arrOrderHistory = [];
  TextStyle lableStyle = TextStyle(fontWeight: FontWeight.bold);
  TextStyle descStyle = TextStyle();

  @override
  void initState() {
    super.initState();
    callOrderHistory();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldkey,
      appBar: AppBar(
        title: Text('Order History'),
        leading: IconButton(
            icon: Icon(Icons.arrow_back_ios),
            onPressed: () {
              Navigator.pop(context);
            }),
      ),
      body: buildBody(),
    );
  }

  Widget buildBody() {
    return _isLoading
        ? Center(
            child: CircularProgressIndicator(),
          )
        : ListView.builder(
            itemCount: _arrOrderHistory.length,
            itemBuilder: (context, index) => GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context, OrderDetailScreen.routeName,
                        arguments: OrderDetailScreenArguments(
                            orderId: _arrOrderHistory[index].orderId,
                            isFromOrderHistory: true));
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Card(
                      elevation: 3,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(children: [
                          SizedBox(
                            height: 10,
                          ),
                          Row(
                            children: <Widget>[
                              Text('Order ID: ', style: lableStyle),
                              Expanded(
                                child: Text(
                                  _arrOrderHistory[index].orderId.toString() ??
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
                              Text('Date: ', style: lableStyle),
                              Expanded(
                                child: Text(
                                  _arrOrderHistory[index]
                                          .orderDate
                                          .toString()
                                          .split(' ')
                                          .first
                                          .toString() ??
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
                                'Restaurant Name: ',
                                style: lableStyle,
                              ),
                              Expanded(
                                child: Text(
                                  _arrOrderHistory[index].resName ?? '',
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
                              Text('Order Status: ', style: lableStyle),
                              Expanded(
                                child: Text(
                                  _arrOrderHistory[index]
                                          .orderStatus
                                          .toString() ??
                                      '',
                                  style: descStyle,
                                ),
                              ),
                            ],
                          ),
                        ]),
                      ),
                    ),
                  ),
                ));
  }

  Future<void> callOrderHistory() async {
    setState(() {
      _isLoading = true;
    });

    User user = await AppUtils.getUser();
    String token = await AppUtils.getToken();

    ApiResponse<OrderHistoryResponseModel> apiResponse =
        await K3Webservice.postMethod(Apis.orderHistory, {"user_id": user.id},
            {"Authorization": "Bearer $token"});

    setState(() {
      _isLoading = false;
    });

    if (apiResponse.error) {
      HelperMethods.showSnackBar(
          context,
          apiResponse.error ? apiResponse.message : apiResponse.data.msg,
          _scaffoldkey,
          null);
      _arrOrderHistory = [];
      return;
    } else {
      setState(() {
        _arrOrderHistory = apiResponse.data.data ?? [];
      });
    }
  }
}
