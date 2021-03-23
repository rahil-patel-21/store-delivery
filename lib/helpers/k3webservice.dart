import 'dart:async';
import 'package:delivery_boy_app/constants/string_constant.dart';
import 'package:delivery_boy_app/model/common_response_model.dart';
import 'package:delivery_boy_app/model/login_model.dart';
import 'package:delivery_boy_app/model/on_going_response_model.dart';
import 'package:delivery_boy_app/model/order_detail_response_model.dart';
import 'package:delivery_boy_app/model/order_history_response_model.dart';
import 'package:delivery_boy_app/model/pickup_response_model.dart';
import 'package:delivery_boy_app/model/timeline_response_model.dart';
import 'package:dio/dio.dart';

class K3Webservice {
  static Future<ApiResponse<T>> postMethod<T>(
      String url, dynamic data, dynamic headers) async {
    Dio dio = new Dio();
    print('hitting url: ' + url);
    print('with parameter: ' + data.toString());
    print('with headers: ' + headers.toString());
    try {
      //var response = await http.post(url, body: data, headers: headers);
      var response =
          await dio.post(url, data: data, options: Options(headers: headers));
      print(response.data);
      if (response.data["message"] == "Auth failed" ||
          response.data["msg"] == "Auth failed") {
        return ApiResponse(
            error: true, message: StringConstant.sessionExpiredText);
      }
      if (response.statusCode == 200) {
        if (response.data["status"] == false) {
          return ApiResponse<T>(error: true, message: response.data["msg"]);
        }
        return ApiResponse<T>(data: fromJson<T>(response.data));
      } else if (response.statusCode == 422) {
        return ApiResponse<T>(error: true, message: "Something went wrong");
      } else {
        return ApiResponse<T>(error: true, message: "Something went wrong");
      }
    } on DioError catch (e) {
      if (e.response == null)
        return ApiResponse<T>(error: true, message: "Something went wrong");

      if (e.response.statusCode == 422) {
        return ApiResponse<T>(
            error: true, message: e.response.data['errors'][0]['msg']);
      } else if (e.response.statusCode == 401) {
        return ApiResponse<T>(error: true, message: StringConstant.sessionExpiredText);
      } else {
        return ApiResponse<T>(error: true, message: "Something went wrong");
      }
    }
  }

  static Future<ApiResponse<T>> getMethod<T>(
      String url, dynamic headers) async {
    Dio dio = new Dio();
    print('hitting url: ' + url);
    print('with headers: ' + headers.toString());

    //var response = await http.get(url, headers: headers);

    try {
      var response = await dio.get(url, options: Options(headers: headers));
    print(response.data);
    if (response.data["message"] == "Auth failed" ||
        response.data["msg"] == "Auth failed") {
      return ApiResponse(
          error: true, message: StringConstant.sessionExpiredText);
    }
    if (response.statusCode == 200) {
      return ApiResponse<T>(data: fromJson<T>(response.data));
    } else if (response.statusCode == 422) {
      return ApiResponse<T>(error: true, message: "Something went wrong");
    } else {
      return ApiResponse<T>(error: true, message: "Something went wrong");
    }
    } catch (e) {
         if (e.response == null)
        return ApiResponse<T>(error: true, message: "Something went wrong");

      if (e.response.statusCode == 422) {
        return ApiResponse<T>(
            error: true, message: e.response.data['errors'][0]['msg']);
      } else if (e.response.statusCode == 401) {
        return ApiResponse<T>(error: true, message: StringConstant.sessionExpiredText);
      } else {
        return ApiResponse<T>(error: true, message: "Something went wrong");
      }
    }
    
  }

  static T fromJson<T>(dynamic json) {
    if (T == CommonResponseModel) {
      return CommonResponseModel.fromJson(json) as T;
    } else if (T == LoginResponseModel) {
      return LoginResponseModel.fromJson(json) as T;
    } else if (T == PickupResponseResponseModel) {
      return PickupResponseResponseModel.fromJson(json) as T;
    }else if (T == OrderDetailResponseModel) {
      return OrderDetailResponseModel.fromJson(json) as T;
    }else if (T == OrderHistoryResponseModel) {
      return OrderHistoryResponseModel.fromJson(json) as T;
    } else if (T == OnGoingResponseModel) {
      return OnGoingResponseModel.fromJson(json) as T;
    }else if (T == TimeLineRepsonseModel) {
      return TimeLineRepsonseModel.fromJson(json) as T;
    }else {
      return null;
      //throw Exception("Unknown class");
    }
  }
}

class ApiResponse<T> {
  T data;
  String message;
  bool error;
  ApiResponse({this.data, this.error = false, this.message});
}
