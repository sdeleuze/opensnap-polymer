import 'package:redstone/server.dart' as app;
import 'package:di/di.dart';
import 'package:mongo_dart/mongo_dart.dart';
import 'package:os_common/os_common.dart';
@app.Install()
import 'package:os_user/os_user.dart';
@app.Install()
import 'package:os_common/os_common_server.dart';

main() {

  app.setupConsoleLog();
  Db db = new Db('mongodb://localhost/users');
  app.addModule(new Module()..bind(Db, toValue: db));
  app.addPlugin(ObjectMapper);
  app.start(port: 8081);
  
  User pauline = new User('Pauline', 'azerty', ['USER'], '543b80c33786c930f70e3960');
  User seb = new User('Seb', 'qwerty', ['USER', 'ADMIN'], '543b80c33786c930f70e3961');
  User baptiste = new User('Baptiste', '12345', ['USER'], '543b80c33786c930f70e3962');
  
  db.open().then((_) => db.collection("users").drop().then((_) => db.collection("users").insertAll([pauline.toJson(), seb.toJson(), baptiste.toJson()])));
}
