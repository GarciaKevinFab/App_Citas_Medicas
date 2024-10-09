import 'package:flutter/material.dart';
import 'screens/appointment/appointment_history_screen.dart';
import 'screens/appointment/create_appointment_screen.dart';
import 'screens/auth/login_screen.dart';
import 'screens/auth/register_screen.dart';
import 'screens/doctor/doctor_appointments_screen.dart';
import 'screens/doctor/doctor_dashboard.dart';
import 'screens/home_screen.dart';
import 'screens/patient/patient_dashboard.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Citas Médicas',
      theme: ThemeData(
        primaryColor: Color(0xFF4C8BF5), // Color azul suave para los botones
        scaffoldBackgroundColor: Colors.white, // Fondo blanco
        textTheme: TextTheme(
          displayLarge: TextStyle(
              fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black),
          bodyLarge: TextStyle(fontSize: 16, color: Colors.grey[800]),
        ),
        buttonTheme: ButtonThemeData(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        ),
        colorScheme:
            ColorScheme.fromSwatch().copyWith(secondary: Color(0xFF88C8FF)),
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => HomeScreen(), // Pantalla de inicio
        '/login': (context) => LoginScreen(),
        '/register': (context) => RegisterScreen(),
        '/patient_dashboard': (context) => PatientDashboard(),
        '/doctor_dashboard': (context) => DoctorDashboard(),
        '/create_appointment': (context) => CreateAppointmentScreen(),
        '/appointment_history': (context) => AppointmentHistoryScreen(),
        '/doctor_appointments': (context) => DoctorAppointmentsScreen(),
      },
    );
  }
}
