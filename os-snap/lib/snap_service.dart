library os_snap;

import 'dart:async';
import 'package:redstone/server.dart' as app;
import 'package:redstone_mapper/plugin.dart';
import 'package:redstone_mapper_mongo/service.dart';
import 'package:mongo_dart/mongo_dart.dart';

import 'package:os_common/os_common.dart';

@app.Group('/snap')
@Encode()
class SnapService extends MongoDbService<Snap> {

  SnapService() : super('snaps');

  @app.Route('/', methods: const [app.POST])
  Future<Snap> create(@Decode() Snap snap) {
    if(snap.id == null) {
      snap.id = new ObjectId().toHexString();
    }
    return insert(snap).then((_) => snap);
  }
  
  @app.Route('/:id')
  Future<Snap> getById(String id) =>
    findOne(where.id(ObjectId.parse(id)));
  
  @app.Route('/received/:userId')
  Future<List<Snap>> received(String userId) =>
    find(where.eq('recipientIds', userId));
  
  @app.Route('/sent/:userId')
  Future<List<Snap>> sent(String userId) =>
    find(where.eq('authorId', userId));
      
  @app.Route('/:id', methods: const [app.DELETE])
  Future<bool> delete(String id) =>
    remove(where.id(ObjectId.parse(id))).then((_) => true);

}