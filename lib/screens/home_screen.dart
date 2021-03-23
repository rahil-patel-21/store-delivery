import 'dart:async';
import 'dart:convert';

import 'package:background_locator/background_locator.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:delivery_boy_app/constants/api_constant.dart';
import 'package:delivery_boy_app/constants/color_constant.dart';
import 'package:delivery_boy_app/constants/get_space.dart';
import 'package:delivery_boy_app/constants/string_constant.dart';
import 'package:delivery_boy_app/helpers/app_utils.dart';
import 'package:delivery_boy_app/helpers/helper_methods.dart';
import 'package:delivery_boy_app/helpers/k3webservice.dart';
import 'package:delivery_boy_app/model/common_response_model.dart';
import 'package:delivery_boy_app/model/drawer_model.dart';
import 'package:delivery_boy_app/model/login_model.dart';
import 'package:delivery_boy_app/model/order_history_response_model.dart';
import 'package:delivery_boy_app/model/pickup_response_model.dart';
import 'package:delivery_boy_app/screens/login_screen.dart';
import 'package:delivery_boy_app/screens/on_going_orders.dart';
import 'package:delivery_boy_app/screens/order_detail_screen.dart';
import 'package:delivery_boy_app/screens/order_history_screen.dart';
import 'package:delivery_boy_app/screens/profile_screen.dart';
import 'package:delivery_boy_app/screens/splashScreen.dart';
import 'package:delivery_boy_app/widgets/custom_switch.dart';
import 'package:delivery_boy_app/widgets/mapLocation.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

