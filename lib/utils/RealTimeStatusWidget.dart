import 'package:flutter/material.dart';
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

  @override
  void initState() {
    super.initState();
    _initializeWebSocket();
  }

  void _initializeWebSocket() {
    _channel = WebSocketChannel.connect(Uri.parse(widget.url));
    _channel.stream.listen(
      (message) {
        // You can handle incoming messages here if needed
      },
      onDone: () {
        setState(() {
          _isConnected = false;
        });
      },
      onError: (error) {
        setState(() {
          _isConnected = false;
        });
      },
    );

    setState(() {
      _isConnected = true;
    });
  }

  @override
  void dispose() {
    _channel.sink.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100,
      height: 100,
      color: _isConnected ? Colors.green : Colors.red,
      child: Center(
        child: Text(
          _isConnected ? 'Connected' : 'Disconnected',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
