import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class SidebarMenu extends StatelessWidget {
  final Function(int) onItemSelected; // Callback para manejar la selección

  const SidebarMenu({super.key, required this.onItemSelected});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        width: MediaQuery.of(context).size.width / 3,
        color: Colors.white12,
        child: Column(
          children: [
            const SizedBox(height: 40),
            Container(
              alignment: const Alignment(-0.5, 0.5),
              child: Image.asset(
                'assets/images/logo-1.png',
                width: 200,
              ),
            ),
            const SizedBox(height: 20),
            Container(
              margin: const EdgeInsets.only(left: 20.0),
              child: Column(
                children: [
                  const ListTile(
                    title: Text(
                      'Home',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ),
                  ListTile(
                    leading: const Icon(Icons.home),
                    title: const Text('Dashboard'),
                    onTap: () => onItemSelected(0), // Cambia al índice 0
                  ),
                  ListTile(
                    leading:
                        const Icon(FontAwesomeIcons.graduationCap, size: 18),
                    title: const Text('Mis cursos'),
                    onTap: () => onItemSelected(2), // Cambia al índice 2
                  ),
                  ListTile(
                    leading: const Icon(FontAwesomeIcons.bookOpen, size: 18),
                    title: const Text('Todos los cursos'),
                    onTap: () => onItemSelected(1), // Cambia al índice 1
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
