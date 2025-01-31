import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ApiService {
  final String baseUrl;

  // Constructor para inicializar la URL base
  ApiService({required this.baseUrl});

  // Método para iniciar sesión
  Future<Map<String, dynamic>> login(
      String nickname, String password, BuildContext context) async {
    final url = Uri.parse('https://$baseUrl/api/usuaris/login');

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'nickname': nickname,
          'password': password,
        }),
      );

      if (response.statusCode == 200) {
        // Éxito: devolver datos decodificados
        return jsonDecode(response.body);
      } else if (response.statusCode == 401) {
        // Mostrar error con SnackBar para credenciales inválidas
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Credenciales inválidas. Verifique sus datos.',
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.w700),
              textAlign: TextAlign.center,
            ),
            backgroundColor: Colors.red,
          ),
        );
        return {};
      } else if (response.statusCode == 404) {
        // Mostrar error con SnackBar para credenciales inexistentes
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Usuario no encontrado',
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.w700),
              textAlign: TextAlign.center,
            ),
            backgroundColor: Colors.red,
          ),
        );
        return {};
      } else if (response.statusCode == 403) {
        // Mostrar error con SnackBar para credenciales sin permiso
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Acceso denegado. No tienes permiso para acceder a esta sección.',
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.w700),
              textAlign: TextAlign.center,
            ),
            backgroundColor: Colors.red,
          ),
        );
        return {};
      } else {
        // Otros errores
        throw Exception(
            'Error del servidor. Código de estado: ${response.statusCode}');
      }
    } catch (e) {
      // Manejar errores generales
      throw Exception('Error de conexión o datos inválidos: $e');
    }
  }

  // Método para obtener todos los usuarios
  Future<Map<String, dynamic>> getAllUsers(BuildContext context) async {
    final url = Uri.parse('https://$baseUrl/api/admin/usuaris');

    try {
      final response = await http.get(
        url,
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else if (response.statusCode == 403) {
        print("403");
        return {};
      } else {
        throw Exception(
            'Error del servidor. Código de estado: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error de conexión o datos inválidos: $e');
    }
  }
}
