import 'package:flutter/material.dart';

class DoctorDashboard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Panel del Doctor')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: ElevatedButton(
            onPressed: () {
              Navigator.pushNamed(context, '/doctor_appointments');
            },
            child: Text('Ver Citas del Doctor'),
          ),
        ),
      ),
    );
  }
}
