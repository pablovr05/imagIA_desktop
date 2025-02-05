import 'dart:convert';
import 'dart:io';
import 'package:desktop/login_view.dart';
import 'package:flutter/material.dart';
import 'api_service.dart';
import 'package:intl/intl.dart';

class MainView extends StatefulWidget {
  const MainView({super.key});

  @override
  _MainViewState createState() => _MainViewState();
}

class _MainViewState extends State<MainView> {
  List<dynamic> users = [];
  static String baseUrl = '';

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

  void updateUserType(int index, String newType) {
    setState(() {
      users[index]['type_id'] = newType;
    });
    print('Usuario ${users[index]['nickname']} ha cambiado a $newType');
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
            appBar: isSmallScreen
                ? AppBar(
                    backgroundColor: Colors.black,
                    title: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'ADMIN DASHBOARD',
                          style: TextStyle(color: Colors.white),
                        ),
                        ElevatedButton(
                          onPressed: fetchUsers,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            padding: const EdgeInsets.all(8),
                            shape: const CircleBorder(),
                          ),
                          child: const Icon(Icons.refresh, color: Colors.black),
                        ),
                      ],
                    ),
                    leading: Builder(
                      builder: (context) => IconButton(
                        icon: const Icon(Icons.menu, color: Colors.white),
                        onPressed: () => Scaffold.of(context).openDrawer(),
                      ),
                    ),
                  )
                : null,
            drawer: isSmallScreen
                ? Drawer(
                    child: ListView(
                    padding: EdgeInsets.zero,
                    children: [
                      const DrawerHeader(
                        decoration: BoxDecoration(color: Colors.black),
                        child: Text(
                          'ADMIN DASHBOARD',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 24,
                          ),
                        ),
                      ),
                      ListTile(
                        title: const Text('Usuarios'),
                        onTap: () {},
                      ),
                      const SizedBox(height: 490),
                      ListTile(
                        leading: const Icon(Icons.logout, color: Colors.black),
                        title: const Text('Desconectarse'),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const LoginScreen()),
                          );
                        },
                      ),
                    ],
                  ))
                : null,
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
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const LoginScreen()),
                            );
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
                        if (!isSmallScreen)
                          // Botón de Recarga
                          Container(
                              alignment: Alignment.centerRight,
                              padding: const EdgeInsets.symmetric(
                                  vertical: 10, horizontal: 16),
                              child: ElevatedButton(
                                onPressed: fetchUsers,
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.white),
                                child: const Icon(Icons.refresh,
                                    color: Colors.black),
                              )),
                        Container(
                            padding: const EdgeInsets.symmetric(
                                vertical: 10.0, horizontal: 32.0),
                            decoration: const BoxDecoration(
                              border: Border(
                                  bottom: BorderSide(color: Colors.white70)),
                            ),
                            child: Row(children: [
                              Expanded(
                                  flex: isSmallScreen ? 3 : 5,
                                  child: const Text('Usuario',
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold))),
                              Expanded(
                                  flex: 3,
                                  child: isSmallScreen
                                      ? const Text('Teléfono',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold))
                                      : const Text(
                                          '                                Teléfono',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold))),
                              if (!isSmallScreen)
                                const Expanded(
                                    flex: 4,
                                    child: Text('Creado en',
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold))),
                              if (!isSmallScreen)
                                const Expanded(
                                    flex: 4,
                                    child: Text('Actualizado en',
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold))),
                              Expanded(
                                  flex: isSmallScreen ? 2 : 2,
                                  child: const Text('Rol',
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold))),
                            ])),
                        Expanded(
                          child: users.isEmpty
                              ? const Center(child: CircularProgressIndicator())
                              : SingleChildScrollView(
                                  child: Column(
                                    children:
                                        users.asMap().entries.map((entry) {
                                      return FutureBuilder<String>(
                                        future: _loadURL(),
                                        builder: (context, snapshot) {
                                          if (snapshot.connectionState ==
                                              ConnectionState.waiting) {
                                            return const CircularProgressIndicator();
                                          }
                                          if (snapshot.hasError ||
                                              !snapshot.hasData ||
                                              snapshot.data!.isEmpty) {
                                            return const Text(
                                                'Error al cargar la URL del servidor');
                                          }

                                          return CustomListItem(
                                            user: entry.value,
                                            isSmallScreen: isSmallScreen,
                                            onUserTypeChange: (newType) =>
                                                updateUserType(
                                                    entry.key, newType),
                                            apiService: ApiService(
                                                baseUrl: snapshot.data!),
                                          );
                                        },
                                      );
                                    }).toList(),
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
            onChanged: (String? newValue) async {
              if (newValue != null && newValue != user['type_id']) {
                try {
                  // Obtener adminId y token
                  int adminId = await ApiService.getUserId();
                  String token = await ApiService.getAuthToken();

                  // Llamar a la API para actualizar el plan del usuario
                  await apiService.updateUserPlan(
                    Future.value(adminId),
                    Future.value(token),
                    user['nickname'],
                    newValue,
                    context,
                  );

                  _showSnackBarPositive(
                      context, 'Se ha cambiado el rol exitosamente.');

                  // Notificar el cambio
                  onUserTypeChange(newValue);
                } catch (e) {
                  _showSnackBar(context,
                      'No puedes cambiar el rol de un Administrador debido a permisos insuficientes.');
                  print('Error al actualizar el tipo de usuario: $e');
                }
              }
            },
          ),
        ],
      ),
    );
  }
}

// Cargar datos del archivo JSON
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

void _showSnackBarPositive(BuildContext context, String message) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(
        message,
        style:
            const TextStyle(color: Colors.white, fontWeight: FontWeight.w700),
        textAlign: TextAlign.center,
      ),
      backgroundColor: Colors.green,
    ),
  );
}
