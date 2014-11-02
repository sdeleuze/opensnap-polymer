import 'dart:convert';
import 'package:unittest/unittest.dart';
import 'package:os_common/os_common.dart';

main() {

  test('Serialize', () {
    User user = new User('sdeleuze', 'Sébastien', 'Deleuze', 'azerty', ['USER', 'ADMIN'], "54394905de442c3a8b250257");
    String json = JSON.encode(user.toJson());
    expect(json, equals('{"_id":"54394905de442c3a8b250257","username":"sdeleuze","firstname":"Sébastien","lastname":"Deleuze","roles":["USER","ADMIN"]}'));
  });
  
  test('Serialize with password', () {
      User user = new User('sdeleuze', 'Sébastien', 'Deleuze', 'azerty', ['USER', 'ADMIN'], "54394905de442c3a8b250257");
      String json = JSON.encode(user.toJson(withPassword: true));
      expect(json, equals('{"_id":"54394905de442c3a8b250257","username":"sdeleuze","firstname":"Sébastien","lastname":"Deleuze","password":"azerty","roles":["USER","ADMIN"]}'));
    });

  test('Deserialize', () {
    String json = '{"_id":"54394905de442c3a8b250257","username":"sdeleuze","firstname":"Sébastien","lastname":"Deleuze","password":"azerty","roles":["USER","ADMIN"]}';
    User user = new User.fromJson(JSON.decode(json));
    expect('54394905de442c3a8b250257', equals(user.id));
    expect('sdeleuze', equals(user.username));
    expect('Sébastien', equals(user.firstname));
    expect('Deleuze', equals(user.lastname));
    expect('azerty', equals(user.password));
    expect(['USER','ADMIN'], equals(user.roles));
  });

  test('Equals', () {
      User user1 = new User('sdeleuze','Sébastien', 'Deleuze', 'azerty', ['USER', 'ADMIN'], "54394905de442c3a8b250257");
      User user2 = new User('sdeleuze','Sébastien', 'Deleuze', 'azerty', ['USER', 'ADMIN'], "54394905de442c3a8b250257");
      expect(user1, equals(user2));
      User user3 = new User.fromId("54394905de442c3a8b250257");
      User user4 = new User.fromId("54394905de442c3a8b250257");
      expect(user3, equals(user4));
  });
}
