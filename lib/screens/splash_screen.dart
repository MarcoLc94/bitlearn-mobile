import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  Future<String?> getToken() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs
        .getString('auth_token'); // Cambia 'auth_token' por tu clave de token.
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String?>(
      future: getToken(),
      builder: (context, snapshot) {
        // Mientras se resuelve el Future
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        // Una vez que el Future se resuelve
        if (snapshot.hasData && snapshot.data != null) {
          // Token encontrado, redirige a la pantalla principal
          WidgetsBinding.instance.addPostFrameCallback((_) {
            Navigator.pushReplacementNamed(context, '/home');
          });
        } else {
          // No hay token, redirige a la pantalla de login
          WidgetsBinding.instance.addPostFrameCallback((_) {
            Navigator.pushReplacementNamed(context, '/');
          });
        }

        return const SizedBox.shrink(); // Pantalla vacía mientras se redirige
      },
    );
  }
}
