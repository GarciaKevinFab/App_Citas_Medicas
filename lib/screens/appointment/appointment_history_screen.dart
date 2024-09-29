import 'package:flutter/material.dart';
import '../../services/api_service.dart';

class AppointmentHistoryScreen extends StatefulWidget {
  @override
  _AppointmentHistoryScreenState createState() =>
      _AppointmentHistoryScreenState();
}

class _AppointmentHistoryScreenState extends State<AppointmentHistoryScreen> {
  List appointments = [];

  @override
  void initState() {
    super.initState();
    fetchAppointments();
  }

  fetchAppointments() async {
    appointments = await ApiService.getPatientAppointments();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Historial de Citas'),
      ),
      body: ListView.builder(
        itemCount: appointments.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(appointments[index]['doctorName']),
            subtitle: Text(
                '${appointments[index]['date']} - ${appointments[index]['time']}'),
          );
        },
      ),
    );
  }
}
