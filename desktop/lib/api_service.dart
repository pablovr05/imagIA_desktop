import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

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
        final responseData = jsonDecode(response.body);
        final userId = (responseData['data']['userId'] as int?) ?? 0;
        final authToken = response.headers['authorization'] ?? '';

        // Guardar en SharedPreferences
        await _saveCredentials(userId, authToken);
        return responseData;
      } else if (response.statusCode == 401) {
        _showSnackBar(context, 'Credenciales inválidas. Verifique sus datos.');
        return {};
      } else if (response.statusCode == 404) {
        _showSnackBar(context, 'Usuario no encontrado');
        return {};
      } else if (response.statusCode == 403) {
        _showSnackBar(context, 'Acceso denegado. No tienes permiso.');
        return {};
      } else {
        throw Exception(
            'Error del servidor. Código de estado: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error de conexión o datos inválidos: $e');
    }
  }

  Future<void> _saveCredentials(int userId, String authToken) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('userId', userId);
    await prefs.setString('authToken', authToken);
  }

  static Future<int> getUserId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt('userId') ?? 0;
  }

  static Future<String> getAuthToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('authToken') ?? '';
  }

  void _showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style:
              const TextStyle(color: Colors.white, fontWeight: FontWeight.w700),
          textAlign: TextAlign.center,
        ),
        backgroundColor: Colors.red,
      ),
    );
  }

  // Método para obtener todos los usuarios
  Future<Map<String, dynamic>> getAllUsers(Future<int> idFuture,
      Future<String> tokenFuture, BuildContext context) async {
    final url = Uri.parse('https://$baseUrl/api/admin/usuaris');
    final String token = await tokenFuture;
    final int id = await idFuture;

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'userId': id,
          'token': token,
        }),
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

  Future<Map<String, dynamic>> updateUserPlan(
      Future<int> idFuture,
      Future<String> tokenFuture,
      String nickname,
      String plan,
      BuildContext context) async {
    final url = Uri.parse('https://$baseUrl/api/admin/usuaris/pla/actualitzar');

    final String token = await tokenFuture;
    final int id = await idFuture;

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'adminId': id.toString(),
          'token': token,
          'nickname': nickname,
          'pla': plan,
        }),
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else if (response.statusCode == 403) {
        _showSnackBar(context, 'Acceso denegado. No tienes permiso.');
        return {};
      } else if (response.statusCode == 404) {
        _showSnackBar(context, 'Usuario no encontrado.');
        return {};
      } else {
        throw Exception(
            'Error del servidor. Código de estado: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error de conexión o datos inválidos: $e');
    }
  }

  Future<Map<String, dynamic>> showLogs(Future<int> idFuture,
      Future<String> tokenFuture, BuildContext context) async {
    final url = Uri.parse('https://$baseUrl/api/admin/logs');

    final String token = await tokenFuture;
    final int id = await idFuture;

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'userId': id.toString(),
          'token': token,
        }),
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else if (response.statusCode == 403) {
        _showSnackBar(context, 'Acceso denegado. No tienes permiso.');
        return {};
      } else if (response.statusCode == 404) {
        _showSnackBar(context, 'Usuario no encontrado.');
        return {};
      } else {
        throw Exception(
            'Error del servidor. Código de estado: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }
}
