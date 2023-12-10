import 'package:flutter/material.dart';
import 'package:flutter_animation_course/examples/example1.dart';
import 'package:flutter_animation_course/examples/example2.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const RotatingYAxisRectAnimation(),
    );
  }
}
