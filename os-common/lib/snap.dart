part of os_common;

class Snap {

  String id;
  User author;
  List<User> recipients;
  String photo;
  int duration;

  Snap([this.author, this.recipients, this.photo, this.duration, this.id = null]);

  factory Snap.fromJson(Map json) {
    var author = (json['author'] == null) ? null : new User.fromJson(json['author']);
    var recipients = (json['recipients'] == null) ? null : json['recipients'].map((_) => new User.fromJson(_)).toList();
    return new Snap(author, recipients, json['photo'], json['duration'], json['_id']);
  }

  Map toJson() {
      var jsonRecipients = recipients.map((_) => _.toJson()).toList();
      return {'_id': id, 'author': author.toJson(), 'recipients': jsonRecipients, 'photo': photo, 'duration': duration};
  }

  bool operator == (other) {
    if (other is! Snap) return false;
    Snap s = other;
    return ((s.id == id) && (s.author == author) && listEq(s.recipients, recipients) && (s.photo == photo) && (s.duration == duration));
  }

}
