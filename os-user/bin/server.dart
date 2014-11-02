import 'package:redstone/server.dart' as app;
import 'package:di/di.dart';
import 'package:mongo_dart/mongo_dart.dart';
import 'package:os_common/os_common.dart';
@app.Install()
import 'package:os_user/os_user.dart';
@app.Install()
import 'package:os_common/os_common_server.dart';

main() {

  User pauline = new User('pauphan', 'Pauline', 'Auphan', 'azerty', ['USER'], '543b80c33786c930f70e3960');
  User seb = new User('sdeleuze', 'Sébastien', 'Deleuze', 'qwerty', ['USER', 'ADMIN'], '543b80c33786c930f70e3961');
  User baptiste = new User('bmeurant', 'Baptiste', 'Meurant', '12345', ['USER'], '543b80c33786c930f70e3962');

  app.setupConsoleLog();
  Db db = new Db('mongodb://localhost/users');
  db.open().then((_) => db.collection("users").drop().then((_) => db.collection("users").insertAll([seb.toJson(), pauline.toJson(), baptiste.toJson()]))).then((_) {
    app.addModule(new Module()..bind(Db, toValue: db));
    app.addPlugin(ObjectMapper);
    app.start(port: 8081);
  });

}
