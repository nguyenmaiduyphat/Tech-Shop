class NewsDetail {
  final String image;
  final String title;
  final String content;
  final String owner;
  final String date;
  late int views;
  late int likes;
  late int dislikes;
  final String id;

  NewsDetail({
    required this.image,
    required this.title,
    required this.content,
    required this.owner,
    required this.date,
    required this.views,
    required this.likes,
    required this.dislikes,
    required this.id,
  });
  Map<String, dynamic> toMap() {
    return {
      'image': image,
      'title': title,
      'content': content,
      'owner': owner,
      'date': date,
      'views': views,
      'likes': likes,
      'dislikes': dislikes,
      'id': id,
    };
  }

  factory NewsDetail.fromMap(Map<String, dynamic> map) {
    return NewsDetail(
      image: map['image'] ?? '',
      title: map['title'] ?? '',
      content: map['content'] ?? '',
      owner: map['owner'] ?? '',
      date: map['date'] ?? '',
      views: map['views'] ?? 0,
      likes: map['likes'] ?? 0,
      dislikes: map['dislikes'] ?? 0,
      id: map['id'] ?? '',
    );
  }
}
