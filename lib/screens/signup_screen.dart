import 'dart:io';
import 'dart:async';
import 'package:delivery_boy_app/constants/api_constant.dart';
import 'package:delivery_boy_app/helpers/k3webservice.dart';
import 'package:delivery_boy_app/model/common_response_model.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:path_provider/path_provider.dart';
import 'package:delivery_boy_app/constants/color_constant.dart';
import 'package:delivery_boy_app/constants/get_space.dart';
import 'package:delivery_boy_app/helpers/helper_methods.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:image_picker/image_picker.dart';

class SignupScreen extends StatefulWidget {
  static const String routeName = "/signupScreen";
  @override
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _scaffoldkey = GlobalKey<ScaffoldState>();
  final GlobalKey<FormBuilderState> _fbKey = GlobalKey<FormBuilderState>();
  FocusNode emailFocus = FocusNode();
  FocusNode passwordFocus = FocusNode();
  FocusNode nameFocus = FocusNode();
  FocusNode phoneFocus = FocusNode();
  File _image;
  final picker = ImagePicker();
  bool fileChose = false;
  bool _isLoading = false;

  @override
  void initState() {
    getImageFileFromAssets();
    super.initState();
  }

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
              buildSignupText(),
             // userPicture(),
              buildFormBuilder(),
              buildSignupButton(),
            ],
          )),
    );
  }

  Text buildSignupText() {
    return Text("Sign Up",
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
                focusNode: nameFocus,
                maxLines: 1,
                validators: [FormBuilderValidators.required()],
                textInputAction: TextInputAction.next,
                decoration: InputDecoration(
                    prefixIcon:
                        Icon(Icons.person, color: AppColor.black26Color),
                    hintText: "Name",
                    hintStyle: TextStyle(color: AppColor.black26Color),
                    filled: true,
                    fillColor: AppColor.whiteColor,
                    border: OutlineInputBorder(
                      borderSide: BorderSide.none,
                      borderRadius: BorderRadius.all(Radius.circular(40.0)),
                    ),
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0)),
                attribute: 'name',
                onFieldSubmitted: (str) {
                  nameFocus.unfocus();
                  emailFocus.requestFocus();
                },
              ),
            ),
            Card(
              margin: EdgeInsets.only(left: 30, right: 30, top: 30),
              elevation: 11,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(40))),
              child: FormBuilderTextField(
                focusNode: emailFocus,
                maxLines: 1,
                validators: [
                  FormBuilderValidators.email(),
                  FormBuilderValidators.required()
                ],
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.next,
                decoration: InputDecoration(
                    prefixIcon:
                        Icon(Icons.email, color: AppColor.black26Color),
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
                  phoneFocus.requestFocus();
                },
              ),
            ),
            Card(
              margin: EdgeInsets.only(left: 30, right: 30, top: 30),
              elevation: 11,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(40))),
              child: FormBuilderTextField(
                focusNode: phoneFocus,
                maxLines: 1,
                validators: [
                  FormBuilderValidators.required()
                ],
                keyboardType: TextInputType.phone,
                textInputAction: TextInputAction.next,
                decoration: InputDecoration(
                    prefixIcon:
                        Icon(Icons.phone, color: AppColor.black26Color),
                    hintText: "Phone",
                    hintStyle: TextStyle(color: AppColor.black26Color),
                    filled: true,
                    fillColor: AppColor.whiteColor,
                    border: OutlineInputBorder(
                      borderSide: BorderSide.none,
                      borderRadius: BorderRadius.all(Radius.circular(40.0)),
                    ),
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0)),
                attribute: 'phone',
                onFieldSubmitted: (str) {
                  phoneFocus.unfocus();
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
                validators: [FormBuilderValidators.required()],
                focusNode: passwordFocus,
                maxLines: 1,
                obscureText: true,
                textInputAction: TextInputAction.done,
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
            GetVSpace(),
          ],
        ));
  }

  Widget userPicture() => Stack(
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(top: 12, bottom: 12),
            padding: EdgeInsets.all(6),
            height: MediaQuery.of(context).size.width * 0.3,
            width: MediaQuery.of(context).size.width * 0.3,
            decoration:
                BoxDecoration(shape: BoxShape.circle, color: Color(0xfff7f7f7)
                    // gradient: LinearGradient(
                    //     begin: Alignment.topLeft,
                    //     end: Alignment.bottomRight,
                    //     colors: [Color(0xff72d583), Color(0xff06a8a2)]),
                    ),
            child: InkWell(
              borderRadius: BorderRadius.circular(36),
              child: Hero(
                tag: "profile",
                child: CircleAvatar(
                  radius: 36,
                  backgroundImage: fileChose
                      ? FileImage(_image)
                      : AssetImage("assets/user_default.png"),
                ),
              ),
            ),
          ),
          Positioned(
            top: MediaQuery.of(context).size.width * 0.24,
            right: 6,
            child: Container(
              width: 34,
              height: 34,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Color(0xfff7f7f7),
              ),
              child: Material(
                  type: MaterialType.transparency,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30)),
                  child: InkWell(
                      onTap: () => getImage(),
                      splashColor: Colors.lightBlueAccent.withOpacity(0.7),
                      borderRadius: BorderRadius.circular(30),
                      child: Icon(Icons.photo_camera,
                          size: 18, color: Color(0xff4dc58f)))),
            ),
          )
        ],
      );

  Widget buildSignupButton() {
    return _isLoading
        ? Center(
            child: Padding(
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
                  // if (_image == null) {
                  //   HelperMethods.showSnackBar(
                  //       context, "Please select profile image", _scaffoldkey, null);
                  //   return;
                  // }
                  callRegistrationApi(_fbKey.currentState.value);
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

  Future getImage() async {
    showCupertinoModalPopup(
        context: context,
        builder: (BuildContext context) => CupertinoActionSheet(
                title: const Text('Choose Options'),
                actions: <Widget>[
                  CupertinoActionSheetAction(
                    child: const Text('Camera'),
                    onPressed: () async {
                      Navigator.pop(context);
                      var pickedFile =
                          await picker.getImage(source: ImageSource.camera);

                      setState(() {
                        _image = File(pickedFile.path);
                        fileChose = true;
                      });
                    },
                  ),
                  CupertinoActionSheetAction(
                    child: const Text('Gallery'),
                    onPressed: () async {
                      Navigator.pop(context);
                      var pickedFile =
                          await picker.getImage(source: ImageSource.gallery);

                      setState(() {
                        _image = File(pickedFile.path);
                        fileChose = true;
                      });
                    },
                  )
                ]));
  }

  getImageFileFromAssets() async {
    final byteData = await rootBundle.load('assets/user_default.png');
    _image = File('${(await getTemporaryDirectory()).path}/profilepicture.png');
    await _image.writeAsBytes(byteData.buffer
        .asUint8List(byteData.offsetInBytes, byteData.lengthInBytes));
  }

  callRegistrationApi(Map<String, dynamic> data) async {
    setState(() {
      _isLoading = true;
    });
    data['role'] = 'driver';
    ApiResponse<CommonResponseModel> response =
        await K3Webservice.postMethod<CommonResponseModel>(
            Apis.registration, data, null);
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
