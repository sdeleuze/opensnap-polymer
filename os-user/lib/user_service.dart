part of os_user;

@app.Group('/user')
class UserService {

 DbCollection get _users => app.request.attributes.db.collection('users');
 String text;

  @app.Route('/')
  list() => _users.find().toList();

  @app.Route('/', methods: const [app.POST])
  create(@Decode() User user) {
    if(user.id == null) {
      user.id = new ObjectId().toHexString();
    }
    var jsonUser = user.toJson();
    return _users.insert(jsonUser).then((_) => jsonUser);
  }

  @app.Route('/:id')
  getById(String id) {
    if(id.contains(',')) {
      return _users.find(where.oneFrom('_id', id.split(','))).toList();
    } else {
      return _users.findOne(where.eq('_id', id)); 
    }
  }

  @app.Route('/name/:name')
  getByName(String name) => _users.findOne(where.eq('username', name));


  @app.Route('/:id', methods: const [app.DELETE])
  delete(String id) => _users.remove(where.eq('_id', id));

}
