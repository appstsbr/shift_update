class EventType {
  final int? id;
  final String? name;
  final String? icon;
  final String? color;
  final String? createdAt;
  final String? updatedAt;

  EventType(
      {required this.id,
      required this.name,
      required this.icon,
      required this.color,
      required this.createdAt,
      required this.updatedAt});

  factory EventType.fromJson(Map<String, dynamic> json) {
    return new EventType(
      id: json['id'],
      name: json['name'],
      icon: json['icon'],
      color: json['color'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }
}
