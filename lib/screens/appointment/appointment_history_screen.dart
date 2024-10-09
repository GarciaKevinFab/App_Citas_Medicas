import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
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
      backgroundColor: Color(0xFFF5F7FA),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color(0xFF4C8BF5), // Azul fuerte
                Color(0xFF88C8FF), // Azul claro
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
            FaIcon(FontAwesomeIcons.calendarAlt,
                size: 28, color: Colors.white), // Icono moderno
            SizedBox(width: 10),
            Text('Historial de Citas',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold)),
          ],
        ),
        centerTitle: true,
      ),
      body: appointments.isNotEmpty
          ? ListView.builder(
              itemCount: appointments.length,
              itemBuilder: (context, index) {
                return AnimatedContainer(
                  duration: Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                  margin: EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.3),
                        blurRadius: 8,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  child: ListTile(
                    leading: CircleAvatar(
                      radius: 30,
                      backgroundColor: Color(0xFF4C8BF5).withOpacity(0.8),
                      child: FaIcon(
                        FontAwesomeIcons.userMd,
                        color: Colors.white,
                        size: 28,
                      ),
                    ),
                    title: Text(
                      appointments[index]['doctorName'],
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: Color(0xFF4C8BF5),
                      ),
                    ),
                    subtitle: Text(
                      '${appointments[index]['date']} - ${appointments[index]['time']}',
                      style: TextStyle(
                        color: Colors.grey[700],
                        fontSize: 16,
                      ),
                    ),
                    trailing: FaIcon(
                      FontAwesomeIcons.stethoscope,
                      color: Color(0xFF64B5F6),
                      size: 24,
                    ),
                  ),
                );
              },
            )
          : Center(
              child: CircularProgressIndicator(),
            ),
    );
  }
}
