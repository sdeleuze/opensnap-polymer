import 'package:redstone/server.dart' as app;
import 'package:di/di.dart';

@app.Install()
import 'package:os_user/user_service.dart';
@app.Install()
import 'package:os_common/os_common.dart';

main() {

  app.setupConsoleLog();
  app.addModule(new Module()..bind(MongoPool, toValue: new MongoPool('mongodb://localhost/users')));
  app.addPlugin(ObjectMapper);
  app.start(port: 8081);
}
