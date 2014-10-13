library navbar_element;

import 'package:polymer/polymer.dart';
import 'package:core_elements/core_drawer_panel.dart';

@CustomTag('app-element')
class AppElement extends PolymerElement {
  
  AppElement.created() : super.created();
  
  void toggleMenu() {
    var drawerPanel = this.$['drawerPanel'] as CoreDrawerPanel;
    drawerPanel.togglePanel();
  }
}