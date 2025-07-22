class PostInfo {
  late int emojiTotal, commentTotal, shareTotal;
  late String currentIcon;
  final String avatarUser, nameUser, datePost, title, content;
  final List<String> imageContent;
  final List<String> comments;
  PostInfo({
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
    required this.comments,
  });
}
