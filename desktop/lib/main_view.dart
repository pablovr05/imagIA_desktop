import 'dart:convert';
import 'dart:io';
import 'package:desktop/login_view.dart';
import 'package:desktop/logs_view.dart';
import 'package:flutter/material.dart';
import 'api_service.dart';
import 'package:intl/intl.dart';

import 'stats_view.dart';

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
      final fetchedUsers =
          await apiService.getAllUsers(getAdminId(), getToken(), context);
      setState(() {
        users = (fetchedUsers['data']['users'] as List<dynamic>?)?.map((user) {
              return {
                "phone": user["phone"] ?? "N/A",
                "nickname": user["nickname"] ?? "N/A",
                "email": user["email"] ?? "N/A",
                "type_id": user["type_id"] ?? "FREE",
                "quote": user["remainingQuote"] ?? "N/A",
              };
            }).toList() ??
            [];
      });
    } catch (e) {
      print('Error fetching users: $e');
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
                          style: TextStyle(color: Colors.white, fontSize: 20),
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
                        leading: const Icon(Icons.people),
                        title: const Text('Usuarios'),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const MainView()),
                          );
                        },
                      ),
                      ListTile(
                        leading: const Icon(Icons.history),
                        title: const Text('Historial'),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const LogView()),
                          );
                        },
                      ),
                      ListTile(
                        leading: const Icon(Icons.bar_chart),
                        title: const Text('Estadísticas'),
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const StatView(),
                              ));
                        },
                      ),
                      const SizedBox(height: 400),
                      ListTile(
                        leading: const Icon(Icons.logout, color: Colors.black),
                        title: const Text('Cerrar Sesión'),
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
                            children: [
                              ListTile(
                                leading: const Icon(Icons.people),
                                title: const Text('Usuarios',
                                    style: TextStyle(color: Colors.black)),
                                tileColor: Colors.white,
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => const MainView()),
                                  );
                                },
                              ),
                              ListTile(
                                leading: const Icon(Icons.history),
                                title: const Text('Historial',
                                    style: TextStyle(color: Colors.black)),
                                tileColor: Colors.white,
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => const LogView()),
                                  );
                                },
                              ),
                              ListTile(
                                leading: const Icon(Icons.bar_chart),
                                title: const Text('Estadísticas',
                                    style: TextStyle(color: Colors.black)),
                                tileColor: Colors.white,
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => const StatView(),
                                      ));
                                },
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
                          label: const Text('Cerrar Sesión',
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
                                  flex: isSmallScreen ? 3 : 5,
                                  child: isSmallScreen
                                      ? const Text('Teléfono',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold))
                                      : const Text('Teléfono',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold))),
                              if (!isSmallScreen)
                                const Expanded(
                                    flex: 4,
                                    child: Text('Cuota',
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold))),
                              Expanded(
                                  flex: isSmallScreen ? 2 : 1,
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
                                            fetchUsers: fetchUsers,
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
  final Function fetchUsers;

  const CustomListItem({
    required this.user,
    required this.isSmallScreen,
    required this.onUserTypeChange,
    required this.apiService,
    required this.fetchUsers,
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
            flex: 3,
            child: Text(user['nickname'] ?? 'N/A',
                style: const TextStyle(color: Colors.white)),
          ),
          Expanded(
            flex: isSmallScreen ? 3 : 3,
            child: Text(user['phone'] ?? 'N/A',
                style: const TextStyle(color: Colors.white)),
          ),
          if (!isSmallScreen)
            Expanded(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    user['quote'] ?? 'N/A',
                    style: const TextStyle(color: Colors.white),
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(
                      width: 8), // Espacio pequeño entre texto e ícono
                  IconButton(
                    icon: const Icon(Icons.edit, color: Colors.white),
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          TextEditingController quoteController =
                              TextEditingController(
                                  text: user['remainingQuote']);
                          return AlertDialog(
                            title: const Text("Editar Cuota"),
                            content: TextField(
                              controller: quoteController,
                              decoration: const InputDecoration(
                                  hintText: "Ingrese la nueva cuota"),
                            ),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.of(context).pop(),
                                child: const Text("Cancelar"),
                              ),
                              TextButton(
                                onPressed: () async {
                                  try {
                                    Navigator.of(context).pop();
                                    onUserQuoteChange(quoteController.text,
                                        context, fetchUsers);
                                  } catch (e) {
                                    _showSnackBar(context,
                                        "Error al actualizar la cuota.");
                                  }
                                },
                                child: const Text("Guardar"),
                              ),
                            ],
                          );
                        },
                      );
                    },
                  ),
                ],
              ),
            ),
          const Spacer(),
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
                  int adminId = await ApiService.getUserId();
                  String token = await ApiService.getAuthToken();
                  await apiService.updateUserPlan(
                    Future.value(adminId),
                    Future.value(token),
                    user['nickname'],
                    newValue,
                    context,
                  );
                  _showSnackBarPositive(
                      context, 'Se ha cambiado el rol exitosamente.');
                  onUserTypeChange(newValue);
                } catch (e) {
                  _showSnackBar(context,
                      'No puedes cambiar el rol de un Administrador debido a permisos insuficientes.');
                }
              }
            },
          ),
        ],
      ),
    );
  }

  void _showSnackBarPositive(BuildContext context, String message) {
    final scaffoldMessenger = ScaffoldMessenger.of(context);
    scaffoldMessenger.showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.green),
    );
  }

  Future<void> onUserQuoteChange(
      String text, BuildContext context, Function fetchUsers) async {
    final scaffoldMessenger = ScaffoldMessenger.of(context);

    try {
      int adminId = await ApiService.getUserId();
      String token = await ApiService.getAuthToken();

      await apiService.updateUserQuote(
        Future.value(adminId),
        Future.value(token),
        Future.value(user['nickname']),
        Future.value(text),
        context,
      );

      scaffoldMessenger.showSnackBar(
        const SnackBar(
            content: Text("Cuota actualizada exitosamente"),
            backgroundColor: Colors.green),
      );

      // Llamar a fetchUsers para actualizar la lista
      fetchUsers();
    } catch (e) {
      scaffoldMessenger.showSnackBar(
        const SnackBar(
            content: Text("Error al actualizar la cuota"),
            backgroundColor: Colors.red),
      );
    }
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
