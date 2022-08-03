import 'package:dio/dio.dart';

class LRNetResponse<T> {
  late bool success;
  Response? response;
  late String message;
  T? data;

  LRNetResponse(Response? netResponse) {
    response = netResponse;

    if (response?.data == null || response?.data is! Map) {
      success = false;
      message = response?.statusMessage ?? "网络请求失败～";
    } else {
      Map mapData = response?.data as Map;
      int? code = mapData["code"];
      if (code != 200) {
        success = false;
        message = mapData["message"] ?? "网络请求失败～";
      } else {
        success = true;
        message = mapData["message"] ?? "请求成功";
        data = mapData["result"];
      }
    }
  }
}
