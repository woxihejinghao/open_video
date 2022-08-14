import 'dart:io';

import 'package:dio/adapter.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:open_video/common/net/net_response.dart';

enum LRNetRequestType {
  get,
  post,
  delete,
  patch,
}

class LRNetManager {
  static final LRNetManager _manager = LRNetManager._internal();
  factory LRNetManager() {
    return _manager;
  }
  LRNetManager._internal() {
    init();
  }

  late Dio _dio;

  void init() {
    //进行初始化
    BaseOptions options = BaseOptions(
        baseUrl: "https://api.apiopen.top/api", connectTimeout: 5000);
    _dio = Dio(options);
    //设置Http代理
    // if (kDebugMode) {
    //   //debug模式下开启代理
    //   (_dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate =
    //       (client) {
    //     // config the http client
    //     client.findProxy = (uri) {
    //       //proxy all request to localhost:8888
    //       return 'PROXY 192.168.10.10:8888';
    //     };
    //     client.badCertificateCallback =
    //         (X509Certificate cert, String host, int port) => true;
    //   };
    // }
  }

  static Future<LRNetResponse<T>> post<T>(String url, {Map? pra}) async {
    return _request(LRNetRequestType.post, url, pra: pra);
  }

  static Future<LRNetResponse<T>> get<T>(String url,
      {Map<String, dynamic>? pra}) async {
    return _request(LRNetRequestType.get, url, pra: pra);
  }

  static Future<LRNetResponse<T>> delete<T>(String url, {Map? pra}) async {
    return _request(LRNetRequestType.delete, url, pra: pra);
  }

  static Future<LRNetResponse<T>> patch<T>(String url, {Map? pra}) async {
    return _request(LRNetRequestType.patch, url, pra: pra);
  }

  static Future<LRNetResponse> refreshToken(String refreshToken) async {
    late Response response;
    try {
      response = await LRNetManager()._dio.post("/api/user_oauth2/token",
          data: {
            "grant_type": "refresh_token",
            "refresh_token": refreshToken,
          },
          options: Options(contentType: Headers.formUrlEncodedContentType));
    } on DioError catch (e) {
      return LRNetResponse(e.response);
    }
    return LRNetResponse(response);
  }

  static Future<LRNetResponse<T>> _request<T>(
      LRNetRequestType requestType, String url,
      {Map? pra}) async {
    late Response response;
    try {
      // String? token = myBox.get("access_token");
      // Options options =
      //     Options(headers: {"Authorization": "Token ${token ?? ""}"});
      Options? options;
      switch (requestType) {
        case LRNetRequestType.get:
          response = await LRNetManager()._dio.get(url,
              queryParameters: Map<String, dynamic>.from(pra ?? {}),
              options: options);
          break;
        case LRNetRequestType.delete:
          response = await LRNetManager()
              ._dio
              .delete(url, data: pra, options: options);
          break;
        case LRNetRequestType.post:
          response =
              await LRNetManager()._dio.post(url, data: pra, options: options);
          break;
        case LRNetRequestType.patch:
          response =
              await LRNetManager()._dio.patch(url, data: pra, options: options);
          break;
        default:
          response =
              await LRNetManager()._dio.post(url, data: pra, options: options);
      }
    } on DioError catch (e) {
      int statusCode = e.response?.statusCode ?? 0;
      if (statusCode == 401) {
        //登录token失效

      }
      return LRNetResponse<T>(e.response);
    }
    return LRNetResponse(response);
  }
}
