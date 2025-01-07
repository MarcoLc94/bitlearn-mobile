import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../models/course_model.dart';
import '../auth/auth_service.dart';

class CourseService {
  // URL de la API
  final String apiUrl = 'https://learn.bitfarm.mx/api';

  // Instancia del servicio de autenticación
  final AuthService authService;

  // Constructor que recibe una instancia de AuthService
  CourseService({required this.authService});

  // Método para obtener los cursos
  Future<List<Course>> fetchCourses() async {
    try {
      String? token = await authService.getToken(); // Obtener el token

      if (token == null) {
        throw Exception('No auth token found. Please log in.');
      }

      // Configuramos los headers, incluyendo el token
      final response = await http.get(
        Uri.parse('$apiUrl/course/search'),
        headers: {
          'Authorization': 'Bearer $token', // Enviar el token en el header
        },
      );

      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        return data.map((courseData) => Course.fromJson(courseData)).toList();
      } else {
        throw Exception('Failed to load courses: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching courses: $e');
    }
  }

  // Método para obtener los cursos
  Future<List<Course>> fetchMyCourses() async {
    try {
      String? token = await authService.getToken(); // Obtener el token
      if (token == null) {
        throw Exception('No auth token found. Please log in.');
      }

      // Configuramos los headers, incluyendo el token
      final response = await http.get(
        Uri.parse('$apiUrl/myAssignments'),
        headers: {
          'Authorization': 'Bearer $token', // Enviar el token en el header
        },
      );
      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        return data.map((courseData) => Course.fromJson(courseData)).toList();
      } else {
        throw Exception('Failed to load courses: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching courses: $e');
    }
  }

  //Metodo para obtener todo el assigment
  Future<List<dynamic>> fetchMyAssigment() async {
    try {
      String? token = await authService.getToken(); // Obtener el token
      if (token == null) {
        throw Exception('No auth token found. Please log in.');
      }

      // Configuramos los headers, incluyendo el token
      final response = await http.get(
        Uri.parse('$apiUrl/myAssignments'),
        headers: {
          'Authorization': 'Bearer $token', // Enviar el token en el header
        },
      );
      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        return data;
      } else {
        throw Exception('Failed to load courses: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching courses: $e');
    }
  }

  // Método para obtener 1 solo curso por id
  Future<List<dynamic>> fetchMyCourseById(id) async {
    try {
      print(id);
      String? token = await authService.getToken(); // Obtener el token
      if (token == null) {
        throw Exception('No auth token found. Please log in.');
      }

      // Configuramos los headers, incluyendo el token
      final response = await http.get(
        Uri.parse('$apiUrl/myAssignment/$id'),
        headers: {
          'Authorization': 'Bearer $token', // Enviar el token en el header
        },
      );
      print(response.statusCode);
      if (response.statusCode == 200) {
        Map<String, dynamic> data = json.decode(response.body);
        List<dynamic> list = [
          data
        ]; // Convertir el Map en una lista con un solo elemento
        print("La info como lista es $list");
        return list;
      } else {
        print("bug 1");
        throw Exception('Failed to load courses: ${response.statusCode}');
      }
    } catch (e) {
      print("$e");
      throw Exception('Error fetching courses: $e');
    }
  }
}
