library os_user;

import 'dart:async';
import 'package:redstone/server.dart' as app;
import 'package:redstone_mapper/plugin.dart';
import 'package:redstone_mapper_mongo/service.dart';
import 'package:mongo_dart/mongo_dart.dart';

import 'package:os_common/os_common.dart';

@app.Group('/user')
@Encode()
class UserService extends MongoDbService<User> {

  UserService() : super('users');

  @app.Route('/')
  Future<List<User>> list() => find();

  @app.Route('/', methods: const [app.POST])
  Future<User> create(@Decode() User user) {
    if(user.id == null) {
      user.id = new ObjectId().toHexString();
    }
    return insert(user).then((_) => user);
  }
  
  @app.Route('/:id')
  Future<User> getById(String id) =>
      findOne(where.id(ObjectId.parse(id)));
  
  @app.Route('/name/:name')
    Future<User> getByName(String name) =>
        findOne(where.eq('username', name));
      
      
  @app.Route('/:id', methods: const [app.DELETE])
  Future<bool> delete(String id) =>
    remove(where.id(ObjectId.parse(id))).then((_) => true);

}