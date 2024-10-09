import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
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
    fetchDoctorAppointments(); // Refresca la lista de citas
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF5F7FA), // Color de fondo suave
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color(0xFF355C7D), // Azul fuerte
                Color(0xFF6C5B7B), // Degradado moderno y profesional
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
            Text(
              'Citas del Doctor',
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
        child: appointments.isEmpty
            ? Center(child: CircularProgressIndicator())
            : ListView.builder(
                itemCount: appointments.length,
                itemBuilder: (context, index) {
                  bool isAttended = appointments[index]['attended'] ?? false;

                  return AnimatedContainer(
                    duration: Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                    margin: EdgeInsets.symmetric(vertical: 10),
                    padding: const EdgeInsets.all(16.0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20), // Bordes suaves
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.3),
                          blurRadius: 8,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        // Avatar con sombra
                        CircleAvatar(
                          radius: 30,
                          backgroundColor: isAttended
                              ? Colors.green.withOpacity(0.7)
                              : Colors.blueAccent.withOpacity(0.7),
                          child: FaIcon(
                            isAttended
                                ? FontAwesomeIcons.checkCircle
                                : FontAwesomeIcons.userClock,
                            color: Colors.white,
                            size: 30,
                          ),
                        ),
                        SizedBox(width: 20),
                        // Información de la cita
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                appointments[index]['patientName'],
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                  color: Color(0xFF355C7D),
                                ),
                              ),
                              SizedBox(height: 5),
                              Text(
                                '${appointments[index]['date']} a las ${appointments[index]['time']}',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.grey[700],
                                ),
                              ),
                            ],
                          ),
                        ),
                        // Botón para marcar como atendida
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            padding: EdgeInsets.symmetric(
                                vertical: 10, horizontal: 20),
                            backgroundColor: isAttended
                                ? Colors
                                    .greenAccent // Color para citas atendidas
                                : Color(
                                    0xFF64B5F6), // Azul suave para pendientes
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            elevation: 5,
                            shadowColor: Colors.black45,
                          ),
                          onPressed: isAttended
                              ? null // Deshabilita el botón si ya está atendida
                              : () {
                                  markAsAttended(appointments[index]['_id']);
                                },
                          child: Text(
                            isAttended ? 'Atendida' : 'Marcar como Atendida',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
      ),
    );
  }
}
