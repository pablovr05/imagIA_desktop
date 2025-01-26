import 'package:http/http.dart' as http;

class ApiService {
  final String baseUrl;

  // Constructor para inicializar la URL base
  ApiService({required this.baseUrl});

  // Método para verificar conexión básica al servidor
  Future<void> testConnection() async {
    final url = Uri.parse('https://$baseUrl/api/admin/users');

    try {
      final response = await http.get(url);

      if (response.statusCode != 200) {
        throw Exception(
            'El servidor respondió con un estado inesperado: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error de conexión');
      print(e);
    }
  }
}
