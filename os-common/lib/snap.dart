part of os_common;

class Snap {

  String id;
  User author;
  List<User> recipients;
  String photo;
  int duration;

  Snap([this.author, this.recipients, this.photo, this.duration, this.id = null]);

  factory Snap.fromJson(value) {
    var json = value is String ? JSON.decode(value) : value;
    var author = (json['_links'] != null && json['_links']['u:author'] != null) ? new User.fromId(json['_links']['u:author']['href']) : null;
    var recipients = (json['_links'] != null && json['_links']['u:recipients'] != null) ? json['_links']['u:recipients'].map((_) => new User.fromId(_['href'])).toList() : null;
    return new Snap(author, recipients, json['photo'], json['duration'], json['_id']);
  }

  Map toJson() {
    Map json = {};
    if(id != null) json['_id'] = id;
    if(photo != null) json['photo'] = photo;
    if(duration != null) json['duration'] = duration;
    var jsonLinks = {'curies': [{ 'name': 'u', 'href': '${User.BASE_URL}{rel}', 'templated': true }]};
    if(author != null && author.id != null) jsonLinks['u:author'] = author.toLink();
    if(recipients != null && recipients.isNotEmpty) jsonLinks['u:recipients'] = recipients.map((_) => _.toLink()).toList(); 
    if(jsonLinks.length > 1) json['_links'] = jsonLinks;
    return json;
  }

  bool operator == (other) {
    if (other is! Snap) return false;
    Snap s = other;
    return ((s.id == id) && (s.author == author) && listEq(s.recipients, recipients) && (s.photo == photo) && (s.duration == duration));
  }
  
  static List<Snap> fromJsonList(value) {
      var json = value is String ? JSON.decode(value) : value;
      if(json is Map) {
        var list = [new Snap.fromJson(json)];
        return list;
      }
      return json.map((_) => new Snap.fromJson(_)).toList();  
    }
      
}
