import 'package:bitlearn_mobile/screens/course_screen.dart';
import 'package:bitlearn_mobile/screens/courses_screen.dart';
import 'package:bitlearn_mobile/screens/home_screen.dart';
import 'package:bitlearn_mobile/screens/my_courses_screen.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart'; // Importar FlutterToast
import '../widgets/navbar.dart';
import '../widgets/sidebar.dart';
import 'dart:async';

class Layout extends StatefulWidget {
  const Layout({super.key});

  @override
  State<Layout> createState() => LayoutState();
}

class LayoutState extends State<Layout> {
  int selectedPageIndex = 0;

  // Mapa de índices a widgets
  final List<Widget> _pages = const [
    HomeScreen(),
    CoursesScreen(),
    MyCoursesScreen(),
  ];

  // Cambiar de página
  void _selectPage(int index) {
    setState(() {
      selectedPageIndex = index;
    });
  }

  // Suscripción para escuchar los cambios en la conectividad
  late StreamSubscription<List<ConnectivityResult>> _connectivitySubscription;

  @override
  void initState() {
    super.initState();

    // Suscribirse al flujo de cambios en la conectividad
    _connectivitySubscription = Connectivity()
        .onConnectivityChanged
        .listen((List<ConnectivityResult> result) {
      // Si no hay conexión, mostrar un Toast
      if (result.contains(ConnectivityResult.none)) {
        Fluttertoast.showToast(
          msg: "No hay conexión a Internet",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.TOP,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0,
        );
      }
    });
  }

  @override
  void dispose() {
    // Cancelar la suscripción cuando el widget sea destruido
    _connectivitySubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Navbar(),
      drawer: SidebarMenu(
        onItemSelected: (index) {
          Navigator.pop(context); // Cierra el Drawer
          _selectPage(index); // Cambia de página
        },
      ),
      body: Navigator(
        onGenerateRoute: (settings) {
          if (settings.name == '/course') {
            final args = settings.arguments as Map<String, dynamic>;

            return MaterialPageRoute(
              builder: (context) => CourseScreen(
                courseData: args, // Pasamos el mapa completo
              ),
            );
          }

          // Si no, mostramos la página principal
          return MaterialPageRoute(
            builder: (context) => _pages[selectedPageIndex],
          );
        },
      ),
    );
  }
}
