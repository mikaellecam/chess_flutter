import 'package:chess_flutter/pages/home_page.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(ChessApp());
}

class ChessApp extends StatelessWidget {
  const ChessApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Chess Game',
      theme: ThemeData(primarySwatch: Colors.brown, useMaterial3: true),
      home: const HomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}
