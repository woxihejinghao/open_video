import 'package:fluro/fluro.dart';
import 'package:open_video/pages/login/login_page.dart';
import 'package:open_video/pages/login/regist_page.dart';
import 'package:open_video/pages/main_tab_page.dart';

var rootHandler = Handler(handlerFunc: (context, parameters) {
  return const LoginPage();
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
