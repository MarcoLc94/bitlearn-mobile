import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';
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

  final CourseService coursesService = CourseService(
      authService: AuthService(baseUrl: 'https://learn.bitfarm.mx/api'));

  List data = [];
  List assigmentInfo = [];
  String idAssigment = "";
  bool isLoading = true;
  String? errorMessage;
  Map<dynamic, dynamic>? assignmentContent;
  List lessons = [];

  Future<dynamic> fetchMyAssigment() async {
    try {
      List<dynamic> assigment = await coursesService.fetchMyAssigment();
      setState(() {
        assigmentInfo = assigment;
        final idInside = widget.courseData['courseId'];
        final currentAssigment = assigmentInfo.firstWhere(
          (item) => item['course']['_id'] == idInside,
          orElse: () => null,
        );
        idAssigment = currentAssigment['_id'];
        isLoading = false;
        fetchCourseById(idAssigment);
      });
    } catch (e) {
      setState(() {
        isLoading = false;
        errorMessage = 'Error al traer el assigment';
      });
    }
  }

  Future<void> fetchCourseById(String courseId) async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      List<dynamic> dataInfo = await coursesService.fetchMyCourseById(courseId);
      if (dataInfo.isEmpty) {
        throw Exception('No se encontraron datos para el curso.');
      }

      setState(() {
        data = dataInfo;
        assignmentContent = data[0]['sections'][0];
        lessons = data[0]['sections'][0]['lessons'];
        isLoading = false;
      });

      setupVideoPlayer(); // Llama a la función de inicialización después de cargar los datos
    } catch (e) {
      setState(() {
        isLoading = false;
        errorMessage = 'Error al cargar los cursos: $e';
      });
    }
  }

  @override
  void initState() {
    super.initState();
    fetchMyAssigment();
  }

  Future<void> setupVideoPlayer() async {
    if (data.isNotEmpty) {
      try {
        List<dynamic> sections = data[0]['sections'];
        if (sections.isNotEmpty) {
          var firstSection = sections[0];
          if (firstSection['lessons'] != null &&
              firstSection['lessons'].isNotEmpty) {
            String videoUrl = firstSection['lessons'][0]['url'];

            _videoController =
                VideoPlayerController.networkUrl(Uri.parse(videoUrl))
                  ..initialize().then((_) {
                    setState(() {
                      _chewieController = ChewieController(
                        videoPlayerController: _videoController,
                        autoPlay:
                            true, // Hacer que se reproduzca automáticamente
                        looping: false,
                      );
                    });
                  });
          }
        }
      } catch (e) {
        debugPrint('Error al configurar el video: $e');
      }
    }
  }

  @override
  void dispose() {
    _videoController.dispose();
    _chewieController?.dispose();
    super.dispose();
  }

  void playVideo(String videoUrl) {
    // Verifica si ya hay un controlador de video anterior y lo libera.
    if (_videoController.value.isInitialized) {
      _videoController.pause();
      _videoController.dispose();
    }

    // Crear un nuevo VideoPlayerController y ChewieController
    _videoController = VideoPlayerController.networkUrl(Uri.parse(videoUrl))
      ..initialize().then((_) {
        setState(() {
          _chewieController = ChewieController(
            videoPlayerController: _videoController,
            autoPlay: true, // Reproduce automáticamente el video
            looping: false, // No hace bucles
          );
        });
      });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          assignmentContent != null
              ? assignmentContent!['name'] ?? 'Curso sin nombre'
              : 'Curso no disponible',
        ),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : errorMessage != null
              ? Center(
                  child:
                      Text(errorMessage!, style: TextStyle(color: Colors.red)),
                )
              : Column(
                  children: [
                    if (_chewieController != null)
                      SizedBox(
                        width: double.infinity,
                        height: 250, // Ajusta la altura según sea necesario
                        child: Chewie(
                          controller: _chewieController!,
                        ),
                      ),
                    Expanded(
                      child: ListView.builder(
                        itemCount: lessons.length,
                        itemBuilder: (context, index) {
                          var lesson = lessons[index];
                          return ListTile(
                            leading: lesson['img'] != null
                                ? Image.network(lesson['img'])
                                : Icon(Icons.video_collection),
                            title: Text(lesson['name'] ?? 'Lección sin nombre'),
                            subtitle: Text(
                                "Duración: ${lesson['duration'] ?? '0'} segundos"),
                            onTap: () {
                              String videoUrl = lesson['url'] ?? '';
                              if (videoUrl.isNotEmpty) {
                                playVideo(videoUrl);
                              }
                            },
                          );
                        },
                      ),
                    ),
                  ],
                ),
    );
  }
}
