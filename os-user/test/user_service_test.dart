import 'dart:io';
import 'dart:convert';
import 'package:unittest/unittest.dart';
import 'package:redstone/server.dart' as app;
import 'package:redstone/mocks.dart';
import 'package:redstone_mapper/plugin.dart';
import 'package:redstone_mapper/mapper.dart';
import 'package:redstone_mapper_mongo/manager.dart';
import 'package:mongo_dart/mongo_dart.dart';
import 'package:os_common/os_common.dart';
import '../lib/user_service.dart';

const uri = 'mongodb://localhost/test';
Db _db = new Db(uri);
DbCollection _users = _db.collection('users');

Map _pauline = {'_id': new ObjectId(), 'username': 'Pauline', 'password': 'azerty', 'roles': ['USER']};
Map _seb = {'_id': new ObjectId(), 'username': 'Seb', 'password': 'qwerty', 'roles': ['USER', 'ADMIN']};

main() {
  
  setUp(() {
    app.setupConsoleLog();
    app.addPlugin(getMapperPlugin(new MongoDbManager(uri), '/user/.*'));
    app.setUp([#os_user]);
    
    return _db.open().then((_) => _users.drop().then((_) => _users.insertAll([_pauline, _seb])));
  });

  tearDown(() {
    app.tearDown();
    return _db.close(); 
  });

  test('Create user', () {
    var req = new MockRequest('/user/', method: app.POST, bodyType: app.JSON, body: encode(new User('Bob')));
    return app.dispatch(req).then((resp) {
      expect(resp.statusCode, equals(HttpStatus.OK));
      User bob = decode(JSON.decode(resp.mockContent), User);
      return _users.findOne(where.id(new ObjectId.fromHexString(bob.id))).then((_) => expect(_, isNotNull));
    });
  });
  
  test('List all users', () {
    var req = new MockRequest('/user/');
    return app.dispatch(req).then((resp) {
      expect(resp.statusCode, equals(HttpStatus.OK));
      List<User> users = decode(JSON.decode(resp.mockContent), User);
      expect(users, isNotNull);
      expect(users.length, equals(2));
    });
  });
  
  test('Get user by id', () {
    var req = new MockRequest('/user/${_pauline['_id'].toHexString()}');  
    return app.dispatch(req).then((resp) {
      expect(resp.statusCode, equals(HttpStatus.OK));
      User user = decode(JSON.decode(resp.mockContent), User);
      expect(user, isNotNull);
      expect(user.id, equals(_pauline['_id'].toHexString()));
    });
  });
  
  test('Get user by name', () {  
    var req = new MockRequest('/user/name/${_pauline['username']}');  
    return app.dispatch(req).then((resp) {
      expect(resp.statusCode, equals(HttpStatus.OK));
      User user = decode(JSON.decode(resp.mockContent), User);
      expect(user, isNotNull);
      expect(user.id, equals(_pauline['_id'].toHexString()));
    });
  });
  
  test('Delete user by id', () {
    var req = new MockRequest('/user/${_pauline['_id'].toHexString()}', method: app.DELETE);  
    return app.dispatch(req).then((resp) {
      expect(resp.statusCode, equals(HttpStatus.OK));
      return _users.findOne(where.id(_pauline['_id'])).then((_) => expect(_, isNull));
    });
  });

}