import 'dart:convert';
import 'package:unittest/unittest.dart';
import 'package:os_common/os_common.dart';
import 'package:redstone_mapper/mapper.dart';
import 'package:redstone_mapper/mapper_factory.dart';

main() {
  
  setUp(() => bootstrapMapper());
 
  test('Serialize User', () {
    User user = new User('sdeleuze', 'azerty', ['USER', 'ADMIN'], "1234");
    String json = JSON.encode(encode(user));
    expect(json, equals('{"id":"1234","username":"sdeleuze","password":"azerty","roles":["USER","ADMIN"]}'));
  });
  
  test('Deserialize User', () {
    String json = '{"id":"1234","username":"sdeleuze","password":"azerty","roles":["USER","ADMIN"]}'; 
    User user = decode(JSON.decode(json), User);
    expect('1234', equals(user.id));
    expect('sdeleuze', equals(user.username));
    expect('azerty', equals(user.password));
    expect(['USER','ADMIN'], equals(user.roles));
  });
}