import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // Para el feedback háptico
import 'package:font_awesome_flutter/font_awesome_flutter.dart'; // Para el ícono de FontAwesome
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
  bool isDoctor = false;
  String specialty = '';
  List<String> availableDays = [];
  List<String> availableHours = [];
  List<String> specialties = [];
  bool isLoading = false;
  bool isHovering = false;

  @override
  void initState() {
    super.initState();
    fetchSpecialties();
  }

  fetchSpecialties() async {
    try {
      List<String> fetchedSpecialties = await ApiService.getSpecialties();
      setState(() {
        specialties = fetchedSpecialties;
        specialty = specialties.isNotEmpty ? specialties[0] : '';
      });
    } catch (e) {
      print("Error fetching specialties: $e");
    }
  }

  register() async {
    setState(() {
      isLoading = true;
    });

    bool success = await ApiService.register(
      email,
      password,
      isDoctor ? 'Doctor' : 'Paciente',
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
      backgroundColor: Color(0xFFF5F7FA), // Fondo más profesional
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color(0xFF355C7D),
                Color(0xFF6C5B7B)
              ], // Gradiente más elegante
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
            Icon(Icons.person_add_alt, color: Colors.white),
            SizedBox(width: 10),
            Text('Registro de Usuario', style: TextStyle(color: Colors.white)),
          ],
        ),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color(0xFFF9F9FB),
                  Color(0xFFE6E8EC)
                ], // Gradiente suave
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
          SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 25, vertical: 20),
            child: isLoading
                ? Center(child: CircularProgressIndicator())
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      SizedBox(height: 30),
                      // Ícono de registro en el centro
                      FaIcon(
                        FontAwesomeIcons.userPlus,
                        size: 80,
                        color: Color(0xFF355C7D),
                      ),
                      SizedBox(height: 30),
                      // Campo de Email
                      buildAnimatedInputField(
                        labelText: 'Email',
                        prefixIcon: Icons.email,
                        onChanged: (value) => setState(() => email = value),
                      ),
                      SizedBox(height: 20),
                      // Campo de Contraseña
                      buildAnimatedInputField(
                        labelText: 'Contraseña',
                        prefixIcon: Icons.lock,
                        obscureText: true,
                        onChanged: (value) => setState(() => password = value),
                      ),
                      SizedBox(height: 20),
                      // Campo de Nombre
                      buildAnimatedInputField(
                        labelText: 'Nombre',
                        prefixIcon: Icons.person,
                        onChanged: (value) => setState(() => name = value),
                      ),
                      SizedBox(height: 20),

                      // Interruptor de Rol moderno
                      buildModernRoleSwitch(),

                      if (isDoctor) ...[
                        SizedBox(height: 20),
                        // Campo de Apellido
                        buildAnimatedInputField(
                          labelText: 'Apellido',
                          prefixIcon: Icons.person_outline,
                          onChanged: (value) =>
                              setState(() => lastName = value),
                        ),
                        SizedBox(height: 20),
                        // Dropdown de Especialidad
                        buildSpecialtyDropdown(),
                        SizedBox(height: 20),
                        // Checkboxes de Días Disponibles
                        buildModernDaysAvailable(),
                        SizedBox(height: 20),
                        // Checkboxes de Horas Disponibles
                        buildModernHoursAvailable(),
                      ],
                      SizedBox(height: 30),
                      // Botón de Registro con hover y animación de color
                      MouseRegion(
                        onEnter: (_) => setState(() => isHovering = true),
                        onExit: (_) => setState(() => isHovering = false),
                        child: GestureDetector(
                          onTapDown: (_) => HapticFeedback.lightImpact(),
                          child: buildAnimatedRegisterButton(),
                        ),
                      ),
                    ],
                  ),
          ),
        ],
      ),
    );
  }

  Widget buildAnimatedInputField({
    required String labelText,
    required IconData prefixIcon,
    bool obscureText = false,
    required ValueChanged<String> onChanged,
  }) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      padding: EdgeInsets.symmetric(vertical: 5),
      child: TextField(
        decoration: InputDecoration(
          labelText: labelText,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(25),
            borderSide: BorderSide.none,
          ),
          filled: true,
          fillColor: Colors.white,
          prefixIcon: Icon(prefixIcon, color: Color(0xFF355C7D)),
          contentPadding:
              EdgeInsets.symmetric(vertical: 20, horizontal: 15), // Espaciado
        ),
        obscureText: obscureText,
        onChanged: onChanged,
      ),
    );
  }

  Widget buildModernRoleSwitch() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          isDoctor ? 'Doctor' : 'Paciente',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w500,
            color: Color(0xFF355C7D),
          ),
        ),
        SizedBox(width: 20),
        Transform.scale(
          scale: 1.3,
          child: Switch(
            value: isDoctor,
            onChanged: (value) {
              setState(() {
                isDoctor = value;
              });
            },
            activeColor: Color(0xFF3A78D7),
            inactiveTrackColor: Colors.grey[300],
            inactiveThumbColor: Colors.white,
          ),
        ),
      ],
    );
  }

  Widget buildSpecialtyDropdown() {
    return DropdownButtonFormField<String>(
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(25),
          borderSide: BorderSide.none,
        ),
        filled: true,
        fillColor: Colors.white,
      ),
      value: specialty.isNotEmpty ? specialty : null,
      hint: Text('Seleccione una especialidad'),
      onChanged: (String? newValue) {
        setState(() {
          specialty = newValue!;
        });
      },
      items: specialties.isNotEmpty
          ? specialties.map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList()
          : [],
    );
  }

  Widget buildModernDaysAvailable() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Días Disponibles',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
        ),
        Wrap(
          spacing: 10,
          children:
              ['Lunes', 'Martes', 'Miércoles', 'Jueves', 'Viernes'].map((day) {
            return ChoiceChip(
              label: Text(day),
              selected: availableDays.contains(day),
              onSelected: (bool selected) {
                setState(() {
                  if (selected) {
                    availableDays.add(day);
                  } else {
                    availableDays.remove(day);
                  }
                });
              },
              backgroundColor: Colors.grey[200],
              selectedColor: Color(0xFF355C7D),
              labelStyle: TextStyle(color: Colors.white),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget buildModernHoursAvailable() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Horas Disponibles',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
        ),
        Wrap(
          spacing: 10,
          children: ['08:00', '10:00', '12:00', '14:00'].map((hour) {
            return ChoiceChip(
              label: Text(hour),
              selected: availableHours.contains(hour),
              onSelected: (bool selected) {
                setState(() {
                  if (selected) {
                    availableHours.add(hour);
                  } else {
                    availableHours.remove(hour);
                  }
                });
              },
              backgroundColor: Colors.grey[200],
              selectedColor: Color(0xFF355C7D),
              labelStyle: TextStyle(color: Colors.white),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget buildAnimatedRegisterButton() {
    return AnimatedContainer(
      duration: Duration(milliseconds: 300),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: isHovering
              ? [Color(0xFF355C7D), Color(0xFF6C5B7B)]
              : [Color(0xFF6C5B7B), Color(0xFF355C7D)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 2,
            blurRadius: 7,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          minimumSize: Size(double.infinity, 50),
        ),
        onPressed: register,
        child: Text(
          'Registrarse',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
