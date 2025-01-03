import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  final String baseUrl;

  // Constructor que recibe la baseUrl
  AuthService({required this.baseUrl});

  // Método para hacer login
  Future<String> login(String user, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'user': user, 'password': password}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        String token = data['token'];
        saveUser(data['user']);
        saveToken(token);

        return token; // Login exitoso
      } else {
        // Error en la solicitud
        return "Error"; // Login fallido
      }
    } catch (e) {
      return "Error";
    }
  }

  // Método para obtener el token desde SharedPreferences
  Future<String?> getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('auth_token');
  }

  // Método para cerrar sesión y eliminar el token
  Future<void> logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('auth_token');
  }

  Future<void> saveToken(String token) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    // Guardamos el token en SharedPreferences
    await prefs.setString('auth_token', token);
  }

  Future<void> saveUser(Map<String, dynamic> userInfo) async {
    SharedPreferences userData = await SharedPreferences.getInstance();
    // Convertir el userInfo a un String (JSON)
    String jsonString = json.encode(userInfo);
    // Guardarlo en SharedPreferences
    await userData.setString('userInfo', jsonString);
  }
}
