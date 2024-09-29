import 'package:flutter/material.dart';

class PatientDashboard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Panel del Paciente')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/appointment_history');
              },
              child: Text('Ver Historial de Citas'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/create_appointment');
              },
              child: Text('Crear Nueva Cita'),
            ),
          ],
        ),
      ),
    );
  }
}
