library received_element;

import 'dart:async';

import 'package:polymer/polymer.dart';

import 'package:os_common/os_common.dart';

@CustomTag('received-element')
class ReceivedElement extends PolymerElement {

  @published bool visible = true;
  @published ObservableList<Snap> snaps;
  @observable String data = "";
  @observable int progressValue = 0;
  @observable int progressMaxValue = 0;

  ReceivedElement.created() : super.created();

  void viewSnap(event, details, target) {
    String snapId = target.attributes['snap-id'];
    Snap snap = snaps.singleWhere((_) => _.id == snapId);
    progressValue = 0;
    progressMaxValue = snap.duration * 1000;
    data = snap.photo;
    this.$['snap-dialog'].toggle();
    new Timer.periodic(new Duration(milliseconds: 10), (Timer t) {
      if (progressValue == snap.duration * 1000) {
        fire('delete-snap', detail: snap);
        this.$['snap-dialog'].toggle();
        data = "";
        t.cancel();
      }
      progressValue = progressValue + 10;
    });
  }

}
