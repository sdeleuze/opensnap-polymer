library os_user;

import 'dart:async';
import 'dart:io';

import 'package:redstone/server.dart' as app;
import 'package:mongo_dart/mongo_dart.dart';

import 'package:os_common/os_common_server.dart';
import 'package:os_common/os_common.dart';

@app.Group('/user')
class UserService {
  DbCollection get _users => app.request.attributes.db.collection('users');

  @app.Route('/')
  Future list() => _users.find().toList();

  @app.Route('/', methods: const [app.POST], statusCode: HttpStatus.CREATED)
  Future create(@Decode() User user) {
    if (user.id == null) {
      user.id = new ObjectId().toHexString();
    }
    var jsonUser = user.toJson();
    return _users.insert(jsonUser).then((_) => jsonUser);
  }

  @app.Route('/:id')
  getById(String id) {
    if (id.contains(',')) {
      return _users.find(where.oneFrom('_id', id.split(','))).toList();
    } else {
      return _users.findOne(where.eq('_id', id));
    }
  }

  @app.Route('/name/:name')
  Future<Map> getByName(String name) => _users.findOne(where.eq('username', name));

  @app.Route('/:id', methods: const [app.DELETE], statusCode: HttpStatus.NO_CONTENT)
  Future delete(String id) => _users.remove(where.eq('_id', id));
}
