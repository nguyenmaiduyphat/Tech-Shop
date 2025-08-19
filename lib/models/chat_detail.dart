class ChatDetail {
  final String id;
  final String avatar;
  final String content;
  final String owner;
  final String date;
  final List<String> images;

  ChatDetail({
    required this.id,
    required this.avatar,
    required this.content,
    required this.owner,
    required this.date,
    required this.images,
  });
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'avatar': avatar,
      'content': content,
      'owner': owner,
      'date': date,
      'images': images,
    };
  }

  factory ChatDetail.fromMap(Map<String, dynamic> map) {
    return ChatDetail(
      id: map['id'] ?? '',
      avatar: map['avatar'] ?? '',
      content: map['content'] ?? '',
      owner: map['owner'] ?? '',
      date: map['date'] ?? '',
      images: List<String>.from(map['images'] ?? []),
    );
  }
}
