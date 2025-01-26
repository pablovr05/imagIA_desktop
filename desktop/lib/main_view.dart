import 'package:flutter/material.dart';

class main_view extends StatelessWidget {
  const main_view({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Colors.black,
        body: Center(
          child: Center(
            child: Text(
              "Hola!",
              style: TextStyle(fontSize: 38, color: Colors.white),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
    );
  }
}
