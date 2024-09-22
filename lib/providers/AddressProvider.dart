import 'package:flutter/material.dart';

class AddressProvider extends ChangeNotifier {
  bool _useLocalhost = false;

  String _ipAddress = "192.168.1.5";
  // String _apiServerAddress = "http://192.168.1.5:8083";
  // String _apiServerAddress_tasks = "http://192.168.1.5:8082";
  String _apiServerAddress_localhost = "http://localhost:8083";
  String _apiServerAddress_tasks_localhost = "http://localhost:8000";

  String get ipAddress => _ipAddress;
  String get apiServerAddress => _useLocalhost ? _apiServerAddress_localhost : "http://$_ipAddress:8083";
  String get apiServerAddress_tasks => _useLocalhost ? _apiServerAddress_tasks_localhost : "http://$_ipAddress:8082";
  bool get useLocalhost => _useLocalhost;

  void setUseLocalhost(){
    _useLocalhost = true;
    notifyListeners();
  }

  void resetUseLocalhost(){
    _useLocalhost = false;
    notifyListeners();
  }

  void changeIPaddress(String newIP){
    _ipAddress = newIP;
  }
}