class HomeScreen extends StatefulWidget {
  static const String routeName = "/homeScreen";
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _enabled = true;
  final GlobalKey<MapLocationState> _myMapLocation =
      GlobalKey<MapLocationState>();
  final _scaffoldkey = GlobalKey<ScaffoldState>();
  List<PickupRequest> _arrPickupRequest = [];
  TextStyle lableStyle = TextStyle(fontWeight: FontWeight.bold);
  TextStyle descStyle = TextStyle();
  bool _isLoadingAcceptOrder = false;
  int tappedIndex = -1;
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    mainContext = context;
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        key: _scaffoldkey,
        appBar: buildAppBar(),
        drawer: buildDrawer(),
        body: buildBody(),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () async {
            await Navigator.pushNamed(context, OnGoingOrderScreen.routeName);
            callPickupRequestApi();
          },
          label: Text('On Going'),
          icon: Icon(Icons.directions_bike),
        ),
      ),
    );
  }

  User user;
  String token;
  @override
  void initState() {
    super.initState();
    AppUtils.getUser().then((value) => user = value).then((value) {
      AppUtils.getToken().then((value) => token = value).then((value) {});
      // AppUtils.getMyServiceStatus().then((value) {
      //   setState(() {
      //     _enabled = value;
      //   });
      // });
    });
    turnOnLocationService();
  }

  turnOnLocationService() async {
    await Future.delayed(Duration(seconds: 2));

    if (await Permission.location.request().isGranted) {
  // Either the permission was already granted before or the user just granted it.

    _myMapLocation.currentState.onStart();
    setState(() {
      _enabled = true;
    });
    bool result = await availForDelivery(status: true);
    if (!result) callPickupRequestApi();
    }else{
      await showDialog(
        barrierDismissible: false,
        context: context,builder:(context) {
        return AlertDialog(title: Text('Location permission is required'),content: Text('Please allow the app to access the location of device to receive the orders'),actions: [
          FlatButton(child: Text('Ok'), onPressed: ()async{
            await openAppSettings();
            Navigator.pop(context);
            turnOnLocationService();
          },)
        ],);
      });
    }
  }

  Drawer buildDrawer() {
    return Drawer(
      child: Column(children: [
        GetVSpace(space: 20),
        if (user != null)
          ListTile(
            leading: CircleAvatar(
              backgroundColor: Colors.grey,
              backgroundImage: user.profileimage == null
                  ? AssetImage('assets/user_default.png')
                  : CachedNetworkImageProvider(baseUrl + user.profileimage),
            ),
            title: Text(user.name),
            subtitle: Text(user.phone ?? "+91-9191919191"),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, ProfileScreen.routeName);
            },
          ),
        Expanded(
          child: ListView.builder(
              itemCount: drawerOptions.length,
              itemBuilder: (context, index) => ListTile(
                    onTap: () {
                      Navigator.pop(context);
                      switch (drawerOptions[index].title) {
                        case 'Log Out':
                          AppUtils.logout();
                          Navigator.pushReplacementNamed(
                              context, LoginScreen.routeName);
                          break;
                        case 'Order History':
                          Navigator.pushNamed(
                              context, OrderHistoryScreen.routeName);
                          break;
                      }
                    },
                    leading: drawerOptions[index].icon,
                    title: Text(drawerOptions[index].title),
                  )),
        )
      ]),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }

  Widget buildBody() {
    return Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                'Service',
                style: TextStyle(
                    color: AppColor.whiteColor,
                    fontSize: 20,
                    fontWeight: FontWeight.w600),
              ),
              Row(children: [
                CustomSwitch(
                  value: _enabled,
                  onChanged: (bool val) async {
                    AppUtils.saveMyServiceStatus(val);
                    if (user != null && token != null)
                      await availForDelivery(status: val);
                    setState(() {
                      _enabled = !_enabled;
                      if (val) {
                        _myMapLocation.currentState.onStart();
                        callPickupRequestApi();
                      } else {
                        _myMapLocation.currentState.onStop();
                      }
                    });
                  },
                ),
                IconButton(
                  icon: Icon(Icons.refresh),
                  onPressed: () {
                    callPickupRequestApi();
                  },
                ),
              ])
            ],
          ),
        ),
        Stack(
          children: <Widget>[
            MapLocation(
              key: _myMapLocation,
            ),
            (_arrPickupRequest == null || _arrPickupRequest.isEmpty)
                ? Center(
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                        Text('No Order Requests'),
                        SizedBox(height: 20),
                        _isLoading
                            ? Center(
                                child: CircularProgressIndicator(),
                              )
                            : RaisedButton(
                                onPressed: () {
                                  if (_enabled) callPickupRequestApi();
                                },
                                child: Text('REFRESH'),
                                shape: StadiumBorder(),
                              )
                      ]))
                : Container(
                    height: MediaQuery.of(context).size.height * 0.7,
                    child: ListView.builder(
                        itemCount: _arrPickupRequest.length,
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
                                          _arrPickupRequest[index]
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
                                          _arrPickupRequest[index]
                                                  .rName
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
                                        'Restaurant Address: ',
                                        style: lableStyle,
                                      ),
                                      Expanded(
                                        child: Text(
                                          ((_arrPickupRequest[index]
                                                          .rAddress
                                                          .toString() ??
                                                      '') +
                                                  ', ${_arrPickupRequest[index].rCity.toString() ?? ''}') ??
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
                                        'Customer Name: ',
                                        style: lableStyle,
                                      ),
                                      Expanded(
                                        child: Text(
                                          ((_arrPickupRequest[index]
                                                          .uFn
                                                          .toString() ??
                                                      '') +
                                                  ' ' +
                                                  (_arrPickupRequest[index]
                                                          .uLn
                                                          .toString() ??
                                                      '')) ??
                                              '',
                                          style: descStyle,
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 20,
                                  ),
                                  (_isLoadingAcceptOrder &&
                                          tappedIndex == index)
                                      ? Center(
                                          child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: CircularProgressIndicator(),
                                        ))
                                      : RaisedButton(
                                          color: AppColor.primaryColor,
                                          onPressed: () {
                                            setState(() {
                                              tappedIndex = index;
                                            });
                                            callAcceptOrderApi(
                                                _arrPickupRequest[index]);
                                          },
                                          shape: StadiumBorder(),
                                          child: Text(
                                            'Accept',
                                            style: TextStyle(
                                                color: AppColor.whiteColor),
                                          ),
                                        )
                                ],
                              ),
                            ))),
                  )
          ],
        )
      ],
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    BackgroundLocator.isRegisterLocationUpdate()
        .then((value) => setState(() => _enabled = value));
  }

  AppBar buildAppBar() {
    return AppBar(
      centerTitle: true,
      title: Text('Home'),
    );
  }

  Future<bool> availForDelivery({@required bool status}) async {
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

    ApiResponse<CommonResponseModel> response = await K3Webservice.postMethod(
        Apis.availForDelivery,
        {"user_id": user.id, "status": status ? 1 : 0},
        {"Authorization": "Bearer $token"});
    HelperMethods.showSnackBar(
        context,
        response.error ? response.message : response.data.msg,
        _scaffoldkey,
        null);
    return response.error;
  }

  Future<void> callPickupRequestApi() async {
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

    setState(() {
      _isLoading = true;
    });

    // ApiResponse<PickupResponseResponseModel> apiResponse =
    //     await K3Webservice.postMethod(Apis.runningOrder, {"user_id": user.id},
    //         {'Authorization': "Bearer $token"});

    ApiResponse<PickupResponseResponseModel> apiResponse =
        await K3Webservice.getMethod(Apis.pickupRequest + '?user_id=${user.id}',
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
      _arrPickupRequest = [];
      return;
    } else {
      setState(() {
        _arrPickupRequest = apiResponse.data.data ?? [];
      });
    }
  }

  Future<void> callAcceptOrderApi(PickupRequest pickupRequest) async {
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

    setState(() {
      _isLoadingAcceptOrder = true;
    });
    ApiResponse<CommonResponseModel> apiResponse =
        await K3Webservice.postMethod(
            Apis.acceptOrder,
            {'user_id': user.id, 'order_id': pickupRequest.orderId},
            {'Authorization': "Bearer $token"});

    setState(() {
      _isLoadingAcceptOrder = false;
      tappedIndex = -1;
    });

    if (apiResponse.error) {
      HelperMethods.showSnackBar(
          context,
          apiResponse.error ? apiResponse.message : apiResponse.data.msg,
          _scaffoldkey,
          null);
      return;
    }
    HelperMethods.showSnackBar(
        context, apiResponse.data.msg, _scaffoldkey, null);
    await Navigator.pushNamed(context, OrderDetailScreen.routeName,
        arguments: OrderDetailScreenArguments(
            orderId: pickupRequest.orderId, isFromOrderHistory: false));
    callPickupRequestApi();
  }
}
