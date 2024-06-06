// lib/models/universe.dart

class Universe {
  final int id;
  final String name;

  Universe({
    required this.id,
    required this.name,
  });

  factory Universe.fromJson(Map<String, dynamic> json) {
    return Universe(
      id: int.parse(json['id'].toString()),
      name: json['name'],
    );
  }
}