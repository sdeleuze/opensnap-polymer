library app_element;

import 'dart:js';

import 'package:core_elements/core_drawer_panel.dart';
import 'package:paper_elements/paper_dropdown_menu.dart';
import 'package:polymer/polymer.dart';

import 'package:os_client/os_client.dart';
import 'package:os_common/os_common.dart';

@CustomTag('app-element')
class AppElement extends PolymerElement {

  static const _PHOTO = 0;
  static const _RECEIVED = 1;
  static const _SENT = 2;

  @published String user;
  @observable User currentUser;
  @observable final ObservableList<User> users = new ObservableList<User>();
  @observable final ObservableList<Snap> snapSent = new ObservableList<Snap>();
  @observable final ObservableList<Snap> snapReceived =
      new ObservableList<Snap>();
  @observable int selected = _PHOTO;

  UserSync _userSync = new UserSync();
  SnapSync _snapSync = new SnapSync();
  StompListener _stompListener = new StompListener();

  AppElement.created() : super.created() {
    _userSync.getAll().then((_) {
      users.addAll(_);
      currentUser = (user == null) ? currentUser = users.first : users.singleWhere((_) => _.username == user);
      (this.$['currentUserMenu'] as PaperDropdownMenu).selected = currentUser.id;
      changeUser();
    });
  }

  void changeUser() {
    _snapSync.getSent(currentUser).then((_) => snapSent..clear()..addAll(_));
    _snapSync.getReceived(currentUser).then((_) => snapReceived..clear()..addAll(_));
    _stompListener.subscribeSnapInbox(currentUser, onSnapReceived);
    _stompListener.subscribeSnapDeleted(onSnapDeleted);
  }

  void onSnapReceived(Snap snap) {
    this.$['snapReceivedToast'].show();
    snapReceived.add(snap);
  }

  void onSnapDeleted(String id) {
    snapReceived.removeWhere((snap) => snap.id == id);
    snapSent.removeWhere((snap) => snap.id == id);
  }

  void toggleMenu() {
    var drawerPanel = this.$['drawerPanel'] as CoreDrawerPanel;
    drawerPanel.togglePanel();
  }

  void sendSnap(event, details, target) {
    this.$['sendSnapStartToast'].show();
    Snap snap = details;
    _snapSync.send(snap).then((_) {
      snapSent.add(_);
      selected = _SENT;
      this.$['sendSnapCompletedToast'].show();
      this.$['photoElement'].reset();
    });
  }

  void onSelectUser(event, details, target) {

        // Improve this not very nice syntax when https://code.google.com/p/dart/issues/detail?id=19315
    // will be fixed
    var isSelected = new JsObject.fromBrowserObject(event)['detail']['isSelected'];
    if(target.selected != null && isSelected) {
      currentUser = users.singleWhere((_) => _.id == target.selected);
      changeUser();
    }
  }

  void deleteSnap(event, details, target) {
    Snap snap = details;
    _snapSync.delete(snap).then((_) {
      snapSent.remove(snap);
      snapReceived.remove(snap);
    });
  }

}
