part of os_common;

class User {
  
  @Field() String id;
  @Field() String username;
  @Field() String password;
  @Field() List<String> roles;

  User([this.username = "", this.password = "", List roles, this.id = null]) {
    this.roles = (roles == null) ? new List() : roles;
  }
    
  factory User.fromJsonMap(Map json) {
    return new User(json['username'], json['password'], json['roles'], json['id']);
  }
  
  Map toJson() => {'id': id, 'username': username, 'password': password, 'roles': roles};
  
  String toJsonString() => JSON.encode(toJson());
  
  bool operator == (User other) => (other.username == username) && listEq(other.roles, roles);
  
}