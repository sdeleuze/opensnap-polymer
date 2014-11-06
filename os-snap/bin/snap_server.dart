import 'package:redstone/server.dart' as app;
import 'package:di/di.dart';
import 'package:mongo_dart/mongo_dart.dart';
@app.Install()
import 'package:os_snap/os_snap.dart';
@app.Install()
import 'package:os_common/os_common_server.dart';

main() {

  app.setupConsoleLog();
  Db db = new Db('mongodb://localhost/snaps');
  db.open().then((_) {
    app.addModule(new Module()..bind(Db, toValue: db));
    app.addPlugin(ObjectMapper);
    app.start(port: 8082);
  });
}
