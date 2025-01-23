import 'package:flutter/material.dart';
import 'login_view.dart';
import 'package:desktop_window/desktop_window.dart';

void main() {
  runApp(const MyApp());
  DesktopWindow.setWindowSize(const Size(600, 800));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Screen Size Specific Views',
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
  void initState() {
    super.initState();
    print("INICIALIZACIÓN");
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: LoginView());
  }
}
