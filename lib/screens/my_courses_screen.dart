import 'package:flutter/material.dart';
import '../models/course_model.dart';
import '../services/courses/courses_service.dart';
import '../services/auth/auth_service.dart';

class MyCoursesScreen extends StatefulWidget {
  const MyCoursesScreen({super.key, authService});

  @override
  MyCoursesScreenState createState() => MyCoursesScreenState();
}

class MyCoursesScreenState extends State<MyCoursesScreen> {
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
              'Mis cursos',
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
                        child:
                            CircularProgressIndicator()) // Indicador de carga
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
                                  double progress =
                                      0.0; // Puedes actualizar este valor según el progreso real del curso.

                                  return MouseRegion(
                                    onEnter: (_) {
                                      setState(() {
                                        // Muestra el botón "Suscribirse" al hacer hover
                                      });
                                    },
                                    onExit: (_) {
                                      setState(() {
                                        // Esconde el botón "Suscribirse" cuando el mouse sale
                                      });
                                    },
                                    child: GestureDetector(
                                      onTap: () {
                                        // Acción al hacer clic (por ejemplo, navegar al detalle del curso)
                                      },
                                      child: Card(
                                        margin: const EdgeInsets.symmetric(
                                            vertical: 10.0),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment
                                              .stretch, // Esto asegura que el contenido ocupe todo el ancho del Card
                                          children: [
                                            ListTile(
                                              leading: course.img != null &&
                                                      course.img!.isNotEmpty
                                                  ? Image.network(
                                                      course.img!,
                                                      width: 50,
                                                      height: 50,
                                                      fit: BoxFit.cover,
                                                      errorBuilder: (context,
                                                              error,
                                                              stackTrace) =>
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
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              subtitle: Text(
                                                course.description.length > 50
                                                    ? course.description
                                                            .substring(0, 50) +
                                                        '...' // Mostrar las primeras 50 letras
                                                    : course
                                                        .description, // Si la descripción tiene menos de 50 caracteres, mostrarla completa
                                              ),
                                            ),
                                            const SizedBox(
                                                height:
                                                    10), // Espaciado entre la lista y los elementos de progreso
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment
                                                    .spaceBetween, // Justifica con espacio entre ellos
                                                children: [
                                                  // Borde circular con el porcentaje de progreso
                                                  Container(
                                                    width: 50,
                                                    height: 50,
                                                    decoration: BoxDecoration(
                                                      shape: BoxShape.circle,
                                                      border: Border.all(
                                                        color: Colors
                                                            .green, // Color del borde
                                                        width: 2,
                                                      ),
                                                    ),
                                                    child: Center(
                                                      child: Text(
                                                        '${(progress * 100).toStringAsFixed(1)}%', // Muestra el porcentaje de progreso
                                                        style: const TextStyle(
                                                          color: Colors.green,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  // Botón de Play a la derecha
                                                  ElevatedButton(
                                                    onPressed: () {
                                                      // Acción cuando el botón "Play" es presionado
                                                      // Aquí puedes manejar la acción de reproducir el curso
                                                    },
                                                    style: ElevatedButton
                                                        .styleFrom(
                                                      shape: CircleBorder(),
                                                      padding:
                                                          EdgeInsets.all(15),
                                                      backgroundColor: const Color(
                                                          0xFF79a341), // Color del botón
                                                    ),
                                                    child: const Icon(
                                                      Icons.play_arrow,
                                                      color: Colors.white,
                                                      size: 30,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            const SizedBox(height: 30),
                                          ],
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              )),
          ],
        ),
      ),
    );
  }
}
