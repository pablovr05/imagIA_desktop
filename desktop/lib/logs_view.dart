import 'dart:convert';
import 'dart:io';

import 'package:desktop/login_view.dart';
import 'package:desktop/main_view.dart';
import 'package:flutter/material.dart';
import 'api_service.dart';
import 'package:intl/intl.dart';

import 'stats_view.dart';

class LogView extends StatefulWidget {
  const LogView({super.key});

  @override
  _MainViewState createState() => _MainViewState();
}

class _MainViewState extends State<LogView> {
  List<dynamic> logsList = [];

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
                "created_at": _formatDate(log["created_at"]),
              };
            }).toList() ??
            [];
      });
    } catch (e) {
      print("Error fetching logs: $e");
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
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        Container(
                          padding: EdgeInsets.symmetric(
                              vertical: 10.0,
                              horizontal: isSmallScreen ? 25.0 : 65.0),
                          decoration: const BoxDecoration(
                            border:
                                Border(bottom: BorderSide(color: Colors.white)),
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                  flex: 0,
                                  child: isSmallScreen
                                      ? const Text('Tipo ',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white))
                                      : const Text('Tipo            ',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white))),
                              Expanded(
                                  flex: isSmallScreen ? 2 : 1,
                                  child: isSmallScreen
                                      ? const Text('Categoría',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white))
                                      : const Text('Categoría           ',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white))),
                              Expanded(
                                  flex: 5,
                                  child: isSmallScreen
                                      ? const Text('Mensaje',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white))
                                      : const Text(
                                          '                      Mensaje',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white))),
                              Expanded(
                                  flex: 1,
                                  child: isSmallScreen
                                      ? const Text('Fecha',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white))
                                      : const Text(
                                          '                              Fecha',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white))),
                            ],
                          ),
                        ),
                        Expanded(
                          child: logsList.isEmpty
                              ? const Center(child: CircularProgressIndicator())
                              : ListView.builder(
                                  itemCount: logsList.length,
                                  itemBuilder: (context, index) {
                                    final log = logsList[index];
                                    return LogEntryWidget(
                                      type: log['type'] ?? 'INFO',
                                      category: log['category'] ?? 'GENERAL',
                                      message: log['prompt'] ??
                                          'Mensaje no disponible',
                                      date: log['date'] ??
                                          DateFormat('yyyy-MM-dd HH:mm')
                                              .format(DateTime.now()),
                                    );
                                  },
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

class LogEntryWidget extends StatelessWidget {
  final String type;
  final String category;
  final String message;
  final String date;

  const LogEntryWidget({
    required this.type,
    required this.category,
    required this.message,
    required this.date,
    super.key,
  });

  IconData _getIconForType() {
    switch (type) {
      case "DEBUG":
        return Icons.bug_report;
      case "INFO":
        return Icons.info;
      case "WARN":
        return Icons.warning;
      case "ERROR":
        return Icons.error;
      default:
        return Icons.help;
    }
  }

  Color _getColorForType() {
    switch (type) {
      case "DEBUG":
        return Colors.blue;
      case "INFO":
        return Colors.green;
      case "WARN":
        return Colors.orange;
      case "ERROR":
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Row(
        children: [
          Expanded(
              flex: 1,
              child: Icon(_getIconForType(), color: _getColorForType())),
          Expanded(
              flex: 2,
              child: Text(category,
                  style: const TextStyle(fontWeight: FontWeight.bold))),
          Expanded(
              flex: 5, child: Text(message, overflow: TextOverflow.ellipsis)),
          Expanded(flex: 3, child: Text(date, textAlign: TextAlign.end)),
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
