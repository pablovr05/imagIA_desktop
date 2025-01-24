import 'package:flutter/material.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _LoginView createState() => _LoginView();
}

class _LoginView extends State<LoginView> {
  @override
  Widget build(BuildContext context) {
    const Color color1 = Color.fromARGB(255, 82, 78, 78);
    const Color color2 = Color.fromARGB(255, 255, 43, 115);
    const Color color3 = Color.fromARGB(255, 255, 90, 106);
    const Color color4 = Color.fromARGB(255, 255, 149, 98);
    const Color color5 = Color.fromARGB(255, 255, 205, 55);

    return MaterialApp(
        home: Scaffold(
            appBar: AppBar(
      title: const Text(
        'LoginView',
        style: TextStyle(
            color: Colors.white,
            fontFamily: "Calibri",
            fontSize: 32,
            fontWeight: FontWeight.bold),
      ),
      centerTitle: true,
      backgroundColor: color1,
    )));
  }
}
