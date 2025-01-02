import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

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

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
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

  void submit() async {
    setState(() {
      _isLoading = true;
    });

    await Future.delayed(Duration(seconds: 2));

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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      resizeToAvoidBottomInset: true,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 40),
            // Usamos Stack para superponer las imágenes
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
                    decoration: const InputDecoration(
                      labelStyle: TextStyle(color: Colors.black),
                      labelText: 'Usuario',
                      border: OutlineInputBorder(),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Color(0xFF79a341),
                          width: 2.0,
                        ),
                      ),
                    ),
                    style: TextStyle(
                        color: Colors.black), // Cambia el color del texto
                    cursorColor:
                        Color(0xFF79a341), // Cambia el color del cursor
                  ),
                  const SizedBox(height: 20),
                  Column(
                    children: [
                      TextFormField(
                        controller: _passwordController,
                        obscureText: _hidePassword,
                        focusNode: _passwordFocusNode,
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
                          suffixIcon: IconButton(
                            icon: Icon(
                              _hidePassword
                                  ? Icons.visibility_off
                                  : Icons.visibility,
                            ),
                            onPressed: togglePasswordVisibility,
                          ),
                        ),
                        style: TextStyle(
                            color: Colors.black), // Cambia el color del texto
                        cursorColor:
                            Color(0xFF79a341), // Cambia el color del cursorn
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
                    ],
                  ),
                  const SizedBox(height: 60),
                  _isLoading
                      ? CircularProgressIndicator(
                          color: Color(0xFF79a341),
                        )
                      : ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xFF79a341),
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.zero,
                            ),
                          ),
                          onPressed: submit,
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
