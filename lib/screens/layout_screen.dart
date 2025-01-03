import 'package:bitlearn_mobile/screens/courses_screen.dart';
import 'package:bitlearn_mobile/screens/home_screen.dart';
import 'package:bitlearn_mobile/screens/my_courses_screen.dart';
import 'package:flutter/material.dart';
import '../widgets/navbar.dart';
import '../widgets/sidebar.dart';

class Layout extends StatefulWidget {
  const Layout({super.key});

  @override
  State<Layout> createState() => _LayoutState();
}

class _LayoutState extends State<Layout> {
  int _selectedPageIndex = 0;

  // Mapa de índices a widgets
  final List<Widget> _pages = const [
    HomeScreen(),
    CoursesScreen(),
    MyCoursesScreen(),
  ];

  // Cambiar de página
  void _selectPage(int index) {
    setState(() {
      _selectedPageIndex = index;
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
      body: IndexedStack(
        index: _selectedPageIndex,
        children: _pages,
      ),
    );
  }
}
