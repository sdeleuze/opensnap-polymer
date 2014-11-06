library sent_element;

import 'package:polymer/polymer.dart';

import 'package:os_common/os_common.dart';

@CustomTag('sent-element')
class SentElement extends PolymerElement {

  @published bool visible = true;
  @published ObservableList<Snap> snaps;

  SentElement.created() : super.created();

}
