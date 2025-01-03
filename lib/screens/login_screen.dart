import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../services/auth/auth_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  LoginScreenState createState() => LoginScreenState();
}

class LoginScreenState extends State<LoginScreen>
    with SingleTickerProviderStateMixin {
  final TextEditingController _userController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _hidePassword = true;
  bool _isLoading = false;

  final FocusNode _userFocusNode = FocusNode();
  final FocusNode _passwordFocusNode = FocusNode();

  late AnimationController _animationController;
  late Animation<double> _opacityAnimation;

  // Para saber si el campo ha sido tocado
  bool _userTouched = false;
  bool _passwordTouched = false;

  // Método para guardar el token
  Future<void> saveToken(String token) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    // Guardamos el token en SharedPreferences
    await prefs.setString('auth_token', token);
  }

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    );

    _opacityAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    _animationController.forward();
  }

  @override
  void dispose() {
    _userFocusNode.dispose();
    _passwordFocusNode.dispose();
    _animationController.dispose();
    super.dispose();
  }

  void togglePasswordVisibility() {
    setState(() {
      _hidePassword = !_hidePassword;
    });
  }

  bool _isFormValid() {
    // Verifica que los campos no estén vacíos y que tengan más de 3 caracteres
    return _userController.text.isNotEmpty &&
        _userController.text.length > 3 &&
        _passwordController.text.isNotEmpty &&
        _passwordController.text.length > 3;
  }

  void submit() async {
    String user = _userController.text;
    String password = _passwordController.text;
    setState(() {
      _isLoading = true;
    });

    AuthService authService =
        AuthService(baseUrl: 'https://learn.bitfarm.mx/api');
    String? token = await authService.login(user, password);

    // Si el token es null, significa que el login falló
    if (token.isNotEmpty && token != "Error") {
      // Mostramos un mensaje de éxito y navegamos a la siguiente pantalla
      Fluttertoast.showToast(
        msg: "Inicio de sesión correcto!",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.TOP,
        timeInSecForIosWeb: 1,
        backgroundColor: Color(0xFF79a341),
        textColor: Colors.white,
        fontSize: 16.0,
      );

      setState(() {
        _isLoading = false;
      });

      if (mounted) {
        Navigator.pushNamed(context, '/home');
      }
    } else {
      // Si el login falló, mostramos un mensaje de error
      Fluttertoast.showToast(
        msg: "Credenciales incorrectas",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.TOP,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0,
      );

      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 140),
            Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  margin: const EdgeInsets.only(bottom: 31),
                  child: Image.asset(
                    'assets/images/logoAnimacion.png',
                    width: 250,
                  ),
                ),
                AnimatedBuilder(
                  animation: _animationController,
                  builder: (context, child) {
                    return FadeTransition(
                      opacity: _opacityAnimation,
                      child: child,
                    );
                  },
                  child: Image.asset(
                    'assets/images/logo-1.png',
                    width: 250,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 80),
            Align(
              alignment: Alignment.centerLeft,
              child: const Text(
                'Bienvenido a Bitlearn',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 30),
            Form(
              child: Column(
                children: [
                  TextFormField(
                    controller: _userController,
                    focusNode: _userFocusNode,
                    onChanged: (_) => setState(() {
                      _userTouched = true;
                    }),
                    decoration: InputDecoration(
                      labelStyle: TextStyle(color: Colors.black),
                      labelText: 'Usuario',
                      border: OutlineInputBorder(),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Color(0xFF79a341),
                          width: 2.0,
                        ),
                      ),
                      errorText: _userTouched &&
                              (_userController.text.isEmpty ||
                                  _userController.text.length <= 3)
                          ? 'Debe tener más de 3 caracteres'
                          : null,
                    ),
                    style: TextStyle(color: Colors.black),
                    cursorColor: Color(0xFF79a341),
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: _passwordController,
                    obscureText: _hidePassword,
                    focusNode: _passwordFocusNode,
                    onChanged: (_) => setState(() {
                      _passwordTouched = true;
                    }),
                    decoration: InputDecoration(
                      labelStyle: TextStyle(color: Colors.black),
                      labelText: 'Contraseña',
                      border: const OutlineInputBorder(),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Color(0xFF79a341),
                          width: 2.0,
                        ),
                      ),
                      errorText: _passwordTouched &&
                              (_passwordController.text.isEmpty ||
                                  _passwordController.text.length <= 3)
                          ? 'Debe tener más de 3 caracteres'
                          : null,
                      suffixIcon: IconButton(
                        icon: Icon(
                          _hidePassword
                              ? Icons.visibility_off
                              : Icons.visibility,
                        ),
                        onPressed: togglePasswordVisibility,
                      ),
                    ),
                    style: TextStyle(color: Colors.black),
                    cursorColor: Color(0xFF79a341),
                  ),
                  const SizedBox(height: 10),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Olvidaste la contraseña?",
                      textAlign: TextAlign.left,
                      style: const TextStyle(
                        color: Color(0xFF79a341),
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  const SizedBox(height: 60),
                  _isLoading
                      ? CircularProgressIndicator(
                          color: Color(0xFF79a341),
                        )
                      : ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: _isFormValid()
                                ? Color(0xFF79a341)
                                : Colors.grey,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.zero,
                            ),
                          ),
                          onPressed: _isFormValid() ? submit : null,
                          child: const Text('Iniciar sesión'),
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
