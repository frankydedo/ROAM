import 'package:web_socket_channel/web_socket_channel.dart';

class WebSocketService {

  final WebSocketChannel channel;

  Stream<dynamic> get stream => channel.stream;

  WebSocketService(String url) : channel = WebSocketChannel.connect(Uri.parse(url));

  void sendMessage(String message) {
    channel.sink.add(message);
  }

  void close() {
    channel.sink.close();
  }
}
