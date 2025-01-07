import 'package:flutter/material.dart';
import '../services/auth/auth_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class Navbar extends StatelessWidget implements PreferredSizeWidget {
  Navbar({super.key});

  final AuthService authService =
      AuthService(baseUrl: 'https://learn.bitfarm.mx/api');

  Future<Map<String, dynamic>?> getUserInfo() async {
    SharedPreferences userData = await SharedPreferences.getInstance();
    String? jsonString = userData.getString('userInfo');
    if (jsonString != null) {
      // Convertir el String de vuelta a un Map
      Map<String, dynamic> userInfo = json.decode(jsonString);
      return userInfo;
    }
    return null; // Si no se encuentra el userInfo
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: IconButton(
        icon: Icon(
          Icons.menu,
          size: 40,
        ),
        onPressed: () => (Scaffold.of(context).openDrawer()),
      ),
      actions: [
        Padding(
          padding: EdgeInsets.only(right: 10.0),
          child: InkWell(
            onTap: () => _showUserInfoModal(context),
            child: ClipOval(
              child: Image.asset(
                'assets/images/user-1.jpg',
                width: 40, // Ajusta el tamaño al deseado
                height: 40,
                fit: BoxFit.cover, // Asegura que la imagen se ajuste al círculo
              ),
            ),
          ),
        ),
      ],
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(20.0)),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(56.0);

  // Modal con la información del usuario y botón de logout
  void _showUserInfoModal(BuildContext context) {
    Future<void> removeToken() async {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.remove('auth_token');
    }

    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return FutureBuilder<Map<String, dynamic>?>(
          future: getUserInfo(), // Asíncrono
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            }
            if (!snapshot.hasData) {
              return Center(child: Text('No user data found'));
            }
            Map<String, dynamic> userInfo = snapshot.data!;
            return Stack(
              children: [
                Positioned(
                  top: 20,
                  left: 1,
                  child: Material(
                    color: Colors.transparent,
                    child: Dialog(
                      child: Container(
                        height: 250,
                        width: 350,
                        padding: EdgeInsets.all(16.0),
                        child: Column(children: [
                          SizedBox(height: 20),
                          Title(
                            color: Colors.black,
                            child: Text("Perfil de estudiante",
                                style: TextStyle(fontWeight: FontWeight.w700)),
                          ),
                          SizedBox(height: 20),
                          Row(mainAxisSize: MainAxisSize.min, children: [
                            Image.asset(
                              "assets/images/user-1.jpg",
                              width: 80,
                            ),
                            SizedBox(width: 20),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                Row(children: [
                                  Icon(Icons.person),
                                  SizedBox(width: 10),
                                  Text('${userInfo['name']}')
                                ]),
                                Row(children: [
                                  Icon(Icons.email),
                                  SizedBox(width: 10),
                                  Text('${userInfo['email']}'),
                                ]),
                              ],
                            ),
                          ]),
                          SizedBox(height: 20),
                          ElevatedButton(
                            style: ButtonStyle(
                              side: WidgetStatePropertyAll(BorderSide(
                                  color: Color(0xFF79a341), width: 2.0)),
                              shape: WidgetStatePropertyAll(
                                  RoundedRectangleBorder(
                                      borderRadius: BorderRadius.zero)),
                            ),
                            onPressed: () {
                              // Acción de logout
                              removeToken();
                              Navigator.pop(context); // Cerrar el modal
                              Navigator.pushReplacementNamed(context,
                                  '/'); // Reemplazar la pantalla actual con la de login
                            },
                            child: Text(
                              'Cerrar sesión',
                              style: TextStyle(color: Color(0xFF79a341)),
                            ),
                          ),
                        ]),
                      ),
                    ),
                  ),
                )
              ],
            );
          },
        );
      },
    );
  }
}
