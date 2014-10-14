import 'package:redstone/server.dart' as app;
import 'package:di/di.dart';
import 'package:os_common/os_common.dart';
import 'package:mongo_dart/mongo_dart.dart';
@app.Install()
import 'package:os_snap/snap_service.dart';
@app.Install()
import 'package:os_common/os_common_server.dart';

main() {

  app.setupConsoleLog();
  app.addModule(new Module()..bind(Db, toValue: new Db('mongodb://localhost/snaps')));
  app.addPlugin(ObjectMapper);
  app.start(port: 8082);

}
