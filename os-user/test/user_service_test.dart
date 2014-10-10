import 'package:unittest/unittest.dart';
import 'package:redstone/server.dart' as app;
import 'package:redstone/mocks.dart';
import 'package:redstone_mapper/plugin.dart';
import 'package:redstone_mapper/mapper.dart';
import "package:redstone_mapper_mongo/manager.dart";
import 'package:mongo_dart/mongo_dart.dart';
import 'dart:io';
import 'dart:convert';

import 'package:os_common/os_common.dart';
import '../lib/user_service.dart';

main() {
  
  MongoDbManager dbManager = new MongoDbManager("mongodb://localhost/users");

setUp(() {
  app.setupConsoleLog();
  app.addPlugin(getMapperPlugin(dbManager, "/user/.*"));
  app.setUp([#os_user]);
  
  return dbManager.getConnection().then((MongoDb db) {
    DbCollection users = db.collection("users");
    return users.drop().then((_) => db.insertAll(users, [encode(new User("Pauline", "azerty")), encode(new User("Seb", "azerty"))]));
  });
});

tearDown(() => app.tearDown());

test("Create user", () {
  var req = new MockRequest("/user/", method: app.POST, bodyType: app.JSON, body: encode(new User("Bob")));
  return app.dispatch(req).then((resp) {
    expect(resp.statusCode, equals(HttpStatus.OK));
  });
});

test("List all users", () {
  
  var req = new MockRequest("/user/");
  return app.dispatch(req).then((resp) {
    expect(resp.statusCode, equals(HttpStatus.OK));
    List<User> users = decode(JSON.decode(resp.mockContent), User);
    expect(users, isNotNull);
    expect(users.length, equals(2));
  });
});

test("Get a user by id", () {
  return dbManager.getConnection().then((db) =>
    db.findOne("users", User).then((dbUser) {
      var req = new MockRequest('/user/${dbUser.id}');  
      return app.dispatch(req).then((resp) {
        expect(resp.statusCode, equals(HttpStatus.OK));
        User user = decode(JSON.decode(resp.mockContent), User);
        expect(user, isNotNull);
        expect(user, equals(dbUser));
      });
    })
  );
});

test("Get a user by name", () {  
  var req = new MockRequest('/user/name/Pauline');  
  return app.dispatch(req).then((resp) {
    expect(resp.statusCode, equals(HttpStatus.OK));
    User user = decode(JSON.decode(resp.mockContent), User);
    expect(user, isNotNull);
    expect(user.username, equals("Pauline"));
  });
});

test("Delete a user by id", () {
  return dbManager.getConnection().then((db) =>
    db.findOne("users", User).then((dbUser) {
      var req = new MockRequest('/user/${dbUser.id}', method: app.DELETE);  
      return app.dispatch(req).then((resp) {
        expect(resp.statusCode, equals(HttpStatus.OK));
        return db.find("users", User, where.id(ObjectId.parse(dbUser.id))).then((_) {
          expect(_.isEmpty, isTrue);
        });
      });
    })
  );
});

}