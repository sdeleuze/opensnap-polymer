library app_element;

import 'package:polymer/polymer.dart';
import 'package:core_elements/core_drawer_panel.dart';
import 'package:os_common/os_common.dart';
import '../os_client.dart';

@CustomTag('app-element')
class AppElement extends PolymerElement {
  
  @observable final ObservableList<User> users = new ObservableList<User>();
  @observable final ObservableList<Snap> snapSent = new ObservableList<Snap>();
  @observable final ObservableList<Snap> snapReceived = new ObservableList<Snap>();
  @observable String visibleContent = 'Photo';
  
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
      _stompListener.subscribeSnapInbox(currentUser, onCreated);
    });
  }
  
  void onCreated(Snap snap) {
    snapReceived.add(snap);
    this.$['snapReceivedToast'].show();
  }
  
  void toggleMenu() {
    var drawerPanel = this.$['drawerPanel'] as CoreDrawerPanel;
    drawerPanel.togglePanel();
  }
  
  int selectedMenuItem(String content) {
    switch(content) {
      case 'Photo': return 0;
      case 'Received': return 1;
      case 'Sent': return 2;
    }
    return -1;
  }
  
  void onMenuItemClick(event, details, target) {
    visibleContent = target.label;
  }
  
  void sendSnap(event, details, target) {
    //this.$['sendSnapStartToast'].show();
    Snap snap = details;
    _snapSync.send(snap).then((_) {
      snapSent.add(_);
      visibleContent = 'Sent';
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