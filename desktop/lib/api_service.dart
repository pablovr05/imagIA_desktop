import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  final String baseUrl;

  // Constructor para inicializar la URL base
  ApiService({required this.baseUrl});

  // Método para iniciar sesión
  Future<Map<String, dynamic>> login(String username, String password) async {
    final url = Uri.parse('https://$baseUrl/api/admin/users');

    try {
      // Realizar la solicitud POST
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'username': username,
          'password': password,
        }),
      );

      // Verificar el estado de la respuesta
      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Error al iniciar sesión: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error de conexión: $e');
    }
  }

  // Método para obtener información del servidor
  Future<Map<String, dynamic>> fetchData(String endpoint) async {
    final url = Uri.parse('https://$baseUrl/$endpoint');

    try {
      // Realizar la solicitud GET
      final response = await http.get(
        url,
        headers: {'Content-Type': 'application/json'},
      );

      // Verificar el estado de la respuesta
      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Error al obtener datos: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error de conexión: $e');
    }
  }
}
