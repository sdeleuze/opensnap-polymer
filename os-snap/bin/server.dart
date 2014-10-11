import 'package:redstone/server.dart' as app;
import 'package:redstone_mapper/plugin.dart';
import 'package:redstone_mapper_mongo/manager.dart';

@app.Install()
import 'package:os_snap/snap_service.dart';

main() {

  app.setupConsoleLog();

  MongoDbManager dbManager = new MongoDbManager('mongodb://localhost/snaps');
  app.addPlugin(getMapperPlugin(dbManager, '/snap/.*'));

  app.start(port: 8082);
}