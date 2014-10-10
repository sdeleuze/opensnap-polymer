part of os_common;

class Snap {
  
  @Id() String id;
  @Field() String authorId;
  @Field() List<String> recipientIds;
  @Field() String photo;
  @Field() int duration;

  Snap([this.authorId, this.recipientIds, this.photo, this.duration, this.id = null]);

  bool operator == (other) {
    if (other is! Snap) return false;
    Snap s = other;
    return (s.id == id);
  }
  
}