import 'dart:async';

import 'package:fleet_manager/data/addressDB.dart';
import 'package:flutter/material.dart';

class AddressProvider extends ChangeNotifier {

  AddressProvider(){
    _loadData();
  }

  final Completer<void> _initializationCompleter = Completer<void>();
  Future<void> get initializationDone => _initializationCompleter.future;

  bool _useLocalhost = false;
  String _ipAddress = "192.168.1.5";
  String _apiServerAddress_localhost = "http://localhost:8083";
  String _apiServerAddress_tasks_localhost = "http://localhost:8000";

  bool get useLocalhost => _useLocalhost;
  String get ipAddress => _ipAddress;
  String get apiServerAddress => _useLocalhost ? _apiServerAddress_localhost : "http://$_ipAddress:8083";
  String get apiServerAddress_tasks => _useLocalhost ? _apiServerAddress_tasks_localhost : "http://$_ipAddress:8082";

  final AddressDB _db = AddressDB();

  Future<void> _loadData() async {
    await _db.init();

    if (_db.toInitialize) {
      _db.createInitialDataColori();
    }

    _ipAddress = _db.ipAddress;
    _useLocalhost = _db.useLocalhost;

    _initializationCompleter.complete();  // Segnala che l'inizializzazione è completa
    notifyListeners();
  }

  Future<void> _saveData() async {
    _db.ipAddress = _ipAddress;
    _db.useLocalhost = _useLocalhost;
    await _db.updateDatabaseAddress();

    notifyListeners();
  }

  void setUseLocalhost(){
    _useLocalhost = true;
    notifyListeners();
    _saveData();
  }

  void resetUseLocalhost(){
    _useLocalhost = false;
    notifyListeners();
    _saveData();
  }

  void changeIPaddress(String newIP){
    _ipAddress = newIP;
    notifyListeners();
    _saveData();
  }
}
