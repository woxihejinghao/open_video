import 'package:fluro/fluro.dart';
import 'package:open_video/common/instance.dart';
import 'package:open_video/pages/login/login_page.dart';
import 'package:open_video/pages/login/regist_page.dart';
import 'package:open_video/pages/main_tab_page.dart';

var rootHandler = Handler(handlerFunc: (context, parameters) {
  String? token = sharedPreferences.getString("token");
  if (token == null) {
    return const LoginPage();
  } else {
    return const MainTabPage();
  }
});
//Tab
var mainHandler = Handler(handlerFunc: (context, parameters) {
  return const MainTabPage();
});

//login
var loginHandler = Handler(handlerFunc: (context, parameters) {
  return const LoginPage();
});

//login
var registHandler = Handler(handlerFunc: (context, parameters) {
  return const RegistPage();
});
