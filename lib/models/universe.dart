// lib/models/universe.dart

// Define the Universe model
class Universe {
  final int id;
  final String name;
  final String description;
  final String image;
  final int creatorId;

  Universe({
    required this.id,
    required this.name,
    required this.description,
    required this.image,
    required this.creatorId,
  });

  factory Universe.fromJson(Map<String, dynamic> json) {
    return Universe(
      id: int.parse(json['id'].toString()),
      name: json['name'],
      description: json['description'] ?? '',
      image: json['image'] ?? '',
      creatorId: json['creator_id'],
    );
  }
}