import 'package:fluro/fluro.dart';
import 'package:flutter/services.dart';
import 'package:open_video/common/route/route_handles.dart';
import 'package:open_video/views/not_found_page.dart';

final router = FluroRouter();

class Routes {
  static String root = "/";
  //首页
  static String main = "/main";
  //登录
  static String login = "/login";

  //配置路由
  static void configureRoutes() {
    //404
    router.notFoundHandler = Handler(handlerFunc: (context, parameters) {
      return const NotFundPage();
    });

    router.define(root, handler: rootHandler);
    router.define(main, handler: mainHandler);
    router.define(login, handler: loginHandler);
  }
}
