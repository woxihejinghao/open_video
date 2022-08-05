import 'package:flutter/material.dart';

NavigatorState get navigatorState => Instance.navigatorKey.currentState!;
//当前上下文
BuildContext get currentContext => navigatorState.context;

ThemeData get currentTheme => Theme.of(currentContext);

ColorScheme get currentColorScheme => currentTheme.colorScheme;

T? asT<T>(dynamic value) {
  if (value is T) {
    return value;
  }
  return null;
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
