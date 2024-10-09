import 'package:flutter/material.dart';

import '../../services/api_service.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  String email = '';
  String password = '';
  bool _obscureText = true;

  // Función para manejar el login
  login() async {
    final result = await ApiService.login(email, password);
    if (result != null) {
      // Redirige según el rol del usuario
      if (result['role'] == 'Paciente') {
        Navigator.pushReplacementNamed(context, '/patient_dashboard');
      } else if (result['role'] == 'Doctor') {
        Navigator.pushReplacementNamed(context, '/doctor_dashboard');
      }
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Error en el login')));
    }
  }

  // Función para alternar la visibilidad de la contraseña
  void _togglePasswordVisibility() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF5F7FA), // Color de fondo más suave
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color(0xFF355C7D), // Azul fuerte y más profesional
                Color(0xFF6C5B7B), // Gradiente de morado
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 10,
                spreadRadius: 1,
              ),
            ],
          ),
        ),
        title: Text('Iniciar Sesión', style: TextStyle(color: Colors.white)),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            SizedBox(height: 50),
            // Logo o ícono de login con animación
            Icon(
              Icons.lock_outline,
              size: 100,
              color: Color(0xFF355C7D),
            ),
            SizedBox(height: 20),
            // Título de pantalla
            Text(
              'Bienvenido de nuevo',
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                color: Color(0xFF355C7D),
              ),
            ),
            SizedBox(height: 20),
            // Formulario
            Form(
              key: _formKey,
              child: Column(
                children: [
                  // Campo de Email
                  buildAnimatedInputField(
                    labelText: 'Email',
                    prefixIcon: Icons.email,
                    onChanged: (value) => setState(() => email = value),
                  ),
                  SizedBox(height: 20),
                  // Campo de Contraseña con opción de mostrar/ocultar
                  buildPasswordInputField(),
                  SizedBox(height: 10),
                  // Opción de "¿Olvidaste tu contraseña?"
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () {
                        // Implementar funcionalidad de recuperación más adelante
                      },
                      child: Text(
                        '¿Olvidaste tu contraseña?',
                        style: TextStyle(
                          color: Color(0xFF355C7D),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  // Botón de Iniciar Sesión estilizado
                  buildLoginButton(),
                  SizedBox(height: 20),
                  // Texto de redirección a registro
                  buildRegisterOption(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildAnimatedInputField({
    required String labelText,
    required IconData prefixIcon,
    required ValueChanged<String> onChanged,
  }) {
    return TextFormField(
      decoration: InputDecoration(
        labelText: labelText,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
        ),
        prefixIcon: Icon(prefixIcon, color: Color(0xFF355C7D)),
        filled: true,
        fillColor: Colors.white,
        contentPadding: EdgeInsets.symmetric(vertical: 15, horizontal: 15),
      ),
      onChanged: onChanged,
    );
  }

  Widget buildPasswordInputField() {
    return TextFormField(
      decoration: InputDecoration(
        labelText: 'Contraseña',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
        ),
        prefixIcon: Icon(Icons.lock, color: Color(0xFF355C7D)),
        suffixIcon: IconButton(
          icon: Icon(
            _obscureText ? Icons.visibility : Icons.visibility_off,
            color: Color(0xFF355C7D),
          ),
          onPressed: _togglePasswordVisibility,
        ),
        filled: true,
        fillColor: Colors.white,
        contentPadding: EdgeInsets.symmetric(vertical: 15, horizontal: 15),
      ),
      obscureText: _obscureText,
      onChanged: (value) => setState(() => password = value),
    );
  }

  Widget buildLoginButton() {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: Color(0xFF355C7D),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
        minimumSize: Size(double.infinity, 50),
        elevation: 5,
      ),
      onPressed: login,
      child: Text(
        'Iniciar Sesión',
        style: TextStyle(fontSize: 18, color: Colors.white),
      ),
    );
  }

  Widget buildRegisterOption() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text('¿No tienes una cuenta?'),
        TextButton(
          onPressed: () {
            Navigator.pushNamed(context, '/register');
          },
          child: Text(
            'Regístrate',
            style: TextStyle(color: Color(0xFF355C7D)),
          ),
        ),
      ],
    );
  }
}
