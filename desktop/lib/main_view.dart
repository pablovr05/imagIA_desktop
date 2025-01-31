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
    return LayoutBuilder(
      builder: (context, constraints) {
        bool isSmallScreen = constraints.maxWidth < 800;

        return MaterialApp(
          debugShowCheckedModeBanner: false,
          home: Scaffold(
            backgroundColor: Colors.white,
            body: Row(
              children: [
                if (!isSmallScreen)
                  Container(
                    width: constraints.maxWidth * 0.2,
                    color: Colors.white,
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'ADMIN DASHBOARD',
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w800,
                            fontSize: 28,
                            decoration: TextDecoration.underline,
                            decorationThickness: 2.0,
                          ),
                        ),
                        const SizedBox(height: 150),
                        Expanded(
                          child: ListView(
                            children: const [
                              ListTile(
                                title: Text('Usuarios',
                                    style: TextStyle(color: Colors.black)),
                                tileColor: Colors.white,
                              ),
                            ],
                          ),
                        ),
                        TextButton.icon(
                          onPressed: () {
                            print('Desconectarse');
                          },
                          icon: const Icon(Icons.logout, color: Colors.black),
                          label: const Text('Desconectarse',
                              style: TextStyle(color: Colors.black)),
                        ),
                      ],
                    ),
                  ),
                Expanded(
                  child: Container(
                    color: Colors.black,
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                              vertical: 10.0, horizontal: 32.0),
                          decoration: const BoxDecoration(
                            border: Border(
                                bottom: BorderSide(color: Colors.white70)),
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                  flex: isSmallScreen ? 3 : 5,
                                  child: const Text('Usuario',
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold))),
                              const Expanded(
                                  flex: 1,
                                  child: Text('Teléfono  ',
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold))),
                              if (!isSmallScreen)
                                const Expanded(
                                    flex: 3,
                                    child: Text('   Creado en',
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold))),
                              if (!isSmallScreen)
                                const Expanded(
                                    flex: 3,
                                    child: Text(' Actualizado en',
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold))),
                              Expanded(
                                  flex: isSmallScreen ? 2 : 1,
                                  child: const Text('   Rol',
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold))),
                            ],
                          ),
                        ),
                        Expanded(
                          child: users.isEmpty
                              ? const Center(child: CircularProgressIndicator())
                              : SingleChildScrollView(
                                  child: Column(
                                    children: users
                                        .map((user) => CustomListItem(
                                            user: user,
                                            isSmallScreen: isSmallScreen))
                                        .toList(),
                                  ),
                                ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class CustomListItem extends StatelessWidget {
  final dynamic user;
  final bool isSmallScreen;
  const CustomListItem(
      {required this.user, required this.isSmallScreen, super.key});

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
        children: [
          Expanded(
              flex: isSmallScreen ? 3 : 5,
              child: Text(user['nickname'] ?? 'N/A',
                  style: const TextStyle(color: Colors.white))),
          Expanded(
              flex: 1,
              child: Text(user['phone'] ?? 'N/A',
                  style: const TextStyle(color: Colors.white))),
          if (!isSmallScreen)
            Expanded(
                flex: 3,
                child: Text(user['created_at'] ?? 'N/A',
                    style: const TextStyle(color: Colors.white))),
          if (!isSmallScreen)
            Expanded(
                flex: 3,
                child: Text(user['updated_at'] ?? 'N/A',
                    style: const TextStyle(color: Colors.white))),
          DropdownButton<String>(
            dropdownColor: Colors.black,
            value: user['type_id'],
            items: ['ADMINISTRADOR', 'FREE', 'PREMIUM']
                .map((String type) => DropdownMenuItem(
                    value: type,
                    child: Text(type,
                        style: const TextStyle(color: Colors.white))))
                .toList(),
            onChanged: (String? newValue) {
              print('Se ha cambiado a $newValue');
            },
          ),
        ],
      ),
    );
  }
}

// Cargar datos del archivo JSON
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
