import 'package:delivery_boy_app/constants/api_constant.dart';
import 'package:delivery_boy_app/constants/color_constant.dart';
import 'package:delivery_boy_app/helpers/app_utils.dart';
import 'package:delivery_boy_app/helpers/helper_methods.dart';
import 'package:delivery_boy_app/helpers/k3webservice.dart';
import 'package:delivery_boy_app/model/login_model.dart';
import 'package:delivery_boy_app/model/on_going_response_model.dart';
import 'package:delivery_boy_app/screens/order_detail_screen.dart';
import 'package:flutter/material.dart';

class OnGoingOrderScreen extends StatefulWidget {
  static const String routeName = "/onGoingOrderScreen";
  @override
  _OnGoingOrderScreenState createState() => _OnGoingOrderScreenState();
}

class _OnGoingOrderScreenState extends State<OnGoingOrderScreen> {
  final _scaffoldkey = GlobalKey<ScaffoldState>();
  List<OngoingData> _arrOngoingData = [];
  TextStyle lableStyle = TextStyle(fontWeight: FontWeight.bold);
  TextStyle descStyle = TextStyle();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    callOnGoingOrderApi();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldkey,
      appBar: AppBar(title: Text('On Going Orders')),
      body: Column(children: [
        _isLoading ? LinearProgressIndicator() : Container(),
        (_arrOngoingData == null || _arrOngoingData.length == 0)
            ? _isLoading
                ? Container()
                : Center(
                    child: Text('No On-going orders'),
                  )
            : Expanded(
                child: ListView.builder(
                    itemCount: _arrOngoingData.length,
                    itemBuilder: (context, index) => Card(
                        elevation: 3,
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
                                      _arrOngoingData[index]
                                              .orderId
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
                                      _arrOngoingData[index]
                                              .resName
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
                                    'Order Status: ',
                                    style: lableStyle,
                                  ),
                                  Expanded(
                                    child: Text(
                                      _arrOngoingData[index]
                                              .orderStatus
                                              .toString() ??
                                          '',
                                      style: descStyle,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              RaisedButton(
                                color: AppColor.primaryColor,
                                onPressed: () {
                                  Navigator.pushNamed(
                                      context, OrderDetailScreen.routeName,
                                      arguments: OrderDetailScreenArguments(
                                          orderId:
                                              _arrOngoingData[index].orderId,
                                          isFromOrderHistory: false));
                                },
                                shape: StadiumBorder(),
                                child: Text(
                                  'Go To Details',
                                  style: TextStyle(color: AppColor.whiteColor),
                                ),
                              )
                            ],
                          ),
                        ))),
              ),
      ]),
    );
  }

  Future<void> callOnGoingOrderApi() async {
    User user = await AppUtils.getUser();
    if (user == null) return;

    String token = await AppUtils.getToken();
    setState(() {
      _isLoading = true;
    });

    ApiResponse<OnGoingResponseModel> apiResponse =
        await K3Webservice.postMethod(Apis.runningOrder, {"user_id": user.id},
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
      _arrOngoingData = [];
      return;
    } else {
      setState(() {
        _arrOngoingData = apiResponse.data.data ?? [];
      });
    }
  }
}
