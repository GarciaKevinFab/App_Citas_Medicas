import 'package:flutter/material.dart';
import '../../services/api_service.dart';

class CreateAppointmentScreen extends StatefulWidget {
  @override
  _CreateAppointmentScreenState createState() =>
      _CreateAppointmentScreenState();
}

class _CreateAppointmentScreenState extends State<CreateAppointmentScreen> {
  final _formKey = GlobalKey<FormState>();
  String dni = '';
  String name = '';
  String complaint = '';
  String selectedDoctor = '';
  String selectedTime = '';
  String recommendedSpecialty = '';
  List<String> doctors = [];
  Map<String, List<String>> doctorSchedule = {};

  // Solicitar la recomendación de especialidad y doctores
  recommendSpecialtyAndDoctors() async {
    try {
      final recommendation =
          await ApiService.getSpecialtyRecommendation(complaint);
      if (recommendation != null) {
        setState(() {
          recommendedSpecialty =
              recommendation['specialty'] ?? 'Especialidad desconocida';

          doctors = List<String>.from(recommendation['doctors']
                  ?.map((doctor) => doctor['name'] ?? 'Doctor desconocido') ??
              []);

          doctorSchedule = Map<String, List<String>>.fromEntries(
            recommendation['doctors']
                .map<MapEntry<String, List<String>>>((doctor) {
              return MapEntry<String, List<String>>(
                  doctor['name'] ?? 'Doctor desconocido',
                  List<String>.from(doctor['availableHours'] ?? []));
            }).toList(),
          );
        });
      }
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error en la recomendación: $error')));
    }
  }

  // Crear la cita médica
  createAppointment() async {
    try {
      await ApiService.createAppointment(
          dni, name, complaint, selectedDoctor, selectedTime);
      Navigator.pop(context);
    } catch (error) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Error al crear cita: $error')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Crear Cita Médica'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              TextFormField(
                decoration: InputDecoration(labelText: 'DNI'),
                onChanged: (value) {
                  setState(() {
                    dni = value;
                  });
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Nombre'),
                onChanged: (value) {
                  setState(() {
                    name = value;
                  });
                },
              ),
              TextFormField(
                decoration:
                    InputDecoration(labelText: 'Descripción de la Molestia'),
                onChanged: (value) {
                  setState(() {
                    complaint = value;
                  });
                },
              ),
              ElevatedButton(
                onPressed: recommendSpecialtyAndDoctors,
                child: Text('Recomendar Especialidad y Doctores'),
              ),
              if (recommendedSpecialty.isNotEmpty) ...[
                Text('Especialidad Recomendada: $recommendedSpecialty'),
                DropdownButton<String>(
                  value: selectedDoctor.isNotEmpty ? selectedDoctor : null,
                  hint: Text('Seleccione un Doctor'),
                  onChanged: (String? newValue) {
                    setState(() {
                      selectedDoctor = newValue!;
                      selectedTime = ''; // Reset the selected time
                    });
                  },
                  items: doctors.map<DropdownMenuItem<String>>((String doctor) {
                    return DropdownMenuItem<String>(
                      value: doctor,
                      child: Text(doctor),
                    );
                  }).toList(),
                ),
                if (selectedDoctor.isNotEmpty)
                  DropdownButton<String>(
                    value: selectedTime.isNotEmpty ? selectedTime : null,
                    hint: Text('Seleccione una Hora'),
                    onChanged: (String? newValue) {
                      setState(() {
                        selectedTime = newValue!;
                      });
                    },
                    items: doctorSchedule[selectedDoctor]!
                        .map<DropdownMenuItem<String>>((String time) {
                      return DropdownMenuItem<String>(
                        value: time,
                        child: Text(time),
                      );
                    }).toList(),
                  ),
              ],
              ElevatedButton(
                onPressed: createAppointment,
                child: Text('Crear Cita'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
