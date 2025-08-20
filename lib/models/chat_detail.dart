class ChatDetail {
  final String idUser;
  final String idShop;
  final String avatar;
  final String content;
  final String owner;
  final String date;
  final List<String> images;

  ChatDetail({
    required this.idUser,
    required this.idShop,
    required this.avatar,
    required this.content,
    required this.owner,
    required this.date,
    required this.images,
  });
  Map<String, dynamic> toMap() {
    return {
      'idUser': idUser,
      'idShop': idShop,
      'avatar': avatar,
      'content': content,
      'owner': owner,
      'date': date,
      'images': images,
    };
  }

  factory ChatDetail.fromMap(Map<String, dynamic> map) {
    return ChatDetail(
      idUser: map['idUser'] ?? '',
      idShop: map['idShop'] ?? '',
      avatar: map['avatar'] ?? '',
      content: map['content'] ?? '',
      owner: map['owner'] ?? '',
      date: map['date'] ?? '',
      images: List<String>.from(map['images'] ?? []),
    );
  }
}
