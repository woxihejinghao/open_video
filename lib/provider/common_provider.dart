import 'dart:async';

import 'package:flutter/material.dart';

class CommonProvider extends ChangeNotifier {
  int _selectedTabIndex = 0;
  StreamController _streamController = StreamController.broadcast();
  int get selectedTabIndex => _selectedTabIndex;
  StreamController get streamController => _streamController;

  ///修改Tab选择的index
  changeSelectTabIndex(int index) {
    _selectedTabIndex = index;
    _streamController.add(index);
    notifyListeners();
  }
}
