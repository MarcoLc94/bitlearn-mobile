import 'package:bitlearn_mobile/screens/courses_screen.dart';
import 'package:bitlearn_mobile/screens/layout_screen.dart';
import 'package:bitlearn_mobile/screens/my_courses_screen.dart';
import 'package:flutter/material.dart';
import 'screens/login_screen.dart';
import 'screens/splash_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme(
          brightness: Brightness.light, // o Brightness.dark para modo oscuro
          primary: Color(0xFF79a341), // Color principal (verde)
          onPrimary: Colors
              .white, // Color para el texto o íconos sobre el color principal
          secondary: Color(
              0xFF79a341), // Color secundario (puedes elegir otro verde o algo complementario)
          onSecondary: Colors
              .white, // Color para texto o íconos sobre el color secundario
          error: Colors.red, // Color de error
          onError: Colors.white, // Color para texto o íconos sobre el error
          surface: Colors
              .white, // Color de las superficies, por ejemplo, fondos de cartas
          onSurface:
              Colors.black, // Color para texto o íconos sobre las superficies
        ),
        useMaterial3: true,
        primarySwatch: Colors.green,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      initialRoute: '/splash',
      routes: {
        '/splash': (context) => const SplashScreen(),
        '/': (context) => LoginScreen(), // Ruta de la pantalla de Login
        '/home': (context) => Layout(), // Ruta de la pantalla de inicio
        '/courses': (context) => CoursesScreen(), //Te lleva a coursitos C:
        '/my-courses': (context) =>
            MyCoursesScreen(), //Te lleva a tus cursillos
      },
    );
  }
}
