import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../services/api_service.dart';

class DoctorDashboard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF5F7FA),
      appBar: AppBar(
        automaticallyImplyLeading: false, // Esto quita la flecha de retroceso
        elevation: 0,
        backgroundColor: Colors.transparent,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color(0xFF355C7D), // Azul oscuro profesional
                Color(0xFF6C5B7B), // Degradado más suave y elegante
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
        title: Row(
          children: [
            FaIcon(FontAwesomeIcons.userMd,
                size: 28, color: Colors.white), // Icono de doctor
            SizedBox(width: 10),
            Text(
              'Panel del Doctor',
              style: TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Botón para ver citas del doctor
              buildDashboardButton(
                context,
                title: 'Ver Citas del Doctor',
                icon: FontAwesomeIcons.calendarCheck,
                colorStart: Color(0xFF42A5F5), // Azul suave
                colorEnd: Color(0xFF64B5F6), // Azul claro
                onPressed: () {
                  Navigator.pushNamed(context, '/doctor_appointments');
                },
              ),
              SizedBox(height: 20), // Espaciado entre botones
              buildDashboardButton(
                context,
                title: 'Historial de Pacientes',
                icon: FontAwesomeIcons.folderOpen,
                colorStart: Color(0xFF5C6BC0), // Azul más oscuro
                colorEnd: Color(0xFF7986CB), // Degradado suave
                onPressed: () {
                  Navigator.pushNamed(context, '/patient_history');
                },
              ),
              SizedBox(
                  height: 40), // Espaciado antes del botón de cerrar sesión
              // Botón para cerrar sesión estilizado
              buildLogoutButton(context),
            ],
          ),
        ),
      ),
    );
  }

  // Método para construir el botón del panel
  Widget buildDashboardButton(BuildContext context,
      {required String title,
      required IconData icon,
      required Color colorStart,
      required Color colorEnd,
      required VoidCallback onPressed}) {
    return GestureDetector(
      onTap: onPressed,
      child: AnimatedContainer(
        duration: Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        width: double.infinity,
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [colorStart, colorEnd],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.15),
              spreadRadius: 3,
              blurRadius: 7,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FaIcon(icon, size: 24, color: Colors.white),
            SizedBox(width: 10),
            Text(
              title,
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Botón para cerrar sesión estilizado con hover
  Widget buildLogoutButton(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        // Limpia el token almacenado
        ApiService.token = null; // Elimina el token almacenado
        ApiService.patientId = null; // Limpia el patientId también

        // Redirigir a la HomeScreen después de cerrar sesión
        Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
      },
      child: AnimatedContainer(
        duration: Duration(milliseconds: 300),
        padding: EdgeInsets.symmetric(vertical: 15, horizontal: 30),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFD32F2F), Color(0xFFE57373)], // Rojo vibrante
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              spreadRadius: 3,
              blurRadius: 7,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.exit_to_app, color: Colors.white),
            SizedBox(width: 10),
            Text(
              'Cerrar Sesión',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
