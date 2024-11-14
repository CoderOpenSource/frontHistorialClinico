import 'package:mapas_api/main.dart';
import 'package:mapas_api/screens/user/register_view.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class LoginView extends StatefulWidget {
  const LoginView({Key? key}) : super(key: key);

  @override
  _LoginViewState createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool _obscureText = true;
  bool _isLoading = false;
  String? _error;

  Future<void> _handleSignIn() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      // Simulación de inicio de sesión exitoso sin realizar una solicitud HTTP
      await Future.delayed(Duration(seconds: 1)); // Simula un tiempo de espera

      // Almacenar un accessToken y username simulados en SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('accessToken', 'simulatedAccessToken123');
      await prefs.setString('username', 'admin');

      // Navegar directamente a la siguiente pantalla
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const MyApp()),
      );
    } catch (error) {
      print('Authentication error: $error');
      setState(() {
        _error = 'Error: $error';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Widget _loadingOverlay() {
    return _isLoading
        ? Container(
            color: Colors.black.withOpacity(0.5),
            child: const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 20),
                  Text("Espere por favor...",
                      style: TextStyle(color: Colors.white)),
                ],
              ),
            ),
          )
        : const SizedBox
            .shrink(); // Oculta el indicador de carga si no se está cargando
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color.fromARGB(255, 10, 11, 11),
              Color.fromARGB(0, 91, 168, 213)
            ],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  const Padding(
                    padding: EdgeInsets.all(
                        16.0), // Añade espacio alrededor del título
                    child: Text(
                      'HISTORIA CLÍNICA ELECTRÓNICA SSVS', // Título resumido
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color:
                            Colors.black, // Puedes ajustar el color del texto
                      ),
                    ),
                  ),
                  Container(
                    height: 220,
                    width: 400,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50),
                      image: const DecorationImage(
                        image: AssetImage(
                            'assets/images/pngwing.png'), // Usando una imagen local
                        fit: BoxFit.fitHeight,
                      ),
                    ),
                  ),
                  // Continúa con los demás elementos de tu Colum
                  const SizedBox(height: 30),
                  Card(
                    color: Colors.black.withOpacity(0.7),
                    elevation: 5,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        children: [
                          const Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              "Iniciar sesión:",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 16),
                            ),
                          ),
                          const SizedBox(height: 10),
                          TextField(
                            controller: emailController,
                            style: const TextStyle(color: Color(0xFF1E272E)),
                            decoration: InputDecoration(
                                prefixIcon: const Icon(Icons.email_sharp,
                                    color: Color(0xFF1E272E)),
                                labelText: 'Correo electrónico',
                                labelStyle:
                                    const TextStyle(color: Color(0xFF1E272E)),
                                hintText: 'Correo electrónico',
                                hintStyle:
                                    const TextStyle(color: Color(0xFF1E272E)),
                                border: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                      color: Color(0xFF1E272E)),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                      color: Color(0xFF1E272E)),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                filled: true,
                                fillColor: Colors.white,
                                focusColor: Colors.transparent),
                          ),
                          const SizedBox(height: 15),
                          TextField(
                            controller: passwordController,
                            obscureText: _obscureText,
                            style: const TextStyle(color: Color(0xFF1E272E)),
                            decoration: InputDecoration(
                                labelText: 'Contraseña',
                                labelStyle:
                                    const TextStyle(color: Color(0xFF1E272E)),
                                hintText: 'Contraseña',
                                hintStyle:
                                    const TextStyle(color: Color(0xFF1E272E)),
                                border: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                      color: Color(0xFF1E272E)),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                      color: Color(0xFF1E272E)),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    _obscureText
                                        ? Icons.visibility
                                        : Icons.visibility_off,
                                    color: const Color(0xFF1E272E),
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      _obscureText = !_obscureText;
                                    });
                                  },
                                ),
                                prefixIcon: const Icon(
                                  Icons.password,
                                  color: Color(0xFF1E272E),
                                ),
                                filled: true,
                                fillColor: Colors.white,
                                focusColor: Colors.transparent),
                          ),
                          const SizedBox(height: 15),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: _isLoading ? null : _handleSignIn,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF1E272E),
                                padding: const EdgeInsets.all(12),
                              ),
                              child: const Text(
                                "Iniciar sesión",
                                style: TextStyle(
                                    fontSize: 18, color: Colors.white),
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),
                          Center(
                            child: TextButton(
                              onPressed: () {},
                              child: const Text(
                                "¿Has olvidado la contraseña?",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 16),
                              ),
                            ),
                          ),
                          const SizedBox(height: 5),
                          Center(
                            child: TextButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const RegisterView()),
                                );
                              },
                              child: const Text(
                                "¿No tienes una cuenta? Regístrate",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 16),
                              ),
                            ),
                          ),
                          if (_error != null)
                            Text(
                              _error!,
                              style: const TextStyle(color: Colors.red),
                            ),
                          _loadingOverlay(),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
