part of os_common;

class SnapAssembler {
  
  // http.Client or ClientBrowser instance
  var _client;
  
  SnapAssembler(this._client);
  
  Future<Snap> fetch(Snap snap) {
    List userIds =  snap.recipients.map((user) => user.id).toList();
    userIds.add(snap.author.id);
    return _client.get(Uri.parse('${User.BASE_URL}${userIds.join(',')}'),headers: {'Accept': 'application/json'}).then((response) {
      List<User> users = User.fromJsonList(response.body);
      snap.author = users.singleWhere((user) => user.id == snap.author.id);
      snap.recipients = snap.recipients.map((recipient) => users.singleWhere((user) => user.id == recipient.id)).toList();
      return snap;
    });
  }
    
  Future<List<Snap>> fetchAll(List<Snap> snaps) {
    Set userIds = new Set();
    snaps.forEach((snap) {
      snap.recipients.forEach((user) => userIds.add(user.id));
      userIds.add(snap.author.id);
    });
    return _client.get(Uri.parse('${User.BASE_URL}${userIds.join(',')}'),headers: {'Accept': 'application/json'}).then((response) {
      List<User> users = User.fromJsonList(response.body);
      snaps.forEach((snap) {
        snap.author = users.singleWhere((user) => user.id == snap.author.id);
        snap.recipients = snap.recipients.map((recipient) => users.singleWhere((user) => user.id == recipient.id)).toList();
      });
      return snaps;
    });
  }
  
}