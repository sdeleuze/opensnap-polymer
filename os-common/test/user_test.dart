import 'dart:convert';
import 'package:unittest/unittest.dart';
import 'package:os-common/os_common.dart';

main() {
 
  test('Serialize User', () {
    User user = new User('sdeleuze', 'azerty', ['USER', 'ADMIN'], "1234");
    String json = user.toJsonString();
    expect(json, equals('{"id":"1234","username":"sdeleuze","password":"azerty","roles":["USER","ADMIN"]}'));
  });
  
  test('Deserialize User', () {
    String json = '{"id":"1234","username":"sdeleuze","password":"azerty","roles":["USER","ADMIN"]}'; 
    User user = new User.fromJsonMap(JSON.decode(json));
    expect('1234', equals(user.id));
    expect('sdeleuze', equals(user.username));
    expect('azerty', equals(user.password));
    expect(['USER','ADMIN'], equals(user.roles));
  });
}