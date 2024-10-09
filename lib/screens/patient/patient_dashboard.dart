import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../services/api_service.dart';

class PatientDashboard extends StatefulWidget {
  @override
  _PatientDashboardState createState() => _PatientDashboardState();
}

class _PatientDashboardState extends State<PatientDashboard> {
  bool isHoveringAppointmentHistory = false;
  bool isHoveringNewAppointment = false;

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
                Color(0xFF5C6BC0), // Azul más oscuro
                Color(0xFF7986CB), // Azul suave
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
            FaIcon(FontAwesomeIcons.userCircle, size: 28, color: Colors.white),
            SizedBox(width: 10),
            Text(
              'Panel del Paciente',
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 20),
            // Tarjeta para historial de citas con hover y animación
            MouseRegion(
              onEnter: (_) {
                setState(() {
                  isHoveringAppointmentHistory = true;
                });
              },
              onExit: (_) {
                setState(() {
                  isHoveringAppointmentHistory = false;
                });
              },
              child: buildDashboardCard(
                context,
                title: 'Ver Historial de Citas',
                icon: FontAwesomeIcons.calendarCheck,
                onTap: () {
                  Navigator.pushNamed(context, '/appointment_history');
                },
                colorStart: Color(0xFF9575CD), // Púrpura suave
                colorEnd: Color(0xFF7E57C2), // Púrpura más oscuro
                isHovering: isHoveringAppointmentHistory,
              ),
            ),
            SizedBox(height: 20),
            // Tarjeta para crear nueva cita con hover y animación
            MouseRegion(
              onEnter: (_) {
                setState(() {
                  isHoveringNewAppointment = true;
                });
              },
              onExit: (_) {
                setState(() {
                  isHoveringNewAppointment = false;
                });
              },
              child: buildDashboardCard(
                context,
                title: 'Crear Nueva Cita',
                icon: FontAwesomeIcons.calendarPlus,
                onTap: () {
                  Navigator.pushNamed(context, '/create_appointment');
                },
                colorStart: Color(0xFF64B5F6), // Azul suave
                colorEnd: Color(0xFF42A5F5), // Azul vibrante
                isHovering: isHoveringNewAppointment,
              ),
            ),
            Spacer(),
            // Botón para cerrar sesión estilizado
            buildLogoutButton(context),
          ],
        ),
      ),
    );
  }

  // Método para construir las tarjetas con gradientes y hover
  Widget buildDashboardCard(BuildContext context,
      {required String title,
      required IconData icon,
      required Function onTap,
      required Color colorStart,
      required Color colorEnd,
      required bool isHovering}) {
    return GestureDetector(
      onTap: () => onTap(),
      child: AnimatedContainer(
        duration: Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        width: double.infinity,
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors:
                isHovering ? [colorEnd, colorStart] : [colorStart, colorEnd],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              spreadRadius: 3,
              blurRadius: 7,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          children: [
            FaIcon(icon, size: 50, color: Colors.white),
            SizedBox(height: 15),
            Text(
              title,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
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
      onTap: () {
        // Aquí puedes limpiar el token o cualquier otro dato de sesión si es necesario
        ApiService.token = null; // Limpia el token almacenado
        ApiService.patientId = null; // Limpia el patientId también

        // Redirigir a la HomeScreen
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
