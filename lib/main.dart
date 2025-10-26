import 'package:flutter/material.dart';
import 'screens/auth_screen.dart';

void main() {
  runApp(const LinkUpApp());
}

class LinkUpApp extends StatelessWidget {
  const LinkUpApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'LinkUp',
      theme: ThemeData.dark(),
      home: const AuthScreen(),
    );
  }
}
