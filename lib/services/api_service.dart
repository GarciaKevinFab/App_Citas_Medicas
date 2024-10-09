import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static String apiUrl = 'https://backend-appcitas.onrender.com';
  static String? token;
  static String? patientId; // Se llenará cuando el paciente inicie sesión

  static Future<Map<String, dynamic>?> login(
      String email, String password) async {
    final response = await http.post(
      Uri.parse('$apiUrl/api/login'),
      headers: {"Content-Type": "application/json"},
      body: json.encode({
        "email": email,
        "password": password,
      }),
    );
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      token = data['token']; // Almacena el token
      patientId = data['userId']; // Guarda el patientId del usuario autenticado
      return {
        "token": data['token'],
        "role": data['role'],
      };
    }
    return null;
  }

  static Future<bool> register(
      String email,
      String password,
      String role,
      String name,
      String lastName,
      String specialty,
      List<String> availableDays,
      List<String> availableHours) async {
    final response = await http.post(
      Uri.parse('$apiUrl/api/register'),
      headers: {"Content-Type": "application/json"},
      body: json.encode({
        "email": email,
        "password": password,
        "role": role,
        "name": name,
        "lastName": lastName,
        "specialty": specialty,
        "availableDays": availableDays,
        "availableHours": availableHours,
      }),
    );

    return response.statusCode == 200;
  }

  static Future<List<String>> getSpecialties() async {
    final response = await http.get(Uri.parse('$apiUrl/api/specialties'));
    if (response.statusCode == 200) {
      return List<String>.from(
          json.decode(response.body).map((item) => item['name']));
    }
    return [];
  }

  static Future<List> getPatientAppointments() async {
    final response = await http.get(
      Uri.parse('$apiUrl/api/patientAppointments'),
      headers: {"Authorization": "Bearer $token"},
    );
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load patient appointments');
    }
  }

  static Future<List> getDoctorAppointments() async {
    final response = await http.get(
      Uri.parse('$apiUrl/api/doctorAppointments'),
      headers: {"Authorization": "Bearer $token"},
    );
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load doctor appointments');
    }
  }

  static Future markAppointmentAsAttended(String appointmentId) async {
    final response = await http.put(
      Uri.parse('$apiUrl/api/appointments/$appointmentId/attend'),
      headers: {"Authorization": "Bearer $token"},
    );
    if (response.statusCode != 200) {
      throw Exception('Failed to mark appointment as attended');
    }
  }

  static Future<Map<String, dynamic>?> getSpecialtyRecommendation(
      String complaint) async {
    if (token == null) {
      throw Exception('Token no disponible');
    }

    final response = await http.post(
      Uri.parse('$apiUrl/api/recommendation'),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token"
      },
      body: json.encode({"complaint": complaint}),
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception(
          'Failed to get recommendation. Status code: ${response.statusCode}');
    }
  }

  static Future createAppointment(String dni, String name, String complaint,
      String doctor, String time) async {
    if (token == null) {
      throw Exception('Token no disponible');
    }

    if (patientId == null) {
      throw Exception('Patient ID no disponible');
    }

    print("Enviando datos para la cita:");
    print("Patient ID: $patientId");
    print("Patient Name: $name");
    print("Doctor Name: $doctor");
    print("Time: $time");

    final response = await http.post(
      Uri.parse('$apiUrl/api/appointments'),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token"
      },
      body: json.encode({
        "patientId": patientId,
        "patientName": name,
        "doctorName": doctor,
        "date": "2023-12-01", // Cambiar por la fecha real si lo necesitas
        "time": time,
      }),
    );

    if (response.statusCode != 201) {
      print("Error al crear cita: ${response.statusCode}");
      print("Respuesta del servidor: ${response.body}");
      throw Exception(
          'Failed to create appointment. Status code: ${response.statusCode}');
    }
  }
}
