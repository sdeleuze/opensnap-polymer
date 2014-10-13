import 'dart:io';
import 'dart:convert';
import 'package:di/di.dart';
import 'package:unittest/unittest.dart';
import 'package:redstone/server.dart' as app;
import 'package:redstone/mocks.dart';
import 'package:mongo_dart/mongo_dart.dart';
import 'package:os_common/os_common.dart';
import '../lib/snap_service.dart';

const uri = 'mongodb://localhost/test';
Db _db = new Db(uri);
DbCollection _snaps = _db.collection('snaps');

User _pauline = new User.fromId(new ObjectId().toHexString());
User _seb = new User.fromId(new ObjectId().toHexString());
User _baptiste = new User.fromId(new ObjectId().toHexString());

Snap _snap1 = new Snap(_pauline, [_seb], 'data:image/jpg;base64,/9j/4AAQSkZJR', 10, new ObjectId().toHexString());
Snap _snap2 = new Snap(_baptiste, [_pauline, _seb], 'data:image/jpg;base64,/9j/4AAQSkZJR', 10, new ObjectId().toHexString());

main() {
  
  setUp(() {
    app.setupConsoleLog();
    app.addModule(new Module()..bind(MongoPool, toValue: new MongoPool(uri)));
    app.addPlugin(ObjectMapper);
    app.setUp([#os_common, #os_snap]);
    
    return _db.open().then((_) => _snaps.drop().then((_) => _snaps.insertAll([_snap1.toJson(), _snap2.toJson()])));
  });

  tearDown(() {
    app.tearDown();
    return _db.close(); 
  });

  test('Create', () {
    Snap snap = new Snap(_seb, [_pauline, _baptiste], 'data:image/jpg;base64,/9j/4AAQSkZJR', 4);
    var req = new MockRequest('/snap/', method: app.POST, bodyType: app.JSON, body: snap.toJson());
    return app.dispatch(req).then((resp) {
      expect(resp.statusCode, equals(HttpStatus.OK));
      snap = new Snap.fromJson(JSON.decode(resp.mockContent));
      return _snaps.findOne(where.eq('_id', snap.id)).then((_) => expect(_, isNotNull));
    });
  });
  
  test('Get by id', () {
    var req = new MockRequest('/snap/${_snap1.id}');  
    return app.dispatch(req).then((resp) {
      expect(resp.statusCode, equals(HttpStatus.OK));
      Snap snap = new Snap.fromJson(JSON.decode(resp.mockContent));
      expect(snap, isNotNull);
      expect(snap.id, equals(_snap1.id));
    });
  });
  
  test('Get by author', () {
    var req = new MockRequest('/snap/sent/${_pauline.id}');  
    return app.dispatch(req).then((resp) {
      expect(resp.statusCode, equals(HttpStatus.OK));
      List<Snap> snaps = JSON.decode(resp.mockContent).map((_) => new Snap.fromJson(_)).toList();
      expect(snaps, isNotNull);
      expect(snaps.length, equals(1));
      expect(snaps[0].id, equals(_snap1.id));
    });
  });
  
  test('Get by recipient', () {
    var req = new MockRequest('/snap/received/${_seb.id}');  
    return app.dispatch(req).then((resp) {
      expect(resp.statusCode, equals(HttpStatus.OK));
      List<Snap> snaps = JSON.decode(resp.mockContent).map((_) => new Snap.fromJson(_)).toList();
      expect(snaps, isNotNull);
      expect(snaps.length, equals(2));
    });
  });
  
  test('Delete by id', () {
    var req = new MockRequest('/snap/${_snap1.id}', method: app.DELETE);  
    return app.dispatch(req).then((resp) {
      expect(resp.statusCode, equals(HttpStatus.OK));
      return _snaps.findOne(where.eq('_id', _snap1.id)).then((_) => expect(_, isNull));
    });
  });

}