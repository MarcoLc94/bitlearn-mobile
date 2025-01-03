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

  // El método fromJson ahora maneja los valores nulos
  factory Course.fromJson(Map<String, dynamic> json) {
    return Course(
      id: json['_id'] ?? '', // Si '_id' es nulo, usa un string vacío
      name: json['name'] ??
          'Nombre no disponible', // Si 'name' es nulo, usa un valor por defecto
      description: json['description'] ??
          'Descripción no disponible', // Lo mismo para 'description'
      img: json['img'], // No es necesario hacer nada si 'img' es nulo
    );
  }
}
