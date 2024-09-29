import 'package:flutter/material.dart';
import 'doctor_appointments_screen.dart';

class DoctorScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Doctor'),
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
                        builder: (context) => DoctorAppointmentsScreen()));
              },
              child: Text('Ver Citas'),
            ),
          ],
        ),
      ),
    );
  }
}
