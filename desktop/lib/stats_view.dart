import 'dart:convert';
import 'dart:io';
import 'dart:ui' as ui;

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
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          "Estadísticas de Uso",
                          style: TextStyle(color: Colors.white, fontSize: 20),
                        ),
                        const SizedBox(height: 20),
                        BarChartWidget(),
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

class BarChartPainter extends CustomPainter {
  final Map<String, int> data;
  final double barHeight = 30.0;
  final double spacing = 15.0;

  BarChartPainter({required this.data});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.blue
      ..style = PaintingStyle.fill;

    final textStyle = TextStyle(color: Colors.white, fontSize: 14);
    final maxValue = data.values.isNotEmpty
        ? data.values.reduce((a, b) => a > b ? a : b)
        : 1;
    final barWidthFactor = (size.width * 0.7) / maxValue;

    double yOffset = 0.0;
    double labelWidth = size.width * 0.22;

    for (var entry in data.entries) {
      final key = entry.key;
      final value = entry.value;

      final barWidth = value * barWidthFactor;
      final rect = Rect.fromLTWH(labelWidth, yOffset, barWidth, barHeight);
      canvas.drawRect(rect, paint);

      // Dibujar la etiqueta (izquierda)
      final keyTextPainter = TextPainter(
        text: TextSpan(text: key, style: textStyle),
        textAlign: TextAlign.right,
        textDirection: ui.TextDirection.rtl,
      );
      keyTextPainter.layout();
      keyTextPainter.paint(
          canvas, Offset(0, yOffset + (barHeight - keyTextPainter.height) / 2));

      // Dibujar el valor (sobre la barra)
      final valueTextPainter = TextPainter(
        text: TextSpan(text: value.toString(), style: textStyle),
        textAlign: TextAlign.left,
        textDirection: ui.TextDirection.ltr,
      );
      valueTextPainter.layout();
      valueTextPainter.paint(
          canvas,
          Offset(labelWidth + barWidth + 5,
              yOffset + (barHeight - valueTextPainter.height) / 2));

      yOffset += barHeight + spacing;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

class BarChartWidget extends StatelessWidget {
  final Map<String, int> data = {
    'BASE DE DATOS': 12,
    'SERVER': 15,
    'PROMPT': 10,
    'ADMIN': 20,
    'MODELS': 8,
    'VALIDATE': 6,
    'REGISTER': 14,
    'LOGIN': 18,
    'SMS': 9,
    'QUOTE': 0,
  };

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: ui.TextDirection.ltr,
      child: Center(
        child: CustomPaint(
          size: Size(MediaQuery.of(context).size.width * 0.8, 400),
          painter: BarChartPainter(data: data),
        ),
      ),
    );
  }
}
