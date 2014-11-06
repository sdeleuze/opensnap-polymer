part of os_client;

class UserSync {
  static const String _baseUrl = 'http://localhost:8081/user/';

  Future<List<User>> getAll() =>
      HttpRequest.request('$_baseUrl').then((HttpRequest req) {
    return User.fromJsonList(req.response);
  });
}
