import 'package:bitlearn_mobile/screens/course_screen.dart';
import 'package:bitlearn_mobile/screens/courses_screen.dart';
import 'package:bitlearn_mobile/screens/home_screen.dart';
import 'package:bitlearn_mobile/screens/my_courses_screen.dart';
import 'package:flutter/material.dart';
import '../widgets/navbar.dart';
import '../widgets/sidebar.dart';

class Layout extends StatefulWidget {
  const Layout({super.key});

  @override
  State<Layout> createState() => LayoutState();
}

class LayoutState extends State<Layout> {
  int selectedPageIndex = 0;

  // Mapa de índices a widgets
  final List<Widget> _pages = const [
    // Asegúrate de que estas páginas existan correctamente
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
            final args = settings.arguments
                as Map<String, dynamic>; // Ahora esperamos un Map

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
