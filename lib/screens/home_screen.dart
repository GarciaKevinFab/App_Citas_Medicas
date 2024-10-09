import 'package:flutter/material.dart';
import 'dart:async'; // Para manejar temporizadores

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  double _opacity = 0.0;
  double _scale = 1.0; // Para la animación de escala

  @override
  void initState() {
    super.initState();
    // Inicializamos la animación de opacidad con un pequeño retraso
    Timer(Duration(milliseconds: 500), () {
      setState(() {
        _opacity = 1.0; // Cambia la opacidad para que los elementos aparezcan
      });
    });
  }

  void _onTapDown(TapDownDetails details) {
    setState(() {
      _scale = 0.95; // Reduce la escala al hacer clic
    });
  }

  void _onTapUp(TapUpDetails details) {
    setState(() {
      _scale = 1.0; // Regresa a la escala original cuando se suelta el botón
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0, // Sin sombra para un diseño más limpio
        backgroundColor: Colors.transparent,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF4C8BF5), Color(0xFF88C8FF)], // Gradiente suave
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        title: Text(
          'Citas Médicas',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFF9F9FB), Color(0xFFE6E8EC)], // Fondo degradado
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              // Animación de desvanecimiento para la imagen
              AnimatedOpacity(
                opacity: _opacity,
                duration: Duration(seconds: 1),
                child: Image.asset(
                  'assets/hero-banner.png', // Cambiamos el ícono por la imagen
                  height: 200, // Ajusta el tamaño según lo necesites
                ),
              ),
              SizedBox(height: 20),
              // Animación de desvanecimiento para el logo de texto
              AnimatedOpacity(
                opacity: _opacity,
                duration: Duration(seconds: 1),
                child: Text(
                  'Citas Médicas',
                  style: TextStyle(
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF4C8BF5),
                    letterSpacing: 2.0,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(height: 30),
              Text(
                'Bienvenido',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF355C7D),
                ),
              ),
              SizedBox(height: 10),
              Text(
                'Agende una cita con su médico de forma fácil y rápida',
                style: TextStyle(fontSize: 18, color: Colors.grey[600]),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 40),
              // Botón con animación de escala para "Crear una cuenta"
              GestureDetector(
                onTapDown: _onTapDown,
                onTapUp: _onTapUp,
                child: AnimatedScale(
                  scale: _scale,
                  duration: Duration(milliseconds: 100), // Animación rápida
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF4C8BF5),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      minimumSize: Size(200, 50), // Tamaño consistente
                      shadowColor: Colors.black45, // Sombra más suave
                      elevation: 5, // Elevar un poco los botones
                    ),
                    onPressed: () {
                      Navigator.pushNamed(context, '/register');
                    },
                    child: Text(
                      'Crear una cuenta',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20),
              // Botón con animación de escala para "Ingresar"
              GestureDetector(
                onTapDown: _onTapDown,
                onTapUp: _onTapUp,
                child: AnimatedScale(
                  scale: _scale,
                  duration: Duration(milliseconds: 100),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      side: BorderSide(color: Color(0xFF4C8BF5)),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      minimumSize: Size(200, 50), // Tamaño consistente
                      shadowColor: Colors.black45, // Sombra suave
                      elevation: 5,
                    ),
                    onPressed: () {
                      Navigator.pushNamed(context, '/login');
                    },
                    child: Text(
                      'Ingresar',
                      style: TextStyle(
                        fontSize: 18,
                        color: Color(0xFF4C8BF5),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
