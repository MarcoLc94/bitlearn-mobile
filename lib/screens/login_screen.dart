import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:local_auth/local_auth.dart'; // Importa local_auth
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
  bool _useBiometrics = false; // Variable para controlar si usar biometría

  final FocusNode _userFocusNode = FocusNode();
  final FocusNode _passwordFocusNode = FocusNode();

  late AnimationController _animationController;
  late Animation<double> _opacityAnimation;

  // Para saber si el campo ha sido tocado
  bool _userTouched = false;
  bool _passwordTouched = false;

  final LocalAuthentication _auth =
      LocalAuthentication(); // Instancia de LocalAuthentication

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

    _checkBiometricAvailability(); // Verifica si biometría está disponible
  }

  // Verifica si la biometría está disponible en el dispositivo
  Future<void> _checkBiometricAvailability() async {
    bool canAuthenticateWithBiometrics = await _auth.canCheckBiometrics;
    if (canAuthenticateWithBiometrics) {
      // Verifica si tiene biometría configurada
      List<BiometricType> availableBiometrics =
          await _auth.getAvailableBiometrics();
      if (availableBiometrics.isNotEmpty) {
        setState(() {
          _useBiometrics = true; // Habilita la opción de usar biometría
        });
      }
    }
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

  Future<bool> _checkConnectivity() async {
    var connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult[0] == ConnectivityResult.none) {
      Fluttertoast.showToast(
        msg: "No hay conexión a Internet",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.TOP,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0,
      );
      return false;
    }
    return true;
  }

  // Método para iniciar sesión con biometría
  Future<void> _authenticateWithBiometrics() async {
    try {
      bool didAuthenticate = await _auth.authenticate(
        localizedReason: 'Por favor autentíquese para continuar',
        options: const AuthenticationOptions(biometricOnly: true),
      );
      if (didAuthenticate) {
        // Si la autenticación fue exitosa
        Fluttertoast.showToast(
          msg: "Autenticación exitosa",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.TOP,
          timeInSecForIosWeb: 1,
          backgroundColor: Color(0xFF79a341),
          textColor: Colors.white,
          fontSize: 16.0,
        );
        // Aquí iría tu lógica de inicio de sesión
        if (mounted) {
          Navigator.pushNamed(context, '/home');
        }
      }
    } catch (e) {
      Fluttertoast.showToast(
        msg: "Error de autenticación biométrica",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.TOP,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    }
  }

  void submit() async {
    // Verifica la conectividad antes de proceder
    bool isConnected = await _checkConnectivity();
    if (!isConnected) return;

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
                      prefixIcon: Icon(
                        Icons.person,
                        size: 24,
                        color: Color(0xFF79a341),
                      ),
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
                    onChanged: (_) => setState(() {
                      _passwordTouched = true;
                    }),
                    decoration: InputDecoration(
                      labelText: 'Contraseña',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(
                        Icons.lock, // Candado al inicio
                        size: 24,
                        color: Color(0xFF79a341),
                      ),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _hidePassword
                              ? Icons.visibility_off
                              : Icons.visibility, // Ojo
                          color: Color(0xFF79a341),
                        ),
                        onPressed: () {
                          // Cambia el estado para mostrar/ocultar la contraseña
                          setState(() {
                            _hidePassword = !_hidePassword;
                          });
                        },
                      ),
                      errorText: _passwordTouched &&
                              (_passwordController.text.isEmpty ||
                                  _passwordController.text.length <= 3)
                          ? 'Debe tener más de 3 caracteres'
                          : null,
                    ),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _isFormValid() ? submit : null,
                    style: ButtonStyle(
                      shape: WidgetStatePropertyAll<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                              borderRadius: BorderRadius.zero)),
                    ),
                    child: _isLoading
                        ? const CircularProgressIndicator(
                            color: Colors.white,
                          )
                        : const Text("Iniciar sesión"),
                  ),
                  const SizedBox(height: 10),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: _useBiometrics
          ? FloatingActionButton(
              onPressed: _authenticateWithBiometrics,
              backgroundColor: Color(0xFF79a341),
              child: const Icon(Icons.fingerprint),
            )
          : null,
    );
  }
}
