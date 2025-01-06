class Course {
  final String id;
  final String name;
  final String description;
  final String?
      img; // Lo marcamos como nullable para que no haya problemas con valores nulos.

  Course({
    required this.id,
    required this.name,
    required this.description,
    this.img, // Si img es nulo, no causará problemas.
  });

  @override
  String toString() {
    return 'Curso: $name, Descripción: $description';
  }

  factory Course.fromJson(Map<String, dynamic> json) {
    // Verificamos si el JSON tiene el campo 'course' (caso anidado)
    if (json.containsKey('course')) {
      final courseData = json['course']; // Accede al objeto 'course' si existe
      return Course(
        id: courseData['_id'] ?? '',
        name: courseData['name'] ?? 'Nombre no disponible',
        description: courseData['description'] ?? 'Descripción no disponible',
        img: courseData['img'], // img puede ser nulo
      );
    } else {
      // Si no contiene 'course', tomamos los datos directamente del objeto principal
      return Course(
        id: json['_id'] ?? '',
        name: json['name'] ?? 'Nombre no disponible',
        description: json['description'] ?? 'Descripción no disponible',
        img: json['img'], // img puede ser nulo
      );
    }
  }
}
