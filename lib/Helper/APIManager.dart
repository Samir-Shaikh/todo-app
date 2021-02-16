import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart';
import 'package:meta/meta.dart';
import 'package:todo_app/Utilities/Utilities.dart';

class APIConstant {
  //URL
  static final String apiVersion = "api/v1/";

  //135 is my user id Hardcoded
  static String getTasksList = apiVersion + "users/135/tasks";
  static String createTask = apiVersion + "users/135/tasks";
  static String editTask = apiVersion + "users/135/tasks";
  static String deleteTask = apiVersion + "users/135/tasks";
}

class APIManger {
  static const _baseURL = "http://tiny-list.herokuapp.com";
  final Client _client = Client();

  static var shared = APIManger();

  Future<Response> request(
      {@required RequestType requestType,
      @required String path,
      Map<String, String> headers,
      Map<String, dynamic> params}) async {
    var finaHeaders = {"Content-Type": "application/json"};

    if (headers != null) {
      finaHeaders.addAll(headers);
    }
    switch (requestType) {
      case RequestType.GET:
        return _client.get("$_baseURL/$path", headers: finaHeaders);

      case RequestType.POST:
        return _client.post("$_baseURL/$path",
            headers: finaHeaders, body: json.encode(params));

      case RequestType.PUT:
        return _client.put("$_baseURL/$path",
            headers: finaHeaders, body: json.encode(params));

      case RequestType.DELETE:
        return _client.delete("$_baseURL/$path", headers: finaHeaders);
      default:
        return throw RequestTypeNotFoundException(
            "The HTTP request method is not found");
    }
  }

  showLoader(BuildContext context) {
    showProgressDialog(context);
  }

  hideLoader(BuildContext context) {
    Navigator.of(context).pop();
  }

  //common request
  void makeRequest(
      {@required BuildContext context,
      @required String endPoint,
      @required RequestType method,
      Map<String, String> headers,
      Map<String, dynamic> params,
      @required ValueChanged<Result> callback}) async {
    showLoader(context);

    try {
      final response = await request(
          requestType: method,
          path: endPoint,
          headers: headers,
          params: params);

      hideLoader(context);
      if (response.statusCode == 200 || response.statusCode == 201) {
        //success with response
        dynamic resp = jsonDecode(response.body);
        callback(Result.success(resp));
      } else if (response.statusCode == 204) {
        //success but no response e.g delete api
        callback(Result.success(null));
      } else {
        Map<String, dynamic> resp = jsonDecode(response.body);
        String msg = resp['msg'];
        callback(Result.error(msg, response.statusCode));
      }
    } catch (error) {
      callback(Result.error('Something went wrong', 400));
    }
  }
}

enum RequestType { GET, POST, DELETE, PUT }

class RequestTypeNotFoundException implements Exception {
  String cause;
  RequestTypeNotFoundException(this.cause);
}

class Result<T> {
  Result._();

  // factory Result.loading(T msg) = LoadingState<T>;

  factory Result.success(T value) = SuccessState<T>;

  factory Result.error(T msg, T code) = ErrorState<T>;
}

class LoadingState<T> extends Result<T> {
  LoadingState(this.msg) : super._();
  final T msg;
}

class ErrorState<T> extends Result<T> {
  ErrorState(this.msg, this.code) : super._();
  final T msg;
  final T code;
}

class SuccessState<T> extends Result<T> {
  SuccessState(this.value) : super._();
  final T value;
}
