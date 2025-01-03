class Course {
  final String id;
  final String name;
  final String description;
  final String imageUrl;

  Course({
    required this.id,
    required this.name,
    required this.description,
    required this.imageUrl,
  });

  // Método para convertir el JSON en un objeto Course
  factory Course.fromJson(Map<String, dynamic> json) {
    return Course(
      id: json['_id'],
      name: json['name'],
      description: json['description'],
      imageUrl: json['img'],
    );
  }
}
