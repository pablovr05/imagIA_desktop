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
    final url = Uri.parse('https://$baseUrl/api/users/login');

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
}
