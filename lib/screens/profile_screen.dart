import 'dart:io';

import 'package:delivery_boy_app/constants/api_constant.dart';
import 'package:delivery_boy_app/constants/color_constant.dart';
import 'package:delivery_boy_app/constants/get_space.dart';
import 'package:delivery_boy_app/constants/string_constant.dart';
import 'package:delivery_boy_app/helpers/app_utils.dart';
import 'package:delivery_boy_app/helpers/helper_methods.dart';
import 'package:delivery_boy_app/helpers/k3webservice.dart';
import 'package:delivery_boy_app/model/common_response_model.dart';
import 'package:delivery_boy_app/model/login_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:path_provider/path_provider.dart';
import 'dart:convert';
import 'package:async/async.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart';
import 'login_screen.dart';

class ProfileScreen extends StatefulWidget {
  static const String routeName = "/profileScreen";
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _scaffoldkey = GlobalKey<ScaffoldState>();
  final GlobalKey<FormBuilderState> _fbKey = GlobalKey<FormBuilderState>();
  FocusNode emailFocus = FocusNode();
  FocusNode phoneFocus = FocusNode();
  FocusNode nameFocus = FocusNode();
  FocusNode addressFocus = FocusNode();
  FocusNode cityFocus = FocusNode();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController cityController = TextEditingController();
  String _strProfile;
  File _image;
  final picker = ImagePicker();
  bool fileChose = false;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    getUserInfo();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldkey,
      appBar: AppBar(),
      body: buildBody(context),
    );
  }

  Widget buildBody(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
          width: MediaQuery.of(context).size.width,
          child: Column(
            children: <Widget>[
              //buildSignupText(),
              userPicture(context),
              buildFormBuilder(),
              buildSignupButton(context),
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
                controller: nameController,
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
                controller: emailController,
                focusNode: emailFocus,
                maxLines: 1,
                validators: [
                  FormBuilderValidators.email(),
                  FormBuilderValidators.required()
                ],
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.next,
                decoration: InputDecoration(
                    prefixIcon: Icon(Icons.email, color: AppColor.black26Color),
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
              margin: EdgeInsets.only(left: 30, right: 30, top: 20),
              elevation: 11,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(40))),
              child: FormBuilderTextField(
                controller: phoneController,
                validators: [FormBuilderValidators.required()],
                focusNode: phoneFocus,
                maxLines: 1,
                obscureText: true,
                keyboardType: TextInputType.phone,
                textInputAction: TextInputAction.done,
                decoration: InputDecoration(
                    prefixIcon: Icon(
                      Icons.phone,
                      color: AppColor.black26Color,
                    ),
                    hintText: "Phone",
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
                attribute: 'phone',
              ),
            ),
            Card(
              margin: EdgeInsets.only(left: 30, right: 30, top: 20),
              elevation: 11,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(40))),
              child: FormBuilderTextField(
                controller: addressController,
                validators: [FormBuilderValidators.required()],
                focusNode: addressFocus,
                maxLines: 1,
                obscureText: false,
                keyboardType: TextInputType.text,
                textInputAction: TextInputAction.next,
                decoration: InputDecoration(
                    prefixIcon: Icon(
                      Icons.location_city,
                      color: AppColor.black26Color,
                    ),
                    hintText: "Address",
                    hintStyle: TextStyle(
                      color: AppColor.black26Color,
                    ),
                    filled: false,
                    fillColor: AppColor.whiteColor,
                    border: OutlineInputBorder(
                      borderSide: BorderSide.none,
                      borderRadius: BorderRadius.all(Radius.circular(40.0)),
                    ),
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0)),
                attribute: 'address',
                onFieldSubmitted: (str) {
                  addressFocus.unfocus();
                  cityFocus.requestFocus();
                },
              ),
            ),
            Card(
              margin: EdgeInsets.only(left: 30, right: 30, top: 20),
              elevation: 11,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(40))),
              child: FormBuilderTextField(
                controller: cityController,
                validators: [FormBuilderValidators.required()],
                focusNode: cityFocus,
                maxLines: 1,
                obscureText: false,
                keyboardType: TextInputType.text,
                textInputAction: TextInputAction.done,
                decoration: InputDecoration(
                    prefixIcon: Icon(
                      Icons.location_city,
                      color: AppColor.black26Color,
                    ),
                    hintText: "City",
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
                attribute: 'city',
              ),
            ),
            GetVSpace(),
          ],
        ));
  }

  Widget userPicture(BuildContext context) => Stack(
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(top: 12, bottom: 12),
            padding: EdgeInsets.all(6),
            height: MediaQuery.of(context).size.width * 0.3,
            width: MediaQuery.of(context).size.width * 0.3,
            decoration:
                BoxDecoration(shape: BoxShape.circle, color: Color(0xfff7f7f7)),
            child: InkWell(
              borderRadius: BorderRadius.circular(36),
              child: Hero(
                tag: "profile",
                child: CircleAvatar(
                  radius: 36,
                  backgroundColor: Colors.grey,
                  backgroundImage: fileChose
                      ? FileImage(_image)
                      : NetworkImage(baseUrl + _strProfile),
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
                      onTap: () => getImage(context),
                      splashColor: Colors.lightBlueAccent.withOpacity(0.7),
                      borderRadius: BorderRadius.circular(30),
                      child: Icon(Icons.photo_camera,
                          size: 18, color: Color(0xff4dc58f)))),
            ),
          )
        ],
      );

  Widget buildSignupButton(BuildContext context) {
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
                  if (_image == null) {
                    HelperMethods.showSnackBar(context,
                        "Please select profile image", _scaffoldkey, null);
                    return;
                  }
                  callUpdateProfileApi(_fbKey.currentState.value, context);
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

  Future getImage(BuildContext context) async {
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


  callUpdateProfileApi(Map<String, dynamic> data, BuildContext context) async {
    setState(() {
      _isLoading = true;
    });
    String token = 'Bearer ' +
        '${await AppUtils.getToken() == null ? '' : await AppUtils.getToken()}';

    User user = await AppUtils.getUser();

    var uri = Uri.parse(Apis.updateProfile);
    print(uri);

    var request = new http.MultipartRequest("POST", uri);

    request.headers["Authorization"] = token;
    if (_image != null) {
      var stream =
          new http.ByteStream(DelegatingStream.typed(_image.openRead()));
      var length = await _image.length();

      var multipartFile = new http.MultipartFile('profilepic', stream, length,
          filename: basename(_image.path));
      //contentType: new MediaType('image', 'png'));
      request.files.add(multipartFile);
    }

    request.fields["name"] = data['name'];
    request.fields["email"] = data['email'];
    request.fields["city"] = data['city'];
    request.fields["dob"] = "1995-05-12";
    request.fields["about"] = "about";
    request.fields["address"] = data['address'];
    request.fields["phone"] = data['phone'];
    request.fields["user_id"] = '${user.id}';

    var streamedResponse = await request.send();
    final response = await http.Response.fromStream(streamedResponse);
    setState(() {
      _isLoading = false;
    });
    print(response.body);
    if (jsonDecode(response.body)["message"] == "Auth failed") {
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
      return;
    }
    if (jsonDecode(response.body)["status"] == false) {
      HelperMethods.showSnackBar(
          context,
          jsonDecode(response.body)["msg"],
          _scaffoldkey,
          SnackBarAction(
            onPressed: () {
              Navigator.pushReplacementNamed(context, LoginScreen.routeName);
            },
            label: 'Login',
          ));
      return;
    } else if (jsonDecode(response.body)["status"] == true) {
      AppUtils.saveUser(User.fromJson(jsonDecode(response.body)["data"]));
      return;
    } else {
      HelperMethods.showSnackBar(
          context, "something went wrong", _scaffoldkey, null);
      return;
    }
  }

  getUserInfo() async {
    User user = await AppUtils.getUser();
    nameController.text = user.name;
    emailController.text = user.email;
    phoneController.text = user.phone;
    addressController.text = user.address;
    cityController.text = user.city;
    setState(() {
      _strProfile = user.profileimage ?? '';
    });
  }
}
