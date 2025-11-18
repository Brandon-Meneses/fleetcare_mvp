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
class PageNotifications {
  final List<NotificationEntity> items;
  final int page;
  final int size;
  final int totalItems;
  final int totalPages;
  final bool hasNext;

  PageNotifications({
    required this.items,
    required this.page,
    required this.size,
    required this.totalItems,
    required this.totalPages,
    required this.hasNext,
  });

  factory PageNotifications.fromJson(Map<String, dynamic> json) {
    return PageNotifications(
      items: (json["items"] as List)
          .map((e) => NotificationEntity.fromJson(e))
          .toList(),
      page: json["page"],
      size: json["size"],
      totalItems: json["totalItems"],
      totalPages: json["totalPages"],
      hasNext: json["hasNext"],
    );
  }
}