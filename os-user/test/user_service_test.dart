import 'dart:io';

import 'package:di/di.dart';
import 'package:mongo_dart/mongo_dart.dart';
import 'package:redstone/mocks.dart';
import 'package:redstone/server.dart' as app;
import 'package:unittest/unittest.dart';

import 'package:os_common/os_common.dart';
import 'package:os_common/os_common_server.dart';

const uri = 'mongodb://localhost/test';
Db _db = new Db(uri);
DbCollection _users = _db.collection('users');

User _pauline = new User('pauphan', 'Pauline', 'Auphan', 'azerty', ['USER'], '543b80c33786c930f70e3960');
User _seb = new User('sdeleuze', 'Sébastien', 'Deleuze', 'qwerty', ['USER', 'ADMIN'], '543b80c33786c930f70e3961');
User _baptiste = new User('bmeurant', 'Baptiste', 'Meurant', '12345', ['USER'], '543b80c33786c930f70e3962');

void main() {
  setUp(() {
    app.setupConsoleLog();
    app.addModule(new Module()..bind(Db, toValue: _db));
    app.addPlugin(ObjectMapper);
    app.setUp([#os_common, #os_user]);

    return _db.open().then((_) => _users.drop().then((_) => _users.insertAll([_pauline.toJson(), _seb.toJson()])));
  });

  tearDown(() {
    app.tearDown();
    return _db.close();
  });

  test('Create', () {
    var req = new MockRequest('/user/', method: app.POST, bodyType: app.JSON, body: new User('Bob').toJson());
    return app.dispatch(req).then((resp) {
      expect(resp.statusCode, equals(HttpStatus.CREATED));
      User bob = new User.fromJson(resp.mockContent);
      expect(bob, isNotNull);
      expect(bob.id, isNotNull);
      return _users.findOne(where.eq('_id', bob.id)).then((_) => expect(_, isNotNull));
    });
  });

  test('List all', () {
    var req = new MockRequest('/user/');
    return app.dispatch(req).then((resp) {
      expect(resp.statusCode, equals(HttpStatus.OK));
      List<User> users = User.fromJsonList(resp.mockContent);
      expect(users, isNotNull);
      expect(users.length, equals(2));
    });
  });

  test('Get by id', () {
    var req = new MockRequest('/user/${_pauline.id}');
    return app.dispatch(req).then((resp) {
      expect(resp.statusCode, equals(HttpStatus.OK));
      User user = new User.fromJson(resp.mockContent);
      expect(user, isNotNull);
      expect(user.id, equals(_pauline.id));
    });
  });

  test('Get by ids', () {
    var req = new MockRequest('/user/${_pauline.id},${_seb.id}');
    return app.dispatch(req).then((resp) {
      expect(resp.statusCode, equals(HttpStatus.OK));
      List<User> users = User.fromJsonList(resp.mockContent);
      expect(users, isNotNull);
      expect(users.length, equals(2));
    });
  });

  test('Get by name', () {
    var req = new MockRequest('/user/name/${_pauline.username}');
    return app.dispatch(req).then((resp) {
      expect(resp.statusCode, equals(HttpStatus.OK));
      User user = new User.fromJson(resp.mockContent);
      expect(user, isNotNull);
      expect(user.id, equals(_pauline.id));
    });
  });

  test('Delete by id', () {
    var req = new MockRequest('/user/${_pauline.id}', method: app.DELETE);
    return app.dispatch(req).then((resp) {
      expect(resp.statusCode, equals(HttpStatus.NO_CONTENT));
      return _users.findOne(where.eq('_id', _pauline.id)).then((_) => expect(_, isNull));
    });
  });
}
