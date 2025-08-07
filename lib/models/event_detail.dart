class EventDetail {
  final String image;
  final String title;
  final String content;
  final String owner;
  final String location;
  final String date;
  final int attendees;

  EventDetail({
    required this.image,
    required this.title,
    required this.content,
    required this.owner,
    required this.location,
    required this.date,
    required this.attendees,
  });
  Map<String, dynamic> toMap() {
    return {
      'image': image,
      'title': title,
      'content': content,
      'owner': owner,
      'location': location,
      'date': date,
      'attendees': attendees,
    };
  }

  factory EventDetail.fromMap(Map<String, dynamic> map) {
    return EventDetail(
      image: map['image'] ?? '',
      title: map['title'] ?? '',
      content: map['content'] ?? '',
      owner: map['owner'] ?? '',
      location: map['location'] ?? '',
      date: map['date'] ?? '',
      attendees: map['attendees'] ?? 0,
    );
  }
}
