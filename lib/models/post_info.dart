import 'package:tech_fun/models/comment_detail.dart';

class PostInfo {
  final String id;
  late int emojiTotal, commentTotal, shareTotal;
  late String currentIcon;
  final String avatarUser, nameUser, datePost, title, content;
  final List<String> imageContent;
  PostInfo({
    required this.id,
    required this.emojiTotal,
    required this.commentTotal,
    required this.shareTotal,
    required this.currentIcon,
    required this.avatarUser,
    required this.nameUser,
    required this.datePost,
    required this.title,
    required this.content,
    required this.imageContent,
  });
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'emojiTotal': emojiTotal,
      'commentTotal': commentTotal,
      'shareTotal': shareTotal,
      'currentIcon': currentIcon,
      'avatarUser': avatarUser,
      'nameUser': nameUser,
      'datePost': datePost,
      'title': title,
      'content': content,
      'imageContent': imageContent,
    };
  }

  factory PostInfo.fromMap(Map<String, dynamic> map) {
    return PostInfo(
      id: map['id'] ?? 0,
      emojiTotal: map['emojiTotal'] ?? 0,
      commentTotal: map['commentTotal'] ?? 0,
      shareTotal: map['shareTotal'] ?? 0,
      currentIcon: map['currentIcon'] ?? '',
      avatarUser: map['avatarUser'] ?? '',
      nameUser: map['nameUser'] ?? '',
      datePost: map['datePost'] ?? '',
      title: map['title'] ?? '',
      content: map['content'] ?? '',
      imageContent: List<String>.from(map['imageContent'] ?? []),
    );
  }
}
