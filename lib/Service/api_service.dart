import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:shared_preferences/shared_preferences.dart';

const String baseUrl = 'http://10.0.2.2:8080'; //prueba en emulador

/* const String baseUrl = 'http://192.168.0.10:8080'; //prueba en dispositivo movil*/

class ApiService {
  final String baseUrl;

  ApiService(this.baseUrl);

  Future<bool> login(String username, String password) async {
    final url = Uri.parse('$baseUrl/auth/login');
    final headers = {
      'Content-Type': 'application/json',
    };
    final body = jsonEncode({
      'username': username,
      'password': password,
    });

    try {
      final response = await http.post(
        url,
        headers: headers,
        body: body,
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        final token = responseData['token'];

        // Guarda el token en SharedPreferences
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('jwt_token', token);

        // Decodifica el token
        Map<String, dynamic> decodedToken = JwtDecoder.decode(token);
        String username = decodedToken['sub'];
        int userId = decodedToken['userId'];
        String role = decodedToken['role'];

        // Guarda el rol y nombre de usuario en SharedPreferences
        await prefs.setString('user_role', role);
        await prefs.setString('username', username);

        if (kDebugMode) {
          print('Username: $username');
          print('User ID: $userId');
          print('User Role: $role');
        }
        return true; // Login exitoso
      } else {
        if (kDebugMode) {
          print('Error: ${response.statusCode} - ${response.body}');
        }
        return false; // Login fallido
      }
    } catch (e) {
      if (kDebugMode) {
        print('Exception: $e');
      }
      return false; // Login fallido
    }
  }

  // Método para registrar un paciente
  Future<bool> registrarPaciente({
    required String userName,
    required String password,
    required String email,
    required String nombre,
    required String apellidoPaterno,
    required String apellidoMaterno,
    required String fechaNacimiento,
    required int rolId,
    required int idAseguradora,
  }) async {
    final url = Uri.parse('$baseUrl/usuarios/registro-paciente');

    final body = jsonEncode({
      'userName': userName,
      'password': password,
      'email': email,
      'nombre': nombre,
      'apellidoPaterno': apellidoPaterno,
      'apellidoMaterno': apellidoMaterno,
      'fechaNacimiento': fechaNacimiento,
      'rolId': rolId,
      'idAseguradora': idAseguradora,
    });

    final headers = {
      'Content-Type': 'application/json',
    };

    try {
      final response = await http.post(url, headers: headers, body: body);

      if (response.statusCode == 200) {
        // Registro exitoso
        return true;
      } else {
        // Registro fallido
        if (kDebugMode) {
          print('Error en registro: ${response.body}');
        }
        return false;
      }
    } catch (e) {
      if (kDebugMode) {
        print('Excepción durante el registro: $e');
      }
      return false;
    }
  }

  Future<Map<String, String>> _obtenerHeaders() async {
    final token = await obtenerToken();
    if (token == null) {
      throw Exception('Token no disponible. Por favor, inicia sesión.');
    }

    return {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };
  }

