library os_snap;

import 'dart:io';
import 'dart:convert';
import 'package:redstone/server.dart' as app;
import 'package:mongo_dart/mongo_dart.dart';
import 'package:os_common/os_common.dart';
import 'package:os_common/os_common_server.dart';
import 'package:stompdart/stomp.dart' as Stomp;
import 'package:stompdart/socketadapter.dart';

@app.Group('/snap')
class SnapService {
  
  DbCollection get _snaps => app.request.attributes.db.collection("snaps");
  Stomp.Client _stomClient;
  
  SnapService() {
    Socket.connect('127.0.0.1', 61613).then((socket) {
      Stomp.SocketAdapter adapter = new SocketAdapter(socket);
      _stomClient = new Stomp.Client(adapter);
      _stomClient.connect(login: 'guest', passcode: 'guest');
    });
  }

  @app.Route('/', methods: const [app.POST], statusCode: HttpStatus.CREATED)
  create(@Decode() Snap snap) {
    if(snap.id == null) {
      snap.id = new ObjectId().toHexString();
    }
    var jsonSnap = snap.toJson();
    return _snaps.insert(jsonSnap).then((_) {
      snap.recipients.forEach((recipient) =>
        _stomClient.send('/queue/snap.inbox.${recipient.id}', body: JSON.encode(jsonSnap)));
      return jsonSnap;
    });
  }
  
  @app.Route('/:id')
  getById(String id) {
    if(id.contains(',')) {
      return _snaps.find(where.oneFrom('_id', id.split(','))).toList();
    } else {
      return _snaps.findOne(where.eq('_id', id));
    }
  }
   
  @app.Route('/received/:userId')
  received(String userId) => _snaps.find(where.eq('_links.u:recipients.href', userId)).toList();
  
  @app.Route('/sent/:userId')
  sent(String userId) => _snaps.find(where.eq('_links.u:author.href', userId)).toList();
      
  @app.Route('/:id', methods: const [app.DELETE], statusCode: HttpStatus.NO_CONTENT)
  delete(String id) => _snaps.remove(where.eq('_id', id)).then((_) => true);

}