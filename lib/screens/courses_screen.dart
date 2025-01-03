import 'package:flutter/material.dart';
import '../models/course_model.dart';
import '../services/courses/courses_service.dart';
import '../services/auth/auth_service.dart';

class CoursesScreen extends StatefulWidget {
  const CoursesScreen({super.key, authService});

  @override
  CoursesScreenState createState() => CoursesScreenState();
}

class CoursesScreenState extends State<CoursesScreen> {
  // Lista para almacenar los cursos
  List courses = [];
  bool isLoading = true;
  String errorMessage = '';

  // Crear una instancia del servicio
  final CourseService coursesService = CourseService(
      authService: AuthService(baseUrl: 'https://learn.bitfarm.mx/api'));

  // Método para obtener los cursos
  Future<void> fetchCourses() async {
    try {
      List<Course> courseList = await coursesService.fetchCourses();
      setState(() {
        courses = courseList;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
        errorMessage = 'No se pudieron cargar los cursos: $e';
      });
    }
  }

  @override
  void initState() {
    super.initState();
    fetchCourses(); // Llamamos al método para obtener los cursos
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Text(
              'Todos los cursos',
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF79a341)),
            ),
            // Campo de búsqueda
            SizedBox(height: 20),
            TextField(
              decoration: InputDecoration(
                labelText: 'Buscar',
                hintText: 'Buscar curso por nombre...',
                prefixIcon: const Icon(Icons.search),
                border: const OutlineInputBorder(),
                focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(
                    color: Color(0xFF79a341),
                    width: 2.0,
                  ),
                ),
              ),
              cursorColor: const Color(0xFF79a341),
            ),
            const SizedBox(height: 20), // Espaciado entre el input y la lista

            // Contenido principal
            Expanded(
              child: isLoading
                  ? const Center(
                      child: CircularProgressIndicator()) // Indicador de carga
                  : errorMessage.isNotEmpty
                      ? Center(
                          child: Text(
                            errorMessage,
                            style: const TextStyle(
                              color: Colors.red,
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        )
                      : courses.isEmpty
                          ? const Center(
                              child: Text(
                                'No hay cursos disponibles.',
                                style: TextStyle(fontSize: 16),
                              ),
                            )
                          : ListView.builder(
                              itemCount: courses.length,
                              itemBuilder: (context, index) {
                                final course = courses[index];
                                return Card(
                                  margin: const EdgeInsets.symmetric(
                                    vertical: 10.0,
                                  ),
                                  child: ListTile(
                                    leading: course.imageUrl.isNotEmpty
                                        ? Image.network(
                                            course.imageUrl,
                                            width: 50,
                                            height: 50,
                                            fit: BoxFit.cover,
                                            errorBuilder:
                                                (context, error, stackTrace) =>
                                                    const Icon(
                                              Icons.broken_image,
                                              size: 50,
                                              color: Colors.grey,
                                            ),
                                          )
                                        : const Icon(
                                            Icons.image,
                                            size: 50,
                                            color: Colors.grey,
                                          ),
                                    title: Text(
                                      course.name,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    subtitle: Text(course.description),
                                    onTap: () {
                                      // Acción al seleccionar un curso
                                    },
                                  ),
                                );
                              },
                            ),
            ),
          ],
        ),
      ),
    );
  }
}
