library app_element;

import 'package:polymer/polymer.dart';
import 'package:core_elements/core_drawer_panel.dart';
import 'package:os_common/os_common.dart';
import '../os_client.dart';

@CustomTag('app-element')
class AppElement extends PolymerElement {
  
  static const _PHOTO = 0;
  static const _RECEIVED = 1;
  static const _SENT = 2;
  
  @observable
  final ObservableList<User> users = new ObservableList<User>();
  @observable
  final ObservableList<Snap> snapSent = new ObservableList<Snap>();
  @observable
  final ObservableList<Snap> snapReceived = new ObservableList<Snap>();
  @observable
  int selected = _PHOTO;
  
  UserSync _userSync = new UserSync();
  SnapSync _snapSync = new SnapSync();
  StompListener _stompListener = new StompListener();
  
  AppElement.created() : super.created() {
    _userSync.getAll().then((_) {
      users.addAll(_); 
      // TODO Update whith the authenticated user
      User currentUser = users.first;
      _snapSync.getSent(currentUser).then((_) => snapSent.addAll(_));
      _snapSync.getReceived(currentUser).then((_) => snapReceived.addAll(_));
      _stompListener.subscribeSnapInbox(currentUser, onReceived);
    });
  }
  
  void onReceived(Snap snap) {
    //this.$['snapReceivedToast'].show();
    snapReceived.add(snap);
  }
  
  void toggleMenu() {
    var drawerPanel = this.$['drawerPanel'] as CoreDrawerPanel;
    drawerPanel.togglePanel();
  }
  
  void sendSnap(event, details, target) {
//    this.$['sendSnapStartToast'].show();
    Snap snap = details;
    _snapSync.send(snap).then((_) {
      snapSent.add(_);
      selected = _SENT;
      this.$['sendSnapCompletedToast'].show();
      this.$['photoElement'].reset();
    });
  }
  
  void deleteSnap(event, details, target) {
    Snap snap = details;
    _snapSync.delete(snap).then((_) {
      snapSent.remove(snap);
      snapReceived.remove(snap);
    });
  }

}