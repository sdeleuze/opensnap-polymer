part of os_common;

class User {

  String id;
  String username;
  String password;
  List<String> roles;

  User([this.username = null, this.password = null, List roles, this.id = null]) {
    this.roles = (roles == null) ? new List() : roles;
  }

  factory User.fromJson(Map json) {
      return new User(json['username'], json['password'], json['roles'], json['_id']);
  }

  factory User.fromId(String id) {
      return new User(null, null, [], id);
  }

  Map toJson() {
    Map json = {};
    if(id != null) json['_id'] = id;
    if(username != null) json['username'] = username;
    if(password != null) json['password'] = password;
    if(roles != null && roles.isNotEmpty) json['roles'] = roles;
    return json;
  }

  bool operator == (User other) {
    if (other is! User) return false;
    User u = other;
    return (u.id == id) && (u.username == username) && (u.password == password) && listEq(other.roles, roles);
  }

}
