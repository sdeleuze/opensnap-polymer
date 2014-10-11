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
import '../lib/snap_service.dart';

const uri = 'mongodb://localhost/test';
Db _db = new Db(uri);
DbCollection _snaps = _db.collection('snaps');

String _paulineId = new ObjectId().toHexString();
String _sebId = new ObjectId().toHexString();
String _baptisteId = new ObjectId().toHexString();

Map _snap1 = {'_id': new ObjectId(), 'authorId': _paulineId, 'recipientIds': [_sebId], 'duration': 10};
Map _snap2 = {'_id': new ObjectId(), 'authorId': _baptisteId, 'recipientIds': [_paulineId, _sebId], 'duration': 4};

main() {
  
  setUp(() {
    app.setupConsoleLog();
    app.addPlugin(getMapperPlugin(new MongoDbManager(uri), '/snap/.*'));
    app.setUp([#os_snap]);
    
    return _db.open().then((_) => _snaps.drop().then((_) => _snaps.insertAll([_snap1, _snap2])));
  });

  tearDown(() {
    app.tearDown();
    return _db.close(); 
  });

  test('Create snap', () {
    Snap snap = new Snap(_sebId, [_paulineId, _baptisteId], 'data:image/jpg;base64,/9j/4AAQSkZJR', 4);
    var req = new MockRequest('/snap/', method: app.POST, bodyType: app.JSON, body: encode(snap));
    return app.dispatch(req).then((resp) {
      expect(resp.statusCode, equals(HttpStatus.OK));
      snap = decode(JSON.decode(resp.mockContent), Snap);
      return _snaps.findOne(where.id(new ObjectId.fromHexString(snap.id))).then((_) => expect(_, isNotNull));
    });
  });
  
  test('Get snap by id', () {
    var req = new MockRequest('/snap/${_snap1['_id'].toHexString()}');  
    return app.dispatch(req).then((resp) {
      expect(resp.statusCode, equals(HttpStatus.OK));
      Snap snap = decode(JSON.decode(resp.mockContent), Snap);
      expect(snap, isNotNull);
      expect(snap.id, equals(_snap1['_id'].toHexString()));
    });
  });
  
  test('Get snap by author', () {
    var req = new MockRequest('/snap/sent/${_paulineId}');  
    return app.dispatch(req).then((resp) {
      expect(resp.statusCode, equals(HttpStatus.OK));
      List<Snap> snaps = decode(JSON.decode(resp.mockContent), Snap);
      expect(snaps, isNotNull);
      expect(snaps.length, equals(1));
      expect(snaps[0].id, equals(_snap1['_id'].toHexString()));
    });
  });
  
  test('Get snap by recipient', () {
    var req = new MockRequest('/snap/received/${_sebId}');  
    return app.dispatch(req).then((resp) {
      expect(resp.statusCode, equals(HttpStatus.OK));
      List<Snap> snaps = decode(JSON.decode(resp.mockContent), Snap);
      expect(snaps, isNotNull);
      expect(snaps.length, equals(2));
    });
  });
  
  test('Delete snap by id', () {
    var req = new MockRequest('/snap/${_snap1['_id'].toHexString()}', method: app.DELETE);  
    return app.dispatch(req).then((resp) {
      expect(resp.statusCode, equals(HttpStatus.OK));
      return _snaps.findOne(where.id(_snap1['_id'])).then((_) => expect(_, isNull));
    });
  });

}