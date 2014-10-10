part of os_common;

class User {
  
  @Id() String id;
  @Field() String username;
  @Field() String password;
  @Field() List<String> roles;

  User([this.username = "", this.password = "", List roles, this.id = null]) {
    this.roles = (roles == null) ? new List() : roles;
  }
    
  bool operator == (User other) => (other.username == username) && listEq(other.roles, roles);
  
}