import 'package:redstone/server.dart' as app;
import 'package:di/di.dart';

@app.Install()
import 'package:os_snap/snap_service.dart';
@app.Install()
import 'package:os_common/os_common.dart';

main() {

  app.setupConsoleLog();
  MongoPool pool = new MongoPool('mongodb://localhost/snaps');
  app.addModule(new Module()..bind(MongoPool, toValue: pool));
  app.addPlugin(ObjectMapper);
  app.start(port: 8082);
  
  User pauline = new User.fromId('543b80c33786c930f70e3960');
  User seb = new User.fromId('543b80c33786c930f70e3961');
  User baptiste = new User.fromId('543b80c33786c930f70e3962');
  
  Snap snap1 = new Snap(pauline, [seb], 'data:image/jpg;base64,/9j/4AAQSkZJR', 10, '563b80c33786c930f70e4000');
  Snap snap2 = new Snap(baptiste, [pauline, seb], 'data:image/jpg;base64,/9j/4AAQSkZJR', 10, '563b80c33786c930f70e4001');

  pool.getConnection().then((db) => db.conn.collection("snaps").drop().then((_) => db.conn.collection("snaps").insertAll([snap1.toJson(), snap2.toJson()]).then((_) => db.conn.close())));
}
