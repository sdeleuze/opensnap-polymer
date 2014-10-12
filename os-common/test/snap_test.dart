import 'dart:convert';
import 'package:unittest/unittest.dart';
import 'package:os_common/os_common.dart';

main() {

  test('Serialize', () {
    Snap snap = new Snap(new User.fromId('12'), [new User.fromId('34'), new User.fromId('56')], 'data:image/jpg;base64,/9j/4AAQSkZJR', 10, '54394905de442c3a8b250258');
    String json = JSON.encode(snap.toJson());
    expect(json, equals('{"_id":"54394905de442c3a8b250258","author":{"_id":"12"},"recipients":[{"_id":"34"},{"_id":"56"}],"photo":"data:image/jpg;base64,/9j/4AAQSkZJR","duration":10}'));
  });

  test('Deserialize', () {
    String json = '{"_id":"54394905de442c3a8b250258","author":{"_id":"12"},"recipients":[{"_id":"34"},{"_id":"56"}],"photo":"data:image/jpg;base64,/9j/4AAQSkZJR","duration":10}';
    Snap snap = new Snap.fromJson(JSON.decode(json));
    expect('54394905de442c3a8b250258', equals(snap.id));
    expect(new User.fromId('12'), equals(snap.author));
    expect([new User.fromId('34'),new User.fromId('56')], equals(snap.recipients));
    expect('data:image/jpg;base64,/9j/4AAQSkZJR', equals(snap.photo));
    expect(10, equals(snap.duration));
  });

  test('Equals', () {
    Snap snap1 = new Snap(new User.fromId('12'), [new User.fromId('34'), new User.fromId('56')], 'data:image/jpg;base64,/9j/4AAQSkZJR', 10, '54394905de442c3a8b250258');
    Snap snap2 = new Snap(new User.fromId('12'), [new User.fromId('34'), new User.fromId('56')], 'data:image/jpg;base64,/9j/4AAQSkZJR', 10, '54394905de442c3a8b250258');
    expect(snap1, equals(snap2));
    Snap snap3 = new Snap(null, null, null, null, '54394905de442c3a8b250258');
    Snap snap4 = new Snap(null, null, null, null, '54394905de442c3a8b250258');
    expect(snap3, equals(snap4));
  });

}
