part of os_snap;

@app.Group('/snap')
class SnapService {

  DbCollection get _snaps => app.request.attributes.db.collection('snaps');
  Stomp.Client _stomClient;

  SnapService() {
    Socket.connect('127.0.0.1', 61613).then((socket) {
      Stomp.SocketAdapter adapter = new SocketAdapter(socket);
      _stomClient = new Stomp.Client(adapter);
      _stomClient.connect(login: 'guest', passcode: 'guest');
    });
  }

  @app.Route('/', methods: const [app.POST])
  create(@Decode() Snap snap) {
    if(snap.id == null) {
      snap.id = new ObjectId().toHexString();
    }
    var jsonSnap = snap.toJson();
    return _snaps.insert(jsonSnap).then((_) {
      snap.recipients.forEach((recipient) =>
        _stomClient.send('/topic/snap.inbox.${recipient.id}', body: JSON.encode(jsonSnap)));
      return jsonSnap;
    });
  }

  @app.Route('/:id')
  getById(String id) {
    if(id.contains(',')) {
      return _snaps.find(where.oneFrom('_id', id.split(','))).toList();
    } else {
      return _snaps.findOne(where.eq('_id', id));
    }
  }

  @app.Route('/received/:userId')
  received(String userId) => _snaps.find(where.eq('_links.u:recipients.href', userId)).toList();

  @app.Route('/sent/:userId')
  sent(String userId) => _snaps.find(where.eq('_links.u:author.href', userId)).toList();

  @app.Route('/:id', methods: const [app.DELETE])
  delete(String id) => _snaps.remove(where.eq('_id', id)).then((_) => _stomClient.send('/topic/snap.deleted', body: JSON.encode(id)));

}