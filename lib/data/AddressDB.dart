import 'package:hive/hive.dart';

class AddressDB {

  bool toInitialize = true;
  String ipAddress = "192.168.1.5";
  bool useLocalhost = false;

  Box<dynamic>? _addressBox;

  Future<void> init() async {
    _addressBox = await Hive.openBox('addressDB');
    loadDataAddress();
  }

  void createInitialDataColori() {
    ipAddress = "192.168.1.5";
    useLocalhost = false;
    toInitialize = false;

    updateDatabaseAddress();
  }

  void loadDataAddress() {
    ipAddress = _addressBox?.get("ipAddress", defaultValue: "192.168.1.5") ?? "192.168.1.5";
    useLocalhost = _addressBox?.get("useLocalhost", defaultValue: false) ?? false;
    toInitialize = _addressBox?.get("toInitialize", defaultValue: true) ?? true;
  }

  Future<void> updateDatabaseAddress() async {
    await _addressBox?.put('ipAddress', ipAddress);
    await _addressBox?.put('toInitialize', toInitialize);
    await _addressBox?.put('useLocalhost', useLocalhost);
  }
}
