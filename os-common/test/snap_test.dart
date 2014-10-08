import 'dart:convert';
import 'package:unittest/unittest.dart';
import 'package:os-common/os_common.dart';

main() {
 
  test('Serialize Snap', () {
    Snap snap = new Snap('12', ['34', '56'], '78', 10, '90');
    String json = snap.toJsonString();
    expect(json, equals('{"id":"90","authorId":"12","recipientIds":["34","56"],"photo":"78","duration":10}'));
  });
  
  test('Deserialize Snap', () {
      String json = '{"id":"90","authorId":"12","recipientIds":["34","56"],"photo":"78","duration":10}'; 
      Snap snap = new Snap.fromJsonMap(JSON.decode(json));
      expect('90', equals(snap.id));
      expect('12', equals(snap.authorId));
      expect(['34','56'], equals(snap.recipientIds));
      expect('78', equals(snap.photo));
      expect(10, equals(snap.duration));
     });
  
}