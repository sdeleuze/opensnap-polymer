part of os_client;

class SnapSync {
  
  final String _baseUrl = 'http://localhost:8082/snap/';
  final SnapAssembler _assembler = new SnapAssembler(new BrowserClient());
  
  Future<Snap> send(Snap snap) =>
    HttpRequest.request('$_baseUrl', method: 'POST', requestHeaders: {'Content-Type': 'application/json'}, sendData: JSON.encode(snap.toJson())).then((HttpRequest req) {
      return _assembler.fetch(new Snap.fromJson(req.response));
  });
  
  Future<List<Snap>> getReceived(User user) =>
    HttpRequest.request('${_baseUrl}received/${user.id}').then((HttpRequest req) {
      List<Snap> snaps = Snap.fromJsonList(req.response);
      return _assembler.fetchAll(snaps);
  });
  
  Future<List<Snap>> getSent(User user) =>
    HttpRequest.request('${_baseUrl}sent/${user.id}').then((HttpRequest req) {
      List<Snap> snaps = Snap.fromJsonList(req.response);
      return _assembler.fetchAll(snaps);
  });
  
  Future delete(Snap snap) => HttpRequest.request('$_baseUrl${snap.id}', method: 'DELETE').then((HttpRequest req) => true);
 
}