import 'package:flutter/material.dart';
import '../models/course_model.dart';
import '../services/courses/courses_service.dart';
import '../services/auth/auth_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  List<Course> courses = [];
  bool isLoading = true;
  String errorMessage = '';

  // Crear una instancia del servicio
  final CourseService coursesService = CourseService(
    authService: AuthService(baseUrl: 'https://learn.bitfarm.mx/api'),
  );

  // Método para obtener los cursos
  Future<void> fetchCourses() async {
    try {
      List<Course> courseList = await coursesService.fetchMyCourses();
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
    fetchCourses();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        actions: [
          Expanded(
            child: IconButton(
              icon: Icon(Icons.book_outlined),
              onPressed: () {
                // Acción al hacer clic en Cursos Pendientes
              },
            ),
          ),
          Expanded(
            child: IconButton(
              icon: Icon(Icons.star_outline),
              onPressed: () {
                // Acción al hacer clic en Insignias
              },
            ),
          ),
          Expanded(
            child: IconButton(
              icon: Icon(Icons.notifications_none),
              onPressed: () {
                // Acción al hacer clic en Noticias
              },
            ),
          ),
          Expanded(
            child: IconButton(
              icon: Icon(Icons.bar_chart_outlined),
              onPressed: () {
                // Acción al hacer clic en Estadísticas
              },
            ),
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Título debajo del AppBar
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'Tus cursos pendientes',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          // Contenedor para el carrusel
          Container(
            padding: const EdgeInsets.symmetric(vertical: 20.0),
            height: 250, // Ajusta la altura del carrusel según tus necesidades
            child: isLoading
                ? Center(child: CircularProgressIndicator())
                : errorMessage.isNotEmpty
                    ? Center(child: Text(errorMessage))
                    : ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: courses.length,
                        itemBuilder: (context, index) {
                          final course = courses[index];
                          return Card(
                            margin: EdgeInsets.symmetric(horizontal: 10),
                            child: Container(
                              width:
                                  150, // Ajusta el ancho de los elementos del carrusel
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Stack(
                                fit: StackFit.expand,
                                children: [
                                  // Imagen de fondo
                                  Container(
                                    decoration: BoxDecoration(
                                      image: DecorationImage(
                                        image: NetworkImage(course.img ??
                                            'https://via.placeholder.com/150'), // Asegúrate de usar la URL correcta
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                  // Fondo con opacidad para mejorar la legibilidad
                                  Container(
                                    decoration: BoxDecoration(
                                      color: Colors.black.withValues(
                                          alpha: 0.4), // Usando withValues
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                  // Texto sobre la imagen
                                  Positioned(
                                    bottom: 10,
                                    left: 10,
                                    right: 10,
                                    child: Text(
                                      course
                                          .name, // Cambia esto por el nombre del curso
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
          ),
        ],
      ),
    );
  }
}
