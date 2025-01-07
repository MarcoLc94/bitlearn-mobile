import 'package:flutter/material.dart';
import '../services/auth/auth_service.dart';
import '../services/courses/courses_service.dart'; // Asegúrate de importar el servicio de asignaciones
import '../models/course_model.dart';
import 'course_screen.dart'; // Asegúrate de importar la pantalla del curso

class CoursesScreen extends StatefulWidget {
  const CoursesScreen({super.key, authService});

  @override
  CoursesScreenState createState() => CoursesScreenState();
}

class CoursesScreenState extends State<CoursesScreen> {
  List<Course> courses = [];
  List<dynamic> assignments = [];
  bool isLoading = true;
  String errorMessage = '';
  Map<int, bool> isCourseLoading = {};
  Map<int, bool> isSubscribed = {};

  final CourseService coursesService = CourseService(
    authService: AuthService(baseUrl: 'https://learn.bitfarm.mx/api'),
  );

  final CourseService assignmentService = CourseService(
    authService: AuthService(baseUrl: 'https://learn.bitfarm.mx/api'),
  );

  // Fetch courses
  Future<void> fetchCourses() async {
    try {
      List<Course> courseList = await coursesService.fetchCourses();
      setState(() {
        courses = courseList;
        isLoading = false;
        isCourseLoading = {for (var i = 0; i < courses.length; i++) i: false};
        isSubscribed = {for (var i = 0; i < courses.length; i++) i: false};
      });
    } catch (e) {
      setState(() {
        isLoading = false;
        errorMessage = 'No se pudieron cargar los cursos: $e';
      });
    }
  }

  // Fetch assignments
  Future<void> fetchAssignments() async {
    try {
      List<dynamic> assignmentsData = await coursesService.fetchMyAssigment();
      setState(() {
        assignments = assignmentsData;
      });
    } catch (e) {
      setState(() {
        errorMessage = 'No se pudieron cargar los assignments: $e';
      });
    }
  }

  @override
  void initState() {
    super.initState();
    fetchCourses();
    fetchAssignments();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            // Titulo y otros widgets
            Expanded(
              child: isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : errorMessage.isNotEmpty
                      ? Center(child: Text(errorMessage))
                      : courses.isEmpty
                          ? const Center(
                              child: Text('No hay cursos disponibles'))
                          : ListView.builder(
                              itemCount: courses.length,
                              itemBuilder: (context, index) {
                                final course = courses[index];
                                bool isAssigned = false;

                                // Verifica si el curso ya está en los assignments
                                for (var assignment in assignments) {
                                  if (assignment['course'] != null &&
                                      assignment['course']['_id'] ==
                                          course.id) {
                                    isAssigned = true;
                                    break;
                                  }
                                }

                                return Card(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.stretch,
                                    children: [
                                      SizedBox(height: 20),
                                      ListTile(
                                        leading: course.img != null &&
                                                course.img!.isNotEmpty
                                            ? Image.network(course.img!)
                                            : const Icon(Icons.image),
                                        title: Text(course.name),
                                        subtitle: Text(course.description),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Align(
                                          alignment: Alignment
                                              .center, // Centra el botón
                                          child: SizedBox(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.7, // 70% del ancho de la pantalla
                                            child: ElevatedButton(
                                              onPressed: () async {
                                                if (isAssigned) {
                                                  // Redirige al curso si ya está asignado
                                                  Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                      builder: (context) =>
                                                          CourseScreen(
                                                        courseData: {
                                                          'courseId': course.id,
                                                          'name': course.name,
                                                          'description': course
                                                              .description,
                                                          'img': course.img,
                                                        },
                                                      ),
                                                    ),
                                                  );
                                                } else {
                                                  // Realiza la suscripción si no está asignado
                                                  setState(() {
                                                    isCourseLoading[index] =
                                                        true;
                                                  });

                                                  await Future.delayed(
                                                      Duration(seconds: 2));

                                                  if (mounted) {
                                                    // Solo mostrar el SnackBar si el widget sigue montado
                                                    ScaffoldMessenger.of(
                                                            context)
                                                        .showSnackBar(
                                                      SnackBar(
                                                        content: Text(
                                                            '¡Te has suscrito al curso!'),
                                                      ),
                                                    );

                                                    setState(() {
                                                      // Actualiza el estado aquí si es necesario
                                                    });
                                                  }

                                                  setState(() {
                                                    isCourseLoading[index] =
                                                        false;
                                                    isSubscribed[index] = true;
                                                  });
                                                }
                                              },
                                              style: ElevatedButton.styleFrom(
                                                padding: EdgeInsets
                                                    .zero, // Elimina el padding alrededor del contenido
                                                backgroundColor: const Color(
                                                    0xFF79a341), // Color de fondo
                                                shape: RoundedRectangleBorder(
                                                  borderRadius: BorderRadius
                                                      .zero, // Bordes sin redondeo
                                                ),
                                              ),
                                              child: Center(
                                                child: (isCourseLoading[
                                                            index] ??
                                                        false)
                                                    ? CircularProgressIndicator(
                                                        color: Colors
                                                            .white, // Cambiar color del spinner
                                                      )
                                                    : Text(
                                                        isAssigned
                                                            ? 'Ir al curso'
                                                            : 'Suscribirse',
                                                        style: TextStyle(
                                                          color: Colors
                                                              .white, // Color del texto
                                                          fontSize:
                                                              16, // Tamaño de fuente
                                                        ),
                                                      ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      SizedBox(height: 10)
                                    ],
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
