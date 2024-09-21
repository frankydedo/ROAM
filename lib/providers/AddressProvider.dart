import 'package:flutter/material.dart';

class AddressProvider extends ChangeNotifier {
  bool _useLocalhost = false;

  final String _apiServerAddress = "http://192.168.1.5:8083";
  final String _apiServerAddress_tasks = "http://192.168.1.5:8082";
  final String _apiServerAddress_localhost = "http://localhost:8083";
  final String _apiServerAddress_tasks_localhost = "http://localhost:8000";

  String get apiServerAddress => _useLocalhost ? _apiServerAddress_localhost : _apiServerAddress;
  String get apiServerAddress_tasks => _useLocalhost ? _apiServerAddress_tasks_localhost : _apiServerAddress_tasks;
  bool get useLocalhost => _useLocalhost;

  // void toggleUseLocalhost() {
  //   _useLocalhost = !_useLocalhost;
  //   notifyListeners();
  // }

  void setUseLocalhost(){
    _useLocalhost = true;
    notifyListeners();
  }

  void resetUseLocalhost(){
    _useLocalhost = false;
    notifyListeners();
  }
}
