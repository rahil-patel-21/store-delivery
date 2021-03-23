import 'package:delivery_boy_app/constants/api_constant.dart';
import 'package:delivery_boy_app/constants/color_constant.dart';
import 'package:delivery_boy_app/constants/get_space.dart';
import 'package:delivery_boy_app/helpers/app_utils.dart';
import 'package:delivery_boy_app/helpers/helper_methods.dart';
import 'package:delivery_boy_app/helpers/k3webservice.dart';
import 'package:delivery_boy_app/model/login_model.dart';
import 'package:delivery_boy_app/model/userprofile.dart';
import 'package:delivery_boy_app/screens/forgort_password_screen.dart';
import 'package:delivery_boy_app/screens/home_screen.dart';
import 'package:delivery_boy_app/screens/signup_screen.dart';
import 'package:delivery_boy_app/screens/splashScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:hydrated/hydrated.dart';

class LoginScreen extends StatefulWidget {
  static const String routeName = "/loginScreen";
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GlobalKey<FormBuilderState> _fbKey = GlobalKey<FormBuilderState>();
  bool _isLoading = false;
  UserProfile userProfile;
  final _scaffoldkey = GlobalKey<ScaffoldState>();
  final isLogin$ = HydratedSubject<bool>("isLogin", seedValue: false);
  final pageData$ =
      HydratedSubject<List<String>>("pageData", seedValue: ["", ""]);
  FocusNode emailFocus = FocusNode();
  FocusNode passwordFocus = FocusNode();
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldkey,
      body: buildBody(context),
    );
  }

  @override
  void initState() {
    super.initState();
    pageData$.stream.listen((event) {
      if (event[0].length > 0 || event[1].length > 0) {
        email.text = pageData$.value[0];
        password.text = pageData$.value[1];
      }
    });
  }

  Stack buildBody(BuildContext context) {
    mainContext = context;
    return Stack(
      children: <Widget>[
        Container(
          height: MediaQuery.of(context).size.height,
        ),
        ListView(
          children: <Widget>[
            Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  GetVSpace(
                    space: 50,
                  ),
                  buildLoginText(),
                  GetVSpace(
                    space: 20,
                  ),
                  buildFormBuilder(),
                  GetVSpace(
                    space: 20,
                  ),
                  _isLoading
                      ? Center(child: CircularProgressIndicator())
                      : buildLoginButton(),
                  buildForgotPasswordButton()
                ],
              ),
            ),
            socialRow(),
            SizedBox(
              height: 50,
            ),
            buildSignupButton(context)
          ],
        ),
      ],
    );
  }

  Align buildSignupButton(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                "Dont have an account?",
                style: TextStyle(color: AppColor.whiteColor),
              ),
              InkWell(
                child: Text(" Sign up",
                    style: TextStyle(
                        color: AppColor.whiteColor,
                        fontWeight: FontWeight.bold)),
                onTap: () {
                  Navigator.pushNamed(context, SignupScreen.routeName);
                },
              )
            ],
          )
        ],
      ),
    );
  }

  GestureDetector buildForgotPasswordButton() {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, ForgotPassworScreen.routeName);
      },
      child: Text("Forgot your password?",
          style: TextStyle(color: AppColor.whiteColor)),
    );
  }

  Widget socialRow() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 28.0),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [],
          ),
          if (userProfile != null) Text(userProfile.toJson().toString())
        ],
      ),
    );
  }

  Container buildLoginButton() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(30.0),
      child: RaisedButton(
        padding: EdgeInsets.symmetric(vertical: 16.0),
        color: AppColor.secondaryColor,
        onPressed: () {
          if (_fbKey.currentState.saveAndValidate()) {
            print(_fbKey.currentState.value);
            pageData$.add([
              _fbKey.currentState.value['email'],
              _fbKey.currentState.value['password']
            ]);
            callLoginApi(_fbKey.currentState.value);
          }
        },
        elevation: 11,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(40.0))),
        child: Text("Login", style: TextStyle(color: AppColor.whiteColor)),
      ),
    );
  }

  Widget buildFormBuilder() {
    return FormBuilder(
        key: _fbKey,
        autovalidate: false,
        child: Column(
          children: <Widget>[
            Card(
              margin: EdgeInsets.only(left: 30, right: 30, top: 30),
              elevation: 11,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(40))),
              child: FormBuilderTextField(
                controller: email,
                validators: [
                  FormBuilderValidators.email(),
                  FormBuilderValidators.required()
                ],
                maxLines: 1,
                focusNode: emailFocus,
                textInputAction: TextInputAction.next,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                    prefixIcon:
                        Icon(Icons.person, color: AppColor.black26Color),
                    hintText: "Email",
                    hintStyle: TextStyle(color: AppColor.black26Color),
                    filled: true,
                    fillColor: AppColor.whiteColor,
                    border: OutlineInputBorder(
                      borderSide: BorderSide.none,
                      borderRadius: BorderRadius.all(Radius.circular(40.0)),
                    ),
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0)),
                attribute: 'email',
                onFieldSubmitted: (str) {
                  emailFocus.unfocus();
                  passwordFocus.requestFocus();
                },
              ),
            ),
            Card(
              margin: EdgeInsets.only(left: 30, right: 30, top: 20),
              elevation: 11,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(40))),
              child: FormBuilderTextField(
                controller: password,
                obscureText: true,
                focusNode: passwordFocus,
                textInputAction: TextInputAction.done,
                validators: [FormBuilderValidators.required()],
                maxLines: 1,
                keyboardType: TextInputType.visiblePassword,
                decoration: InputDecoration(
                    prefixIcon: Icon(
                      Icons.lock,
                      color: AppColor.black26Color,
                    ),
                    hintText: "Password",
                    hintStyle: TextStyle(
                      color: AppColor.black26Color,
                    ),
                    filled: true,
                    fillColor: AppColor.whiteColor,
                    border: OutlineInputBorder(
                      borderSide: BorderSide.none,
                      borderRadius: BorderRadius.all(Radius.circular(40.0)),
                    ),
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0)),
                attribute: 'password',
              ),
            ),
          ],
        ));
  }

  Text buildLoginText() {
    return Text("Login",
        textAlign: TextAlign.center,
        style: TextStyle(
            color: AppColor.whiteColor,
            fontWeight: FontWeight.bold,
            fontSize: 28.0));
  }

  @override
  void dispose() {
    pageData$.close();
    isLogin$.close();
    super.dispose();
  }

  callLoginApi(Map<String, dynamic> data) async {
    setState(() {
      _isLoading = true;
    });
    String deviceToken = await AppUtils.getDeviceToken();
    data['device_token'] = deviceToken;
    ApiResponse<LoginResponseModel> response =
        await K3Webservice.postMethod<LoginResponseModel>(
            Apis.login, data, null);
    setState(() {
      _isLoading = false;
    });
    if (response.error) {
      HelperMethods.showSnackBar(context, response.message, _scaffoldkey, null);
      return;
    }
    HelperMethods.showSnackBar(context, response.data.msg, _scaffoldkey, null);
    isLogin$.add(true);
    AppUtils.saveUser(response.data.data.user);
    AppUtils.saveToken(response.data.data.token);
    await Future.delayed(Duration(seconds: 1));
    Navigator.pushReplacementNamed(context, HomeScreen.routeName);
  }
}
