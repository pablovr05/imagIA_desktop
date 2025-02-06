import 'dart:convert';
import 'dart:io';

import 'package:desktop/login_view.dart';
import 'package:desktop/logs_view.dart';
import 'package:desktop/main_view.dart';
import 'package:flutter/material.dart';
import 'api_service.dart';
import 'package:intl/intl.dart';

class StatView extends StatefulWidget {
  const StatView({super.key});

  @override
  _MainViewState createState() => _MainViewState();
}

class _MainViewState extends State<StatView> {
  List<dynamic> logsList = [];
  static String baseUrl = '';

  @override
  void initState() {
    super.initState();
    fetchLogs();
  }

  Future<void> fetchLogs() async {
    try {
      String baseUrl = await _loadURL();
      if (baseUrl.isEmpty) {
        print('Error: No se pudo cargar la URL del servidor.');
        return;
      }

      ApiService apiService = ApiService(baseUrl: baseUrl);
      final fetchedLogs =
          await apiService.showLogs(getAdminId(), getToken(), context);

      // Acceso correcto a los logs
      setState(() {
        logsList = (fetchedLogs["data"]["all_logs"]["logs"] as List<dynamic>?)
                ?.map((log) {
              return {
                "type": log["type"] ?? "N/A",
                "category": log["category"] ?? "N/A",
                "prompt": log["prompt"] ?? "N/A",
                "created_at": log["created_at"] ?? "N/A",
              };
            }).toList() ??
            [];
      });
    } catch (e) {
      print("Error fetching logs: $e");
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
            backgroundColor: Colors.black,
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
                          onPressed: fetchLogs,
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
                                builder: (context) => const StatView()),
                          );
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
                                        builder: (context) => const StatView()),
                                  );
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
                const Expanded(
                  child: Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Column(
                      children: [],
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
