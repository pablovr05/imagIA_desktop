import 'dart:convert';
import 'dart:io';
import 'package:desktop/api_service.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class UserManagementScreen extends StatefulWidget {
  @override
  _UserManagementScreenState createState() => _UserManagementScreenState();
}

class _UserManagementScreenState extends State<UserManagementScreen> {
  List<dynamic> users = [];
  static String baseUrl = '';
  bool isSmallScreen = false;

  @override
  void initState() {
    super.initState();
    fetchUsers();
  }

  Future<void> fetchUsers() async {
    try {
      String baseUrl = await _loadURL();
      if (baseUrl.isEmpty) {
        print('Error: No se pudo cargar la URL del servidor.');
        return;
      }

      ApiService apiService = ApiService(baseUrl: baseUrl);
      final fetchedUsers =
          await apiService.getAllUsers(getAdminId(), getToken(), context);
      setState(() {
        users = (fetchedUsers['data']['users'] as List<dynamic>?)?.map((user) {
              return {
                "phone": user["phone"] ?? "N/A",
                "nickname": user["nickname"] ?? "N/A",
                "email": user["email"] ?? "N/A",
                "type_id": user["type_id"] ?? "FREE",
                "created_at": _formatDate(user["created_at"]),
                "updated_at": _formatDate(user["updated_at"]),
              };
            }).toList() ??
            [];
      });
    } catch (e) {
      print('Error fetching users: $e');
    }
  }

  String _formatDate(String? date) {
    if (date == null || date.isEmpty) return "N/A";
    try {
      DateTime parsedDate = DateTime.parse(date);
      return DateFormat('yyyy-MM-dd HH:mm').format(parsedDate);
    } catch (e) {
      return "N/A";
    }
  }

  Future<String> _loadURL() async {
    try {
      const path = './data/';
      final file = File('$path/data.json');

      if (file.existsSync()) {
        final String content = await file.readAsString();
        final Map<String, dynamic> data = jsonDecode(content);

        if (data.containsKey('ServerKey')) {
          return data['ServerKey'];
        }
      }
    } catch (e) {
      print('Error al cargar los datos: $e');
    }
    return '';
  }

  Future<String> getToken() async {
    return await ApiService.getAuthToken();
  }

  Future<int> getAdminId() async {
    return await ApiService.getUserId();
  }

  void updateUserType(int index, String newType) {
    setState(() {
      users[index]['type_id'] = newType;
    });
    print('Usuario ${users[index]['nickname']} ha cambiado a $newType');
  }

  @override
  Widget build(BuildContext context) {
    isSmallScreen = MediaQuery.of(context).size.width < 600;

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          if (!isSmallScreen)
            Container(
              alignment: Alignment.centerRight,
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
              child: ElevatedButton(
                onPressed: fetchUsers,
                style: ElevatedButton.styleFrom(backgroundColor: Colors.white),
                child: const Icon(Icons.refresh, color: Colors.black),
              ),
            ),
          Expanded(
            child: users.isEmpty
                ? const Center(child: CircularProgressIndicator())
                : SingleChildScrollView(
                    child: Column(
                      children: users.asMap().entries.map((entry) {
                        return CustomListItem(
                          user: entry.value,
                          isSmallScreen: isSmallScreen,
                          onUserTypeChange: (newType) =>
                              updateUserType(entry.key, newType),
                          apiService: ApiService(baseUrl: baseUrl),
                        );
                      }).toList(),
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}

class CustomListItem extends StatelessWidget {
  final dynamic user;
  final bool isSmallScreen;
  final Function(String newType) onUserTypeChange;
  final ApiService apiService;

  const CustomListItem({
    required this.user,
    required this.isSmallScreen,
    required this.onUserTypeChange,
    required this.apiService,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 65, 65, 65),
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Row(
        children: [
          Expanded(
            flex: isSmallScreen ? 3 : 5,
            child: Text(user['nickname'] ?? 'N/A',
                style: const TextStyle(color: Colors.white)),
          ),
          DropdownButton<String>(
            dropdownColor: Colors.black,
            value: user['type_id'],
            items: ['ADMINISTRADOR', 'FREE', 'PREMIUM']
                .map((String type) => DropdownMenuItem(
                      value: type,
                      child: Text(type,
                          style: const TextStyle(color: Colors.white)),
                    ))
                .toList(),
            onChanged: (String? newValue) {
              if (newValue != null && newValue != user['type_id']) {
                onUserTypeChange(newValue);
              }
            },
          ),
        ],
      ),
    );
  }
}
