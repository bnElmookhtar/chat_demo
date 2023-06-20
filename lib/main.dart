import 'package:flutter/material.dart';
import 'package:goat/pages/welcome_page.dart';

void main() {
  runApp(const GoatMessanger());
}

class GoatMessanger extends StatelessWidget {
  const GoatMessanger({super.key});
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.from(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
      ),
      home: const WelcomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}
