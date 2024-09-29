import 'package:flutter/material.dart';
import '../appointment/create_appointment_screen.dart';
import '../appointment/appointment_history_screen.dart';

class PatientScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Paciente'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => CreateAppointmentScreen()));
              },
              child: Text('Reservar Nueva Cita'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => AppointmentHistoryScreen()));
              },
              child: Text('Ver Historial de Citas'),
            ),
          ],
        ),
      ),
    );
  }
}
