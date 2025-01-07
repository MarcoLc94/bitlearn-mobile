import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';
import '../models/course_model.dart';
import '../services/courses/courses_service.dart';
import '../services/auth/auth_service.dart';

class CourseScreen extends StatefulWidget {
  final Map<String, dynamic> courseData;

  const CourseScreen({super.key, required this.courseData});

  @override
  State<CourseScreen> createState() => _CourseScreenState();
}

class _CourseScreenState extends State<CourseScreen> {
  late VideoPlayerController _videoController;
  ChewieController? _chewieController;

  // Crear una instancia del servicio
  final CourseService coursesService = CourseService(
      authService: AuthService(baseUrl: 'https://learn.bitfarm.mx/api'));

  // Variable para almacenar los cursos
  List data = [];
  bool isLoading = true;
  String? errorMessage;

  // Método para obtener los cursos
  Future<void> fetchCourseById(String courseId) async {
    try {
      List<dynamic> dataInfo = await coursesService.fetchMyCourseById(courseId);
      setState(() {
        data = dataInfo;
        print(data);
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
    fetchCourseById(widget.courseData['courseId']);
    print("Variable es: ${widget.courseData['course']}");

    print(data);

    // String? videoUrl;

    //   // Verificar si existe la estructura de datos esperada
    //   if (data[0] is List &&
    //       data[0]!.isNotEmpty &&
    //       data[0] is List &&
    //       data[0]!.isNotEmpty) {
    //     // Extraer URL del video
    //     videoUrl = widget.courseData['sections'][0]['lessons'][0]['url'];
    //     print("video url es igual a: $videoUrl");
    //   } else {
    //     debugPrint('Estructura de datos no válida o URL de video no encontrada.');
    //   }

    //   if (videoUrl != null && videoUrl.isNotEmpty) {
    //     // Inicializar el controlador de video
    //     _videoController = VideoPlayerController.networkUrl(Uri.parse(videoUrl))
    //       ..initialize().then((_) {
    //         setState(() {}); // Actualizar el estado cuando el video esté listo
    //       });

    //     // Configurar el controlador de Chewie
    //     _chewieController = ChewieController(
    //       videoPlayerController: _videoController,
    //       autoPlay: false,
    //       looping: false,
    //       materialProgressColors: ChewieProgressColors(
    //         playedColor: Colors.blue,
    //         handleColor: Colors.blueAccent,
    //         backgroundColor: Colors.grey,
    //         bufferedColor: Colors.lightBlue,
    //       ),
    //       errorBuilder: (context, errorMessage) {
    //         return Center(
    //           child: Text(
    //             errorMessage,
    //             style: const TextStyle(color: Colors.red),
    //           ),
    //         );
    //       },
    //     );
    //   } else {
    //     debugPrint('URL del video no encontrada.');
    //   }
  }

  @override
  void dispose() {
    _videoController.dispose();
    _chewieController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.courseData['course'] is Map<String, dynamic>
              ? (widget.courseData['course']['name'] ?? 'Sin nombre')
              : ((widget.courseData['course'])?.name ?? 'Sin nombre'),
        ),
      ),
      body: _chewieController != null
          ? Column(
              children: [
                AspectRatio(
                  aspectRatio: _videoController.value.isInitialized
                      ? _videoController.value.aspectRatio
                      : 16 / 9,
                  child: Chewie(controller: _chewieController!),
                ),
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'Data del curso: ${widget.courseData['course'] is Map<String, dynamic> ? widget.courseData['course']['name'] : (widget.courseData['course'] as Course?)?.name ?? 'Sin datos'}',
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            )
          : const Center(
              child: CircularProgressIndicator(),
            ),
    );
  }
}
