import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'api_service.dart';

class MainView extends StatefulWidget {
  const MainView({super.key});

  @override
  _MainViewState createState() => _MainViewState();
}

class _MainViewState extends State<MainView> {
  List<dynamic> users = [];

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
      final fetchedUsers = await apiService.getAllUsers(context);
      setState(() {
        users = (fetchedUsers['data']['users'] as List<dynamic>?)?.map((user) {
              return {
                "phone": user["phone"] ?? "N/A",
                "nickname": user["nickname"] ?? "N/A",
                "email": user["email"] ?? "N/A",
                "type_id": user["type_id"] ?? "FREE",
                "created_at": user["created_at"] ?? "yyyy-mm-dd HH:MM:SS",
                "updated_at": user["updated_at"] ?? "yyyy-mm-dd HH:MM:SS",
              };
            }).toList() ??
            [];
      });
    } catch (e) {
      print('Error fetching users: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Colors.white,
        body: Padding(
          padding: const EdgeInsets.only(top: 40.0),
          child: Center(
            child: Container(
              width: MediaQuery.of(context).size.width * 0.9,
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(16.0),
              ),
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  const Text(
                    'Lista de Usuarios',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold),
                  ),
                  Expanded(
                    child: users.isEmpty
                        ? const Center(child: CircularProgressIndicator())
                        : ListView.builder(
                            itemCount: users.length,
                            itemBuilder: (context, index) {
                              return CustomListItem(user: users[index]);
                            },
                          ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class CustomListItem extends StatefulWidget {
  final dynamic user;
  const CustomListItem({required this.user, super.key});

  @override
  _CustomListItemState createState() => _CustomListItemState();
}

class _CustomListItemState extends State<CustomListItem> {
  late String selectedType;

  @override
  void initState() {
    super.initState();
    selectedType =
        widget.user['type_id'] ?? 'FREE'; // Asegúrate de usar 'type_id'
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 16.0),
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 65, 65, 65),
        borderRadius: BorderRadius.circular(12.0),
        boxShadow: const [
          BoxShadow(
            color: Colors.white,
            blurRadius: 10.0,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Text(widget.user['nickname'] ?? 'N/A',
              style: const TextStyle(color: Colors.white)),
          Text(widget.user['phone'] ?? 'N/A',
              style: const TextStyle(color: Colors.white)),
          Text(widget.user['created_at'] ?? 'N/A',
              style: const TextStyle(color: Colors.white)),
          Text(widget.user['updated_at'] ?? 'N/A',
              style: const TextStyle(color: Colors.white)),
          DropdownButton<String>(
            dropdownColor: Colors.black,
            value: selectedType,
            items: ['ADMINISTRADOR', 'FREE', 'PREMIUM']
                .map((String type) => DropdownMenuItem(
                      value: type,
                      child: Text(type,
                          style: const TextStyle(color: Colors.white)),
                    ))
                .toList(),
            onChanged: (String? newValue) {
              setState(() {
                selectedType = newValue!;
              });
              print('Se ha cambiado a $newValue');
            },
          ),
        ],
      ),
    );
  }
}

// Cargar datos del archivo JSON si existe
Future<dynamic> _loadURL() async {
  try {
    const path = './data/';
    final file = File('$path/data.json');

    if (file.existsSync()) {
      final String content = await file.readAsString();
      final Map<String, dynamic> data = jsonDecode(content);

      if (data.containsKey('ServerKey')) {
        print(data['serverKey']);
        return data['ServerKey'];
      }
    }
  } catch (e) {
    print('Error al cargar los datos: $e');
  }
  return '';
}
