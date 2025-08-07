class CommentDetail {
  final String id;
  final String content;
  final String avatar;
  final String user;

  CommentDetail({
    required this.id,
    required this.content,
    required this.avatar,
    required this.user,
  });

  Map<String, dynamic> toMap() {
    return {'id': id, 'content': content, 'avatar': avatar, 'user': user};
  }

  factory CommentDetail.fromMap(Map<String, dynamic> map) {
    return CommentDetail(
      id: map['id'] ?? '',
      content: map['content'] ?? '',
      avatar: map['avatar'] ?? '',
      user: map['user'] ?? '',
    );
  }
}
