import 'dart:async';
import 'dart:ui';
import 'package:flutter/material.dart'; 

class ColorsProvider extends ChangeNotifier {
  // ColorsProvider() {
  //   _loadData();
  // }

  final Completer<void> _initializationCompleter = Completer<void>();

  Future<void> get initializationDone => _initializationCompleter.future;

  bool isLightMode = true;

  String _temaAttuale = "Sistema Operativo";

  String get temaAttuale => _temaAttuale;

  Color _colorePrimario = Colors.grey.shade100;
  Color _colorePrimario_dark = const Color.fromARGB(255, 9, 9, 9);
  Color _coloreSecondario = Colors.indigo.shade800;
  Color _coloreSecondario_dark = Colors.indigo.shade300;
  Color _coloreTitoli = Colors.indigo.shade800;
  Color _coloreHighlight = const Color.fromARGB(255, 219, 224, 255);
  Color _coloreHighlight_dark = Colors.indigo.shade900;

  Color get coloreTitoli => isLightMode ? _coloreTitoli : _colorePrimario;
  Color get colorePrimario => isLightMode ? _colorePrimario : _colorePrimario_dark;
  Color get coloreSecondario => isLightMode ? _coloreSecondario : _coloreSecondario_dark;
  Color get backgroudColor => isLightMode ? _colorePrimario : _colorePrimario_dark;
  Color get tileBackGroudColor => isLightMode ? Colors.white : const Color.fromARGB(255, 36, 36, 36);
  Color get textColor => !isLightMode ? Colors.white : Colors.black;
  Color get dialogBackgroudColor => isLightMode ? _colorePrimario : const Color.fromARGB(255, 36, 36, 36);
  Color get coloreHighlight => isLightMode ? _coloreHighlight : _coloreHighlight_dark;

  // final ColoriDB _db = ColoriDB();

  // Future<void> _loadData() async {
  //   await _db.init();

  //   if (_db.toInitialize) {
  //     _db.createInitialDataColori();
  //   }

  //   _temaAttuale = _db.temaAttuale;
  //   _coloreSecondario = _db.coloreSecondario;
  //   _coloreSecondario_dark = _db.coloreSecondario_dark;

  //   _initializationCompleter.complete();  // Segnala che l'inizializzazione è completa
  //   notifyListeners();
  // }

  // Future<void> _saveData() async {
  //   _db.coloreSecondario = _coloreSecondario;
  //   _db.coloreSecondario_dark = _coloreSecondario_dark;
  //   _db.temaAttuale = _temaAttuale;
  //   await _db.updateDatabaseColori();

  //   notifyListeners();
  // }

  void setTemaAttualeChiaroScuro(BuildContext context, String nuovoTema) {
    _temaAttuale = nuovoTema;
    isLightMode = _temaAttuale == "Chiaro";
    // _saveData();
  }

  void setTemaAttualeSistemaOperativo(BuildContext context) {
    _temaAttuale = "Sistema Operativo";
    initLightMode(context);
    // _saveData();
  }

  void initLightMode(BuildContext context) {
    if (_temaAttuale == "Sistema Operativo") {
      final brightness = MediaQuery.of(context).platformBrightness;
      isLightMode = brightness == Brightness.light;
      // _saveData();
      notifyListeners();
    }else{
      setTemaAttualeChiaroScuro(context, _temaAttuale);
    }
  }

  void updateLightMode(BuildContext context) {
    if (_temaAttuale == "Sistema Operativo") {
      final brightness = MediaQuery.of(context).platformBrightness;
      isLightMode = brightness != Brightness.light;
      // _saveData();
      notifyListeners();
    }
  }

  void setViolaColoreSecondario() {
    _coloreSecondario = Colors.purple.shade600;
    _coloreSecondario_dark = Colors.purple.shade400;
    // _saveData();
  }

  void setArancioneColoreSecondario() {
    _coloreSecondario = Colors.orange.shade600;
    _coloreSecondario_dark = Colors.orange.shade400;
    // _saveData();
  }

  void setBluColoreSecondario() {
    _coloreSecondario = Colors.indigo.shade800;
    _coloreSecondario_dark = Colors.indigo.shade300;
    // _saveData();
  }

  void setVerdeColoreSecondario() {
    _coloreSecondario = Colors.green.shade800;
    _coloreSecondario_dark = Colors.green.shade600;
    // _saveData();
  }
}
