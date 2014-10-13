library os_snap;

import 'package:redstone/server.dart' as app;
import 'package:mongo_dart/mongo_dart.dart';
import 'package:os_common/os_common.dart';

@app.Group('/snap')
class SnapService {
  
  DbCollection get snaps => app.request.attributes.db.collection("snaps");

  @app.Route('/', methods: const [app.POST])
  create(@Decode() Snap snap) {
    if(snap.id == null) {
      snap.id = new ObjectId().toHexString();
    }
    var jsonSnap = snap.toJson();
    return snaps.insert(jsonSnap).then((_) => jsonSnap);
  }
  
  @app.Route('/:id')
  getById(String id) {
    if(id.contains(',')) {
      return snaps.find(where.oneFrom('_id', id.split(','))).toList();
    } else {
      return snaps.findOne(where.eq('_id', id)); 
    }
  }
  
  @app.Route('/received/:userId')
  received(String userId) => snaps.find(where.eq('_links.u:recipients.href', userId)).toList();
  
  @app.Route('/sent/:userId')
  sent(String userId) => snaps.find(where.eq('_links.u:author.href', userId)).toList();
      
  @app.Route('/:id', methods: const [app.DELETE])
  delete(String id) => snaps.remove(where.eq('_id', id)).then((_) => true);

}