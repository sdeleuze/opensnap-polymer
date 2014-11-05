part of os_client;

class StompListener {
  
  Stomp.Client _stompClient;
  Future<Stomp.Frame> _connectedFuture;
  bool connected = false;
  final SnapAssembler _assembler = new SnapAssembler(new BrowserClient());
  
  StreamSubscription snapInboxSubscription;
  StreamSubscription snapDeletedSubscription;
  
  StompListener() {
    SockJSAdapter adapter = new SockJSAdapter.fromUrl('http://127.0.0.1:15674/stomp');
    _stompClient = new Stomp.Client(adapter);
    // Need to add and configure 127.0.0.1 vistual host in RabbitMQ admin
    _connectedFuture = _stompClient.connect(login: 'guest', passcode: 'guest').then((_) {
      connected = true;
      return _;
    });
  }
  
  void subscribeSnapInbox(User recipient, void onCreated(Snap snap)) {
    if(connected) {
      _subscribeSnapInbox(recipient, onCreated);
    } else {
      _connectedFuture.then((_) => _subscribeSnapInbox(recipient, onCreated));
    }
  }
  
  void _subscribeSnapInbox(User recipient, void onCreated(Snap snap)) {
    if(snapInboxSubscription != null) {
      snapInboxSubscription.cancel();
    }
    snapInboxSubscription = _stompClient.subscribe('/topic/snap.inbox.${recipient.id}').listen((Stomp.Frame frame) {
        String body = frame.body;
        Snap snap = new Snap.fromJson(JSON.decode(body));
        _assembler.fetch(snap).then((snap) =>  onCreated(snap));
    });
  }
  
  void subscribeSnapDeleted(void onDeleted(String id)) {
    if(connected) {
      _subscribeSnapDeleted(onDeleted);
    } else {
      _connectedFuture.then((_) => _subscribeSnapDeleted(onDeleted));
    }
  }
  
  void _subscribeSnapDeleted(void onDeleted(String id)) {
    if(snapDeletedSubscription != null) {
      snapDeletedSubscription.cancel();
    }
    snapDeletedSubscription = _stompClient.subscribe('/topic/snap.deleted').listen((Stomp.Frame frame) {
    onDeleted(JSON.decode(frame.body));
    });
  }
}
