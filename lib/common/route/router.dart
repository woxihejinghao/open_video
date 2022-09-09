import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:open_video/common/route/route_handles.dart';
import 'package:open_video/views/not_found_page.dart';

final router = FluroRouter();

extension NavigateExtension on BuildContext {
  void lrNavigatorTo(String path,
      {Object? arguments,
      bool clearStack = false,
      TransitionType transition = TransitionType.cupertino}) {
    ///页面跳转
    router.navigateTo(this, path,
        clearStack: clearStack,
        transition: transition,
        routeSettings: RouteSettings(arguments: arguments));
  }
}

extension RouterExtension on FluroRouter {
  Future lrNavigatorTo(BuildContext context, String path,
      {Object? arguments,
      bool clearStack = false,
      TransitionType transition = TransitionType.cupertino}) {
    ///页面跳转
    return router.navigateTo(context, path,
        clearStack: clearStack,
        transition: transition,
        routeSettings: RouteSettings(arguments: arguments));
  }
}

class Routes {
  static String root = "/";

  ///首页
  static String main = "/main";

  ///登录
  static String login = "/login";

  ///注册
  static String regist = "/regist";

  //配置路由
  static void configureRoutes() {
    //404
    router.notFoundHandler = Handler(handlerFunc: (context, parameters) {
      return const NotFundPage();
    });

    router.define(root, handler: rootHandler);
    router.define(main, handler: mainHandler);
    router.define(login, handler: loginHandler);
    router.define(regist, handler: registHandler);
  }
}
