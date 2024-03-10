import 'package:flutter/material.dart';

import 'package:jarvis/screens/homepage.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
        title: 'Jarvis', debugShowCheckedModeBanner: false, home: HomePage());
  }
}
