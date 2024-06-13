// lib/models/character.dart

// Define the Character model
class Character {
  final int id;
  final String name;
  final String description;
  final String image;
  final int universeId;

  Character({
    required this.id,
    required this.name,
    required this.description,
    required this.image,
    required this.universeId,
  });

  factory Character.fromJson(Map<String, dynamic> json) {
    return Character(
      id: int.parse(json['id'].toString()),
      name: json['name'],
      description: json['description'] ?? '',
      image: json['image'] ?? '',
      universeId: json['universe_id'],
    );
  }
}