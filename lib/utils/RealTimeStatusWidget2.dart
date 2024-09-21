import 'dart:async';
import 'package:fleet_manager/providers/AddressProvider.dart';
import 'package:fleet_manager/utils/MyAlertDialog.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

class RealTimeStatusWidget2 extends StatefulWidget {


  RealTimeStatusWidget2();

  @override
  _RealTimeStatusWidget2State createState() => _RealTimeStatusWidget2State();
}

class _RealTimeStatusWidget2State extends State<RealTimeStatusWidget2> {

  bool _isConnected = false;
  Timer? _reconnectTimer;

  @override
  void initState() {
    super.initState();
    startPolling();
  }

  void setConnected(){
    setState(() {
      _isConnected = true;
    });
  }

  void resetConnected(){
    setState(() {
      _isConnected = false;
    });
  }

  void startPolling() async {

    _reconnectTimer = Timer.periodic(Duration(seconds: 1), (timer) async {

      final addressProvider = Provider.of<AddressProvider>(context, listen: false);

      if(_isConnected){
        
        try{
          final response = await http.get(Uri.parse(addressProvider.apiServerAddress + '/dashboard_config'));

          if (response.statusCode == 200) {
            setConnected();
          }
        }catch (e){
          showAlertDialog(context);
          resetConnected();
        }
      }else{
        try{
          final response = await http.get(Uri.parse(addressProvider.apiServerAddress + '/dashboard_config'));

          if (response.statusCode == 200) {
            setConnected();
          }
        }catch (e){
        }
      }
    });
  }

  Future showAlertDialog(BuildContext context) {
    return showDialog(
      context: context,
      builder: (context) => MyAlertDialog(alert_msg: "Ristabilire la connessione."),
    );
  }

  @override
  void dispose() {
    _reconnectTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [

          !_isConnected ? 

          Icon(Icons.error_rounded, color: Colors.red)
          :
          Icon(Icons.check_circle, color: Colors.green)
        ]
      ),
    );
  }
}