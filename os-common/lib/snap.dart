part of os_common;

class Snap {
  
  @Field() String id;
  @Field() String authorId;
  @Field() List<String> recipientIds;
  @Field() String photo;
  @Field() int duration;

  Snap(this.authorId, this.recipientIds, this.photo, this.duration, [this.id = null]);
 
  factory Snap.fromJsonMap(Map json) {
    return new Snap(json['authorId'], json['recipientIds'], json['photo'], json['duration'], json['id']);
  }
    
  Map toJson() => {'id': id, 'authorId': authorId, 'recipientIds': recipientIds, 'photo': photo, 'duration': duration};
  
  String toJsonString() => JSON.encode(toJson());

  bool operator == (other) {
    if (other is! Snap) return false;
    Snap s = other;
    return (s.id == id);
  }
  
}