  // Método para obtener usuarios por rol
  Future<List<dynamic>> obtenerUsuariosPorRol(int rolId) async {
    final url = Uri.parse('$baseUrl/usuarios/rol/$rolId');
    final headers = await _obtenerHeaders();

    final response = await http.get(url, headers: headers);

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Error al obtener usuarios con rol $rolId');
    }
  }

  // Obtener todas las aseguradoras
  Future<List<dynamic>> obtenerAseguradoras() async {
    final url = Uri.parse('$baseUrl/aseguradora');
    final headers = await _obtenerHeaders();

    final response = await http.get(url, headers: headers);

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Error al obtener aseguradoras');
    }
  }

  // Crear nueva aseguradora
  Future<bool> crearAseguradora(Map<String, dynamic> aseguradoraData) async {
    final url = Uri.parse('$baseUrl/aseguradora');
    final headers = await _obtenerHeaders();

    final response = await http.post(
      url,
      headers: headers,
      body: jsonEncode(aseguradoraData),
    );

    return response.statusCode == 201;
  }

  // Actualizar aseguradora existente
  Future<bool> actualizarAseguradora(
      int id, Map<String, dynamic> aseguradoraData) async {
    final url = Uri.parse('$baseUrl/aseguradora/$id');
    final headers = await _obtenerHeaders();

    final response = await http.put(
      url,
      headers: headers,
      body: jsonEncode(aseguradoraData),
    );

    return response.statusCode == 200;
  }

  // Eliminar aseguradora
  Future<bool> eliminarAseguradora(int id) async {
    final url = Uri.parse('$baseUrl/aseguradora/$id');
    final headers = await _obtenerHeaders();

    final response = await http.delete(url, headers: headers);

    return response.statusCode == 204;
  }

  // Obtener todas las Especialidades
  Future<List<dynamic>> obtenerEspecialidades() async {
    final url = Uri.parse('$baseUrl/especialidades');
    final headers = await _obtenerHeaders();

    final response = await http.get(url, headers: headers);

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Error al obtener especialidades');
    }
  }

  // Crear nueva Especialidad
  Future<bool> crearEspecialidades(
      Map<String, dynamic> especialidadData) async {
    final url = Uri.parse('$baseUrl/especialidades');
    final headers = await _obtenerHeaders();

    final response = await http.post(
      url,
      headers: headers,
      body: jsonEncode(especialidadData),
    );

    return response.statusCode == 201;
  }

  // Actualizar Especialidades existente
  Future<bool> actualizarEspecialidades(
      int id, Map<String, dynamic> especialidadData) async {
    final url = Uri.parse('$baseUrl/especialidades/$id');
    final headers = await _obtenerHeaders();

    final response = await http.put(
      url,
      headers: headers,
      body: jsonEncode(especialidadData),
    );

    return response.statusCode == 200;
  }

  // Eliminar Especialidades
  Future<bool> eliminarEspecialidades(int id) async {
    final url = Uri.parse('$baseUrl/especialidades/$id');
    final headers = await _obtenerHeaders();

    final response = await http.delete(url, headers: headers);

    return response.statusCode == 204;
  }

  // Obtener todos los horarios
  Future<List<dynamic>> obtenerHorarios() async {
    final url = Uri.parse('$baseUrl/horarioAtencion');
    final headers = await _obtenerHeaders();

    final response = await http.get(url, headers: headers);

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Error al obtener horarios');
    }
  }

  // Crear nuevo horario
  Future<bool> crearHorario(Map<String, dynamic> horarioData) async {
    final url = Uri.parse('$baseUrl/horarioAtencion');
    final headers = await _obtenerHeaders();

    final response = await http.post(
      url,
      headers: headers,
      body: jsonEncode(horarioData),
    );

    return response.statusCode == 201;
  }

  // Actualizar horario existente
  Future<bool> actualizarHorario(
      int id, Map<String, dynamic> horarioData) async {
    final url = Uri.parse('$baseUrl/horarioAtencion/$id');
    final headers = await _obtenerHeaders();

    final response = await http.put(
      url,
      headers: headers,
      body: jsonEncode(horarioData),
    );

    return response.statusCode == 200;
  }

  Future<String?> obtenerToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('jwt_token');
  }

  Future<Map<String, dynamic>> obtenerCitas() async {
    final url = Uri.parse('$baseUrl/citaHora/semana');
    final token = await obtenerToken();

    if (token == null) {
      throw Exception('Token no disponible. Por favor, inicia sesión.');
    }

    final response = await http.get(
      url,
      headers: {
        'Authorization': 'Bearer $token', // Incluye el token en el encabezado
        'Accept': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body) as Map<String, dynamic>;
    } else {
      throw Exception(
          'Error al obtener citas: ${response.statusCode} - ${response.body}');
    }
  }

  Future<Map<String, dynamic>> obtenerAllCitas() async {
    final url = Uri.parse('$baseUrl/citaHora/todas/semana');
    final token = await obtenerToken();

    if (token == null) {
      throw Exception('Token no disponible. Por favor, inicia sesión.');
    }

    final response = await http.get(
      url,
      headers: {
        'Authorization': 'Bearer $token', // Incluye el token en el encabezado
        'Accept': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body) as Map<String, dynamic>;
    } else {
      throw Exception(
          'Error al obtener citas: ${response.statusCode} - ${response.body}');
    }
  }

  // Método para reservar una cita
  Future<Map<String, dynamic>?> reservarCita(int citaHoraId) async {
    final token = await obtenerToken();
    if (token == null) {
      throw Exception(
          'Token no disponible. Por favor, inicia sesión nuevamente.');
    }

    final url = Uri.parse('$baseUrl/citas/reservar?citaHoraId=$citaHoraId');
    final headers = {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };

    final response = await http.post(url, headers: headers);

    if (response.statusCode == 200) {
      return jsonDecode(response.body); // Devuelve la respuesta decodificada
    } else {
      if (kDebugMode) {
        print(
            'Error al reservar la cita: ${response.statusCode} - ${response.body}');
      }
      return null; // Devuelve null si la reserva falla
    }
  }

  Future<void> subirDocumento(Map<String, dynamic> datosDocumento) async {
    final url = Uri.parse('$baseUrl/archivos/subir');
    final token = await obtenerToken();

    if (token == null) {
      throw Exception('Token no disponible. Por favor, inicia sesión.');
    }

    final response = await http.post(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode(datosDocumento),
    );

    if (response.statusCode != 200) {
      throw Exception(
          'Error al subir documento: ${response.statusCode} - ${response.body}');
    }
  }
}
