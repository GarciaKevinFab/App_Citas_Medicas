import 'package:flutter/material.dart';
import '../../services/api_service.dart';

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  String email = '';
  String password = '';
  String name = '';
  String lastName = '';
  String role = 'Paciente';
  String specialty = '';
  List<String> availableDays = [];
  List<String> availableHours = [];
  List<String> specialties = [];
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    fetchSpecialties();
  }

  // Función para obtener las especialidades desde la API
  fetchSpecialties() async {
    try {
      List<String> fetchedSpecialties = await ApiService.getSpecialties();
      setState(() {
        specialties = fetchedSpecialties;
        specialty = specialties.isNotEmpty
            ? specialties[0]
            : ''; // Selecciona la primera especialidad por defecto
      });
    } catch (e) {
      print("Error fetching specialties: $e");
    }
  }

  // Función para realizar el registro
  register() async {
    setState(() {
      isLoading = true;
    });

    bool success = await ApiService.register(
      email,
      password,
      role,
      name,
      lastName,
      specialty,
      availableDays,
      availableHours,
    );

    setState(() {
      isLoading = false;
    });

    if (success) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Registro exitoso')));
      Navigator.pushReplacementNamed(context, '/login');
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Error al registrarse')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Registro de Usuario')),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: isLoading
            ? Center(child: CircularProgressIndicator())
            : Column(
                children: <Widget>[
                  TextField(
                    decoration: InputDecoration(labelText: 'Email'),
                    onChanged: (value) {
                      setState(() {
                        email = value;
                      });
                    },
                  ),
                  TextField(
                    decoration: InputDecoration(labelText: 'Contraseña'),
                    obscureText: true,
                    onChanged: (value) {
                      setState(() {
                        password = value;
                      });
                    },
                  ),
                  TextField(
                    decoration: InputDecoration(labelText: 'Nombre'),
                    onChanged: (value) {
                      setState(() {
                        name = value;
                      });
                    },
                  ),
                  DropdownButton<String>(
                    value: role,
                    onChanged: (String? newValue) {
                      setState(() {
                        role = newValue!;
                      });
                    },
                    items: <String>['Paciente', 'Doctor']
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  ),
                  if (role == 'Doctor') ...[
                    TextField(
                      decoration: InputDecoration(labelText: 'Apellido'),
                      onChanged: (value) {
                        setState(() {
                          lastName = value;
                        });
                      },
                    ),
                    DropdownButton<String>(
                      value: specialty.isNotEmpty ? specialty : null,
                      hint: Text('Seleccione una especialidad'),
                      onChanged: (String? newValue) {
                        setState(() {
                          specialty = newValue!;
                        });
                      },
                      items: specialties.isNotEmpty
                          ? specialties
                              .map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList()
                          : [],
                    ),
                    Text('Días Disponibles'),
                    Wrap(
                      children: [
                        'Lunes',
                        'Martes',
                        'Miércoles',
                        'Jueves',
                        'Viernes'
                      ].map((day) {
                        return CheckboxListTile(
                          title: Text(day),
                          value: availableDays.contains(day),
                          onChanged: (bool? selected) {
                            setState(() {
                              if (selected == true) {
                                availableDays.add(day);
                              } else {
                                availableDays.remove(day);
                              }
                            });
                          },
                        );
                      }).toList(),
                    ),
                    Text('Horas Disponibles'),
                    Wrap(
                      children:
                          ['08:00', '10:00', '12:00', '14:00'].map((hour) {
                        return CheckboxListTile(
                          title: Text(hour),
                          value: availableHours.contains(hour),
                          onChanged: (bool? selected) {
                            setState(() {
                              if (selected == true) {
                                availableHours.add(hour);
                              } else {
                                availableHours.remove(hour);
                              }
                            });
                          },
                        );
                      }).toList(),
                    ),
                  ],
                  ElevatedButton(
                    onPressed: register,
                    child: Text('Registrarse'),
                  ),
                ],
              ),
      ),
    );
  }
}
