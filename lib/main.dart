import 'package:bitlearn_mobile/screens/courses_screen.dart';
import 'package:bitlearn_mobile/screens/layout_screen.dart';
import 'package:bitlearn_mobile/screens/my_courses_screen.dart';
import 'package:flutter/material.dart';
import 'screens/login_screen.dart';

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
        useMaterial3: true,
        primarySwatch: Colors.green,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => LoginScreen(), // Ruta de la pantalla de Login
        '/home': (context) => Layout(), // Ruta de la pantalla de inicio
        '/courses': (context) => CoursesScreen(), //Te lleva a coursitos C:
        '/my-courses': (context) =>
            MyCoursesScreen(), //Te lleva a tus cursillos
      },
    );
  }
}
