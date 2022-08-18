import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:open_video/views/loading_toast.dart';

NavigatorState get navigatorState => Instance.navigatorKey.currentState!;
//当前上下文
BuildContext get currentContext => navigatorState.context;

ThemeData get currentTheme => Theme.of(currentContext);

ColorScheme get currentColorScheme => currentTheme.colorScheme;

FToast fToast = FToast();

T? asT<T>(dynamic value) {
  if (value is T) {
    return value;
  }
  return null;
}

///显示toast
showToast(String msg, {ToastGravity? gravity}) {
  Fluttertoast.showToast(msg: msg, gravity: ToastGravity.CENTER);
}

showLoading() {
  fToast.showToast(
      child: const LoadingToast(),
      toastDuration: const Duration(seconds: 60),
      gravity: ToastGravity.CENTER);
}

dismissLoading() {
  fToast.removeCustomToast();
}

class Instance {
  static final Instance _instance = Instance._internal();

  factory Instance() {
    return _instance;
  }
  Instance._internal();

  static final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>();
}
