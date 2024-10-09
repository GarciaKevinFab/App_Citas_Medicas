import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
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
      backgroundColor: Color(0xFFF5F7FA),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color(0xFF4C8BF5),
                Color(0xFF88C8FF),
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
            FaIcon(FontAwesomeIcons.notesMedical,
                size: 28, color: Colors.white),
            SizedBox(width: 10),
            Text('Crear Cita Médica',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold)),
          ],
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              buildAnimatedInputField(
                labelText: 'DNI',
                inputType: TextInputType.number,
                onChanged: (value) {
                  setState(() {
                    dni = value;
                  });
                },
              ),
              SizedBox(height: 20),
              buildAnimatedInputField(
                labelText: 'Nombre',
                onChanged: (value) {
                  setState(() {
                    name = value;
                  });
                },
              ),
              SizedBox(height: 20),
              buildAnimatedInputField(
                labelText: 'Descripción de la Molestia',
                onChanged: (value) {
                  setState(() {
                    complaint = value;
                  });
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF42A5F5),
                  padding: EdgeInsets.symmetric(vertical: 15, horizontal: 30),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  elevation: 5,
                  shadowColor: Colors.black45,
                ),
                onPressed: recommendSpecialtyAndDoctors,
                child: Text('Recomendar Especialidad y Doctores',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    )),
              ),
              SizedBox(height: 20),
              if (recommendedSpecialty.isNotEmpty) ...[
                Text(
                  'Especialidad Recomendada: $recommendedSpecialty',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF4C8BF5),
                  ),
                ),
                SizedBox(height: 10),
                DropdownButton<String>(
                  value: selectedDoctor.isNotEmpty ? selectedDoctor : null,
                  hint: Text('Seleccione un Doctor'),
                  onChanged: (String? newValue) {
                    setState(() {
                      selectedDoctor = newValue!;
                      selectedTime = '';
                    });
                  },
                  items: doctors.map<DropdownMenuItem<String>>((String doctor) {
                    return DropdownMenuItem<String>(
                      value: doctor,
                      child: Text(doctor),
                    );
                  }).toList(),
                ),
                SizedBox(height: 10),
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
              SizedBox(height: 20),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFFD32F2F),
                  padding: EdgeInsets.symmetric(vertical: 15, horizontal: 30),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  elevation: 5,
                  shadowColor: Colors.black45,
                ),
                onPressed: createAppointment,
                child: Text('Crear Cita',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    )),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Método para construir los campos de texto con animación
  Widget buildAnimatedInputField({
    required String labelText,
    TextInputType inputType = TextInputType.text,
    required ValueChanged<String> onChanged,
  }) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      padding: EdgeInsets.symmetric(vertical: 5),
      child: TextField(
        keyboardType: inputType,
        decoration: InputDecoration(
          labelText: labelText,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(25),
            borderSide: BorderSide.none,
          ),
          filled: true,
          fillColor: Colors.white,
          contentPadding: EdgeInsets.symmetric(vertical: 20, horizontal: 15),
        ),
        onChanged: onChanged,
      ),
    );
  }
}
