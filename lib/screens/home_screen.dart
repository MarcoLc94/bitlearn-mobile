import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Dashboard de estudiante')),
      body: const Center(
        child: Text('Bienvenido a la pantalla de inicio'),
      ),
    );
  }
}
