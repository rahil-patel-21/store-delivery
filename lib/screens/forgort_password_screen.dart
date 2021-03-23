import 'package:delivery_boy_app/constants/api_constant.dart';
import 'package:delivery_boy_app/constants/color_constant.dart';
import 'package:delivery_boy_app/constants/get_space.dart';
import 'package:delivery_boy_app/helpers/helper_methods.dart';
import 'package:delivery_boy_app/helpers/k3webservice.dart';
import 'package:delivery_boy_app/model/common_response_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

class ForgotPassworScreen extends StatefulWidget {
  static const String routeName = "/forgotPasswordScreen";
  @override
  _ForgotPassworScreenState createState() => _ForgotPassworScreenState();
}

class _ForgotPassworScreenState extends State<ForgotPassworScreen> {
  final GlobalKey<FormBuilderState> _fbKey = GlobalKey<FormBuilderState>();
  final _scaffoldkey = GlobalKey<ScaffoldState>();
  bool _isLoading = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldkey,
      appBar: AppBar(),
      body: buildBody(),
    );
  }

  Widget buildBody() {
    return SingleChildScrollView(
        child: Container(
      width: MediaQuery.of(context).size.width,
      child: Column(
        children: <Widget>[
          GetVSpace(
            space: 50,
          ),
          buildForgotPassText(),
          GetVSpace(
            space: 100,
          ),
          buildFormBuilder(),
          buildSumbitButton()
        ],
      ),
    ));
  }

  Widget buildSumbitButton() {
    return _isLoading
        ? Center(child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: CircularProgressIndicator(),
        ))
        : Container(
            width: double.infinity,
            padding: EdgeInsets.all(30.0),
            child: RaisedButton(
              padding: EdgeInsets.symmetric(vertical: 16.0),
              color: AppColor.secondaryColor,
              onPressed: () {
                if (_fbKey.currentState.saveAndValidate()) {
                  print(_fbKey.currentState.value);
                  callForgotPasswordApi(_fbKey.currentState.value);
                }
              },
              elevation: 11,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(40.0))),
              child:
                  Text("Submit", style: TextStyle(color: AppColor.whiteColor)),
            ),
          );
  }

  Text buildForgotPassText() {
    return Text("Forgot Password?",
        textAlign: TextAlign.center,
        style: TextStyle(
            color: AppColor.whiteColor,
            fontWeight: FontWeight.bold,
            fontSize: 28.0));
  }

  FormBuilder buildFormBuilder() {
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
                maxLines: 1,
                textInputAction: TextInputAction.done,
                keyboardType: TextInputType.emailAddress,
                validators: [
                  FormBuilderValidators.email(),
                  FormBuilderValidators.required()
                ],
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
              ),
            ),
          ],
        ));
  }

  callForgotPasswordApi(Map<String, dynamic> data) async {
    setState(() {
      _isLoading = true;
    });
    ApiResponse<CommonResponseModel> response =
        await K3Webservice.postMethod<CommonResponseModel>(
            Apis.forgotPassword, data, null);
    setState(() {
      _isLoading = false;
    });
    if (response.error) {
      HelperMethods.showSnackBar(context, response.message, _scaffoldkey, null);
      return;
    }
    HelperMethods.showSnackBar(context, response.data.msg, _scaffoldkey, null);
    await Future.delayed(Duration(seconds: 1));
    Navigator.pop(context);
  }
}
