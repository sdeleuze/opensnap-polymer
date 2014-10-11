import 'package:redstone/server.dart' as app;
import 'package:redstone_mapper/plugin.dart';
import 'package:redstone_mapper_mongo/manager.dart';

@app.Install()
import 'package:os_user/user_service.dart';

main() {

  app.setupConsoleLog();

  MongoDbManager dbManager = new MongoDbManager('mongodb://localhost/users');
  app.addPlugin(getMapperPlugin(dbManager, '/user/.*'));

  app.start(port: 8081);
}