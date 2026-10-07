import 'dart:async';
import 'dart:convert';

import 'package:logging/logging.dart';

import 'package:http/http.dart' as http;

final _log = Logger('wt_client');

class WarThunderHttpClient {
  new() {
    Timer.periodic(Duration(milliseconds: 500), (_) => update());
  }

  void update() {
    _log.fine('Update');
    final endpoints = [
      '/mission.json',
      '/map_obj.json',
      '/map_info.json',
      //'/gamechat?lastId='+lastChatRecId,
      '/hudmsg',
      '/indicators',
      '/state',
    ];

    for (final endpoint in endpoints) {
      var url = Uri.http('127.0.0.1:8111', endpoint);
      http.get(url).then((response) {
        _log.fine('Endpoint: $endpoint');
        _log.fine('Response status: ${response.statusCode}');
        _log.finest('Response body: ${response.body}');

        if (endpoint == '/indicators' && response.statusCode == 200) {
          final json = jsonDecode(response.body);

          if (json["valid"] == false || json["valid"] == null) return;
          final type = json["type"] as String;
          _streamController.add(type);
        }
      });
    }
  }

  Stream<String> get selectedAircraftId => _streamController.stream;

  final _streamController = StreamController<String>();
}
