import 'dart:convert';
import 'dart:io';

import 'api_service.dart';
import 'package:flutter/material.dart';
import 'main_view.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _serverController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadDataFromFile();
  }

  // Cargar datos del archivo JSON si existe
  Future<void> _loadDataFromFile() async {
    try {
      const path = './data/';
      final file = File('$path/data.json');

      if (file.existsSync()) {
        final String content = await file.readAsString();
        final Map<String, dynamic> data = jsonDecode(content);

        if (data.containsKey('ServerKey') && data.containsKey('UsernameKey')) {
          _serverController.text = data['ServerKey'];
          _usernameController.text = data['UsernameKey'];
        }
      }
    } catch (e) {
      print('Error al cargar los datos: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double containerWidth =
        screenWidth >= 800 ? screenWidth * 0.3 : screenWidth * 0.8;
    double buttonWidth =
        screenWidth >= 800 ? screenWidth * 0.1 : screenWidth * 0.3;

    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: SizedBox(
            width: containerWidth,
            child: Column(
              children: [
                const SizedBox(height: 30),
                SizedBox(
                    width: double.infinity,
                    height: MediaQuery.of(context).size.height / 3,
                    child: Image.asset('assets/images/flutter.png')),
                Expanded(
                  child: Container(
                    width: double.infinity,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(30),
                        topRight: Radius.circular(30),
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Server',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 10),
                            Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                color: Colors.black,
                              ),
                              child: TextField(
                                controller: _serverController,
                                style: const TextStyle(color: Colors.white),
                                decoration: const InputDecoration(
                                  border: InputBorder.none,
                                  prefixIcon: Icon(
                                    Icons.cloud,
                                    color: Colors.white,
                                  ),
                                  hintText: 'Server',
                                  hintStyle: TextStyle(color: Colors.white),
                                ),
                              ),
                            ),
                            const SizedBox(height: 15),
                            const Text(
                              'Username',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 10),
                            Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                color: Colors.black,
                              ),
                              child: TextField(
                                controller: _usernameController,
                                style: const TextStyle(color: Colors.white),
                                decoration: const InputDecoration(
                                  border: InputBorder.none,
                                  prefixIcon: Icon(
                                    Icons.person,
                                    color: Colors.white,
                                  ),
                                  hintText: 'Username',
                                  hintStyle: TextStyle(color: Colors.white),
                                ),
                              ),
                            ),
                            const SizedBox(height: 15),
                            const Text(
                              'Password',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 10),
                            Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                color: Colors.black,
                              ),
                              child: TextField(
                                controller: _passwordController,
                                obscureText: true,
                                style: const TextStyle(color: Colors.white),
                                decoration: const InputDecoration(
                                  border: InputBorder.none,
                                  prefixIcon: Icon(
                                    Icons.lock,
                                    color: Colors.white,
                                  ),
                                  hintText: 'Password',
                                  hintStyle: TextStyle(color: Colors.white),
                                ),
                              ),
                            ),
                            const SizedBox(height: 35),
                            Center(
                              child: GestureDetector(
                                onTap: () async {
                                  // Validar los campos
                                  if (_serverController.text.isEmpty ||
                                      _usernameController.text.isEmpty ||
                                      _passwordController.text.isEmpty) {
                                    // Mostrar un mensaje de error si algún campo está vacío
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text(
                                          'Todos los campos son obligatorios.',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.w700),
                                          textAlign: TextAlign.center,
                                        ),
                                        backgroundColor: Colors.red,
                                      ),
                                    );
                                    return;
                                  }

                                  // Enviar el login para verificar
                                  try {
                                    final ApiService apiService = ApiService(
                                        baseUrl: _serverController.text.trim());

                                    // Llamar al método login
                                    final response = await apiService.login(
                                      _usernameController.text.trim(),
                                      _passwordController.text.trim(),
                                      context, // Pasar el contexto al método
                                    );

                                    // Si la respuesta no es vacía, significa éxito
                                    if (response.isNotEmpty) {
                                      await saveInDocument(
                                        'ServerKey',
                                        'UsernameKey',
                                        _serverController.text,
                                        _usernameController.text,
                                      );
                                      // Navegar a la siguiente vista
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                const MainView()),
                                      );
                                    }
                                  } catch (e) {
                                    // Mostrar un mensaje de error en caso de que falle la conexión
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text(
                                          'Error al conectar con el servidor',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.w700),
                                          textAlign: TextAlign.center,
                                        ),
                                        backgroundColor: Colors.red,
                                      ),
                                    );
                                    print(e);
                                  }
                                },
                                child: Container(
                                  width: buttonWidth,
                                  height: 40,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(40),
                                    color: Colors.black,
                                  ),
                                  child: const Center(
                                    child: Text(
                                      'Log In',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 18,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

Future<void> saveInDocument(String serverKey, String usernameKey, String server,
    String username) async {
  try {
    const path = './data/';
    final directory = Directory(path);

    // Crear la carpeta si no existe
    if (!directory.existsSync()) {
      await directory.create(recursive: true);
    }

    final file = File('${directory.path}/data.json');

    // Crear el archivo si no existe
    if (!file.existsSync()) {
      await file.create();
    }

    // Datos a guardar
    final Map<String, String> data = {
      serverKey: server,
      usernameKey: username,
    };

    // Guardar los datos en formato JSON
    await file.writeAsString(jsonEncode(data));
    print("Datos guardados correctamente.");
  } catch (e) {
    print('Error al guardar los datos: $e');
  }
}
