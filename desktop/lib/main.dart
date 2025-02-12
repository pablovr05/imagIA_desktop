import 'package:desktop/login_view.dart';

import 'package:flutter/material.dart';
import 'package:window_manager/window_manager.dart';
//import 'main_view.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Inicializar el gestor de ventanas
  await windowManager.ensureInitialized();

  // Configurar propiedades iniciales de la ventana
  WindowOptions windowOptions = const WindowOptions(
    title: 'ImagIA',
    size: Size(600, 800),
    minimumSize: Size(600, 800),
  );

  windowManager.waitUntilReadyToShow(windowOptions, () async {
    await windowManager.show();
    await windowManager.focus();
  });

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: LoginScreen());
    //return const Scaffold(body: MainView());
  }
}
