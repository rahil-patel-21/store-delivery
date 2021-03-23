  //Mark:- Facebook login Action
// import 'dart:convert';
// import 'package:delivery_boy_app/instagram/instagram.dart' as insta;
// import 'package:delivery_boy_app/constants/string_constant.dart';
// import 'package:delivery_boy_app/model/userprofile.dart';
// import 'package:dio/dio.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_facebook_login/flutter_facebook_login.dart';
// import 'package:google_sign_in/google_sign_in.dart';
class SocialLogins
{

//  Future<UserProfile> facebookLoginAction(BuildContext context) async {
//     var facebookLogin = FacebookLogin();
//     UserProfile  userProfile;
//     facebookLogin.logOut();
//     var facebookLoginResult = await facebookLogin.logIn(['email']);
//     // await facebookLogin.logInWithReadPermissions(['email']);
//     switch (facebookLoginResult.status) {
//       case FacebookLoginStatus.error:
//         print("Error");
//         // onLoginStatusChanged(false);
//         break;
//       case FacebookLoginStatus.cancelledByUser:
//         print("CancelledByUser");
//         // onLoginStatusChanged(false);
//         break;
//       case FacebookLoginStatus.loggedIn:
//         print(facebookLoginResult.accessToken);
//         var graphResponse = await Dio().get(
//             'https://graph.facebook.com/v2.12/me?fields=name,first_name,last_name,email&access_token=${facebookLoginResult.accessToken.token}');
//         Map<String, dynamic> profile = json.decode(graphResponse.data);
//         profile.putIfAbsent(
//             "picture",
//             () =>
//                 "https://graph.facebook.com/${facebookLoginResult.accessToken.userId}/picture?height=200");
//         print("Token : ${facebookLoginResult.accessToken.toString()}");
//         print('response : ${profile.toString()}');
//         // onLoginStatusChanged(true);
//         userProfile = UserProfile(
//             userId: facebookLoginResult.accessToken.userId,
//             userName: profile['email'],
//             fullName: "${profile['first_name']} ${profile['last_name']}",
//             profilePic: profile['picture']);
//         print("user got is ${userProfile.toJson()}");
//         facebookLogin.logOut();
//                         String result = ( await Dio().delete(
//         "https://graph.facebook.com/me/permissions?access_token=${facebookLoginResult.accessToken.token}")).data.toString();
//         print(result);
//     if (!result.contains("success")) {
//        return null ; }
//         facebookLogin.logOut();

//         break;
//     }
//     return userProfile;
//   }

//   //Mark:- Instagram Login Action
//   Future<UserProfile> instaLoginAction(BuildContext context) async {
//  var tok = await  insta.getToken(StringConstant.appId, StringConstant.appSecret, context);
//     var username = await insta.getUsername(tok);
//    var userProfile = await  insta.getProfile(username);
//     //  doSocialLogin(userProfile, StringHelper.instagram);
// return userProfile;
//   }

//   //Mark:- Google Login Action
//   Future<UserProfile> googleLoginAction(BuildContext context) async {
//     GoogleSignIn _googleSignIn = GoogleSignIn(scopes: ['profile', 'email']);
//     UserProfile  userProfile;
//     try {
//       await _googleSignIn.signIn();
//     } catch (error) {
//       print(error);
//     }
//     GoogleSignInAccount _currentUser = _googleSignIn.currentUser;
//     if (_currentUser == null)
//       print("cannot sign in");
//     else {
//       print("${_currentUser.email} ${_currentUser.displayName}");
    
//         userProfile = UserProfile(
//             userId: _currentUser.id,
//             userName: _currentUser.email,
//             fullName: _currentUser.displayName,
//             profilePic: _currentUser.photoUrl);
      
//       print("user got is ${userProfile.toJson()}");
//       _googleSignIn.signOut();
//     }
//     return userProfile;
//   }

  }