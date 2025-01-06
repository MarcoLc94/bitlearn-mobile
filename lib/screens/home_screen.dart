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
  int selectedIndex = 0; // Índice para gestionar las vistas del body

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
                setState(() {
                  selectedIndex = 0; // Cambiar a "Cursos Pendientes"
                });
              },
            ),
          ),
          Expanded(
            child: IconButton(
              icon: Icon(Icons.star_outline),
              onPressed: () {
                setState(() {
                  selectedIndex = 1; // Cambiar a "Insignias"
                });
              },
            ),
          ),
          Expanded(
            child: IconButton(
              icon: Icon(Icons.notifications_none),
              onPressed: () {
                setState(() {
                  selectedIndex = 2; // Cambiar a "Noticias"
                });
              },
            ),
          ),
          Expanded(
            child: IconButton(
              icon: Icon(Icons.bar_chart_outlined),
              onPressed: () {
                setState(() {
                  selectedIndex = 3; // Cambiar a "Estadísticas"
                });
              },
            ),
          ),
        ],
      ),
      body: IndexedStack(
        index: selectedIndex, // El índice determina qué vista se muestra
        children: [
          // Cursos Pendientes
          _buildCoursesView(),

          // Insignias
          _buildInsigniasView(),

          // Noticias
          _buildNoticiasView(),

          // Estadísticas
          _buildEstadisticasView(),
        ],
      ),
    );
  }

  // Vista de Cursos Pendientes
  Widget _buildCoursesView() {
    return Column(
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
                                    color: Color(0x1A000000),
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
    );
  }

  // Vista de Insignias
  Widget _buildInsigniasView() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Imagen demo de la insignia
          Image.network(
            'https://via.placeholder.com/150', // Aquí puedes poner la URL de la imagen de la insignia
            width: 100, // Ajusta el tamaño de la imagen
            height: 100, // Ajusta el tamaño de la imagen
          ),
          SizedBox(height: 20), // Espacio entre la imagen y el texto
          // Texto informativo
          Text(
            'No tienes ninguna insignia',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }

  // Vista de Noticias
  Widget _buildNoticiasView() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Título "Últimas Noticias"
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'Últimas Noticias',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          // Noticia 1
          GestureDetector(
            onTap: () {
              // Acción al hacer clic en la noticia
            },
            child: Container(
              margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
              padding: EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Colors.blue[50],
                borderRadius: BorderRadius.circular(8.0),
                boxShadow: [
                  BoxShadow(
                    color: Color(0x1A000000),
                    blurRadius: 5,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Introducción a Python: Nuevas características',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Descubre las últimas características de Python y cómo pueden mejorar tu productividad.',
                    style: TextStyle(fontSize: 14),
                  ),
                ],
              ),
            ),
          ),
          // Noticia 2
          GestureDetector(
            onTap: () {
              // Acción al hacer clic en la noticia
            },
            child: Container(
              margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
              padding: EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Colors.green[50],
                borderRadius: BorderRadius.circular(8.0),
                boxShadow: [
                  BoxShadow(
                    color: Color(0x1A000000),
                    blurRadius: 5,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'JavaScript sigue siendo esencial en el desarrollo web',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'A pesar de las novedades, JavaScript sigue siendo una de las bases del desarrollo web.',
                    style: TextStyle(fontSize: 14),
                  ),
                ],
              ),
            ),
          ),
          // Noticia 3
          GestureDetector(
            onTap: () {
              // Acción al hacer clic en la noticia
            },
            child: Container(
              margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
              padding: EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Colors.red[50],
                borderRadius: BorderRadius.circular(8.0),
                boxShadow: [
                  BoxShadow(
                    color: Color(0x1A000000),
                    blurRadius: 5,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'El futuro de Java: ¿Qué esperar?',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Explora las predicciones sobre el futuro de Java y cómo afectará a los desarrolladores.',
                    style: TextStyle(fontSize: 14),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Vista de Estadísticas
  Widget _buildEstadisticasView() {
    return Center(child: Text('Vista de Estadísticas'));
  }
}
