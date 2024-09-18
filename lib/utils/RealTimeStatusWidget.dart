import 'dart:async';
import 'package:fleet_manager/providers/ColorsProvider.dart';
import 'package:fleet_manager/utils/MyAlertDialog.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class RealTimeStatusWidget extends StatefulWidget {

  final String url;

  RealTimeStatusWidget({required this.url});

  @override
  _RealTimeStatusWidgetState createState() => _RealTimeStatusWidgetState();
}

class _RealTimeStatusWidgetState extends State<RealTimeStatusWidget> {

  late WebSocketChannel _channel;
  bool _isConnected = false;
  Timer? _reconnectTimer;

  @override
  void initState() {
    super.initState();
    _initializeWebSocket();
  }

  Future showAlertDialog(BuildContext context) {
    return showDialog(
      context: context,
      builder: (context) => MyAlertDialog(alert_msg: "Ristabilire la connessione e riavviare l'app."),
    );
  }

  void _initializeWebSocket() {
    try {
      _channel = WebSocketChannel.connect(Uri.parse(widget.url));
      _isConnected = true;

      _channel.stream.listen(
        (message) {
          // TODO: Handle incoming messages if needed
        },
        onDone: () {
          showAlertDialog(context);
          setState(() {
            _isConnected = false;
          });
        },
        onError: (error) {
          showAlertDialog(context);
          setState(() {
            _isConnected = false;
          });
        },
      );
    } catch (e) {
      setState(() {
        _isConnected = false;
      });
    }
  }


  @override
  void dispose() {
    _channel.sink.close();
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
