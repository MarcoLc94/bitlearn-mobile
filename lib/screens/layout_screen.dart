import 'package:flutter/material.dart';
import '../widgets/navbar.dart'; // Asumimos que tienes tu Navbar como widget independiente
import 'home_screen.dart'; // Ejemplo de una pantalla dentro del Layout

class Layout extends StatelessWidget {
  const Layout({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const Navbar(), // Aquí usas tu Navbar
      body: const _BodyNavigator(),
    );
  }
}

class _BodyNavigator extends StatelessWidget {
  const _BodyNavigator();

  @override
  Widget build(BuildContext context) {
    // El body se controla por la ruta actual
    return Navigator(
      onGenerateRoute: (settings) {
        // Define las rutas y qué pantallas deben ser cargadas
        switch (settings.name) {
          case '/':
            return MaterialPageRoute(builder: (context) => const HomeScreen());
          case '/home':
            return MaterialPageRoute(builder: (context) => const HomeScreen());
          default:
            return MaterialPageRoute(builder: (context) => const HomeScreen());
        }
      },
    );
  }
}
