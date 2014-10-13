library os_user;

import 'package:redstone/server.dart' as app;
import 'package:mongo_dart/mongo_dart.dart';
import 'package:os_common/os_common.dart';

@app.Group('/user')
class UserService {

 DbCollection get users => app.request.attributes.db.collection("users");

  @app.Route('/')
  list() => users.find().toList();

  @app.Route('/', methods: const [app.POST])
  create(@Decode() User user) {
    if(user.id == null) {
      user.id = new ObjectId().toHexString();
    }
    var jsonUser = user.toJson();
    return users.insert(jsonUser).then((_) => jsonUser);
  }

  @app.Route('/:id')
    getById(String id) {
      if(id.contains(',')) {
        return users.find(where.oneFrom('_id', id.split(','))).toList();
      } else {
        return users.findOne(where.eq('_id', id)); 
      }
    }

  @app.Route('/name/:name')
  getByName(String name) => users.findOne(where.eq('username', name));


  @app.Route('/:id', methods: const [app.DELETE])
  delete(String id) => users.remove(where.eq('_id', id)).then((_) => true);

}
