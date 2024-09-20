import 'dart:async';
import 'package:fleet_manager/providers/ColorsProvider.dart';
import 'package:fleet_manager/utils/MyAlertDialog.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

class RealTimeStatusWidget extends StatefulWidget {


  RealTimeStatusWidget();

  @override
  _RealTimeStatusWidgetState createState() => _RealTimeStatusWidgetState();
}

class _RealTimeStatusWidgetState extends State<RealTimeStatusWidget> {

  final String apiServerAddress_tasks = "http://192.168.1.5:8000";
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

    Timer.periodic(Duration(seconds: 1), (timer) async {

      if(_isConnected){
        try{
          final response = await http.get(Uri.parse('$apiServerAddress_tasks/tasks'));

          if (response.statusCode == 200) {
            setConnected();
            print("all good");
          }
        }catch (e){
          print("not anymore");
          showAlertDialog(context);
          resetConnected();
        }
      }else{
        try{
          final response = await http.get(Uri.parse('$apiServerAddress_tasks/tasks'));

          if (response.statusCode == 200) {
            setConnected();
            print("all good");
          }
        }catch (e){
          print("not anymore");
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
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: _isConnected ? Colors.green : Colors.red,
            ),
            width: 12,
            height: 12,
          ),
          SizedBox(
            width: 6,
          ),
          Text(
            _isConnected ? "Connesso" : "Non Connesso",
            style: GoogleFonts.encodeSans(
              color: Provider.of<ColorsProvider>(context, listen: false).coloreTitoli,
              fontSize: 20,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
