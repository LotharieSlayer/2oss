import 'dart:async';
import 'dart:io';

import 'package:two_oss/main.dart';

class WebSocketService {
  late HttpServer _server;
  WebSocket? _socket;
  final _controller = StreamController<String>();

  Stream<String> get messages => _controller.stream;

  Future<void> startServer() async {
    _server = await HttpServer.bind('0.0.0.0', 9897);
    print('WebSocket server running at ws://${_server.address.address}:${_server.port}');

    _server.listen((HttpRequest request) async {
      if (WebSocketTransformer.isUpgradeRequest(request)) {
        _socket = await WebSocketTransformer.upgrade(request);
        print('Client connected.');

        // Push a notification that the user can remove each second
        await notifRepo.createNotification(false, null);

        _socket!.listen(
          (message) {
            print('Message from client: $message');
            _controller.add(message);
          },
          onDone: () {
            print('Client disconnected.');
            _socket = null;
          },
        );
      } else {
        request.response
          ..statusCode = HttpStatus.forbidden
          ..write('WebSocket connections only')
          ..close();
      }
    });
  }

  void sendMessage(String message) {
    if (_socket != null) {
      _socket!.add(message);
    } else {
      print('No active WebSocket connection.');
    }
  }

  void dispose() {
    _controller.close();
    _server.close();
  }
}