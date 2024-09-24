import 'package:hive/hive.dart';

class TemaDB {

  bool toInitialize = true;
  String temaAttuale = "Sistema Operativo";

  Box<dynamic>? _temaBox;

  Future<void> init() async {
    _temaBox = await Hive.openBox('temaDB');
    loadDataTema();
  }

  void createInitialDataColori() {
    temaAttuale = "Sistema Operativo";
    toInitialize = false;

    updateDatabaseTema();
  }

  void loadDataTema() {
    temaAttuale = _temaBox?.get("temaAttuale", defaultValue: "Sistema Operativo") ?? "Sistema Operativo";
    toInitialize = _temaBox?.get("toInitialize", defaultValue: true) ?? true;
  }

  Future<void> updateDatabaseTema() async {
    await _temaBox?.put('temaAttuale', temaAttuale);
    await _temaBox?.put('toInitialize', toInitialize);
  }
}
