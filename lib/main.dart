import 'package:delivery_boy_app/constants/color_constant.dart';
import 'package:delivery_boy_app/screens/forgort_password_screen.dart';
import 'package:delivery_boy_app/screens/home_screen.dart';
import 'package:delivery_boy_app/screens/login_screen.dart';
import 'package:delivery_boy_app/screens/on_going_orders.dart';
import 'package:delivery_boy_app/screens/order_detail_screen.dart';
import 'package:delivery_boy_app/screens/order_history_screen.dart';
import 'package:delivery_boy_app/screens/profile_screen.dart';
import 'package:delivery_boy_app/screens/signup_screen.dart';
import 'package:delivery_boy_app/screens/splashScreen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'constants/test_websocket.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: navigatorKey,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          scaffoldBackgroundColor: AppColor.primaryColor,
          appBarTheme: AppBarTheme(color: AppColor.primaryColor, elevation: 0)),
      home: SplashScreen(),
      onGenerateRoute: routes,
    );
  }
}

Route routes(RouteSettings settings) {
  var page;
  String routeName = settings.name;
  switch (routeName) {
    case LoginScreen.routeName:
      page = LoginScreen();
      break;
    case SignupScreen.routeName:
      page = SignupScreen();
      break;
    case ForgotPassworScreen.routeName:
      page = ForgotPassworScreen();
      break;
    case HomeScreen.routeName:
      page = HomeScreen();
      break;
    case OrderDetailScreen.routeName:
      OrderDetailScreenArguments args = settings.arguments;
      page = OrderDetailScreen(
        orderId: args.orderId,
        isFromOrderHistory: args.isFromOrderHistory,
      );
      break;
    case ProfileScreen.routeName:
      page = ProfileScreen();
      break;
    case OrderHistoryScreen.routeName:
      page = OrderHistoryScreen();
      break;
    case OnGoingOrderScreen.routeName:
      page = OnGoingOrderScreen();
      break;
  }
  return CupertinoPageRoute(builder: (context) => page);
}
