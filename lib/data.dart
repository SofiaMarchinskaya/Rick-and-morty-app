

import 'package:flutter/widgets.dart';

class Data with ChangeNotifier{
  String _currentId = "0";
  selectId(String id){
    _currentId=id;
    notifyListeners();
  }
  String get selectedId=>_currentId;
}