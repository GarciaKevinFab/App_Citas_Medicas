import 'package:flutter/material.dart';
import '../../services/api_service.dart';

class DoctorAppointmentsScreen extends StatefulWidget {
  @override
  _DoctorAppointmentsScreenState createState() =>
      _DoctorAppointmentsScreenState();
}

class _DoctorAppointmentsScreenState extends State<DoctorAppointmentsScreen> {
  List appointments = [];

  @override
  void initState() {
    super.initState();
    fetchDoctorAppointments();
  }

  fetchDoctorAppointments() async {
    try {
      appointments = await ApiService.getDoctorAppointments();
      if (appointments.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('No se encontraron citas para este doctor')),
        );
      }
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al obtener citas: $error')),
      );
    }
    setState(() {}); // Actualizar la UI
  }

  markAsAttended(String appointmentId) async {
    await ApiService.markAppointmentAsAttended(appointmentId);
    fetchDoctorAppointments();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Citas del Doctor'),
      ),
      body: ListView.builder(
        itemCount: appointments.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(appointments[index]['patientName']),
            subtitle: Text(
                '${appointments[index]['date']} a las ${appointments[index]['time']}'),
            trailing: ElevatedButton(
              onPressed: () {
                markAsAttended(appointments[index]['_id']);
              },
              child: Text('Marcar como Atendida'),
            ),
          );
        },
      ),
    );
  }
}
