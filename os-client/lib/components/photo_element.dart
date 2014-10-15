library photo_element;

import 'dart:html';
import 'package:polymer/polymer.dart';
import 'package:paper_elements/paper_button.dart';
import 'package:os_common/os_common.dart';

@CustomTag('photo-element')
class PhotoElement extends PolymerElement {
  
  @published bool visible = true;
  @published ObservableList<User> users;
  
  VideoElement video;
  CanvasElement canvas;
  ImageElement photo;
  PaperButton sendButton, takePhotoButton;
  bool isReady = false;
  
  String _data;
  
  PhotoElement.created() : super.created() {
    Polymer.onReady.then((_) {
      video = this.$['video'];
      canvas = this.$['canvas'];
      photo = this.$['photo'];
      takePhotoButton = this.$['take-photo'];
      sendButton = this.$['send'];
      photo.hidden = true;
      window.navigator.getUserMedia(audio: false, video: true).then((s) {
        video.src = Url.createObjectUrlFromStream(s);
        if (video.readyState >= 3) {
          canPlay();
        } else {
          video.onCanPlay.listen((e) => canPlay()).onError((_) => this.$['webcamErrorToast'].show());
        }
      });
    });
  }
  
  void reset() {
    photo.hidden = true;
    video.hidden = false;
    sendButton.disabled = true;
    _data = '';
  }
  
  void canPlay() {
    canvas.width = video.videoWidth;
    canvas.height = video.videoHeight;
    isReady = true;
  }
  
  void takePhoto() {
      if(!isReady) {
        this.$['authorizeWebcamToast'].show();
        return;
      }
      canvas.context2D.drawImage(video, 0, 0);
      _data = canvas.toDataUrl('image/png');
      photo.src = _data;  
      video.hidden = true;
      photo.hidden = false;
      sendButton.disabled = false;
    }

    void sendSnap(event, detail, target) {
      if(this.$['duration'].selected == null) {
        this.$['durationToast'].show();
        return;
      }
      if(this.$['to'].selected == null) {
        this.$['recipientToast'].show();
        return;
      }
      int duration = int.parse(this.$['duration'].selected);
      // TODO Update whith the authenticated user
      User currentUser = users.first;
      User recipient =  new User.fromId(this.$['to'].selected);
      fire('send-snap', detail: new Snap(currentUser, [recipient], _data, duration));
    }
  
}