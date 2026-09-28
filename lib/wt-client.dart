import 'dart:async';

import 'package:http/http.dart' as http;

class WarThunderHttpClient {
  new() {
    Timer.periodic(Duration(milliseconds: 500), (_) => update());
  }

  void update() {
    print('Update');
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
        print('Endpoint: $endpoint');
        print('Response status: ${response.statusCode}');
        print('Response body: ${response.body}');
      });
    }
    /*
      $.ajax({type:'GET', url:'/mission.json',  success:format_mission_data })
      $.ajax({type:'GET', url:'/map_obj.json',  success:update_object_positions })
      $.ajax({type:'GET', url:'/map_info.json', success:update_map_info })
      $.ajax({type:'GET', url:'/gamechat?lastId='+lastChatRecId, success:update_game_chat })
      $.ajax({type:'GET', url:'/hudmsg', data:{'lastEvt':lastEvtMsgId, 'lastDmg':lastDmgMsgId}, success:update_hud_msg })
      $.ajax({type:'GET', url:'/indicators',    success:update_indicators })
      $.ajax({type:'GET', url:'/state',         success:update_state,
         error: function(jqXHR, textStatus, errorThrown) {
          alert(textStatus + '\n' + errorThrown)
        }
      })
     */
  }

  //final Stream<String> data;
}
