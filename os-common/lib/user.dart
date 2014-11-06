part of os_common;

class User {

  // TODO This should be a dynamic property
  static const String BASE_URL = 'http://localhost:8081/user/';

  String id;
  String username;
  String firstname;
  String lastname;
  String password;
  List<String> roles;

  User([this.username = null, this.firstname = null, this.lastname = null, this.password = null, List roles, this.id = null]) {
    this.roles = (roles == null) ? new List() : roles;
  }

  factory User.fromJson(value) {
    var json = value is String ? JSON.decode(value) : value;
    return new User(json['username'], json['firstname'], json['lastname'], json['password'], json['roles'], json['_id']);
  }

  factory User.fromId(String id) {
    return new User(null, null, null, null, [], id);
  }

  String get fullname => '$firstname $lastname';

  Map toJson({withPassword: false}) {
    Map json = {};
    if (id != null) json['_id'] = id;
    if (username != null) json['username'] = username;
    if (firstname != null) json['firstname'] = firstname;
    if (lastname != null) json['lastname'] = lastname;
    if (password != null && withPassword) json['password'] = password;
    if (roles != null && roles.isNotEmpty) json['roles'] = roles;
    return json;
  }

  Map toLink() {
    assert(id != null);
    return {'href':id};
  }

  bool operator ==(User other) {
    if (other is! User) return false;
    User u = other;
    return (u.id == id) && (u.username == username) && (u.password == password) && listEq(other.roles, roles);
  }

  static List<User> fromJsonList(value) {
    var json = value is String ? JSON.decode(value) : value;
    if (json is Map) {
      var list = [new User.fromJson(json)];
      return list;
    }
    return json.map((_) => new User.fromJson(_)).toList();
  }

}
