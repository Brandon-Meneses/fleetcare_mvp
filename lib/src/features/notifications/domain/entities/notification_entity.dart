class NotificationEntity {
  final int id;
  final String title;
  final String content;
  final String? link;
  final bool read;
  final DateTime createdAt;

  NotificationEntity({
    required this.id,
    required this.title,
    required this.content,
    this.link,
    required this.read,
    required this.createdAt,
  });

  factory NotificationEntity.fromJson(Map<String, dynamic> json) {
    return NotificationEntity(
      id: json["id"],
      title: json["title"],
      content: json["content"],
      link: json["link"],
      read: json["read"] ?? false,
      createdAt: DateTime.parse(json["createdAt"]),
    );
  }

  Map<String, dynamic> toJson() => {
    "id": id,
    "title": title,
    "content": content,
    "link": link,
    "read": read,
    "createdAt": createdAt.toIso8601String(),
  };
}