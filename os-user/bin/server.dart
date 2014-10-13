import 'package:redstone/server.dart' as app;
import 'package:di/di.dart';

@app.Install()
import 'package:os_user/os_user.dart';
@app.Install()
import 'package:os_common/os_common.dart';

main() {

  app.setupConsoleLog();
  MongoPool pool = new MongoPool('mongodb://localhost/users');
  app.addModule(new Module()..bind(MongoPool, toValue: pool));
  app.addPlugin(ObjectMapper);
  app.start(port: 8081);
  
  User pauline = new User('Pauline', 'azerty', ['USER'], '543b80c33786c930f70e3960');
  User seb = new User('Seb', 'qwerty', ['USER', 'ADMIN'], '543b80c33786c930f70e3961');
  User baptiste = new User('Baptiste', '12345', ['USER'], '543b80c33786c930f70e3962');
  
  pool.getConnection().then((db) => db.conn.collection("users").drop().then((_) => db.conn.collection("users").insertAll([pauline.toJson(), seb.toJson(), baptiste.toJson()]).then((_) => db.conn.close())));
}
